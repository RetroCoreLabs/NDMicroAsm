//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;

namespace NDMicroAsm.ND500
{
    /// <summary>
    /// One ND-500 micro assembler mnemonic and its bit contribution to the
    /// 144-bit micro word.
    ///
    /// The ND-500 micro word is 144 bits = nine 16-bit control store parts.
    /// Words[0] = CS8 (micro word bits 143-128) ... Words[8] = CS0 (bits 15-0),
    /// i.e. the same F1..F9 order as Appendix A of ND-30.013.02 prints them.
    /// The assembler ORs the contributions of all mnemonics in an instruction;
    /// two mnemonics setting the same bit is an assembly error
    /// ("OR-ing rejected due to overlapping of MNE-values").
    /// </summary>
    public class ND500Token
    {
        /// <summary>
        /// Number of 16-bit control store parts in one ND-500 micro word.
        /// </summary>
        public const int WORD_PARTS = 9;

        /// <summary>
        /// The mnemonic as written in ND-500 micro code source.
        /// </summary>
        public string Token;
        /// <summary>
        /// The nine 16-bit parts the mnemonic contributes, CS8 (bits 143-128) first.
        /// </summary>
        public ushort[] Words;
        /// <summary>
        /// What the mnemonic means, from Appendix A of ND-30.013.02.
        /// </summary>
        public string Comment;

        /// <summary>
        /// Creates a mnemonic entry.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <param name="words">
        /// The nine 16-bit parts it contributes, CS8 first.
        /// </param>
        /// <param name="comment">
        /// What the mnemonic means.
        /// </param>
        public ND500Token(string token, ushort[] words, string comment)
        {
            Token = token;
            Words = words;
            Comment = comment;
        }
    }

    /// <summary>
    /// Token table base for the ND-500 (144-bit / 9-part) micro word family.
    /// Parallel to <see cref="ND1X0.TokensBase"/> (the 64-bit ND-110/ND-120 table),
    /// but with a per-part ushort[] value so wider micro words (ND-500: 9 parts,
    /// a future ND-5000: 8 parts) fit without squeezing into a ulong.
    /// </summary>
    public abstract class ND500TokensBase
    {
        readonly Dictionary<string, ND500Token> tokens = new Dictionary<string, ND500Token>();

        /// <summary>
        /// Finds a mnemonic by its source spelling.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <returns>
        /// The entry, or null when the table has no such mnemonic.
        /// </returns>
        public ND500Token? LookupToken(string token)
        {
            if (tokens.TryGetValue(token, out var t))
            {
                return t;
            }
            return null;
        }

        /// <summary>
        /// Number of mnemonics in the table.
        /// </summary>
        public int Count => tokens.Count;

        /// <summary>
        /// All registered tokens (insertion order). Used by the lossless
        /// disassembler to build its (field, value) -> mnemonic reverse map.
        /// </summary>
        public ND500Token[] AllTokens
        {
            get
            {
                ND500Token[] all = new ND500Token[tokens.Count];
                tokens.Values.CopyTo(all, 0);
                return all;
            }
        }

        /// <summary>
        /// OR a field value into the 9-part micro word at bit position
        /// highBit..lowBit (bit 143 = Words[0] bit 15 ... bit 0 = Words[8]
        /// bit 0). Used by the raw FIELDNAME=octal assembler syntax.
        /// </summary>
        public static void OrValueIntoWords(ushort[] words, int highBit, int lowBit, ulong value)
        {
            for (int bit = lowBit; bit <= highBit; bit++)
            {
                if (((value >> (bit - lowBit)) & 1UL) != 0)
                {
                    int part = 8 - (bit / 16);
                    int bitInPart = bit % 16;
                    words[part] |= (ushort)(1 << bitInPart);
                }
            }
        }

        /// <summary>
        /// Removes every mnemonic from the table.
        /// </summary>
        public void Clear()
        {
            tokens.Clear();
        }

        /// <summary>
        /// Fills the table with every mnemonic of the CPU the derived class describes.
        /// </summary>
        public abstract void InitializeTokens();

        /// <summary>
        /// Register a mnemonic. f1..f9 are the nine 16-bit field contributions
        /// as octal strings, F1 = CS8 (bits 143-128) first - exactly as printed
        /// in Appendix A of ND-30.013.02.
        /// </summary>
        public void AddToken(string token, string f1, string f2, string f3, string f4, string f5,
                             string f6, string f7, string f8, string f9, string comment)
        {
            ushort[] words = new ushort[ND500Token.WORD_PARTS];
            words[0] = ParseOctalWord(f1);
            words[1] = ParseOctalWord(f2);
            words[2] = ParseOctalWord(f3);
            words[3] = ParseOctalWord(f4);
            words[4] = ParseOctalWord(f5);
            words[5] = ParseOctalWord(f6);
            words[6] = ParseOctalWord(f7);
            words[7] = ParseOctalWord(f8);
            words[8] = ParseOctalWord(f9);

            tokens.Add(token, new ND500Token(token, words, comment));
        }

        static ushort ParseOctalWord(string value)
        {
            return (ushort)Convert.ToUInt16(value.Trim(), 8);
        }

        /// <summary>
        /// Writes the whole table as text, one mnemonic per line with its nine octal parts and description.
        /// </summary>
        /// <param name="strTokensFile">
        /// Path of the text file to write; an existing file is replaced.
        /// </param>
        public void DumpAllTokensToFile(string strTokensFile)
        {
            using (var w = new System.IO.StreamWriter(strTokensFile, false))
            {
                w.WriteLine($"{"Token".PadRight(17)} [CS8    CS7    CS6    CS5    CS4    CS3    CS2    CS1    CS0   ]  Description");
                w.WriteLine($"{new string('_', 17)} [{new string('_', 62)}]  {new string('_', 11)}");

                ND500Token[] all = new ND500Token[tokens.Count];
                tokens.Values.CopyTo(all, 0);
                for (int tokIdx = 0; tokIdx < all.Length; tokIdx++)
                {
                    ND500Token token = all[tokIdx];
                    string fields = "";
                    for (int i = 0; i < ND500Token.WORD_PARTS; i++)
                    {
                        fields += Convert.ToString(token.Words[i], 8).PadLeft(6, '0') + " ";
                    }
                    w.WriteLine($"{token.Token.PadRight(17)} [{fields}]  {token.Comment}");
                }
            }
        }
    }
}
