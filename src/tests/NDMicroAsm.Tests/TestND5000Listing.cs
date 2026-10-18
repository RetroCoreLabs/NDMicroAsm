//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using System.IO;
using System.Text;
using NDMicroAsm.ND5000;
using NUnit.Framework;

namespace NDMicroAsm.Tests
{
    /// <summary>
    /// Tests for the ND-5000 listing generator (ND5000Listing /
    /// ND5000LabelMap): .LABE cross-reference parsing, the JS-style (but
    /// lossless) listing token formatter, the markdown-cell parser/validator
    /// round trip on synthetic words covering every notation, and a guarded
    /// full-image generation+validation run against the original
    /// MICRO-5800-A30 dump.
    /// </summary>
    [TestFixture]
    public class TestND5000Listing
    {
        /// <summary>
        /// Directory holding the original ND-5000 microcode dumps (the docs/MC folder of the
        /// nd5000uc repository). Not in this repository: set the environment variable
        /// ND5000UC_MC_DIR to it. When it is unset the tests that need the dumps skip themselves.
        /// </summary>
        static readonly string MC_DIR = Environment.GetEnvironmentVariable("ND5000UC_MC_DIR") ?? "";

        // ------------------------------------------------------------------
        // .LABE parsing
        // ------------------------------------------------------------------

        /// <summary>Build .LABE-style file bytes with bit 7 set on every byte (printer parity).</summary>
        static byte[] LabeBytes(string text)
        {
            byte[] b = Encoding.ASCII.GetBytes(text);
            for (int i = 0; i < b.Length; i++)
            {
                b[i] = (byte)(b[i] | 0x80);
            }
            return b;
        }

        [Test]
        public void LabelMap_ParsesEntries_StripsParityBit_SkipsHeaderAndContinuations()
        {
            string text =
                "\f\r\n" +
                "\r\n" +
                "ND-5800 microprogram cross reference table version 11430 (W-406)   2    PAGE       1\r\n" +
                "\r\n" +
                "SAMSON          000000* 001234 002345 \r\n" +
                "INIT_SAMSON     013533* 000000 \r\n" +
                "                        003456 004567 \r\n" +   // continuation line (leading space) - skipped
                "2W1_1           020703* 020676 020700 \r\n";
            var map = ND5000LabelMap.Parse(LabeBytes(text));

            Assert.That(map.Count, Is.EqualTo(3));
            Assert.That(map.NameToAddr["SAMSON"], Is.EqualTo(0));
            Assert.That(map.NameToAddr["INIT_SAMSON"], Is.EqualTo(System.Convert.ToInt32("13533", 8)));
            Assert.That(map.NameToAddr["2W1_1"], Is.EqualTo(System.Convert.ToInt32("20703", 8)));
            Assert.That(map.AddrToName[0], Is.EqualTo("SAMSON"));
        }

        [Test]
        public void LabelMap_DuplicateEntries_LaterOverwrites_LikeTheJs()
        {
            // Same name at two addresses: the JS object assignment lets the
            // LATER entry win in NameToAddr; both addresses keep their name
            // in AddrToName (each written once)
            string text =
                "DUP             000100* \r\n" +
                "DUP             000200* \r\n" +
                "OTHER           000100* \r\n";
            var map = ND5000LabelMap.Parse(LabeBytes(text));

            Assert.That(map.Count, Is.EqualTo(2));
            Assert.That(map.NameToAddr["DUP"], Is.EqualTo(System.Convert.ToInt32("200", 8)));
            // Address 100: DUP first, then OTHER overwrites (later entry)
            Assert.That(map.AddrToName[System.Convert.ToInt32("100", 8)], Is.EqualTo("OTHER"));
            Assert.That(map.AddrToName[System.Convert.ToInt32("200", 8)], Is.EqualTo("DUP"));
        }

        [Test]
        public void LabelMap_CaseSensitiveNames_AreDistinct()
        {
            // MICRO-5800-A30 really has GOIDLE at 000016 and goidle at 000017
            string text =
                "GOIDLE          000016* \r\n" +
                "goidle          000017* \r\n";
            var map = ND5000LabelMap.Parse(LabeBytes(text));

            Assert.That(map.Count, Is.EqualTo(2));
            Assert.That(map.AddrToName[System.Convert.ToInt32("16", 8)], Is.EqualTo("GOIDLE"));
            Assert.That(map.AddrToName[System.Convert.ToInt32("17", 8)], Is.EqualTo("goidle"));
        }

        [Test]
        public void Slug_LowercasesAndReplacesUnderscores()
        {
            Assert.That(ND5000Listing.Slug("INIT_SAMSON"), Is.EqualTo("init-samson"));
            Assert.That(ND5000Listing.Slug("2W1_1"), Is.EqualTo("2w1-1"));
        }

        // ------------------------------------------------------------------
        // Formatter / validator round trip on synthetic words
        // ------------------------------------------------------------------

        /// <summary>Assemble a word from assembler source, format it as a listing cell, and validate the cell round trip.</summary>
        static string FormatAndValidate(string source, ND5000LabelMap labels)
        {
            using var compiler = new ND5000Compiler();
            var target = compiler.Assemble("100/ " + source + " ;");
            Assert.That(compiler.ErrorCount, Is.EqualTo(0), $"synthetic word must assemble: {source}");

            ushort[] word = new ushort[ND5000Compiler.WORD_PARTS];
            ND5000Listing.GetWord(target.Exe!, System.Convert.ToInt32("100", 8), word);

            var listing = new ND5000Listing();
            string cell = listing.FormatMarkdownCell(word, labels);

            using var validator = new ND5000Compiler();
            bool ok = listing.ValidateCell(cell, word, labels, validator, 0, out string? error);
            Assert.That(ok, Is.True, $"cell must validate: '{cell}' ({error})");
            return cell;
        }

        static ND5000LabelMap EmptyLabels => new ND5000LabelMap();

        [Test]
        public void Listing_Larg_EmitsElevenDigitOctal_WithAddrAndScalDecorations()
        {
            // A,LARG: bits 31-0 are the argument; ABS_ADDR/SCAL inside it are
            // ALSO decorated (ADDR= link, IX*4) exactly like the JS
            var labels = new ND5000LabelMap();
            labels.NameToAddr["TARGET"] = System.Convert.ToInt32("13533", 8);
            labels.AddrToName[System.Convert.ToInt32("13533", 8)] = "TARGET";

            string cell = FormatAndValidate("ALU,A A,LARG 13533,246 D,SC13 T,RETURN", labels);
            // bits 31-0 = (0o13533 << 16) | 0o246 = 0x175B00A6 = 0o2726600246
            Assert.That(cell, Does.Contain("LARG=02726600246"));
            Assert.That(cell, Does.Contain("[ADDR=TARGET](#target)"));
            Assert.That(cell, Does.Contain("IX*4"));                    // bits 8-6 of 246 octal = 2
            Assert.That(cell, Does.Not.Contain("AA="));                 // covered by LARG
        }

        [Test]
        public void Listing_Sarg_EmitsSixDigitOctal_AddrIndependent()
        {
            string cell = FormatAndValidate("ALU,XOR A,SARG 70 B,SC14 D,SC4 T,JMP ABS_ADDR=7", EmptyLabels);
            Assert.That(cell, Does.Contain("SARG=000070"));
            Assert.That(cell, Does.Contain("ADDR=000007"));             // bits 31-16 are not part of SARG
        }

        [Test]
        public void Listing_Marg_EmitsThreeDigitOctal_AndKeepsAaAbRaw()
        {
            // MARG covers bits 7-0 only; AA/AB (bits 15-9) stay raw fields
            string cell = FormatAndValidate("ALU,A A,MARG 123 AA=5 AB=14 T,JMP", EmptyLabels);
            Assert.That(cell, Does.Contain("MARG=123"));
            Assert.That(cell, Does.Contain("AA=5"));
            Assert.That(cell, Does.Contain("AB=14"));
        }

        [Test]
        public void Listing_MargWithScal_OverlappingBits_RoundTrips()
        {
            // SCAL bits 8-6 partially overlap MARG bits 7-0: MARG=123 has
            // bits 7-6 = 01, so SCAL 1 (IX*2) shares them consistently and
            // bit 8 stays clear
            string cell = FormatAndValidate("ALU,A A,MARG 123 T,JMP", EmptyLabels);
            Assert.That(cell, Does.Contain("MARG=123"));
            Assert.That(cell, Does.Contain("IX*2"));                    // bits 8-6 of 123 octal = 1
        }

        [Test]
        public void Listing_AddrLabel_RendersMarkdownLink_OctalWhenUnknown()
        {
            var labels = new ND5000LabelMap();
            labels.NameToAddr["MY_TARGET"] = System.Convert.ToInt32("1234", 8);
            labels.AddrToName[System.Convert.ToInt32("1234", 8)] = "MY_TARGET";

            string linked = FormatAndValidate("ALU,FZRO T,JMP ABS_ADDR=1234", labels);
            Assert.That(linked, Does.Contain("[ADDR=MY_TARGET](#my-target)"));

            string plain = FormatAndValidate("ALU,FZRO T,JMP ABS_ADDR=4321", labels);
            Assert.That(plain, Does.Contain("ADDR=004321"));
            Assert.That(plain, Does.Not.Contain("["));
        }

        [Test]
        public void Listing_AmbiguousLabel_FallsBackToOctal()
        {
            // A name whose NameToAddr entry points elsewhere (duplicate name
            // in the .LABE) would make ADDR=<name> ambiguous text - the
            // generator must fall back to the octal form for losslessness
            var labels = new ND5000LabelMap();
            labels.NameToAddr["DUP"] = System.Convert.ToInt32("200", 8);        // later entry won
            labels.AddrToName[System.Convert.ToInt32("100", 8)] = "DUP";        // this address still shows DUP
            labels.AddrToName[System.Convert.ToInt32("200", 8)] = "DUP";

            string cell = FormatAndValidate("ALU,FZRO T,JMP ABS_ADDR=100", labels);
            Assert.That(cell, Does.Contain("ADDR=000100"));

            string cell2 = FormatAndValidate("ALU,FZRO T,JMP ABS_ADDR=200", labels);
            Assert.That(cell2, Does.Contain("[ADDR=DUP](#dup)"));
        }

        [Test]
        public void Listing_AaAbRaw_EmittedWhenNotCoveredByArgument()
        {
            string cell = FormatAndValidate("ALU,FZRO T,JMP AA=1 AB=6", EmptyLabels);
            Assert.That(cell, Does.Contain("AA=1"));
            Assert.That(cell, Does.Contain("AB=6"));
        }

        [Test]
        public void Listing_Scal_MnemonicFor1To5_RawFor6And7()
        {
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP SCAL=2", EmptyLabels), Does.Contain("IX*4"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP SCAL=4", EmptyLabels), Does.Contain("IX/8"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP SCAL=6", EmptyLabels), Does.Contain("SCAL=6"));
        }

        [Test]
        public void Listing_Orcon_HexWhenOrEnableSet_PrefixedHexOtherwise()
        {
            // OR_ENABLE set: JS convention ORCON=<2-digit uppercase hex>
            string enabled = FormatAndValidate("ALU,FZRO T,JMP OR_ENABLE=1 ORCON=46", EmptyLabels);
            Assert.That(enabled, Does.Contain("ORCON=26"));             // 46 octal = 0x26
            Assert.That(enabled, Does.Not.Contain("0x"));

            // OR_ENABLE set with ORCON zero: still printed (JS does too)
            string zero = FormatAndValidate("ALU,FZRO T,JMP OR_ENABLE=1", EmptyLabels);
            Assert.That(zero, Does.Contain("ORCON=00"));

            // ORCON without OR_ENABLE: the JS is silent - emitted with the
            // distinguishing 0x prefix
            string orphan = FormatAndValidate("ALU,FZRO T,JMP ORCON=46", EmptyLabels);
            Assert.That(orphan, Does.Contain("ORCON=0x26"));
        }

        [Test]
        public void Listing_SuppressedDefaults_DNone_TbcNoop_TNext()
        {
            // D,NONE (DEST=24), TBC,NOOP (TBC=7) and T,NEXT (jump type 3) are
            // suppressed in the text and re-injected by the parser
            string cell = FormatAndValidate("ALU,FZRO D,NONE TBC,NOOP T,NEXT", EmptyLabels);
            Assert.That(cell, Does.Not.Contain("D,NONE"));
            Assert.That(cell, Does.Not.Contain("TBC,NOOP"));
            Assert.That(cell, Does.Not.Contain("T,NEXT"));
        }

        [Test]
        public void Listing_ConditionalAluPair_AndSequencerStackJoin()
        {
            string cell = FormatAndValidate("C,ALU ALU,FZRO ALUF,A CRYF,ONE T,RETURN T,POP", EmptyLabels);
            Assert.That(cell, Does.Contain("C,ALU ALU,FZRO ALUF,A CRYF,ONE"));
            Assert.That(cell, Does.Contain("T,RETURN, T,POP"));         // the JS decodeSeq ", " join
        }

        [Test]
        public void Listing_AluFalseWithoutCondAlu_IsEmitted_JsLosesIt()
        {
            string cell = FormatAndValidate("ALU,FZRO ALUF,ADRC T,JMP", EmptyLabels);
            Assert.That(cell, Does.Contain("ALUF,ADRC"));
            Assert.That(cell, Does.Not.Contain("C,ALU"));
        }

        [Test]
        public void Listing_SeqFalseWithoutCondSeq_IsEmitted_WithForcedType()
        {
            // F,POP alone would be ambiguous; the type is forced so absence
            // of F tokens without C,SEQ always means SEQ_FALSE = 0
            string cell = FormatAndValidate("ALU,FZRO T,JMP F,NEXT F,POP", EmptyLabels);
            Assert.That(cell, Does.Contain("F,NEXT, F,POP"));
            Assert.That(cell, Does.Not.Contain("C,SEQ"));
        }

        [Test]
        public void Listing_JsLossyFields_Timing_Mem_EaSave_Memot_AreEmitted()
        {
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP SLOW2", EmptyLabels), Does.Contain("SLOW2"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP READ", EmptyLabels), Does.Contain("READ"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP EA1SAVE", EmptyLabels), Does.Contain("EA1SAVE"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP C,MEMOT", EmptyLabels), Does.Contain("C,MEMOT"));
        }

        [Test]
        public void Listing_UnknownFieldValues_FallBackToRawOctal()
        {
            // TBC=5, MEM code 12 (octal), AAP selector 3 have no mnemonics
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP TBC=5", EmptyLabels), Does.Contain("TBC=5"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP MEM_BIT3=1 MEM_BITS20=2", EmptyLabels),
                Does.Contain("MEM_BIT3=1 MEM_BITS20=2"));
            Assert.That(FormatAndValidate("ALU,FZRO T,JMP AAP_CTRL=140", EmptyLabels), Does.Contain("AAP_CTRL=140"));
        }

        [Test]
        public void Parser_RejectsInconsistentDecorations()
        {
            var listing = new ND5000Listing();
            // ADDR decoration disagreeing with the LARG bits 31-16 must fail
            var toks = listing.ParseInstructionCell(
                "ALU,A A,LARG LARG=01353300246 ADDR=000001", EmptyLabels, out string? error);
            Assert.That(toks, Is.Null);
            Assert.That(error, Does.Contain("ADDR"));
        }

        // ------------------------------------------------------------------
        // Full image generation + validation (guarded: original dumps needed)
        // ------------------------------------------------------------------

        [Test]
        public void GenerateMarkdown_FullA30Image_AllLinesValidate_InMemory()
        {
            Assume.That(MC_DIR, Is.Not.Empty, "ND5000UC_MC_DIR is not set - skipping, the original dumps are not in this repository");
            string dataPath = Path.Combine(MC_DIR, "MICRO-5800-A30.DATA");
            string labePath = Path.Combine(MC_DIR, "MICRO-5800-A30.LABE");
            Assume.That(File.Exists(dataPath), $"original dump not found ({dataPath}) - skipping on this machine");
            Assume.That(File.Exists(labePath), $"label file not found ({labePath}) - skipping on this machine");

            byte[] data = File.ReadAllBytes(dataPath);
            var labels = ND5000LabelMap.Parse(File.ReadAllBytes(labePath));
            Assert.That(labels.Count, Is.EqualTo(3334), "A30 has 3334 distinct label names (JS export header)");

            var listing = new ND5000Listing();
            // GenerateMarkdown validates every one of the 16384 lines from
            // its own markdown text and throws on the first failure
            string markdown = listing.GenerateMarkdown(data, labels, "MICRO-5800-A30", "1970-01-01T00:00:00.000Z");

            var lines = markdown.Split('\n');
            Assert.That(lines.Length, Is.EqualTo(16384 + 13), "13 header lines + 16384 instruction rows");
            Assert.That(lines[13], Does.StartWith("| `000000` | <a id=\"samson\"></a>**SAMSON** | "));
            Assert.That(markdown, Does.Not.EndWith("\n"), "the JS export has no trailing newline");
        }
    }
}
