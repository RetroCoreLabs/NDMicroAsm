//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;

namespace NDMicroAsm.ND10
{
    /// <summary>
    /// One named bit field of the 32-bit NORD-10 micro word.
    /// </summary>
    public readonly struct ND10Field
    {
        /// <summary>
        /// The field name as the manual and the disassembler print it.
        /// </summary>
        public readonly string Name;

        /// <summary>
        /// The most significant bit of the field, 31 down to 0.
        /// </summary>
        public readonly int HighBit;

        /// <summary>
        /// The least significant bit of the field, 31 down to 0.
        /// </summary>
        public readonly int LowBit;

        /// <summary>
        /// Defines a field by its bit range.
        /// </summary>
        /// <param name="name">
        /// The field name.
        /// </param>
        /// <param name="highBit">
        /// The most significant bit.
        /// </param>
        /// <param name="lowBit">
        /// The least significant bit.
        /// </param>
        public ND10Field(string name, int highBit, int lowBit)
        {
            Name = name;
            HighBit = highBit;
            LowBit = lowBit;
        }

        /// <summary>
        /// Number of bits in the field.
        /// </summary>
        public int Width => HighBit - LowBit + 1;

        /// <summary>
        /// Highest value that fits in the field.
        /// </summary>
        public uint MaxValue => Width == 32 ? uint.MaxValue : (1u << Width) - 1;

        /// <summary>
        /// The field's bits in place in the micro word.
        /// </summary>
        public uint Mask => MaxValue << LowBit;

        /// <summary>
        /// Reads the field out of a micro word.
        /// </summary>
        /// <param name="word">
        /// The 32-bit NORD-10 micro word.
        /// </param>
        /// <returns>
        /// The field value, right-aligned.
        /// </returns>
        public uint Extract(uint word)
        {
            return (word >> LowBit) & MaxValue;
        }
    }

    /// <summary>
    /// Named bit fields of the NORD-10 micro word, used by the lossless disassembler to walk a
    /// word and to print bits that have no mnemonic as an octal constant.
    /// </summary>
    /// <remarks>
    /// Positions follow figure 1.1 of ND-06.010.01 and the MICMAC reconstruction; see
    /// <see cref="ND10Tokens"/> for the full layout. The fields overlap on purpose (the same bits
    /// mean different things in the four formats); each name is one position, nothing more.
    /// </remarks>
    public static class ND10Fields
    {
        /// <summary>
        /// Bits 31-30, the format: 0 ARITHMETIC, 1 INTERBLOCK, 2 JUMP, 3 LOOP.
        /// </summary>
        public static readonly ND10Field OP = new ND10Field("OP", 31, 30);

        // ARITHMETIC / INTERBLOCK

        /// <summary>
        /// Bit 29, ARITHMETIC and INTERBLOCK: logical (1) or arithmetic (0) ALU operation.
        /// </summary>
        public static readonly ND10Field LOG = new ND10Field("LOG", 29, 29);

        /// <summary>
        /// Bits 28-25, ARITHMETIC and INTERBLOCK: the ALU function select of table 2.1.
        /// </summary>
        public static readonly ND10Field ALU = new ND10Field("ALU", 28, 25);

        /// <summary>
        /// Bit 24, ARITHMETIC and INTERBLOCK: most significant (1) or least significant (0) unit.
        /// </summary>
        public static readonly ND10Field UNIT = new ND10Field("UNIT", 24, 24);

        /// <summary>
        /// Bits 23-21, ARITHMETIC and INTERBLOCK: the cycle specification (memory and effective address).
        /// </summary>
        public static readonly ND10Field CYCLE = new ND10Field("CYCLE", 23, 21);

        /// <summary>
        /// Bit 20: change program level (ARITHMETIC) or DSPL direction (INTERBLOCK).
        /// </summary>
        public static readonly ND10Field CHLEV = new ND10Field("CHLEV", 20, 20);

        /// <summary>
        /// Bit 19: save carry and overflow.
        /// </summary>
        public static readonly ND10Field SACO = new ND10Field("SACO", 19, 19);

        /// <summary>
        /// Bits 18-16: the OR specification, which instruction register bits the OR logic copies in.
        /// </summary>
        public static readonly ND10Field OR = new ND10Field("OR", 18, 16);

        /// <summary>
        /// Bit 15: conditional execution.
        /// </summary>
        public static readonly ND10Field COND = new ND10Field("COND", 15, 15);

        /// <summary>
        /// Bits 14-12: the test condition that goes with <see cref="COND"/>.
        /// </summary>
        public static readonly ND10Field TC = new ND10Field("TC", 14, 12);

        /// <summary>
        /// Bits 15-12, INTERBLOCK: the program level (LE0 to LE17), or the bit number of a bit-mask B operand.
        /// </summary>
        public static readonly ND10Field LEVEL = new ND10Field("LEVEL", 15, 12);

        /// <summary>
        /// Bits 11-8: the destination register.
        /// </summary>
        public static readonly ND10Field DEST = new ND10Field("DEST", 11, 8);

        /// <summary>
        /// Bits 7-4: the B operand.
        /// </summary>
        public static readonly ND10Field B = new ND10Field("B", 7, 4);

        /// <summary>
        /// Bits 3-0: the A operand.
        /// </summary>
        public static readonly ND10Field A = new ND10Field("A", 3, 0);

        // JUMP

        /// <summary>
        /// Bit 29, JUMP: take the jump address from the computed address register.
        /// </summary>
        public static readonly ND10Field CAR = new ND10Field("CAR", 29, 29);

        /// <summary>
        /// Bit 28, JUMP: privileged instruction interrupt.
        /// </summary>
        public static readonly ND10Field PRIV = new ND10Field("PRIV", 28, 28);

        /// <summary>
        /// Bits 27-16, JUMP: no mnemonic uses them; printed as a raw value when set.
        /// </summary>
        public static readonly ND10Field UNUSED27_16 = new ND10Field("UNUSED27_16", 27, 16);

        /// <summary>
        /// Bits 11-0, JUMP: the absolute ROM address.
        /// </summary>
        public static readonly ND10Field ADDR = new ND10Field("ADDR", 11, 0);

        // LOOP

        /// <summary>
        /// Bits 24-20, LOOP: the alternative ALU function, used when SH31 or SH0 selects it.
        /// </summary>
        public static readonly ND10Field ALT = new ND10Field("ALT", 24, 20);

        /// <summary>
        /// Bit 18, LOOP: shift direction and type come from the instruction register.
        /// </summary>
        public static readonly ND10Field ORSHT = new ND10Field("ORSHT", 18, 18);

        /// <summary>
        /// Bits 17-16, LOOP: no mnemonic uses them; printed as a raw value when set.
        /// </summary>
        public static readonly ND10Field UNUSED17_16 = new ND10Field("UNUSED17_16", 17, 16);

        /// <summary>
        /// Bit 15, LOOP: shift right (1) or left (0).
        /// </summary>
        public static readonly ND10Field SHR = new ND10Field("SHR", 15, 15);

        /// <summary>
        /// Bits 14-13, LOOP: shift type, 1 rotate (SHRO), 2 zero end input (SHZE).
        /// </summary>
        public static readonly ND10Field SHT = new ND10Field("SHT", 14, 13);

        /// <summary>
        /// Bit 12, LOOP: 32-bit shift.
        /// </summary>
        public static readonly ND10Field SH32 = new ND10Field("SH32", 12, 12);

        /// <summary>
        /// Bit 11, LOOP: no mnemonic uses it; printed as a raw value when set.
        /// </summary>
        public static readonly ND10Field UNUSED11 = new ND10Field("UNUSED11", 11, 11);

        /// <summary>
        /// Bit 10, LOOP: the M bit, set each pass as part of ORSHT.
        /// </summary>
        public static readonly ND10Field M = new ND10Field("M", 10, 10);

        /// <summary>
        /// Bits 9-8, LOOP: rounding (TGSH0, TGAC0, TGS0).
        /// </summary>
        public static readonly ND10Field TG = new ND10Field("TG", 9, 8);

        /// <summary>
        /// Bits 3-2, LOOP: loop termination (TSC0, TSH31, TSH22).
        /// </summary>
        public static readonly ND10Field TERM = new ND10Field("TERM", 3, 2);

        /// <summary>
        /// Bit 1, LOOP: end input for division.
        /// </summary>
        public static readonly ND10Field ENDID = new ND10Field("ENDID", 1, 1);

        /// <summary>
        /// Bit 0, LOOP: use the alternative ALU function when SH0 = 1 (ASH0) instead of SH31 (ASH31).
        /// </summary>
        public static readonly ND10Field ASH = new ND10Field("ASH", 0, 0);

        static readonly Dictionary<string, ND10Field> byName = Build();

        static Dictionary<string, ND10Field> Build()
        {
            var d = new Dictionary<string, ND10Field>();
            ND10Field[] all =
            {
                OP, LOG, ALU, UNIT, CYCLE, CHLEV, SACO, OR, COND, TC, LEVEL, DEST, B, A,
                CAR, PRIV, UNUSED27_16, ADDR,
                ALT, ORSHT, UNUSED17_16, SHR, SHT, SH32, UNUSED11, M, TG, TERM, ENDID, ASH
            };
            for (int i = 0; i < all.Length; i++)
            {
                d.Add(all[i].Name, all[i]);
            }
            return d;
        }

        /// <summary>
        /// Finds a field by its name, as written in a FIELDNAME=value source token.
        /// </summary>
        /// <param name="name">
        /// The field name.
        /// </param>
        /// <param name="field">
        /// The field when found.
        /// </param>
        /// <returns>
        /// True when <paramref name="name"/> is a known field.
        /// </returns>
        public static bool TryLookup(string name, out ND10Field field)
        {
            return byName.TryGetValue(name, out field);
        }

        /// <summary>
        /// The source form of a field value that has no mnemonic: the bits in place, as one
        /// octal constant.
        /// </summary>
        /// <remarks>
        /// MICMAC ORs a bare octal number into the word, so this is all the syntax needed (the
        /// manual's listing writes jump addresses the same way).
        /// </remarks>
        /// <param name="field">
        /// The field the value belongs to.
        /// </param>
        /// <param name="value">
        /// The field value, right-aligned.
        /// </param>
        /// <returns>
        /// The octal constant to write in the source.
        /// </returns>
        public static string Raw(ND10Field field, uint value)
        {
            return Convert.ToString((long)(value << field.LowBit), 8);
        }
    }
}
