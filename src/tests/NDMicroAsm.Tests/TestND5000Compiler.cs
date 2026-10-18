//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using System.IO;
using NDMicroAsm;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the ND-5000 micro code assembler / disassembler
    /// (ND5000Compiler / ND5000Tokens / ND5000Disassembler).
    ///
    /// Token values are generated from microcode-5000-def.json in the nd5000uc
    /// repository's docs folder and spot-checked
    /// here against hand-computed bit positions from the canonical field
    /// partition (nd5000uc reference JS disassembler, documented in
    /// ND5000-APP-ARCHITECTURE.md).
    ///
    /// Micro word layout: 128 bits = eight 16-bit parts,
    /// Words[0] = bits 127-112 ... Words[7] = bits 15-0; the binary image is
    /// 16 bytes per word big-endian (byte 0 = bits 127-120), 16K words =
    /// 262144 bytes - the exact original .DATA format.
    /// </summary>
    [TestFixture]
    public class TestND5000Compiler
    {
        const int WORD_BYTES = ND5000Compiler.WORD_PARTS * 2;   // 16

        /// <summary>
        /// Directory holding the original ND-5000 microcode dumps (round-trip source; the docs/MC
        /// folder of the nd5000uc repository). Not in this repository: set the environment variable
        /// ND5000UC_MC_DIR to it. When it is unset the round-trip test skips itself.
        /// </summary>
        static readonly string MC_DIR = Environment.GetEnvironmentVariable("ND5000UC_MC_DIR") ?? "";

        /// <summary>Extract the 8 word parts (bits 127-112 first) for one address from a .DATA-format image.</summary>
        static ushort[] GetWord(byte[] image, int address)
        {
            ushort[] w = new ushort[ND5000Compiler.WORD_PARTS];
            int off = address * WORD_BYTES;
            for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
            {
                w[i] = (ushort)((image[off + i * 2] << 8) | image[off + i * 2 + 1]);
            }
            return w;
        }

        static ushort Oct(string octal)
        {
            return (ushort)System.Convert.ToUInt16(octal, 8);
        }

        static string WordToOctal(ushort[] word)
        {
            string s = "";
            for (int i = 0; i < word.Length; i++)
            {
                s += System.Convert.ToString(word[i], 8).PadLeft(6, '0');
                if (i < word.Length - 1) s += " ";
            }
            return s;
        }

        // ------------------------------------------------------------------
        // Token table
        // ------------------------------------------------------------------

        [Test]
        public void TokenTable_LoadsAllGeneratedTokens()
        {
            var tokens = new ND5000Tokens();
            tokens.InitializeTokens();
            // 609 tokens generated from microcode-5000-def.json (placeholder
            // mnemonics in parentheses are skipped by the generator)
            Assert.That(tokens.Count, Is.EqualTo(609));
        }

        // Spot checks against microcode-5000-def.json values, hand-placed on
        // the canonical bit partition:
        //   ALU,A+B   = ALU_OP 13  at bits 127-124 -> Words[0] = 150000
        //   CRY,ONE   = ALU_CRY 1  at bits 123-122 -> Words[0] = 002000
        //   ALUF,A-B  = ALUF_OP 10 at bits 121-118 -> Words[0] = 001240? no:
        //               10 << (118-112) = 10 << 6 -> Words[0] bits 9-6 = 0o1200
        //   A,LARG    = A_OP 239   at bits 96-89   -> bit 96 in Words[1], bits 95-89 in Words[2]
        //   D,NONE    = DEST 24    at bits 83-76   -> bit 80 in Words[2], bit 79 in Words[3]
        //   T,NEXT    = SEQT_TYPE 3 at bits 68-67  -> Words[3] = 000030
        //   TBC,NOOP  = TBC 7      at bits 50-48   -> Words[4] = 000007
        //   READ      = MEM code 15 SPLIT: bit 3 -> word bit 41, bits 2-0 -> 34-32 -> Words[5] = 001007
        //   EXPISO    = AAP_CTRL selector 6, op 0 at bits 110-108 -> Words[1] = 060000
        //   AAP1,A+B  = AAP_CTRL (1<<5)|17 = 49 at bits 110-103 -> Words[1] = 014200? see below
        [TestCase("ALU,A+B", "150000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("CRY,ONE", "002000", "000000", "000000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("A,LARG", "000000", "000001", "157000", "000000", "000000", "000000", "000000", "000000")]
        [TestCase("D,NONE", "000000", "000000", "000001", "100000", "000000", "000000", "000000", "000000")]
        [TestCase("T,NEXT", "000000", "000000", "000000", "000030", "000000", "000000", "000000", "000000")]
        [TestCase("TBC,NOOP", "000000", "000000", "000000", "000000", "000007", "000000", "000000", "000000")]
        [TestCase("READ", "000000", "000000", "000000", "000000", "000000", "001007", "000000", "000000")]
        [TestCase("EXPISO", "000000", "060000", "000000", "000000", "000000", "000000", "000000", "000000")]
        public void TokenValues_MatchDefinitionJson(string mnemonic, string w0, string w1, string w2,
            string w3, string w4, string w5, string w6, string w7)
        {
            var tokens = new ND5000Tokens();
            tokens.InitializeTokens();

            var token = tokens.LookupToken(mnemonic);
            Assert.That(token, Is.Not.Null, $"token {mnemonic} missing");

            string[] expected = { w0, w1, w2, w3, w4, w5, w6, w7 };
            for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
            {
                Assert.That(token!.Words[i], Is.EqualTo(Oct(expected[i])),
                    $"{mnemonic} Words[{i}] (bits {127 - i * 16}-{112 - i * 16}) mismatch");
            }
        }

        [Test]
        public void TokenTable_ReverseLookup_FindsFieldTokens()
        {
            var tokens = new ND5000Tokens();
            tokens.InitializeTokens();

            // (field, value) -> token reverse map drives the disassembler
            Assert.That(tokens.LookupFieldToken("ALU_OP", 13), Is.EqualTo("ALU,A+B"));
            Assert.That(tokens.LookupFieldToken("DEST", 24), Is.EqualTo("D,NONE"));
            Assert.That(tokens.LookupFieldToken("TBC", 7), Is.EqualTo("TBC,NOOP"));
            Assert.That(tokens.LookupFieldToken(ND5000TokensBase.MEM_FIELD, 15), Is.EqualTo("READ"));
            Assert.That(tokens.LookupFieldToken("AAP_CTRL", (1 << 5) | 17), Is.EqualTo("AAP1,A+B"));
            Assert.That(tokens.LookupFieldToken("AAP_CTRL", 6 << 5), Is.EqualTo("EXPISO"));
            // No token for an undefined value -> disassembler falls back to raw
            Assert.That(tokens.LookupFieldToken("TBC", 5), Is.Null);
        }

        // ------------------------------------------------------------------
        // Field placement / raw field syntax
        // ------------------------------------------------------------------

        [Test]
        public void Assemble_RawFieldSyntax_PlacesValueAtFieldPosition()
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ ABS_ADDR=123456 AA=5 ORCON=77 ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[6], Is.EqualTo(Oct("123456")), "ABS_ADDR in bits 31-16");
            // AA = bits 15-13: 5 << 13 = 0xA000 = 120000 octal; ORCON = bits 5-0
            Assert.That(w[7], Is.EqualTo((ushort)(Oct("120000") | Oct("000077"))), "AA and ORCON in bits 15-0");
        }

        [Test]
        public void Assemble_RawFieldValueTooWide_IsError()
        {
            using var compiler = new ND5000Compiler();
            compiler.Assemble("1/ AA=17 ;");   // AA is 3 bits, 17 octal = 15 does not fit
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_UnknownFieldName_IsError()
        {
            using var compiler = new ND5000Compiler();
            compiler.Assemble("1/ NOSUCHFIELD=1 ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_TokensAreOrdTogether()
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ ALU,A+B CRY,ONE TBC,NOOP READ ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[0], Is.EqualTo((ushort)(Oct("150000") | Oct("002000"))), "ALU,A+B | CRY,ONE share Words[0]");
            Assert.That(w[4], Is.EqualTo(Oct("000007")), "TBC,NOOP");
            Assert.That(w[5], Is.EqualTo(Oct("001007")), "READ split memory code (bit 41 + bits 34-32)");
        }

        [Test]
        public void Assemble_LabelReference_LandsInAbsAddrBits31_16()
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble(
                "1/ T,JMPREL TARGET ;\n" +
                "2000/ TARGET: T,NEXT ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[6], Is.EqualTo(Oct("002000")), "label address in ABS_ADDR (bits 31-16)");
        }

        [Test]
        public void Assemble_ShortArgument_PlacedInBits15_0()
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ A,SARG 123456 ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[7], Is.EqualTo(Oct("123456")), "short argument in bits 15-0");
        }

        [Test]
        public void Assemble_OverlappingMnemonics_IsError()
        {
            using var compiler = new ND5000Compiler();
            // ALU,A+B and ALU,A-B both set bits in the ALU op field
            compiler.Assemble("1/ ALU,A+B ALU,A-B ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_RawFieldOverlappingMnemonic_IsError()
        {
            using var compiler = new ND5000Compiler();
            // TBC,NOOP sets TBC=7; raw TBC=7 on top overlaps every bit
            compiler.Assemble("1/ TBC,NOOP TBC=7 ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_WriteOnFormerEntry_IsError()
        {
            using var compiler = new ND5000Compiler();
            compiler.Assemble(
                "100/ T,NEXT ;\n" +
                "100/ T,NEXT ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_UnknownToken_IsError()
        {
            using var compiler = new ND5000Compiler();
            compiler.Assemble("1/ NO,SUCH,TOKEN ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        // ------------------------------------------------------------------
        // Output format
        // ------------------------------------------------------------------

        [Test]
        public void Assemble_OutputIsFull16KImage_16BytesPerWordBigEndian()
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ ALU,A+B ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            Assert.That(target.Exe!.Length, Is.EqualTo(262144),
                "full 16K control store, 16 bytes per word - same size as the original .DATA files");

            // ALU,A+B = 13 << 124: byte 0 of word 1 holds bits 127-120 = 0xD0
            Assert.That(target.Exe[1 * WORD_BYTES + 0], Is.EqualTo((byte)0xD0), "byte 0 = bits 127-120, big-endian");
            Assert.That(target.Exe[1 * WORD_BYTES + 1], Is.EqualTo((byte)0x00));
        }

        [Test]
        public void Assemble_NoDateStamp_Word0StaysZero()
        {
            // The ND-500 assembler stamps the assembly date into word 0 bits
            // 15-0; the ND-5000 must NOT (that behavior is ND-500 specific)
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ ALU,A+B ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w0 = GetWord(target.Exe!, 0);
            for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
            {
                Assert.That(w0[i], Is.EqualTo((ushort)0), $"word 0 part {i} must stay zero");
            }
        }

        // ------------------------------------------------------------------
        // Disassembler
        // ------------------------------------------------------------------

        [Test]
        public void Disassemble_ZeroWord_EmitsNothing()
        {
            var disasm = new ND5000Disassembler();
            var tokens = disasm.Disassemble(new ushort[8]);
            Assert.That(tokens, Is.Empty, "all-zero word must produce an empty token list");
        }

        [Test]
        public void Disassemble_KnownWord_EmitsExpectedTokens()
        {
            // Assemble a word from mnemonics, disassemble it, and expect the
            // same tokens back (all chosen values have exact-match mnemonics)
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ ALU,A+B CRY,ONE A,DATA D,NONE TBC,NOOP READ T,NEXT ;");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0));

            var disasm = new ND5000Disassembler();
            var tokens = disasm.Disassemble(GetWord(target.Exe!, 1));

            Assert.That(tokens, Is.EquivalentTo(new[]
            {
                "ALU,A+B", "CRY,ONE", "A,DATA", "D,NONE", "TBC,NOOP", "READ", "T,NEXT"
            }));
        }

        [Test]
        public void Disassemble_UnknownFieldValue_FallsBackToRawOctal()
        {
            // TBC=5 has no mnemonic in the definition JSON
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("1/ TBC=5 ABS_ADDR=1234 ;");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0));

            var disasm = new ND5000Disassembler();
            var tokens = disasm.Disassemble(GetWord(target.Exe!, 1));

            Assert.That(tokens, Is.EquivalentTo(new[] { "TBC=5", "ABS_ADDR=1234" }));
        }

        // ------------------------------------------------------------------
        // Round trip: disassemble -> reassemble every word of every original
        // ND-5000 microcode image and compare all 128 bits
        // ------------------------------------------------------------------

        [Test]
        public void RoundTrip_AllMicrocodeImages_BitExact()
        {
            Assume.That(MC_DIR, Is.Not.Empty, "ND5000UC_MC_DIR is not set - skipping, the original dumps are not in this repository");
            Assume.That(Directory.Exists(MC_DIR),
                $"ND-5000 microcode directory not found ({MC_DIR}) - skipping round trip on this machine");

            string[] allFiles = Directory.GetFiles(MC_DIR, "*.DATA");
            System.Array.Sort(allFiles);

            var images = new List<string>();
            for (int fileIdx = 0; fileIdx < allFiles.Length; fileIdx++)
            {
                // TEST-PATTERN is an ND-500 image, not ND-5000
                if (Path.GetFileName(allFiles[fileIdx]).Contains("TEST-PATTERN")) continue;
                images.Add(allFiles[fileIdx]);
            }
            Assume.That(images.Count, Is.GreaterThan(0), "no .DATA images found - skipping");

            var disasm = new ND5000Disassembler();
            using var compiler = new ND5000Compiler();
            var labels = new Labels();

            const int MAX_REPORTED = 20;
            int wordsChecked = 0;
            int mismatchCount = 0;
            var report = new System.Text.StringBuilder();

            ushort[] word = new ushort[ND5000Compiler.WORD_PARTS];
            ushort[] rebuilt = new ushort[ND5000Compiler.WORD_PARTS];

            for (int imageIdx = 0; imageIdx < images.Count; imageIdx++)
            {
                string file = images[imageIdx];
                byte[] image = File.ReadAllBytes(file);
                Assert.That(image.Length, Is.EqualTo(262144),
                    $"{Path.GetFileName(file)}: expected 16384 words x 16 bytes");

                int wordCount = image.Length / WORD_BYTES;
                for (int addr = 0; addr < wordCount; addr++)
                {
                    // Extract the 128-bit word (big-endian, byte 0 = bits 127-120)
                    int off = addr * WORD_BYTES;
                    for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
                    {
                        word[i] = (ushort)((image[off + i * 2] << 8) | image[off + i * 2 + 1]);
                    }

                    // Disassemble to tokens, reassemble via the compiler's
                    // Translate path, compare all 128 bits
                    var tokens = disasm.Disassemble(word);

                    var instruction = new Instruction();
                    instruction.Address = addr;
                    instruction.Args = tokens;

                    for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++) rebuilt[i] = 0;
                    compiler.Translate(instruction, labels, rebuilt);

                    bool equal = true;
                    for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
                    {
                        if (rebuilt[i] != word[i]) { equal = false; break; }
                    }

                    if (!equal)
                    {
                        mismatchCount++;
                        if (mismatchCount <= MAX_REPORTED)
                        {
                            report.AppendLine($"{Path.GetFileName(file)} addr {System.Convert.ToString(addr, 8).PadLeft(6, '0')}:");
                            report.AppendLine($"  expected [{WordToOctal(word)}]");
                            report.AppendLine($"  got      [{WordToOctal(rebuilt)}]");
                            report.AppendLine($"  tokens: {string.Join(" ", tokens)}");
                        }
                    }
                    wordsChecked++;
                }
            }

            TestContext.Out.WriteLine($"Round trip: {images.Count} images, {wordsChecked} words checked, {mismatchCount} mismatches");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), "reassembly must produce no compiler errors");
            Assert.That(mismatchCount, Is.EqualTo(0),
                $"{mismatchCount} of {wordsChecked} words did not round trip. First {MAX_REPORTED}:\n{report}");
        }
    }
}
