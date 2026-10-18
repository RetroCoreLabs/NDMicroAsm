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
    /// Lossless NORD-10 micro code disassembler.
    ///
    /// Given one 32-bit ROM word it emits the MICMAC mnemonics (ND10Tokens.cs)
    /// such that ND10Compiler reassembles them to exactly the same word. Every
    /// set bit is covered either by a mnemonic or by the raw fallback
    /// <c>FIELDNAME=octal</c> (ND10Fields.cs), so a word the manual does not
    /// describe still round-trips. The unit tests prove this against both real
    /// PROM dumps (1k standard and 4k CE micro code).
    ///
    /// Reading order of the output, per format:
    ///
    ///   ARITHMETIC  ARM/CARM/LOGM/...  ALU  cycle  CHLEV SACO  OR  test  D,x B,x A,x
    ///   INTERBLOCK  IARM/ILOGM/...     ALU  cycle  DSPL SACO   ORIN LEn  D,x B,x A,x
    ///   JUMP        JMP/CJMP  ,CAR PRIV  test  address
    ///   LOOP        LOOP  ALU  alternative ALU  SACO ORSHT  SHR SHRO/SHZE SH32  TG  B,x  TSCx  ENDID ASH0
    ///
    /// Zero-valued mnemonics (ARL, BM1, BDIRC, Z, TSC0, ...) are written when
    /// they make the line readable; they contribute nothing, so the assembler
    /// does not care either way.
    /// </summary>
    public class ND10Disassembler
    {
        static readonly string[] CondNames = { "ZERO", "SPOS", "POS", "POSM", "NZERO", "SNEG", "NEG", "NEGM" };
        static readonly string[] CycleNames = { "", "CEATR", "CPTR", "CFC", "CWR1", "CW", "CRR1", "CR" };
        static readonly string[] OrNames = { "", "ORBWO", "", "ORBW", "ORSKP", "ORROP", "ORSW2", "ORSW3" };
        static readonly string[] LogicalNames = { "BDIRC", "ANDC", "ORCB", "ONE", "ORC", "ADIRC", "EXORC", "ORCA", "ANDCB", "EXOR", "ADIR", "OR", "", "ANDCA", "AND", "BDIR" };
        // Arithmetic ALU select = function (bits 26-25) + carry-in select (bits 28-27).
        // Carry select 2 (bit 28 alone) has no mnemonic in the manual: raw fallback.
        static readonly string[] ArithFunction = { "BM1", "PLUS", "BMAM1", "BDI" };
        static readonly string[] AltNames = { "BM1A", "PLUSA", "", "BDIA", "", "", "", "", "", "", "", "", "", "", "BMAA", "" };
        static readonly string[] DestNames = { "", "D,D", "D,P", "D,B", "D,L", "D,A", "D,T", "D,X", "D,S", "D,SH", "D,IO", "D,SC", "D,SCR", "", "D,SP", "D,SS" };
        static readonly string[] BNames = { "", "B,D", "B,P", "B,B", "B,L", "B,A", "B,T", "B,X", "B,SC", "B,SH", "B,IO", "B,AC", "B,HAC", "B,2AC", "", "" };
        static readonly string[] BWriteNames = { "B,PAC", "B,S", "B,LMP", "B,PCR", "B,MIS", "B,IIE", "B,PID", "B,PIE", "", "", "", "B,CAR", "B,IR", "", "B,BIO", "B,IR3" };
        static readonly string[] BReadNames = { "B,PAS", "B,S", "B,OPR", "B,PGS", "B,PVL", "B,IIC", "B,PID", "B,PIE", "", "B,PIM", "B,ALD", "B,PES", "B,MPC", "B,PEA", "B,BIO", "B,BIR3" };
        static readonly string[] ANames = { "", "A,D", "A,P", "A,B", "A,L", "A,A", "A,T", "A,X", "A,S", "A,DH", "A,IO", "A,H", "A,SCR", "A,R", "A,SP", "A,SS" };
        static readonly string[] ShtNames = { "", "SHRO", "SHZE", "" };
        static readonly string[] TgNames = { "", "TGSH0", "TGAC0", "TGS0" };
        static readonly string[] TermNames = { "TSC0", "", "TSH31", "TSH22" };

        const uint SPECIAL = 10;   // octal 12 in the A, B or D field selects a special case

        /// <summary>Disassemble one word to its token list. Never empty: the format mnemonic is always there.</summary>
        public List<string> Disassemble(uint word)
        {
            var t = new List<string>(12);
            switch (word >> 30)
            {
                case 0: Arithmetic(word, t, false); break;
                case 1: Arithmetic(word, t, true); break;
                case 2: Jump(word, t); break;
                default: Loop(word, t); break;
            }
            return t;
        }

        /// <summary>One line of source text for a word, without address.</summary>
        public string DisassembleToString(uint word)
        {
            return string.Join(" ", Disassemble(word));
        }

        // ------------------------------------------------------------------

        void Arithmetic(uint word, List<string> t, bool interblock)
        {
            bool logical = ND10Fields.LOG.Extract(word) != 0;
            bool most = ND10Fields.UNIT.Extract(word) != 0;
            uint b = ND10Fields.B.Extract(word);
            uint a = ND10Fields.A.Extract(word);
            uint d = ND10Fields.DEST.Extract(word);
            uint or = ND10Fields.OR.Extract(word);
            uint level = ND10Fields.LEVEL.Extract(word);   // bits 15-12
            bool condBit = ND10Fields.COND.Extract(word) != 0;

            // Bit 15 is the conditional flag in ARITHMETIC, except with the bit
            // mask B operand (B = 12 octal) where bits 15-12 are the bit number.
            // In INTERBLOCK bits 15-12 are the program level (or ORIN's bit).
            bool bitMask = !interblock && b == SPECIAL;
            bool conditional = !interblock && condBit && !bitMask;

            // Format mnemonic: I? C? AR/LOG M/L
            string name = (interblock ? "I" : "") + (conditional ? "C" : "") + (logical ? "LOG" : "AR") + (most ? "M" : "L");
            t.Add(name);

            AluName(word, t, logical);

            uint cycle = ND10Fields.CYCLE.Extract(word);
            if (cycle != 0) t.Add(CycleNames[cycle]);

            if (ND10Fields.CHLEV.Extract(word) != 0) t.Add(interblock ? "DSPL" : "CHLEV");
            if (ND10Fields.SACO.Extract(word) != 0) t.Add("SACO");

            // OR specification, then the bits 15-12 area
            if (interblock)
            {
                if ((or == 1 || or == 3) && condBit)
                {
                    t.Add(or == 1 ? "ORIN" : "ORIN2");
                    level &= 7;   // bit 15 is inside ORIN/ORIN2
                }
                else if (or != 0)
                {
                    if (OrNames[or].Length > 0) t.Add(OrNames[or]);
                    else t.Add(ND10Fields.Raw(ND10Fields.OR, or));
                }
                if (level != 0) t.Add("LE" + Convert.ToString(level, 8));
            }
            else
            {
                if (or != 0)
                {
                    if (OrNames[or].Length > 0) t.Add(OrNames[or]);
                    else t.Add(ND10Fields.Raw(ND10Fields.OR, or));
                }
                if (conditional)
                {
                    t.Add(CondNames[level & 7]);
                }
                else if (!bitMask && level != 0)
                {
                    // bits 14-12 set without the conditional bit: no mnemonic covers this
                    t.Add(ND10Fields.Raw(ND10Fields.TC, level & 7));
                }
            }

            // Destination
            if (d != 0)
            {
                if (DestNames[d].Length > 0) t.Add(DestNames[d]);
                else t.Add(ND10Fields.Raw(ND10Fields.DEST, d));
            }

            // B operand: the special cases name internal registers
            if (d == SPECIAL)
            {
                // D,IO: A operand written to the internal register in the B field (TRR)
                if (BWriteNames[b].Length > 0) t.Add(BWriteNames[b]);
                else t.Add(ND10Fields.Raw(ND10Fields.B, b));
            }
            else if (a == SPECIAL)
            {
                // A,IO: internal register in the B field read to H (TRA)
                if (BReadNames[b].Length > 0) t.Add(BReadNames[b]);
                else t.Add(ND10Fields.Raw(ND10Fields.B, b));
            }
            else if (bitMask)
            {
                // bit mask: the bit number sits in bits 15-12
                t.Add("B,B" + Convert.ToString(level, 8));
            }
            else if (b != 0)
            {
                if (BNames[b].Length > 0) t.Add(BNames[b]);
                else t.Add(ND10Fields.Raw(ND10Fields.B, b));
            }

            if (a != 0) t.Add(ANames[a]);
        }

        /// <summary>ALU select, bits 28-25: logical names when bit 29 is set, else function + carry.</summary>
        static void AluName(uint word, List<string> t, bool logical)
        {
            uint alu = ND10Fields.ALU.Extract(word);
            if (logical)
            {
                // function 14 octal (LOGICAL 0) has no mnemonic: octal constant
                if (LogicalNames[alu].Length > 0) t.Add(LogicalNames[alu]);
                else t.Add(ND10Fields.Raw(ND10Fields.ALU, alu));
                return;
            }
            uint function = alu & 3;
            uint carry = alu >> 2;
            switch (carry)
            {
                case 0:
                    t.Add(ArithFunction[function]);
                    break;
                case 1:
                    t.Add(ArithFunction[function]);
                    t.Add("ADDC");
                    break;
                case 3:
                    if (function == 2)
                    {
                        t.Add("BMINA");   // B - A - 1 with forced carry = B - A
                    }
                    else
                    {
                        t.Add(ArithFunction[function]);
                        t.Add("ADD1");
                    }
                    break;
                default:
                    // carry select 2 (bit 28 alone): not in the manual's table
                    t.Add(ND10Fields.Raw(ND10Fields.ALU, alu));
                    break;
            }
        }

        void Jump(uint word, List<string> t)
        {
            bool conditional = ND10Fields.COND.Extract(word) != 0;
            // the listing writes the CAR jump as one word: JMP,CAR
            bool viaCar = ND10Fields.CAR.Extract(word) != 0;
            t.Add(conditional ? (viaCar ? "CJMP,CAR" : "CJMP") : (viaCar ? "JMP,CAR" : "JMP"));
            if (ND10Fields.PRIV.Extract(word) != 0) t.Add("PRIV");
            uint unused = ND10Fields.UNUSED27_16.Extract(word);
            if (unused != 0) t.Add(ND10Fields.Raw(ND10Fields.UNUSED27_16, unused));
            uint tc = ND10Fields.TC.Extract(word);
            if (conditional) t.Add(CondNames[tc]);
            else if (tc != 0) t.Add(ND10Fields.Raw(ND10Fields.TC, tc));
            uint addr = ND10Fields.ADDR.Extract(word);
            if (addr != 0 || ND10Fields.CAR.Extract(word) == 0)
            {
                t.Add(Convert.ToString(addr, 8).PadLeft(4, '0'));
            }
        }

        void Loop(uint word, List<string> t)
        {
            t.Add("LOOP");
            bool logical = ND10Fields.LOG.Extract(word) != 0;
            if (logical) t.Add(ND10Fields.Raw(ND10Fields.LOG, 1));
            AluName(word, t, logical);

            uint alt = ND10Fields.ALT.Extract(word);
            if (alt < AltNames.Length && AltNames[alt].Length > 0) t.Add(AltNames[alt]);
            else if (alt != 0) t.Add(ND10Fields.Raw(ND10Fields.ALT, alt));
            else t.Add("BM1A");

            if (ND10Fields.SACO.Extract(word) != 0) t.Add("SACO");
            // ORSHT is bits 18 and 10 together; either bit alone has no mnemonic
            bool orsht = ND10Fields.ORSHT.Extract(word) != 0;
            bool mbit = ND10Fields.M.Extract(word) != 0;
            if (orsht && mbit) t.Add("ORSHT");
            else if (orsht) t.Add(ND10Fields.Raw(ND10Fields.ORSHT, 1));
            uint unused = ND10Fields.UNUSED17_16.Extract(word);
            if (unused != 0) t.Add(ND10Fields.Raw(ND10Fields.UNUSED17_16, unused));

            if (ND10Fields.SHR.Extract(word) != 0) t.Add("SHR");
            uint sht = ND10Fields.SHT.Extract(word);
            if (sht != 0)
            {
                if (ShtNames[sht].Length > 0) t.Add(ShtNames[sht]);
                else t.Add(ND10Fields.Raw(ND10Fields.SHT, sht));
            }
            if (ND10Fields.SH32.Extract(word) != 0) t.Add("SH32");
            if (ND10Fields.UNUSED11.Extract(word) != 0) t.Add(ND10Fields.Raw(ND10Fields.UNUSED11, 1));
            if (mbit && !orsht) t.Add(ND10Fields.Raw(ND10Fields.M, 1));

            uint tg = ND10Fields.TG.Extract(word);
            if (tg != 0) t.Add(TgNames[tg]);

            uint b = ND10Fields.B.Extract(word);
            if (b != 0)
            {
                if (BNames[b].Length > 0) t.Add(BNames[b]);
                else t.Add(ND10Fields.Raw(ND10Fields.B, b));
            }

            uint term = ND10Fields.TERM.Extract(word);
            if (TermNames[term].Length > 0) t.Add(TermNames[term]);
            else t.Add(ND10Fields.Raw(ND10Fields.TERM, term));

            if (ND10Fields.ENDID.Extract(word) != 0) t.Add("ENDID");
            if (ND10Fields.ASH.Extract(word) != 0) t.Add("ASH0");
        }
    }
}
