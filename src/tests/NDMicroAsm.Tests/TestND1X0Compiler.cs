//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using System.IO;
using System.Linq;
using NDMicroAsm.ND1X0;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the ND-110 and ND-120 micro code assembler (Compiler.AssembleFile) against the
    /// two real EPROM pairs in microcode/ND-110/REFERENCE and microcode/ND-120/REFERENCE.
    ///
    /// Chip layout (found by comparing the assembled DELILAH-L image with the chips, all 19544
    /// sub-words equal): the chip pair holds 8192 words of 4 sub-words; sub-word k of the word at
    /// address a is at byte a*4+k of both chips, the HIGH chip holding the upper byte and the LOW
    /// chip the lower byte of the 16-bit sub-word, k = 0 being bits 15-0 of the word.
    /// </summary>
    [TestFixture]
    public class TestND1X0Compiler
    {
        static string MicrocodeDir(string cpu)
        {
            string? dir = TestContext.CurrentContext.TestDirectory;
            while (dir != null)
            {
                string candidate = Path.Combine(dir, "NDMicroAsm", "microcode", cpu);
                if (Directory.Exists(candidate)) return candidate;
                dir = Path.GetDirectoryName(dir);
            }
            Assert.Fail($"microcode/{cpu} folder not found above the test directory");
            return "";
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

        /// <summary>Assembles source text and returns address -> 64-bit word as written to the .CODE file.</summary>
        static Dictionary<int, ulong> AssembleText(string source, bool isND120, string version)
        {
            string dir = Path.Combine(Path.GetTempPath(), "ndmicroasm-nd1x0-" + Path.GetRandomFileName());
            Directory.CreateDirectory(dir);
            try
            {
                string uc = Path.Combine(dir, "T.uc");
                File.WriteAllText(uc, source);
                using var asm = new Compiler();
                Assert.That(asm.AssembleFile(uc, isND120, version), Is.Not.Null, "assembly must succeed");
                return ReadCode(File.ReadAllBytes(Path.Combine(dir, "T.CODE")));
            }
            finally
            {
                Directory.Delete(dir, true);
            }
        }

        static Dictionary<int, ulong> AssembleFile(string cpu, string file, bool isND120, string version)
        {
            string source = File.ReadAllText(Path.Combine(MicrocodeDir(cpu), file));
            return AssembleText(source, isND120, version);
        }

        /// <summary>The 8192 words of a chip pair, see the layout in the class comment.</summary>
        static ulong[] ReadChips(string cpu, string lowChip, string highChip)
        {
            string folder = Path.Combine(MicrocodeDir(cpu), "REFERENCE");
            byte[] low = File.ReadAllBytes(Path.Combine(folder, lowChip));
            byte[] high = File.ReadAllBytes(Path.Combine(folder, highChip));
            Assert.That(low.Length, Is.EqualTo(32768));
            Assert.That(high.Length, Is.EqualTo(32768));
            var words = new ulong[8192];
            for (int a = 0; a < words.Length; a++)
            {
                for (int k = 0; k < 4; k++)
                {
                    int i = a * 4 + k;
                    words[a] |= (ulong)((high[i] << 8) | low[i]) << (16 * k);
                }
            }
            return words;
        }

        // ------------------------------------------------------------------
        // ND-120, version L: proved against the real EPROM pair (AM27256 45132L / 45133L)
        // ------------------------------------------------------------------

        [Test]
        public void ND120_DelilahL_EqualsTheEpromWordForWord()
        {
            var words = AssembleFile("ND-120", "ND-120-DELILAH-L.uc", true, "L");
            ulong[] rom = ReadChips("ND-120", "AM27256_45132L.bin", "AM27256_45133L.bin");

            Assert.That(words.Count, Is.EqualTo(4886), "words the source defines");
            var wrong = words.Where(w => rom[w.Key] != w.Value).Select(w => w.Key).ToList();
            Assert.That(wrong, Is.Empty, "assembled words that differ from the chips");
        }

        [Test]
        public void ND120_DelilahLPatch_DiffersFromTheEpromInOneWord()
        {
            // ND-120-DELILAH-L-PATCH.uc is version L plus COMM,LDIRV in one word; the chips do not
            // have that change, so exactly that word (0o500) differs.
            var words = AssembleFile("ND-120", "ND-120-DELILAH-L-PATCH.uc", true, "L");
            ulong[] rom = ReadChips("ND-120", "AM27256_45132L.bin", "AM27256_45133L.bin");

            var wrong = words.Where(w => rom[w.Key] != w.Value).Select(w => w.Key).ToList();
            Assert.That(wrong, Is.EqualTo(new List<int> { 0x140 }), "0o500 is 0x140");
        }

        [Test]
        public void ND120_VersionL_RemovesDly1FromTheRegisterSelectTokens()
        {
            // Version K and L differ in B,P / B,B / B,X: version L has no DLY1 (word 2, 004000
            // octal in the 16-bit part = bit 27 of the micro word).
            string source = "0/ B,P ;\n1/ B,B ;\n2/ B,X ;\n";
            var k = AssembleText(source, true, "K");
            var l = AssembleText(source, true, "L");
            Assert.That(k.Keys, Is.EquivalentTo(l.Keys));
            foreach (int address in k.Keys)
            {
                Assert.That(k[address] ^ l[address], Is.EqualTo(1UL << 27), $"address {address}");
            }
        }

        // ------------------------------------------------------------------
        // ND-110: RASK is micro code version 0o13, the chips (3095 card, 37948L / 37949L) hold 0o14
        // ------------------------------------------------------------------

        [Test]
        public void ND110_Rask_AgainstTheEprom()
        {
            var words = AssembleFile("ND-110", "ND-110-RASK.uc", false, "K");
            ulong[] rom = ReadChips("ND-110", "37948L.bin", "37949L.bin");

            Assert.That(words.Count, Is.EqualTo(4865), "words the source defines");
            var differ = words.Where(w => rom[w.Key] != w.Value).Select(w => w.Key).ToList();

            // Measured on 21 October 2026: 4257 words are equal, so the .CODE image is in the form of
            // the chips with no inversion applied afterwards. The other 608 are the changes between
            // version 0o13 (the source) and 0o14 (the chips): the version word at 0o20 and
            // 368 words that differ in bit 27 only.
            Assert.That(words.Count - differ.Count, Is.EqualTo(4257), "equal words");
            Assert.That(differ.Count, Is.EqualTo(608), "differing words");
            Assert.That(differ.Contains(0x10), Is.True, "0o20, the version word");
            Assert.That(words[0x10] & 0xFFFF, Is.EqualTo(0xBUL), "source version 0o13");
            Assert.That(rom[0x10] & 0xFFFF, Is.EqualTo(0xCUL), "chip version 0o14");
            int bit27Only = differ.Count(a => (words[a] ^ rom[a]) == (1UL << 27));
            Assert.That(bit27Only, Is.EqualTo(368), "words that differ in bit 27 only");
        }
    }
}
