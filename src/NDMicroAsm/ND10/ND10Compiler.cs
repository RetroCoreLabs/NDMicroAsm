//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using NDMicroAsm.Core;

namespace NDMicroAsm.ND10
{
    /// <summary>
    /// NORD-10 micro code assembler (MICMAC dialect).
    ///
    /// The NORD-10 micro program (ND-06.010.01) is stored in a 1k x 32-bit
    /// ROM; the later NORD-10 CE micro code fills a 4k x 32-bit ROM. Every
    /// ROM word is one of four formats (ARITHMETIC, INTERBLOCK, JUMP, LOOP),
    /// see ND10Tokens.cs for the bit layout. The assembler is the same
    /// token-OR model as the ND-110/ND-500/ND-5000 assemblers in this project:
    /// each mnemonic on a line contributes fixed bits, the contributions are
    /// ORed, and two mnemonics that set the same bit are an error.
    ///
    /// Source dialect (the MICMAC form the manual's listing uses, as
    /// reconstructed by Anders Magnusson's micmac.awk):
    ///
    ///   - one micro instruction per line
    ///   - '%' starts a comment that runs to the end of the line
    ///   - 'nnnn:' as the first item sets the location counter (octal); the
    ///     listing form, four octal digits without the colon, does the same
    ///   - an 8-digit hexadecimal word directly after 'nnnn:' is the word the
    ///     disassembler read from the ROM; it is checked against the
    ///     assembled word and a difference is an error (a self-checking
    ///     listing, as dismac prints it)
    ///   - 'NAME,' (a name ending in a comma) defines a label at the current
    ///     address; a line with only labels does not advance the counter
    ///   - a bare octal number is ORed into the word as it is: a jump address
    ///     (bits 11-0) or any bit pattern that has no mnemonic
    ///   - a label name is a jump address and goes into bits 11-0, also with
    ///     an octal offset (NOINV+1); '*n' is the current location plus n
    ///     (octal), '*-n' minus n
    ///   - anything else must be a mnemonic from ND10Tokens.cs
    ///
    /// Output: the ROM image as text, one 8-digit uppercase hexadecimal word
    /// per line (the prom.hex format of the reference dumps) and as a binary
    /// .CODE file (32-bit words, big-endian). The image is 1024 words when
    /// no address reaches 1024, else 4096 words.
    /// </summary>
    public class ND10Compiler
    {
        /// <summary>
        /// Size in words of the standard NORD-10 micro program ROM.
        /// </summary>
        public const int ROM_1K = 1024;
        /// <summary>
        /// Size in words of the NORD-10/CE micro program ROM.
        /// </summary>
        public const int ROM_4K = 4096;
        /// <summary>
        /// Mask of the 12-bit jump address, bits 11-0 of a JUMP word.
        /// </summary>
        public const uint ADDRESS_MASK = 0xFFF;   // JUMP: bits 11-0

        readonly ND10Tokens tokens;

        int errorCount;
        readonly List<string> errors = new List<string>();

        /// <summary>
        /// Number of errors the last assembly reported.
        /// </summary>
        public int ErrorCount => errorCount;
        /// <summary>
        /// The error messages of the last assembly, in source order.
        /// </summary>
        public List<string> Errors => errors;

        /// <summary>Labels defined by the last Assemble call, in definition order.</summary>
        public List<LabelDefinition> Labels { get; private set; } = new List<LabelDefinition>();

        /// <summary>
        /// Creates an assembler with the MICMAC mnemonic table loaded.
        /// </summary>
        public ND10Compiler()
        {
            tokens = new ND10Tokens();
            tokens.InitializeTokens();
        }

        /// <summary>
        /// The MICMAC mnemonic table the assembler uses.
        /// </summary>
        public ND10Tokens Tokens => tokens;

        /// <summary>
        /// Assemble a source file. Writes NAME.hex, NAME.CODE, NAME.LISTING.TXT
        /// and NAME.SYMBOLS.TXT next to the source. Returns the ROM image or
        /// null when the source had errors.
        /// </summary>
        public uint[]? AssembleFile(string ucTextFile)
        {
            FileInfo fi = new FileInfo(ucTextFile);
            if (!fi.Exists)
            {
                Console.WriteLine("Can't find source file: " + ucTextFile);
                return null;
            }
            string? dir = fi.DirectoryName;
            if (dir == null) return null;
            string fname = Path.GetFileNameWithoutExtension(fi.Name);

            string source = File.ReadAllText(ucTextFile);
            Console.WriteLine($"Reading NORD-10 uCode from {ucTextFile}, {source.Length} characters");

            tokens.DumpAllTokensToFile(Path.Combine(dir, "TOKENS-ND10.TXT"));

            var listing = new StringBuilder();
            uint[]? rom = Assemble(source, listing);

            File.WriteAllText(Path.Combine(dir, fname + ".LISTING.TXT"), listing.ToString());
            WriteSymbolFile(Path.Combine(dir, fname + ".SYMBOLS.TXT"));

            if (rom == null)
            {
                Console.WriteLine($"Compile failed! {errorCount} error(s)");
                return null;
            }

            WriteHexFile(Path.Combine(dir, fname + ".hex"), rom);
            WriteBinaryFile(Path.Combine(dir, fname + ".CODE"), rom);
            Console.WriteLine($"Compiled OK! {rom.Length} ROM words written to {fname}.hex and {fname}.CODE");
            return rom;
        }

        /// <summary>
        /// Assemble source text into a ROM image (1024 or 4096 words). Returns
        /// null when there were errors; ErrorCount / Errors say what.
        /// </summary>
        public uint[]? Assemble(string source, StringBuilder? listing = null)
        {
            errorCount = 0;
            errors.Clear();
            Labels = new List<LabelDefinition>();

            uint[] rom = new uint[ROM_4K];
            bool[] written = new bool[ROM_4K];
            int highest = -1;

            // Pass 1: labels. A label takes the address of the next micro
            // instruction, so the counter must be walked exactly as in pass 2.
            var labelMap = new Dictionary<string, int>();
            var lines = SplitLines(source);
            int address = 0;
            for (int i = 0; i < lines.Length; i++)
            {
                var parsed = ParseLine(lines[i], i + 1, ref address, labelMap, true);
                if (parsed.HasInstruction) address++;
            }

            // Pass 2: assemble
            address = 0;
            for (int i = 0; i < lines.Length; i++)
            {
                int lineNo = i + 1;
                var parsed = ParseLine(lines[i], lineNo, ref address, labelMap, false);
                if (!parsed.HasInstruction)
                {
                    listing?.AppendLine($"{lineNo,5}                  {lines[i]}");
                    continue;
                }

                if (address >= ROM_4K)
                {
                    Error($"Location counter beyond the 4k ROM: {Oct(address)}, line {lineNo}");
                    listing?.AppendLine($"{lineNo,5}  ????            {lines[i]}");
                    address++;
                    continue;
                }
                if (written[address])
                {
                    Error($"Attempt to write on former entry: {Oct(address)}, line {lineNo}");
                }

                uint word = Translate(parsed.Items, address, lineNo, labelMap);
                if (parsed.HasExpectedWord && parsed.ExpectedWord != word)
                {
                    Error($"Assembled word {word:X8} differs from the listed word {parsed.ExpectedWord:X8} at {Oct(address)}, line {lineNo}");
                }

                rom[address] = word;
                written[address] = true;
                if (address > highest) highest = address;
                listing?.AppendLine($"{lineNo,5}  {Oct(address)}  {word:X8}  {lines[i]}");
                address++;
            }

            if (errorCount > 0) return null;

            int size = highest >= ROM_1K ? ROM_4K : ROM_1K;
            uint[] image = new uint[size];
            Array.Copy(rom, image, size);
            return image;
        }

        struct ParsedLine
        {
            public bool HasInstruction;
            public bool HasExpectedWord;
            public uint ExpectedWord;
            public List<string> Items;
        }

        /// <summary>
        /// Split one source line into its parts: address, listed word, labels,
        /// and the mnemonics/arguments that form the instruction.
        /// </summary>
        ParsedLine ParseLine(string rawLine, int lineNo, ref int address, Dictionary<string, int> labelMap, bool defineLabels)
        {
            var result = new ParsedLine { Items = new List<string>() };
            string line = StripComment(rawLine);
            string[] parts = line.Split(new char[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
            int i = 0;

            // 'nnnn:' or, as the manual's listing prints it, a first item of
            // exactly four octal digits sets the location counter
            if (parts.Length > 0 && (parts[0].EndsWith(":") || IsListingAddress(parts[0])))
            {
                string strAddress = parts[0].EndsWith(":") ? parts[0].Substring(0, parts[0].Length - 1) : parts[0];
                long adr = ParseOctal(strAddress);
                if (adr < 0 || adr >= ROM_4K)
                {
                    if (!defineLabels) Error($"Bad octal address '{parts[0]}', line {lineNo}");
                }
                else
                {
                    address = (int)adr;
                }
                i = 1;

                // an 8-digit hex word right after the address is the listed word
                if (parts.Length > 1 && IsHexWord(parts[1]))
                {
                    result.HasExpectedWord = true;
                    result.ExpectedWord = Convert.ToUInt32(parts[1], 16);
                    i = 2;
                }
            }

            // 'NAME,' defines a label at the current address
            while (i < parts.Length && parts[i].Length > 1 && parts[i].EndsWith(",") && IsLabelStart(parts[i][0]))
            {
                string name = parts[i].Substring(0, parts[i].Length - 1);
                if (defineLabels)
                {
                    if (tokens.LookupToken(name) != null)
                    {
                        Error($"Label '{name}' has the name of a mnemonic, line {lineNo}");
                    }
                    else if (labelMap.ContainsKey(name))
                    {
                        Error($"Label '{name}' defined twice, line {lineNo}");
                    }
                    else
                    {
                        labelMap.Add(name, address);
                        Labels.Add(new LabelDefinition { Label = name, Address = address });
                    }
                }
                i++;
            }

            for (; i < parts.Length; i++)
            {
                result.Items.Add(parts[i]);
            }
            result.HasInstruction = result.Items.Count > 0;
            return result;
        }

        /// <summary>OR the contributions of one instruction's items into a micro word.</summary>
        public uint Translate(List<string> items, int address, int lineNo, Dictionary<string, int> labelMap)
        {
            uint word = 0;
            for (int k = 0; k < items.Count; k++)
            {
                string item = items[k];

                var token = tokens.LookupToken(item);
                if (token != null)
                {
                    Or(ref word, token.Value, item, address, lineNo);
                    continue;
                }

                // A bare octal number is ORed into the word as it is:
                // a jump address, or bits that have no mnemonic
                long number = ParseOctal(item);
                if (number >= 0)
                {
                    if (number > uint.MaxValue)
                    {
                        Error($"Octal constant {item} does not fit 32 bits at {Oct(address)}, line {lineNo}");
                        continue;
                    }
                    Or(ref word, (uint)number, item, address, lineNo);
                    continue;
                }

                // Relative jump address: '*' is the current location, '*3' the
                // location plus 3 (octal), '*-2' minus 2 - as the listing writes
                // short forward jumps ("CJMP POS *3")
                if (item[0] == '*')
                {
                    long offset = 0;
                    string rest = item.Substring(1);
                    bool negative = rest.StartsWith("-");
                    if (rest.StartsWith("+") || negative) rest = rest.Substring(1);
                    if (rest.Length > 0)
                    {
                        offset = ParseOctal(rest);
                        if (offset < 0)
                        {
                            Error($"Bad relative address {item} at {Oct(address)}, line {lineNo}");
                            continue;
                        }
                    }
                    long target = negative ? address - offset : address + offset;
                    if (target < 0 || target > ADDRESS_MASK)
                    {
                        Error($"Relative address {item} leaves the ROM at {Oct(address)}, line {lineNo}");
                        continue;
                    }
                    Or(ref word, (uint)target, item, address, lineNo);
                    continue;
                }

                // Jump address as a label, optionally with an octal offset:
                // the listing writes "JMP NOINV+1"
                string labelName = item;
                long labelOffset = 0;
                int idxSign = item.IndexOfAny(new char[] { '+', '-' }, 1);
                if (idxSign > 0)
                {
                    labelOffset = ParseOctal(item.Substring(idxSign + 1));
                    if (labelOffset >= 0)
                    {
                        labelName = item.Substring(0, idxSign);
                        if (item[idxSign] == '-') labelOffset = -labelOffset;
                    }
                }
                if (labelMap.TryGetValue(labelName, out int labelAddress))
                {
                    long labelTarget = labelAddress + labelOffset;
                    if (labelTarget < 0 || labelTarget > ADDRESS_MASK)
                    {
                        Error($"Address {item} leaves the ROM at {Oct(address)}, line {lineNo}");
                        continue;
                    }
                    Or(ref word, (uint)labelTarget, item, address, lineNo);
                    continue;
                }

                Error($"Unknown token: {item} at {Oct(address)}, line {lineNo}");
            }
            return word;
        }

        void Or(ref uint word, uint contribution, string item, int address, int lineNo)
        {
            if ((word & contribution) != 0)
            {
                Error($"OR-ing rejected due to overlapping of MNE-values: {item} at {Oct(address)}, line {lineNo}");
            }
            word |= contribution;
        }

        void Error(string message)
        {
            errorCount++;
            errors.Add(message);
            Console.WriteLine("ERROR: " + message);
        }

        // ------------------------------------------------------------------
        // Helpers
        // ------------------------------------------------------------------

        static string[] SplitLines(string source)
        {
            return source.Replace("\r", "").Split('\n');
        }

        /// <summary>'%' starts a comment that runs to the end of the line.</summary>
        public static string StripComment(string line)
        {
            int idx = line.IndexOf('%');
            return idx < 0 ? line : line.Substring(0, idx);
        }

        static bool IsLabelStart(char c)
        {
            return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
        }

        /// <summary>Exactly four octal digits: the address column of the manual's listing.</summary>
        static bool IsListingAddress(string s)
        {
            return s.Length == 4 && ParseOctal(s) >= 0;
        }

        static bool IsHexWord(string s)
        {
            if (s.Length != 8) return false;
            for (int i = 0; i < 8; i++)
            {
                char c = s[i];
                bool ok = (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
                if (!ok) return false;
            }
            return true;
        }

        /// <summary>Octal number, or -1 when the text is not one.</summary>
        public static long ParseOctal(string value)
        {
            if (value.Length == 0 || value.Length > 11) return -1;
            long result = 0;
            for (int i = 0; i < value.Length; i++)
            {
                char c = value[i];
                if (c < '0' || c > '7') return -1;
                result = result * 8 + (c - '0');
            }
            return result;
        }

        /// <summary>
        /// Formats a ROM address as four octal digits, the way the listing prints it.
        /// </summary>
        /// <param name="value">
        /// The address or value to format.
        /// </param>
        /// <returns>
        /// Four octal digits, zero padded.
        /// </returns>
        public static string Oct(int value)
        {
            return Convert.ToString(value, 8).PadLeft(4, '0');
        }

        void WriteSymbolFile(string path)
        {
            using var w = new StreamWriter(path, false);
            w.WriteLine("Labels, sorted by address");
            w.WriteLine("=========================");
            var byAddress = new List<LabelDefinition>(Labels);
            byAddress.Sort((x, y) => x.Address.CompareTo(y.Address));
            for (int i = 0; i < byAddress.Count; i++)
            {
                w.WriteLine($"{Oct(byAddress[i].Address)}={byAddress[i].Label}");
            }
            w.WriteLine();
            w.WriteLine("Labels, sorted by name");
            w.WriteLine("======================");
            var byName = new List<LabelDefinition>(Labels);
            byName.Sort((x, y) => string.CompareOrdinal(x.Label ?? "", y.Label ?? ""));
            for (int i = 0; i < byName.Count; i++)
            {
                w.WriteLine($"{byName[i].Label}={Oct(byName[i].Address)}");
            }
        }

        // ------------------------------------------------------------------
        // ROM image files
        // ------------------------------------------------------------------

        /// <summary>Read a prom.hex style file: one hexadecimal 32-bit word per line.</summary>
        public static uint[] ReadHexFile(string path)
        {
            string[] lines = File.ReadAllLines(path);
            var words = new List<uint>(lines.Length);
            for (int i = 0; i < lines.Length; i++)
            {
                string s = lines[i].Trim();
                if (s.Length == 0) continue;
                words.Add(Convert.ToUInt32(s, 16));
            }
            return words.ToArray();
        }

        /// <summary>Write the prom.hex format: 8 uppercase hex digits per word, LF line ends.</summary>
        public static void WriteHexFile(string path, uint[] rom)
        {
            var sb = new StringBuilder(rom.Length * 9);
            for (int i = 0; i < rom.Length; i++)
            {
                sb.Append(rom[i].ToString("X8")).Append('\n');
            }
            File.WriteAllText(path, sb.ToString());
        }

        /// <summary>Binary image: 32-bit words, big-endian.</summary>
        public static void WriteBinaryFile(string path, uint[] rom)
        {
            byte[] bytes = new byte[rom.Length * 4];
            for (int i = 0; i < rom.Length; i++)
            {
                bytes[i * 4] = (byte)(rom[i] >> 24);
                bytes[i * 4 + 1] = (byte)(rom[i] >> 16);
                bytes[i * 4 + 2] = (byte)(rom[i] >> 8);
                bytes[i * 4 + 3] = (byte)rom[i];
            }
            File.WriteAllBytes(path, bytes);
        }
    }
}
