//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System;
using System.Collections.Generic;

namespace NDMicroAsm.Core
{
    /// <summary>
    /// A label in a micro code source and the control store address it stands for.
    /// </summary>
    /// <remarks>
    /// Equality and ordering are by <see cref="Address"/> only: two labels at the same
    /// address compare equal, which is how the symbol files group them.
    /// </remarks>
    public class LabelDefinition : IEquatable<LabelDefinition>, IComparable<LabelDefinition>
    {
        /// <summary>
        /// The label text as written in the source, without the trailing colon or comma.
        /// </summary>
        public string? Label;

        /// <summary>
        /// The control store address the label was defined at.
        /// </summary>
        public int Address;

        /// <summary>
        /// Orders labels by <see cref="Address"/>; a null <paramref name="other"/> sorts first.
        /// </summary>
        /// <param name="other">
        /// The label to compare against.
        /// </param>
        /// <returns>
        /// Negative, zero or positive as this label's address is below, equal to or above the other's.
        /// </returns>
        public int CompareTo(LabelDefinition? other)
        {
            // A null value means that this object is greater.
            if (other == null)
                return 1;

            else
                return this.Address.CompareTo(other.Address);
        }

        /// <summary>
        /// Two labels are equal when they stand for the same <see cref="Address"/>.
        /// </summary>
        /// <param name="other">
        /// The label to compare against.
        /// </param>
        /// <returns>
        /// True when both labels have the same address.
        /// </returns>
        public bool Equals(LabelDefinition? other)
        {
            if (other == null) return false;
            return (this.Address.Equals(other.Address));
        }

        /// <summary>
        /// The hash is the <see cref="Address"/>, matching <see cref="Equals(LabelDefinition?)"/>.
        /// </summary>
        /// <returns>
        /// The control store address.
        /// </returns>
        public override int GetHashCode()
        {
            return Address;
        }
    }

    /// <summary>
    /// The label table of one assembly: every label the preprocessor found, in definition order.
    /// </summary>
    public class Labels
    {
        /// <summary>
        /// What <c>MapLabelToAddress</c> returns for a label that is not in the table.
        /// </summary>
        public static readonly int UNDEFINED = -1;

        List<LabelDefinition> _labels = new List<LabelDefinition>();

        internal int MapLabelToAddress(string label)
        {
            for (int lblIdx = 0; lblIdx < _labels.Count; lblIdx++)
            {
                if (_labels[lblIdx].Label == label)
                {
                    return _labels[lblIdx].Address;
                }
            }
            return (int)UNDEFINED;
        }

        internal void AddLabelAndAddress(string label, int address)
        {
            _labels.Add(new LabelDefinition() { Label = label, Address = address });
        }

        /// <summary>
        /// The labels sorted by name, for the by-name half of the symbol file.
        /// </summary>
        /// <returns>
        /// A new list; the table itself keeps definition order.
        /// </returns>
        public List<LabelDefinition> GetSortedByName()
        {
            return SortedCopy(_labels, CompareByName);
        }

        /// <summary>
        /// The labels sorted by control store address, for the by-address half of the symbol file.
        /// </summary>
        /// <returns>
        /// A new list; the table itself keeps definition order.
        /// </returns>
        public List<LabelDefinition> GetSortedByAddress()
        {
            return SortedCopy(_labels, CompareByAddress);
        }

        // Stable sort of a copy: labels that compare equal keep their definition order, which
        // is what the symbol files were written with before (LINQ OrderBy is stable, List.Sort
        // is not), so the .SYMBOLS.TXT files in git stay byte-identical.
        static List<LabelDefinition> SortedCopy(List<LabelDefinition> source, Comparison<LabelDefinition> compare)
        {
            int count = source.Count;
            int[] order = new int[count];
            for (int i = 0; i < count; i++) order[i] = i;
            Array.Sort(order, (a, b) =>
            {
                int c = compare(source[a], source[b]);
                return c != 0 ? c : a.CompareTo(b);
            });
            var sorted = new List<LabelDefinition>(count);
            for (int i = 0; i < count; i++) sorted.Add(source[order[i]]);
            return sorted;
        }

        // Same comparers LINQ's OrderBy(p => p.Label) / OrderBy(p => p.Address) used: the
        // default string comparer (current culture) and plain integer order.
        static int CompareByName(LabelDefinition a, LabelDefinition b) => string.Compare(a.Label, b.Label);
        static int CompareByAddress(LabelDefinition a, LabelDefinition b) => a.Address.CompareTo(b.Address);
    }

    /// <summary>
    /// One source line that produces a micro word, as the preprocessor leaves it for the assembler.
    /// </summary>
    public class InstructionInfo
    {
        /// <summary>
        /// One-based line number in the source file, for error messages and the listing.
        /// </summary>
        public int LineNumber;

        /// <summary>
        /// The control store address the micro word is assembled to.
        /// </summary>
        public int Address;

        /// <summary>
        /// The instruction text with labels, address prefix and comments stripped; null for a line
        /// that defines labels only.
        /// </summary>
        public string? Raw;
    };

    /// <summary>
    /// Result of the preprocessor pass: the instruction lines and the label table of one source.
    /// </summary>
    public class SourceMap
    {
        /// <summary>
        /// The instruction lines in source order.
        /// </summary>
        public List<InstructionInfo> Instructions = new List<InstructionInfo>();

        /// <summary>
        /// Every label the source defines, with its address.
        /// </summary>
        public Labels Labels = new Labels();
    };

    /// <summary>
    /// Maps one assembled control store address back to the source line it came from.
    /// </summary>
    public class DebugInfo
    {
        /// <summary>
        /// The control store address.
        /// </summary>
        public UInt16 Address;

        /// <summary>
        /// The source line assembled at that address.
        /// </summary>
        public InstructionInfo? Info;
    };

    /// <summary>
    /// The output of one assembly: the control store image and its address-to-source map.
    /// </summary>
    public class Target
    {
        /// <summary>
        /// The control store image, big-endian, in the word size of the CPU the assembler targets;
        /// null when the assembly failed.
        /// </summary>
        public byte[]? Exe;

        /// <summary>
        /// Address-to-source map for every assembled word; the assemblers do not fill it in yet.
        /// </summary>
        public DebugInfo[]? Pdb;
    };

    /// <summary>
    /// An assembly error that names the source line it was found on.
    /// </summary>
    public class ND110AsmException : SystemException
    {
        /// <summary>
        /// One-based source line the error belongs to.
        /// </summary>
        public int SourceCodeLine { get; set; }

        /// <summary>
        /// Creates an error without a message or a line number.
        /// </summary>
        public ND110AsmException() : base() { }

        /// <summary>
        /// Creates an error for one source line.
        /// </summary>
        /// <param name="message">
        /// What went wrong, in the words the listing shows.
        /// </param>
        /// <param name="sourceLine">
        /// One-based source line the error belongs to.
        /// </param>
        public ND110AsmException(string message, int sourceLine) : base(message)
        {
            SourceCodeLine = sourceLine;
        }
    }
}
