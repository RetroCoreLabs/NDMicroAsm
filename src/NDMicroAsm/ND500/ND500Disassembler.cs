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
    /// Lossless ND-500 micro code disassembler.
    ///
    /// Given a 144-bit micro word (nine 16-bit parts, Words[0] = CS8 = bits
    /// 143-128 ... Words[8] = CS0 = bits 15-0) it emits an ordered token list
    /// such that reassembling the tokens with <see cref="ND500Compiler"/>
    /// reproduces the word EXACTLY:
    ///
    ///   - bits 143-32 are walked using the canonical non-overlapping field
    ///     partition from <see cref="ND500Fields"/>
    ///   - a field whose value is zero is omitted (zero contributes nothing,
    ///     so omission is round-trip safe)
    ///   - a nonzero field emits its Appendix A mnemonic when one exists whose
    ///     WHOLE contribution is exactly that value in that field, else the
    ///     raw fallback FIELDNAME=octal
    ///   - bits 31-0 (the argument area: long argument / CSA address / short
    ///     argument / EA inhibit bits) are ALWAYS emitted as raw arguments:
    ///     'hi,lo' (long argument syntax, bits 31-16 and 15-0) when bits 31-16
    ///     are nonzero, else a single octal short argument when bits 15-0 are
    ///     nonzero. No semantic interpretation - lossless by construction.
    ///
    /// The (field, value) -> mnemonic reverse map is built once from
    /// <see cref="ND500Tokens"/> (the generated Appendix A table): a token
    /// qualifies for the map when all its set bits fall inside ONE partition
    /// field. Tokens spanning several fields, or contributing to the argument
    /// area, never enter the map - words using them still round-trip via the
    /// raw fallbacks. Zero-valued pseudo mnemonics (IFT, SHARG, TYP,W, ...)
    /// contribute no bits and are simply never emitted.
    ///
    /// When several mnemonics share an encoding (Appendix A has aliases) the
    /// alphabetically first one is chosen so output is deterministic.
    /// </summary>
    public class ND500Disassembler
    {
        readonly ND500Tokens tokens;
        readonly Dictionary<string, string> fieldValueToToken = new Dictionary<string, string>();

        // Part indexes into the 9-part word (Words[0] = CS8 first)
        const int CS1 = 7;   // micro word bits 31-16
        const int CS0 = 8;   // micro word bits 15-0

        /// <summary>
        /// Creates a disassembler with the Appendix A mnemonic table and its reverse map built.
        /// </summary>
        public ND500Disassembler()
        {
            tokens = new ND500Tokens();
            tokens.InitializeTokens();
            BuildReverseMap();
        }

        /// <summary>
        /// Look up the mnemonic for an exact (field, value) pair; null when no
        /// single-field mnemonic covers the value (disassembly falls back to
        /// raw FIELDNAME=octal).
        /// </summary>
        public string? LookupFieldToken(string fieldName, int value)
        {
            if (fieldValueToToken.TryGetValue(fieldName + ":" + value, out var t))
            {
                return t;
            }
            return null;
        }

        void BuildReverseMap()
        {
            var partition = ND500Fields.Partition;

            ND500Token[] allTokens = tokens.AllTokens;
            for (int tokIdx = 0; tokIdx < allTokens.Length; tokIdx++)
            {
                ND500Token token = allTokens[tokIdx];
                // Find every set bit; reject tokens touching the argument
                // area (bits 31-0) or more than one partition field
                int fieldIndex = -1;
                bool eligible = true;
                bool anyBit = false;

                for (int part = 0; part < ND500Token.WORD_PARTS && eligible; part++)
                {
                    ushort w = token.Words[part];
                    if (w == 0) continue;

                    for (int bitInPart = 0; bitInPart < 16; bitInPart++)
                    {
                        if ((w & (1 << bitInPart)) == 0) continue;

                        anyBit = true;
                        int bit = (8 - part) * 16 + bitInPart;
                        if (bit < 32)
                        {
                            eligible = false;   // argument area - raw emit covers it
                            break;
                        }

                        int idx = FindPartitionField(partition, bit);
                        if (fieldIndex < 0)
                        {
                            fieldIndex = idx;
                        }
                        else if (fieldIndex != idx)
                        {
                            eligible = false;   // spans several fields
                            break;
                        }
                    }
                }

                if (!eligible || !anyBit || fieldIndex < 0) continue;

                var f = partition[fieldIndex];
                int value = ExtractField(token.Words, f.HighBit, f.LowBit);
                string key = f.Name + ":" + value;

                // Aliases: keep the alphabetically first mnemonic (deterministic)
                if (!fieldValueToToken.TryGetValue(key, out var existing) ||
                    string.CompareOrdinal(token.Token, existing) < 0)
                {
                    fieldValueToToken[key] = token.Token;
                }
            }
        }

        static int FindPartitionField(ND500Field[] partition, int bit)
        {
            for (int i = 0; i < partition.Length; i++)
            {
                if (bit <= partition[i].HighBit && bit >= partition[i].LowBit)
                {
                    return i;
                }
            }
            throw new InvalidOperationException($"Bit {bit} not covered by the ND-500 field partition");
        }

        /// <summary>
        /// Disassemble one 144-bit micro word into an ordered token list that
        /// reassembles to the exact word. Field order: partition high to low
        /// (bits 143-32), then the bits 31-0 argument.
        /// </summary>
        public List<string> Disassemble(ushort[] word)
        {
            if (word == null || word.Length != ND500Token.WORD_PARTS)
            {
                throw new ArgumentException("ND-500 micro word must be 9 x 16-bit parts");
            }

            var m = new List<string>();
            var partition = ND500Fields.Partition;

            for (int i = 0; i < partition.Length; i++)
            {
                var f = partition[i];
                int v = ExtractField(word, f.HighBit, f.LowBit);
                if (v == 0) continue;   // zero contributes nothing - omission is round-trip safe

                string? token = LookupFieldToken(f.Name, v);
                if (token != null)
                {
                    m.Add(token);
                }
                else
                {
                    m.Add(f.Name + "=" + Convert.ToString(v, 8));
                }
            }

            // Bits 31-0: raw long/short argument (covers CSA address, EA
            // inhibit bits and the short argument without interpretation)
            if (word[CS1] != 0)
            {
                m.Add(Convert.ToString(word[CS1], 8) + "," + Convert.ToString(word[CS0], 8));
            }
            else if (word[CS0] != 0)
            {
                m.Add(Convert.ToString(word[CS0], 8));
            }

            return m;
        }

        /// <summary>
        /// Extract micro word bits highBit..lowBit from the 9-part word
        /// (bit 143 = Words[0] bit 15 ... bit 0 = Words[8] bit 0).
        /// Field widths are at most 16 bits so an int suffices.
        /// </summary>
        public static int ExtractField(ushort[] word, int highBit, int lowBit)
        {
            int value = 0;
            for (int bit = highBit; bit >= lowBit; bit--)
            {
                int part = 8 - (bit / 16);
                int bitInPart = bit % 16;
                value = (value << 1) | ((word[part] >> bitInPart) & 1);
            }
            return value;
        }
    }
}
