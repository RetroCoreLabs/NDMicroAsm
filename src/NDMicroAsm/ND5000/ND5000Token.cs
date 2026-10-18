//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;
using NDMicroAsm.ND500;

namespace NDMicroAsm.ND5000
{
    /// <summary>
    /// One ND-5000 micro assembler mnemonic and its bit contribution to the
    /// 128-bit micro word.
    ///
    /// The ND-5000 micro word is 128 bits = eight 16-bit control store parts.
    /// Words[0] = micro word bits 127-112 ... Words[7] = bits 15-0, matching
    /// the .DATA image byte order (byte 0 = bits 127-120, big-endian).
    /// The assembler ORs the contributions of all mnemonics in an instruction;
    /// two mnemonics setting the same bit is an assembly error
    /// ("OR-ing rejected due to overlapping of MNE-values") - same rule as
    /// the ND-500 assembler.
    /// </summary>
    public class ND5000Token
    {
        /// <summary>
        /// Number of 16-bit control store parts in one ND-5000 micro word.
        /// </summary>
        public const int WORD_PARTS = 8;

        /// <summary>
        /// The mnemonic as written in ND-5000 micro code source.
        /// </summary>
        public string Token;
        /// <summary>
        /// The eight 16-bit parts the mnemonic contributes, bits 127-112 first.
        /// </summary>
        public ushort[] Words;
        /// <summary>
        /// What the mnemonic means, from the ND-5000 micro code definition.
        /// </summary>
        public string Comment;

        /// <summary>
        /// Creates a mnemonic entry.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <param name="words">
        /// The eight 16-bit parts it contributes, bits 127-112 first.
        /// </param>
        /// <param name="comment">
        /// What the mnemonic means.
        /// </param>
        public ND5000Token(string token, ushort[] words, string comment)
        {
            Token = token;
            Words = words;
            Comment = comment;
        }
    }

    /// <summary>
    /// Token table base for the ND-5000 (128-bit / 8-part) micro word family.
    /// Parallel to <see cref="ND500TokensBase"/> (the 144-bit ND-500 table) -
    /// the repo uses the parallel-table idiom rather than a shared generic
    /// base, matching ND110/ND120.
    ///
    /// Unlike the ND-500 table (hand-transcribed 9-part octal columns), the
    /// ND-5000 token values are defined as (field name, field value) pairs:
    /// the bit position comes from <see cref="ND5000Fields"/> and the
    /// contribution is the value shifted left to the field's low bit. This also
    /// gives the disassembler an exact reverse map from (field, value) to token
    /// so a disassemble/reassemble round trip is bit-exact by construction.
    /// </summary>
    public abstract class ND5000TokensBase
    {
        readonly Dictionary<string, ND5000Token> tokens = new Dictionary<string, ND5000Token>();

        // Reverse map: field name -> (field value -> token string).
        // Used by ND5000Disassembler to find the mnemonic for an exact field value.
        readonly Dictionary<string, Dictionary<int, string>> fieldValueTokens = new Dictionary<string, Dictionary<int, string>>();

        /// <summary>
        /// Key in the reverse map for the recombined 4-bit memory operation
        /// code (bit 41 = code bit 3, bits 34-32 = code bits 2-0).
        /// </summary>
        public const string MEM_FIELD = "MEM";

        /// <summary>
        /// Finds a mnemonic by its source spelling.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <returns>
        /// The entry, or null when the table has no such mnemonic.
        /// </returns>
        public ND5000Token? LookupToken(string token)
        {
            if (tokens.TryGetValue(token, out var t))
            {
                return t;
            }
            return null;
        }

        /// <summary>
        /// Find the mnemonic token whose contribution is exactly
        /// <paramref name="value"/> in <paramref name="field"/> (a name from
        /// <see cref="ND5000Fields"/>, or <see cref="MEM_FIELD"/> for the
        /// recombined memory code). Returns null when no mnemonic covers the
        /// value - the disassembler then falls back to raw FIELDNAME=octal.
        /// </summary>
        public string? LookupFieldToken(string field, int value)
        {
            if (fieldValueTokens.TryGetValue(field, out var values))
            {
                if (values.TryGetValue(value, out var token))
                {
                    return token;
                }
            }
            return null;
        }

        /// <summary>
        /// Number of mnemonics in the table.
        /// </summary>
        public int Count => tokens.Count;

        /// <summary>
        /// Removes every mnemonic and the reverse map.
        /// </summary>
        public void Clear()
        {
            tokens.Clear();
            fieldValueTokens.Clear();
        }

        /// <summary>
        /// Fills the table with every mnemonic of the CPU the derived class describes.
        /// </summary>
        public abstract void InitializeTokens();

        /// <summary>
        /// Register a mnemonic whose 128-bit contribution is the value shifted
        /// left to the field's low bit. Duplicate token names or duplicate
        /// (field, value) pairs throw - a silent drop would break the
        /// disassembler's reverse map.
        /// </summary>
        public void AddToken(string token, string field, int value, string comment)
        {
            if (!ND5000Fields.TryLookup(field, out var f))
            {
                throw new ArgumentException($"Token {token}: unknown ND-5000 field {field}");
            }
            if ((ulong)value > f.MaxValue)
            {
                throw new ArgumentException($"Token {token}: value {value} does not fit field {field} ({f.Width} bits)");
            }

            ushort[] words = new ushort[ND5000Token.WORD_PARTS];
            OrValueIntoWords(words, f.HighBit, f.LowBit, (ulong)value);
            tokens.Add(token, new ND5000Token(token, words, comment));   // throws on duplicate name
            RegisterFieldValue(field, value, token);
        }

        /// <summary>
        /// Register a memory operation mnemonic. The 4-bit code is stored
        /// SPLIT in the micro word: code bit 3 goes to bit 41 (MEM_BIT3) and
        /// code bits 2-0 go to bits 34-32 (MEM_BITS20) - see
        /// <see cref="ND5000Fields"/> class remarks.
        /// </summary>
        public void AddMemToken(string token, int code, string comment)
        {
            if (code < 0 || code > 15)
            {
                throw new ArgumentException($"Token {token}: memory code {code} out of range 0-15");
            }

            ushort[] words = new ushort[ND5000Token.WORD_PARTS];
            OrValueIntoWords(words, 41, 41, (ulong)((code >> 3) & 1));   // code bit 3 -> micro word bit 41
            OrValueIntoWords(words, 34, 32, (ulong)(code & 7));          // code bits 2-0 -> bits 34-32
            tokens.Add(token, new ND5000Token(token, words, comment));   // throws on duplicate name
            RegisterFieldValue(MEM_FIELD, code, token);
        }

        void RegisterFieldValue(string field, int value, string token)
        {
            if (!fieldValueTokens.TryGetValue(field, out var values))
            {
                values = new Dictionary<int, string>();
                fieldValueTokens.Add(field, values);
            }
            values.Add(value, token);   // throws on duplicate (field, value)
        }

        /// <summary>
        /// OR a field value into the 8-part word at bit positions
        /// highBit..lowBit (bit 127 = Words[0] bit 15, bit 0 = Words[7] bit 0).
        /// </summary>
        public static void OrValueIntoWords(ushort[] words, int highBit, int lowBit, ulong value)
        {
            // Walk the value bit by bit; field widths are small (max 16 bits
            // for ABS_ADDR) so this is not a hot path.
            for (int bit = lowBit; bit <= highBit; bit++)
            {
                if (((value >> (bit - lowBit)) & 1) != 0)
                {
                    int part = 7 - (bit / 16);        // Words[7] holds bits 15-0
                    int bitInPart = bit % 16;
                    words[part] |= (ushort)(1 << bitInPart);
                }
            }
        }

        /// <summary>
        /// Writes the whole table as text, one mnemonic per line with its eight octal parts and description.
        /// </summary>
        /// <param name="strTokensFile">
        /// Path of the text file to write; an existing file is replaced.
        /// </param>
        public void DumpAllTokensToFile(string strTokensFile)
        {
            using (var w = new System.IO.StreamWriter(strTokensFile, false))
            {
                w.WriteLine($"{"Token".PadRight(17)} [127-112 111-96 95-80  79-64  63-48  47-32  31-16  15-0  ]  Description");
                w.WriteLine($"{new string('_', 17)} [{new string('_', 55)}]  {new string('_', 11)}");

                ND5000Token[] all = new ND5000Token[tokens.Count];
                tokens.Values.CopyTo(all, 0);
                for (int tokIdx = 0; tokIdx < all.Length; tokIdx++)
                {
                    ND5000Token token = all[tokIdx];
                    string fields = "";
                    for (int i = 0; i < ND5000Token.WORD_PARTS; i++)
                    {
                        fields += Convert.ToString(token.Words[i], 8).PadLeft(6, '0') + " ";
                    }
                    w.WriteLine($"{token.Token.PadRight(17)} [{fields}]  {token.Comment}");
                }
            }
        }
    }
}
