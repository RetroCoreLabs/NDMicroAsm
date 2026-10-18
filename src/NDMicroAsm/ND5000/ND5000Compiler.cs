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

namespace NDMicroAsm.ND5000
{
    /// <summary>
    /// ND-5000 micro code assembler.
    ///
    /// Mirrors <see cref="ND500.ND500Compiler"/> (same source dialect) with the
    /// ND-5000 word format: 128 bits = eight 16-bit parts (Words[0] = bits
    /// 127-112 ... Words[7] = bits 15-0). Control store: 16K words; the
    /// binary output is 16 bytes per word big-endian (byte 0 = bits 127-120),
    /// full image = 262144 bytes - identical to the original .DATA dumps in
    /// the nd5000uc project.
    ///
    /// Source dialect:
    ///   - mnemonics separated by spaces; an instruction is terminated by ';'
    ///     and may span several lines
    ///   - '#' preceded by whitespace/line start begins a comment; '%' is
    ///     also accepted as a comment character (ND-110 .uc convention)
    ///   - 'nnnn/' as the first element sets the current control store address
    ///   - 'NAME:' as the first symbol defines a label (value = current address)
    ///   - a label reference places the address in ABS_ADDR (micro word bits
    ///     31-16, the ND-5000 sequencer jump target field)
    ///   - FIELDNAME=octal places a raw value in the named field (names from
    ///     ND5000Fields, partition fields and sub fields alike); range-checked
    ///     against the field width and overlap-checked per bit
    ///   - one octal integer = short argument, placed in bits 15-0
    ///   - two octal integers 'n,n' = long argument, placed in bits 31-0
    ///   - all constants are octal (an optional trailing 'B' is accepted)
    ///   - two mnemonics setting the same bit is an error:
    ///     "OR-ing rejected due to overlapping of MNE-values"
    ///   - writing the same control store address twice is an error:
    ///     "Attempt to write on former entry"
    ///   - NO assembly date stamp (that is an ND-500 specific behavior)
    /// </summary>
    public class ND5000Compiler : IDisposable
    {
        /// <summary>
        /// Number of 16-bit control store parts in one ND-5000 micro word.
        /// </summary>
        public const int WORD_PARTS = ND5000Token.WORD_PARTS;   // 8 x 16-bit parts
        /// <summary>
        /// Number of micro words in the ND-5000 control store.
        /// </summary>
        public const int CONTROL_STORE_WORDS = 16384;           // 16K micro words
        /// <summary>
        /// Mask of the 16-bit control store address carried in the ABS_ADDR field, micro word bits 31-16.
        /// </summary>
        public const int ADDRESS_MASK = 0xFFFF;                 // ABS_ADDR is a full 16-bit field

        // Word part indexes (Words[0] = bits 127-112 first)
        const int PART_31_16 = 6;   // micro word bits 31-16 (ABS_ADDR)
        const int PART_15_0 = 7;    // micro word bits 15-0

        StreamWriter? listingFileStream;
        StreamWriter? detailsFileStream;
        StreamWriter? symbolFileStream;
        string? binaryFileName;

        ND5000Tokens? ndTokens;

        int currentLine;      // current source code line during compilation (for error reports)
        int errorCount;

        /// <summary>
        /// Number of errors the last assembly reported.
        /// </summary>
        public int ErrorCount => errorCount;

        /// <summary>
        /// When true (default) the output image is the full 16K control store
        /// (262144 bytes, 16 bytes per word big-endian) - the exact format of
        /// the original ND-5000 .DATA dumps.
        /// </summary>
        public bool WriteFullControlStore = true;

        /// <summary>
        /// Assemble an ND-5000 micro code text file to a binary control store image.
        /// </summary>
        public Target? AssembleFile(string ucTextFile)
        {
            if (!InitializeFiles(ucTextFile))
            {
                LogConsoleMessage("Can't find source file: " + ucTextFile);
                return null;
            }

            var sourceText = File.ReadAllText(ucTextFile);
            LogConsoleMessage($"Reading ND-5000 uCode from {ucTextFile}, {sourceText.Length} characters");

            ndTokens = new ND5000Tokens();
            ndTokens.InitializeTokens();

            string strTokensFile = Path.GetDirectoryName(ucTextFile) + "/TOKENS-ND5000.TXT";
            ndTokens.DumpAllTokensToFile(strTokensFile);

            Target? result = null;
            try
            {
                LogConsoleMessage("Compiling.....");
                result = Assemble(sourceText);

                if (result?.Exe != null && errorCount == 0)
                {
                    LogConsoleMessage($"Compiled OK! {result.Exe.Length / (WORD_PARTS * 2)} control store words written");
                    if (binaryFileName != null)
                    {
                        LogConsoleMessage($"Writing control store image, {result.Exe.Length} bytes");
                        File.WriteAllBytes(binaryFileName, result.Exe);
                    }
                }
                else
                {
                    LogConsoleMessage($"Compile failed! {errorCount} error(s)");
                    result = null;
                }
            }
            catch (ND110AsmException asmEx)
            {
                LogConsoleMessage($"Assembler error: {asmEx.Message} at line {asmEx.SourceCodeLine}");
            }

            CleanupFiles();
            return result;
        }

        /// <summary>
        /// Preprocess: strip comments, handle 'nnnn/' address modifiers and
        /// 'NAME:' labels, and gather the ';'-terminated instructions with
        /// their control store addresses. Same rules as ND500Compiler.
        /// </summary>
        public SourceMap Preprocess(string sourceCode)
        {
            SourceMap map = new SourceMap();
            int ucAddress = 0;
            int lineNo = 1;

            sourceCode = sourceCode.Replace("\r", "");
            var all_lines = sourceCode.Split("\n");
            string ucLine = "";

            for (int lineIdx = 0; lineIdx < all_lines.Length; lineIdx++)
            {
                string line = StripComment(all_lines[lineIdx]).Trim();

                // Normalize spacing around ',' so 'A, B' style input still tokenizes
                line = line.Replace(" ,", ",");
                line = line.Replace(", ", ",");

                bool startOfInstruction = ucLine.Trim().Length == 0;

                // 'nnnn/' as the first element of a micro instruction sets the
                // current control store address
                if (startOfInstruction)
                {
                    int idxSlash = line.IndexOf("/");
                    if (idxSlash > 0)
                    {
                        string strAddress = line.Substring(0, idxSlash).Trim();
                        int adr = ParseOctal(strAddress);
                        if (adr >= 0)
                        {
                            ucAddress = adr;
                            line = line.Substring(idxSlash + 1).Trim();
                        }
                    }
                }

                // 'NAME:' as the first symbol defines a label
                int idxColon = line.IndexOf(":");
                if ((idxColon > 0) && (idxColon < 30) && startOfInstruction)
                {
                    string label = line.Substring(0, idxColon).Trim();
                    if (IsLabelName(label))
                    {
                        map.Labels.AddLabelAndAddress(label, ucAddress);
                        line = line.Substring(idxColon + 1).Trim();
                    }
                }

                string strline = lineNo.ToString().PadLeft(4, '0');
                string strUcAddr = Convert.ToString(ucAddress, 8).PadLeft(6, '0');
                LogListing($"{strline}  {strUcAddr}  {all_lines[lineIdx]}");

                ucLine = ucLine + " " + line;

                // ';' terminates the micro instruction (may span several lines)
                if (ucLine.IndexOf(";") > 0)
                {
                    ucLine = ucLine.Replace(";", "");
                    map.Instructions.Add(new InstructionInfo() { LineNumber = lineNo, Address = ucAddress, Raw = ucLine });
                    ucAddress++;
                    ucLine = "";
                }
                lineNo++;
            }

            return map;
        }

        /// <summary>
        /// Remove comments: '#' at line start or preceded by whitespace starts
        /// a comment ('#' inside a token stays). '%' always starts a comment.
        /// </summary>
        public static string StripComment(string line)
        {
            for (int i = 0; i < line.Length; i++)
            {
                char c = line[i];
                if (c == '%')
                {
                    return line.Substring(0, i);
                }
                if (c == '#')
                {
                    if (i == 0 || line[i - 1] == ' ' || line[i - 1] == '\t')
                    {
                        return line.Substring(0, i);
                    }
                }
            }
            return line;
        }

        static bool IsLabelName(string label)
        {
            if (label.Length == 0) return false;
            // A label starts with a letter; anything numeric is an address/constant
            char c = label[0];
            return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
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
        /// Translate one instruction into its 8-part micro word by OR-ing the
        /// mnemonic contributions, raw field values, label addresses and
        /// octal arguments. Public so unit tests (round trip) can drive it
        /// directly without building a full control store per word.
        /// </summary>
        public void Translate(Instruction instruction, Labels labels, ushort[] word)
        {
            // Allow direct use (unit tests) without going through Assemble
            if (ndTokens == null)
            {
                ndTokens = new ND5000Tokens();
                ndTokens.InitializeTokens();
            }

            LogDetailCompile($"ucode: {Int2Oct(instruction.Address)}");

            for (int argIdx = 0; argIdx < instruction.Args.Count; argIdx++)
            {
                string strToken = instruction.Args[argIdx];
                var token = ndTokens.LookupToken(strToken);
                if (token != null)
                {
                    // "OR-ing rejected due to overlapping of MNE-values":
                    // two mnemonics must not set the same bit
                    for (int i = 0; i < WORD_PARTS; i++)
                    {
                        if ((word[i] & token.Words[i]) != 0)
                        {
                            LogError($"OR-ing rejected due to overlapping of MNE-values: {strToken} overlaps at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                        }
                    }
                    for (int i = 0; i < WORD_PARTS; i++)
                    {
                        word[i] |= token.Words[i];
                    }

                    LogDetailCompile($"{token.Token.PadRight(17)} [{WordToOctal(token.Words)} => {token.Comment}]");
                    continue;
                }

                // Raw field syntax: FIELDNAME=<octal> places the value at the
                // field position (checked before anything else containing '=';
                // no mnemonic contains '=')
                int idxEquals = strToken.IndexOf('=');
                if (idxEquals > 0)
                {
                    string fieldName = strToken.Substring(0, idxEquals);
                    if (ND5000Fields.TryLookup(fieldName, out var field))
                    {
                        int fieldValue = ParseOctal(strToken.Substring(idxEquals + 1));
                        if (fieldValue < 0)
                        {
                            LogError($"Bad octal value in field assignment: {strToken} at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                            continue;
                        }
                        if ((ulong)fieldValue > field.MaxValue)
                        {
                            LogError($"Transform overflow: {strToken} does not fit {field.Width}-bit field at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                            continue;
                        }
                        OrFieldValue(word, field, (ulong)fieldValue, instruction, strToken);
                        LogDetailCompile($"{strToken.PadRight(17)} => Field {fieldName} value {Int2Oct(fieldValue)}");
                        continue;
                    }
                    LogError($"Unknown field name: {strToken} at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                    continue;
                }

                // Long argument 'n,n' - two 16-bit octal integers into bits 31-0.
                // Checked before labels: no valid token/label contains a ','
                // with octal numbers on both sides.
                int idxComma = strToken.IndexOf(',');
                if (idxComma > 0)
                {
                    int hi = ParseOctal(strToken.Substring(0, idxComma));
                    int lo = ParseOctal(strToken.Substring(idxComma + 1));
                    if (hi >= 0 && lo >= 0)
                    {
                        if (hi > 0xFFFF || lo > 0xFFFF)
                        {
                            LogError($"Transform overflow: long argument {strToken} at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                            continue;
                        }
                        OrArgument(word, PART_31_16, (ushort)hi, instruction, strToken);
                        OrArgument(word, PART_15_0, (ushort)lo, instruction, strToken);
                        LogDetailCompile($"{strToken.PadRight(17)} => Long argument {Int2Oct(hi)},{Int2Oct(lo)}");
                        continue;
                    }
                }

                // Label reference - address into ABS_ADDR (micro word bits 31-16,
                // the ND-5000 sequencer jump target field)
                int labelAddress = labels.MapLabelToAddress(strToken);
                if (labelAddress >= 0)
                {
                    OrArgument(word, PART_31_16, (ushort)(labelAddress & ADDRESS_MASK), instruction, strToken);
                    LogDetailCompile($"{strToken.PadRight(17)} => Label address {Int2Oct(labelAddress)}");
                    continue;
                }

                // Short argument - one 16-bit octal integer into bits 15-0
                int numeric = ParseOctal(strToken);
                if (numeric >= 0)
                {
                    if (numeric > 0xFFFF)
                    {
                        LogError($"Transform overflow: {strToken} at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                        continue;
                    }
                    OrArgument(word, PART_15_0, (ushort)numeric, instruction, strToken);
                    LogDetailCompile($"{strToken.PadRight(17)} => Short argument {Int2Oct(numeric)}");
                    continue;
                }

                LogError($"Unknown token: {strToken} at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
            }

            LogDetailCompile("");
        }

        void OrFieldValue(ushort[] word, ND5000Field field, ulong value, Instruction instruction, string strToken)
        {
            // Build the contribution separately so overlaps can be detected
            // before committing anything
            ushort[] contribution = new ushort[WORD_PARTS];
            ND5000TokensBase.OrValueIntoWords(contribution, field.HighBit, field.LowBit, value);

            for (int i = 0; i < WORD_PARTS; i++)
            {
                if ((word[i] & contribution[i]) != 0)
                {
                    LogError($"OR-ing rejected due to overlapping of MNE-values: {strToken} overlaps at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
                }
            }
            for (int i = 0; i < WORD_PARTS; i++)
            {
                word[i] |= contribution[i];
            }
        }

        void OrArgument(ushort[] word, int part, ushort value, Instruction instruction, string strToken)
        {
            if ((word[part] & value) != 0)
            {
                LogError($"OR-ing rejected due to overlapping of MNE-values: argument {strToken} overlaps at {Int2Oct(instruction.Address)}, line {instruction.LineNo}");
            }
            word[part] |= value;
        }

        /// <summary>
        /// Assemble: preprocess, translate every instruction into the control
        /// store image, emit the binary. No date stamp (ND-500 specific).
        /// </summary>
        public Target Assemble(string sourceCode)
        {
            // Allow direct use (unit tests) without going through AssembleFile
            if (ndTokens == null)
            {
                ndTokens = new ND5000Tokens();
                ndTokens.InitializeTokens();
            }

            Target t = new Target();
            var sourceMap = Preprocess(sourceCode);

            // Full 16K control store image, 8 parts per word
            ushort[] store = new ushort[CONTROL_STORE_WORDS * WORD_PARTS];
            bool[] written = new bool[CONTROL_STORE_WORDS];
            int highestAddress = -1;

            ushort[] word = new ushort[WORD_PARTS];

            for (int instrIdx = 0; instrIdx < sourceMap.Instructions.Count; instrIdx++)
            {
                InstructionInfo instr = sourceMap.Instructions[instrIdx];
                if (instr.Raw == null) continue;

                currentLine = instr.LineNumber;

                if (instr.Address >= CONTROL_STORE_WORDS)
                {
                    LogError($"Current location counter is at upper limit: {Int2Oct(instr.Address)}, line {instr.LineNumber}");
                    continue;
                }
                if (written[instr.Address])
                {
                    LogError($"Attempt to write on former entry: {Int2Oct(instr.Address)}, line {instr.LineNumber}");
                    continue;
                }

                var instruction = Tokenize(instr.Raw);
                instruction.LineNo = instr.LineNumber;
                instruction.Address = instr.Address;

                for (int i = 0; i < WORD_PARTS; i++) word[i] = 0;
                Translate(instruction, sourceMap.Labels, word);

                string strUcDetail = $"uC: {Int2Oct(instruction.Address)} : {WordToOctal(word)}";
                LogBinaryMicroCode(strUcDetail);
                LogBinaryMicroCode("%-----");

                for (int i = 0; i < WORD_PARTS; i++)
                {
                    store[instr.Address * WORD_PARTS + i] = word[i];
                }
                written[instr.Address] = true;
                if (instr.Address > highestAddress) highestAddress = instr.Address;
            }

            // Emit the image: 16 bytes per word, big-endian per part
            // (byte 0 = bits 127-120) - the original .DATA format
            int wordsToWrite = WriteFullControlStore ? CONTROL_STORE_WORDS : highestAddress + 1;
            if (wordsToWrite < 0) wordsToWrite = 0;
            using (MemoryStream ms = new MemoryStream())
            {
                for (int addr = 0; addr < wordsToWrite; addr++)
                {
                    for (int i = 0; i < WORD_PARTS; i++)
                    {
                        ushort part = store[addr * WORD_PARTS + i];
                        ms.WriteByte((byte)(part >> 8));
                        ms.WriteByte((byte)(part & 0xFF));
                    }
                }
                t.Exe = ms.ToArray();
            }

            WriteSymbolFile(sourceMap);
            return t;
        }

        void WriteSymbolFile(SourceMap sourceMap)
        {
            if (symbolFileStream == null) return;

            symbolFileStream.WriteLine("Labels, sorted by address");
            symbolFileStream.WriteLine("=========================");
            symbolFileStream.WriteLine("");
            List<LabelDefinition> byAddress = sourceMap.Labels.GetSortedByAddress();
            for (int lblIdx = 0; lblIdx < byAddress.Count; lblIdx++)
            {
                symbolFileStream.WriteLine($"{Int2Oct(byAddress[lblIdx].Address)}={byAddress[lblIdx].Label}");
            }
            symbolFileStream.WriteLine("");

            symbolFileStream.WriteLine("Labels, sorted by name");
            symbolFileStream.WriteLine("======================");
            symbolFileStream.WriteLine("");
            List<LabelDefinition> byName = sourceMap.Labels.GetSortedByName();
            for (int lblIdx = 0; lblIdx < byName.Count; lblIdx++)
            {
                symbolFileStream.WriteLine($"{byName[lblIdx].Label}={Int2Oct(byName[lblIdx].Address)}");
            }
        }

        static string WordToOctal(ushort[] word)
        {
            string s = "";
            for (int i = 0; i < WORD_PARTS; i++)
            {
                s += Convert.ToString(word[i], 8).PadLeft(6, '0');
                if (i < WORD_PARTS - 1) s += " ";
            }
            return s;
        }

        /// <summary>
        /// Formats a value as six octal digits, the way the listing and symbol files print addresses.
        /// </summary>
        /// <param name="val">
        /// The value to format.
        /// </param>
        /// <returns>
        /// Six octal digits, zero padded.
        /// </returns>
        public static string Int2Oct(int val)
        {
            return Convert.ToString(val, 8).PadLeft(6, '0');
        }

        /// <summary>
        /// ND constants are octal; an optional trailing 'B' (the ND octal
        /// marker) is accepted. Returns -1 when not an octal number.
        /// </summary>
        public static int ParseOctal(string value)
        {
            value = value.Trim();
            if (value.Length == 0) return -1;

            if (value.EndsWith("B") || value.EndsWith("b"))
            {
                value = value.Substring(0, value.Length - 1);
                if (value.Length == 0) return -1;
            }

            for (int i = 0; i < value.Length; i++)
            {
                if (value[i] < '0' || value[i] > '7') return -1;
            }

            try
            {
                return Convert.ToInt32(value, 8);
            }
            catch (Exception)
            {
                return -1;
            }
        }

        #region File Logic
        bool InitializeFiles(string ucTextFile)
        {
            FileInfo fi = new FileInfo(ucTextFile);
            if (!fi.Exists) return false;

            string fname = Path.GetFileNameWithoutExtension(fi.Name);
            string? path = fi.DirectoryName;
            if (path == null) return false;

            listingFileStream = new StreamWriter($"{path}/{fname}.LISTING.TXT", false);
            detailsFileStream = new StreamWriter($"{path}/{fname}.DETAILS.TXT", false);
            symbolFileStream = new StreamWriter($"{path}/{fname}.SYMBOLS.TXT", false);
            binaryFileName = $"{path}/{fname}.CODE";

            errorCount = 0;
            return true;
        }

        void CleanupFiles()
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

        void LogListing(string strListing)
        {
            if (listingFileStream != null)
                listingFileStream.WriteLine(strListing);
        }

        void LogDetailCompile(string message)
        {
            if (detailsFileStream != null)
                detailsFileStream.WriteLine(message);
        }

        void LogBinaryMicroCode(string message)
        {
            if (detailsFileStream != null)
                detailsFileStream.WriteLine(message);
        }

        void LogError(string message)
        {
            errorCount++;
            Console.WriteLine("ERROR: " + message);
            if (detailsFileStream != null)
                detailsFileStream.WriteLine("ERROR: " + message);
            if (listingFileStream != null)
                listingFileStream.WriteLine("ERROR: " + message);
        }

        void LogConsoleMessage(string message)
        {
            Console.WriteLine(message);
        }
        #endregion File Logic

        /// <summary>
        /// Closes the listing, details and symbol files if an assembly left them open.
        /// </summary>
        public void Dispose()
        {
            CleanupFiles();
        }
    }
}
