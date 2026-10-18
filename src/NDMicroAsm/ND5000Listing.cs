//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace NDMicroAsm
{
    /// <summary>
    /// Address/label map parsed from an ND-5000 .LABE printer cross reference
    /// table, replicating the reference JS loadLabels() (nd5000uc index.html)
    /// EXACTLY so the generated listing renders the same label names:
    ///   - strip bit 7 of every byte (old files have the parity bit set)
    ///   - split on '\n'
    ///   - skip empty (trimmed) lines, lines containing
    ///     "microprogram cross reference table" (the page header), and lines
    ///     starting with a space (continuation lines of the reference list)
    ///   - an entry line matches ^(\S+)\s+(\d+)\*? - the FIRST address after
    ///     the name (octal; a trailing '*' marks the defining line and is
    ///     ignored, the defining address is printed first)
    ///   - duplicates: later entries overwrite earlier ones in BOTH maps
    ///     (plain JS object property assignment) - e.g. MICRO-5800-A30 has
    ///     GOIDLE at 000016 and lowercase goidle at 000017 as separate names
    /// </summary>
    public class ND5000LabelMap
    {
        /// <summary>Label name -> address (JS "labels"; later duplicate names overwrite).</summary>
        public readonly Dictionary<string, int> NameToAddr = new Dictionary<string, int>();

        /// <summary>Address -> label name (JS "labelsByAddr"; later entries for the same address overwrite).</summary>
        public readonly Dictionary<int, string> AddrToName = new Dictionary<int, string>();

        /// <summary>Distinct label names - the "Labels" count in the exported header.</summary>
        public int Count => NameToAddr.Count;

        /// <summary>Parse a raw .LABE file image (bytes as stored, parity bits included).</summary>
        public static ND5000LabelMap Parse(byte[] bytes)
        {
            var map = new ND5000LabelMap();

            // Strip bit 7 of every byte, exactly like the JS (String.fromCharCode(b & 0x7F))
            var sb = new StringBuilder(bytes.Length);
            for (int i = 0; i < bytes.Length; i++)
            {
                sb.Append((char)(bytes[i] & 0x7F));
            }

            var lines = sb.ToString().Split('\n');
            for (int i = 0; i < lines.Length; i++)
            {
                string line = lines[i];
                string t = line.Trim();

                // JS: if (!t || t.includes('microprogram cross reference table') || line.startsWith(' ')) continue;
                // Note the startsWith check is on the UNtrimmed line - that is
                // what skips the reference-continuation lines.
                if (t.Length == 0) continue;
                if (t.Contains("microprogram cross reference table")) continue;
                if (line.Length > 0 && line[0] == ' ') continue;

                // ^(\S+)\s+(\d+)\*?  - name, whitespace, first (defining) octal address
                var m = System.Text.RegularExpressions.Regex.Match(t, @"^(\S+)\s+(\d+)\*?");
                if (!m.Success) continue;

                int addr = ND5000Compiler.ParseOctal(m.Groups[2].Value);
                if (addr < 0) continue;   // JS parseInt(x, 8) would stop at a non-octal digit; \d+ with 8/9 cannot appear in these files

                map.NameToAddr[m.Groups[1].Value] = addr;   // overwrite = JS object assignment
                map.AddrToName[addr] = m.Groups[1].Value;
            }

            return map;
        }
    }

    /// <summary>
    /// ND-5000 microcode listing generator: renders a .DATA control store
    /// image in the exact markdown style of the reference JS web
    /// disassembler's "Export Markdown" (generateDisassemblyMarkdown), but
    /// LOSSLESSLY - every set bit of the 128-bit word is recoverable from the
    /// emitted instruction text alone.
    ///
    /// The JS presentation conventions are kept wherever they are already
    /// lossless (so a git diff of JS-exported vs. this output highlights
    /// content, not style):
    ///   - conditional ALU: C,ALU + true + false pair when COND_ALU set,
    ///     otherwise only the true path
    ///   - sequencer: jump type suppressed when NEXT (3), stack op suppressed
    ///     when HOLD (0); type and stack joined ", " ("T,RETURN, T,POP")
    ///   - A,LARG / A,SARG / A,MARG overlays: LARG= followed by 11 octal digits
    ///     (bits 31-0), SARG= by 6 octal digits (bits 15-0), MARG= by 3 octal
    ///     digits (bits 7-0)
    ///   - nonzero ABS_ADDR: ADDR=label (markdown-linked to the label anchor)
    ///     or ADDR= followed by 6 octal digits
    ///   - SCAL 1-5 as IX*2 / IX*4 / IX*8 / IX/8 / IX*16
    ///   - ORCON as ORCON= followed by 2 uppercase hex digits when OR_ENABLE set
    ///     (the one hex field in the JS listing; even when the value is 00)
    ///   - suppressed defaults: D,NONE (DEST=24), TBC,NOOP (TBC=7), zero
    ///     fields, TYP,W (0), SCAL 0
    ///
    /// Where the JS is LOSSY the information is emitted anyway (these lines
    /// are exactly the interesting diffs against the JS export):
    ///   - TIMING (SLOW1/2/3), memory ops (READ/WRITE/...), EA_SAVE
    ///     (EA1SAVE/...) - all dropped by the JS due to JSON field-name
    ///     mismatches (TIMING_OPS/MEM_OPS/EA_SAVE_OPS stay empty)
    ///   - C,MEMOT, AA=, AB= - extracted by the JS but never printed
    ///   - ALU_FALSE without COND_ALU, SEQ_FALSE without COND_SEQ (the JS
    ///     only prints the false paths when the condition bit is set); a
    ///     SEQ_FALSE jump type is then printed even when NEXT so absence
    ///     stays unambiguous
    ///   - ORCON without OR_ENABLE: ORCON=0x followed by 2 hex digits (the 0x
    ///     prefix distinguishes it from the OR_ENABLE form above)
    ///   - values without a mnemonic (unknown A_OP/DEST/TESTOBJ/... codes,
    ///     AAP selectors 3-5/7, SCAL 6-7, AD_ARTI, RESERVED_36): raw
    ///     FIELDNAME=octal instead of the JS "A,DAC,?21" guesswork or
    ///     silence
    ///
    /// Every generated line is VALIDATED before the file is written: the
    /// instruction cell is re-parsed from its own markdown text, converted to
    /// assembler tokens and reassembled through ND5000Compiler.Translate; the
    /// result must equal the original 128-bit word exactly.
    /// </summary>
    public class ND5000Listing
    {
        readonly ND5000Tokens tokens;

        /// <summary>
        /// Creates a listing generator with the ND-5000 mnemonic table loaded.
        /// </summary>
        public ND5000Listing()
        {
            tokens = new ND5000Tokens();
            tokens.InitializeTokens();
        }

        // ------------------------------------------------------------------
        // Formatting
        // ------------------------------------------------------------------

        /// <summary>Anchor slug, exactly the JS rule: label.toLowerCase().replace(/_/g,'-').</summary>
        public static string Slug(string label)
        {
            return label.ToLowerInvariant().Replace('_', '-');
        }

        static string Oct(int v)
        {
            return Convert.ToString(v, 8);
        }

        static string OctPad(long v, int width)
        {
            return Convert.ToString(v, 8).PadLeft(width, '0');
        }

        /// <summary>
        /// Render one micro word as the ordered listing token list (plain
        /// text, no markdown links - ADDR= carries the bare label or octal).
        /// Emission order mirrors the JS disassemble() so unchanged content
        /// produces byte-identical lines.
        /// </summary>
        public List<string> FormatTokens(ushort[] word, ND5000LabelMap labels)
        {
            var m = new List<string>();

            int condAlu = ND5000Disassembler.ExtractField(word, 114, 114);
            int aluOp = ND5000Disassembler.ExtractField(word, 127, 124);
            int aluCry = ND5000Disassembler.ExtractField(word, 123, 122);
            int alufOp = ND5000Disassembler.ExtractField(word, 121, 118);
            int alufCry = ND5000Disassembler.ExtractField(word, 117, 116);

            // Conditional ALU pair: C,ALU + true path + false path; otherwise
            // only the true path - plus the JS-lossy case: a nonzero false
            // path without COND_ALU is emitted anyway (never printed by JS)
            if (condAlu != 0) m.Add("C,ALU");
            m.Add(tokens.LookupFieldToken("ALU_OP", aluOp)!);           // all 16 op codes have mnemonics
            if (aluCry != 0) m.Add(tokens.LookupFieldToken("ALU_CRY", aluCry)!);
            if (condAlu != 0 || alufOp != 0 || alufCry != 0)
            {
                if (condAlu != 0 || alufOp != 0)
                {
                    m.Add(tokens.LookupFieldToken("ALUF_OP", alufOp)!);
                }
                if (alufCry != 0) m.Add(tokens.LookupFieldToken("ALUF_CRY", alufCry)!);
            }

            if (ND5000Disassembler.ExtractField(word, 115, 115) != 0) m.Add("EXUC");

            int qReg = ND5000Disassembler.ExtractField(word, 113, 111);
            if (qReg != 0) m.Add(tokens.LookupFieldToken("Q_REG", qReg)!);   // 1-7 all defined

            int aap = ND5000Disassembler.ExtractField(word, 110, 103);
            if (aap != 0)
            {
                // Exact-match token (AAP1,x / AAP2,x / EXPISO); unknown
                // selector/op combinations fall back to raw (JS is silent)
                string? aapTok = tokens.LookupFieldToken("AAP_CTRL", aap);
                m.Add(aapTok ?? ("AAP_CTRL=" + Oct(aap)));
            }

            int timing = ND5000Disassembler.ExtractField(word, 102, 101);
            if (timing != 0) m.Add(tokens.LookupFieldToken("TIMING", timing)!);   // SLOW1/2/3 - JS drops these (TIMING_OPS empty)

            int datatype = ND5000Disassembler.ExtractField(word, 100, 98);
            if (datatype != 0) m.Add(tokens.LookupFieldToken("DATATYPE", datatype)!);   // 1-7 all defined

            // A operand; LARG/SARG/MARG overlays reuse the low word as
            // immediate data - printed exactly like the JS (octal, fixed width)
            int aOp = ND5000Disassembler.ExtractField(word, 96, 89);
            string? aTok = tokens.LookupFieldToken("A_OP", aOp);
            bool isLarg = aTok == "A,LARG";
            bool isSarg = aTok == "A,SARG";
            bool isMarg = aTok == "A,MARG";
            if (aTok != null)
            {
                m.Add(aTok);
                if (isLarg)
                {
                    long larg = ((long)ND5000Disassembler.ExtractField(word, 31, 16) << 16)
                              | (uint)ND5000Disassembler.ExtractField(word, 15, 0);
                    m.Add("LARG=" + OctPad(larg, 11));
                }
                else if (isSarg)
                {
                    m.Add("SARG=" + OctPad(ND5000Disassembler.ExtractField(word, 15, 0), 6));
                }
                else if (isMarg)
                {
                    m.Add("MARG=" + OctPad(ND5000Disassembler.ExtractField(word, 7, 0), 3));
                }
            }
            else
            {
                m.Add("A_OP=" + Oct(aOp));   // JS prints "A,<group>,?<reg>" guesswork here
            }

            int bOp = ND5000Disassembler.ExtractField(word, 88, 84);
            string? bTok = tokens.LookupFieldToken("B_OP", bOp);
            m.Add(bTok ?? ("B_OP=" + Oct(bOp)));   // B is always printed (0 = B,X1)

            int dest = ND5000Disassembler.ExtractField(word, 83, 76);
            if (dest != 24)   // 24 = D,NONE, the suppressed default
            {
                string? dTok = tokens.LookupFieldToken("DEST", dest);
                m.Add(dTok ?? ("DEST=" + Oct(dest)));
            }

            int status = ND5000Disassembler.ExtractField(word, 75, 72);
            if (status != 0)
            {
                string? sTok = tokens.LookupFieldToken("STATUS", status);
                m.Add(sTok ?? ("STATUS=" + Oct(status)));
            }

            if (ND5000Disassembler.ExtractField(word, 71, 71) != 0) m.Add("IXADJ");
            if (ND5000Disassembler.ExtractField(word, 70, 70) != 0) m.Add("LCDECR");

            // Sequencer: type suppressed when NEXT (3), stack when HOLD (0);
            // type+stack joined ", " into ONE list element, exactly like the
            // JS decodeSeq ("T,RETURN, T,POP")
            int condSeq = ND5000Disassembler.ExtractField(word, 69, 69);
            if (condSeq != 0) m.Add("C,SEQ");

            int seqtType = ND5000Disassembler.ExtractField(word, 68, 67);
            int seqtStack = ND5000Disassembler.ExtractField(word, 66, 65);
            string? seqT = FormatSeq("SEQT_TYPE", seqtType, "SEQT_STACK", seqtStack, false);
            if (seqT != null) m.Add(seqT);

            int seqfType = ND5000Disassembler.ExtractField(word, 64, 63);
            int seqfStack = ND5000Disassembler.ExtractField(word, 62, 61);
            if (condSeq != 0)
            {
                string? seqF = FormatSeq("SEQF_TYPE", seqfType, "SEQF_STACK", seqfStack, false);
                if (seqF != null) m.Add(seqF);
            }
            else if (seqfType != 0 || seqfStack != 0)
            {
                // JS loses the false path without COND_SEQ; a NONZERO
                // SEQ_FALSE is emitted anyway (zero needs no preserving).
                // The type token is forced even when NEXT so absence stays
                // unambiguous: no F tokens without C,SEQ = SEQ_FALSE 0
                string? seqF = FormatSeq("SEQF_TYPE", seqfType, "SEQF_STACK", seqfStack, true);
                if (seqF != null) m.Add(seqF);
            }

            if (ND5000Disassembler.ExtractField(word, 60, 60) != 0) m.Add("INVSEQ");
            if (ND5000Disassembler.ExtractField(word, 59, 59) != 0) m.Add("CSAVE");

            int testObj = ND5000Disassembler.ExtractField(word, 58, 53);
            string? tTok = tokens.LookupFieldToken("TESTOBJ", testObj);
            m.Add(tTok ?? ("TESTOBJ=" + Oct(testObj)));   // 0 = COND,MSEXO is always printed by the JS too

            int abr = ND5000Disassembler.ExtractField(word, 52, 51);
            if (abr != 0) m.Add(tokens.LookupFieldToken("ABR", abr)!);   // 1-3 all defined

            int tbc = ND5000Disassembler.ExtractField(word, 50, 48);
            if (tbc != 7)   // 7 = TBC,NOOP, the suppressed default
            {
                string? tbcTok = tokens.LookupFieldToken("TBC", tbc);
                m.Add(tbcTok ?? ("TBC=" + Oct(tbc)));   // TBC=5 has no mnemonic
            }

            int get = ND5000Disassembler.ExtractField(word, 47, 44);
            if (get != 0)
            {
                string? gTok = tokens.LookupFieldToken("GET", get);
                m.Add(gTok ?? ("GET=" + Oct(get)));
            }

            if (ND5000Disassembler.ExtractField(word, 43, 43) != 0) m.Add("STOP");
            if (ND5000Disassembler.ExtractField(word, 42, 42) != 0) m.Add("AAPSYNC");

            // Memory op: recombined split code (bit 41 << 3 | bits 34-32).
            // The JS never prints these (MEM_OPS stays empty - JSON field
            // name mismatch), so every memory op is a JS-loss diff.
            int memBit3 = ND5000Disassembler.ExtractField(word, 41, 41);
            int memBits20 = ND5000Disassembler.ExtractField(word, 34, 32);
            int mem = (memBit3 << 3) | memBits20;
            if (mem != 0)
            {
                string? memTok = tokens.LookupFieldToken(ND5000TokensBase.MEM_FIELD, mem);
                if (memTok != null)
                {
                    m.Add(memTok);
                }
                else
                {
                    // Unknown code (10 octal 12): raw per split part so the
                    // reassembly places the exact bits back
                    if (memBit3 != 0) m.Add("MEM_BIT3=1");
                    if (memBits20 != 0) m.Add("MEM_BITS20=" + Oct(memBits20));
                }
            }

            if (ND5000Disassembler.ExtractField(word, 40, 40) != 0) m.Add("AD_ARTI=1");   // no mnemonic exists

            int eaSave = ND5000Disassembler.ExtractField(word, 39, 38);
            if (eaSave != 0) m.Add(tokens.LookupFieldToken("EA_SAVE", eaSave)!);   // EA1SAVE/EA2SAVE/EA3SAVE - JS drops these

            if (ND5000Disassembler.ExtractField(word, 37, 37) != 0) m.Add("C,MEMOT");     // extracted but never printed by the JS
            if (ND5000Disassembler.ExtractField(word, 36, 36) != 0) m.Add("RESERVED_36=1");
            if (ND5000Disassembler.ExtractField(word, 35, 35) != 0) m.Add("ADACT");

            // Sequencer jump target. Label form only when the name resolves
            // BACK to this address (a name defined at two addresses would be
            // ambiguous text - the JS prints it anyway, we print octal).
            int absAddr = ND5000Disassembler.ExtractField(word, 31, 16);
            if (absAddr != 0)
            {
                string? name;
                if (labels.AddrToName.TryGetValue(absAddr, out name)
                    && labels.NameToAddr.TryGetValue(name, out int back) && back == absAddr)
                {
                    m.Add("ADDR=" + name);
                }
                else
                {
                    m.Add("ADDR=" + OctPad(absAddr, 6));
                }
            }

            // AA/AB: never printed by the JS (a loss); suppressed here only
            // when the bits are already covered by a LARG/SARG argument
            int aa = ND5000Disassembler.ExtractField(word, 15, 13);
            int ab = ND5000Disassembler.ExtractField(word, 12, 9);
            if (!isLarg && !isSarg)
            {
                if (aa != 0) m.Add("AA=" + Oct(aa));
                if (ab != 0) m.Add("AB=" + Oct(ab));
            }

            // SCAL: the JS prints IX*2/IX*4/IX*8/IX/8/IX*16 for 1-5 even when
            // the bits are inside a LARG/SARG argument - matched here. 6-7
            // have no mnemonic: raw, unless covered by LARG/SARG.
            int scal = ND5000Disassembler.ExtractField(word, 8, 6);
            if (scal >= 1 && scal <= 5)
            {
                m.Add(tokens.LookupFieldToken("SCAL", scal)!);
            }
            else if (scal != 0 && !isLarg && !isSarg)
            {
                m.Add("SCAL=" + Oct(scal));
            }

            // ORCON: 2-digit uppercase hex when OR_ENABLE set (the JS
            // convention, printed even when 00). Without OR_ENABLE the JS is
            // silent - emitted as ORCON=0x<hex> unless the bits are already
            // covered by a LARG/SARG/MARG argument.
            int orEnable = ND5000Disassembler.ExtractField(word, 97, 97);
            int orcon = ND5000Disassembler.ExtractField(word, 5, 0);
            if (orEnable != 0)
            {
                m.Add("ORCON=" + orcon.ToString("X2"));
            }
            else if (orcon != 0 && !isLarg && !isSarg && !isMarg)
            {
                m.Add("ORCON=0x" + orcon.ToString("X2"));
            }

            return m;
        }

        /// <summary>
        /// One sequencer path as the JS decodeSeq string: type token when not
        /// NEXT (or always, when <paramref name="forceType"/>), stack token
        /// when not HOLD, joined ", ". Null when nothing is printed.
        /// </summary>
        string? FormatSeq(string typeField, int type, string stackField, int stack, bool forceType)
        {
            string? s = null;
            if (type != 3 || forceType)
            {
                s = tokens.LookupFieldToken(typeField, type)!;   // 0-3 all defined (T,JMP/T,JMPREL/T,RETURN/T,NEXT and F,*)
            }
            if (stack != 0)
            {
                string st = tokens.LookupFieldToken(stackField, stack)!;   // 1-3 defined (POP/LOAD/PUSH)
                s = s == null ? st : s + ", " + st;
            }
            return s;
        }

        /// <summary>
        /// Render the markdown instruction cell: the plain token list with
        /// ADDR=label turned into a markdown link to the label's anchor, exactly
        /// like the JS markdown export.
        /// </summary>
        public string FormatMarkdownCell(ushort[] word, ND5000LabelMap labels)
        {
            var toks = FormatTokens(word, labels);
            var sb = new StringBuilder();
            for (int i = 0; i < toks.Count; i++)
            {
                if (i > 0) sb.Append(' ');
                string t = toks[i];
                if (t.StartsWith("ADDR=", StringComparison.Ordinal))
                {
                    string target = t.Substring(5);
                    // Octal targets (no label found) stay plain; labels get linked
                    if (ND5000Compiler.ParseOctal(target) < 0 || !IsSixDigitOctal(target))
                    {
                        sb.Append("[ADDR=").Append(target).Append("](#").Append(Slug(target)).Append(')');
                        continue;
                    }
                }
                sb.Append(t);
            }
            return sb.ToString();
        }

        /// <summary>True when the ADDR target is the 6-digit zero-padded octal form (not a label).</summary>
        static bool IsSixDigitOctal(string s)
        {
            if (s.Length != 6) return false;
            for (int i = 0; i < 6; i++)
            {
                if (s[i] < '0' || s[i] > '7') return false;
            }
            return true;
        }

        // ------------------------------------------------------------------
        // Parsing / validation
        // ------------------------------------------------------------------

        /// <summary>Parse an octal string into a long (LARG needs 32 bits); -1 when not octal.</summary>
        static long ParseOctalLong(string value)
        {
            if (value.Length == 0) return -1;
            long v = 0;
            for (int i = 0; i < value.Length; i++)
            {
                char c = value[i];
                if (c < '0' || c > '7') return -1;
                v = (v << 3) | (long)(c - '0');
                if (v > 0xFFFFFFFFL) return -1;   // nothing in the listing is wider than 32 bits
            }
            return v;
        }

        /// <summary>Parse a 2-digit uppercase hex value (the ORCON notation); -1 when malformed.</summary>
        static int ParseHexByte(string value)
        {
            if (value.Length == 0 || value.Length > 2) return -1;
            int v = 0;
            for (int i = 0; i < value.Length; i++)
            {
                char c = value[i];
                int d;
                if (c >= '0' && c <= '9') d = c - '0';
                else if (c >= 'A' && c <= 'F') d = c - 'A' + 10;
                else return -1;
                v = (v << 4) | d;
            }
            return v;
        }

        /// <summary>
        /// Parse one instruction cell (markdown text, links included) back
        /// into ND-5000 assembler tokens for ND5000Compiler.Translate.
        ///
        /// The listing notations are resolved to the raw assembler dialect:
        ///   - markdown links are stripped, ADDR=label resolved via the label
        ///     map to ABS_ADDR=octal
        ///   - LARG= becomes the long-argument 'hi,lo' form; SARG=/MARG=
        ///     become plain short arguments (MARG merged with a redundant
        ///     IX*/SCAL decoration - its bits 7-6 overlap the argument)
        ///   - decorations that repeat argument bits (ADDR/IX*/ORCON inside a
        ///     LARG or SARG) are consistency-checked and dropped
        ///   - ORCON=hex sets OR_ENABLE=1 + ORCON; ORCON=0x followed by hex
        ///     sets only ORCON
        ///   - suppressed defaults are re-injected: D,NONE when no
        ///     destination, TBC,NOOP when no TBC, T,NEXT when no true-path
        ///     jump type, F,NEXT when C,SEQ present without a false-path type
        /// Returns null and an error message when the text is not parseable.
        /// </summary>
        public List<string>? ParseInstructionCell(string cell, ND5000LabelMap labels, out string? error)
        {
            error = null;

            // Strip markdown links: [ADDR=NAME](#slug) -> ADDR=NAME
            cell = System.Text.RegularExpressions.Regex.Replace(cell, @"\[([^\]]+)\]\(#[^)]*\)", "$1");

            var parts = cell.Split(' ');
            var mnemonics = new List<string>();

            long larg = -1, sarg = -1, marg = -1;
            int addr = -1, orconHex = -1, orconRaw = -1, scalVal = -1;
            bool orEnable = false;
            bool destSeen = false, tbcSeen = false, tTypeSeen = false, fTypeSeen = false, condSeq = false;
            bool scalIsToken = false;

            for (int i = 0; i < parts.Length; i++)
            {
                string tok = parts[i].Trim();
                if (tok.Length == 0) continue;
                // decodeSeq joins type and stack with ", " - strip the trailing comma
                if (tok.EndsWith(",", StringComparison.Ordinal)) tok = tok.Substring(0, tok.Length - 1);
                if (tok.Length == 0) continue;

                int eq = tok.IndexOf('=');
                if (eq > 0)
                {
                    string name = tok.Substring(0, eq);
                    string val = tok.Substring(eq + 1);

                    switch (name)
                    {
                        case "LARG":
                            larg = ParseOctalLong(val);
                            if (larg < 0) { error = $"bad LARG value '{val}'"; return null; }
                            continue;
                        case "SARG":
                            sarg = ParseOctalLong(val);
                            if (sarg < 0 || sarg > 0xFFFF) { error = $"bad SARG value '{val}'"; return null; }
                            continue;
                        case "MARG":
                            marg = ParseOctalLong(val);
                            if (marg < 0 || marg > 0xFF) { error = $"bad MARG value '{val}'"; return null; }
                            continue;
                        case "ADDR":
                            if (IsSixDigitOctal(val))
                            {
                                addr = (int)ParseOctalLong(val);
                            }
                            else if (!labels.NameToAddr.TryGetValue(val, out addr))
                            {
                                error = $"unknown ADDR label '{val}'";
                                return null;
                            }
                            continue;
                        case "ORCON":
                            if (val.StartsWith("0x", StringComparison.Ordinal))
                            {
                                orconRaw = ParseHexByte(val.Substring(2));
                                if (orconRaw < 0) { error = $"bad ORCON value '{val}'"; return null; }
                            }
                            else
                            {
                                orconHex = ParseHexByte(val);
                                if (orconHex < 0) { error = $"bad ORCON value '{val}'"; return null; }
                                orEnable = true;   // the JS prints ORCON= only when OR_ENABLE is set
                            }
                            continue;
                        case "SCAL":
                            scalVal = (int)ParseOctalLong(val);
                            if (scalVal < 0 || scalVal > 7) { error = $"bad SCAL value '{val}'"; return null; }
                            scalIsToken = false;
                            continue;
                        default:
                            // Raw FIELDNAME=<octal> pass-through (A_OP=, TESTOBJ=, TBC=, AA=, ...)
                            if (!ND5000Fields.TryLookup(name, out _))
                            {
                                error = $"unknown field notation '{tok}'";
                                return null;
                            }
                            if (name == "DEST") destSeen = true;
                            if (name == "TBC") tbcSeen = true;
                            if (name == "SEQT_TYPE") tTypeSeen = true;
                            if (name == "SEQF_TYPE") fTypeSeen = true;
                            mnemonics.Add(tok);
                            continue;
                    }
                }

                // Mnemonic token
                var t = tokens.LookupToken(tok);
                if (t == null)
                {
                    error = $"unknown mnemonic '{tok}'";
                    return null;
                }

                // Track notations that drive default re-injection / argument merging
                if (tok == "C,SEQ") condSeq = true;
                if (tok.StartsWith("D,", StringComparison.Ordinal)) destSeen = true;
                if (tok.StartsWith("TBC,", StringComparison.Ordinal)) tbcSeen = true;
                if (tok == "T,JMP" || tok == "T,JMPREL" || tok == "T,RETURN" || tok == "T,NEXT") tTypeSeen = true;
                if (tok == "F,JMP" || tok == "F,JMPREL" || tok == "F,RETURN" || tok == "F,NEXT") fTypeSeen = true;
                if (tok == "IX*2") { scalVal = 1; scalIsToken = true; continue; }
                if (tok == "IX*4") { scalVal = 2; scalIsToken = true; continue; }
                if (tok == "IX*8") { scalVal = 3; scalIsToken = true; continue; }
                if (tok == "IX/8") { scalVal = 4; scalIsToken = true; continue; }
                if (tok == "IX*16") { scalVal = 5; scalIsToken = true; continue; }

                mnemonics.Add(tok);
            }

            // --- resolve the low-word notations ---------------------------------

            int argModes = (larg >= 0 ? 1 : 0) + (sarg >= 0 ? 1 : 0) + (marg >= 0 ? 1 : 0);
            if (argModes > 1) { error = "conflicting LARG/SARG/MARG arguments"; return null; }

            if (larg >= 0)
            {
                // Decorations inside the 32-bit argument must agree with it
                if (addr >= 0 && addr != (int)(larg >> 16)) { error = "ADDR decoration disagrees with LARG"; return null; }
                if (scalVal >= 0 && scalVal != (int)((larg >> 6) & 7)) { error = "SCAL decoration disagrees with LARG"; return null; }
                if (orconHex >= 0 && orconHex != (int)(larg & 0x3F)) { error = "ORCON decoration disagrees with LARG"; return null; }
                if (orconRaw >= 0) { error = "ORCON=0x form is redundant under LARG"; return null; }
                mnemonics.Add(OctPad(larg >> 16, 1) + "," + OctPad(larg & 0xFFFF, 1));   // long-argument 'hi,lo'
            }
            else if (sarg >= 0)
            {
                if (scalVal >= 0 && scalVal != (int)((sarg >> 6) & 7)) { error = "SCAL decoration disagrees with SARG"; return null; }
                if (orconHex >= 0 && orconHex != (int)(sarg & 0x3F)) { error = "ORCON decoration disagrees with SARG"; return null; }
                if (orconRaw >= 0) { error = "ORCON=0x form is redundant under SARG"; return null; }
                if (sarg != 0) mnemonics.Add(OctPad(sarg, 1));   // short argument (a zero contributes nothing)
                if (addr >= 0) mnemonics.Add("ABS_ADDR=" + Oct(addr));
            }
            else
            {
                if (marg >= 0)
                {
                    // MARG covers bits 7-0; a SCAL decoration (bits 8-6)
                    // partially overlaps it - verify the shared bits 7-6 and
                    // merge into one short argument covering bits 8-0
                    long low = marg;
                    if (scalVal >= 0)
                    {
                        if ((scalVal & 3) != (int)((marg >> 6) & 3)) { error = "SCAL decoration disagrees with MARG"; return null; }
                        low |= (long)scalVal << 6;
                    }
                    if (orconHex >= 0 && orconHex != (int)(marg & 0x3F)) { error = "ORCON decoration disagrees with MARG"; return null; }
                    if (orconRaw >= 0) { error = "ORCON=0x form is redundant under MARG"; return null; }
                    if (low != 0) mnemonics.Add(OctPad(low, 1));
                }
                else
                {
                    // No argument overlay: AA/AB/SCAL/ORCON are disjoint raw fields
                    if (scalVal >= 0)
                    {
                        if (scalIsToken) mnemonics.Add(tokens.LookupFieldToken("SCAL", scalVal)!);
                        else mnemonics.Add("SCAL=" + Oct(scalVal));
                    }
                    if (orconHex > 0) mnemonics.Add("ORCON=" + Oct(orconHex));
                    if (orconRaw > 0) mnemonics.Add("ORCON=" + Oct(orconRaw));
                }
                if (addr >= 0) mnemonics.Add("ABS_ADDR=" + Oct(addr));
            }
            if (orEnable) mnemonics.Add("OR_ENABLE=1");

            // --- re-inject the suppressed nonzero defaults -----------------------
            if (!destSeen) mnemonics.Add("D,NONE");        // DEST default 24
            if (!tbcSeen) mnemonics.Add("TBC,NOOP");       // TBC default 7
            if (!tTypeSeen) mnemonics.Add("T,NEXT");       // SEQ_TRUE jump type default NEXT (3)
            if (condSeq && !fTypeSeen) mnemonics.Add("F,NEXT");   // false path only defaults to NEXT under C,SEQ; without C,SEQ absence means 0

            return mnemonics;
        }

        /// <summary>
        /// Validate one generated instruction cell: re-parse it from its own
        /// markdown text and reassemble through ND5000Compiler.Translate; the
        /// result must be bit-exact against <paramref name="originalWord"/>.
        /// </summary>
        public bool ValidateCell(string cell, ushort[] originalWord, ND5000LabelMap labels,
            ND5000Compiler compiler, int address, out string? error)
        {
            var toks = ParseInstructionCell(cell, labels, out error);
            if (toks == null) return false;

            var instruction = new Instruction();
            instruction.Address = address;
            instruction.Args = toks;

            int errorsBefore = compiler.ErrorCount;
            ushort[] rebuilt = new ushort[ND5000Compiler.WORD_PARTS];
            compiler.Translate(instruction, emptyLabels, rebuilt);
            if (compiler.ErrorCount != errorsBefore)
            {
                error = "assembler errors during reassembly";
                return false;
            }

            for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
            {
                if (rebuilt[i] != originalWord[i])
                {
                    error = $"reassembly mismatch part {i}: expected {Convert.ToString(originalWord[i], 8).PadLeft(6, '0')}, got {Convert.ToString(rebuilt[i], 8).PadLeft(6, '0')}";
                    return false;
                }
            }
            return true;
        }

        readonly Labels emptyLabels = new Labels();   // ADDR labels are resolved to octal before Translate

        // ------------------------------------------------------------------
        // File generation
        // ------------------------------------------------------------------

        const int WORD_BYTES = ND5000Compiler.WORD_PARTS * 2;   // 16 bytes per word, big-endian

        /// <summary>Extract the 8 word parts for one address from a .DATA image (byte 0 = bits 127-120).</summary>
        public static void GetWord(byte[] image, int address, ushort[] word)
        {
            int off = address * WORD_BYTES;
            for (int i = 0; i < ND5000Compiler.WORD_PARTS; i++)
            {
                word[i] = (ushort)((image[off + i * 2] << 8) | image[off + i * 2 + 1]);
            }
        }

        /// <summary>
        /// Build the full markdown listing for a .DATA image + label map,
        /// validating EVERY instruction line (see class remarks) before any
        /// text is returned. Throws on the first line that fails validation -
        /// an unvalidated file must never be written.
        /// </summary>
        public string GenerateMarkdown(byte[] data, ND5000LabelMap labels, string fileName, string generatedTimestamp)
        {
            if (data.Length != ND5000Compiler.CONTROL_STORE_WORDS * WORD_BYTES)
            {
                throw new ArgumentException($"{fileName}: expected {ND5000Compiler.CONTROL_STORE_WORDS} words x {WORD_BYTES} bytes, got {data.Length} bytes");
            }

            using var compiler = new ND5000Compiler();

            var lines = new List<string>(ND5000Compiler.CONTROL_STORE_WORDS + 16);
            lines.Add("# ND-5000 Microcode Disassembly");
            lines.Add("");
            lines.Add("| Property | Value |");
            lines.Add("|----------|-------|");
            lines.Add("| File | `" + fileName + "` |");
            lines.Add("| Generated | " + generatedTimestamp + " |");
            lines.Add("| Words | " + ND5000Compiler.CONTROL_STORE_WORDS + " |");
            lines.Add("| Labels | " + labels.Count + " |");
            lines.Add("");
            lines.Add("## Disassembly Listing");
            lines.Add("");
            lines.Add("| Address | Label | Instruction |");
            lines.Add("|---------|-------|-------------|");

            ushort[] word = new ushort[ND5000Compiler.WORD_PARTS];
            for (int addr = 0; addr < ND5000Compiler.CONTROL_STORE_WORDS; addr++)
            {
                GetWord(data, addr, word);

                string cell = FormatMarkdownCell(word, labels);

                // VALIDATION GATE: the cell text alone must reassemble to the
                // exact original 128-bit word
                if (!ValidateCell(cell, word, labels, compiler, addr, out string? error))
                {
                    throw new InvalidOperationException(
                        $"{fileName} address {OctPad(addr, 6)}: line validation failed ({error}); cell: {cell}");
                }

                string labelCell = "";
                if (labels.AddrToName.TryGetValue(addr, out string? name))
                {
                    labelCell = "<a id=\"" + Slug(name) + "\"></a>**" + name + "**";
                }

                lines.Add("| `" + OctPad(addr, 6) + "` | " + labelCell + " | " + cell + " |");
            }

            // The JS export uses lines.join('\n') - no trailing newline
            return string.Join("\n", lines);
        }

        /// <summary>
        /// Command line entry: read DATA + LABE, generate and validate the
        /// listing, write the markdown file. Returns the number of validated
        /// instruction lines (16384 on success; throws otherwise).
        /// </summary>
        public int GenerateListingFile(string dataPath, string labePath, string outPath)
        {
            byte[] data = File.ReadAllBytes(dataPath);
            var labels = ND5000LabelMap.Parse(File.ReadAllBytes(labePath));

            string fileName = Path.GetFileNameWithoutExtension(dataPath);
            string timestamp = DateTime.UtcNow.ToString("yyyy-MM-dd'T'HH:mm:ss.fff'Z'");

            string markdown = GenerateMarkdown(data, labels, fileName, timestamp);
            File.WriteAllText(outPath, markdown);

            Console.WriteLine($"{fileName}: {ND5000Compiler.CONTROL_STORE_WORDS} lines generated and validated, {labels.Count} labels -> {outPath}");
            return ND5000Compiler.CONTROL_STORE_WORDS;
        }
    }
}
