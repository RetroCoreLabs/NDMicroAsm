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
    /// Lossless ND-5000 micro code disassembler.
    ///
    /// Given a 128-bit micro word (eight 16-bit parts, Words[0] = bits 127-112
    /// ... Words[7] = bits 15-0) it emits an ordered token list such that
    /// reassembling the tokens with <see cref="ND5000Compiler"/> reproduces
    /// the word EXACTLY:
    ///
    ///   - the word is walked using the canonical non-overlapping field
    ///     partition from <see cref="ND5000Fields"/> (all 128 bits covered)
    ///   - a field whose value is zero is omitted (zero contributes nothing,
    ///     so omission is round-trip safe)
    ///   - a nonzero field emits its mnemonic token when one exists for the
    ///     exact value, else the raw fallback FIELDNAME=octal
    ///   - ALU_TRUE/ALU_FALSE are decoded as 4-bit op + 2-bit carry, and
    ///     SEQ_TRUE/SEQ_FALSE as 2-bit jump + 2-bit stack, exactly how the
    ///     tokens are defined - so lookups always match
    ///   - the split memory code is recombined (bit 41 shifted left by three, ORed with bits 34-32,
    ///     as the reference JS disassembler does) and looked up as one token;
    ///     if unknown, the raw fallback is per split part (MEM_BIT3 /
    ///     MEM_BITS20) so the compiler can place the bits back verbatim
    ///   - bits 31-0 are handled canonically: ABS_ADDR, AA, AB, SCAL and
    ///     ORCON are ALWAYS emitted as raw octal fields when nonzero. This
    ///     keeps LARG/SARG/MARG argument overlays (bits 31-0 reused as
    ///     immediate data when A_OP selects A,LARG / A,SARG / A,MARG)
    ///     lossless without any semantic interpretation.
    ///
    /// Unlike the reference JS (which suppresses semantic defaults such as
    /// SEQ jump=NEXT or stack=HOLD), suppression here is purely "value == 0";
    /// nonzero defaults like DEST=24 (D,NOOP) and TBC=7 (TBC,NOOP) are
    /// emitted via their tokens so nothing is lost.
    /// </summary>
    public class ND5000Disassembler
    {
        readonly ND5000Tokens tokens;

        /// <summary>
        /// Creates a disassembler with the ND-5000 mnemonic table and its reverse map loaded.
        /// </summary>
        public ND5000Disassembler()
        {
            tokens = new ND5000Tokens();
            tokens.InitializeTokens();
        }

        /// <summary>
        /// Disassemble one 128-bit micro word into an ordered token list.
        /// Order follows the reference JS disassemble(): ALU, execution
        /// control, operands, status, sequencer, IAC, memory, address.
        /// </summary>
        public List<string> Disassemble(ushort[] word)
        {
            if (word == null || word.Length != ND5000Token.WORD_PARTS)
            {
                throw new ArgumentException("ND-5000 micro word must be 8 x 16-bit parts");
            }

            var m = new List<string>();

            // --- ALU (both paths; COND_ALU gates semantics, not bits) ------
            EmitField(m, word, "COND_ALU");
            EmitField(m, word, "ALU_OP");       // ALU_TRUE bits 127-124
            EmitField(m, word, "ALU_CRY");      // ALU_TRUE bits 123-122
            EmitField(m, word, "ALUF_OP");      // ALU_FALSE bits 121-118
            EmitField(m, word, "ALUF_CRY");     // ALU_FALSE bits 117-116
            EmitField(m, word, "EXUC");

            // --- Q register / AAP / timing / data type ---------------------
            EmitField(m, word, "Q_REG");
            EmitField(m, word, "AAP_CTRL");     // combined selector+op byte tokens (AAP1,x / AAP2,x / EXPISO)
            EmitField(m, word, "TIMING");
            EmitField(m, word, "DATATYPE");

            // --- Operands ---------------------------------------------------
            EmitField(m, word, "OR_ENABLE");
            EmitField(m, word, "A_OP");         // A,LARG/A,SARG/A,MARG come out as plain tokens;
                                                // their argument bits are covered by the raw
                                                // ABS_ADDR/AA/AB/SCAL/ORCON emission below
            EmitField(m, word, "B_OP");
            EmitField(m, word, "DEST");         // 24 = D,NOOP token (nonzero default)

            // --- Status -------------------------------------------------------
            EmitField(m, word, "STATUS");
            EmitField(m, word, "IXC_INCR");
            EmitField(m, word, "LC_DECR");

            // --- Sequencer ------------------------------------------------------
            EmitField(m, word, "COND_SEQ");
            EmitField(m, word, "SEQT_TYPE");    // SEQ_TRUE bits 68-67 (T,JMPREL/T,RETURN/T,NEXT)
            EmitField(m, word, "SEQT_STACK");   // SEQ_TRUE bits 66-65 (T,POP/T,LOAD/T,PUSH)
            EmitField(m, word, "SEQF_TYPE");    // SEQ_FALSE bits 64-63
            EmitField(m, word, "SEQF_STACK");   // SEQ_FALSE bits 62-61
            EmitField(m, word, "INVSEQ");
            EmitField(m, word, "CSAVE");
            EmitField(m, word, "TESTOBJ");

            // --- IAC / control ----------------------------------------------------
            EmitField(m, word, "ABR");
            EmitField(m, word, "TBC");          // 7 = TBC,NOOP token (nonzero default)
            EmitField(m, word, "GET");
            EmitField(m, word, "STOP");
            EmitField(m, word, "AAPSYNC");

            // --- Memory: recombine the split 4-bit op code -------------------------
            int memBit3 = ExtractField(word, 41, 41);
            int memBits20 = ExtractField(word, 34, 32);
            int mem = (memBit3 << 3) | memBits20;
            if (mem != 0)
            {
                string? memToken = tokens.LookupFieldToken(ND5000TokensBase.MEM_FIELD, mem);
                if (memToken != null)
                {
                    m.Add(memToken);
                }
                else
                {
                    // No mnemonic for this code: fall back per split part so
                    // the compiler places the exact bits back
                    if (memBit3 != 0) m.Add("MEM_BIT3=1");
                    if (memBits20 != 0) m.Add("MEM_BITS20=" + Convert.ToString(memBits20, 8));
                }
            }
            EmitField(m, word, "AD_ARTI");      // no mnemonic exists - always raw
            EmitField(m, word, "EA_SAVE");
            EmitField(m, word, "MEMOT");
            EmitField(m, word, "RESERVED_36");  // reserved bit - always raw
            EmitField(m, word, "ADACT");

            // --- Bits 31-0: canonical raw partition ----------------------------------
            // Always raw octal (never mnemonics) so LARG/SARG/MARG overlays and
            // jump addresses round-trip bit-exactly with zero interpretation.
            EmitRaw(m, word, "ABS_ADDR");
            EmitRaw(m, word, "AA");
            EmitRaw(m, word, "AB");
            EmitRaw(m, word, "SCAL");
            EmitRaw(m, word, "ORCON");

            return m;
        }

        /// <summary>
        /// Emit the mnemonic token for a field when its value is nonzero;
        /// falls back to raw FIELDNAME=octal when no token covers the value.
        /// </summary>
        void EmitField(List<string> m, ushort[] word, string fieldName)
        {
            if (!ND5000Fields.TryLookup(fieldName, out var f))
            {
                throw new InvalidOperationException($"Unknown ND-5000 field {fieldName}");
            }

            int v = ExtractField(word, f.HighBit, f.LowBit);
            if (v == 0) return;   // zero contributes nothing - omission is round-trip safe

            string? token = tokens.LookupFieldToken(fieldName, v);
            if (token != null)
            {
                m.Add(token);
            }
            else
            {
                m.Add(fieldName + "=" + Convert.ToString(v, 8));
            }
        }

        /// <summary>
        /// Emit a field as raw FIELDNAME=octal when nonzero (never a mnemonic).
        /// </summary>
        static void EmitRaw(List<string> m, ushort[] word, string fieldName)
        {
            if (!ND5000Fields.TryLookup(fieldName, out var f))
            {
                throw new InvalidOperationException($"Unknown ND-5000 field {fieldName}");
            }

            int v = ExtractField(word, f.HighBit, f.LowBit);
            if (v == 0) return;
            m.Add(fieldName + "=" + Convert.ToString(v, 8));
        }

        /// <summary>
        /// Extract micro word bits highBit..lowBit from the 8-part word
        /// (bit 127 = Words[0] bit 15 ... bit 0 = Words[7] bit 0).
        /// Field widths are at most 16 bits so an int suffices.
        /// </summary>
        public static int ExtractField(ushort[] word, int highBit, int lowBit)
        {
            int value = 0;
            for (int bit = highBit; bit >= lowBit; bit--)
            {
                int part = 7 - (bit / 16);
                int bitInPart = bit % 16;
                value = (value << 1) | ((word[part] >> bitInPart) & 1);
            }
            return value;
        }
    }
}
