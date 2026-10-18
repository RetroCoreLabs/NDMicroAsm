//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using NDMicroAsm;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the NORD-10 micro code assembler (ND10Compiler / ND10Tokens /
    /// ND10Disassembler): mnemonic values from ND-06.010.01 section 3.1 and
    /// figure 1.1, and the MICMAC source dialect.
    ///
    /// The bit positions are the ones that make both real PROM dumps
    /// round-trip (TestND10RoundTrip.cs); the checks here pin the values the
    /// manual states in words so a table edit cannot drift silently.
    /// </summary>
    [TestFixture]
    public class TestND10Compiler
    {
        static uint Bit(int n)
        {
            return 1u << n;
        }

        static uint Token(string name)
        {
            var tokens = new ND10Tokens();
            tokens.InitializeTokens();
            var t = tokens.LookupToken(name);
            Assert.That(t, Is.Not.Null, $"mnemonic {name} must exist");
            return t!.Value;
        }

        // ------------------------------------------------------------------
        // Mnemonic values (manual section 1.2, 2.1-2.4, 3.1)
        // ------------------------------------------------------------------

        [Test]
        public void Tokens_FormatBits_31_30()
        {
            Assert.That(Token("ARL"), Is.EqualTo(0u), "ARITHMETIC is 00");
            Assert.That(Token("IARL"), Is.EqualTo(Bit(30)), "INTERBLOCK is 01");
            Assert.That(Token("JMP"), Is.EqualTo(Bit(31)), "JUMP is 10");
            Assert.That(Token("LOOP"), Is.EqualTo(Bit(31) | Bit(30)), "LOOP is 11");
        }

        [Test]
        public void Tokens_InstructionMnemonics_CarryUnitLogicalAndConditionalBits()
        {
            Assert.That(Token("ARM"), Is.EqualTo(Bit(24)), "M = most significant unit, bit 24");
            Assert.That(Token("CARM"), Is.EqualTo(Bit(24) | Bit(15)), "C = conditional, bit 15");
            Assert.That(Token("LOGM"), Is.EqualTo(Bit(29) | Bit(24)), "LOG = logical, bit 29");
            Assert.That(Token("CLOGM"), Is.EqualTo(Bit(29) | Bit(24) | Bit(15)));
            Assert.That(Token("ILOGM"), Is.EqualTo(Bit(30) | Bit(29) | Bit(24)));
            Assert.That(Token("CJMP"), Is.EqualTo(Bit(31) | Bit(15)));
            Assert.That(Token(",CAR"), Is.EqualTo(Bit(29)), "JMP ,CAR: bit 29");
            Assert.That(Token("PRIV"), Is.EqualTo(Bit(28)), "JMP PRIV: bit 28");
        }

        [Test]
        public void Tokens_LogicalFunctions_Table21()
        {
            // Table 2.1, MIR 29 = 1: the 16 logical functions in order
            // function 12 (LOGICAL 0) has no mnemonic: the listing uses ZERO for the zero test
            string[] names = { "BDIRC", "ANDC", "ORCB", "ONE", "ORC", "ADIRC", "EXORC", "ORCA", "ANDCB", "EXOR", "ADIR", "OR", "", "ANDCA", "AND", "BDIR" };
            for (uint i = 0; i < 16; i++)
            {
                if (names[i].Length == 0) continue;
                Assert.That(Token(names[i]), Is.EqualTo(i << 25), $"{names[i]} is logical function {i}");
            }
        }

        [Test]
        public void Tokens_ArithmeticFunctions_Table21()
        {
            Assert.That(Token("BM1"), Is.EqualTo(0u));
            Assert.That(Token("PLUS"), Is.EqualTo(1u << 25));
            Assert.That(Token("BMAM1"), Is.EqualTo(2u << 25));
            Assert.That(Token("BDI"), Is.EqualTo(3u << 25));
            Assert.That(Token("ADDC"), Is.EqualTo(4u << 25));
            Assert.That(Token("ADD1"), Is.EqualTo(12u << 25));
            Assert.That(Token("BMINA"), Is.EqualTo((Token("BMAM1") | Token("ADD1"))), "B - A = (B - A - 1) + forced carry");
        }

        [Test]
        public void Tokens_ZeroTest_BothSpellings_AndCondCo17()
        {
            // The listing writes "CJMP ZERO label"; section 3.1 lists the test as Z
            Assert.That(Token("Z"), Is.EqualTo(0u));
            Assert.That(Token("ZERO"), Is.EqualTo(0u));
            // The listing writes "COND CO17" for a conditional word with condition 7
            Assert.That(Token("COND"), Is.EqualTo(Bit(15)));
            Assert.That(Token("CO17"), Is.EqualTo(7u << 12));
            Assert.That(Token("COND") | Token("CO17"), Is.EqualTo(Token("NEGM") | Bit(15)));
            // "CJMP GREM CRY1" at 0475 of the dump: condition 3, greater magnitude
            Assert.That(Token("GREM"), Is.EqualTo(Token("POSM")));
        }

        [Test]
        public void Tokens_TestConditions_Bits14_12()
        {
            string[] names = { "ZERO", "SPOS", "POS", "POSM", "NZERO", "SNEG", "NEG", "NEGM" };
            for (uint i = 0; i < 8; i++)
            {
                Assert.That(Token(names[i]), Is.EqualTo(i << 12));
            }
        }

        [Test]
        public void Tokens_CycleSpecifications_Bits23_21()
        {
            Assert.That(Token("CEATR"), Is.EqualTo(1u << 21), "cycle 1");
            Assert.That(Token("CPTR"), Is.EqualTo(2u << 21), "cycle 2");
            Assert.That(Token("CFC"), Is.EqualTo(3u << 21), "cycle 3");
            Assert.That(Token("CWR1"), Is.EqualTo(4u << 21), "cycle 4");
            Assert.That(Token("CW"), Is.EqualTo(5u << 21), "cycle 5");
            Assert.That(Token("CRR1"), Is.EqualTo(6u << 21), "cycle 6");
            Assert.That(Token("CR"), Is.EqualTo(7u << 21), "cycle 7");
        }

        [Test]
        public void Tokens_OperandFields()
        {
            Assert.That(Token("A,A"), Is.EqualTo(5u), "A operand bits 3-0");
            Assert.That(Token("A,IO"), Is.EqualTo(10u), "special case 3");
            Assert.That(Token("B,A"), Is.EqualTo(5u << 4), "B operand bits 7-4");
            Assert.That(Token("B,IO"), Is.EqualTo(10u << 4), "special case 2");
            Assert.That(Token("D,A"), Is.EqualTo(5u << 8), "destination bits 11-8");
            Assert.That(Token("D,IO"), Is.EqualTo(10u << 8), "special case 1");
            Assert.That(Token("B,B5"), Is.EqualTo((10u << 4) | (5u << 12)), "bit mask: B = 12 octal, bit number in bits 15-12");
            Assert.That(Token("B,B17"), Is.EqualTo((10u << 4) | (15u << 12)));
            Assert.That(Token("LE7"), Is.EqualTo(7u << 12), "INTERBLOCK level in bits 15-12");
            Assert.That(Token("LE17"), Is.EqualTo(15u << 12));
            Assert.That(Token("DSPL"), Is.EqualTo(Bit(20)));
            Assert.That(Token("CHLEV"), Is.EqualTo(Bit(20)));
            Assert.That(Token("SACO"), Is.EqualTo(Bit(19)));
        }

        [Test]
        public void Tokens_OrSpecifications_Bits18_16()
        {
            Assert.That(Token("ORBWO"), Is.EqualTo(1u << 16));
            Assert.That(Token("ORBW"), Is.EqualTo(3u << 16));
            Assert.That(Token("ORSKP"), Is.EqualTo(4u << 16));
            Assert.That(Token("ORROP"), Is.EqualTo(5u << 16));
            Assert.That(Token("ORSW2"), Is.EqualTo(6u << 16));
            Assert.That(Token("ORSW3"), Is.EqualTo(7u << 16));
            Assert.That(Token("ORIN"), Is.EqualTo((1u << 16) | Bit(15)));
            Assert.That(Token("ORIN2"), Is.EqualTo((3u << 16) | Bit(15)));
        }

        [Test]
        public void Tokens_LoopFields()
        {
            Assert.That(Token("PLUSA"), Is.EqualTo(1u << 20), "alternative ALU bits 24-20");
            Assert.That(Token("BMAA"), Is.EqualTo(14u << 20));
            Assert.That(Token("ORSHT"), Is.EqualTo(Bit(18) | Bit(10)), "the listing's ORSHT carries the M bit too");
            Assert.That(Token("SHR"), Is.EqualTo(Bit(15)));
            Assert.That(Token("SHRO"), Is.EqualTo(1u << 13));
            Assert.That(Token("SHZE"), Is.EqualTo(2u << 13));
            Assert.That(Token("SH32"), Is.EqualTo(Bit(12)));
            Assert.That(Token("TGSH0"), Is.EqualTo(1u << 8));
            Assert.That(Token("TGAC0"), Is.EqualTo(2u << 8));
            Assert.That(Token("TGS0"), Is.EqualTo(3u << 8));
            Assert.That(Token("TSC0"), Is.EqualTo(0u));
            Assert.That(Token("TSH31"), Is.EqualTo(2u << 2));
            Assert.That(Token("TSH22"), Is.EqualTo(3u << 2));
            Assert.That(Token("ENDID"), Is.EqualTo(Bit(1)));
            Assert.That(Token("ASH0"), Is.EqualTo(Bit(0)));
        }

        // ------------------------------------------------------------------
        // Source dialect
        // ------------------------------------------------------------------

        static uint[] AssembleOk(string source, out ND10Compiler compiler)
        {
            compiler = new ND10Compiler();
            var rom = compiler.Assemble(source);
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), string.Join("; ", compiler.Errors));
            Assert.That(rom, Is.Not.Null);
            return rom!;
        }

        [Test]
        public void Assemble_MnemonicsAreOred()
        {
            var rom = AssembleOk("0132: ARM PLUS CFC SACO D,A B,A A,H % ADD, from the manual's entry point 132", out _);
            uint expected = Bit(24) | (1u << 25) | (3u << 21) | Bit(19) | (5u << 8) | (5u << 4) | 11u;
            Assert.That(rom[0x5A], Is.EqualTo(expected));
            Assert.That(rom.Length, Is.EqualTo(ND10Compiler.ROM_1K), "no address at or above 1024: 1k image");
        }

        [Test]
        public void Assemble_AddressPrefix_SetsLocationCounter_AndLinesFollow()
        {
            var rom = AssembleOk("0100: LOGM ADIR D,A A,B\nLOGM ADIR D,B A,A\n0200: JMP 0100", out _);
            Assert.That(rom[0x40], Is.Not.EqualTo(0u));
            Assert.That(rom[0x41], Is.Not.EqualTo(0u), "the next line takes the next address");
            Assert.That(rom[0x80], Is.EqualTo(Bit(31) | 0x40u));
        }

        [Test]
        public void Assemble_LabelWithComma_ResolvesJump_AndDoesNotAdvance()
        {
            var rom = AssembleOk("0000: JMP START\n0010: START,\nLOGM ADIR D,A A,B\n0020: CJMP NZERO START", out var compiler);
            Assert.That(rom[0], Is.EqualTo(Bit(31) | 8u), "label on its own line names the next word");
            Assert.That(rom[8], Is.Not.EqualTo(0u));
            Assert.That(rom[16], Is.EqualTo(Bit(31) | Bit(15) | (4u << 12) | 8u));
            Assert.That(compiler.Labels.Count, Is.EqualTo(1));
            Assert.That(compiler.Labels[0].Label, Is.EqualTo("START"));
        }

        [Test]
        public void Assemble_ListingAddressWithoutColon()
        {
            // the manual's listing form: address column, label, mnemonics, comment
            string source = "0002  %ROUTINE TO CONVERT FROM FLOATING NUMBER\n"
                          + "0002  DNZC,   ARM PLUS A,DH B,T D,A     %T + DH -> A\n"
                          + "0003          ARM PLUS D,SS B,B4 A,A\n"
                          + "0005          CJMP ZERO DNZC";
            var rom = AssembleOk(source, out _);
            Assert.That(rom[2], Is.EqualTo(0x03000569u));
            Assert.That(rom[3], Is.EqualTo(0x03004FA5u));
            Assert.That(rom[5], Is.EqualTo(Bit(31) | Bit(15) | 2u));
        }

        [Test]
        public void Assemble_RelativeAddress_StarPlusN()
        {
            // the listing writes "CJMP POS *3" at 0055 for a jump to 0060
            string source = "0055  CJMP POS *3" + "\n" + "0060  JMP *" + "\n" + "0061  JMP *-1";
            var rom = AssembleOk(source, out _);
            Assert.That(rom[0x2D], Is.EqualTo(Bit(31) | Bit(15) | (2u << 12) | 0x30u));
            Assert.That(rom[0x30], Is.EqualTo(Bit(31) | 0x30u));
            Assert.That(rom[0x31], Is.EqualTo(Bit(31) | 0x30u));
        }

        [Test]
        public void Assemble_LabelWithOffset()
        {
            // the listing writes "JMP NOINV+1"
            string nl = "\n";
            var rom = AssembleOk("0556  NOINV,  JMP 0000" + nl + "0557  JMP 0000" + nl + "0560  JMP NOINV+1" + nl + "0561  JMP NOINV-1", out _);
            Assert.That(rom[0x170], Is.EqualTo(Bit(31) | 0x16Fu));
            Assert.That(rom[0x171], Is.EqualTo(Bit(31) | 0x16Du));
        }

        [Test]
        public void Assemble_LabelOnInstructionLine()
        {
            var rom = AssembleOk("0010: HERE, LOGM ADIR D,A A,B\nJMP HERE", out _);
            Assert.That(rom[9], Is.EqualTo(Bit(31) | 8u));
        }

        [Test]
        public void Assemble_BareOctalNumber_IsOredIntoTheWord()
        {
            // 2200000000 octal = bits 28 and 25: an ALU select without a mnemonic
            var rom = AssembleOk("1064: IARM 2200000000 DSPL LE10 D,SCR B,SH A,SCR", out _);
            Assert.That(rom[0x234], Is.EqualTo(0x53108C9Cu), "word 1064 of the 1k dump");
            Assert.That(rom.Length, Is.EqualTo(ND10Compiler.ROM_1K));
        }

        [Test]
        public void Assemble_AddressAt1024OrAbove_Gives4kImage()
        {
            var rom = AssembleOk("2200: JMP 0000", out _);
            Assert.That(rom.Length, Is.EqualTo(ND10Compiler.ROM_4K));
            Assert.That(rom[0x480], Is.EqualTo(Bit(31)));
        }

        [Test]
        public void Assemble_ListedHexWord_IsChecked()
        {
            AssembleOk("0000: 80000302 JMP 1402", out var ok);
            Assert.That(ok.ErrorCount, Is.EqualTo(0));

            var compiler = new ND10Compiler();
            compiler.Assemble("0000: 80000303 JMP 1402");
            Assert.That(compiler.ErrorCount, Is.EqualTo(1), "listed word differs from the assembled word");
        }

        [Test]
        public void Assemble_OverlappingMnemonics_IsError()
        {
            var compiler = new ND10Compiler();
            compiler.Assemble("0000: ARM PLUS BDI D,A");   // PLUS and BDI both set bit 25
            Assert.That(compiler.ErrorCount, Is.EqualTo(1));
            Assert.That(compiler.Errors[0], Does.Contain("OR-ing rejected"));
        }

        [Test]
        public void Assemble_UnknownToken_IsError()
        {
            var compiler = new ND10Compiler();
            compiler.Assemble("0000: ARM NOSUCH D,A");
            Assert.That(compiler.ErrorCount, Is.EqualTo(1));
            Assert.That(compiler.Errors[0], Does.Contain("Unknown token"));
        }

        [Test]
        public void Assemble_SameAddressTwice_IsError()
        {
            var compiler = new ND10Compiler();
            compiler.Assemble("0000: JMP 0001\n0000: JMP 0002");
            Assert.That(compiler.ErrorCount, Is.EqualTo(1));
            Assert.That(compiler.Errors[0], Does.Contain("former entry"));
        }

        [Test]
        public void Assemble_CommentsAndBlankLines_AreIgnored()
        {
            var rom = AssembleOk("% header\n\n0000: JMP 0001 % trailing\n   % indented comment\n", out _);
            Assert.That(rom[0], Is.EqualTo(Bit(31) | 1u));
            Assert.That(rom[1], Is.EqualTo(0u));
        }

        // ------------------------------------------------------------------
        // Disassembler
        // ------------------------------------------------------------------

        [Test]
        public void Disassemble_FourFormats()
        {
            var d = new ND10Disassembler();
            Assert.That(d.DisassembleToString(0x80000302), Is.EqualTo("JMP 1402"));
            Assert.That(d.DisassembleToString(Bit(31) | Bit(15) | (4u << 12) | 0x1E3), Is.EqualTo("CJMP NZERO 0743"));
            Assert.That(d.DisassembleToString(0x80008177), Is.EqualTo("CJMP ZERO 0567"));
            Assert.That(d.DisassembleToString(Bit(31) | Bit(29)), Is.EqualTo("JMP,CAR"));
            Assert.That(d.DisassembleToString(0x03000569), Is.EqualTo("ARM PLUS D,A B,T A,DH"));
            Assert.That(d.DisassembleToString(Bit(24) | Bit(15) | (5u << 12) | (14u << 25) | (5u << 8) | 5u), Is.EqualTo("CARM BMINA SNEG D,A A,A"));
            Assert.That(d.DisassembleToString(Bit(30) | Bit(29) | Bit(24) | (10u << 25) | (3u << 16) | Bit(15) | 14u), Is.EqualTo("ILOGM ADIR ORIN2 A,SP"));
            Assert.That(d.DisassembleToString(Bit(31) | Bit(30) | Bit(15) | (2u << 13)), Is.EqualTo("LOOP BM1 BM1A SHR SHZE TSC0"));
        }

        [Test]
        public void Disassemble_SpecialCases_NameInternalRegisters()
        {
            var d = new ND10Disassembler();
            // D,IO: A operand written to the internal register in the B field
            Assert.That(d.DisassembleToString(Bit(29) | Bit(24) | (10u << 25) | (10u << 8) | (11u << 4) | 11u), Is.EqualTo("LOGM ADIR D,IO B,CAR A,H"));
            // A,IO: internal register in the B field read to H
            Assert.That(d.DisassembleToString(Bit(29) | Bit(24) | (10u << 25) | (12u << 4) | 10u), Is.EqualTo("LOGM ADIR B,MPC A,IO"));
            // bit mask B operand: the bit number sits in bits 15-12, no condition
            Assert.That(d.DisassembleToString(Bit(29) | Bit(24) | (14u << 25) | (10u << 4) | (14u << 12) | 15u), Is.EqualTo("LOGM AND B,B16 A,SS"));
        }

        [Test]
        public void Disassemble_BitsWithoutMnemonic_ComeOutAsOctal()
        {
            var d = new ND10Disassembler();
            Assert.That(d.DisassembleToString(0x53108C9C), Is.EqualTo("IARM 2200000000 DSPL LE10 D,SCR B,SH A,SCR"));
            Assert.That(d.DisassembleToString(Bit(31) | Bit(30) | Bit(10)), Is.EqualTo("LOOP BM1 BM1A 2000 TSC0"), "LOOP bit 10 alone has no mnemonic");
            Assert.That(d.DisassembleToString(Bit(31) | Bit(30) | Bit(18) | Bit(10) | Bit(12)), Is.EqualTo("LOOP BM1 BM1A ORSHT SH32 TSC0"));
        }
    }
}
