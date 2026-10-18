//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.IO;
using System.Text;
using NDMicroAsm.ND10;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Round-trip and ground-truth tests for the NORD-10 micro code toolchain.
    ///
    /// Ground truth: the two real PROM dumps in
    /// NDMicroAsm/microcode/NORD-10/REFERENCE (the 1k standard micro program and
    /// the 4k NORD-10/CE micro program, see the README there).
    ///
    ///  1. Every word of both dumps disassembles (ND10Disassembler) and
    ///     reassembles (ND10Compiler) to the same bits.
    ///  2. The checked-in sources NORD-10.uc and NORD-10-CE.uc assemble to the
    ///     dumps word for word, and the .hex the assembler writes is byte for
    ///     byte the reference file.
    /// </summary>
    [TestFixture]
    public class TestND10RoundTrip
    {
        static string RepoRoot()
        {
            // Walk up from the test binary to the src folder holding NDMicroAsm.slnx
            string? dir = TestContext.CurrentContext.TestDirectory;
            while (dir != null && !File.Exists(Path.Combine(dir, "NDMicroAsm.slnx")))
            {
                dir = Path.GetDirectoryName(dir);
            }
            Assume.That(dir, Is.Not.Null, "NDMicroAsm.slnx not found above the test directory");
            return dir!;
        }

        static string UCodeDir()
        {
            return Path.Combine(RepoRoot(), "NDMicroAsm", "microcode", "NORD-10");
        }

        const string REF_1K = "NORD-10-1K-prom.hex";
        const string REF_4K = "NORD-10-CE-4K-prom4k.hex";

        static uint[] LoadReference(string name)
        {
            string path = Path.Combine(UCodeDir(), "REFERENCE", name);
            Assume.That(File.Exists(path), $"reference dump missing: {path}");
            return ND10Compiler.ReadHexFile(path);
        }

        static void AssertRoundTrip(string refName, int expectedWords)
        {
            uint[] rom = LoadReference(refName);
            Assert.That(rom.Length, Is.EqualTo(expectedWords));

            var disasm = new ND10Disassembler();
            var src = new StringBuilder();
            for (int addr = 0; addr < rom.Length; addr++)
            {
                src.Append(ND10Compiler.Oct(addr)).Append(": ").AppendLine(disasm.DisassembleToString(rom[addr]));
            }

            var compiler = new ND10Compiler();
            uint[]? back = compiler.Assemble(src.ToString());
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), string.Join("; ", compiler.Errors));
            Assert.That(back, Is.Not.Null);
            Assert.That(back!.Length, Is.EqualTo(rom.Length));

            int mismatches = 0;
            for (int addr = 0; addr < rom.Length; addr++)
            {
                if (back[addr] != rom[addr])
                {
                    mismatches++;
                    if (mismatches <= 10)
                    {
                        TestContext.Out.WriteLine($"{ND10Compiler.Oct(addr)}: {rom[addr]:X8} -> {disasm.DisassembleToString(rom[addr])} -> {back[addr]:X8}");
                    }
                }
            }
            Assert.That(mismatches, Is.EqualTo(0), $"{mismatches} of {rom.Length} words did not survive the round trip");
        }

        [Test]
        public void RoundTrip_Standard1kDump_AllWordsExact()
        {
            AssertRoundTrip(REF_1K, ND10Compiler.ROM_1K);
        }

        [Test]
        public void RoundTrip_CE4kDump_AllWordsExact()
        {
            AssertRoundTrip(REF_4K, ND10Compiler.ROM_4K);
        }

        static void AssertSourceMatchesReference(string sourceName, string refName)
        {
            string sourcePath = Path.Combine(UCodeDir(), sourceName);
            Assume.That(File.Exists(sourcePath), $"source missing: {sourcePath}");
            uint[] rom = LoadReference(refName);

            var compiler = new ND10Compiler();
            uint[]? built = compiler.Assemble(File.ReadAllText(sourcePath));
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), string.Join("; ", compiler.Errors));
            Assert.That(built, Is.Not.Null);
            Assert.That(built!.Length, Is.EqualTo(rom.Length), "ROM size");

            int mismatches = 0;
            for (int addr = 0; addr < rom.Length; addr++)
            {
                if (built[addr] != rom[addr])
                {
                    mismatches++;
                    if (mismatches <= 10)
                    {
                        TestContext.Out.WriteLine($"{ND10Compiler.Oct(addr)}: source {built[addr]:X8}, reference {rom[addr]:X8}");
                    }
                }
            }
            Assert.That(mismatches, Is.EqualTo(0), $"{mismatches} words differ between {sourceName} and {refName}");

            // The written .hex must be the reference file byte for byte
            string tmp = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName() + ".hex");
            try
            {
                ND10Compiler.WriteHexFile(tmp, built);
                byte[] written = File.ReadAllBytes(tmp);
                byte[] reference = File.ReadAllBytes(Path.Combine(UCodeDir(), "REFERENCE", refName));
                Assert.That(written, Is.EqualTo(reference), "written .hex differs from the reference dump");
            }
            finally
            {
                if (File.Exists(tmp)) File.Delete(tmp);
            }
        }

        [Test]
        public void Source_NORD10_AssemblesToThe1kDump()
        {
            AssertSourceMatchesReference("NORD-10.uc", REF_1K);
        }

        [Test]
        public void Source_NORD10CE_AssemblesToThe4kDump()
        {
            AssertSourceMatchesReference("NORD-10-CE.uc", REF_4K);
        }

        [Test]
        public void Dumps_FirstThousandWordsDifferInOneBitOnly()
        {
            uint[] rom1 = LoadReference(REF_1K);
            uint[] rom4 = LoadReference(REF_4K);
            int differing = 0;
            for (int addr = 0; addr < rom1.Length; addr++)
            {
                if (rom1[addr] != rom4[addr]) differing++;
            }
            Assert.That(differing, Is.EqualTo(1));
            Assert.That(rom1[0x234] ^ rom4[0x234], Is.EqualTo(1u << 28), "address 1064 octal, bit 28");
        }
    }
}
