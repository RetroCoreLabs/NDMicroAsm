//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

namespace NDMicroAsm.ND1X0
{
    /// <summary>
    /// Bit flags carried in <see cref="ND1X0Token.CompilerDetails"/> by the ND-110/ND-120 mnemonics.
    /// </summary>
    /// <remarks>
    /// The flags say what a mnemonic contributes to a micro instruction, or what it needs the
    /// other mnemonics on the same line to contribute. After the mnemonics of one line are
    /// combined, the assembler checks the combined flags: a Require flag without its matching
    /// Is flag, a missing IDB source, or a conditional instruction without a false-branch
    /// address and stack operation is reported for that line.
    /// </remarks>
    static public class Constants
    {
        /// <summary>
        /// The mnemonic selects the A operand (the A,x register tokens).
        /// </summary>
        static public readonly ushort IsA = 1 << 0;

        /// <summary>
        /// The mnemonic selects the B operand (the B,x register tokens).
        /// </summary>
        static public readonly ushort IsB = 1 << 1;

        /// <summary>
        /// Both <see cref="IsA"/> and <see cref="IsB"/>.
        /// </summary>
        static public readonly ushort IsA_B = (ushort)(IsA | IsB);

        /// <summary>
        /// The mnemonic needs an A operand on the same line.
        /// </summary>
        static public readonly ushort RequireA = 1 << 2;

        /// <summary>
        /// The mnemonic needs a B operand on the same line.
        /// </summary>
        static public readonly ushort RequireB = 1 << 3;

        /// <summary>
        /// Both <see cref="RequireA"/> and <see cref="RequireB"/>.
        /// </summary>
        static public readonly ushort RequireA_B = ((ushort)(RequireA | RequireB));

        /// <summary>
        /// The mnemonic is an interrupt system command (the PIC,x tokens).
        /// </summary>
        static public readonly ushort IsPIC = 1 << 4;

        /// <summary>
        /// The mnemonic needs an interrupt system command on the same line.
        /// </summary>
        static public readonly ushort RequirePIC = 1 << 5;

        /// <summary>
        /// The mnemonic selects the IDB source (the IDBS,x tokens).
        /// </summary>
        static public readonly ushort IsIDBS = 1 << 6;

        /// <summary>
        /// The mnemonic gives the next address for the true sequence (the T,x tokens).
        /// </summary>
        static public readonly ushort IsTrueAddr = 1 << 7;

        /// <summary>
        /// The mnemonic gives the stack operation for the true sequence.
        /// </summary>
        static public readonly ushort IsTrueStack = 1 << 8;

        /// <summary>
        /// The mnemonic gives the next address for the false sequence (the F,x tokens).
        /// </summary>
        static public readonly ushort IsFalseAddr = 1 << 9;

        /// <summary>
        /// The mnemonic gives the stack operation for the false sequence.
        /// </summary>
        static public readonly ushort IsFalseStack = 1 << 10;

        /// <summary>
        /// The mnemonic makes the instruction conditional (the COND,x tokens), so a false
        /// sequence address and stack operation are needed too.
        /// </summary>
        static public readonly ushort IsCond = 1 << 11;
    }
}
