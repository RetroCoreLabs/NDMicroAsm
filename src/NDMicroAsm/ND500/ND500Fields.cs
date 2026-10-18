//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;

namespace NDMicroAsm.ND500
{
    /// <summary>
    /// One named bit field of the ND-500 144-bit micro word.
    /// </summary>
    public readonly struct ND500Field
    {
        /// <summary>
        /// The field name, as in the nd500uc micro code definition.
        /// </summary>
        public readonly string Name;

        /// <summary>
        /// The most significant bit of the field, 143 down to 0.
        /// </summary>
        public readonly int HighBit;

        /// <summary>
        /// The least significant bit of the field, 143 down to 0.
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
        public ND500Field(string name, int highBit, int lowBit)
        {
            Name = name;
            HighBit = highBit;
            LowBit = lowBit;
        }
    }

    /// <summary>
    /// The canonical, non-overlapping field partition of the ND-500 144-bit
    /// micro word, bits 143 down to 32, exactly as defined in the nd500uc
    /// project's microcode-500-def.json (in its docs folder), which in
    /// turn comes from the NORD-500 MICROPROGRAM FORMAT chart, the ND-05.012.01
    /// Micro Program Guide ch. 3 and Appendix A of ND-30.013.02.
    ///
    /// Bit 143 is the top bit; the word is stored as nine 16-bit control store
    /// parts CS8 (bits 143-128) down to CS0 (bits 15-0), big-endian per part.
    ///
    /// Bits 31-0 are NOT part of the partition: they are the argument area
    /// (long argument 31-0 / CSA address 29-16 / short argument 15-0) and are
    /// handled by the assembler's long/short argument syntax. The partition
    /// names bits 143-32 exactly once each.
    ///
    /// The alternative-ALU overlay (CARRY_FALSE bits 41-40, ALU_FALSE bits
    /// 36-32 - the external unit bits reused when no external cycle runs) is
    /// exposed via the sub fields, sharing bits with EXUNIT/EXFUNC by design.
    /// </summary>
    public static class ND500Fields
    {
        /// <summary>
        /// The canonical partition, highest bit first. Names and bit ranges
        /// match microcode-500-def.json exactly.
        /// </summary>
        public static readonly ND500Field[] Partition =
        {
            new ND500Field("CTRL143",   143, 143),  // control function / spare (chart shows PARITY here - uncertain)
            new ND500Field("SPAREBIT",  142, 142),  // spare / inhibit SP clock
            new ND500Field("ALU_TRUE",  141, 137),  // ALU function, true path
            new ND500Field("CARRY",     136, 135),  // carry select
            new ND500Field("ASEL",      134, 125),  // A operand select (3-bit mux + 7-bit sub select)
            new ND500Field("BSEL",      124, 116),  // B operand select (3-bit mux + 6-bit sub select)
            new ND500Field("DSEL",      115, 106),  // destination select (3-bit group + 7-bit sub select)
            new ND500Field("ORA",       105, 105),  // OR logic enable: A operand
            new ND500Field("ORB",       104, 104),  // OR logic enable: B operand
            new ND500Field("ORD",       103, 103),  // OR logic enable: destination
            new ND500Field("ORMEM",     102, 102),  // OR logic enable: memory
            new ND500Field("ORT",       101, 101),  // OR logic enable: test
            new ND500Field("TYP",       100,  99),  // data type
            new ND500Field("MEMRQ",      98,  98),  // memory request
            new ND500Field("ALTMOD",     97,  97),  // alternative page table mode
            new ND500Field("MEMMV",      96,  96),  // memory move
            new ND500Field("MEMWR",      95,  95),  // memory write
            new ND500Field("MEMNBY",     94,  93),  // memory number of bytes
            new ND500Field("CSAVE",      92,  92),  // condition save
            new ND500Field("CSEQ",       91,  91),  // conditional sequence enable
            new ND500Field("CALU",       90,  90),  // conditional ALU enable
            new ND500Field("CMEM",       89,  89),  // conditional memory enable
            new ND500Field("COND",       88,  84),  // test condition select
            new ND500Field("SEQ_TRUE",   83,  76),  // sequence instruction, true path
            new ND500Field("SET",        75,  75),  // set condition select
            new ND500Field("CSEQD",      74,  74),  // delayed conditional sequence
            new ND500Field("SEQ_FALSE",  73,  66),  // sequence instruction, false path
            new ND500Field("STCTL",      65,  64),  // status control
            new ND500Field("PRF",        63,  60),  // prefetch control
            new ND500Field("TIM",        59,  58),  // timing control
            new ND500Field("WAIT",       57,  55),  // wait for select
            new ND500Field("STSAVA",     54,  54),  // status save
            new ND500Field("LCDECR",     53,  53),  // loop counter decrement
            new ND500Field("IADJ",       52,  52),  // index counter adjust
            new ND500Field("AACTL",      51,  49),  // address arithmetic control
            new ND500Field("AB",         48,  45),  // address arithmetic B operand
            new ND500Field("AA",         44,  43),  // address arithmetic A operand
            new ND500Field("EXACT",      42,  42),  // external unit activate
            new ND500Field("EXUNIT",     41,  40),  // external unit select (overlay: CARRY_FALSE)
            new ND500Field("MVBUS",      39,  38),  // move bus control
            new ND500Field("XRES",       37,  37),  // external unit reserve
            new ND500Field("EXFUNC",     36,  32),  // external unit function (overlay: ALU_FALSE)
        };

        /// <summary>
        /// Sub fields overlapping the partition entries above, addressable in
        /// raw FIELDNAME=octal syntax just like the partition fields. The mux/
        /// sub splits come from microcode-500-def.json; the alternative-ALU
        /// overlay (CARRY_FALSE / ALU_FALSE) shares bits with EXUNIT / EXFUNC
        /// by hardware design; IXSEL overlays the low two BSUB bits.
        /// </summary>
        public static readonly ND500Field[] Subfields =
        {
            new ND500Field("AMUX",        134, 132),  // A operand mux (top 3 bits of ASEL)
            new ND500Field("ASUB",        131, 125),  // A operand sub select
            new ND500Field("BMUX",        124, 122),  // B operand mux (top 3 bits of BSEL)
            new ND500Field("BSUB",        121, 116),  // B operand sub select
            new ND500Field("DGROUP",      115, 113),  // destination group (top 3 bits of DSEL)
            new ND500Field("DSUB",        112, 106),  // destination sub select
            new ND500Field("IXSEL",       117, 116),  // index register select (overlays BSUB bits 1-0)
            new ND500Field("CARRY_FALSE",  41,  40),  // alternative carry select (overlays EXUNIT)
            new ND500Field("ALU_FALSE",    36,  32),  // alternative ALU function (overlays EXFUNC)
            new ND500Field("EA2INH",       31,  31),  // EA2 clock inhibit (argument area bit 31)
            new ND500Field("EA1INH",       30,  30),  // EA1 clock inhibit (argument area bit 30)
            new ND500Field("CSA_ADDRESS",  29,  16),  // absolute micro program address
            new ND500Field("SHORT_ARGUMENT", 15,  0), // short argument
        };

        static readonly Dictionary<string, ND500Field> byName = BuildLookup();

        static Dictionary<string, ND500Field> BuildLookup()
        {
            var d = new Dictionary<string, ND500Field>();
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
        public static bool TryLookup(string name, out ND500Field field)
        {
            return byName.TryGetValue(name, out field);
        }
    }
}
