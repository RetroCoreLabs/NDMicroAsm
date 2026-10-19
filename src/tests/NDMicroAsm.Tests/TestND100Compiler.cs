//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using System.IO;
using NDMicroAsm.ND1X0;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the ND-100 micro code assembler (Compiler.AssembleFileND100 / ND100Tokens):
    /// mnemonics of ND-06.018.01 EN (NORD-100 Microprogramming Description), the inversion of
    /// bits 22-27 on write, the 12-bit branch address, and the proof against the factory PROMs.
    ///
    /// The PROM proof: the sources microcode/ND-100/ND-100-3033S.uc and ND-100-3033E-CX.uc are
    /// the printed Norsk Data listing (labels, comments, operand names) written back from the
    /// scan, with the instruction words of the 16-chip (3033S) and 32-chip (3033E-CX base and
    /// extension bank) PROM sets; the plain chip decoding is in the DISASSEMBLY folder. The
    /// reference images microcode/ND-100/REFERENCE/*.CODE are the chips combined by
    /// tools/nd100-combine.py of nd-microcode-meta, a program that shares no code with this
    /// assembler. The assembled images must equal them byte for byte.
    /// </summary>
    [TestFixture]
    public class TestND100Compiler
    {
        static string MicrocodeDir()
        {
            string? dir = TestContext.CurrentContext.TestDirectory;
            while (dir != null)
            {
                string candidate = Path.Combine(dir, "NDMicroAsm", "microcode", "ND-100");
                if (Directory.Exists(candidate)) return candidate;
                dir = Path.GetDirectoryName(dir);
            }
            Assert.Fail("microcode/ND-100 folder not found above the test directory");
            return "";
        }

        static ulong Token(string name)
        {
            var tokens = new ND100Tokens();
            tokens.InitializeTokens();
            var t = tokens.LookupToken(name);
            Assert.That(t, Is.Not.Null, $"mnemonic {name} must exist");
            return t!.Value;
        }

        static ulong Bit(int n)
        {
            return 1UL << n;
        }

        /// <summary>Assembles source text and returns address -> 64-bit word as written to the .CODE file.</summary>
        static Dictionary<int, ulong> Assemble(string source)
        {
            string dir = Path.Combine(Path.GetTempPath(), "ndmicroasm-nd100-" + Path.GetRandomFileName());
            Directory.CreateDirectory(dir);
            try
            {
                string uc = Path.Combine(dir, "T.uc");
                File.WriteAllText(uc, source);
                using var asm = new Compiler();
                Assert.That(asm.AssembleFileND100(uc), Is.Not.Null, "assembly must succeed");
                return ReadCode(File.ReadAllBytes(Path.Combine(dir, "T.CODE")));
            }
            finally
            {
                Directory.Delete(dir, true);
            }
        }

        static Dictionary<int, ulong> ReadCode(byte[] bytes)
        {
            var map = new Dictionary<int, ulong>();
            for (int i = 0; i + 9 < bytes.Length; i += 10)
            {
                int address = bytes[i] | (bytes[i + 1] << 8);
                ulong value = 0;
                for (int j = 0; j < 8; j++) value |= (ulong)bytes[i + 2 + j] << (8 * j);
                map[address] = value;
            }
            return map;
        }

        // ------------------------------------------------------------------
        // Mnemonic table
        // ------------------------------------------------------------------

        [Test]
        public void Tokens_Has300Mnemonics()
        {
            var tokens = new ND100Tokens();
            tokens.InitializeTokens();
            int found = 0;
            foreach (string line in File.ReadLines(Path.Combine(MicrocodeDir(), "TOKENS.TXT")))
            {
                if (line.Contains(" [0x")) found++;
            }
            Assert.That(found, Is.EqualTo(300), "TOKENS.TXT dump of the ND-100 table");
            Assert.That(tokens.LookupToken("A,Z"), Is.Not.Null);
            Assert.That(tokens.LookupToken("COND,FETCH"), Is.Not.Null);
        }

        [Test]
        public void Tokens_NamesOfThePrintedListing()
        {
            // The printed listing writes bit 50 as XRF (145 times) and the A operand taken from
            // the macro instruction register as A,SRCE (the old table had the misreading A,SHCE).
            Assert.That(Token("XRF"), Is.EqualTo(Token("EN_EXT")), "same bit 50");
            Assert.That(Token("A,SRCE"), Is.EqualTo(0x14000000000000UL));
            var tokens = new ND100Tokens();
            tokens.InitializeTokens();
            Assert.That(tokens.LookupToken("A,SHCE"), Is.Null);
        }

        [Test]
        public void Tokens_OperandAndSequencerValues()
        {
            Assert.That(Token("A,R7"), Is.EqualTo(0xF000UL), "A operand 17 octal in bits 15-12");
            Assert.That(Token("B,R4"), Is.EqualTo(0xC0000UL), "B operand 14 octal in bits 19-16");
        }

        // ------------------------------------------------------------------
        // Assembler behaviour
        // ------------------------------------------------------------------

        [Test]
        public void Assemble_InvertsBits22To27()
        {
            // An empty instruction has every token bit 0; after the manual's "bits 22 - 27 are
            // inverted after the word is assembled" those six bits read 1.
            var words = Assemble("0/ ;\n");
            Assert.That(words[0], Is.EqualTo(0x0FC00000UL));
        }

        [Test]
        public void Assemble_Label_UsesTwelveBitsAndLeavesBit20Alone()
        {
            // A label at 0o4005 has bit 11 set. On the ND-110 the 13th address bit goes to bit 20;
            // on the ND-100 bit 20 is the timing bit TC0 and the branch address is 12 bits.
            var words = Assemble("0/ T,JMP TARGET;\n4005/\nTARGET:\nT,NEXT;\n");
            Assert.That(words[0] & 0xFFF, Is.EqualTo(0x805UL));
            Assert.That(words[0] & Bit(20), Is.EqualTo(0UL), "bit 20 untouched");
        }

        // ------------------------------------------------------------------
        // Proof against the factory PROMs
        // ------------------------------------------------------------------

        static void AssertSameAsReference(string source, params string[] references)
        {
            string dir = MicrocodeDir();
            var assembled = Assemble(File.ReadAllText(Path.Combine(dir, source)));
            var expected = new Dictionary<int, ulong>();
            foreach (string r in references)
            {
                foreach (var kv in ReadCode(File.ReadAllBytes(Path.Combine(dir, "REFERENCE", r)))) expected[kv.Key] = kv.Value;
            }
            Assert.That(assembled.Count, Is.EqualTo(expected.Count), "number of words");
            var wrong = new List<string>();
            foreach (var kv in expected)
            {
                if (!assembled.TryGetValue(kv.Key, out ulong got) || got != kv.Value)
                {
                    wrong.Add($"{System.Convert.ToString(kv.Key, 8)}: {kv.Value:X16} expected, {got:X16} assembled");
                }
            }
            Assert.That(wrong, Is.Empty, "words that differ from the PROM image");
        }

        [Test]
        public void Assemble_LabelAndInstructionOnOneLine()
        {
            // The printout writes "LABEL: tokens ... operand;" on one line for many instructions.
            var words = Assemble("0/\nONE: ALUF,PASSD ALUD,Q IDBS,ARG T,RETURN T,POP CYCL,SLOW 1560;\nTWO: B,1 T,JMP ONE CONDENABL;\n");
            Assert.That(words[0] & 0xFFF, Is.EqualTo(0x370UL), "1560 octal");
            Assert.That(words[1] & 0xFFF, Is.EqualTo(0UL), "ONE is at address 0");
        }

        [Test]
        public void Prom3033S_AssemblesToTheChipImage()
        {
            AssertSameAsReference("ND-100-3033S.uc", "3033S-microcode.CODE");
        }

        [Test]
        public void Prom3033ECX_BothBanksAssembleToTheChipImages()
        {
            AssertSameAsReference("ND-100-3033E-CX.uc", "3033E-CX-microcode.CODE", "3033E-CX-microcode_ext.CODE");
        }

        [Test]
        public void Disassembly3033S_AssemblesToTheChipImage()
        {
            AssertSameAsReference(Path.Combine("DISASSEMBLY", "ND-100-3033S.disasm.uc"), "3033S-microcode.CODE");
        }

        [Test]
        public void Disassembly3033ECX_AssemblesToTheChipImages()
        {
            AssertSameAsReference(Path.Combine("DISASSEMBLY", "ND-100-3033E-CX.disasm.uc"), "3033E-CX-microcode.CODE", "3033E-CX-microcode_ext.CODE");
        }

        [Test]
        public void Float32_OnlyTheReplacedWordsDifferFromTheChips()
        {
            // The 32 bit floating point PROMs (026XX) replace the words 0o517 - 0o1105 of the
            // 3033S program. There is no chip dump of them. What can be proved: the file
            // assembles, and all 1801 words outside the replaced part are the words of the chips.
            string dir = MicrocodeDir();
            var assembled = Assemble(File.ReadAllText(Path.Combine(dir, "ND-100-3033S-32BIT-FLOAT.uc")));
            var chips = ReadCode(File.ReadAllBytes(Path.Combine(dir, "REFERENCE", "3033S-microcode.CODE")));
            Assert.That(assembled.Count, Is.EqualTo(2048));
            int different = 0;
            var outside = new List<string>();
            foreach (var kv in chips)
            {
                bool inside = kv.Key >= System.Convert.ToInt32("517", 8) && kv.Key <= System.Convert.ToInt32("1105", 8);
                if (assembled[kv.Key] == kv.Value) continue;
                if (inside) different++;
                else outside.Add(System.Convert.ToString(kv.Key, 8));
            }
            Assert.That(outside, Is.Empty, "words outside 0517-1105 that differ from the chips");
            Assert.That(different, Is.GreaterThan(200), "the 32 bit routines are other code");
        }
    }
}
