//
// SPDX-License-Identifier: MIT
// Copyright (c) 1985-2026 Ronny Hansen
// RetroCore Labs — https://github.com/RetroCoreLabs/NDMicroAsm
// NDMicroAsm — Assembling yesterday's micro code with today's tools
//

using System.Collections.Generic;
using System.Diagnostics.Metrics;

namespace NDMicroAsm
{
    internal class ND120Tokens : TokensBase
    {
        internal override void InitializeTokens()
        {
            Clear();
            AddToken("A,Z", "000000", "000000", "000000", "000000", @"A-OP. IS O. USED TO ADDR. ZERO REG., STATUS OR SCRATCH", Constants.IsA);
            AddToken("A,D", "000000", "000000", "000000", "010000", @"A-OP. IS 1. USED TO ADDR. THE D-REGISTER", Constants.IsA);
            AddToken("A,P", "000000", "000000", "000000", "020000", @"A-OP. IS 2. USED TO ADDR. THE P-REGISTER", Constants.IsA);
            AddToken("A,B", "000000", "000000", "000000", "030000", @"A-OP. IS 3. USED TO ADDR. THE B-REGISTER", Constants.IsA);
            AddToken("A,L", "000000", "000000", "000000", "040000", @"A-OP. IS 4. USED TO ADDR. THE L-REGISTER", Constants.IsA);
            AddToken("A,A", "000000", "000000", "000000", "050000", @"A-OP. IS 5. USED TO ADDR. THE A-REGISTER", Constants.IsA);
            AddToken("A,T", "000000", "000000", "000000", "060000", @"A-OP. IS 6. USED TO ADDR. THE T-REGISTER", Constants.IsA);
            AddToken("A,X", "000000", "000000", "000000", "070000", @"A-OP. IS 7. USED TO ADDR. THE X-REGISTER", Constants.IsA);
            AddToken("A,STS", "000000", "000000", "000000", "100000", @"A-OP. IS 10. USED TO ADDR. REGISTER 10, STATUS OR SCRATCH", Constants.IsA);
            AddToken("A,R1", "000000", "000000", "000000", "110000", @"A-OP. IS 11. USED TO ADDR. REGISTER 11, ADDRESS OR SCRATCH", Constants.IsA);
            AddToken("A,R2", "000000", "000000", "000000", "120000", @"A-OP. IS 12. USED TO ADDR. REGISTER 12, SCRATCH", Constants.IsA);
            AddToken("A,R3", "000000", "000000", "000000", "130000", @"A-OP. IS 13. USED TO ADDR. REGISTER 13, SCRATCH", Constants.IsA);
            AddToken("A,R4", "000000", "000000", "000000", "140000", @"A-OP. IS 14. USED TO ADDR. REGISTER 14, SCRATCH", Constants.IsA);
            AddToken("A,R5", "000000", "000000", "000000", "150000", @"A-OP. IS 15. USED TO ADDR. REGISTER 15, SCRATCH", Constants.IsA);
            AddToken("A,R6", "000000", "000000", "000000", "160000", @"A-OP. IS 16. USED TO ADDA. REGISTER 16, SCRATCH", Constants.IsA);
            AddToken("A,R7", "000000", "000000", "000000", "170000", @"A-OP. IS 17. USED TO ADDR. REGISTER 17, SCRATCH", Constants.IsA);
            AddToken("A,PIL", "000010", "000000", "000000", "000000", @"A-OP. IS VALUE IN 'PIL' REGISTER, LOADED BY 'COMM, LDPIL'", Constants.IsA);
            AddToken("A,REG", "000020", "000000", "000000", "000000", @"A-OP. IS VALUE OF 'INSTR. BITS 3-6' LOADED BY LAST 'T,MAPJ'", Constants.IsA);
            AddToken("A,SRCE", "000024", "000000", "000000", "000000", @"A-OP. IS VALUE OF 'INSTR. BITS 3-5' LOADED BY LAST 'T,MAPJ'", Constants.IsA);
            AddToken("A,LC", "000030", "000000", "000000", "000000", @"A-OP. IS VALUE OF 'LOOP COUNTER' TWO MICROINSTRUCTIONS AGO", Constants.IsA);
            AddToken("PIC,RSTS", "000000", "000000", "000000", "060000", @"A-OP. IS 6. USED TO GIVE 'READ STATUS' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,MCL", "000000", "000000", "000000", "000000", @"A-OP. IS 0. USED TO GIVE 'MASTER CLEAR' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,MCLPID", "000000", "000000", "000000", "020000", @"A-OP. IS 2. USED TO GIVE 'MASKED CLEAR PID' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,RMSK", "000000", "000000", "000000", "070000", @"A-OP. IS 7. USED TO GIVE 'READ MASK' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,LOSTS", "000000", "000000", "000000", "110000", @"A-OP. IS 11. USED TO GIVE 'LOAD STATUS' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,LMSK", "000000", "000000", "000000", "160000", @"A-OP. IS 16. USED TO GIVE 'LOAD MASK' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,MCLMSK", "000000", "000000", "000000", "120000", @"A-OP. IS 12. USED TO GIVE 'MASKED CLEAR MASK' CMD TO INTSYS", Constants.IsPIC);
            AddToken("PIC,IOF", "000000", "000000", "000000", "150000", @"A-OP. IS 15. USED TO GIVE 'IOF' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,ION", "000000", "000000", "000000", "170000", @"A-OP. IS 17. USED TO GIVE 'ION' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,MSTMSK", "000000", "000000", "000000", "130000", @"A-OP. IS 13. USED TO GIVE 'MASKED SET MASK' CMD. TO INTSYS", Constants.IsPIC);
            AddToken("PIC,RVECT", "000000", "000000", "000000", "050000", @"A-OP. IS 5. USED TO GIVE 'READ-VECTOR' COMMAND TO INTSYS", Constants.IsPIC);
            AddToken("A,0", "000000", "000000", "000000", "000000", @"A-OP. IS 0", Constants.IsA);
            AddToken("A,1", "000000", "000000", "000000", "010000", @"A-OP. IS 1", Constants.IsA);
            AddToken("A,2", "000000", "000000", "000000", "020000", @"A-OP. IS 2", Constants.IsA);
            AddToken("A,3", "000000", "000000", "000000", "030000", @"A-OP. IS 3", Constants.IsA);
            AddToken("A,4", "000000", "000000", "000000", "040000", @"A-OP. IS 4", Constants.IsA);
            AddToken("A,5", "000000", "000000", "000000", "050000", @"A-OP. IS 5", Constants.IsA);
            AddToken("A,6", "000000", "000000", "000000", "060000", @"A-OP. IS 6", Constants.IsA);
            AddToken("A,7", "000000", "000000", "000000", "070000", @"A-OP. IS 7", Constants.IsA);
            AddToken("A,10", "000000", "000000", "000000", "100000", @"A-OP. IS 10", Constants.IsA);
            AddToken("A,11", "000000", "000000", "000000", "110000", @"A-OP. IS 11", Constants.IsA);
            AddToken("A,12", "000000", "000000", "000000", "120000", @"A-OP. IS 12", Constants.IsA);
            AddToken("A,13", "000000", "000000", "000000", "130000", @"A-OP. IS 13", Constants.IsA);
            AddToken("A,14", "000000", "000000", "000000", "140000", @"A-OP. IS 14", Constants.IsA);
            AddToken("A,15", "000000", "000000", "000000", "150000", @"A-OP. IS 15", Constants.IsA);
            AddToken("A,16", "000000", "000000", "000000", "160000", @"A-OP. IS 16", Constants.IsA);
            AddToken("A,17", "000000", "000000", "000000", "170000", @"A-OP. IS 17", Constants.IsA);
            AddToken("B,Z", "000000", "000000", "000000", "000000", @"B-OP. IS O. USED TO ADDR. ZERO REG. , STATUS OR SCRATCH", Constants.IsB);
            AddToken("B,D", "000000", "000000", "000001", "000000", @"B-OP. IS 1. USED TO ADDR. THE D-REGISTER", Constants.IsB);
            AddToken("B,P", "000000", "000000", "004002", "000000", @"B-OP. IS 2. USED TO ADDR. THE P-REGISTER", Constants.IsB);
            AddToken("B,B", "000000", "000000", "004003", "000000", @"B-OP. IS 3. USED TO ADDR. THE B-REGISTER", Constants.IsB);
            AddToken("B,L", "000000", "000000", "000004", "000000", @"B-OP. IS 4. USED TO ADDR. THE L-REGISTER", Constants.IsB);
            AddToken("B,A", "000000", "000000", "000005", "000000", @"B-OP. IS 5. USED TO ADDR. THE A-REGISTER", Constants.IsB);
            AddToken("B,T", "000000", "000000", "000006", "000000", @"B-OP. IS 6. USED TO ADDR. THE T-REGISTER", Constants.IsB);
            AddToken("B,X", "000000", "000000", "004007", "000000", @"B-OP. IS 7. USED TO ADDR. THE X-REGISTER", Constants.IsB);
            AddToken("B,STS", "000000", "000000", "000010", "000000", @"B-OP. IS 10. USED TO ADDR. REG. 10, STATUS OR SCRATCH", Constants.IsB);
            AddToken("B,R1", "000000", "000000", "000011", "000000", @"B-OP. IS 11. USED TO ADDR. REG. 11, ADDR. OR SCRATCH", Constants.IsB);
            AddToken("B,R2", "000000", "000000", "000012", "000000", @"B-OP. IS 12. USED TO ADDR. REG. 12, SCRATCH", Constants.IsB);
            AddToken("B,R3", "000000", "000000", "000013", "000000", @"B-OP, IS 13. USED TO ADDR. REG. 13. SCRATCH", Constants.IsB);
            AddToken("B,R4", "000000", "000000", "000014", "000000", @"B-OP. IS 14. USED TO ADDR. REG. 14. SCRATCH", Constants.IsB);
            AddToken("B,R5", "000000", "000000", "000015", "000000", @"B-OP. IS 15. USED TO ADDR. REG. 15, SCRATCH", Constants.IsB);
            AddToken("B,R6", "000000", "000000", "000016", "000000", @"B-OP. IS 16. USED TO ADDR. REG. 16, SCRATCH", Constants.IsB);
            AddToken("B,R7", "000000", "000000", "000017", "000000", @"B-OP. IS 17. USED TO ADDR. REG. 17, SCRATCH", Constants.IsB);
            AddToken("B,DEST", "000001", "000000", "000000", "000000", @"B-OP. IS VALUE OF 'INSTR. BITS 0-2' LOADED BY LAST 'T,MAPJ'", Constants.IsB);
            AddToken("B,SRCE", "000002", "000000", "000000", "000000", @"B-OP. IS VALUE OF 'INSTR. BITS 3-5' LOADED BY LAST 'T,MAPJ'", Constants.IsB);
            AddToken("B,LC", "000003", "000000", "000000", "000000", @"B-OP. IS VALUE OF THE 'LOOP COUNTER' TWO INSTRUCTIONS AGO", Constants.IsB);
            AddToken("B,0", "000000", "000000", "000000", "000000", @"B-OP. IS 0", Constants.IsB);
            AddToken("B,1", "000000", "000000", "000001", "000000", @"B-OP. IS 1", Constants.IsB);
            AddToken("B,2", "000000", "000000", "000002", "000000", @"B-OP. IS 2", Constants.IsB);
            AddToken("B,3", "000000", "000000", "000003", "000000", @"B-OP. IS 3", Constants.IsB);
            AddToken("B,4", "000000", "000000", "000004", "000000", @"B-OP. IS 4", Constants.IsB);
            AddToken("B,5", "000000", "000000", "000005", "000000", @"B-OP. IS 5", Constants.IsB);
            AddToken("B,6", "000000", "000000", "000006", "000000", @"B-OP. IS 6", Constants.IsB);
            AddToken("B,7", "000000", "000000", "000007", "000000", @"B-OP. IS 7", Constants.IsB);
            AddToken("B,10", "000000", "000000", "000010", "000000", @"B-OP. IS 10", Constants.IsB);
            AddToken("B,11", "000000", "000000", "000011", "000000", @"B-OP. IS 11", Constants.IsB);
            AddToken("B,12", "000000", "000000", "000012", "000000", @"B-OP. IS 12", Constants.IsB);
            AddToken("B,13", "000000", "000000", "000013", "000000", @"B-OP. IS 13", Constants.IsB);
            AddToken("B,14", "000000", "000000", "000014", "000000", @"B-OP. IS 14", Constants.IsB);
            AddToken("B,15", "000000", "000000", "000015", "000000", @"B-OP. IS 15", Constants.IsB);
            AddToken("B,16", "000000", "000000", "000016", "000000", @"B-OP. IS 16", Constants.IsB);
            AddToken("B,17", "000000", "000000", "000017", "000000", @"B-OP. IS 17", Constants.IsB);
            AddToken("ALUF,ANDAQ", "010000", "000000", "000000", "000000", @"A /\ Q -> F", Constants.RequireA);
            AddToken("ALUF,ANDAB", "010200", "000000", "000000", "000000", @"A /\ B -> F", Constants.RequireA_B);
            AddToken("ALUF,ANDDA", "011200", "000000", "000000", "000000", @"D /\ A -> F", Constants.RequireA);
            AddToken("ALUF,ANDDQ", "011400", "000000", "000000", "000000", @"D /\ Q -> F");
            AddToken("ALUF,ORAQ", "006000", "000000", "000000", "000000", @"A \/ Q -> F", Constants.RequireA);
            AddToken("ALUF,ORAB", "006200", "000000", "000000", "000000", @"A \/ B -> F", Constants.RequireA_B);
            AddToken("ALUF,ORDA", "007200", "000000", "000000", "000000", @"D \/ A -> F", Constants.RequireA);
            AddToken("ALUF,ORDQ", "007400", "000000", "000000", "000000", @"D \/ Q -> F");
            AddToken("ALUF,XORAQ", "014000", "000000", "000000", "000000", @"A XOR Q -> F", Constants.RequireA);
            AddToken("ALUF,XORAB", "014200", "000000", "000000", "000000", @"A XOR B -> F", Constants.RequireA_B);
            AddToken("ALUF,XORDA", "015200", "000000", "000000", "000000", @"D XOR A -> F", Constants.RequireA);
            AddToken("ALUF,XORDQ", "015400", "000000", "000000", "000000", @"D XOR Q -> F");
            AddToken("ALUF,XNORAQ", "016000", "000000", "000000", "000000", @"NOT(A XOR Q) -> F", Constants.RequireA_B);
            AddToken("ALUF,XNORAB", "016200", "000000", "000000", "000000", @"NOT(A XOR B) -> F", Constants.RequireA_B);
            AddToken("ALUF,XNORDA", "017200", "000000", "000000", "000000", @"NOT(D XOR A) -> F", Constants.RequireA_B);
            AddToken("ALUF,XNORDQ", "017400", "000000", "000000", "000000", @"NOT(D XOR Q) -> F", Constants.RequireA_B);
            AddToken("ALUF,ZERO", "010400", "000000", "000000", "000000", @"0 -> F");
            AddToken("ALUF,INVQ", "016400", "000000", "000000", "000000", @"NOT(Q) -> F");
            AddToken("ALUF,INVB", "016600", "000000", "000000", "000000", @"NOT(B) -> F", Constants.RequireB);
            AddToken("ALUF,INVA", "017000", "000000", "000000", "000000", @"NOT(A) -> F", Constants.RequireA);
            AddToken("ALUF,INVD", "017600", "000000", "000000", "000000", @"NOT(D) -> F");
            AddToken("ALUF,PASSQ", "014400", "000000", "000000", "000000", @"Q -> F");//, Constants.RequireB); // Nope, no rules founnd that wored
            AddToken("ALUF,PASSB", "014600", "000000", "000000", "000000", @"B -> F", Constants.RequireB);
            AddToken("ALUF,PASSA", "015000", "000000", "000000", "000000", @"A -> F", Constants.RequireA);
            AddToken("ALUF,PASSD", "015600", "000000", "000000", "000000", @"D -> F"); //, Constants.RequireB);
            AddToken("ALUF,MASKAQ", "012000", "000000", "000000", "000000", @"NOT(A) /\ Q -> F");
            AddToken("ALUF,MASKAB", "012200", "000000", "000000", "000000", @"NOT(A) /\ B -> F", Constants.RequireA_B);
            AddToken("ALUF,MASKDA", "013200", "000000", "000000", "000000", @"NOT(D) /\ A -> F", Constants.RequireA);
            AddToken("ALUF,MASKDQ", "013400", "000000", "000000", "000000", @"NOT(D) /\ Q -> F");
            AddToken("ALUF,A+Q", "000000", "000000", "000000", "000000", @"A + Q -> F", Constants.RequireA);
            AddToken("ALUF,A+B", "000200", "000000", "000000", "000000", @"A + B -> F", Constants.RequireA_B);
            AddToken("ALUF,D+A", "001200", "000000", "000000", "000000", @"D + A -> F"); // not really: Constants.RequireA);
            AddToken("ALUF,D+Q", "001400", "000000", "000000", "000000", @"D + Q -> F");
            AddToken("ALUF,A+Q+1", "000000", "040000", "000000", "000000", @"A + Q * 1 -> F", Constants.RequireA);
            AddToken("ALUF,A+B+1", "000200", "040000", "000000", "000000", @"A + B + 1 - >", Constants.RequireA_B);
            AddToken("ALUF,D+A+1", "001200", "040000", "000000", "000000", @"D + A + 1 -> F", Constants.RequireA);
            AddToken("ALUF,D+Q+1", "001400", "040000", "000000", "000000", @"D + Q + 1 - > F");
            AddToken("ALUF,-Q-1", "004400", "000000", "000000", "000000", @"-Q - 1 -> F");
            AddToken("ALUF,-B-1", "004600", "000000", "000000", "000000", @"-B - 1 -> F", Constants.RequireB);
            AddToken("ALUF,-A-1", "005000", "000000", "000000", "000000", @"-A - 1 -> F", Constants.RequireA);
            AddToken("ALUF,-D-1", "003600", "000000", "000000", "000000", @"-D - 1 -> F");
            AddToken("ALUF,Q-A-1", "002000", "000000", "000000", "000000", @"Q - A - 1 -> F", Constants.RequireA);
            AddToken("ALUF,B-A-1", "002200", "000000", "000000", "000000", @"B - A - 1 -> F", Constants.RequireA_B);
            AddToken("ALUF,A-D-1", "003200", "000000", "000000", "000000", @"A - D - 1 -> F", Constants.RequireA);
            AddToken("ALUF,Q-D-1", "003400", "000000", "000000", "000000", @"Q - D- 1 -> F");
            AddToken("ALUF,A-Q-1", "004000", "000000", "000000", "000000", @"A - Q - 1 -> F", Constants.RequireA);
            AddToken("ALUF,A-B-1", "004200", "000000", "000000", "000000", @"A - B - 1 -> F", Constants.RequireA_B);
            AddToken("ALUF,D-A-1", "005200", "000000", "000000", "000000", @"D - A - 1 -> F", Constants.RequireA);
            AddToken("ALUF,D-Q-1", "005400", "000000", "000000", "000000", @"D - Q - 1 -> F");
            AddToken("ALUF,Q", "000400", "000000", "000000", "000000", @"Q -> F");
            AddToken("ALUF,B", "000600", "000000", "000000", "000000", @"B -> F", Constants.RequireB);
            AddToken("ALUF,A", "001000", "000000", "000000", "000000", @"A -> F", Constants.RequireA);
            AddToken("ALUF,D", "001600", "000000", "000000", "000000", @"D -> F");
            AddToken("ALUF,Q+1", "000400", "040000", "000000", "000000", @"Q + 1 -> F");
            AddToken("ALUF,B+1", "000600", "040000", "000000", "000000", @"B + 1 -> F", Constants.RequireB);
            AddToken("ALUF,A+1", "001000", "040000", "000000", "000000", @"A + 1 -> F", Constants.RequireA);
            AddToken("ALUF,D+1", "001600", "040000", "000000", "000000", @"D + 1 -> F");
            AddToken("ALUF,Q-1", "002400", "000000", "000000", "000000", @"0 - 1 -> F");
            AddToken("ALUF,B-1", "002600", "000000", "000000", "000000", @"B - 1 -> F", Constants.RequireB);
            AddToken("ALUF,A-1", "003000", "000000", "000000", "000000", @"A - 1 -> F", Constants.RequireA);
            AddToken("ALUF,D-1", "005600", "000000", "000000", "000000", @"D - 1 -> F");
            AddToken("ALUF,-Q", "004400", "040000", "000000", "000000", @"-Q -> F");
            AddToken("ALUF,-B", "004600", "040000", "000000", "000000", @"-B -> F", Constants.RequireB);
            AddToken("ALUF,-A", "005000", "040000", "000000", "000000", @"-A -> F", Constants.RequireA);
            AddToken("ALUF,-D", "003600", "040000", "000000", "000000", @"-D -> F");
            AddToken("ALUF,Q-A", "002000", "040000", "000000", "000000", @"Q - A -> F", Constants.RequireA);
            AddToken("ALUF,B-A", "002200", "040000", "000000", "000000", @"B - A -> F", Constants.RequireA_B);
            AddToken("ALUF,A-D", "003200", "040000", "000000", "000000", @"A - D -> F", Constants.RequireA);
            AddToken("ALUF,Q-D", "003400", "040000", "000000", "000000", @"Q - D -> F");
            AddToken("ALUF,A-Q", "004000", "040000", "000000", "000000", @"A - Q -> F", Constants.RequireA);
            AddToken("ALUF,A-B", "004200", "040000", "000000", "000000", @"A - B -> F", Constants.RequireA_B);
            AddToken("ALUF,D-A", "005200", "040000", "000000", "000000", @"D - A -> F", Constants.RequireA);
            AddToken("ALUF,D-Q", "005400", "040000", "000000", "000000", @"D - Q -> F");
            AddToken("ALUD,Q", "000000", "000000", "000000", "000000", @"F -> Q : F -> Y");
            AddToken("ALUD,NONE", "020000", "000000", "000000", "000000", @"F -> Y");
            AddToken("ALUD,B,YA", "040000", "000000", "000000", "000000", @"F -> B : A -> Y", Constants.RequireB);
            AddToken("ALUD,B", "060000", "000000", "000000", "000000", @"F -> B : F -> Y", Constants.RequireB);
            AddToken("ALUD,SRD", "100000", "000000", "000000", "000000", @"F -> Y : (F,Q)/2 -> (B,Q)");
            AddToken("ALUD,SRB", "120000", "000000", "000000", "000000", @"F -> Y : F/2 -> B", Constants.RequireB);
            AddToken("ALUD,SLD", "140000", "000000", "000000", "000000", @"F -> Y : (F,Q)*2 -> (B,Q)", Constants.RequireB);
            AddToken("ALUD,SLB", "160000", "000000", "000000", "000000", @"F -> Y : F*2 -> B", Constants.RequireB);
            AddToken("STS,LO", "000140", "000000", "000000", "000000", @"IDB-BITS 0-7 -> STATUS-BITS 0-7");
            AddToken("STS,EA", "000040", "000000", "000000", "000000", @"CRY -> STS C : OVF -> STS Q : OVF \/ STS O -> STS O");
            AddToken("STS,ES", "000100", "000000", "000000", "000000", @"ALU SHIFT OUTPUT -> STATUS M");
            AddToken("CRY,C", "000000", "100000", "000000", "000000", @"STATUS C -> CARRY IN");
            AddToken("CRY,GPR", "000000", "140000", "000000", "000000", @"GPR BIT 0 -> CARRY IN");
            AddToken("ALUM,FMU", "000000", "010000", "000000", "000000", @"MULTIPLY ALU MODE. GPR 0 -> ALU-INSTR 1 ; RIGHT GPR-SHIFT");
            AddToken("ALUM,FDV", "000000", "020000", "000000", "000000", @"DIVISION ALU MODE. GPR 0 -> ALU-INSTR 3 : LEFT GPR-SHIFT");
            AddToken("ALUM,IR", "000000", "030000", "000000", "000000", @"SHIFT INSTR. MODE. SH MODE FROM IR-BITS. M IS SET AUTOM.");
            AddToken("ALUM,MIC", "000000", "000000", "000000", "000000", @"MICROPROGRAM CONTR. SHIFT. SHIFT MODE FROM 'MIS-BITS'");
            AddToken("MIS,ROT", "000000", "002000", "000000", "000000", @"SPECIFIES ROTATIONAL SHIFT IF 'ALUM, MIC'");
            AddToken("MIS,ZIN", "000000", "004000", "000000", "000000", @"SPECIFIES ZERO-END-INPUT SHIFT IF 'ALUM, MIC'");
            AddToken("MIS,LIN", "000000", "006000", "000000", "000000", @"SPECIFIES LINK-END-INPUT SHIFT IF 'ALUM. MIC'");
            AddToken("LCOUNT", "000000", "000000", "002100", "000000", @"COUNT LOOP-COUNTER : IF FALSE 'RETURN'&'HOLD'. ND-120: DLY0 (bit 26) always set by assembler");
            AddToken("CONDENABL", "000000", "000000", "002200", "000000", @"ENABLE COND. SEQ. , USE 'FALSE' SPECS IF CONDITION FALSE. ND-120: DLY0 (bit 26) always set by assembler");
            AddToken("IDBS,ALU", "000000", "000000", "000000", "000000", @"ARITHMETIC-LOGIC-UNIT -> IDB", Constants.IsIDBS);
            AddToken("IDBS,BMG", "000000", "000040", "000000", "000000", @"BIT-MASK-GENERATOR -> IDB", (ushort)(Constants.IsIDBS | Constants.RequireA));
            AddToken("IDBS,GPR", "000000", "000100", "000000", "000000", @"GENERAL-PURPOSE-REGISTER -> IDB", Constants.IsIDBS);
            AddToken("IDBS,DBR", "000000", "000140", "000000", "000000", @"DATA-BUS-REGISTER -> IDB", Constants.IsIDBS);
            AddToken("IDBS,ARG", "000000", "000200", "000000", "000000", @"ARGUMENT (MICRO-INSTRUCTION-BITS 0-15) => IDB", Constants.IsIDBS);
            AddToken("IDBS,REG", "000000", "000240", "000040", "000000", @"REGISTER-FILE -> IDB", (ushort)(Constants.IsIDBS | Constants.RequireA_B));
            AddToken("IDBS,STS", "000000", "000300", "000000", "000000", @"STATUS => IDB", Constants.IsIDBS);
            AddToken("IDBS,BARG", "000000", "000400", "000000", "000000", @"B-OPERAND-ARGUMENT (0-17) -> IDB", (ushort)(Constants.IsIDBS | Constants.RequireB));
            AddToken("IDBS,SWAP", "000000", "000440", "000000", "000000", @"BYTE-SWAP OF LAST IDB -> IDB", Constants.IsIDBS);
            AddToken("IDBS,PEA", "000000", "000500", "000040", "000000", @"PEA-REGISTER -> IDB", Constants.IsIDBS);
            AddToken("IDBS,PES", "000000", "000540", "000040", "000000", @"PES-REGISTER -> IDB", Constants.IsIDBS);
            AddToken("IDBS,AARG", "000000", "000600", "000000", "000000", @"A-OPERAND-ARGUMENT'10 (0-170) -> IDB", (ushort)(Constants.IsIDBS | Constants.RequireA));
            AddToken("IDBS,PIC", "000000", "000640", "000000", "000000", @"PRIORITY-INTERRUPT-CONTROL STATUS REGISTER -> IDB", Constants.IsIDBS);
            AddToken("IDBS,IOR", "000000", "000700", "000040", "000000", @"UART DATA AND STATUS -> IDB", Constants.IsIDBS);
            AddToken("IDBS,DSABL", "000000", "000740", "000040", "000000", @"DConstants.IsABLE IDBS (USED TO READ 'PIC'-INFO, EXCEPT PIC-STS)", Constants.IsIDBS);
            AddToken("IDBS,MIPANS", "000000", "001000", "000040", "000000", @"IR 0 USED BY MOPC", Constants.IsIDBS);
            AddToken("IDBS,MAPANS", "000000", "001040", "000040", "000000", @"IR 0 USED BY TRA-INSTRUCTION", Constants.IsIDBS);
            AddToken("IDBS,GPR,SEXT", "000000", "001100", "000000", "000000", @"GPR BITS 0-7 (WITH BITS 8-15 EQUAL TO BIT 7) -> IDB", Constants.IsIDBS);
            AddToken("IDBS,PGS", "000000", "001140", "000040", "000000", @"PAGING STATUS ACCORDING TO LAST REQUEST (NEVER LOCKED)", Constants.IsIDBS);
            AddToken("IDBS,CSR", "000000", "001200", "000040", "000000", @"CACHE STATUS REGISTER", Constants.IsIDBS);
            AddToken("IDBS,PCR", "000000", "001240", "000040", "000000", @"READ PAGING CONTROL REGISTER (NUMBER SELECTED BY PIL)", Constants.IsIDBS);
            AddToken("IDBS,ALD", "000000", "001300", "000040", "000000", @"AUTOMATIC LOAD DESCRIPTOR & PRINT STATUS", Constants.IsIDBS);
            AddToken("IDBS,PANEL", "000000", "001340", "000040", "000000", @"PANEL VECTOR", Constants.IsIDBS);
            AddToken("IDBS,RCS", "000000", "001400", "000040", "000000", @"READ CONTROL STORE", Constants.IsIDBS);
            AddToken("IDBS,PICVC", "000000", "001440", "000040", "000000", @"INTERRUPT VECTOR. CGA.", Constants.IsIDBS);
            //AddToken("IDBS,LBR", "000000", "001500", "006000", "000000", @"READ LBR FROM LA BUS (MUST HAVE COMM,PLBR)", Constants.IsIDBS); // ND-110 only            

            AddToken("IDBS,LA", "000000", "001600", "000000", "000000", @"LOGICAL ADDRESS USED BY 'ALU' WHEN JUMP", Constants.IsIDBS);
            AddToken("IDBS,INR", "000000", "001640", "000040", "000000", @"READ INSTALLATION NUMBER FROM BACKWIRING", Constants.IsIDBS);
            AddToken("IDBS,PICM", "000000", "001700", "000040", "000000", @"INTERRUPT MASK REGISTER. CGA.", Constants.IsIDBS);
            AddToken("IDBS,UART", "000000", "001740", "000000", "000000", @"READ FROM THE REG. ADDRESSED BY COMM,UART", Constants.IsIDBS);
            AddToken("COMM,LDPIL", "000000", "000001", "000040", "000000", @"IDB BITS 8-15 -> STATUS BITS 8-15");
            AddToken("COMM,LDGPR", "000000", "000002", "000040", "000000", @"IDB -> GENERAL-PURPOSE-REGISTER");
            AddToken("COMM,EWRF", "000000", "000003", "000040", "000000", @"IDB -> REGISTER FILE WORD ADDRESSED BY A-OP AND B-OP", Constants.RequireA_B);
            AddToken("COMM,UART,DATA", "000000", "000005", "000000", "000000", @"CONSOLE DATA-REGISTERS");
            AddToken("COMM,UART,STATUS", "000000", "002005", "000000", "000000", @"CONSOLE STATUS-REGISTER");
            AddToken("COMM,UART,MODE", "000000", "004005", "000000", "000000", @"CONSOLE MODE-REGISTERS 1/2");
            AddToken("COMM,UART,COM", "000000", "006005", "000000", "000000", @"CONSOLE COMMAND-REGISTER");
            AddToken("COMM,CLIRQ", "000000", "000004", "000000", "000000", @"PREVENT JUMP TO INTR VECT. REMOVE 'PANEL'-EFF ON IRQ-TEST");
            AddToken("COMM,RSDA", "000000", "000005", "000000", "000000", @"RESET DATA AVAILABLE IN 'UART'");
            //AddToken("COMM,TBSTR", "000000", "000006", "000000", "000000", @"'TRANSMIT BUFFER STROBE' TO 'UART' IDB 0-7 -> 'UART'"); //ND-110 ONLY

            AddToken("COMM,LDPANC", "000000", "004006", "000000", "000000", @"SEND ONE BYTE TO IR 0");
            AddToken("COMM,LDPCR", "000000", "006006", "000040", "000000", @"LOAD PCR (NUMBER DETERMINED BY PIL)");
            AddToken("COMM,SIOC", "000000", "000007", "000040", "000000", @"LOAD 'I/O-CONTROL' REGISTER");
            AddToken("COMM,SLOW", "000000", "000010", "000000", "000000", @"SLOW CYCLE (200 NS)");
            AddToken("COMM,EPIC", "000000", "000011", "000000", "000000", @"A-OPERAND IS AN INSTRUCTION TO 'PIC' (PRIORITY INT CONTR)", Constants.RequirePIC);
            AddToken("COMM,SMPID", "000000", "000012", "000000", "000000", @"SET MICRO-PID. PID-BITS WHERE IDB IS '1' ARE FORCED TO '1'");
            AddToken("COMM,START", "000000", "000013", "000000", "000000", @"RESET THE 'STOP' FLIP-FLOP");
            AddToken("COMM,SSTOP", "000000", "000014", "000000", "000000", @"SET THE 'STOP' FLIP-FLOP");
            AddToken("COMM,CLRTC", "000000", "000015", "000000", "000000", @"CLEAR THE 20 MS CLOCK FLIP-FLOP");
            AddToken("COMM,CLFF", "000000", "000016", "000000", "000000", @"CLEAR THE 'OOD' AND THE 'DZD' FLIP-FLOPS");
            AddToken("COMM,LDLC", "000000", "000017", "000040", "000000", @"LOAD THE 'LOOP COUNTER' WITH THE 6 LOWER IDB-BITS");
            AddToken("COMM,LDSEG", "000000", "000020", "000040", "000000", @"LOAD SEGMENT REGISTER (SELECTS PHYSICAL 64K AREA)");
            //AddToken("COMM,LDDOMI",    "000000", "002020", "004040", "000000", @"LOAD SINTRAN-4 DOMAIN REGISTER");
            //AddToken("COMM,LDPS",      "000000", "004020", "004040", "000000", @"LOAD SINTRAN-4 PS REGISTER");
            AddToken("COMM,LDIRV", "000000", "006020", "000040", "000000", @"LOAD INSTRUCTION REGISTER FOR OR-LOGIC USE");
            AddToken("COMM,WCIHM", "000000", "000021", "000040", "000000", @"WRITE CACHE INHIBIT MAP (BIT 15 =1 IS NORMAL, = 0 IS INH)");
            AddToken("COMM,SSEMA", "000000", "002021", "000000", "000000", @"THE NEXT REQUEST IS A SEMAPHOR REQUEST. ND-120: no DLY bits (EPROM verified)");
            AddToken("COMM,CCLR", "000000", "004021", "000000", "000000", @"CLEAR CACHE (BIT 3 OF CSR MUST BE 0 BEFORE START)");
            AddToken("COMM,LDEXM", "000000", "006021", "000040", "000000", @"LOAD EXAMINE MODE");
            AddToken("COMM,IREAD,PT", "000000", "000022", "002040", "000000", @"INDIRECT ADDRESS READ (PT-RELATIVE)");
            AddToken("COMM,IREAD,APT", "000000", "002022", "006040", "000000", @"INDIRECT ADDRESS READ (APT-RELATIVE)");
            AddToken("COMM,MAP", "000000", "004022", "000040", "000000", @"USE IDB AS INSTRUCTION (AS IN EXR)");
            AddToken("COMM,CNEXT,NWP", "000000", "006022", "000040", "000000", @"EXECUTE NEXT INSTRUCTION IF P NOT CHANGED IN LAST CYCLE");
            AddToken("COMM,CJMP,F15", "000000", "000023", "002040", "000000", @"JUMP IF F15 =1");

            // 244, page 4            
            AddToken("COMM,CJMP,NF15", "000000", "002023", "002040", "000000", @"JUMP IF F15 -0");
            AddToken("COMM,CJMP,F=0", "000000", "004023", "002040", "000000", @"JUMP IF F =0");
            AddToken("COMM,CJMP,NF=0", "000000", "006023", "002040", "000000", @"JUMP IF F <> 0");
            AddToken("COMM,CNEXT,SGR", "000000", "000024", "000040", "000000", @"SKIP LST");
            AddToken("COMM,CNEXT,NSGR", "000000", "002024", "000040", "000000", @"SKIP GRE");
            AddToken("COMM,CNEXT,CRY", "000000", "004024", "000040", "000000", @"SKIP MLS");
            AddToken("COMM,CNEXT,NCRY", "000000", "006024", "000040", "000000", @"SKIP MGR");
            AddToken("COMM,CNEXT,F15", "000000", "000025", "000040", "000000", @"SKIP GEQ");
            AddToken("COMM,CNEXT,NF15", "000000", "002025", "000040", "000000", @"SKIP LSS");
            AddToken("COMM,CNEXT,F=0", "000000", "004025", "000040", "000000", @"SKIP VEQ");
            AddToken("COMM,CNEXT,NF=0", "000000", "006025", "000040", "000000", @"SKIP EQL");
            AddToken("COMM,JMP,*", "000000", "000026", "002040", "000000", @"JMP P-RELATIVE");
            AddToken("COMM,JMP,B", "000000", "002026", "006040", "000000", @"JMP ,B");
            AddToken("COMM,JMP,I", "000000", "004026", "002040", "000000", @"JMP I & I,B");
            AddToken("COMM,JMP,X", "000000", "006026", "006040", "000000", @"JMP ,X");
            AddToken("COMM,JMP,XB", "000000", "000027", "006040", "000000", @"JMP ,X,B");
            AddToken("COMM,JMP,XI", "000000", "002027", "006040", "000000", @"JMP I,X & I,B,X");
            //AddToken("COMM,LBCONT",    "000000", "004027", "000040", "000000", @"USED IN PREX-INSTRUCTION ONLY"); // ND-110 Only
            AddToken("COMM,CONTINUE", "000000", "006027", "000040", "000000", @"FETCH NEW INSTRUCTION RELATIVE TO P");
            AddToken("COMM,AREAD,*", "000000", "000030", "002040", "000000", @"READ P-RELATIVE");
            AddToken("COMM,AREAD,B", "000000", "002030", "006040", "000000", @"READ ,B");
            AddToken("COMM,AREAD,I", "000000", "004030", "002040", "000000", @"READ I & I,B");
            AddToken("COMM,AREAD,X", "000000", "006030", "006040", "000000", @"READ ,X");
            AddToken("COMM,AREAD,XB", "000000", "000031", "006040", "000000", @"READ , B,X");
            AddToken("COMM,AREAD,XI", "000000", "002031", "006040", "000000", @"READ I,X & I,B,X");
            //AddToken("COMM,IREAD2",    "000000", "004031", "000040", "000000", @"READ FIRST PART OF 32-BIT INDIRECT ADDRESS"); // ND-110 Only
            AddToken("COMM,AREAD,NEXT", "000000", "006031", "000040", "000000", @"READ NEXT ADDRESS");
            AddToken("COMM,AWRITE,*", "000000", "000032", "002000", "000000", @"WRITE P-RELATIVE");
            AddToken("COMM,AWRITE,B", "000000", "002032", "006000", "000000", @"WRITE ,B");
            AddToken("COMM,AWRITE,I", "000000", "004032", "002000", "000000", @"WRITE I & I,B");
            AddToken("COMM,AWRITE,X", "000000", "006032", "006000", "000000", @"WRITE ,X");
            AddToken("COMM,AWRITE,XB", "000000", "000033", "006000", "000000", @"WRITE ,X,B");
            AddToken("COMM,AWRITE,XI", "000000", "002033", "006000", "000000", @"WRITE I,X & I,X,B");
            AddToken("COMM,AWRITE,HOLD", "000000", "004033", "000000", "000000", @"WRITE IN LAST ADDRESS");
            AddToken("COMM,AWRITE,NEXT", "000000", "006033", "000000", "000000", @"WRITE IN NEXT ADDRESS");
            AddToken("COMM,RDRQ,PT", "000000", "000034", "002040", "000000", @"READ PAGE-TABLE-RELATIVE, ADDRESS FROM IDE");
            AddToken("COMM,RDRQ,APT", "000000", "002034", "002040", "000000", @"READ ALTERNATIVE-PT-RELATIVE, ADDRESS FROM IDB");
            AddToken("COMM,RDRQ,HOLD", "000000", "004034", "002040", "000000", @"READ FROM LAST USED PT. ADDRESS FROM IDB");
            AddToken("COMM,EXRQ", "000000", "006034", "002040", "000000", @"EXAMINE");
            AddToken("COMM,WRRQ,PT", "000000", "000035", "002000", "000000", @"WRITE PT-RELATIVE, ADDRESS FROM IDB");
            AddToken("COMM,WRRQ,APT", "000000", "002035", "002000", "000000", @"WRITE APT-RELATIVE, ADDRESS FROM IDB");
            AddToken("COMM,WRRQ,HOLD", "000000", "004035", "002000", "000000", @"WRITE IN LAST USED PT, ADDRESS FROM IDB");
            AddToken("COMM,DERQ", "000000", "006035", "002000", "000000", @"DEPOSIT");
            AddToken("COMM,ADCS", "000000", "000036", "000000", "000000", @"SET CONTROL STORE ADDRESS. ND-120: no DLY bits (EPROM verified)");
            AddToken("COMM,RWCS", "000000", "002036", "000000", "000000", @"READ OR WRITE IN CONTROL STORE. ND-120: no DLY bits (EPROM verified)");
            //AddToken("COMM,WLBR",      "000000", "004036", "004040", "000000", @"WRITE LOGICAL BANK REGISTER"); // ND-110
            AddToken("COMM,MACL", "000000", "004036", "000000", "000000", @"HARD RESET. MASTER CLEAR WITH LOAD CONTROL STORE");
            //AddToken("COMM,WALBR",     "000000", "006036", "004040", "000000", @"WRITE ALTERNATIVE LOGICAL BANK REGISTER"); // ND-110
            AddToken("COMM,XSLOW", "000000", "006036", "000000", "000000", @"MAKE EXTRA SLOW CYCLE (425 NS)");
            AddToken("COMM,IDENT", "000000", "004037", "002000", "000000", @"IDENT BUS REQUEST");
            AddToken("COMM,IOX", "000000", "006037", "002000", "000000", @"IOX BUS REQUEST");
            AddToken("T,JMP", "000000", "000000", "000000", "000000", @"TRUE SEQUENCE IS JUMP", Constants.IsTrueAddr);
            AddToken("T,JMP0-3", "000000", "000000", "001000", "000000", @"TRUE SEQ IS JUMP. IR0-3 CONTROLS THE 4 LOWER JUMP ADDR BITS", Constants.IsTrueAddr);
            AddToken("T,JMPAOPR", "000000", "006000", "001000", "000000", @"TRUE SEQ IS JUMP. A-OP CONTROLS THE 4 LOWER JUMP ADDR BITS", Constants.IsTrueAddr);
            AddToken("T,RETURN", "000000", "000000", "040000", "000000", @"TRUE SEQUENCE IS RETURN", Constants.IsTrueAddr);
            AddToken("T,NEXT", "000000", "000000", "100000", "000000", @"TRUE SEQUENCE IS NEXT", Constants.IsTrueAddr);
            AddToken("T,HOLD", "000000", "000000", "000000", "000000", @"TRUE STACK OPERATION IS HOLD", Constants.IsTrueStack);
            AddToken("T,POP", "000000", "000000", "010000", "000000", @"TRUE STACK OPERATION IS POP", Constants.IsTrueStack);
            AddToken("T,LOAD", "000000", "000000", "020000", "000000", @"TRUE STACK OPERATION IS LOAD", Constants.IsTrueStack);
            AddToken("T,PUSH", "000000", "000000", "030000", "000000", @"TRUE STACK OPERATION IS PUSH", Constants.IsTrueStack);
            AddToken("F,JMP", "000000", "000000", "000000", "000000", @"FALSE SEQUENCE IS JUMP. USED WITH A CONDITION SETTING", Constants.IsFalseAddr);
            AddToken("F,RETURN", "000000", "000000", "000000", "000004", @"FALSE SEQUENCE IS RETURN, USED WITH A CONDITION SETTING", Constants.IsFalseAddr);
            AddToken("F,NEXT", "000000", "000000", "000000", "000010", @"FALSE SEQUENCE IS NEXT. USED WITH A CONDITION SETTING", Constants.IsFalseAddr);
            AddToken("F,HOLD", "000000", "000000", "000000", "000000", @"FALSE STACK OPERATION IS HOLD. USED WITH A COND SETTING", Constants.IsFalseStack);
            AddToken("F,POP", "000000", "000000", "000000", "000001", @"FALSE STACK OPERATION IS POP. USED WITH A COND SETTING", Constants.IsFalseStack);
            AddToken("F,LOAD", "000000", "000000", "000000", "000002", @"FALSE STACK OPERATION IS LOAD. USED WITH A COND SETTING", Constants.IsFalseStack);
            AddToken("F,PUSH", "000000", "000000", "000000", "000003", @"FALSE STACK OPERATION IS PUSH. USED WITH A COND SETTING", Constants.IsFalseStack);
            AddToken("COND,STP", "000000", "000000", "000400", "000360", @"CONDITION FOR TESTING IS 'STOP'", Constants.IsCond);
            AddToken("COND,PXM", "000000", "000000", "000400", "000220", @"CONDITION FOR TESTING IS PREFIX-MODE", Constants.IsCond);
            AddToken("COND,OVF", "000000", "000000", "000400", "000240", @"CONDITION FOR TESTING IS 'OVERFLOW' FROM ALU", Constants.IsCond);
            AddToken("COND,CRY", "000000", "000000", "000400", "000260", @"CONDITION FOR TESTING IS 'CARRY' FROM ALU", Constants.IsCond);
            AddToken("COND,F11", "000000", "000000", "000400", "000300", @"CONDITION FOR TESTING IS BIT 11 FROM ALU", Constants.IsCond);
            AddToken("COND,F15", "000000", "000000", "000400", "000320", @"CONDITION FOR TESTING IS BIT 15 FROM ALU", Constants.IsCond);
            AddToken("COND,F=0", "000000", "000000", "000400", "000340", @"CONDITION FOR TESTING IS 'ALL ZEROS' FROM ALU", Constants.IsCond);
            AddToken("COND,LC=0", "000000", "000000", "000400", "000020", @"CONDITION FOR TESTING IS 'LOOP-COUNTER' CONTENT =0", Constants.IsCond);
            AddToken("COND,FETCH", "000000", "000000", "000400", "000100", @"CONDITION FOR TESTING IS LAST MEMORY REQUEST WAS FETCH", Constants.IsCond);
            AddToken("COND,IRQ", "000000", "000000", "000400", "000040", @"COND FOR TEST IS 'IRQ'. CHECKS LEV 10-15 IF 'COMM, CLIRQ'", Constants.IsCond);
            AddToken("COND,RESTR", "000000", "000000", "000400", "000060", @"COND FOR TESTING IS 'RESTRICTED-MODE'. TRUE IF RING 0-1", Constants.IsCond);
            AddToken("COND,OOD", "000000", "000000", "000400", "000120", @"CONDITION FOR TESTING IS THE 'ONE-OUT-DETECT' FLIP-FLOP", Constants.IsCond);
            AddToken("COND,DZD", "000000", "000000", "000400", "000000", @"COND FOR TESTING IS THE 'DOUBLE-ZERO-DETECT' FLIP-FLOP", Constants.IsCond);
            AddToken("COND,COND", "000000", "000000", "000400", "000160", @"COND FOR TEST IS OUTCOME OF LATEST TEST (DELAYS TESTS)", Constants.IsA_B);
            AddToken("AB,CDIGI", "000000", "000000", "000011", "170000", @"COUNTER CONTROLLING NUMBER OF DIGITS IN AN OCTAL NUMBER", Constants.IsA_B);
            AddToken("AB,UPPNR", "000000", "000000", "000012", "130000", @"SCRATCH WORD KEEPING UPPER ADDR LIMIT IN MOPC DUMP CMND", Constants.IsA_B);
            AddToken("AB,CURNR", "000000", "000000", "000013", "130000", @"SCRATCH WORD KEEPING CURRENT ADDR IN A MOPC DUMP COMMAND", Constants.IsA_B);
            AddToken("AB,CNT10", "000000", "000000", "000017", "170000", @"COUNTER CONTROLLING NO. OF OCTAL NOS/LINE IN MOPC DUMP CMND", Constants.IsA_B);
            AddToken("AB,PRCHR", "000000", "000000", "000016", "160000", @"SCRATCH WORD : THE NEXT CHARACTER TO BE WRITTEN BY MOPC", Constants.IsA_B);
            AddToken("AB,TXT1", "000000", "000000", "000014", "160000", @"SCRATCH WORD : DISPLAY TEXT", Constants.IsA_B);
            AddToken("AB,TXT2", "000000", "000000", "000013", "160000", @"SCRATCH WORD : DISPLAY TEXT", Constants.IsA_B);
            AddToken("AB,SCRAM", "000000", "000000", "000015", "140000", @"SCR WD : SCRAMBLED REPRESENTATION OF LETTERS IN MOPC-INPUT", Constants.IsA_B);
            AddToken("AB,OCTNR", "000000", "000000", "000015", "150000", @"SCRATCH WORD : OCTAL NUMBER ASSEMBLED FROM MOPC-INPUT", Constants.IsA_B);
            AddToken("AB,DISPL", "000000", "000000", "000015", "160000", @"TYPE OF RUNNING DISPLAY", Constants.IsA_B);
            AddToken("AB,OCTAD", "000000", "000000", "000013", "150000", @"ADDRESS OF RUNNING DISPLAY", Constants.IsA_B);
            AddToken("AB,OCTA2", "000000", "000000", "000012", "160000", @"WORD TO EXTEND ADDRESS IN OCTAD TO 24 BITS", Constants.IsA_B);
            AddToken("AB,DEPOS", "000000", "000000", "000017", "150000", @"SOME OCTAL DIGIT WAS WRITTEN SINCE LAST COMMAND TERMINATED", Constants.IsA_B);
            AddToken("AB,DUMPF", "000000", "000000", "000016", "150000", @"SCRATCH WORD INDICATING THAT A DUMP IS IN PROGRESS", Constants.IsA_B);
            AddToken("AB,RONLY", "000000", "000000", "000014", "150000", @"THE EXAMINED REGISTER IS READ-ONLY", Constants.IsA_B);
            AddToken("AB,WRTYP", "000000", "000000", "000012", "150000", @"TYPE OF VARIABLE IN CASE OF DEPOSIT", Constants.IsA_B);
            AddToken("AB,WRADR", "000000", "000000", "000011", "150000", @"ADDRESS OF VARIABLE IN CASE OF DEPOSIT", Constants.IsA_B);
            AddToken("AB,ACTLV", "000000", "000000", "000017", "140000", @"SCRATCH WORD HOLDING 'ACTIVE LEVELS'", Constants.IsA_B);
            AddToken("AB,PVL", "000000", "000000", "000015", "170000", @"SCRATCH WORD HOLDING 'PREVIOUS LEVEL'", Constants.IsA_B);
            AddToken("AB,IIE", "000000", "000000", "000012", "170000", @"SCR WORD HOLDING 'PIC' REPRESENTATION OF LAST IIE SETTING", Constants.IsA_B);
            AddToken("AB,PID", "000000", "000000", "000014", "170000", @"SCR WORD HOLDING MICROPROGRAM-KNOWN BITS OF PID REGISTER", Constants.IsA_B);
            AddToken("AB,PIE", "000000", "000000", "000013", "170000", @"SCRATCH WORD HOLDING THE 'PIE' REGISTER", Constants.IsA_B);
            AddToken("AB,STATUS", "000000", "000000", "000017", "160000", @"SCRATCH WORD HOLDING THE LATEST 'COMM, SIOC' INFORMATION", Constants.IsA_B);
            AddToken("AB,OCTN2", "000000", "000000", "000015", "130000", @"SCRATCH WORD EXPANDING THE 'AB, OCTNA' TO 24 BITS", Constants.IsA_B);
            AddToken("AB,NUMBR", "000000", "000000", "000012", "120000", @"SCRATCH WORD HOLDING AN OCTAL NUMBER BEING PRINTED BY MOPC", Constants.IsA_B);
            AddToken("AB,OPR", "000000", "000000", "000011", "160000", @"SCRATCH WORD HOLDING THE 'OPR' REGISTER VALUE", Constants.IsA_B);
            AddToken("AB,BRKPT", "000000", "000000", "000016", "140000", @"SCRATCH WORD HOLDING BREAKPOINT ADDRESS", Constants.IsA_B);
            AddToken("AB,SINGL", "000000", "000000", "000014", "140000", @"SCRATCH WORD COUNTING SINGLE-INSTRUCTION", Constants.IsA_B);
            AddToken("AB,BPFLG", "000000", "000000", "000013", "140000", @"SCRATCH WORD INDICATING THAT BREAKPOINT IS ON", Constants.IsA_B);
            AddToken("AB,MACL", "000000", "000000", "000011", "140000", @"SCRATCH WORD HOLDING RETRY COUNTER FOR LOAD AFTER MACL", Constants.IsA_B);
            AddToken("AB,LMP", "000000", "000000", "000012", "140000", @"SCRATCH WORD HOLDING THE 'LMP' REGISTER VALUE", Constants.IsA_B);
            AddToken("AB,EXMOD", "000000", "000000", "000011", "130000", @"SCRATCH WORD HOLDING THE 'EXM' REGISTER", Constants.IsA_B);
            AddToken("AB,MANIR", "000000", "000000", "000014", "130000", @"SCRATCH WORD HOLDING FLAG FOR MANUAL IR", Constants.IsA_B);
            AddToken("AB,SSAVE", "000000", "000000", "000016", "130000", @"SCRATCH WORD HOLDING STS DURING DECIMAL INTRUCTIONS", Constants.IsA_B);
            AddToken("XRF", "000004", "000000", "000000", "000000", @"SELECT EXTENDED REGISTER FILE", Constants.IsA_B);
            AddToken("AB,UCIL", "000000", "000000", "000014", "120000", @"SCRATCH WORD HOLDING CACHE INHIBIT UPPER LIMIT", Constants.IsA_B);
            AddToken("AB,LCIL", "000000", "000000", "000013", "120000", @"SCRATCH REGISTER HOLDING CACHE INHIBIT LOWER LIMIT", Constants.IsA_B);

            AddToken("AB,PGS", "000000", "000000", "000015", "120000", @"COPY OF PGS FROM LAST PF/PV", Constants.IsA_B);
            AddToken("AB,STBNK", "000000", "000000", "000011", "120000", @"GLOBAL BANK POINTER TO THE SEGMENT TABLE BANK", Constants.IsA_B);
            AddToken("AB,STSRT", "000000", "000000", "000016", "120000", @"GLOBAL POINTER TO THE SEGMENT TABLE WITHIN THE BANK", Constants.IsA_B);
            AddToken("AB,CMBNK", "000000", "000000", "000017", "120000", @"GLOBAL POINTER TO THE CORE MAP TABLE BANK", Constants.IsA_B);
            AddToken("AB,BAUD", "000000", "000000", "000010", "010000", @"BAUD RATE THUMBWHEEL VALUE", Constants.IsA_B);
            AddToken("AB,OLD303", "000000", "000000", "000015", "050000", @"SAVED IOX 303 A REG TO SPOT UART DIFFS", Constants.IsA_B);
            AddToken("AB,NOISE", "000000", "000000", "000010", "020000", @"SET ON MACL,RESET ON STOP,INHIBIT LOAD AFTER MACL", Constants.IsA_B);



        }

        /// <summary>
        /// Post-load fixup for microcode version L (EPROM version word oct 014):
        /// mutates the already-initialized token collection in place.
        ///
        /// Version L removed the DLY1 register-read delay (bit 27 of the
        /// microword, octal 004000 in the w2 chunk) from the three
        /// register-select tokens that carried it in version K:
        /// B,P / B,B / B,X. Everything else is identical to the K table; in L
        /// every remaining DLY1 bit comes from the memory-operation COMM
        /// tokens (COMM,IREAD,APT / COMM,AREAD,B / ...), which are unchanged.
        ///
        /// Evidence: the L EPROM dump has not a single word carrying bit 27
        /// without a DLY1-bearing COMM token, while the K listing compiles
        /// 235 words whose only diff vs L is bit 27 - all of them
        /// B,P / B,B / B,X words. So ND most likely made this exact change to
        /// their own assembler's token table between K and L and rebuilt; the
        /// printed source spelling (B,P etc.) stays the same, only the
        /// assembled bits differ.
        ///
        /// Validated bit-exact against the L EPROM (all 4886 words) by
        /// ND120UC scripts/check_l_from_k_vs_eprom.py.
        /// </summary>
        internal void AdjustTokensForVersionL()
        {
            // Same register numbers (2 = P, 3 = B, 7 = X), DLY1 (w2 004000) removed.
            ReplaceToken("B,P", "000000", "000000", "000002", "000000", @"B-OP. IS 2. USED TO ADDR. THE P-REGISTER (L: no DLY1)", Constants.IsB);
            ReplaceToken("B,B", "000000", "000000", "000003", "000000", @"B-OP. IS 3. USED TO ADDR. THE B-REGISTER (L: no DLY1)", Constants.IsB);
            ReplaceToken("B,X", "000000", "000000", "000007", "000000", @"B-OP. IS 7. USED TO ADDR. THE X-REGISTER (L: no DLY1)", Constants.IsB);
        }
    }
}

/* new tokens

AB,BAUD
AB,OLD303
AB,NOISE

COMM,UART,DATA     5,0
COMM,UART,STATUS   5,1
COMM,UART,MODE     5,2
COMM,UART,COM      5,3

IDBS,LA
IDBS,INR
IDBS,PICM
IDBS,UART



Modified (changed meaning)

* COMM,WLBR => COMM,MACL (HARD RESET) (36,2)
* COMM,WALBR changed to COMM,XSLOW (36,3)

COMM,MACL =  36,2 (=COMM,LCS)
COMM,XSLOW = 36,3


Removed (not used in ND-120)
* COMM,TBSTR 
* COMM,LBCONT
* COMM,IREAD2
* IDBS,LBR
* COMM,SLOW2


Removed SINTRAN 4 reference
* COMM,LDDOMI
* COMM,LDPS


Renamed
* COMM,SLOW1 => COMM,SLOW


Some microinstruction changed in bits range "16-31" (DELAY and DLY0+DLY1)
* 006000 to 000040 
* 004040 to 000040
* 004040 to 002040

Bit 27 - DLY 1  004000  
Bit 26 - DLY 0  002000 
Bit 26+27       006000

Bit 21 - DELAY  000040


*/
