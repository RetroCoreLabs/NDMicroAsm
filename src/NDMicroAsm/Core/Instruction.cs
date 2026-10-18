//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;

namespace NDMicroAsm.Core
{
    /// <summary>
    /// One micro instruction after tokenising: the mnemonics of a source line and where they go.
    /// </summary>
    public class Instruction
    {
        /// <summary>
        /// One-based source line, for error messages.
        /// </summary>
        public int LineNo;

        /// <summary>
        /// The control store address the instruction is assembled to.
        /// </summary>
        public int Address;

        /// <summary>
        /// The combined <see cref="ND1X0.Constants"/> flags of every mnemonic on the line; the assembler
        /// checks them after translation.
        /// </summary>
        public ushort CompilerDetails;

        /// <summary>
        /// The mnemonics, raw field values and label references of the line, in source order.
        /// </summary>
        public List<string> Args = new List<string>();
    };
}
