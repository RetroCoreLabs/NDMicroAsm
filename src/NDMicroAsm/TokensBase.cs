//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;

namespace NDMicroAsm
{

    internal abstract class TokensBase
    {
        Dictionary<string, ND1X0Token> tokens = new Dictionary<string, ND1X0Token>();

        public ND1X0Token? LookupToken(string token)
        {
            if (tokens.TryGetValue(token, out var t))
            {
                return t;
            }
            return null;
        }


        internal void Clear()
        {
            tokens.Clear();
        }

        internal abstract void InitializeTokens();

        internal void AddToken(string token, string w4, string w3, string w2, string w1, string comment, ushort compilerDetails = 0)
        {
            //Debug.WriteLine(token);
            ulong value = 0;
            value = (uint)ParseIntValue(w4);

            value = value << 16;
            value |= (uint)ParseIntValue(w3);

            value = value << 16;
            value |= (uint)ParseIntValue(w2);

            value = value << 16;
            value |= (uint)ParseIntValue(w1);


            ND1X0Token nd110token = new ND1X0Token(token, value, comment, compilerDetails);
            tokens.Add(token, nd110token);
        }

        /// <summary>
        /// Redefine an already-registered token in the in-memory collection
        /// (used by post-load version fixups, e.g.
        /// ND120Tokens.AdjustTokensForVersionL where microcode version L drops
        /// the DLY1 bit from the B,P / B,B / B,X register-select tokens).
        /// </summary>
        internal void ReplaceToken(string token, string w4, string w3, string w2, string w1, string comment, ushort compilerDetails = 0)
        {
            tokens.Remove(token);
            AddToken(token, w4, w3, w2, w1, comment, compilerDetails);
        }

        internal int ParseIntValue(string value)
        {
            value = value.Trim();
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

        internal void DumpAllTokensToFile(string strTokensFile)
        {
            // Write header (overwrite file if exists)
            System.IO.File.WriteAllText(strTokensFile,
                $"{"Token".PadRight(17)} [{"Hexadecimal".PadRight(18)}|{"Binary (Grouped 64-bit)".PadRight(68)} ]     Description {Environment.NewLine}");

            // Underline line
            System.IO.File.AppendAllText(strTokensFile,
                $"{new string('_', 17)} {new string('_', 19)}|{"_".PadRight(69, '_')}]     {"".PadRight("Description".Length, '_')}{Environment.NewLine}");

            ND1X0Token[] all = new ND1X0Token[tokens.Count];
            tokens.Values.CopyTo(all, 0);
            for (int tokIdx = 0; tokIdx < all.Length; tokIdx++)
            {
                ND1X0Token token = all[tokIdx];
                ulong value = token.Value;

                // Hexadecimal, zero-padded to 16 digits
                string hex = $"0x{value:X16}";

                // Binary, zero-padded to 64 bits

                string binary = Convert.ToString((long)value, 2).PadLeft(64, '0');


                string grouped = binary.Substring(0, 9) + "_" +   // 63–55  ALU INSTRUCTION
                    binary.Substring(9, 13) + "_" +   // 54–42  ALU EXTERNAL CONTROL/SELECT
                    binary.Substring(22, 5) + "_" +   // 41–37  INTERNAL DATA BUS CONTROL
                    binary.Substring(27, 5) + "_" +   // 36–32  COMMAND CODE
                    binary.Substring(32, 12) + "_" +  // 31–20  SEQUENCING CONTROL
                    binary.Substring(44, 4) + "_" +   // 19–16  B OPERAND
                    binary.Substring(48, 16);         // 15–0   COMBINED DATA FIELD

                System.IO.File.AppendAllText(strTokensFile, $"{token.Token.PadRight(17)} [{hex}|{grouped}  => {token.Comment}]" + Environment.NewLine);
            }
        }
    }
}
