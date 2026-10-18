//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;

namespace NDMicroAsm.ND5000
{
    /// <summary>
    /// One named bit field of the ND-5000 128-bit micro word.
    /// </summary>
    public readonly struct ND5000Field
    {
        /// <summary>
        /// The field name, as in the ND-5000 micro code definition.
        /// </summary>
        public readonly string Name;

        /// <summary>
        /// The most significant bit of the field, 127 down to 0.
        /// </summary>
        public readonly int HighBit;

        /// <summary>
        /// The least significant bit of the field, 127 down to 0.
        /// </summary>
        public readonly int LowBit;

        /// <summary>
        /// Number of bits in the field.
        /// </summary>
        public int Width => HighBit - LowBit + 1;

        /// <summary>Highest value that fits in the field.</summary>
        public ulong MaxValue => (1UL << Width) - 1;

        /// <summary>
        /// Defines a field by its bit range.
        /// </summary>
        /// <param name="name">
        /// The field name.
        /// </param>
        /// <param name="highBit">
        /// The most significant bit.
        /// </param>
        /// <param name="lowBit">
        /// The least significant bit.
        /// </param>
        public ND5000Field(string name, int highBit, int lowBit)
        {
            Name = name;
            HighBit = highBit;
            LowBit = lowBit;
        }
    }

    /// <summary>
    /// The canonical, non-overlapping field partition of the ND-5000 128-bit
    /// micro word, as decoded by the reference JS disassembler
    /// (nd5000uc index.html FIELDS table, documented in
    /// ND5000-APP-ARCHITECTURE.md section 3/4). Bit 127 is the top bit;
    /// byte 0 of a .DATA image holds bits 127-120 (big-endian).
    ///
    /// Together the partition covers all 128 bits exactly once. Note that the
    /// reference FIELDS table leaves bit 36 unassigned (reserved); it is
    /// included here as RESERVED_36 so a raw disassembly/assembly round trip
    /// is lossless even if real microcode sets that bit.
    ///
    /// The MEMORY operation code in microcode-5000-def.json is a 4-bit value
    /// stored SPLIT: code bit 3 lives in micro word bit 41 (MEM_BIT3) and
    /// code bits 2-0 live in bits 34-32 (MEM_BITS20), because bits 40-35 in
    /// between belong to other fields. The JS recombines them as MEM_BIT3
    /// shifted left by three, ORed with MEM_BITS20.
    /// </summary>
    public static class ND5000Fields
    {
        /// <summary>
        /// The canonical partition, highest bit first. Names and bit ranges
        /// match the JS FIELDS table exactly (plus RESERVED_36 for bit 36).
        /// </summary>
        public static readonly ND5000Field[] Partition =
        {
            new ND5000Field("ALU_TRUE",   127, 122),  // ALU function, true path (4-bit op + 2-bit carry)
            new ND5000Field("ALU_FALSE",  121, 116),  // ALU function, false path (4-bit op + 2-bit carry)
            new ND5000Field("EXUC",       115, 115),  // execute unconditional
            new ND5000Field("COND_ALU",   114, 114),  // enable conditional ALU operation
            new ND5000Field("Q_REG",      113, 111),  // Q register operation
            new ND5000Field("AAP_CTRL",   110, 103),  // AAP control (3-bit selector + 5-bit op)
            new ND5000Field("TIMING",     102, 101),  // cycle time (JSON field is named TIMING, not CYCLE)
            new ND5000Field("DATATYPE",   100,  98),  // data type
            new ND5000Field("OR_ENABLE",   97,  97),  // OR control enable (gates ORCON)
            new ND5000Field("A_OP",        96,  89),  // A operand select (3-bit group + 5-bit register)
            new ND5000Field("B_OP",        88,  84),  // B operand select
            new ND5000Field("DEST",        83,  76),  // destination select (default 24 = D,NOOP)
            new ND5000Field("STATUS",      75,  72),  // status operation
            new ND5000Field("IXC_INCR",    71,  71),  // index counter increment (IXADJ)
            new ND5000Field("LC_DECR",     70,  70),  // loop counter decrement (LCDECR)
            new ND5000Field("COND_SEQ",    69,  69),  // enable conditional sequence
            new ND5000Field("SEQ_TRUE",    68,  65),  // sequencer, true path (2-bit jump + 2-bit stack)
            new ND5000Field("SEQ_FALSE",   64,  61),  // sequencer, false path (2-bit jump + 2-bit stack)
            new ND5000Field("INVSEQ",      60,  60),  // invert test condition
            new ND5000Field("CSAVE",       59,  59),  // push test condition to stack
            new ND5000Field("TESTOBJ",     58,  53),  // test object (condition select)
            new ND5000Field("ABR",         52,  51),  // alternative branch address calculation
            new ND5000Field("TBC",         50,  48),  // instruction cache write control (default 7 = TBC,NOOP)
            new ND5000Field("GET",         47,  44),  // instruction/operand fetch
            new ND5000Field("STOP",        43,  43),  // stop microprogram
            new ND5000Field("AAPSYNC",     42,  42),  // wait for AAP ready
            new ND5000Field("MEM_BIT3",    41,  41),  // memory op code bit 3 (see class remarks)
            new ND5000Field("AD_ARTI",     40,  40),  // address arithmetic (extracted but never emitted by the JS)
            new ND5000Field("EA_SAVE",     39,  38),  // effective address save (lives in the MEMORY group of the JSON)
            new ND5000Field("MEMOT",       37,  37),  // memory request if data operand (C,MEMOT)
            new ND5000Field("RESERVED_36", 36,  36),  // reserved - not in the JS FIELDS table
            new ND5000Field("ADACT",       35,  35),  // address arithmetic activate
            new ND5000Field("MEM_BITS20",  34,  32),  // memory op code bits 2-0 (see class remarks)
            new ND5000Field("ABS_ADDR",    31,  16),  // sequencer jump target address
            new ND5000Field("AA",          15,  13),  // address A operand select
            new ND5000Field("AB",          12,   9),  // address B operand select
            new ND5000Field("SCAL",         8,   6),  // index scaling
            new ND5000Field("ORCON",        5,   0),  // OR control (only meaningful when OR_ENABLE set)
        };

        /// <summary>
        /// Sub fields overlapping the partition entries above. These carry the
        /// mnemonic split used by the JS decode helpers: ALU 4-bit op + 2-bit
        /// carry, sequencer 2-bit jump type + 2-bit stack op, and the ORCON
        /// sub controls. They are addressable in raw FIELDNAME=octal syntax
        /// just like the partition fields.
        /// </summary>
        public static readonly ND5000Field[] Subfields =
        {
            new ND5000Field("ALU_OP",     127, 124),  // ALU_TRUE op       - JS decodeAlu: (v >> 2) & 0xF
            new ND5000Field("ALU_CRY",    123, 122),  // ALU_TRUE carry    - JS decodeAlu: v & 3
            new ND5000Field("ALUF_OP",    121, 118),  // ALU_FALSE op
            new ND5000Field("ALUF_CRY",   117, 116),  // ALU_FALSE carry
            new ND5000Field("SEQT_TYPE",   68,  67),  // SEQ_TRUE jump     - JS decodeSeq: (v >> 2) & 3
            new ND5000Field("SEQT_STACK",  66,  65),  // SEQ_TRUE stack    - JS decodeSeq: v & 3
            new ND5000Field("SEQF_TYPE",   64,  63),  // SEQ_FALSE jump
            new ND5000Field("SEQF_STACK",  62,  61),  // SEQ_FALSE stack
            new ND5000Field("ORCON_N",      5,   5),  // OR control: next
            new ND5000Field("ORCON_E",      4,   4),  // OR control: enable
            new ND5000Field("ORCON_A",      3,   2),  // OR control: address
            new ND5000Field("ORCON_D",      1,   0),  // OR control: data
        };

        static readonly Dictionary<string, ND5000Field> byName = BuildLookup();

        static Dictionary<string, ND5000Field> BuildLookup()
        {
            var d = new Dictionary<string, ND5000Field>();
            for (int i = 0; i < Partition.Length; i++)
            {
                d.Add(Partition[i].Name, Partition[i]);
            }
            for (int i = 0; i < Subfields.Length; i++)
            {
                d.Add(Subfields[i].Name, Subfields[i]);
            }
            return d;
        }

        /// <summary>Look up a partition field or sub field by name.</summary>
        public static bool TryLookup(string name, out ND5000Field field)
        {
            return byName.TryGetValue(name, out field);
        }
    }
}
