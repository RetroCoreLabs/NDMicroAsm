# ND-100 micro code

| File | What it is |
|---|---|
| `ND-100-3033S.uc` | The micro program of the 3033S CPU card (PROM set 015XX, 2048 words): the printed Norsk Data listing, with the instruction words of the 16 PROM chips. |
| `ND-100-3033E-CX.uc` | The micro program of the 3033E-CX card: the base bank (2008 words, the same program as the 3033S) and the CX option bank (1529 words at 0o4000 and up, PROM set 085XX). |
| `ND-100-3033S-32BIT-FLOAT.uc` | The 3033S program with the words 0o517 - 0o1105 replaced by the printed 32 bit floating point listing (PROM set 026XX). No chip dump exists for these PROMs. |
| `DISASSEMBLY/` | The plain decoding of the chips (names `L<address>` for the decode PLA entry points, no comments), for the 3033S and the 3033E-CX. |
| `*.CODE`, `*.LISTING.TXT`, `*.SYMBOLS.TXT`, `*.DETAILS.TXT`, `TOKENS.TXT` | Written by `ndmicroasm nd100-asm`, see below. |
| `REFERENCE/` | The PROM images the sources must reproduce, see `REFERENCE/README.md`. |

## Where the text comes from

The three `.uc` files at the top are written back from a printout of the ND-100 micro code source
(`ND100-MICROCODE.pdf`, 311 scanned pages: NORD-100 Microprogramming Description, label list, ND-100
Microcode 48 bit PROM 015XX "N-VERSION" of 16.12.1985, 32 BIT ND-100 Floating Point PROM 026XX, CX-Option
PROM 085XX). The printout is the Norsk Data source itself: label names, comments, banners, the way the
operands are written (`A,17`, `B,0`, `T,POP 1560;`) and the one-line form of the vector tables.

How it was made, and how each part was checked:

1. Each page image was read with tesseract (an earlier OCR text of the scan, made by a language model, had invented and left out
   whole lines on the dense pages and was not used for the code).
2. Every printed instruction was matched to a chip word (monotone alignment on the instruction fields; the
   printed address column is off by one on the 2nd line of an instruction and was only a hint). A printed
   instruction counts when its mnemonics rebuild the chip word. OCR slips that are one or two characters
   (`B,RS` for `B,R5`, `F.dJMP`, `T,.NEXT`) were repaired against the chip word.
3. Labels, comments, operand names and the layout were then compared with the page images by eight readers
   (one per 26 pages, an image plus the transcript, corrections as data) and a second time at every page
   break (an image of the bottom of one page and the top of the next), because an instruction that runs over
   a page break could not be judged on one page.
4. The result was assembled with `nd100-asm` and compared with the PROM images: **3033S: identical
   (20480 bytes); 3033E-CX: identical (35370 bytes)**. This proves the instruction words, the jump
   operands and the label values (a wrong label name that jumps to another address would change a word).
   It does not prove the spelling of a label that nothing jumps to, of the comments, or of the register
   operand spelling; those were checked against the page images only. 153 places carry a reader's doubt
   (mostly letter O against digit 0); the choice made is the one the reader judged more likely.

### What the PROMs hold that the print does not say

- **CYCL.** The printout says `CYCL,FAST` on 908 of the base bank words and nothing on 651 more. The 3033S
  chips hold `CYCL,SLOW` in all of those 1559 words (the standard, slow-cycle build; ND-06.018.01 says the
  fast option replaces SLOW by FAST). `CYCL,WAIT` (216) and `CYCL,SLOW` (171) are the same in print and chips.
  The 3033E-CX chips follow the print exactly: FAST for `CYCL,FAST` and for no CYCL, `CYCL,NORM` (113 words)
  and `CYCL,WAIT` as printed. So the bit 21 pattern of the two chip sets (always 1 on the 3033S, 14-20 %
  on the 3033E-CX) is the two builds of the same source. In the 3033S file every word has a `CYCL` token; in
  the 3033E-CX file a word has none where the print has none and the chips hold FAST.
- **0o3514 - 0o3517.** The print jumps to `5INIT`, `ENTR`, `LEAV` and `ELEAV` (the PLANC routines at 0o3370
  and up); the chips of both cards jump to `ILLIN`. The source follows the chips and has a comment there.
- **Words that are not in the print.** Fill words in front of an origin line (0o643-0o660, 0o731-0o737,
  0o1034-0o1036, 0o1056-0o1060, 0o1101-0o1105, 0o3450-0o3457: the printed address stays the old one after
  `661/`, `740/`, `1037/`, `1061/`, `1106/`, `3460/`) and the words of the two blank printout pages
  165 and 191 (0o2125-0o2146 and 0o2772-0o3004). They are written from the chip decoding, without comments.
  A label a printed jump names for such a word (`MOVB9` at 0o2777) is given from the jump.
- **Two assemblies.** The printed base listing and the printed CX listing were assembled apart; the CX
  listing reaches the base names through the old label list (pages 84-87). Nine names are in both: `5INIT
  COBVC COMME ELEAV ENTR ENTRB ENTRC LEAV TSTAC`. One assembly cannot hold a name twice, so in
  `ND-100-3033E-CX.uc` the copy in the extension bank is written `<name>_CX` (for example `ENTR_CX`).

### The 32 bit floating point file

The 026XX listing (pages 221-233, 247 instructions from 0o517 to 0o1105) was typed from the page images by
one reader and has no chip image to be compared with. `ND-100-3033S-32BIT-FLOAT.uc` puts it in place of the
48 bit floating point routines and assembles it. Checks that were possible: every label resolves, the
addresses in the print run without a gap, and the 1801 words outside 0o517-0o1105 stay bit for bit the
words of the 3033S chips. That second check also shows that the entry points `FSB`, `FAD`, `FMU`, `FDV`,
`NLZ`, `DNZ` and `IOX` of the 32 bit routines are at the same addresses as the 48 bit ones (the jumps of
the unchanged words into them still land on them). Nine of the 247 words have the same mnemonics as the
chip word at their address; the others are other code.

### Token names the printout corrected

The printout writes bit 50 as `XRF` (145 times) and the A operand taken from the macro instruction as
`A,SRCE` (35 times). The old mnemonic table had `A,SHCE`, a misreading of the dot matrix print of
ND-06.018.01 Appendix A page A-2 (the R of that print looks like an H), and no `XRF` (only `EN_EXT`, the
name of the manual's field table). `A,SRCE` is now the name, and `XRF` is a second name for the same bit.

## Assembling

```powershell
ndmicroasm nd100-asm microcode\ND-100\ND-100-3033S.uc
ndmicroasm nd100-asm microcode\ND-100\ND-100-3033E-CX.uc
ndmicroasm nd100-asm microcode\ND-100\ND-100-3033S-32BIT-FLOAT.uc
```

Bits 22-27 of every word are written inverted. ND-06.018.01, chapter 4 (printed page 4-1): "It is
important to be aware that bits 22 - 27 are inverted after the word is assembled." Pages 3-7 and
3-8 call each of the six bits active low. The `.CODE` image is therefore in the form the PROMs
hold, and a reader that wants the active high form flips bits 22-27 again (`XOR 0x0FC00000`, the
same mask as the ND-110). Branch addresses are 12 bits; bit 20 is the timing bit TC0 and the
assembler does not touch it for a label.

## Proof against the chips

- `ND-100-3033S.CODE` is byte for byte equal to `REFERENCE/3033S-microcode.CODE` (20480 bytes).
- `ND-100-3033E-CX.CODE` is equal to the two reference files of the CX card put together (35370 bytes).
- The two plain decodings in `DISASSEMBLY/` assemble to the same images.
- Split back into chips with the layout of `tools/nd100-combine.py`, all 48 chips (16 of the 3033S,
  16 + 16 of the 3033E-CX base and extension) have 0 differing nibbles over 32768 nibbles each bank.
- `TestND100Compiler` in `src/tests/NDMicroAsm.Tests` repeats the image checks and the 32 bit file check.

The mnemonic table (`ND1X0/ND100Tokens.cs`) is generated by `eng/gen-nd100-tokens.py` from
`defs/tokens/nd100-tokens.yaml` of `nd-microcode-meta` (300 mnemonics). Every token that the printed
listing or the chips use is proved by the match above (this includes the numeric operands `A,0` - `A,17`
and `B,0` - `B,17`, which the printed source writes). 13 tokens appear in neither source file. They were
read by eye on the page images of Appendix A of ND-06.018.01 (pages A-2 to A-6, printed sideways; each
printed line is the name, then four octal groups that are the four 16 bit parts of the 64 bit table value,
the top part first):
11 are in the print with the same value as the table: `PIC,MCL` 000000, `PIC,MCLMSK` 120000 in the last
group, `PIC,MSTMSK` 130000, `ALUF,XNORAB` 016200, `ALUF,XNORDA` 017200, `ALUF,XNORDQ` 017400, `ALUF,-Q-1`
004400, `ALUF,-D-1` 003600, `ALUF,D-Q-1` 005400, `ALUF,-D` 003600 040000, `F,LOAD` 000002 in the last group.
2 are NOT in the printed list (it has 300 numbered lines, the last four marked REMOVED, and no such name):
`T,REPEAT` (the T list, lines 228-239, ends with `T,PUSH`) and the stand alone `SEXT` (the list only has
`IDBS,GPR,SEXT`, line 203, 001100 in the second group, which matches the table). Neither word is used by
any chip word or by the printed source.
