//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;
using System.IO;
using NDMicroAsm.Core;

namespace NDMicroAsm.ND1X0
{
    internal class Compiler : IDisposable
    {

        public static readonly int UNDEFINED = Labels.UNDEFINED;
        StreamWriter? listingFileStream;
        StreamWriter? detailsFileStream;
        StreamWriter? symbolFileStream;
        string? binaryFileName;

        TokensBase? ndTokens;


        bool ND120Compiler = false;

        /// <summary>
        /// True while assembling ND-100 micro code. The ND-100 word has a 12-bit branch address
        /// (bit 20 is the timing bit TC0, not an address bit) and its own token table.
        /// </summary>
        bool ND100Compiler = false;

        /// <summary>
        /// Assembles an ND-110 or ND-120 micro code source file to a control store image.
        /// </summary>
        /// <remarks>
        /// Writes NAME.CODE, NAME.LISTING.TXT, NAME.SYMBOLS.TXT and NAME.DETAILS.TXT next to the
        /// source, and a TOKENS.TXT (TOKENS-L.TXT for version L) dump of the token table.
        /// </remarks>
        /// <param name="ucTextFile">
        /// Path of the .uc source file.
        /// </param>
        /// <param name="isND120">
        /// True assembles with the ND-120 token table, false with the ND-110 table.
        /// </param>
        /// <param name="microcodeVersion">
        /// ND-120 only: "K" (default) uses the token table as loaded; "L" applies the post-load
        /// fixup <see cref="ND120Tokens.AdjustTokensForVersionL"/>, where the B,P / B,B / B,X
        /// register-select tokens lose the DLY1 delay bit (the change ND made between micro code
        /// versions K and L).
        /// </param>
        /// <returns>
        /// The assembled image and its source map, or null when the source could not be read or
        /// had errors.
        /// </returns>
        public Target? AssembleFile(string ucTextFile, bool isND120 = false, string microcodeVersion = "K")
        {
            return AssembleFileCore(ucTextFile, isND120, false, microcodeVersion);
        }

        /// <summary>
        /// Assembles an ND-100 micro code source file to a control store image.
        /// </summary>
        /// <remarks>
        /// Uses the ND-100 token table (ND-06.018.01 EN, NORD-100 Microprogramming Description).
        /// Like the ND-110, the assembler inverts bits 22-27 of every word when it writes it
        /// ("bits 22 - 27 are inverted after the word is assembled"), so the .CODE image holds
        /// the words in the form of the PROMs. Writes NAME.CODE, NAME.LISTING.TXT,
        /// NAME.SYMBOLS.TXT and NAME.DETAILS.TXT next to the source, and a TOKENS.TXT dump of the
        /// token table.
        /// </remarks>
        /// <param name="ucTextFile">
        /// Path of the .uc source file.
        /// </param>
        /// <returns>
        /// The assembled image and its source map, or null when the source could not be read or
        /// had errors.
        /// </returns>
        public Target? AssembleFileND100(string ucTextFile)
        {
            return AssembleFileCore(ucTextFile, false, true, "K");
        }

        Target? AssembleFileCore(string ucTextFile, bool isND120, bool isND100, string microcodeVersion)
        {
            ND120Compiler = isND120;
            ND100Compiler = isND100;

            if (!InitializeFiles(ucTextFile))
            {
                LogConsoleMessage("Can't find source file: " + ucTextFile);
                return null;
            }


            var sourceText = File.ReadAllText(ucTextFile);
            LogConsoleMessage($"Reading uCode from {ucTextFile}, {sourceText.Length} characters");

            // now we can initialize tokens

            if (isND100)
            {
                ndTokens = new ND100Tokens();
                ndTokens.InitializeTokens();
            }
            else if (isND120)
            {
                var nd120Tokens = new ND120Tokens();
                nd120Tokens.InitializeTokens();
                if (microcodeVersion == "L")
                {
                    // Post-load fixup: version L differs from K only in the
                    // DLY1 bit of B,P / B,B / B,X (see AdjustTokensForVersionL).
                    nd120Tokens.AdjustTokensForVersionL();
                }
                ndTokens = nd120Tokens;
            }
            else
            {
                ndTokens = new ND110Tokens();
                ndTokens.InitializeTokens();
            }

            // Suffix the dump per version so compiling K and L from the same
            // directory doesn't overwrite one table with the other.
            string strTokensFile = Path.Combine(Path.GetDirectoryName(Path.GetFullPath(ucTextFile))!,
                (isND120 && microcodeVersion == "L") ? "TOKENS-L.TXT" : "TOKENS.TXT");
            ndTokens.DumpAllTokensToFile(strTokensFile);


            var result = AssembleSourceCode(sourceText);

            if ((result == null) || (result.Exe == null))
            {
                LogConsoleMessage("Compile failed!");
            }
            else
            {
                if (binaryFileName != null)
                {
                    LogConsoleMessage($"Writing ROM file, {result.Exe.Length} bytes");
                    File.WriteAllBytes(binaryFileName, result.Exe);

                    //TODO: Write PDB info also?
                }
            }
            CleanupFiles();

            return result;
        }



        public Target? AssembleSourceCode(string uCode)
        {
            Target? result = null;
            int numInstr = 0;
            try
            {
                LogConsoleMessage("Compiling.....");

                result = Assemble(uCode);
                if ((result != null) && (result.Exe != null))
                {
                    numInstr = result.Exe.Length / 8;
                    LogConsoleMessage($"Compiled OK! {Int2Oct(numInstr)} microcode instructions");
                }
                else
                    LogConsoleMessage($"Compiled FAILED spectacular!");

            }
            catch (ND110AsmException asmEx)
            {
                LogConsoleMessage($"Assembler error: {asmEx.Message} at line {asmEx.SourceCodeLine}");
            }
            catch (Exception unknownEx)
            {

                LogConsoleMessage("Unknown exception: " + unknownEx.ToString());
            }

            return result;
        }


        private int currentLine; // global variable - current source code line during compilation


        public SourceMap Preprocess(string sourceCode)
        {
            SourceMap map = new SourceMap();
            int ucAddress = 0;
            int lineNo = 1; // First source code line is #1

            sourceCode = sourceCode.Replace("\r", ""); // Remove Carriage Return
            var all_lines = sourceCode.Split("\n");
            string ucLine = "";
            for (int lineIdx = 0; lineIdx < all_lines.Length; lineIdx++)
            {
                string line = all_lines[lineIdx].Trim();
                string label = "";
                string strAddress = "";

                // Reformat text to make the compiler like it more
                line = line.Replace(" ,", ",");
                line = line.Replace(", ", ",");

                // Remove comment
                int idxComment = line.IndexOf("%");
                if (idxComment >= 0)
                {
                    line = line.Substring(0, idxComment);
                    line.Trim();
                }


                // Check for seting of uC address
                // Remove comment
                int idxSlash = line.IndexOf("/");
                if (idxSlash >= 0)
                {
                    strAddress = line.Substring(0, idxSlash);
                    int adr = ParseIntValue(strAddress);
                    if (adr >= 0)
                    {
                        ucAddress = adr;
                    }
                    line = line.Substring(idxSlash + 1);
                    line.Trim();
                }


                // Check for label
                //
                int idxColon = line.IndexOf(":");
                if ((idxColon >= 0) && (idxColon < 30))
                {
                    label = line.Substring(0, idxColon);
                    label.Trim();
                    line = line.Substring(idxColon + 1);
                    line.Trim();

                    map.Labels.AddLabelAndAddress(label, ucAddress);
                }

                string strline = lineNo.ToString().PadLeft(4, '0');
                string strUcAddr = Convert.ToString(ucAddress, 8).PadLeft(6, '0');
                string strListing = $"{strline}  {strUcAddr}  {all_lines[lineIdx]}";


                LogListing(strListing);

                // Now convert "CONT" label

                // The termination to a macroinstruction is the label CONT:

                // ND-120 Microcode:
                // 145  CONT: B,Z ALUF,ZERO ALUD,B IDBS,ALU COMM,CONTINUE T,JMP T,HOLD

                // This sets the Z register to zero, and executes a COMM.CONTINUE T,JMP which fetches 
                // the next macroinstruction relative to P. This command can be executed elsewhere.

                // Misunderstanding from the doc, nothing special happens during compile - its actual the microcode jumping to label CONT:
                //line = line.Replace(" CONT", "COMM,CONTINUE  T,JMP");  //TODO: SET Z to zero


                // End CONT


                ucLine = ucLine + " " + line;
                // Check if this line is the last line for this uC definition
                if (line.IndexOf(";") > 0)
                {
                    // remove ;
                    ucLine = ucLine.Replace(";", "");

                    // End of this uc instruction
                    map.Instructions.Add(new InstructionInfo() { LineNumber = lineNo, Address = ucAddress, Raw = ucLine });

                    ucAddress++;
                    ucLine = "";
                }
                lineNo++;
            }

            return map;
        }


        Instruction Tokenize(string raw)
        {
            var instr = new Instruction();
            var splitSpace = raw.Split(" ");

            for (int splitIdx = 0; splitIdx < splitSpace.Length; splitIdx++)
            {
                var splitTrimmed = splitSpace[splitIdx].Trim();
                if (splitTrimmed.Length > 0)
                {
                    instr.Args.Add(splitTrimmed);
                }
            }
            return instr;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="instruction"></param>
        /// <param name="labels"></param>
        /// <returns></returns>
        public ulong Translate(Instruction instruction, Labels labels)
        {
            if (ndTokens == null) return 0;

            LogDetailCompile($"ucode: {Int2Oct(instruction.Address)}");

            // ND-120: emit exact 64-bit micro word (EPROM / golden ROM), bypassing token OR.
            if (ND120Compiler && instruction.Args.Count >= 2 &&
                string.Equals(instruction.Args[0], "RAW64", StringComparison.Ordinal))
            {
                string hex = instruction.Args[1].Trim();
                if (hex.StartsWith("0x", StringComparison.OrdinalIgnoreCase))
                {
                    hex = hex.Substring(2);
                }
                ulong raw = Convert.ToUInt64(hex, 16);
                instruction.CompilerDetails = 0;
                LogDetailCompile($"RAW64 0x{raw:X16}");
                return raw;
            }

            ulong l = 0;
            ushort compilerDetails = 0;

            // Pre-scan the instruction's tokens to determine whether a
            // numeric literal in this instruction should be treated as a
            // 13-bit branch target (split across bit 20 and bits 11:0)
            // or as 16-bit data (OR'd into bits 15:0).
            //
            // Jump-target context: T,JMP / T,JMP0-3 / T,JMPAOPR is
            //   present AND no COND,xxx test is active. In this case a
            //   numeric 0..0x1FFF is a branch address and must be split
            //   the same way labels are - otherwise `T,JMP 14000;`
            //   incorrectly sets AOP.0 instead of bit 20.
            //
            // Data context: T,NEXT (default), T,RETURN (uses return
            //   stack, not low bits), any SCOND=1 instruction (low 12
            //   bits encode LCC/TSEL/F.SEQ/F.STK), or plain sequential
            //   flow. Numerics OR into bits 15:0 unchanged.
            //
            // Deliberate exclusions from "jump context":
            //   - T,RETURN: uses the return stack (see RASK addr 0o4752
            //     where T,RETURN + 14000 loads data 0x1800, not an addr).
            //   - Stand-alone CONDENABL: combined with T,NEXT and
            //     IDBS,ARG the numeric may be data (see RASK addr
            //     0o1535). When CONDENABL appears with T,JMP the latter
            //     token alone puts us in jump context.
            bool isJumpContext = false;
            bool hasCondToken = false;
            for (int argIdx = 0; argIdx < instruction.Args.Count; argIdx++)
            {
                string a = instruction.Args[argIdx];
                if (a == "T,JMP" || a == "T,JMP0-3" || a == "T,JMPAOPR")
                    isJumpContext = true;
                if (a.StartsWith("COND,", StringComparison.Ordinal))
                    hasCondToken = true;
            }
            bool splitNumericsAsAddress = isJumpContext && !hasCondToken;

            for (int argIdx = 0; argIdx < instruction.Args.Count; argIdx++)
            {
                string strToken = instruction.Args[argIdx];
                var token = ndTokens.LookupToken(strToken);


                if (token != null)
                {

                    compilerDetails |= token.CompilerDetails;

                    // Ok, a known ND100 token
                    l |= token.Value;

                    LogDetailCompile($"{token.Token.PadRight(17)} [{token.Value:X16} => {token.Comment}]");
                    continue;
                }

                int labelAddress = labels.MapLabelToAddress(strToken);
                if (labelAddress >= 0)
                {

                    if ((labelAddress & 1 << 12) != 0)
                    {
                        // Console.Write("!");
                    }
                    // Ok, a known Label (use bits 0-11 and bit 20; ND-100: bits 0-11 only,
                    // bit 20 is the timing bit TC0 there)
                    l |= (ulong)((ushort)(labelAddress & 0xFFF));
                    if (ND100Compiler)
                    {
                        if (labelAddress > 0xFFF)
                        {
                            Console.WriteLine($"Label {strToken} = {Int2Oct(labelAddress)} does not fit the 12-bit ND-100 branch address in {Int2Oct(instruction.Address)}");
                        }
                    }
                    else
                    {
                        l |= (ulong)((labelAddress >> 12) & 0x01) << 20;
                    }

                    LogDetailCompile($"{strToken.PadRight(17)} => Token address {Int2Oct(labelAddress)}");
                    continue;
                }

                int numeric = ParseIntValue(strToken);
                if (numeric >= 0)
                {
                    if (splitNumericsAsAddress && ND100Compiler && numeric <= 0xFFF)
                    {
                        // ND-100: a 12-bit branch target, bits 11:0 only.
                        l |= (ulong)((ushort)(numeric & 0xFFF));
                        LogDetailCompile($"{strToken.PadRight(17)} => Address {Int2Oct(numeric)} (12-bit)");
                    }
                    else if (splitNumericsAsAddress && !ND100Compiler && numeric <= 0x1FFF)
                    {
                        // Treat as 13-bit branch target - split bit 12
                        // out to bit 20 the same way a label is handled.
                        l |= (ulong)((ushort)(numeric & 0xFFF));
                        l |= (ulong)((numeric >> 12) & 0x01) << 20;
                        LogDetailCompile($"{strToken.PadRight(17)} => Address {Int2Oct(numeric)} (13-bit, bit-20 split)");
                    }
                    else
                    {
                        // 16-bit data literal (OR into low word).
                        l |= (ushort)numeric;
                        LogDetailCompile($"{strToken.PadRight(17)} => Number {Int2Oct(numeric)}");
                    }
                    continue;
                }

                LogUnknownToken($"Unknown token: {strToken} Line: {instruction.LineNo}");
            }

            instruction.CompilerDetails = compilerDetails;
            LogDetailCompile("");

            if (ND120Compiler == false)
            {
                // Convert to ND-110 / ND-100 token form: bits 22-27 are stored inverted.
                // ND-06.031.1 chapter 4 (ND-110) and ND-06.018.01 "Writing the Microprogram" (ND-100).
                l = l ^ 0x000000000FC00000; // Invert bit 22-27
            }

            return l;
        }


        /// <summary>
        /// Assembler
        ///     * Preprocess - Tokenize and identify all labels and their addresses
        ///     * Translate - Text to Binary
        ///     * Save Binary
        /// </summary>
        /// <param name="sourceCode"></param>
        /// <returns></returns>
        public Target Assemble(string sourceCode)
        {

            Target t = new Target();
            var sourceMap = Preprocess(sourceCode);



            using (MemoryStream ms = new MemoryStream())
            {
                for (int instrIdx = 0; instrIdx < sourceMap.Instructions.Count; instrIdx++)
                {
                    InstructionInfo instr = sourceMap.Instructions[instrIdx];
                    if (instr.Raw == null) continue;

                    currentLine = instr.LineNumber; // Global variable used by exceptions

                    var instruction = Tokenize(instr.Raw);
                    instruction.LineNo = instr.LineNumber; // Used by exceptions inside Instruction
                    instruction.Address = instr.Address;


                    // Write long array to disk. Low bytes first. So first byte is bits 0-7, next byte is bits 8-15,..
                    ulong uC = Translate(instruction, sourceMap.Labels);

                    string strUcDetail = $"uC: {Int2Oct(instruction.Address)} : 0x{uC:X16} => ";
                    string strUcBinary = $"uC: {Int2Oct(instruction.Address)} : ";
                    for (int i = 3; i >= 0; i--)
                    {
                        ushort val = (ushort)(uC >> (i * 16));
                        strUcDetail += Int2Oct(val) + " ";

                        strUcBinary += Convert.ToString(val, 2).PadLeft(16, '0') + " ";
                    }

                    // TODO: IF ND-110 "invert" bits 22-24 (LOOP, ECOND, SCOND), bit 24 (vectored jump)

                    CheckCompilerWarnings(instruction);

                    LogBinaryMicroCode(strUcDetail);
                    LogBinaryMicroCode(strUcBinary);
                    LogBinaryMicroCode("%-----");



                    // Store the compiled microcode in LITTLE ENDIAN format
                    // (the least significant byte first)

                    // First 2 bytes is the 16 bits address
                    ms.WriteByte((byte)(instruction.Address & 0xFF));
                    ms.WriteByte((byte)((instruction.Address >> 8) & 0xFF));


                    // Next 8 bytes is the 64 bit micro-code -                
                    byte byteval = 0;
                    for (int i = 0; i < 8; i++)
                    {
                        byteval = (byte)(uC & 0xFF);
                        uC = uC >> 8;

                        ms.WriteByte(byteval);
                    }
                }
                t.Exe = ms.ToArray();
            }

            // Write the symbols - Sorted by Address

            if (symbolFileStream != null)
            {
                symbolFileStream.WriteLine("Labels, sorted by address");
                symbolFileStream.WriteLine("=========================");
                symbolFileStream.WriteLine("");

                List<LabelDefinition> byAddress = sourceMap.Labels.GetSortedByAddress();
                for (int lblIdx = 0; lblIdx < byAddress.Count; lblIdx++)
                {
                    symbolFileStream.WriteLine($"{Int2Oct(byAddress[lblIdx].Address)}={byAddress[lblIdx].Label}");
                }
                symbolFileStream.WriteLine("");


                // Write the symbols - Sorted by Name

                symbolFileStream.WriteLine("Labels, sorted by name");
                symbolFileStream.WriteLine("======================");
                symbolFileStream.WriteLine("");


                List<LabelDefinition> byName = sourceMap.Labels.GetSortedByName();
                for (int lblIdx = 0; lblIdx < byName.Count; lblIdx++)
                {
                    symbolFileStream.WriteLine($"{byName[lblIdx].Label}={Int2Oct(byName[lblIdx].Address)}");
                }
            }

            return t;
        }



        // Workaround to hide "sloppy" microcode        
        // Hardcoded list, may be extended when new "wrong" opodes are detected
        static readonly ushort[] myArray = new ushort[] { 429, 507, 1004, 1073, 2008, 2456, 4797 }; // Converted from OCT

        bool IsIgnored(ushort address)
        {
            for (int i = 0; i < myArray.Length; i++)
            {
                if (myArray[i] == address)
                {
                    return true;
                }
            }
            return false;
        }
        private void CheckCompilerWarnings(Instruction instr)
        {
            if (IsIgnored((ushort)instr.Address)) return;


            ushort w = instr.CompilerDetails;
            if ((w & Constants.RequireA) != 0)
            {
                if ((w & Constants.IsA) == 0)
                {
                    Console.WriteLine($"Missing A in {Int2Oct(instr.Address)}"); ;
                }
            }

            if ((w & Constants.RequireB) != 0)
            {
                if ((w & Constants.IsB) == 0)
                {
                    Console.WriteLine($"Missing B in {Int2Oct(instr.Address)}"); ;
                }
            }

            if ((w & Constants.RequirePIC) != 0)
            {
                if ((w & Constants.IsPIC) == 0)
                {
                    Console.WriteLine($"Missing PIC in {Int2Oct(instr.Address)}"); ;
                }
            }

#if _not_everywhere_ // helped me find ONE missing though...

            if ((w & Constants.IsIDBS) == 0)
            {
                Console.WriteLine($"Missing IDBS {Int2Oct(instr.Address)}"); ;
            }
#endif

#if _this_didnt_give_value // to sloppy uc programming!!
            if ((w & Constants.IsTrueAddr) == 0)
            {
                Console.WriteLine($"Missing T,<address> in {Int2Oct(instr.Address)}"); ;
            }
            if ((w & Constants.IsTrueStack) == 0)
            {
                Console.WriteLine($"Missing T,<stack> in {Int2Oct(instr.Address)}"); ;
            }

            if ((w & Constants.IsCond) != 0)
            {
                if ((w & Constants.IsFalseAddr) == 0)
                {
                    Console.WriteLine($"Missing F,<address> in {Int2Oct(instr.Address)}"); ;
                }
                if ((w & Constants.IsFalseStack) == 0)
                {
                    Console.WriteLine($"Missing F,<stack> in {Int2Oct(instr.Address)}"); ;
                }

            }
#endif

        }

        #region Octal text helper functions
        bool IsVal(string valStr)
        {

            int val = ParseIntValue(valStr);
            if (val >= 0) return true;

            return false;
        }

        int GetAddr(string addrStr, Labels labels)
        {

            int address = labels.MapLabelToAddress(addrStr);

            if (address == UNDEFINED)
            {
                if (IsVal(addrStr))
                {
                    return ParseIntValue(addrStr);
                }
                else
                {
                    throw new ND110AsmException($"Unexpected address {addrStr}", currentLine);
                }
            }

            return address;
        }


        public static string Int2Oct(int val)
        {
            return Convert.ToString(val, 8).PadLeft(6, '0');
        }

        public static int ParseIntValue(string value)
        {
            value = value.Trim();
            if (!double.TryParse(value, out _)) return -1;
            try
            {

                // DEC dNNNN
                if ((value.StartsWith("d")) | (value.StartsWith("D")))
                {
                    return int.Parse(value.Substring(1));
                }


                // HEX 0xNNNN
                if ((value.StartsWith("0x")) | (value.StartsWith("0X")))
                {
                    if (value.Length <= 1)
                        value = "0x" + value;

                    if ((value[1] != 'x') && (value[1] != 'X'))
                        value = "0x" + value;

                    return int.Parse(value.Substring(2), System.Globalization.NumberStyles.HexNumber);
                }

                // HEX $NNNN
                if (value.StartsWith("$"))
                {
                    return int.Parse(value.Substring(1), System.Globalization.NumberStyles.HexNumber);
                }

                //Octal o012345
                if (value.StartsWith("o"))
                {
                    return Convert.ToInt32(value.Substring(1), 8);
                }


                // Octal 012345
                if ((value.StartsWith("0")) || ((value.StartsWith("1")) && (value.Length == 6)) || true) // default fallback to Octal
                {
                    return Convert.ToInt32(value, 8);
                }

                // Decimal (default)
                return int.Parse(value);
            }
            catch (Exception)
            {
                return -1;
            }
        }

        #endregion Octal text helper functions

        #region File Logic
        private void CleanupFiles()
        {
            if (listingFileStream != null)
            {
                listingFileStream.Close();
                listingFileStream.Dispose();
                listingFileStream = null;
            }

            if (detailsFileStream != null)
            {
                detailsFileStream.Close();
                detailsFileStream.Dispose();
                detailsFileStream = null;
            }

            if (symbolFileStream != null)
            {
                symbolFileStream.Close();
                symbolFileStream.Dispose();
                symbolFileStream = null;
            }
        }

        private bool InitializeFiles(string ucTextFile)
        {

            FileInfo fi = new FileInfo(ucTextFile); ;

            if (!fi.Exists) return false;

            string fileName = fi.Name;
            string fname = Path.GetFileNameWithoutExtension(fileName);
            string? path = fi.DirectoryName;
            if (path == null) return false;


            // Microinstructions are generated using the Microassembier program.
            // This program is internal to Norsk Data. 
            //
            // Five output fiTes are generated from the assembier, with the name *—F32 or *—F48.
            //
            // Their fiiename extensions are:
            //      :LIST Tisting fiTe — compiete
            //      :LABE TabeTs and their addresses
            //      :ERR error Tisting
            //      :UDEF undefined entries
            //      :DATA the assembied output for ?—PROM—PROGRAM.



            string listingFile = $"{path}/{fname}.LISTING.TXT";
            string detailsFile = $"{path}/{fname}.DETAILS.TXT";
            string symbolFile = $"{path}/{fname}.SYMBOLS.TXT";
            binaryFileName = $"{path}/{fname}.CODE";


            listingFileStream = new StreamWriter(listingFile, false);
            detailsFileStream = new StreamWriter(detailsFile, false);
            symbolFileStream = new StreamWriter(symbolFile, false);

            return true;

        }

        private void LogListing(string strListing)
        {
            if (listingFileStream != null)
                listingFileStream.WriteLine(strListing);
        }

        void LogDetailCompile(string message)
        {
            if (detailsFileStream != null)
                detailsFileStream.WriteLine(message);
        }

        void LogUnknownToken(string message)
        {
            if (detailsFileStream != null)
                detailsFileStream.WriteLine(message);

            if (listingFileStream != null)
                listingFileStream.WriteLine(message);
        }

        void LogBinaryMicroCode(string message)
        {
            if (detailsFileStream != null)
                detailsFileStream.WriteLine(message);
        }

        void LogConsoleMessage(string message)
        {
            Console.WriteLine(message);
        }


        #endregion File Logic


        public void Dispose()
        {
            CleanupFiles();
        }

    }




}

