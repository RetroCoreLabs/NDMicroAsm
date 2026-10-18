//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

namespace NDMicroAsm
{
    /// <summary>
    /// One ND-110 or ND-120 mnemonic and the bits it contributes to the 64-bit micro word.
    /// </summary>
    /// <remarks>
    /// The assembler ORs the contributions of every mnemonic on a line into one word; two
    /// mnemonics that set the same bit are an error. The token tables come from the ND-110
    /// and ND-120 Microprogrammer's Guide, ND-06.031.1 EN.
    /// </remarks>
    public class ND1X0Token
    {
        /// <summary>
        /// The mnemonic as written in micro code source, for example <c>A,D</c> or <c>T,JMP</c>.
        /// </summary>
        public string Token;

        /// <summary>
        /// The bits the mnemonic sets in the 64-bit micro word.
        /// </summary>
        public ulong Value;

        /// <summary>
        /// The description of the mnemonic from the Microprogrammer's Guide, printed in the details file.
        /// </summary>
        public string Comment;

        /// <summary>
        /// <see cref="Constants"/> flags that say what the mnemonic contributes and what it needs.
        /// </summary>
        public ushort CompilerDetails;

        /// <summary>
        /// Creates a mnemonic entry.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <param name="value">
        /// The bits it sets in the 64-bit micro word.
        /// </param>
        /// <param name="comment">
        /// The description from the Microprogrammer's Guide.
        /// </param>
        /// <param name="compilerDetails">
        /// <see cref="Constants"/> flags for the line checks.
        /// </param>
        public ND1X0Token(string token, ulong value, string comment, ushort compilerDetails)
        {
            Token = token;
            Value = value;
            Comment = comment;
            CompilerDetails = compilerDetails;
        }
    }
}
