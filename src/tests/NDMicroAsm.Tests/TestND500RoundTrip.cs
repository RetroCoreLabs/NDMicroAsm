//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.IO;
using NDMicroAsm.Core;
using NDMicroAsm.ND500;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Round-trip tests for the ND-500 (144-bit) micro code toolchain:
    /// ND500Disassembler emits a lossless token list, ND500Compiler
    /// reassembles it, and every bit must survive.
    ///
    /// The main test proves both directions against the only known real
    /// ND-500 control store binary, CONT-STORE-10611.DATA (8192 words x
    /// 18 bytes PACKED18, CS8 first, big-endian per part): if disassembly +
    /// reassembly reproduces all 147456 bytes, the field partition, token
    /// table, assembler and disassembler are simultaneously consistent.
    /// </summary>
    [TestFixture]
    public class TestND500RoundTrip
    {
        const int WORD_BYTES = ND500Compiler.WORD_PARTS * 2;   // 18

        /// <summary>
        /// The real ND-500 control store dump (round-trip source), CONT-STORE-10611.DATA in the
        /// docs/MC folder of the nd500uc project. Not in this repository: set the environment
        /// variable ND500UC_MC_DIR to that folder. When it is unset both round-trip tests skip.
        /// </summary>
        static readonly string MC_FILE = Path.Combine(
            Environment.GetEnvironmentVariable("ND500UC_MC_DIR") ?? "", "CONT-STORE-10611.DATA");

        /// <summary>Extract the 9 word parts (CS8 = bits 143-128 first) for one address.</summary>
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
        // Raw field syntax (FIELDNAME=octal)
        // ------------------------------------------------------------------

        [Test]
        public void Assemble_RawFieldSyntax_PlacesValueAtFieldPosition()
        {
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            // ALU_TRUE = bits 141-137: 0o25 << (137-128) = bits in CS8;
            // COND = bits 88-84: value 0o31 lands in CS5 (95-80) bits 8-4
            var target = compiler.Assemble("1/ ALU_TRUE=25 COND=31 ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w = GetWord(target.Exe!, 1);
            Assert.That(w[0], Is.EqualTo((ushort)(Oct("25") << 9)), "ALU_TRUE in CS8 bits 13-9");
            Assert.That(w[3], Is.EqualTo((ushort)(Oct("31") << 4)), "COND in CS5 bits 8-4");
        }

        [Test]
        public void Assemble_RawFieldValueTooWide_IsError()
        {
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            compiler.Assemble("1/ CARRY=7 ;");   // CARRY is 2 bits; 7 does not fit
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_UnknownFieldName_IsError()
        {
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            compiler.Assemble("1/ NOSUCHFIELD=1 ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_RawFieldOverlappingMnemonic_IsError()
        {
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            // JMP sets SEQ_TRUE bits; raw SEQ_TRUE on the same value overlaps
            var tokens = new ND500Tokens();
            tokens.InitializeTokens();
            var jmp = tokens.LookupToken("JMP");
            Assume.That(jmp, Is.Not.Null);

            compiler.Assemble("1/ JMP SEQ_TRUE=377 ;");
            Assert.That(compiler.ErrorCount, Is.GreaterThan(0));
        }

        [Test]
        public void Assemble_NoDateStamp_Word0StaysZero()
        {
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            var target = compiler.Assemble("1/ ALU_TRUE=25 ;");

            Assert.That(compiler.ErrorCount, Is.EqualTo(0));
            var w0 = GetWord(target.Exe!, 0);
            for (int i = 0; i < ND500Compiler.WORD_PARTS; i++)
            {
                Assert.That(w0[i], Is.EqualTo((ushort)0), $"word 0 part {i} must stay zero with StampDate off");
            }
        }

        // ------------------------------------------------------------------
        // Disassembler basics
        // ------------------------------------------------------------------

        [Test]
        public void Disassemble_ZeroWord_EmitsNothing()
        {
            var disasm = new ND500Disassembler();
            var tokens = disasm.Disassemble(new ushort[ND500Compiler.WORD_PARTS]);
            Assert.That(tokens, Is.Empty, "all-zero word must produce an empty token list");
        }

        [Test]
        public void Disassemble_ArgumentBits_ComeBackAsRawArguments()
        {
            // Long argument when bits 31-16 are set, short argument otherwise
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            var target = compiler.Assemble(
                "1/ 123456,054321 ;\n" +
                "2/ 054321 ;");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0));

            var disasm = new ND500Disassembler();
            Assert.That(disasm.Disassemble(GetWord(target.Exe!, 1)),
                Is.EqualTo(new[] { "123456,54321" }));
            Assert.That(disasm.Disassemble(GetWord(target.Exe!, 2)),
                Is.EqualTo(new[] { "54321" }));
        }

        [Test]
        public void Disassemble_KnownSingleFieldTokens_ComeBackAsMnemonics()
        {
            // Assemble single-field Appendix A mnemonics, expect them (or an
            // alias with the identical encoding) back from the disassembler
            using var compiler = new ND500Compiler();
            compiler.StampDate = false;
            var target = compiler.Assemble("1/ ALU,A+B JMP ;");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0));

            var disasm = new ND500Disassembler();
            var tokens = disasm.Disassemble(GetWord(target.Exe!, 1));

            // Reassemble and verify bit-identity (alias names are acceptable)
            using var compiler2 = new ND500Compiler();
            compiler2.StampDate = false;
            var target2 = compiler2.Assemble("1/ " + string.Join(" ", tokens) + " ;");
            Assert.That(compiler2.ErrorCount, Is.EqualTo(0));
            Assert.That(GetWord(target2.Exe!, 1), Is.EqualTo(GetWord(target.Exe!, 1)));
        }

        // ------------------------------------------------------------------
        // Round trip: every word of the real ND-500 control store
        // ------------------------------------------------------------------

        [Test]
        public void RoundTrip_ContStore10611_AllWordsBitExact()
        {
            Assume.That(File.Exists(MC_FILE),
                $"ND-500 control store not found ({MC_FILE}) - skipping round trip on this machine");

            byte[] image = File.ReadAllBytes(MC_FILE);
            Assert.That(image.Length, Is.EqualTo(ND500Compiler.CONTROL_STORE_WORDS * WORD_BYTES),
                "expected 8192 words x 18 bytes (PACKED18)");

            var disasm = new ND500Disassembler();
            using var compiler = new ND500Compiler();
            var labels = new Labels();

            const int MAX_REPORTED = 20;
            int wordsChecked = 0;
            int mismatchCount = 0;
            int rawFallbacks = 0;
            var report = new System.Text.StringBuilder();

            ushort[] word = new ushort[ND500Compiler.WORD_PARTS];
            ushort[] rebuilt = new ushort[ND500Compiler.WORD_PARTS];

            int wordCount = image.Length / WORD_BYTES;
            for (int addr = 0; addr < wordCount; addr++)
            {
                int off = addr * WORD_BYTES;
                for (int i = 0; i < ND500Compiler.WORD_PARTS; i++)
                {
                    word[i] = (ushort)((image[off + i * 2] << 8) | image[off + i * 2 + 1]);
                }

                // Disassemble to tokens, reassemble via the compiler's
                // Translate path, compare all 144 bits
                var tokens = disasm.Disassemble(word);

                var instruction = new Instruction();
                instruction.Address = addr;
                instruction.Args = tokens;

                for (int i = 0; i < ND500Compiler.WORD_PARTS; i++) rebuilt[i] = 0;
                compiler.Translate(instruction, labels, rebuilt);

                bool equal = true;
                for (int i = 0; i < ND500Compiler.WORD_PARTS; i++)
                {
                    if (rebuilt[i] != word[i]) { equal = false; break; }
                }

                for (int tokIdx = 0; tokIdx < tokens.Count; tokIdx++)
                {
                    if (tokens[tokIdx].IndexOf('=') > 0) { rawFallbacks++; }
                }

                if (!equal)
                {
                    mismatchCount++;
                    if (mismatchCount <= MAX_REPORTED)
                    {
                        report.AppendLine($"addr {System.Convert.ToString(addr, 8).PadLeft(6, '0')}:");
                        report.AppendLine($"  expected [{WordToOctal(word)}]");
                        report.AppendLine($"  got      [{WordToOctal(rebuilt)}]");
                        report.AppendLine($"  tokens: {string.Join(" ", tokens)}");
                    }
                }
                wordsChecked++;
            }

            TestContext.Out.WriteLine(
                $"Round trip: {wordsChecked} words checked, {mismatchCount} mismatches, {rawFallbacks} raw FIELD= fallbacks");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), "reassembly must produce no compiler errors");
            Assert.That(mismatchCount, Is.EqualTo(0),
                $"{mismatchCount} of {wordsChecked} words did not round trip. First {MAX_REPORTED}:\n{report}");
        }

        /// <summary>
        /// The full-pipeline proof: generate a complete .uc source file from
        /// the binary, assemble it through the normal source path (Preprocess
        /// + Translate + image emit), and compare ALL 147456 bytes.
        /// </summary>
        [Test]
        public void RoundTrip_ContStore10611_FullSourceFile_ByteIdentical()
        {
            Assume.That(File.Exists(MC_FILE),
                $"ND-500 control store not found ({MC_FILE}) - skipping round trip on this machine");

            byte[] image = File.ReadAllBytes(MC_FILE);
            var disasm = new ND500Disassembler();

            var src = new System.Text.StringBuilder();
            src.AppendLine("% CONT-STORE-10611 - generated by ND500Disassembler (lossless round-trip source)");
            int wordCount = image.Length / WORD_BYTES;
            for (int addr = 0; addr < wordCount; addr++)
            {
                var word = GetWord(image, addr);
                var tokens = disasm.Disassemble(word);
                if (tokens.Count == 0) continue;   // all-zero word: store stays zero
                src.Append(System.Convert.ToString(addr, 8).PadLeft(6, '0'));
                src.Append("/ ");
                src.Append(string.Join(" ", tokens));
                src.AppendLine(" ;");
            }

            using var compiler = new ND500Compiler();
            compiler.StampDate = false;   // no fabricated bits - word 0 must match the dump exactly
            var target = compiler.Assemble(src.ToString());

            Assert.That(compiler.ErrorCount, Is.EqualTo(0), "assembly of the generated source must be error free");
            Assert.That(target.Exe, Is.Not.Null);
            Assert.That(target.Exe!.Length, Is.EqualTo(image.Length), "full 8K PACKED18 image");

            int firstDiff = -1;
            for (int i = 0; i < image.Length; i++)
            {
                if (target.Exe[i] != image[i]) { firstDiff = i; break; }
            }
            Assert.That(firstDiff, Is.EqualTo(-1),
                $"first differing byte at offset {firstDiff} (word {firstDiff / WORD_BYTES})");
        }
    }
}
