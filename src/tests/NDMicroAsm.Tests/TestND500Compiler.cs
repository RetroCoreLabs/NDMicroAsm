//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using NDMicroAsm.ND500;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the ND-500 micro code assembler (ND500Compiler / ND500Tokens).
    ///
    /// Token values are spot-checked against Appendix A of ND-30.013.02
    /// "Test Micro Program Descriptions for ND-500" (the printout of the
    /// original assembler value file N500-MNE-VALUES:DATA), transcribed in
    /// the nd500uc project (docs/ND500-MNEMONIC-VALUES.md).
    ///
    /// Micro word layout: 144 bits = nine 16-bit parts CS8..CS0,
    /// CS8 = bits 143-128 first, both in the token table and in the
    /// PACKED18 binary output (big-endian per part).
    /// </summary>
    [TestFixture]
    public class TestND500Compiler
    {
        const int WORD_BYTES = ND500Compiler.WORD_PARTS * 2;   // 18

        /// <summary>Extract control store word parts CS8..CS0 for one address from a PACKED18 image.</summary>
        static ushort[] GetWord(byte[] image, int address)
        {
            ushort[] w = new ushort[ND500Compiler.WORD_PARTS];
            int off = address * WORD_BYTES;
            for (int i = 0; i < ND500Compiler.WORD_PARTS; i++)
            {
                w[i] = (ushort)((image[off + i * 2] << 8) | image[off + i * 2 + 1]);
            }
            return w;
        }

        static ushort Oct(string octal)
        {
            return (ushort)System.Convert.ToUInt16(octal, 8);
        }

        // ------------------------------------------------------------------
        // Token table
        // ------------------------------------------------------------------

        [Test]
        public void TokenTable_LoadsAll721AppendixAEntries()
        {
            var tokens = new ND500Tokens();
            tokens.InitializeTokens();
            Assert.That(tokens.Count, Is.EqualTo(721));
        }

        [TestCase("A,-1", "000000", "100000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("A,P", "000160", "020000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("D,TOS", "000000", "000006", "016000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("JMP", "000000", "000000", "000000", "000014", "070000", "000000", "000000", "000000", "000000")]
        [TestCase("NEXT", "000000", "000000", "000000", "000016", "170000", "000000", "000000", "000000", "000000")]
        [TestCase("F,JMPREL", "000000", "000000", "000000", "000000", "001670", "000000", "000000", "000000", "000000")]
        [TestCase("ALU,A+B", "011000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("A,AL#17", "000005", "160000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        public void TokenValues_MatchAppendixA(string mnemonic, string f1, string f2, string f3,
            string f4, string f5, string f6, string f7, string f8, string f9)
        {
            var tokens = new ND500Tokens();
            tokens.InitializeTokens();

            var token = tokens.LookupToken(mnemonic);
            Assert.That(token, Is.Not.Null, $"token {mnemonic} missing");

            string[] expected = { f1, f2, f3, f4, f5, f6, f7, f8, f9 };
            for (int i = 0; i < ND500Compiler.WORD_PARTS; i++)
            {
                Assert.That(token!.Words[i], Is.EqualTo(Oct(expected[i])),
                    $"{mnemonic} CS{8 - i} mismatch");
            }
        }

        // ------------------------------------------------------------------
        // Comment stripping ('#' is both comment char and register select)
        // ------------------------------------------------------------------

        [Test]
        public void StripComment_HashAtWhitespaceBoundary_IsComment()
        {
            Assert.That(ND500Compiler.StripComment("A,P NEXT ; # this is a comment"),
                Is.EqualTo("A,P NEXT ; "));
            Assert.That(ND500Compiler.StripComment("# full line comment"), Is.EqualTo(""));
        }

        [Test]
        public void StripComment_HashInsideToken_IsRegisterSelect()
        {
            Assert.That(ND500Compiler.StripComment("A,AL#17 B,X#0 NEXT ;"),
                Is.EqualTo("A,AL#17 B,X#0 NEXT ;"));
        }

        [Test]
        public void StripComment_PercentIsAlwaysComment()
        {
            Assert.That(ND500Compiler.StripComment("A,P NEXT ; % note"),
                Is.EqualTo("A,P NEXT ; "));
        }

        // ------------------------------------------------------------------
        // Assembly
        // ------------------------------------------------------------------

        [Test]
        public void Assemble_TokensAreOrdTogether()
        {
            using var compiler = new ND500Compiler();
            // Word 1 (word 0 gets the date stamp): A,P + ALU,A+B share CS8
            var target = compiler.Assemble("1/ A,P ALU,A+B NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[0], Is.EqualTo((ushort)(Oct("000160") | Oct("011000"))), "CS8 = A,P | ALU,A+B");
            Assert.That(w[1], Is.EqualTo(Oct("020000")), "CS7 from A,P");
            Assert.That(w[3], Is.EqualTo(Oct("000016")), "CS5 from NEXT");
            Assert.That(w[4], Is.EqualTo(Oct("170000")), "CS4 from NEXT");
        }

        [Test]
        public void Assemble_LabelReference_PlacedInBits28_16()
        {
            using var compiler = new ND500Compiler();
            var target = compiler.Assemble(
                "1/ JMP TARGET ;\n" +
                "2000/ TARGET: NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            // CS1 = micro word bits 31-16; the 13-bit address lands in bits 28-16
            Assert.That(w[7], Is.EqualTo(Oct("002000")), "label address in CS1");
        }

        [Test]
        public void Assemble_ShortArgument_PlacedInBits15_0()
        {
            using var compiler = new ND500Compiler();
            var target = compiler.Assemble("1/ A,XD,SARG 123456 NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[8], Is.EqualTo(Oct("123456")), "short argument in CS0");
        }

        [Test]
        public void Assemble_LongArgument_PlacedInBits31_0()
        {
            using var compiler = new ND500Compiler();
            var target = compiler.Assemble("1/ A,XD,LARG 12,34567 NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[7], Is.EqualTo(Oct("000012")), "long argument high in CS1");
            Assert.That(w[8], Is.EqualTo(Oct("034567")), "long argument low in CS0");
        }

        [Test]
        public void Assemble_OverlappingMnemonics_IsError()
        {
            using var compiler = new ND500Compiler();
            // A,P and A,B both set bits in the A-operand select field
            compiler.Assemble("1/ A,P A,B NEXT ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_WriteOnFormerEntry_IsError()
        {
            using var compiler = new ND500Compiler();
            compiler.Assemble(
                "100/ NEXT ;\n" +
                "100/ NEXT ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_UnknownToken_IsError()
        {
            using var compiler = new ND500Compiler();
            compiler.Assemble("1/ NO,SUCH,TOKEN NEXT ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_Word0_GetsAssemblyDateStamp()
        {
            using var compiler = new ND500Compiler();
            var target = compiler.Assemble("0/ NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 0);
            // year (bits 15-9), month (bits 8-5), day (bits 4-0)
            var now = System.DateTime.Now;
            Assert.That(w[8] >> 9, Is.EqualTo(now.Year % 100), "year in CS0 bits 15-9");
            Assert.That((w[8] >> 5) & 0xF, Is.EqualTo(now.Month), "month in CS0 bits 8-5");
            // Day may tick over at midnight between stamp and assert - allow both
            Assert.That(w[8] & 0x1F, Is.EqualTo(now.Day).Or.EqualTo(System.DateTime.Now.Day), "day in CS0 bits 4-0");
        }

        [Test]
        public void Assemble_OutputIsFull8KPacked18Image()
        {
            using var compiler = new ND500Compiler();
            var target = compiler.Assemble("1/ NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            Assert.That(target.Exe!.Length, Is.EqualTo(ND500Compiler.CONTROL_STORE_WORDS * WORD_BYTES),
                "full 8K control store, 18 bytes per word");
        }

        [Test]
        public void Assemble_ExampleProgram_CompilesClean()
        {
            string source =
                "0/ NEXT ;\n" +
                "START:  A,P B,X#0 ALU,A+B D,TOS NEXT ;\n" +
                "        A,XD,SARG 123456 B,X#0 ALU,A+B D,X#0 NEXT ;\n" +
                "        A,XD,LARG 12,34567 D,TOS NEXT ;\n" +
                "        COND,ZRO C,SEQ JMP START F,NEXT ;\n" +
                "        C,ALU ALU,A+B F,A-B A,P B,DATA D,TOS NEXT ;\n" +
                "        JSR SUB1 ;\n" +
                "        MEM,RD1 TYP,BY NEXT ;\n" +
                "2000/ SUB1: LCDECR POPRET ;\n";

            using var compiler = new ND500Compiler();
            var target = compiler.Assemble(source);

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));

            // Forward label reference: JSR SUB1 at word 6 carries address 2000 octal
            var w = GetWord(target.Exe!, 6);
            Assert.That(w[7], Is.EqualTo(Oct("002000")), "JSR forward label in CS1");
            Assert.That(w[3], Is.EqualTo(Oct("000014")), "JSR CS5");
            Assert.That(w[4], Is.EqualTo(Oct("010000")), "JSR CS4");

            // SUB1 itself at 2000: LCDECR + POPRET
            var sub = GetWord(target.Exe!, System.Convert.ToInt32("2000", 8));
            Assert.That(sub[5], Is.EqualTo(Oct("000040")), "LCDECR in CS3");
            Assert.That(sub[3], Is.EqualTo(Oct("000017")), "POPRET CS5");
            Assert.That(sub[4], Is.EqualTo(Oct("050000")), "POPRET CS4");
        }
    }
}
