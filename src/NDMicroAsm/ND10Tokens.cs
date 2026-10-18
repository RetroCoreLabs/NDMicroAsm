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
    /// <summary>
    /// One NORD-10 MICMAC mnemonic and the bits it contributes to the 32-bit
    /// micro word. The NORD-10 assembler (MICMAC, "MICRO MAC") ORs the
    /// contributions of every mnemonic on a line into one ROM word; two
    /// mnemonics that set the same bit are an error, as in the later ND micro
    /// assemblers.
    /// </summary>
    public class ND10Token
    {
        /// <summary>
        /// The mnemonic as written in MICMAC source.
        /// </summary>
        public string Token;
        /// <summary>
        /// The bits the mnemonic sets in the 32-bit micro word.
        /// </summary>
        public uint Value;
        /// <summary>
        /// What the mnemonic means, from section 3.1 of ND-06.010.01.
        /// </summary>
        public string Comment;

        /// <summary>
        /// Creates a mnemonic entry.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <param name="value">
        /// The bits it sets in the micro word.
        /// </param>
        /// <param name="comment">
        /// What the mnemonic means.
        /// </param>
        public ND10Token(string token, uint value, string comment)
        {
            Token = token;
            Value = value;
            Comment = comment;
        }
    }

    /// <summary>
    /// NORD-10 micro word mnemonic table.
    ///
    /// Sources, in order of authority:
    ///
    ///  1. ND-06.010.01 "NORD-10/S MICROPROGRAM" - chapter 1 (figure 1.1, the bit
    ///     assignment of the four micro instruction formats), chapter 2 (the
    ///     four instructions, tables 2.1 and figures 2.2-2.10) and section 3.1,
    ///     the MICMAC mnemonic table (pages 31-37). The manual names every
    ///     mnemonic, but its figures with the bit numbers survived OCR badly.
    ///  2. The bit positions were taken from Anders Magnusson's reconstruction
    ///     of MICMAC (micmac.awk / dismac.c in the nord10-microcode tools,
    ///     2024), which round-trips the real 1k PROM dump. Every value below
    ///     was then checked against the two real PROM dumps by the round-trip
    ///     unit tests in TestND110/TestND10RoundTrip.cs: both dumps disassemble
    ///     with this table and reassemble bit for bit.
    ///
    /// Four names in the manual's table have no known bit value and are not in
    /// this table: ORCAR (OR with CAR), SHAR (arithmetic shift), SHLI (link
    /// end input) and DNO (device number). Neither PROM dump has a word that
    /// needs them.
    ///
    /// Micro word layout (ROM bits 31-0, figure 1.1 of the manual):
    ///
    ///   bits 31-30  format: 00 ARITHMETIC, 01 INTERBLOCK, 10 JUMP, 11 LOOP
    ///
    ///   ARITHMETIC / INTERBLOCK
    ///   bit  29     logical (1) or arithmetic (0) ALU operation (LOG.. / AR..)
    ///   bits 28-25  ALU function select (table 2.1)
    ///   bit  24     most significant unit (..M) or least significant unit (..L)
    ///   bits 23-21  cycle specification (memory / effective address)
    ///   bit  20     CHLEV change program level (ARITH), DSPL direction (INTB)
    ///   bit  19     SACO save carry and overflow
    ///   bits 18-16  OR specification (which IR bits the OR logic copies in)
    ///   bit  15     conditional execution (CARM/CARL/CLOGM/CLOGL)
    ///   bits 14-12  test condition (with bit 15), or the bit number of the
    ///               bit-mask B operand (B,B0..B,B17 use bits 15-12), or the
    ///               program level (INTERBLOCK, LE0..LE17 use bits 15-12)
    ///   bits 11-8   destination register
    ///   bits 7-4    B operand
    ///   bits 3-0    A operand
    ///
    ///   JUMP
    ///   bit  29     ,CAR   jump address from the computed address register
    ///   bit  28     PRIV   privileged instruction interrupt
    ///   bit  15     conditional jump (CJMP), bits 14-12 the test condition
    ///   bits 11-0   absolute ROM address
    ///
    ///   LOOP
    ///   bits 29-25  ALU function (as ARITHMETIC, bit 29 = logical)
    ///   bits 24-20  alternative ALU function (used when SH31 or SH0 says so)
    ///   bit  19     SACO
    ///   bit  18     ORSHT  shift direction and type come from IR (with bit 10)
    ///   bit  15     SHR    shift right (0 = shift left)
    ///   bits 14-13  shift type: 1 SHRO rotate, 2 SHZE zero end input
    ///   bit  12     SH32   32-bit shift
    ///   bit  10     the M bit is set each pass (part of ORSHT)
    ///   bits 9-8    TG rounding: TGSH0, TGAC0, TGS0
    ///   bits 7-4    B operand (AC, HAC, 2AC)
    ///   bits 3-2    termination: TSC0, TSH31, TSH22
    ///   bit  1      ENDID  end input for division
    ///   bit  0      ASH0   alternative ALU when SH0 = 1 (ASH31 when 0)
    /// </summary>
    public class ND10Tokens
    {
        readonly Dictionary<string, ND10Token> tokens = new Dictionary<string, ND10Token>();
        readonly List<ND10Token> ordered = new List<ND10Token>();

        /// <summary>
        /// Number of mnemonics in the table.
        /// </summary>
        public int Count => tokens.Count;

        /// <summary>All registered tokens in registration order.</summary>
        public List<ND10Token> AllTokens => ordered;

        /// <summary>
        /// Finds a mnemonic by its source spelling.
        /// </summary>
        /// <param name="token">
        /// The mnemonic as written in source.
        /// </param>
        /// <returns>
        /// The entry, or null when the table has no such mnemonic.
        /// </returns>
        public ND10Token? LookupToken(string token)
        {
            if (tokens.TryGetValue(token, out var t))
            {
                return t;
            }
            return null;
        }

        static uint Bit(int n)
        {
            return 1u << n;
        }

        /// <summary>Value placed with its least significant bit at <paramref name="lowBit"/>.</summary>
        static uint At(int lowBit, uint value)
        {
            return value << lowBit;
        }

        void Add(string token, uint value, string comment)
        {
            if (tokens.ContainsKey(token))
            {
                throw new InvalidOperationException($"Duplicate NORD-10 mnemonic {token}");
            }
            var t = new ND10Token(token, value, comment);
            tokens.Add(token, t);
            ordered.Add(t);
        }

        // Format bits (31-30) and the unit / logical / conditional bits that
        // the instruction mnemonics carry (manual section 3.1)
        const uint OP_INTB = 1u << 30;
        const uint OP_JUMP = 2u << 30;
        const uint OP_LOOP = 3u << 30;
        const uint LOG = 1u << 29;   // logical operation (MIR 29 = 1)
        const uint MOST = 1u << 24;  // most significant unit
        const uint COND = 1u << 15;  // conditional execution

        /// <summary>
        /// Fills the table with every MICMAC mnemonic and its bit value.
        /// </summary>
        /// <remarks>
        /// Clears any earlier contents first, so it can be called again to reset the table.
        /// </remarks>
        public void InitializeTokens()
        {
            tokens.Clear();
            ordered.Clear();

            // ---- Instruction mnemonics ------------------------------------------
            Add("ARL", 0, "Arithmetic operation least significant unit");
            Add("ARM", MOST, "Arithmetic operation most significant unit");
            Add("CARL", COND, "Conditional Arithmetic least significant unit");
            Add("CARM", COND | MOST, "Conditional Arithmetic most significant unit");
            Add("LOGL", LOG, "Logical operation least significant unit");
            Add("LOGM", LOG | MOST, "Logical operation most significant unit");
            Add("CLOGL", LOG | COND, "Conditional logical operation, least significant unit (formed like CLOGM; not in the manual's table)");
            Add("CLOGM", LOG | COND | MOST, "Conditional logical operation most significant unit");
            Add("IARL", OP_INTB, "Interblock arithmetic operation, least significant unit (formed like IARM; not in the manual's table)");
            Add("IARM", OP_INTB | MOST, "Interblock arithmetic operation most significant unit");
            Add("ILOGL", OP_INTB | LOG, "Interblock logical operation, least significant unit (formed like ILOGM; not in the manual's table)");
            Add("ILOGM", OP_INTB | LOG | MOST, "Interblock logical operation most significant unit");
            Add("JMP", OP_JUMP, "Jump");
            Add("CJMP", OP_JUMP | COND, "Conditional jump");
            Add(",CAR", Bit(29), "Jump address from CAR (Computed Address Register)");
            Add("JMP,CAR", OP_JUMP | Bit(29), "Jump via CAR - the listing writes JMP,CAR as one word");
            Add("CJMP,CAR", OP_JUMP | COND | Bit(29), "Conditional jump via CAR (formed like JMP,CAR)");
            Add("CALL", OP_JUMP, "Jump to subroutine - the listing writes CALL OUTCH; the bits are a plain JMP, the return address was saved by the word before (ARM A,IO B,MPC)");
            Add("PRIV", Bit(28), "Privileged instructions");
            Add("LOOP", OP_LOOP, "Loop instruction");

            // ---- Test conditions (bits 14-12; bit 15 comes from CARM/CJMP) ---------
            // The listing writes the zero test as ZERO ("CJMP ZERO ZTAD"); the
            // mnemonic table (3.1) lists it as Z. Both are accepted. Table 2.1
            // also calls the logical ALU function 14 (octal) "LOGICAL 0 - ZERO";
            // neither PROM dump uses that function, so it has no mnemonic here
            // and the disassembler would print it as the octal constant
            // 3000000000 (bits 28-27 in place).
            Add("ZERO", At(12, 0), "Test for zero (condition 0) - the listing's spelling");
            Add("Z", At(12, 0), "Test for zero");
            Add("COND", Bit(15), "Condition bit set bit 15 in ROM");
            Add("CO17", At(12, 7), "Conditional bit set and condition 7");
            Add("SPOS", At(12, 1), "Sign positive");
            Add("POS", At(12, 2), "Test for positive");
            Add("POSM", At(12, 3), "Test for positive magnitude");
            Add("NZERO", At(12, 4), "Test for not zero");
            Add("SNEG", At(12, 5), "Sign negative");
            Add("NEG", At(12, 6), "Test for negative");
            Add("NEGM", At(12, 7), "Test for negative magnitude");
            Add("GREM", At(12, 3), "Greater Magnitude (the listing writes CJMP GREM for condition 3, the same bits as POSM)");

            // ---- Cycle specification (bits 23-21) ------------------------------------
            Add("CEATR", At(21, 1), "Cycle 1, Effective address to R -- no request");
            Add("CPTR", At(21, 2), "Cycle 2, Current P register to R register");
            Add("CFC", At(21, 3), "Cycle 3, Fetch");
            Add("CWR1", At(21, 4), "Cycle 4, Write into effective location + 1");
            Add("CW", At(21, 5), "Cycle 5, Write into effective location");
            Add("CRR1", At(21, 6), "Cycle 6, Read contents of effective address + 1");
            Add("CR", At(21, 7), "Cycle 7, Read contents of effective address");

            // ---- Bit 20, 19 ------------------------------------------------------------
            Add("CHLEV", Bit(20), "Change program level");
            Add("DSPL", Bit(20), "Destination register on level specified by bits 12-15 in ROM");
            Add("SACO", Bit(19), "Save Carry and Overflow");

            // ---- OR specification (bits 18-16, table 1.1) ------------------------------
            Add("ORBWO", At(16, 1), "OR for bit operation without destination");
            Add("ORBW", At(16, 3), "OR for bit operations with destination");
            Add("ORSKP", At(16, 4), "OR for SKP");
            Add("ORROP", At(16, 5), "OR for Register Operations");
            Add("ORSW2", At(16, 6), "OR for SWAP cycle 2");
            Add("ORSW3", At(16, 7), "OR for SWAP cycle 3");
            Add("ORIN", At(16, 1) | Bit(15), "OR for Interblock");
            Add("ORIN2", At(16, 3) | Bit(15), "OR for Interblock");

            // ---- ALU function select (bits 28-25), table 2.1 ---------------------------
            // Arithmetic operations (bit 29 = 0). The field is a function
            // (bits 26-25) plus a carry-in select (bits 28-27).
            Add("BM1", At(25, 0), "B-operand minus 1");
            Add("PLUS", At(25, 1), "A-operand + B-operand");
            Add("BMAM1", At(25, 2), "B-operand - A-operand -1 (B-A-1)");
            Add("BDI", At(25, 3), "B-operand direct during arithmetic operation");
            Add("ADDC", At(25, 4), "Add Carry Input");
            Add("ADD1", At(25, 12), "Forced Carry Input");
            Add("BMINA", At(25, 14), "B-operand - A-operand (B-A)");
            // Logical operations (bit 29 = 1), 16 values
            Add("BDIRC", At(25, 0), "B complemented (logical)");
            Add("ANDC", At(25, 1), "AND complement — NAND = A̅ ∙ B̅");
            Add("ORCB", At(25, 2), "A + B̅");
            Add("ONE", At(25, 3), "Logical 1 (all ones)");
            Add("ORC", At(25, 4), "OR complement (A̅ + B̅)");
            Add("ADIRC", At(25, 5), "A-operand Direct Complemented = A̅");
            Add("EXORC", At(25, 6), "Exclusive OR complement");
            Add("ORCA", At(25, 7), "A̅ + B");
            Add("ANDCB", At(25, 8), "A ∙ B̅");
            Add("EXOR", At(25, 9), "Exclusive OR");
            Add("ADIR", At(25, 10), "A-operand Direct through Arithmetic = A");
            Add("OR", At(25, 11), "Inclusive OR");
            // function 14 octal, LOGICAL 0 "ZERO" in table 2.1: no mnemonic, see the test conditions above
            Add("ANDCA", At(25, 13), "A̅ ∙ B");
            Add("AND", At(25, 14), "Logical AND = A · B");
            Add("BDIR", At(25, 15), "B-operand direct during logical operation");

            // ---- LOOP: alternative ALU function (bits 24-20) --------------------------
            Add("BM1A", At(20, 0), "B-operand minus 1, alternative ALU specs.");
            Add("PLUSA", At(20, 1), "A-operand + B-operand alternative specs.");
            Add("BDIA", At(20, 3), "B-operation direct alternative ALU Specs.");
            Add("BMAA", At(20, 14), "B-operand - A-operand alternative ALU spec.");

            // ---- LOOP: shift control ---------------------------------------------------
            // The listing writes "LOOP ORSHT SH32 TSC0" for words that carry bits 18
            // and 10 together: the OR-for-shift mnemonic also sets the M bit (bit 10,
            // "M-bits are set when ORSHT", figure 2.9). Every ORSHT word in the 1k
            // dump has both bits.
            Add("ORSHT", Bit(18) | Bit(10), "OR for Shift");
            Add("SHR", Bit(15), "Shift right");
            Add("SHRO", At(13, 1), "Rotational Shift");
            Add("SHZE", At(13, 2), "Zero end input");
            Add("SH32", Bit(12), "32 bits shift");
            Add("TGSH0", At(8, 1), "TG = 1 if SH0=1");
            Add("TGAC0", At(8, 2), "TG = 1 if ACO = 1");
            Add("TGS0", At(8, 3), "TG = 1 if SUM0-31 = 0");
            Add("TSC0", At(2, 0), "Terminate when Shift Counter = 0");
            Add("TSH31", At(2, 2), "Terminate when Shift Counter = 0 or SH₃₁ = 1");
            Add("TSH22", At(2, 3), "Terminate when SH₂₂ = 1 (32 bits floating)");
            Add("ENDID", Bit(1), "End input for division");
            Add("ASH31", 0, "Alternative ALU specs. if SH31 = 1");
            Add("ASH0", Bit(0), "Alternative ALU specs. if SH0 = 1");

            // ---- INTERBLOCK program level (bits 15-12) ---------------------------------
            for (uint level = 0; level < 16; level++)
            {
                Add("LE" + Convert.ToString(level, 8), At(12, level), $"Program level {Convert.ToString(level, 8)} (INTERBLOCK)");
            }

            // ---- Destination register (bits 11-8) ---------------------------------------
            Add("D,D", At(8, 1), "D register as destination");
            Add("D,P", At(8, 2), "CP register as destination");
            Add("D,B", At(8, 3), "B-register as destination");
            Add("D,L", At(8, 4), "L register as destination");
            Add("D,A", At(8, 5), "A register as destination register");
            Add("D,T", At(8, 6), "T register as destination");
            Add("D,X", At(8, 7), "X register as destination");
            Add("D,S", At(8, 8), "Status register as destination");
            Add("D,SH", At(8, 9), "Shift register as destination");
            Add("D,IO", At(8, 10), "Special case, A-operand transferred to internal registers");
            Add("D,SC", At(8, 11), "Shift counter as destination");
            Add("D,SCR", At(8, 12), "Scratch register as destination");
            Add("D,SP", At(8, 14), "Saved P as destination");
            Add("D,SS", At(8, 15), "Saved Status as destination");

            // ---- B operand (bits 7-4) -----------------------------------------------------
            Add("B,Z", At(4, 0), "Zero as B-operand");
            Add("B,D", At(4, 1), "D register as B-operand");
            Add("B,P", At(4, 2), "CP register as B-operand");
            Add("B,B", At(4, 3), "B register as B-operand");
            Add("B,L", At(4, 4), "L register as B-operand");
            Add("B,A", At(4, 5), "A register as B-operand");
            Add("B,T", At(4, 6), "T register as B-operand");
            Add("B,X", At(4, 7), "X-register as B-operand");
            Add("B,SC", At(4, 8), "Shift Counter as B-operand");
            Add("B,SH", At(4, 9), "Shift register as B-operand");
            Add("B,IO", At(4, 10), "Special case 2: bit mask as B operand (bit number in bits 15-12)");
            Add("B,BM", At(4, 10), "Bit mask as B operand, bit number from the OR logic (ORBW/ORBWO)");
            Add("B,AC", At(4, 11), "AC register (Temporary SUM or ACCUMULATOR) as B-operand");
            Add("B,HAC", At(4, 12), "1/2 AC as B-operand");
            Add("B,2AC", At(4, 13), "2 · AC as B-operand");
            // Bit mask B operand: B field = 12 (octal) and the bit number in bits 15-12
            for (uint bit = 0; bit < 16; bit++)
            {
                Add("B,B" + Convert.ToString(bit, 8), At(4, 10) | At(12, bit), $"Bit mask with bit {Convert.ToString(bit, 8)} set as B operand");
            }
            // Internal registers written by TRR (D,IO): the B field names the register
            Add("B,PAC", At(4, 0), "Panel Control as B-operand");
            Add("B,S", At(4, 1), "Status register (internal register, with D,IO or A,IO)");
            Add("B,LMP", At(4, 2), "Lamp register as B operand");
            Add("B,PCR", At(4, 3), "Paging control register (write, with D,IO)");
            Add("B,MIS", At(4, 4), "Miscellaneous register as B-operand");
            Add("B,MISC", At(4, 4), "Miscellaneous register (write, with D,IO) - alias of B,MIS");
            Add("B,IIE", At(4, 5), "Internal interrupt enable (write, with D,IO)");
            Add("B,PID", At(4, 6), "Priority Interrupt Detect as B-operand");
            Add("B,PIE", At(4, 7), "PIE as B-operand");
            Add("B,CAR", At(4, 11), "Computed Address Register as B-operand");
            Add("B,IR", At(4, 12), "IR as B-operand");
            Add("B,BIO", At(4, 14), "I/O bus (source with A,IO, destination with D,IO)");
            Add("B,IR3", At(4, 15), "IRO-3 as B-operand");
            // Internal registers read by TRA (A,IO): the B field names the register
            Add("B,PAS", At(4, 0), "Panel Status as B-operand");
            Add("B,OPR", At(4, 2), "Panel Switch Register as B operand");
            Add("B,PGS", At(4, 3), "Paging status register (read, with A,IO)");
            Add("B,PVL", At(4, 4), "Previous program level (read, with A,IO)");
            Add("B,IIC", At(4, 5), "Internal interrupt code (read, with A,IO)");
            Add("B,PIM", At(4, 9), "Decoded PIL as B-operand");
            Add("B,DPIL", At(4, 9), "Decoded PIL (read, with A,IO) - alias of B,PIM");
            Add("B,ALD", At(4, 10), "ALD — Automatic Load Descriptor as B-operand");
            Add("B,PES", At(4, 11), "Memory Error Status register as B-operand");
            Add("B,MPC", At(4, 12), "Micro Program Counter as B-operand");
            Add("B,PEA", At(4, 13), "Memory error address (read, with A,IO)");
            Add("B,BIR3", At(4, 15), "Register selected by IR bits 0-3 (read, with A,IO)");
            // Short forms the listing and the mnemonic table use for the internal registers
            Add("BIO", At(4, 14), "I/O bus as source when A, IO: I/O bus as dest. when D, IO");
            Add("BIR", At(4, 12), "IR as B-operand");
            Add("BIR3", At(4, 15), "IR0-3 as B-operand");
            Add("BM", At(4, 10), "B-operand = BIT MASK");
            Add("BMISC", At(4, 4), "Miscellaneous register as B-operand");

            // ---- A operand (bits 3-0) -----------------------------------------------------
            Add("A,Z", At(0, 0), "Zero as A-operand");
            Add("A,D", At(0, 1), "D register as A-operand");
            Add("A,P", At(0, 2), "CP register as A-operand");
            Add("A,B", At(0, 3), "B register as A-operand");
            Add("A,L", At(0, 4), "L register as A-operand");
            Add("A,A", At(0, 5), "A register as A-operand");
            Add("A,T", At(0, 6), "T register as A-operand");
            Add("A,X", At(0, 7), "X register as A-operand");
            Add("A,S", At(0, 8), "STATUS as A-operand");
            Add("A,DH", At(0, 9), "Lower 8 bits of H with sign extension as A operand");
            Add("A,IO", At(0, 10), "Special Case: Internal Register specified as B-operand to H register");
            Add("A,H", At(0, 11), "H register as A-operand");
            Add("A,SCR", At(0, 12), "SCRATCH register as A-operand");
            Add("A,R", At(0, 13), "R register as A-operand");
            Add("A,SP", At(0, 14), "SAVED P as A-operand");
            Add("A,SS", At(0, 15), "SAVED STATUS as A-operand");
        }

        /// <summary>Write every token with its bit pattern, one per line.</summary>
        public void DumpAllTokensToFile(string strTokensFile)
        {
            using (var w = new System.IO.StreamWriter(strTokensFile, false))
            {
                w.WriteLine($"{"Token".PadRight(10)} {"Hex".PadRight(10)} {"Binary 31..0".PadRight(35)} Description");
                w.WriteLine($"{new string('_', 10)} {new string('_', 10)} {new string('_', 35)} {new string('_', 11)}");
                for (int i = 0; i < ordered.Count; i++)
                {
                    var t = ordered[i];
                    string bin = Convert.ToString(t.Value, 2).PadLeft(32, '0');
                    string grouped = bin.Substring(0, 2) + "_" + bin.Substring(2, 4) + "_" + bin.Substring(6, 2) + "_" + bin.Substring(8, 8) + "_" + bin.Substring(16, 4) + "_" + bin.Substring(20, 4) + "_" + bin.Substring(24, 4) + "_" + bin.Substring(28, 4);
                    w.WriteLine($"{t.Token.PadRight(10)} 0x{t.Value:X8} {grouped.PadRight(35)} {t.Comment}");
                }
            }
        }
    }
}
