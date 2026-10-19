%#MODEL nd100
% ND-100 3033E-CX micro code, recovered from the PROM chips in reference/roms/ND100/3033E-CX.
% This is NOT the original Norsk Data source: there is none. It is the disassembly of the
% factory PROMs by tools/nd100-prom-to-uc.mjs, in the mnemonics of ND-06.018.01.
% Words: 3537. Assembled with nd100-asm the words come back bit for bit.
% Labels are the macro instruction entry points from the decode PLA (L<octal address>).
%

0/
          A,R7 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD
          COND,FETCH F,NEXT F,HOLD;
          A,R5 ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD
          3 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,R3 ALUF,ORDQ
          IDBS,BMG COMM,CLIRQ T,NEXT T,HOLD
          COND,IRQ F,JMP F,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT
          12 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,STP F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          15 CONDENABL;
          AB,BPFLG A,R4 B,R3 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          AB,SINGL A,R4 B,R4 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2401 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          2401 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,FETCH F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          15 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          15;
          A,A ALUD,NONE
          IDBS,GPR T,MAPJ T,HOLD
          16;
          A,P ALUF,ZERO ALUD,B,YA
          COMM,RDRQ T,JMP T,PUSH
          0;
          ALUD,NONE
          IDBS,DSABL T,NEXT T,HOLD CYCL,WAIT;
          B,P ALUF,PASSB ALUD,NONE
          COMM,RDRQ T,NEXT T,PUSH;
          A,A B,P ALUF,B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,MAPJ T,HOLD CYCL,WAIT
          16;
          A,P B,R1 ALUF,A-B ALUD,NONE
          COMM,ESRP T,NEXT T,HOLD CYCL,WAIT
          COND,R=P F,JMP F,HOLD;
          A,A B,P ALUF,B+1 ALUD,B
          IDBS,GPR T,NEXT T,NEXT T,MAPJ T,HOLD
          16 CONDENABL;
          PIC,LOSTS B,P ALUF,B-1 ALUD,B
          IDBS,AARG COMM,EPIC T,NEXT T,HOLD
          10;
          ALUD,NONE
          T,JMP T,HOLD
          20;
          A,A B,P ALUF,B+1 ALUD,B
          IDBS,GPR T,MAPJ T,HOLD
          16;
L0027:
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
L0030:
          A,R1 ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
L0031:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          ALUF,ZERO ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0033:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          A,A ALUF,PASSA ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0035:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          A,T ALUF,PASSA ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0037:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          A,X ALUF,PASSA ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0041:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          A,A ALUF,PASSA ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          3676;
          A,D ALUF,PASSA ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0044:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3700;
          A,T ALUF,PASSA ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          3676;
          A,A ALUF,PASSA ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          3676;
          A,D ALUF,PASSA ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
L0050:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,R2 ALUF,D+1 ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,HOLD T,HOLD
          COND,COND F,JMP F,POP;
          A,R2 ALUF,PASSA ALUD,NONE
          T,NEXT T,POP CYCL,WAIT
          22 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
L0055:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0057:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,T ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0061:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,X ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0063:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          B,D ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0066:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,T ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,JMP MIS,HOLD T,HOLD
          64;
L0071:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          A,A B,A ALUF,D+A ALUD,B STS,EA
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0073:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          A,A B,A ALUF,A-D ALUD,B STS,EA
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0075:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          A,A B,A ALUF,ANDDA ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0077:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          A,A B,A ALUF,ORDA ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L0101:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,STS T,NEXT T,HOLD;
          B,STS ALUF,MASKDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          20;
          A,A B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT
          110 CONDENABL;
          B,R2 ALUF,-B ALUD,B
          T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          B,R6 ALUF,ZERO
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          112 CONDENABL;
          A,R3 ALUF,-A ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          B,R5 ALUF,ZERO ALUD,B
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,R2 B,R5 ALUF,A+B ALUD,SRD ALUM,FMU
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R5 ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,APT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R4 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          120 CONDENABL;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          60;
          A,STS B,R4 ALUF,ORAB ALUD,NONE STS,LO
          T,NEXT T,HOLD;
          A,A B,R3 ALUF,XORAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD
          124 CONDENABL;
          B,A ALUF,-B ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,POP
          26;
L0125:
          ALUF,D-1
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3660;
L0126:
          A,P B,L ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          L0125;
L0127:
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F=0 F,RETURN F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP T,HOLD
          131 CONDENABL;
          A,R1 B,P ALUF,A+B ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
L0132:
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F=0 F,JMP F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,RETURN T,HOLD
          131 CONDENABL;
L0134:
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F15 F,RETURN F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP T,HOLD
          131 CONDENABL;
L0136:
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F15 F,JMP F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,RETURN T,HOLD
          131 CONDENABL;
L0140:
          A,X ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F=0 F,RETURN F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP T,HOLD
          131 CONDENABL;
L0142:
          B,X ALUF,B+1 ALUD,B
          T,NEXT T,POP
          COND,F15 F,JMP F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,RETURN T,HOLD
          131 CONDENABL;
L0144:
          B,X ALUF,B+1 ALUD,B
          T,NEXT T,POP
          COND,F15 F,RETURN F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP T,HOLD
          131 CONDENABL;
L0146:
          A,X ALUF,PASSA ALUD,NONE
          T,NEXT T,POP
          COND,F15 F,RETURN F,HOLD;
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP T,HOLD
          131 CONDENABL;
L0150:
          B,DEST ALUF,PASSB
          T,NEXT T,HOLD;
          A,SHCE B,DEST ALUF,PASSA ALUD,B EN_EXT
          T,NEXT T,HOLD;
          B,SRCE ALUF,PASSQ ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
L0153:
          ALUF,PASSB
          T,JMP T,HOLD
          151;
L0154:
          B,DEST ALUF,PASSB
          T,NEXT T,HOLD;
          A,SHCE B,DEST ALUF,INVA ALUD,B EN_EXT
          T,NEXT T,HOLD;
          B,SRCE ALUF,PASSQ ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
L0157:
          ALUF,PASSB
          T,JMP T,HOLD
          155;
L0160:
          A,SHCE B,DEST ALUF,ANDAB ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0161:
          B,DEST ALUF,PASSA ALUD,B
          T,RETURN T,POP
          21 CONDENABL;
L0162:
          A,SHCE B,DEST ALUF,MASKAB ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0163:
          A,SHCE B,DEST ALUF,XORAB ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0164:
          A,SHCE B,DEST ALUF,PASSA ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0165:
          A,SHCE B,R1 ALUF,INVA ALUD,B EN_EXT
          T,NEXT T,HOLD;
          A,R1 B,DEST ALUF,ORAB ALUD,B
          T,RETURN T,POP
          21 CONDENABL;
L0167:
          A,SHCE B,DEST ALUF,INVA ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0170:
          A,SHCE B,DEST ALUF,ORAB ALUD,B EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0171:
          A,SHCE B,DEST ALUF,A+B ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0172:
          A,SHCE B,DEST ALUF,A ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0173:
          A,SHCE B,DEST ALUF,B-A-1 ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0174:
          A,SHCE B,DEST ALUF,-A-1 ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0175:
          A,SHCE B,DEST ALUF,A+B+1 ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0176:
          A,SHCE B,DEST ALUF,A+1 ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0177:
          A,SHCE B,DEST ALUF,B-A ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0200:
          A,SHCE B,DEST ALUF,-A ALUD,B STS,EA EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0201:
          A,SHCE B,DEST ALUF,A+B ALUD,B STS,EA CRY,C EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0202:
          A,SHCE B,DEST ALUF,A ALUD,B STS,EA CRY,C EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0203:
          A,SHCE B,DEST ALUF,B-A-1 ALUD,B STS,EA CRY,C EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0204:
          A,SHCE B,DEST ALUF,-A-1 ALUD,B STS,EA CRY,C EN_EXT
          T,RETURN T,POP
          21 CONDENABL;
L0205:
          ALUD,NONE
          T,JMP T,HOLD
          21;
L0206:
          ALUD,NONE
          IDBS,GPR COMM,LDLC T,JMP T,LOAD
          210;
          B,A ALUF,PASSB ALUD,SRB ALUM,IR
          T,JMP T,POP LCOUNT
          21;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,HOLD LCOUNT;
L0212:
          ALUD,NONE
          IDBS,GPR COMM,LDLC T,JMP T,LOAD
          210;
          B,T ALUF,PASSB ALUD,SRB ALUM,IR
          T,JMP T,POP LCOUNT
          21;
L0214:
          ALUD,NONE
          IDBS,GPR COMM,LDLC T,JMP T,LOAD
          210;
          B,D ALUF,PASSB ALUD,SRB ALUM,IR
          T,JMP T,POP LCOUNT
          21;
L0216:
          A,D ALUF,PASSA
          IDBS,GPR COMM,LDLC T,JMP T,LOAD
          210;
          B,A ALUF,PASSB ALUD,SRD ALUM,IR
          T,NEXT T,POP LCOUNT;
          B,D ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          21;
L0221:
          B,A ALUF,PASSD ALUD,B
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0222:
          B,T ALUF,PASSD ALUD,B
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0223:
          B,X ALUF,PASSD ALUD,B
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0224:
          B,B ALUF,PASSD ALUD,B
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0225:
          A,A B,A ALUF,D+A ALUD,B STS,EA
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0226:
          A,T B,T ALUF,D+A ALUD,B STS,EA
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0227:
          A,X B,X ALUF,D+A ALUD,B STS,EA
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0230:
          A,B B,B ALUF,D+A ALUD,B STS,EA
          IDBS,GPR,SEXT T,JMP T,POP
          21;
L0231:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,F=0 F,RETURN F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          233 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
L0234:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,HOLD
          COND,OVF F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          L0246 CONDENABL;
L0236:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,F15 F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,HOLD
          233 CONDENABL;
L0240:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,CRY F,RETURN F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          233 CONDENABL;
L0242:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,HOLD
          233 CONDENABL;
L0244:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,HOLD
          COND,OVF F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          L0236 CONDENABL;
L0246:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,F15 F,RETURN F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          233 CONDENABL;
L0250:
          A,SHCE B,DEST ALUF,B-A ALUD,NONE EN_EXT
          T,NEXT T,POP
          COND,CRY F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,HOLD
          233 CONDENABL;
L0252:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,PUSH
          256;
          ALUD,NONE
          T,NEXT T,HOLD
          L0261 CONDENABL;
L0254:
          A,REG B,R1 ALUF,INVD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          257;
          A,R1 B,DEST ALUF,ANDAB ALUD,B
          T,RETURN T,POP
          260 CONDENABL;
          ALUF,ANDDQ
          IDBS,STS T,RETURN T,POP
          COND,F=0 F,JMP F,HOLD;
          ALUF,PASSD ALUD,B
          IDBS,STS T,RETURN T,POP
          COND,DR=2 F,JMP F,POP;
          ALUF,PASSA STS,LO
          T,RETURN T,HOLD;
L0261:
          A,REG B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          257;
          A,R1 B,DEST ALUF,ORAB ALUD,B
          IDBS,BMG T,RETURN T,POP
          260 CONDENABL;
L0263:
          A,REG B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          257;
          A,R1 B,DEST ALUF,XORAB ALUD,B
          T,RETURN T,POP
          260 CONDENABL;
L0265:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,NEXT T,HOLD
          L0273 CONDENABL;
L0267:
          ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          B,DEST ALUF,INVB
          T,JMP T,HOLD
          275;
L0271:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,NEXT T,HOLD
          L0267 CONDENABL;
L0273:
          ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          B,DEST ALUF,PASSB
          T,NEXT T,HOLD;
          A,REG ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          233 CONDENABL;
L0277:
          A,P B,R2 ALUF,INVD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          301;
          B,R2 ALUF,ANDAB ALUD,NONE STS,LO
          T,JMP T,HOLD CYCL,WAIT
          17;
          ALUD,NONE
          T,JMP T,PUSH
          L0252;
          B,R2 ALUF,ANDAB ALUD,NONE STS,LO
          T,JMP T,HOLD CYCL,WAIT
          20;
L0303:
          A,P B,R2 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          305;
          B,R2 ALUF,ORAB ALUD,NONE STS,LO
          T,JMP T,HOLD CYCL,WAIT
          17;
          A,R2 ALUF,XORDA
          IDBS,STS T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE STS,LO
          T,JMP T,PUSH
          L0252;
          B,R2 ALUF,ORAB ALUD,NONE STS,LO
          T,JMP T,HOLD CYCL,WAIT
          20;
L0310:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,RETURN T,HOLD
          L0314 CONDENABL;
L0312:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,NEXT T,HOLD
          21 CONDENABL;
L0314:
          A,REG B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          257;
          A,R1 B,DEST ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,R2 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          327 CONDENABL;
          A,R2 ALUF,ORAB ALUD,NONE STS,LO
          T,JMP T,HOLD
          21;
L0320:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,RETURN T,HOLD
          L0324 CONDENABL;
L0322:
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,LOAD
          256;
          ALUD,NONE
          T,NEXT T,HOLD
          21 CONDENABL;
L0324:
          A,REG B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          257;
          A,R1 B,DEST ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,R2 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          317 CONDENABL;
          A,R2 ALUF,MASKAB ALUD,NONE STS,LO
          T,JMP T,HOLD
          21;
L0330:
          ALUF,PASSD ALUD,B
          IDBS,STS T,JMP T,PUSH
          347;
          B,X ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          334 CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,PIL B,LC ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,POP LCOUNT;
          A,X B,R1 ALUF,PASSA ALUD,B
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,REG B,P ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,X ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,T ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,A ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,D ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,L ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          377;
          A,REG B,Z ALUF,ANDDQ
          IDBS,REG T,JMP T,PUSH
          3676;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          3676;
          A,REG B,B ALUD,NONE
          IDBS,REG T,JMP T,POP CYCL,WAIT
          22;
          ALUF,PASSD
          IDBS,GPR T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          A,PIL ALUF,XORDQ
          IDBS,AARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,RETURN T,POP
          L0170;
L0353:
          B,X ALUD,NONE
          IDBS,BARG COMM,LDLC T,JMP T,PUSH
          347;
          A,P B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,REG B,P ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,X ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,T ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,A ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,D ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,L ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,Z ALUD,NONE
          IDBS,DBR COMM,EWRF T,JMP T,PUSH CYCL,WAIT
          3675;
          A,REG B,B ALUF,PASSQ ALUD,NONE
          IDBS,DBR COMM,EWRF T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,POP;
          ALUD,NONE
          T,NEXT T,HOLD
          26 CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,PIL B,LC ALUF,PASSD ALUD,B
          IDBS,REG T,NEXT T,POP LCOUNT;
          A,R2 B,P ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSA ALUD,NONE STS,LO
          T,JMP T,POP
          26;
L0373:
          ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,GPR T,JMP T,LOAD
          351;
          A,REG B,Z ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          400 CONDENABL;
          ALUF,ANDDA ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          B,DEST ALUF,PASSB
          T,JMP T,HOLD
          403;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,REG B,Z ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,REG B,DEST ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,RETURN T,HOLD;
L0404:
          A,P B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,GPR T,JMP T,LOAD
          351;
          ALUD,NONE
          IDBS,DSABL T,NEXT T,HOLD
          412 CONDENABL;
          A,A B,DEST ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          416;
          A,R2 B,P ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          0 CONDENABL;
          ALUF,PASSA ALUD,NONE STS,LO
          T,RETURN T,HOLD;
          A,A ALUF,PASSA
          T,NEXT T,HOLD;
          A,REG B,DEST ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          416;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          377 CONDENABL;
          A,REG B,Z ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,RETURN T,HOLD;
          B,DEST ALUF,PASSD ALUD,NONE
          IDBS,BARG T,RETURN T,POP
          COND,F=0 F,RETURN F,HOLD;
L0417:
          A,X B,R1 ALUF,PASSA ALUD,SRB
          IDBS,DBR COMM,LDGPR T,JMP MIS,APT T,PUSH CYCL,WAIT
          424;
          ALUF,PASSD
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          423 CONDENABL;
          B,A ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          ALUD,NONE
          T,JMP T,POP
          26;
          ALUF,PASSD
          IDBS,SWAP T,RETURN T,POP;
          A,T B,R1 ALUF,A+B ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,X B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,RETURN T,POP
          COND,F=0 F,NEXT F,HOLD;
L0426:
          B,R3 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,A B,R3 ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,SRB
          IDBS,DBR COMM,LDGPR T,JMP MIS,APT T,PUSH CYCL,WAIT
          424;
          ALUF,PASSD
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          435 CONDENABL;
          AB,IIE A,R7 B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          AB,UPPNR A,R3 B,R2 ALUF,ORAB ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          22;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,R3 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,SWAP T,JMP T,HOLD
          433;
L0440:
          A,SHCE B,R1 ALUF,PASSA ALUD,B EN_EXT
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,DEST ALUF,PASSB
          COMM,LDGPR T,NEXT T,HOLD
          443 CONDENABL;
          B,R1 ALUF,-B ALUD,B
          T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          B,R6 ALUF,ZERO ALUD,B
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          445 CONDENABL;
          ALUF,-Q ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,R1 B,R6 ALUF,A+B ALUD,SRD ALUM,FMU
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,SHCE B,DEST ALUF,XORAB ALUD,NONE EN_EXT
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,D ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          452 CONDENABL;
          A,R6 B,A ALUF,PASSA ALUD,B
          T,JMP T,POP
          21;
          B,D ALUF,-Q ALUD,B STS,EA
          T,NEXT T,HOLD;
          A,R6 B,A ALUF,-A-1 ALUD,B CRY,C
          T,JMP T,POP
          21;
L0454:
          A,SHCE B,R1 ALUF,PASSA ALUD,B EN_EXT
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,A B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          457 CONDENABL;
          B,R1 ALUF,-B ALUD,B
          T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          A,SHCE B,A ALUF,XORAB EN_EXT
          T,NEXT T,HOLD
          462 CONDENABL;
          B,D ALUF,-B ALUD,B STS,EA
          T,NEXT T,HOLD;
          B,A ALUF,-B-1 ALUD,B CRY,C
          T,NEXT T,HOLD;
          A,R1 B,A ALUF,B-A ALUD,B
          T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          B,R7 ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          505 CONDENABL;
          B,D ALUF,PASSB
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          16;
          B,STS ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          A,X ALUF,PASSD ALUD,NONE STS,LO
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          B,A ALUF,PASSB ALUD,SLD STS,ES
          IDBS,AARG COMM,LDGPR T,NEXT T,NEXT MIS,APT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,R1 B,A ALUF,B-A ALUD,SLD STS,ES CRY,C ALUM,FDV
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          ALUF,PASSD
          IDBS,GPR T,NEXT T,HOLD;
          A,A B,D ALUF,PASSA ALUD,SRB
          T,NEXT T,NEXT MIS,HOLD T,HOLD;
          B,D ALUF,ANDDQ ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,STS ALUF,PASSA ALUD,NONE STS,LO
          T,NEXT T,HOLD
          476 CONDENABL;
          A,R1 B,D ALUF,A+B ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R5 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          501 CONDENABL;
          ALUF,-Q
          T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD
          503 CONDENABL;
          B,D ALUF,-B ALUD,B
          T,NEXT T,HOLD;
          A,A B,R7 ALUF,XORAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,POP;
          ALUD,NONE
          T,NEXT T,HOLD
          21 CONDENABL;
          B,STS ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          B,STS ALUF,ORDQ ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          A,STS ALUF,PASSA ALUD,NONE STS,LO
          T,JMP T,POP
          21;
L0510:
          A,SHCE ALUF,XORDA EN_EXT
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R7 ALUF,ANDDQ ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          7700;
          A,SHCE ALUF,PASSA ALUD,NONE EN_EXT
          COMM,LDGPR T,JMP T,HOLD
          505 CONDENABL;
          ALUD,NONE
          IDBS,GPR COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          0;
L0515:
          A,A B,X ALUF,A-1 ALUD,SLB
          COMM,LDGPR T,NEXT T,HOLD;
          A,X B,X ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,POP
          21;
L0517:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          AB,IIE A,R7 B,R2 ALUF,XORDQ ALUD,B
          IDBS,BMG T,JMP T,HOLD
          524;
L0522:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          B,STS ALUF,INVD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,A B,R6 ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          AB,PVL A,R7 B,R5 ALUF,INVD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,R5 B,T ALUF,ANDAB
          T,NEXT T,HOLD;
          A,R2 B,R5 ALUF,ANDAB ALUD,B
          T,JMP T,PUSH
          3675;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,Q-A ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,STS B,STS ALUF,ANDDA ALUD,B
          IDBS,STS COMM,CLFF T,JMP T,HOLD
          555 CONDENABL;
          A,R5 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R5 ALUF,A-1 ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          603 CONDENABL;
          AB,DISPL A,R6 B,R5 ALUF,MASKAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          1023 CONDENABL;
          ALUD,NONE
          IDBS,DSABL T,JMP T,PUSH
          3675;
          ALUF,PASSD
          IDBS,DBR COMM,CLFF T,NEXT T,PUSH CYCL,WAIT
          COND,LC=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSB ALUD,SRD STS,ES
          T,JMP MIS,APT T,LOAD LCOUNT
          641;
          ALUD,NONE
          T,JMP T,HOLD
          575 CONDENABL;
          A,D B,D ALUD,B STS,EA
          T,NEXT T,HOLD;
          A,R3 B,A ALUF,A+B ALUD,B STS,EA CRY,C
          T,NEXT T,HOLD
          COND,CRY F,JMP F,HOLD;
          A,D ALUF,PASSA
          T,NEXT T,HOLD
          720 CONDENABL;
          ALUF,ORDQ
          IDBS,ARG T,NEXT T,HOLD
          1;
          B,A ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,PT T,HOLD;
          B,D ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          A,L B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD;
          A,T ALUF,A+1
          T,JMP T,PUSH
          1027;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,HOLD
          1011;
          AB,RONLY A,R5 B,R4 ALUF,A-1 ALUD,B
          T,NEXT T,HOLD;
          AB,TXT1 A,R6 B,R4 ALUF,ORAB
          T,NEXT T,HOLD;
          ALUF,INVQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUF,A+1 ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          572 CONDENABL;
          A,D ALUF,PASSA
          T,NEXT T,HOLD;
          A,A B,R3 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R4 B,A ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R5 B,D ALUF,PASSA ALUD,B
          COMM,CLFF T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSB ALUD,SRD STS,ES
          T,JMP MIS,APT T,LOAD LCOUNT
          641;
          A,R2 B,T ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          575 CONDENABL;
          A,D B,D ALUD,B STS,EA
          T,JMP T,HOLD
          545;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          B,D ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R2 B,T ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          1023;
          A,D B,D ALUF,A-Q ALUD,B STS,EA
          T,NEXT T,HOLD;
          A,R3 B,A ALUF,B-A-1 ALUD,B CRY,C
          T,NEXT T,HOLD
          COND,OOD F,JMP F,HOLD;
          A,STS ALUF,PASSA
          T,NEXT T,HOLD
          602 CONDENABL;
          B,STS ALUF,ORDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,BARG T,NEXT T,HOLD;
          A,D ALUF,PASSA
          T,JMP T,HOLD
          620;
          A,R2 B,T ALUF,XORAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          607 CONDENABL;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          ALUF,PASSD
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          544;
          B,R3 ALUF,INVD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          A,D ALUF,A-D-1 STS,EA
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R3 B,A ALUF,A+B ALUD,B STS,EA CRY,C
          T,NEXT T,HOLD
          COND,CRY F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          615 CONDENABL;
          ALUF,Q+1 STS,EA
          T,NEXT T,HOLD;
          B,A ALUF,B ALUD,B CRY,C
          T,JMP T,HOLD
          620;
          A,STS ALUF,INVQ
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD;
          A,T B,T ALUF,XORDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,A ALUF,INVB ALUD,B
          T,NEXT T,HOLD;
          B,R4 ALUF,D-1 ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          21;
          A,P B,A ALUF,PASSB ALUD,NONE
          IDBS,AARG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,T B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          631 CONDENABL;
          A,T B,R5 ALUF,A-D ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUF,ZERO
          T,NEXT T,HOLD
          631 CONDENABL;
          B,A ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,D ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,R7 B,T ALUF,ZERO ALUD,B,YA
          COMM,LDGPR T,JMP T,HOLD
          1011;
          AB,PRCHR A,R6 B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,PUSH
          COND,F15 F,JMP F,HOLD;
          B,A ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,PT T,POP LCOUNT;
          B,A ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,PT T,HOLD;
          B,A ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,PT T,HOLD;
          B,D ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          A,R4 B,LC ALUF,A-D-1
          IDBS,BARG T,NEXT T,HOLD;
          A,R5 ALUF,A-Q
          T,JMP T,PUSH
          1024;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,HOLD
          1011;
          B,R3 ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,HOLD T,HOLD;
          A,R2 B,T ALUF,XORAB ALUD,NONE
          T,RETURN T,POP
          COND,F15 F,NEXT F,HOLD;

661/
L0661:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,STS ALUF,INVD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,STS B,STS ALUF,ANDDA ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          A,R2 B,T ALUF,A+B
          T,NEXT T,HOLD;
          A,R7 ALUF,MASKDQ
          IDBS,BMG T,NEXT T,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          A,T B,R2 ALUF,XORAB ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          673 CONDENABL;
          A,R7 ALUF,ORDQ
          IDBS,BMG T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          A,L B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,XNORAQ ALUD,B
          T,NEXT T,HOLD
          701 CONDENABL;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          762 CONDENABL;
          A,R6 B,T ALUF,XORDQ ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          ALUF,ZERO
          COMM,CLFF T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,R1 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          17;
          A,D STS,EA ALUM,FMU
          T,NEXT T,HOLD;
          A,A B,R1 ALUF,A+B ALUD,SRD STS,EA CRY,C ALUM,FMU
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          16;
          A,D STS,EA ALUM,FMU
          T,NEXT T,HOLD;
          A,A B,R1 ALUF,A+B ALUD,SRD STS,EA CRY,C ALUM,FMU
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,D STS,EA ALUM,FMU
          T,NEXT T,HOLD;
          A,A B,R1 ALUF,A+B ALUD,B STS,EA CRY,C ALUM,FMU
          T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          A,R1 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          724 CONDENABL;
          A,R1 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,D ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          626 CONDENABL;
          A,T ALUF,A-1
          T,JMP T,PUSH
          1024;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,OOD F,JMP F,HOLD;
          A,STS ALUF,PASSA
          T,NEXT T,HOLD
          1023 CONDENABL;
          B,STS ALUF,ORDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,BARG T,JMP T,HOLD
          1023;
          B,D ALUF,ORDQ
          IDBS,BARG T,NEXT T,HOLD
          COND,OOD F,JMP F,HOLD;
          A,D B,A ALUF,PASSB ALUD,SRD
          IDBS,BMG COMM,LDGPR T,NEXT T,NEXT MIS,PT T,HOLD
          730 CONDENABL;
          A,STS B,STS ALUF,ORDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,ORDQ
          IDBS,ARG T,NEXT T,HOLD
          1;
          A,R7 B,D ALUF,PASSQ ALUD,B,YA
          COMM,LDGPR T,JMP T,HOLD
          1011;

740/
L0740:
          B,R1 ALUF,D-1 ALUD,B
          IDBS,GPR,SEXT T,JMP8-10 T,PUSH
          3720;
          B,STS ALUF,INVD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,STS B,STS ALUF,ANDDA ALUD,B
          IDBS,STS T,NEXT T,HOLD;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3675;
          A,T B,R2 ALUF,A-B
          T,NEXT T,HOLD;
          A,R7 ALUF,MASKDQ
          IDBS,BMG T,NEXT T,HOLD;
          A,T B,R2 ALUF,XORAB ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          751 CONDENABL;
          A,R7 ALUF,ORDQ
          IDBS,BMG T,NEXT T,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F15 F,JMP F,HOLD;
          A,R6 ALUF,XORDQ
          IDBS,BMG T,NEXT T,HOLD
          1016 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,HOLD T,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          A,L B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,XORAQ ALUD,B
          T,JMP T,HOLD
          765 CONDENABL;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          765 CONDENABL;
          A,T B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          1016 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          626;
          B,T ALUF,PASSQ ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          16;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,D ALUF,PASSA
          COMM,CLFF T,NEXT T,HOLD
          626 CONDENABL;
          A,X ALUF,PASSD ALUD,NONE STS,LO
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,R4 ALUF,Q-A STS,EA
          T,NEXT T,HOLD;
          A,R3 B,A ALUF,B-A-1 ALUD,SLD STS,ES CRY,C
          T,NEXT T,NEXT MIS,APT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,R4 ALUF,Q-A STS,EA CRY,C ALUM,FDV
          T,NEXT T,HOLD;
          A,R3 B,A ALUF,B-A-1 ALUD,SLD STS,ES CRY,C ALUM,FDV
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          AB,DEPOS A,R5 B,R7 ALUF,PASSA ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          A,R4 ALUF,Q-A STS,EA CRY,C ALUM,FDV
          T,NEXT T,HOLD;
          A,R3 B,A ALUF,B-A-1 ALUD,SLD STS,ES CRY,C ALUM,FDV
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,R5 B,A ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,D ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          1013 CONDENABL;
          A,T ALUF,A+1
          T,JMP T,PUSH
          1027;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,DZD F,JMP F,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          1012 CONDENABL;
          A,D B,D ALUF,MASKDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          2;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,NEXT T,HOLD;
          A,STS ALUF,PASSA ALUD,NONE STS,LO
          T,JMP T,POP
          26;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,BARG T,JMP T,HOLD
          1011;
          A,D ALUF,PASSA
          T,NEXT T,HOLD;
          B,A ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD
          COND,DZD F,JMP F,HOLD;
          B,D ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          1005;
          A,X B,T ALUF,ORDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7777;
          B,A ALUF,INVA ALUD,B
          T,NEXT T,HOLD;
          B,D ALUF,INVA ALUD,B
          T,NEXT T,HOLD;
          B,STS ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,HOLD
          1011;
          A,T B,R2 ALUF,MASKAQ ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          B,T ALUF,PASSQ ALUD,B
          T,RETURN T,POP
          626 CONDENABL;
          B,R2 ALUF,INVQ ALUD,B
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          B,T ALUF,PASSQ ALUD,B
          T,RETURN T,POP
          0 CONDENABL;
          A,R7 ALUF,XORDQ
          IDBS,BMG T,JMP T,POP
          1016;

1037/
L1037:
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,D ALUF,ZERO ALUD,B
          T,NEXT T,HOLD
          1042 CONDENABL;
          B,T ALUF,ZERO ALUD,B
          T,JMP T,POP
          21;
          A,L ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD;
          B,T ALUF,D+Q ALUD,B
          IDBS,GPR,SEXT T,NEXT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R7 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          1050 CONDENABL;
          A,T B,T ALUF,D+A ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,A ALUF,-B ALUD,B
          T,NEXT T,HOLD;
          B,R4 ALUF,D-1 ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          21;
          B,A ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,POP LCOUNT;
          B,A ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          B,A ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          A,R4 B,LC ALUF,A-D-1
          IDBS,BARG T,NEXT T,HOLD;
          A,T B,T ALUF,A-Q ALUD,B
          T,JMP T,HOLD
          21;

1061/
L1061:
          A,T ALUF,D+A
          IDBS,GPR,SEXT T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R2 ALUF,D+Q ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          20;
          A,L B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD;
          A,R2 B,R6 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          A,R6 B,D ALUF,ANDDQ ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          1071 CONDENABL;
          B,T ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,A ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,D ALUF,ZERO ALUD,B
          T,JMP T,POP
          21;
          ALUF,PASSQ ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          505 CONDENABL;
          ALUD,NONE
          IDBS,DSABL T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          B,A ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,A ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          B,A ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,POP;
          B,T ALUF,ZERO ALUD,B
          T,NEXT T,HOLD
          21 CONDENABL;
          B,A ALUF,-B ALUD,B
          T,JMP T,POP
          21;

1106/
L1106:
          B,R1 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,PUSH CYCL,WAIT
          1115;
          ALUD,NONE
          T,JMP T,POP
          26;
          A,T B,R1 ALUF,PASSA ALUD,B
          COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,PUSH
          1117;
          ALUD,NONE
          T,JMP T,POP
          26;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          3777;
          A,R1 B,R1 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R1 B,X ALUF,MASKDA
          IDBS,BARG T,NEXT T,HOLD
          COND,OPCTT1 F,NEXT F,HOLD;
          ALUF,XORDQ ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          300;
          A,R1 B,B ALUF,MASKDA
          IDBS,BARG T,JMP T,HOLD
          1127 CONDENABL;
          B,STS ALUF,XORDQ ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,Z ALUF,PASSD
          IDBS,IOR T,JMP T,HOLD
          1130 CONDENABL;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IOX T,NEXT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,RETURN T,POP CYCL,WAIT;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP0-3 T,HOLD
          3640;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP0-3 T,HOLD
          3650;
          AB,STATUS A,R6 B,R7 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,SIOC T,RETURN T,POP CYCL,SLOW;
          A,R3 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,A ALUF,ANDDQ ALUD,B
          IDBS,ARG T,RETURN T,POP
          377 CONDENABL;
          ALUD,NONE
          COMM,RSDA T,RETURN T,POP CYCL,SLOW;
          A,A B,D ALUF,PASSA
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,PUSH;
          B,A ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          340;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R6 B,A ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,L B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          1146 CONDENABL;
          A,R6 B,A ALUF,ORAB ALUD,B
          T,NEXT T,HOLD;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R3 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          1153 CONDENABL;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1153 CONDENABL;
          A,B B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,R6 B,A ALUF,ORAB ALUD,B
          T,NEXT T,HOLD;
          A,D ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,Z B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,RETURN T,POP
          0 CONDENABL;
          A,R6 B,A ALUF,ORAB ALUD,B
          T,RETURN T,POP;
          A,R2 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,ORDA ALUD,B
          IDBS,BARG T,JMP T,HOLD
          1161 CONDENABL;
          AB,NUMBR A,R2 B,R2 ALUF,MASKDA ALUD,B
          IDBS,BARG T,NEXT T,HOLD;
          A,X B,R3 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          4002;
          AB,UPPNR A,R3 B,R2 ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          L0175;
          A,R2 ALUF,ORAQ
          T,JMP T,HOLD
          1131;
          A,Z ALUF,PASSD ALUD,NONE
          IDBS,IOR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          1170 CONDENABL;
          A,B B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,P ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,RETURN T,POP
          1155 CONDENABL;
          A,A B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P ALUF,ORDQ
          IDBS,BMG T,NEXT T,HOLD
          1131 CONDENABL;
          B,L ALUF,MASKDQ
          IDBS,BARG T,JMP T,HOLD
          1131;
          ALUF,PASSQ ALUD,NONE
          COMM,SIOC T,NEXT T,HOLD CYCL,SLOW;
          A,X ALUF,MASKDQ
          IDBS,BMG COMM,CLRTC T,JMP T,HOLD
          1132;
          A,A B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          AB,WRTYP A,R5 B,R2 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          1202 CONDENABL;
          B,D ALUF,MASKDQ
          IDBS,BARG T,NEXT T,HOLD;
          A,A B,R2 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1131 CONDENABL;
          B,STS ALUF,MASKDQ
          IDBS,BARG T,JMP T,HOLD
          1131;
L1205:
          A,T B,R1 ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,R1 B,R1 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          43;
          A,R1 B,R6 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD;
          A,R1 B,L ALUF,A-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          1232 CONDENABL;
          A,R1 B,R1 ALUF,A-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          1226 CONDENABL;
          A,Z ALUF,PASSD
          IDBS,IOR T,JMP T,HOLD
          1236 CONDENABL;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R3 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          1236 CONDENABL;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1236 CONDENABL;
          A,D ALUF,ANDDQ ALUD,NONE
          IDBS,BMG COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,COND F,NEXT F,HOLD;
          B,LC ALUF,MASKDQ
          IDBS,BARG T,JMP T,HOLD
          1236 CONDENABL;
          A,Z B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,SIOC T,NEXT T,HOLD CYCL,SLOW;
          AB,STATUS A,R6 B,R7 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,POP
          26;
          A,R7 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          A,Z ALUF,ANDDQ ALUD,NONE
          IDBS,IOR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1236 CONDENABL;
          A,P ALUF,ANDDQ ALUD,NONE
          IDBS,BMG COMM,LDLC T,JMP T,HOLD
          1221;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          11;
          A,R2 B,R1 ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD;
          A,Z ALUF,MASKDQ
          IDBS,BMG T,JMP T,HOLD
          1223 CONDENABL;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IDENT T,NEXT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26;
L1241:
          ALUF,PASSD
          IDBS,GPR T,JMP T,PUSH
          1253;
          B,T ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1257 CONDENABL;
          B,X ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1261 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1263 CONDENABL;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,POP CYCL,WAIT
          20;
L1246:
          ALUF,PASSD
          IDBS,GPR T,JMP T,PUSH
          1253;
          B,T ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1265 CONDENABL;
          B,X ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1266 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1270 CONDENABL;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,POP CYCL,WAIT
          20;
          B,R7 ALUF,ANDDQ
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,D ALUF,Q-D ALUD,NONE
          IDBS,BARG T,RETURN T,POP CYCL,SLOW;
          A,A ALUF,MASKAQ
          T,RETURN T,POP;
          A,A ALUF,ORAQ
          T,RETURN T,POP;
          ALUF,PASSD
          IDBS,STS T,NEXT T,HOLD;
          A,A ALUF,MASKAQ ALUD,NONE STS,LO
          T,JMP T,POP
          21;
          AB,PID A,R7 B,R4 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          1255;
          ALUD,NONE
          T,JMP T,POP
          3626;
          AB,PIE A,R7 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          1255;
          ALUD,NONE
          T,JMP T,POP
          3627;
          A,A ALUF,ORDA
          IDBS,STS T,JMP T,HOLD
          3621;
          AB,PID A,R7 B,R4 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          1256;
          ALUD,NONE
          T,JMP T,POP
          3626;
          AB,PIE A,R7 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          1256;
          ALUD,NONE
          T,JMP T,POP
          3627;
L1272:
          A,L ALUD,NONE
          IDBS,BMG COMM,SMPID T,NEXT T,POP;
          A,R6 B,T ALUD,NONE
          IDBS,GPR,SEXT COMM,EWRF T,RETURN T,HOLD;
L1274:
          B,P ALUF,B+1 ALUD,B
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          IDBS,DSABL T,JMP T,PUSH SLWCS CYCL,WAIT
          L7400;
L1276:
          ALUF,PASSD
          IDBS,STS T,JMP0-3 T,HOLD
          3560;
          PIC,IOF ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSQ ALUD,NONE
          COMM,LDPIL T,RETURN T,HOLD CYCL,SLOW;
          ALUF,PASSQ ALUD,NONE
          COMM,LDPIL T,NEXT T,HOLD CYCL,SLOW;
          PIC,ION ALUD,NONE
          COMM,EPIC T,JMP T,HOLD
          1465;
          A,A B,R7 ALUF,PASSA ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,PUSH CYCL,WAIT
          1311;
          A,D ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,NEXT T,HOLD;
          B,T ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          1315;
          A,A B,R7 ALUF,PASSA ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,PUSH CYCL,WAIT
          1311;
          A,D ALUF,PASSA ALUD,NONE
          COMM,DERQ T,NEXT T,HOLD;
          A,T ALUF,PASSA ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1315;
          ALUF,PASSQ ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,SLOW;
          ALUF,ZERO ALUD,NONE
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,XMM T,RETURN T,POP CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          121;
          AB,EXMOD A,R3 B,R1 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,POP CYCL,SLOW
          26;
L1317:
          ALUD,NONE
          T,JMP0-3 T,POP
          3600;
          PIC,RSTS B,R5 ALUF,PASSD ALUD,B
          IDBS,PIC COMM,EPIC T,NEXT T,HOLD
          COND,IRQ F,JMP F,HOLD;
          PIC,LOSTS B,STS ALUF,ZERO
          IDBS,BARG COMM,EPIC T,NEXT T,HOLD;
          PIC,ION B,R6 ALUF,INVD ALUD,B
          IDBS,BMG COMM,EPIC T,NEXT T,HOLD;
          AB,PRCHR B,R6 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD;
          AB,IIE A,R7 B,R2 ALUF,PASSD ALUD,B
          IDBS,REG COMM,CLIRQ T,NEXT T,HOLD;
          A,R7 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          1327 CONDENABL;
          A,R7 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          B,A ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          A,L B,R3 ALUF,INVD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          AB,OCTA2 B,R2 ALUF,INVB ALUD,NONE
          COMM,EPIC T,JMP T,PUSH
          1334;
          AB,TXT2 B,R3 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD
          1334 CONDENABL;
          ALUF,ORDQ
          IDBS,GPR T,NEXT T,HOLD;
          PIC,LOSTS B,STS ALUD,NONE
          IDBS,BARG COMM,EPIC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSB ALUD,SRB ALUM,FMU
          COMM,CLIRQ T,NEXT T,POP LCOUNT
          COND,IRQ F,JMP F,HOLD;
          AB,PID A,R7 B,R4 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD;
          PIC,LOSTS B,R5 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD;
          ALUF,PASSD ALUD,NONE
          IDBS,STS T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          AB,OPR B,R1 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,JMP T,HOLD
          1362 CONDENABL;
          PIC,IOF ALUD,NONE
          COMM,EPIC T,JMP T,HOLD
          1362;
          PIC,RMSK B,R6 ALUF,PASSD ALUD,B
          IDBS,DSABL COMM,EPIC T,NEXT T,HOLD;
          AB,IIE A,R7 B,R2 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,B ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          7760;
          PIC,LMSK ALUF,INVQ ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          25;
          AB,PIE B,R3 ALUF,PASSD ALUD,B
          IDBS,BARG COMM,EPIC T,NEXT T,PUSH
          COND,F=0 F,NEXT F,HOLD;
          PIC,LOSTS ALUF,PASSQ ALUD,NONE
          COMM,EPIC T,JMP T,POP
          1355 CONDENABL;
          A,R3 ALUF,A-Q ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          ALUF,Q-1
          COMM,CLIRQ T,NEXT T,POP
          COND,IRQ F,NEXT F,HOLD CONDENABL;
          ALUF,ZERO
          T,JMP T,HOLD
          1357;
          ALUF,Q-D
          IDBS,ARG T,NEXT T,HOLD
          12;
          A,R6 ALUD,NONE
          IDBS,BMG COMM,SMPID T,NEXT T,HOLD;
          PIC,LOSTS B,R5 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,JMP T,PUSH
          1527;
          ALUF,PASSD ALUD,NONE
          IDBS,STS T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,PRCHR B,R6 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD
          1342 CONDENABL;
          B,A ALUF,PASSQ ALUD,B
          T,RETURN T,HOLD;
          A,R5 B,A ALUF,ORDQ ALUD,B
          IDBS,ARG T,RETURN T,HOLD
          3602;
          ALUD,NONE
          T,JMPALD T,PUSH
          3520;
          B,A ALUF,PASSQ ALUD,B
          T,RETURN T,HOLD;
          B,Z ALUF,D-1
          IDBS,BARG T,JMP T,HOLD
          1376;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,STS T,JMP T,PUSH
          1402;
          ALUF,PASSD
          IDBS,MMR T,NEXT T,HOLD CYCL,SLOW;
          A,R7 B,A ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7773;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,LDPIL T,JMP T,HOLD CYCL,SLOW
          1442;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,STS T,JMP T,PUSH
          1402;
          A,A ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          1372;
          A,R6 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          1777;
          ALUD,NONE
          IDBS,GPR COMM,LDIR T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          T,NEXT T,HOLD;
          B,A ALUF,ANDDQ ALUD,B
          IDBS,MMR T,JMP T,HOLD CYCL,SLOW
          1442;
          B,X ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1376;
          B,P ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          A,A B,R5 ALUF,PASSA ALUD,SLB
          IDBS,GPR COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          COND,LC=0 F,JMP F,HOLD;
          B,R5 ALUF,PASSB ALUD,SLB
          T,NEXT T,POP LCOUNT;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDPIL T,RETURN T,POP CYCL,SLOW;
L1406:
          B,A ALUF,PASSB
          T,JMP0-3 T,POP
          3620;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          7774;
          A,D B,R1 ALUF,ORDQ ALUD,SLB
          IDBS,ARG T,NEXT T,HOLD;
          PIC,RMSK B,R2 ALUF,INVD ALUD,B
          IDBS,DSABL COMM,EPIC T,NEXT T,HOLD;
          AB,PIE A,R7 B,R3 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R1 ALUF,A+B
          T,JMP T,HOLD
          1421 CONDENABL;
          A,STS B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          AB,OCTA2 A,R6 B,R2 ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,ORAQ ALUD,B
          T,NEXT T,HOLD;
          AB,OCTA2 B,R2 ALUF,INVB ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD;
          AB,IIE A,R7 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,RETURN T,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,JMP T,PUSH
          1531;
          B,STS ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,STS B,R1 ALUF,ANDDA ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,STS ALUF,PASSA
          T,NEXT T,HOLD;
          AB,IIE A,R7 B,R2 ALUF,ANDDQ
          IDBS,REG T,NEXT T,HOLD;
          A,R1 B,R1 ALUF,ORAQ ALUD,B
          T,NEXT T,HOLD;
          AB,OPR B,R1 ALUF,INVB ALUD,NONE
          COMM,EPIC T,JMP T,HOLD
          1465;
          ALUF,PASSD
          IDBS,SWAP T,JMP T,PUSH
          1531;
          A,R4 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          17;
          B,R1 ALUF,MASKAQ ALUD,B
          T,JMP T,PUSH
          1530;
          ALUF,ANDAQ ALUD,NONE
          COMM,SMPID T,JMP T,HOLD
          1465;
          AB,LMP A,R4 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,RETURN T,HOLD;
          ALUD,NONE
          IDBS,GPR COMM,LDIR T,NEXT T,HOLD CYCL,SLOW;
          A,A ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          1442;
          A,STS B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          115;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,PUSH CYCL,WAIT
          1117;
          A,P ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,RETURN T,HOLD;
          ALUD,NONE
          IDBS,GPR COMM,LDIR T,NEXT T,HOLD CYCL,SLOW;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,SWAP COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,SWAP COMM,XMM T,JMP T,HOLD CYCL,SLOW
          1442;
L1447:
          ALUF,PASSD ALUD,NONE
          IDBS,STS T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD CYCL,WAIT
          1706 CONDENABL;
          B,R7 ALUF,ANDDQ
          IDBS,BARG T,NEXT T,HOLD;
          B,R1 ALUF,PASSQ ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,LC ALUF,MASKDQ
          IDBS,BMG T,NEXT T,HOLD;
          A,R1 B,R6 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          1474 CONDENABL;
          A,R1 B,R2 ALUF,A-D
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          1465 CONDENABL;
          B,L ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,LC ALUF,PASSD
          IDBS,BMG T,JMP T,HOLD
          1464 CONDENABL;
          A,R7 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          PIC,MCLPID ALUF,PASSQ ALUD,NONE
          COMM,EPIC T,NEXT T,HOLD;
          PIC,LOSTS B,STS ALUD,NONE
          IDBS,BARG COMM,EPIC T,NEXT T,HOLD
          COND,IRQ F,NEXT F,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSD
          IDBS,REG COMM,CLIRQ T,NEXT T,HOLD;
          ALUF,PASSD ALUD,NONE
          IDBS,STS T,RETURN T,HOLD
          COND,F15 F,RETURN F,HOLD CONDENABL;
          AB,PIE A,R7 B,R3 ALUF,ANDDQ ALUD,SLB
          IDBS,REG T,NEXT T,HOLD
          COND,F11 F,JMP F,HOLD CONDENABL;
          A,STS ALUF,PASSD
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          13;
          B,R3 ALUF,PASSB ALUD,SLD
          T,NEXT T,POP LCOUNT;
          B,LC ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1502;
          A,L ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD;
          PIC,MCLPID ALUF,PASSQ ALUD,NONE
          COMM,EPIC T,JMP T,HOLD
          1465;
          B,P ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0027;
          A,R6 ALUD,NONE
          IDBS,BMG COMM,SMPID T,NEXT T,HOLD;
          PIC,LOSTS ALUD,NONE
          IDBS,GPR COMM,EPIC T,JMP T,HOLD
          1502;
          B,P ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,SWAP T,JMP T,HOLD
          1507 CONDENABL;
          A,LC ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          AB,PID A,R7 B,R4 ALUF,ORDQ ALUD,B
          IDBS,REG T,NEXT T,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,PIL ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          A,LC ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,R4 ALUF,ANDDQ ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          0 CONDENABL;
          A,LC ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          A,PIL B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          1515 CONDENABL;
          AB,PVL A,R7 B,R5 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,ACTLV A,R4 B,R7 ALUF,ORDQ ALUD,B
          IDBS,REG T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          7;
          ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,PIL B,LC ALUF,PASSB
          COMM,EWRF T,NEXT T,POP LCOUNT;
          A,R7 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT;
          B,R6 ALUF,ORAB ALUD,NONE
          COMM,LDPIL T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          7;
          AB,ACTLV A,R4 B,R7 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,PUSH;
          A,PIL B,LC ALUF,PASSD ALUD,B
          IDBS,REG T,NEXT T,POP LCOUNT;
          ALUF,PASSA ALUD,NONE STS,LO
          T,JMP T,HOLD
          20;
          A,B B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7760;
          PIC,MCLPID B,R1 ALUF,PASSB ALUD,NONE
          COMM,EPIC T,RETURN T,POP;
          ALUF,ANDDQ ALUD,SRB
          IDBS,ARG T,NEXT T,HOLD
          74;
          A,X ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,T ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          1535 CONDENABL;
          A,Z ALUF,ORDA ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          COND,COND F,NEXT F,HOLD;
          ALUF,PASSB ALUD,SRB
          T,RETURN T,RETURN MIS,PT T,POP
          0 CONDENABL;
          A,X ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7760;
          ALUF,ORAQ ALUD,B
          T,RETURN T,POP;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          AB,EXMOD A,R3 B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          B,R5 ALUD,NONE
          IDBS,BARG COMM,XMM T,RETURN T,POP CYCL,SLOW;
          A,B ALUF,PASSD
          IDBS,ARG COMM,SIOC T,NEXT T,HOLD CYCL,SLOW
          120;
          ALUF,PASSD
          IDBS,STS COMM,SSTOP T,JMP T,PUSH
          3565;
          ALUF,ZERO
          COMM,RSDA T,JMP T,PUSH CYCL,SLOW
          1407;
          PIC,LOSTS B,STS ALUF,ZERO
          IDBS,BARG COMM,EPIC T,JMP T,PUSH
          3627;
          A,R7 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          AB,RONLY A,R5 B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CDIGI A,R7 B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,PRCHR A,R6 B,R6 ALUD,NONE
          IDBS,ARG COMM,EWRF T,NEXT T,HOLD
          443;
          PIC,LMSK ALUF,PASSQ ALUD,NONE
          COMM,EPIC T,NEXT T,NEXT T,MAPJ T,HOLD;
          AB,DISPL A,R6 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTAD A,R5 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTA2 A,R6 B,R2 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          1677;
          AB,BPFLG A,R4 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,STS T,JMP T,PUSH
          3567;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUF,ZERO
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          1540;
          ALUF,PASSQ ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          1564;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,PUSH
          400;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,R1 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,R1 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,PUSH
          1667 CONDENABL;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          1000;
          ALUF,ZERO
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          3;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          ALUF,Q+1
          T,NEXT T,POP LCOUNT;
          B,A ALUF,D-Q ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,PUSH
          1667 CONDENABL;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          1400;
          B,B ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          A,X ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          707;
          A,B B,R3 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,PUSH
          L0303;
          B,R3 ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,PT T,POP LCOUNT;
          A,B ALUF,Q-D
          IDBS,ARG T,NEXT T,HOLD
          4346;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSB
          T,NEXT T,HOLD
          1667 CONDENABL;
          A,D ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          4156;
          ALUD,NONE
          T,NEXT T,PUSH
          1666 CONDENABL;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          2400;
          AB,PVL A,R7 B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7777;
          B,Z ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R5 ALUF,B+1 ALUD,NONE
          T,NEXT T,HOLD
          1667 CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH
          1666 CONDENABL;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          3400;
          A,R7 ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,X ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          4000;
          ALUD,NONE
          T,NEXT T,PUSH
          1667 CONDENABL;
          B,R2 ALUF,B+1 ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          4000;
          B,R1 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          17;
          A,STS ALUF,PASSD
          IDBS,ARG COMM,LDGPR T,NEXT T,PUSH;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,LC ALUF,Q-D ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          ALUF,Q-D ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          1667 CONDENABL;
          B,R1 ALUF,PASSB ALUD,SRD ALUM,FMU
          T,NEXT T,HOLD
          1666 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          ALUD,NONE
          IDBS,PEA T,NEXT T,HOLD LCOUNT;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,STS T,NEXT T,LOAD;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          5000;
          A,R7 B,STS ALUD,NONE
          IDBS,ARG COMM,EWRF T,NEXT T,HOLD
          7777;
          ALUF,ZERO ALUD,NONE STS,LO
          COMM,LDPIL T,JMP T,PUSH CYCL,SLOW
          1664;
          ALUF,PASSD
          IDBS,STS T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD;
          A,R7 B,STS ALUF,D+1 ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          1667 CONDENABL;
          A,R7 B,STS ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          1666 CONDENABL;
          A,R7 B,STS ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          T,NEXT T,HOLD
          1665 CONDENABL;
          A,R7 ALUF,PASSA ALUD,NONE STS,LO
          COMM,LDPIL T,NEXT T,HOLD CYCL,SLOW;
          A,A B,R7 ALUF,PASSA ALUD,B
          T,NEXT T,PUSH;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          6400;
          ALUD,NONE
          T,JMP T,PUSH
          3606;
          A,R7 B,STS ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,ZERO
          T,JMP T,LOAD
          3626;
          A,R4 ALUD,NONE
          IDBS,ARG COMM,SMPID T,NEXT T,HOLD
          17;
          ALUD,NONE
          T,JMP T,PUSH
          3606;
          A,R7 ALUF,D-Q
          IDBS,ARG T,NEXT T,POP
          6000;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R7 B,STS ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          1667 CONDENABL;
          B,R6 ALUF,ZERO ALUD,B
          T,JMP T,PUSH
          3626;
          A,R7 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          1671;
          A,R7 ALUD,NONE
          IDBS,ARG T,RETURN T,POP
          7777;
          AB,NUMBR A,R2 B,R2 ALUF,A+B ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          400;
          AB,NUMBR A,R2 B,R2 ALUF,A+B ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          400;
          B,R2 ALUF,PASSB
          T,JMP T,PUSH
          2237;
          ALUF,PASSQ ALUD,NONE
          COMM,LDPIL T,RETURN T,HOLD;
          A,B ALUF,PASSD
          IDBS,ARG COMM,SIOC T,NEXT T,HOLD CYCL,SLOW
          L0140;
          AB,STATUS A,R6 B,R7 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,MANIR A,R3 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,TXT1 A,R6 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,TXT2 A,R6 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,SINGL A,R4 B,R4 ALUF,ZERO
          COMM,EWRF T,JMP T,HOLD
          1515;
          AB,DUMPF A,R5 B,R6 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,SCRAM A,R4 B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,UPPNR A,R3 B,R2 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTN2 A,R3 B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,DEPOS A,R5 B,R7 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,RETURN T,POP;
          AB,PRCHR A,R6 B,R6 ALUD,NONE
          IDBS,ARG COMM,EWRF T,NEXT T,HOLD
          443;
          AB,MACL A,R4 B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          A,Z ALUF,PASSD
          IDBS,IOR T,JMP T,HOLD
          3545 CONDENABL;
          A,R5 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          AB,MACL A,R4 B,R1 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          3545 CONDENABL;
          ALUD,NONE
          T,JMPALD T,PUSH
          3520;
          A,R7 ALUF,MASKDQ
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R5 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          20 CONDENABL;
          A,X B,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          1755 CONDENABL;
          A,D B,D ALUF,D+Q ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          B,A ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,D B,R1 ALUF,A-1 ALUD,B
          T,JMP T,PUSH
          1115;
          A,D B,R1 ALUF,A-1 ALUD,B
          T,JMP T,PUSH
          1115;
          A,D B,R1 ALUF,A+1 ALUD,B
          T,JMP T,PUSH
          1115;
          A,D B,R1 ALUF,D+A ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          5;
          A,R2 B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          1115;
          A,D B,R1 ALUF,D+A+1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,P B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          1115;
          A,D B,R1 ALUF,D+A ALUD,B
          IDBS,BMG T,JMP T,PUSH
          1115;
          A,A B,L ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,R7 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          1730 CONDENABL;
          A,A B,R7 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          1720 CONDENABL;
          B,P ALUF,ZERO ALUD,B
          COMM,START T,JMP T,HOLD
          2303;
          A,Z ALUF,PASSD
          IDBS,IOR COMM,CLRTC T,NEXT T,HOLD
          COND,STP F,RETURN F,POP;
          A,R5 ALUF,ANDDQ
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD CONDENABL;
          AB,MACL A,R4 B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          1745 CONDENABL;
          AB,MACL A,R4 B,R1 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMPALD T,PUSH
          3520;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1714 CONDENABL;
          A,P B,P ALUF,PASSD ALUD,B
          IDBS,AARG T,JMP T,HOLD
          1751;
          AB,MACL A,R4 B,R1 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          20 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1744;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,STP F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1713 CONDENABL;
          ALUD,NONE
          COMM,START T,JMP T,HOLD
          2303;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1713 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1714;
          B,D ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          2010;
          A,R5 B,P ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,A B,L ALUF,D+1 ALUD,B
          IDBS,BMG T,JMP T,PUSH
          2012;
          A,R2 B,R5 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R2 B,L ALUF,A-B ALUD,NONE
          T,JMP T,HOLD
          1756 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1764 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1757;
          A,STS B,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          B,L ALUF,ZERO ALUD,B
          T,JMP T,PUSH
          2022;
          B,X ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          2022;
          B,T ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          2022;
          B,T ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,X B,X ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,PT T,HOLD
          COND,COND F,JMP F,HOLD;
          B,L ALUF,A+B ALUD,B,YA
          T,NEXT T,HOLD CYCL,WAIT
          1770 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          2022;
          B,L ALUF,XORAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2162 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          2012;
          A,R2 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2303 CONDENABL;
          ALUD,NONE
          COMM,START T,JMP T,HOLD
          2303;
          A,D B,R1 ALUF,D+A ALUD,B
          IDBS,BMG T,JMP T,PUSH
          1115;
          A,A B,STS ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          2003 CONDENABL;
          A,D B,R1 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          1115;
          A,A B,STS ALUF,ANDAB ALUD,NONE
          COMM,LDGPR T,JMP T,HOLD
          2010;
          B,A ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          4005;
          A,D B,R1 ALUF,D+A+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          1115;
          AB,OCTNR A,R5 B,R5 ALUF,ZERO ALUD,B
          COMM,EWRF T,JMP T,HOLD
          2014;
          ALUD,NONE
          T,JMP T,PUSH
          2267;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD ALUD,B
          IDBS,REG T,JMP T,PUSH
          2003;
          A,STS B,R2 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          60;
          A,R2 B,R3 ALUF,A-Q ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,STS ALUF,A-D ALUD,NONE
          IDBS,BARG T,RETURN T,POP
          COND,F15 F,RETURN F,POP CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2013 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          2003;
          ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,PASSD ALUD,B
          IDBS,SWAP T,JMP T,PUSH
          2003;
          ALUF,ORDA ALUD,B
          IDBS,GPR T,RETURN T,POP;
          B,STS ALUF,PASSD
          IDBS,BARG COMM,CLRTC T,NEXT T,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,ORDQ
          IDBS,REG T,JMP T,PUSH
          1131;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          40;
          ALUF,PASSD ALUD,NONE
          IDBS,MMR T,NEXT T,HOLD CYCL,SLOW
          COND,F15 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2036 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          20;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          40;
          ALUD,NONE
          IDBS,MMR T,NEXT T,HOLD CYCL,SLOW;
          AB,PRCHR A,R6 B,R6 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          A,Z ALUF,PASSD
          IDBS,IOR T,JMP T,HOLD
          2117 CONDENABL;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R7 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          2043 CONDENABL;
          ALUD,NONE
          COMM,RSDA T,JMP T,HOLD CYCL,SLOW
          2305;
          ALUD,NONE
          T,JMP T,HOLD
          20 CONDENABL;
          AB,PRCHR A,R6 B,R6 ALUF,PASSD
          IDBS,REG COMM,TBSTR T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUF,D-Q ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          43;
          B,R2 ALUF,D-Q ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          2417 CONDENABL;
          AB,PRCHR A,R6 B,R6 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2313 CONDENABL;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          2064 CONDENABL;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,CDIGI A,R7 B,R1 ALUF,Q-1 ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2063 CONDENABL;
          AB,NUMBR A,R2 B,R2 ALUF,PASSD ALUD,SLB
          IDBS,REG T,NEXT T,NEXT MIS,PT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,PASSB
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          7;
          ALUF,D+Q
          IDBS,ARG T,NEXT T,HOLD
          60;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2036;
          A,A ALUF,PASSD
          IDBS,BMG T,JMP T,HOLD
          2062;
          AB,DUMPF A,R5 B,R6 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2036 CONDENABL;
          B,P ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,R2 ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          2071 CONDENABL;
          AB,CURNR A,R3 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD CYCL,SLOW
          2075 CONDENABL;
          AB,CNT10 A,R7 B,R7 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,PUSH
          2105;
          AB,CURNR A,R3 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          2241;
          AB,CNT10 A,R7 B,R7 ALUF,D+1
          IDBS,REG T,JMP T,HOLD
          2104;
          AB,UPPNR A,R3 B,R2 ALUF,Q-D ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,PRCHR A,R6 B,R6 ALUF,ZERO ALUD,NONE
          T,JMP T,HOLD
          2306 CONDENABL;
          AB,SCRAM A,R4 B,R5 ALUD,NONE
          IDBS,REG COMM,LDLC T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          2171;
          AB,CURNR A,R3 B,R3 ALUF,D+1 ALUD,B
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW;
          AB,CURNR A,R3 B,R3 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          2241;
          AB,CNT10 A,R7 B,R7 ALUF,D+1
          IDBS,REG T,NEXT T,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2036;
          B,D ALUF,D-Q ALUD,NONE
          IDBS,BARG T,RETURN T,POP CYCL,SLOW
          2111 CONDENABL;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          L0057;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,D+1
          IDBS,REG T,JMP T,HOLD
          2104;
          B,R2 ALUF,D-Q ALUD,NONE
          IDBS,BARG T,RETURN T,POP CYCL,SLOW
          2113 CONDENABL;
          B,R5 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2107;
          ALUD,NONE
          T,RETURN T,POP
          2114 CONDENABL;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          412;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2036;
          A,R3 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,PUSH
          2164;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,T ALUF,MASKDQ
          IDBS,BMG T,JMP T,PUSH
          1131;
          A,Z ALUF,PASSD
          IDBS,IOR T,NEXT T,HOLD;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          2166 CONDENABL;
          ALUF,ANDDQ
          IDBS,ARG COMM,RSDA T,NEXT T,HOLD
          L0177;
          B,R2 ALUF,PASSQ ALUD,B
          COMM,TBSTR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R5 ALUF,Q-D ALUD,NONE
          IDBS,BARG T,JMP T,PUSH CYCL,SLOW
          2132;
          B,R2 ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          20;
          ALUD,NONE
          T,RETURN T,POP
          COND,F15 F,NEXT F,POP CONDENABL;
          B,R1 ALUF,Q-D ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          60;
          A,R1 B,STS ALUF,A-D ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          2136 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2301 CONDENABL;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          L0101;
          B,R5 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          2142 CONDENABL;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          L0132;
          ALUD,NONE
          T,JMP T,HOLD
          2314 CONDENABL;
          A,T ALUF,Q-D
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,L ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2306 CONDENABL;
          B,R5 ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2410 CONDENABL;
          B,A ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2553 CONDENABL;
          B,R7 ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2415 CONDENABL;
          B,A ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2303 CONDENABL;
          A,X B,R1 ALUF,Q-D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          2306 CONDENABL;
          B,R1 ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          2250;
          B,D ALUF,Q-D
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          B,R1 ALUF,PASSB ALUD,NONE
          T,JMP T,HOLD CYCL,SLOW
          2321 CONDENABL;
          B,D ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2373 CONDENABL;
          B,D ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2363 CONDENABL;
          B,D ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2326 CONDENABL;
          B,P ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1752 CONDENABL;
          B,STS ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          1752 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          3554 CONDENABL;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          L0077;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2305;
          ALUD,NONE
          T,RETURN T,POP
          COND,STP F,NEXT F,HOLD CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2120 CONDENABL;
          AB,DISPL A,R6 B,R5 ALUD,NONE
          IDBS,REG COMM,LDLC T,NEXT T,HOLD;
          AB,OCTAD A,R5 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          2171;
          ALUD,NONE
          T,JMP T,HOLD
          20;
          A,LC ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMPAOPR T,HOLD
          3540;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          AB,OCTA2 A,R6 B,R2 ALUF,PASSD ALUD,B
          IDBS,REG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,STS ALUD,NONE
          IDBS,BARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          AB,OCTA2 A,R6 B,R2 ALUF,PASSB ALUD,NONE
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          2235;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          2235;
          ALUF,PASSQ ALUD,NONE
          COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          2207;
          A,A ALUF,PASSA
          T,NEXT T,POP;
          A,R7 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          2232;
          ALUD,NONE
          T,JMP T,PUSH
          L0373;
          ALUF,PASSQ ALUD,NONE
          COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,REG B,LC ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2232;
          ALUF,PASSQ ALUD,NONE
          COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          2220;
          A,A ALUF,PASSA
          T,JMP T,POP CYCL,WAIT
          2206;
          ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          L1317;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          23;
          AB,OCTA2 A,R6 B,R2 ALUF,PASSD ALUD,B
          IDBS,MMR T,NEXT T,HOLD CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          22;
          ALUF,PASSD
          IDBS,MMR T,NEXT T,HOLD CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R3 ALUD,NONE
          IDBS,BARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          AB,OCTA2 A,R6 B,R2 ALUF,PASSB ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2235;
          AB,ACTLV A,PIL B,R7 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          AB,ACTLV A,R4 B,R7 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2237;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R1 ALUD,NONE
          IDBS,BARG COMM,XMM T,JMP T,PUSH CYCL,SLOW
          2235;
          A,P ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2236;
          ALUF,PASSQ ALUD,NONE
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,SWAP COMM,XMM T,RETURN T,POP CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R2 ALUD,NONE
          IDBS,BARG COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2235;
          AB,NUMBR A,R2 B,R2 ALUF,PASSQ ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,PASSB
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          1;
          ALUF,D+Q
          IDBS,ARG T,NEXT T,HOLD
          60;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          5;
          AB,CDIGI A,R7 B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,RETURN T,POP;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2162 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,STP F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,POP
          2162 CONDENABL;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R6 ALUD,NONE
          IDBS,BARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          AB,TXT1 A,R6 B,R4 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,PUSH CYCL,SLOW
          2236;
          AB,TXT2 A,R6 B,R3 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2236;
          AB,TXT1 A,R6 B,R4 ALUF,PASSD ALUD,B
          IDBS,REG T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,T ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          AB,TXT2 A,R6 B,R3 ALUF,PASSD
          IDBS,REG T,NEXT T,PUSH;
          AB,TXT1 A,R6 B,R4 ALUF,PASSB ALUD,SLD
          T,NEXT T,POP LCOUNT;
          A,R2 ALUF,ORAQ
          T,NEXT T,HOLD;
          AB,TXT1 A,R6 B,R4 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,TXT2 A,R6 B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,RETURN T,POP;
          AB,OCTN2 A,R3 B,R5 ALUF,PASSD ALUD,B
          IDBS,REG T,JMP T,PUSH
          2260;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          B,R5 ALUF,PASSB ALUD,SLD
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          7;
          AB,NUMBR A,R2 B,R2 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,R2 ALUF,ORAQ
          T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTN2 A,R3 B,R5 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,DEPOS A,R5 B,R7 ALUD,NONE
          IDBS,ARG COMM,EWRF T,RETURN T,POP;
          ALUD,NONE
          T,JMP T,PUSH
          2267;
          ALUD,NONE
          T,JMP T,HOLD
          20;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,T ALUF,ORDQ
          IDBS,BMG T,JMP T,PUSH
          1131;
          AB,RONLY A,R5 B,R4 ALUD,NONE
          IDBS,ARG COMM,EWRF T,JMP T,HOLD
          2306;
          AB,MANIR A,R3 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,BPFLG A,R4 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,SINGL A,R4 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,TXT1 A,R6 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          1677;
          AB,TXT2 A,R6 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          20;
          AB,PRCHR A,R6 B,R6 ALUD,NONE
          IDBS,GPR COMM,EWRF T,JMP T,HOLD
          20;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD ALUD,SLB
          IDBS,REG T,JMP T,PUSH
          2260;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          L0037;
          AB,NUMBR A,R2 B,R2 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R2 B,R5 ALUF,A+B ALUD,B
          T,NEXT T,HOLD;
          AB,SCRAM A,R4 B,R5 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          20;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2162 CONDENABL;
          AB,DEPOS A,R5 B,R7 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          COMM,START T,JMP T,HOLD
          2303 CONDENABL;
          B,P ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          2303;
          A,R5 B,A ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          AB,OCTNR A,R5 B,R5 ALUD,NONE
          IDBS,REG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          B,D ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,Z B,T ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          B,R2 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,B B,P ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,P B,L ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R2 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          2340 CONDENABL;
          A,T B,L ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          COND,COND F,JMP F,HOLD;
          A,D B,L ALUF,XORAB ALUD,B
          T,NEXT T,HOLD
          2343 CONDENABL;
          A,P B,P ALUF,B+1 ALUD,B,YA
          COMM,DERQ T,NEXT T,HOLD;
          A,L ALUF,PASSA ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          2346;
          A,P B,P ALUF,B+1 ALUD,B,YA
          COMM,IRDRQ T,NEXT T,HOLD;
          A,L ALUF,XORDA ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2357 CONDENABL;
          A,P B,X ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R2 ALUF,INVB ALUD,NONE
          T,NEXT T,HOLD
          2334 CONDENABL;
          B,R2 ALUF,INVB ALUD,B
          T,NEXT T,HOLD
          2333 CONDENABL;
          A,T B,T ALUF,A+B ALUD,B
          T,NEXT T,HOLD;
          B,D ALUF,INVB ALUD,NONE
          T,NEXT T,HOLD
          2332 CONDENABL;
          B,D ALUF,INVB ALUD,B
          T,NEXT T,HOLD
          2331 CONDENABL;
          B,A ALUF,INVB ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          443;
          ALUD,NONE
          T,NEXT T,HOLD
          2330 CONDENABL;
          AB,PRCHR A,R6 B,R6 ALUD,NONE
          IDBS,GPR COMM,EWRF T,JMP T,HOLD
          2305;
          B,D ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,P ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,L B,D ALUF,XORAB
          T,NEXT T,HOLD;
          B,T ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          2162;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          AB,BRKPT A,R4 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,MANIR A,R3 B,R4 ALUD,NONE
          IDBS,ARG COMM,EWRF T,JMP T,HOLD
          2311;
          AB,MANIR A,R3 B,R4 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,BRKPT A,R4 B,R6 ALUD,NONE
          IDBS,REG COMM,LDGPR T,JMP T,HOLD
          20 CONDENABL;
          ALUD,NONE
          COMM,CLIRQ T,JMP T,PUSH
          2372;
          ALUD,NONE
          T,MAPJ T,HOLD
          16;
          ALUD,NONE
          IDBS,GPR COMM,CLIRQ T,MAPJ T,HOLD
          16;
          AB,BPFLG A,R4 B,R3 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2162 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          2404 CONDENABL;
          A,P B,P ALUF,A+1 ALUD,B,YA
          COMM,RDRQ T,JMP T,PUSH
          2400;
          A,A B,P ALUF,B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,MAPJ T,HOLD CYCL,WAIT
          16;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          COMM,START T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,A ALUD,NONE
          IDBS,GPR COMM,SSTOP T,MAPJ T,HOLD
          16;
          AB,SINGL A,R4 B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2311;
          ALUD,NONE
          T,NEXT T,HOLD
          COND,STP F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          2376 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          20;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          2162 CONDENABL;
          AB,CURNR A,R3 B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,DUMPF A,R5 B,R6 ALUD,NONE
          IDBS,BARG COMM,EWRF T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          20;
          AB,OCTAD A,R5 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          2241;
          ALUD,NONE
          T,JMP T,HOLD
          2306;
          AB,PRCHR A,R6 B,R6 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,DUMPF A,R5 B,R6 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2526 CONDENABL;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD CYCL,SLOW
          114;
          B,Z ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          2432 CONDENABL;
          B,B ALUF,PASSD
          IDBS,BARG T,JMP T,PUSH
          2252;
          AB,DUMPF A,R5 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,SCRAM A,R4 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          20;
          AB,UPPNR A,R3 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2540;
          B,A ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW;
          B,T ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          2442 CONDENABL;
          AB,DEPOS A,R5 B,R7 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2437 CONDENABL;
          A,P ALUF,ORDQ
          IDBS,BMG T,NEXT T,HOLD;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUF,PASSQ ALUD,NONE
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          1540;
          ALUF,PASSQ ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2305;
          ALUD,NONE
          T,NEXT T,HOLD
          2447 CONDENABL;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          AB,OCTNR A,R5 B,R5 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,PUSH CYCL,SLOW
          2236;
          ALUD,NONE
          T,JMP T,HOLD
          2305;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD CYCL,SLOW
          L0176;
          ALUD,NONE
          T,NEXT T,HOLD
          2452 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          1543;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD CYCL,SLOW
          L0426;
          ALUD,NONE
          T,NEXT T,HOLD
          2455 CONDENABL;
          ALUD,NONE
          COMM,SSTOP T,JMP T,HOLD
          2305;
          AB,DEPOS A,R5 B,R7 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          T,NEXT T,HOLD CYCL,SLOW
          2465 CONDENABL;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW;
          AB,DISPL A,R6 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2162 CONDENABL;
          AB,OCTAD A,R5 B,R3 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          2305 CONDENABL;
          AB,OCTAD A,R5 B,R3 ALUF,Q+1
          COMM,EWRF T,JMP T,PUSH
          2171;
          ALUD,NONE
          T,JMP T,PUSH
          2241;
          ALUD,NONE
          T,JMP T,HOLD
          2306;
          ALUF,D-Q ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD CYCL,SLOW
          52;
          ALUD,NONE
          T,NEXT T,HOLD
          2250 CONDENABL;
          AB,RONLY A,R5 B,R4 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,HOLD;
          AB,WRTYP A,R5 B,R2 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          2162 CONDENABL;
          B,D ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          2477 CONDENABL;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          AB,OCTA2 A,R6 B,R2 ALUD,NONE
          IDBS,REG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          AB,OCTAD A,R5 B,R3 ALUF,PASSD
          IDBS,REG COMM,DERQ T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          2462;
          B,P ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          2511 CONDENABL;
          AB,WRADR A,R5 B,R1 ALUF,PASSD
          IDBS,REG COMM,CLIRQ T,MAPJ T,PUSH
          350;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD
          2504 CONDENABL;
          B,DEST ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          2506;
          ALUF,PASSQ ALUD,NONE STS,LO
          T,JMP T,HOLD
          2305;
          A,REG B,DEST ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          2506;
          A,REG B,Z ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2305;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          377;
          B,DEST ALUF,PASSD ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,RETURN T,POP
          2305 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD CYCL,SLOW
          2520 CONDENABL;
          AB,WRADR A,R5 B,R1 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,B B,R6 ALUF,ORDQ ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD CYCL,SLOW;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,REG B,LC ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2305;
          A,A B,R7 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          2522;
          A,R7 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          2305;
          AB,WRADR A,R5 B,R1 ALUF,PASSD
          IDBS,REG COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD CYCL,SLOW;
          ALUF,PASSQ ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          L1406;
          A,A ALUF,Q-D ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD CYCL,SLOW
          2531 CONDENABL;
          AB,OCTNR A,R5 B,R5 ALUF,D+1
          IDBS,REG T,NEXT T,HOLD;
          AB,UPPNR A,R3 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2540;
          ALUD,NONE
          T,NEXT T,HOLD
          2534 CONDENABL;
          AB,OCTNR A,R5 B,R5 ALUF,D+1 ALUD,B
          IDBS,REG T,JMP T,PUSH CYCL,SLOW
          2543;
          AB,SCRAM A,R4 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2540;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD CYCL,SLOW
          L0125;
          ALUD,NONE
          T,NEXT T,HOLD
          2162 CONDENABL;
          AB,OCTNR A,R5 B,R5 ALUF,D+1 ALUD,B
          IDBS,REG T,JMP T,PUSH
          2543;
          AB,SCRAM A,R4 B,R5 ALUF,Q+1 ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          15;
          AB,PRCHR A,R6 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          20;
          AB,CURNR A,R3 B,R3 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSB ALUD,SLD
          T,NEXT T,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSB
          T,NEXT T,HOLD;
          AB,UPPNR A,R3 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          B,D ALUF,PASSD
          IDBS,BARG T,RETURN T,POP;
          AB,SCRAM A,R4 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          B,R1 ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2612 CONDENABL;
          B,R7 ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2610 CONDENABL;
          B,L ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2604 CONDENABL;
          B,D ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2603 CONDENABL;
          B,B ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2575 CONDENABL;
          B,L ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2577 CONDENABL;
          B,R3 ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2601 CONDENABL;
          B,D ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2602 CONDENABL;
          B,P ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2600 CONDENABL;
          B,R6 ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2576 CONDENABL;
          B,B ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2606 CONDENABL;
          B,R4 ALUF,Q-D
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2640 CONDENABL;
          B,B ALUF,D+Q
          IDBS,BARG T,JMP T,HOLD CYCL,SLOW
          2630 CONDENABL;
          A,R2 ALUF,Q-D
          IDBS,AARG T,JMP T,HOLD CYCL,SLOW
          2642 CONDENABL;
          A,A ALUF,D+Q+1
          IDBS,AARG T,JMP T,HOLD CYCL,SLOW
          2637 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2644 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2162;
          B,Z ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,D ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,P ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,B ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,L ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,A ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,T ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,X ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          2605;
          B,R2 ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          2270;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2607;
          A,Z B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          2614;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          A,D B,R1 ALUF,D+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD CYCL,SLOW
          2614;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          AB,OCTAD A,R5 B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,WRADR A,R5 B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,OCTN2 A,R3 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          AB,OCTA2 A,R6 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,R1 ALUF,PASSA
          COMM,LDLC T,NEXT T,HOLD;
          AB,DISPL A,R6 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,WRTYP A,R5 B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2623;
          AB,OCTAD A,R5 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,PUSH
          2171;
          AB,RONLY A,R5 B,R4 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          2241;
          AB,DISPL A,R6 B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          ALUD,NONE
          T,NEXT T,HOLD
          2254 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          2306;
          A,A B,R4 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG COMM,CLIRQ T,NEXT T,NEXT T,MAPJ T,HOLD;
          B,R1 ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          AB,OPR A,R6 B,R1 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          B,A ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          1117;
          A,A ALUF,PASSA
          T,JMP T,PUSH
          2241;
          A,R4 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          2305;
          A,R6 ALUF,D+1
          IDBS,AARG T,JMP T,HOLD
          2641;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          L0142;
          A,D B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          2614;
          B,R7 ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          AB,DISPL A,R6 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,PUSH
          2305;
          B,L ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          AB,DISPL A,R6 B,R5 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          123;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R5 ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          100;
          B,R4 ALUD,NONE
          IDBS,BARG COMM,XMM T,JMP T,HOLD CYCL,SLOW
          2441;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          60;
          ALUF,ANDDQ
          IDBS,GPR T,NEXT T,HOLD;
          A,P ALUF,XORDQ ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          L0027 CONDENABL;
          ALUD,NONE
          T,JMP0-3 T,HOLD CYCL,WAIT
          3500;
          A,R1 B,R4 ALUF,PASSA ALUD,B
          T,RETURN T,POP CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          A,R7 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          AB,TXT1 A,R6 B,R4 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R3 ALUF,D-1
          IDBS,BMG T,NEXT T,HOLD;
          AB,PRCHR A,R6 B,R6 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R4 B,T ALUF,A+B ALUD,B STS,EA
          T,NEXT T,HOLD;
          A,R6 B,X ALUF,A+B ALUD,B CRY,C
          T,RETURN T,POP;
          A,R7 B,T ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          2672 CONDENABL;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,STS ALUF,PASSA ALUD,NONE
          COMM,CLIRQ T,RETURN T,POP CYCL,WAIT
          COND,IRQ F,NEXT F,HOLD;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,JMP MIS,PT T,HOLD
          2671;
          A,R7 B,T ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          2677 CONDENABL;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSD ALUD,B
          IDBS,DBR T,RETURN T,POP CYCL,WAIT;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,JMP MIS,PT T,HOLD
          2676;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,PASSA
          T,NEXT T,HOLD
          3243 CONDENABL;
          A,R7 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          3243 CONDENABL;
          B,R2 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          3243;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,T ALUF,PASSA
          T,NEXT T,HOLD
          2673 CONDENABL;
          A,R7 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          2673 CONDENABL;
          B,R3 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2673;
          B,R2 ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          2673;
          B,STS ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,JMP T,PUSH
          2666;
          B,R3 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD CYCL,WAIT;
          B,R5 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,R6 ALUF,B-1 ALUD,B
          T,RETURN T,POP;
          B,X ALUF,B+1 ALUD,B
          T,JMP T,PUSH
          2673;
          B,STS ALUF,MASKAB ALUD,B
          T,NEXT T,HOLD;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,JMP T,PUSH
          2666;
          AB,PIE A,R7 B,R3 ALUF,B+1 ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          A,T B,T ALUF,MASKDA ALUD,B
          IDBS,GPR T,JMP T,HOLD
          2716;
          AB,STATUS A,R6 B,R7 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,T B,R5 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          A,X B,R3 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD CYCL,WAIT
          2741 CONDENABL;
          AB,SSAVE A,R3 B,R6 ALUD,NONE
          IDBS,STS COMM,EWRF T,NEXT T,HOLD;
          AB,DUMPF A,R5 B,R6 ALUF,PASSA ALUD,SRB
          T,JMP MIS,PT T,PUSH
          2660;
          A,R7 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD;
          A,T B,T ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          AB,SSAVE A,R3 B,R6 ALUD,NONE STS,LO
          IDBS,REG T,NEXT T,HOLD;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          B,STS ALUF,MASKAB
          T,NEXT T,HOLD
          2712 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          B,A ALUF,ANDAB
          T,NEXT T,HOLD;
          B,R2 ALUF,ORDQ ALUD,B
          IDBS,SWAP T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          2720 CONDENABL;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,SRB
          T,JMP T,PUSH
          2657;
          A,R2 B,STS ALUF,PASSA ALUD,B
          T,RETURN T,POP
          2666 CONDENABL;
          B,R3 ALUF,B+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          2753 CONDENABL;
          B,R1 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          A,R1 ALUF,PASSA ALUD,NONE
          T,JMP T,HOLD
          2747;
          AB,MACL A,R4 B,R1 ALUF,A-B
          T,NEXT T,HOLD;
          A,X B,X ALUF,A+Q+1 ALUD,B
          T,NEXT T,HOLD;
          AB,CDIGI A,R7 B,R1 ALUF,Q+1 ALUD,SLB
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD;
          A,T B,T ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          AB,WRADR A,R5 B,R1 ALUF,A-B ALUD,B
          T,NEXT T,HOLD;
          A,R1 B,T ALUF,ORAB ALUD,B
          T,NEXT T,HOLD;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          20;
          ALUD,NONE
          T,JMP T,PUSH
          3243;
          B,R4 ALUF,ANDDA ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,MASKAQ
          T,JMP T,HOLD
          2712;
          B,D ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          3243;
          B,STS ALUF,MASKAB
          T,JMP T,HOLD
          2712;
          B,D ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          3243;
          ALUF,ANDDA
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,R4 ALUF,MASKAB ALUD,B
          T,JMP T,HOLD
          2720;
          ALUD,NONE
          T,JMP T,PUSH
          3243;
          B,STS ALUF,ANDAB
          T,JMP T,HOLD
          2720;
          A,R4 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          A,D ALUF,ANDAQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          3105 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          3141;
          A,T ALUF,PASSA
          T,NEXT T,HOLD;
          A,R4 B,T ALUF,MASKDQ ALUD,B
          IDBS,BMG T,JMP T,HOLD
          3007;
          A,D ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD;
          A,T B,T ALUF,ORAQ ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,D B,R5 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,WRADR A,R5 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,T B,R1 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          A,T B,R6 ALUF,ANDAQ ALUD,B
          T,JMP T,HOLD
          3017 CONDENABL;
          AB,LMP A,R4 B,R2 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,T B,R2 ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          3030 CONDENABL;
          AB,DUMPF A,R5 B,R6 ALUF,B-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,SINGL A,R4 B,R4 ALUF,INVQ ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          3022 CONDENABL;
          AB,DISPL A,R6 B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R1 B,T ALUF,ORAB ALUD,B
          T,NEXT T,HOLD
          3030 CONDENABL;
          A,R4 B,T ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,R5 B,T ALUF,ORAB ALUD,B
          T,NEXT T,HOLD;
          A,R4 B,D ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,R5 B,D ALUF,ORAB ALUD,B
          T,NEXT T,HOLD;
          A,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD CYCL,WAIT;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          2777 CONDENABL;
          B,R2 ALUF,ZERO ALUD,SRB ALUM,FMU
          T,NEXT T,HOLD;
          A,A B,R2 ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,PUSH
          2700;
          A,X B,R3 ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,PUSH
          2705;
          B,R2 ALUF,ZERO ALUD,SRB ALUM,FMU
          T,NEXT T,HOLD;
          A,A B,R2 ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,PUSH
          3243;
          A,X B,R3 ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,PUSH
          2673;
          A,A B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          3243;
          A,X B,R3 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          2673;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          3107 CONDENABL;
          AB,RONLY A,R5 B,R4 ALUF,A-1 ALUD,SRB
          T,NEXT T,HOLD
          3070 CONDENABL;
          A,A B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,JMP F,PUSH;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          3056 CONDENABL;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          2775;
          B,R2 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          B,A ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          B,D ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          3345;
          A,R1 B,D ALUF,MASKAB ALUD,B
          T,JMP T,PUSH
          3252;
          ALUD,NONE
          T,JMP T,HOLD
          3141;
          A,D B,T ALUF,XORAB
          T,JMP T,PUSH
          3155;
          A,R5 B,STS ALUF,PASSA ALUD,SRB
          T,NEXT T,POP
          0 CONDENABL;
          A,STS B,R2 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD;
          A,STS B,R3 ALUF,A+B ALUD,B
          T,JMP T,PUSH
          2766 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          3260;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,PUSH
          3227;
          A,T B,R4 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          2775;
          B,X ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,R4 B,T ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          20;
          A,A B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,JMP F,PUSH;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          3074 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          3266;
          ALUD,NONE
          T,JMP T,HOLD
          3115;
          A,D B,T ALUF,XORAB
          T,JMP T,PUSH
          3155;
          A,R5 B,STS ALUF,PASSA ALUD,SRB
          T,NEXT T,POP
          0 CONDENABL;
          A,STS B,R2 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD;
          AB,BPFLG A,R4 B,R3 ALUF,A+B ALUD,B
          T,JMP T,HOLD
          3104 CONDENABL;
          B,D ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          2762;
          A,R4 ALUF,PASSA
          T,JMP T,PUSH
          3305;
          ALUD,NONE
          T,JMP T,HOLD
          3105;
          ALUD,NONE
          T,JMP T,PUSH
          3302;
          ALUD,NONE
          T,JMP T,PUSH
          3227;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
          AB,RONLY A,R5 B,R4 ALUF,A-1 ALUD,SRB
          T,NEXT T,HOLD
          3136 CONDENABL;
          A,A B,X ALUF,B-A ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          3121 CONDENABL;
          A,R1 B,T ALUF,MASKAB ALUD,B
          T,JMP T,PUSH
          2771;
          A,R1 B,D ALUF,ORAB ALUD,B
          T,JMP T,PUSH
          3345;
          A,R4 ALUF,PASSA
          T,JMP T,PUSH
          3271;
          B,R1 ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          3217;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          A,R1 ALUF,PASSA
          T,NEXT T,HOLD
          2712 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
          A,D B,T ALUF,XORAB
          T,JMP T,PUSH
          3155;
          A,R5 B,STS ALUF,PASSA ALUD,SRB
          T,NEXT T,POP
          0 CONDENABL;
          AB,LMP A,R4 B,R2 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW;
          A,STS B,R3 ALUF,A+B ALUD,B
          T,JMP T,HOLD
          3133 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          3302;
          B,R1 ALUF,PASSQ ALUD,B
          T,JMP T,PUSH
          3227;
          A,T B,R4 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R1 ALUF,PASSA
          T,JMP T,PUSH
          2720;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          3066;
          B,D ALUF,B-1 ALUD,B
          T,JMP T,PUSH
          2762;
          A,R4 ALUF,PASSA
          T,JMP T,PUSH
          3305;
          ALUD,NONE
          T,JMP T,HOLD
          3127;
          A,A B,X ALUF,B-A ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          AB,CDIGI A,R7 B,R1 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,PUSH
          3145 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          3252;
          ALUD,NONE
          T,JMP T,PUSH
          3217;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,JMP F,PUSH;
          ALUD,NONE
          T,NEXT T,HOLD
          2767 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
          A,D B,T ALUF,XORAB
          T,JMP T,PUSH
          3155;
          ALUD,NONE
          T,NEXT T,POP
          0 CONDENABL;
          AB,LMP A,R4 B,R2 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          A,R5 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,SLOW;
          AB,BPFLG A,R4 B,R3 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          2766 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          3260;
          ALUD,NONE
          T,JMP T,PUSH
          3227;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
          A,R6 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,POP;
          A,D ALUF,PASSD
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          0 CONDENABL;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD;
          AB,SSAVE A,R3 B,R6 ALUF,ZERO
          IDBS,STS COMM,EWRF T,NEXT T,HOLD
          0 CONDENABL;
          AB,PVL A,R7 B,R5 ALUF,PASSB ALUD,SRB
          IDBS,BMG COMM,LDGPR T,NEXT T,NEXT MIS,PT T,HOLD;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD;
          A,R5 STS,EA
          T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          3777;
          AB,DUMPF A,R5 B,R6 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,A B,R6 ALUF,A+B ALUD,B CRY,C
          T,NEXT T,HOLD;
          AB,SSAVE A,R3 B,R6 ALUD,NONE STS,LO
          IDBS,REG T,JMP T,PUSH
          3172;
          B,R5 ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          B,D ALUF,PASSD
          IDBS,BARG T,RETURN T,POP
          COND,F=0 F,RETURN F,POP;
          A,X B,R6 ALUF,B-A ALUD,B
          T,NEXT T,HOLD
          COND,CRY F,RETURN F,POP;
          AB,BRKPT A,R4 B,R6 ALUF,PASSB ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD CONDENABL;
          A,R7 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,JMP T,HOLD
          3201 CONDENABL;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,POP
          COND,F=0 F,JMP F,HOLD;
          AB,SCRAM A,R4 B,R5 ALUF,PASSB ALUD,SLB
          IDBS,BMG COMM,LDGPR T,NEXT T,NEXT MIS,PT T,HOLD
          3215 CONDENABL;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,ZERO
          T,RETURN T,POP
          COND,F=0 F,RETURN F,POP;
          A,T ALUF,PASSA ALUD,NONE
          T,RETURN T,POP
          COND,F15 F,JMP F,HOLD CONDENABL;
          ALUD,NONE
          T,RETURN T,POP
          3175 CONDENABL;
          AB,MACL A,R4 B,R1 ALUF,A-B
          T,NEXT T,HOLD;
          A,A B,A ALUF,A+Q+1 ALUD,B
          T,NEXT T,HOLD;
          AB,MACL A,R4 B,R1 ALUF,Q+1 ALUD,SLB
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,X B,X ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD
          3213 CONDENABL;
          A,R1 B,T ALUF,B-A ALUD,B
          T,JMP T,HOLD
          3213;
          AB,MACL A,R4 B,R1 ALUF,A-B
          T,NEXT T,HOLD;
          B,R1 ALUF,Q+1 ALUD,SLB
          T,NEXT T,HOLD;
          A,R1 B,D ALUF,B-A ALUD,B
          T,NEXT T,HOLD;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          20;
          A,B ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD;
          A,T B,T ALUF,MASKDA ALUD,B
          IDBS,GPR T,JMP T,HOLD
          20;
          AB,DUMPF A,R5 B,R6 ALUF,PASSA ALUD,SRB
          T,JMP MIS,PT T,PUSH
          3235;
          A,T ALUF,PASSA
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R4 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          3231 CONDENABL;
          A,R4 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,T B,T ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R5 B,T ALUF,B-A ALUD,B
          T,NEXT T,HOLD;
          A,R5 B,D ALUF,B-A ALUD,B
          T,RETURN T,POP;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,T B,R6 ALUF,ANDAB ALUD,SRB
          T,JMP MIS,PT T,PUSH
          3235;
          A,R4 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,T B,T ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD;
          A,D B,D ALUF,ANDAQ ALUD,B
          T,RETURN T,POP;
          AB,SSAVE A,R3 B,R6 ALUD,NONE
          IDBS,STS COMM,EWRF T,JMP T,PUSH
          2660;
          A,R4 B,D ALUF,A+B ALUD,B STS,EA
          T,NEXT T,HOLD;
          A,R6 B,A ALUF,A+B ALUD,B CRY,C
          T,NEXT T,HOLD;
          A,R6 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,D B,D ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          AB,SSAVE A,R3 B,R6 ALUD,NONE STS,LO
          IDBS,REG T,RETURN T,POP;
          A,R7 B,D ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          3247 CONDENABL;
          A,R2 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSD ALUD,B
          IDBS,DBR T,RETURN T,POP CYCL,WAIT;
          A,R2 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,JMP MIS,PT T,HOLD
          3246;
          B,R3 ALUF,B+1 ALUD,B
          T,RETURN T,POP
          COND,F=0 F,JMP F,PUSH;
          B,R3 ALUF,B-1 ALUD,B
          T,RETURN T,POP
          COND,F=0 F,JMP F,PUSH;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,SRB
          T,JMP T,PUSH
          3316;
          ALUD,NONE
          T,RETURN T,POP
          3243 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          2666;
          B,R2 ALUF,B+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3203 CONDENABL;
          B,R3 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          B,R1 ALUF,B-1 ALUD,B
          T,JMP T,HOLD CYCL,SLOW
          3253;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,SRB
          T,JMP T,PUSH
          2657;
          ALUD,NONE
          T,RETURN T,POP
          3243 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          2666;
          B,R2 ALUF,B-1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3211 CONDENABL;
          B,R3 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          B,R1 ALUF,B-1 ALUD,B
          T,JMP T,HOLD CYCL,SLOW
          3261;
          ALUD,NONE
          T,JMP T,PUSH
          3243;
          B,STS ALUF,ANDAB ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD;
          B,R2 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,SRB
          T,JMP T,PUSH
          2657;
          ALUD,NONE
          T,RETURN T,POP
          3243 CONDENABL;
          B,STS ALUF,ANDDA ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,JMP T,PUSH
          2666;
          B,R6 ALUF,MASKAB
          T,JMP T,HOLD CYCL,WAIT
          3203 CONDENABL;
          B,R2 ALUF,B+1 ALUD,B
          T,JMP T,PUSH CYCL,WAIT
          3250;
          B,R1 ALUF,B-1 ALUD,B
          T,JMP T,HOLD CYCL,SLOW
          3273;
          ALUD,NONE
          T,JMP T,PUSH
          3243;
          A,STS B,R2 ALUF,B-1 ALUD,B,YA
          T,NEXT T,HOLD;
          ALUF,ANDDA
          IDBS,SWAP T,NEXT T,HOLD;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,SRB
          T,JMP T,PUSH
          2657;
          ALUD,NONE
          T,RETURN T,POP
          3243 CONDENABL;
          B,R6 ALUF,ANDDA ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          B,STS ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,STS ALUF,MASKAB ALUD,B
          T,NEXT T,HOLD;
          A,STS B,STS ALUF,ORAQ ALUD,B
          T,JMP T,PUSH
          2666;
          A,R6 ALUF,PASSA
          T,JMP T,HOLD CYCL,WAIT
          3211 CONDENABL;
          B,R2 ALUF,B-1 ALUD,B
          T,JMP T,PUSH CYCL,WAIT
          3251;
          B,R1 ALUF,B-1 ALUD,B
          T,JMP T,HOLD CYCL,SLOW
          3306;
          A,R1 B,X ALUF,PASSA
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          40;
          A,R1 B,R4 ALUF,PASSA ALUD,B
          T,RETURN T,POP
          COND,F=0 F,JMP F,PUSH CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,PIL B,LC ALUF,PASSB ALUD,NONE
          COMM,EWRF T,JMP T,LOAD LCOUNT
          3326;
          ALUD,NONE
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,PIL B,LC ALUF,PASSD ALUD,B
          IDBS,REG T,NEXT T,POP LCOUNT;
          A,R4 ALUF,PASSA ALUD,NONE
          T,RETURN T,POP
          COND,F=0 F,JMP F,PUSH;
          A,R1 B,R1 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,R7 B,X ALUF,PASSA
          IDBS,BARG COMM,LDLC T,RETURN T,POP
          COND,F=0 F,RETURN F,HOLD CONDENABL;
          A,PIL B,D ALUF,ANDDQ ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,SLOW
          3341;
          AB,NUMBR A,R2 B,R2 ALUF,B+1 ALUD,B,YA
          COMM,RDRQ T,JMP MIS,APT T,HOLD
          3332;
          B,LC ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,POP LCOUNT CYCL,WAIT;
          B,X ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,PIL B,T ALUF,ANDDQ ALUD,NONE
          IDBS,REG T,JMP T,PUSH CYCL,SLOW
          3343;
          AB,CURNR A,R3 B,R3 ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,JMP MIS,APT T,HOLD
          3336;
          B,LC ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,LC=0 F,JMP F,HOLD;
          B,R1 ALUF,B-1 ALUD,B
          COMM,CLIRQ T,NEXT T,POP LCOUNT CYCL,WAIT
          COND,IRQ F,JMP F,HOLD;
          B,X ALUD,NONE
          IDBS,BARG COMM,LDLC T,RETURN T,POP
          3326 CONDENABL;
          ALUD,NONE
          T,NEXT T,LOAD
          COND,LC=0 F,JMP F,HOLD CONDENABL;
          AB,NUMBR A,R2 B,R2 ALUF,B+1 ALUD,B,YA
          COMM,RDRQ T,JMP MIS,PT T,HOLD
          3332;
          ALUD,NONE
          T,NEXT T,LOAD
          COND,LC=0 F,JMP F,HOLD CONDENABL;
          AB,CURNR A,R3 B,R3 ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,JMP MIS,PT T,HOLD
          3336;
          A,T ALUF,PASSA
          T,NEXT T,HOLD;
          A,R4 ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,RETURN T,POP
          0 CONDENABL;
          B,T ALUF,B-1 ALUD,B
          T,RETURN T,POP;
L3351:
          A,R2 ALUF,D+1
          IDBS,AARG T,NEXT T,HOLD;
          A,T B,R7 ALUF,PASSA ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,PUSH CYCL,WAIT
          1311;
          A,X B,SRCE ALUF,D+A
          IDBS,BARG T,JMP0-3 T,HOLD
          3460;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          1315;
          B,X ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          1315;
          B,D ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3354;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,X B,B ALUF,ORDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          A,B B,B ALUF,A+B ALUD,B
          T,JMP T,HOLD
          1315;
          A,A ALUF,PASSA ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1315;
          ALUF,ZERO ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1315;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSQ ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3363;
          A,P B,R1 ALUF,A+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0176;
          A,B B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3417;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0172;
          B,R7 ALUF,D+Q ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3426;
          ALUF,PASSD
          IDBS,STS T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          ALUF,XORDQ
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,Z ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,P ALUF,A+1 ALUD,B
          T,JMP T,HOLD
          3414 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          20;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0176;
          A,B B,R6 ALUF,A-B ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,B B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3417;
          A,R2 B,R4 ALUF,A-B ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0172;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          3426;
          AB,PIE A,R7 B,R3 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,JMP F,POP;
          B,P ALUF,B+1 ALUD,B
          T,NEXT T,HOLD CYCL,WAIT
          20 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          20;
          ALUF,PASSQ ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,L ALUF,B+1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,X B,B ALUF,D+Q ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          AB,TXT2 A,R6 B,R3 ALUF,A+1 ALUD,B
          T,NEXT T,HOLD CYCL,WAIT;
          A,B B,R3 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R2 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          AB,TXT1 A,R6 B,R4 ALUF,A-1 ALUD,B
          T,RETURN T,POP CYCL,WAIT;
          A,B B,R4 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,R5 ALUF,D-A
          IDBS,GPR T,NEXT T,HOLD CYCL,WAIT;
          A,B B,R6 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,B B,R3 ALUD,B
          T,RETURN T,POP CYCL,WAIT;
          A,X ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD CYCL,WAIT;
          A,B ALUF,A-Q
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,D-1 ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSQ ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          L0173;
          A,B ALUF,A-Q ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          L0177;
          A,B B,R1 ALUF,A-B ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,B ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R1 ALUF,A-1 ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,P ALUF,PASSD ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,POP CYCL,WAIT
          20;

3460/
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3354;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3355;
          ALUF,Q+1 ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3356;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3360;
          ALUF,PASSQ ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3363;
          ALUF,PASSQ ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3364;
          ALUF,Q+1 ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3365;
          ALUF,Q+1 ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3365;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3354;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3355;
          ALUF,Q+1 ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3356;
          ALUF,PASSQ ALUD,NONE
          COMM,IRDRQ T,JMP T,HOLD
          3360;
          ALUF,PASSQ ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3363;
          ALUF,PASSQ ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3364;
          ALUF,Q+1 ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3365;
          ALUF,Q+1 ALUD,NONE
          COMM,DERQ T,JMP T,HOLD
          3365;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          2725;
          ALUD,NONE
          T,JMP T,HOLD
          3003;
          ALUD,NONE
          T,JMP T,HOLD
          3005;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          L0027;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1560;
          A,P ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          500;
          A,P ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1540;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          400;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1600;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1560;
          A,R2 ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          500;
          A,R2 ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1540;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          400;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP
          1600;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          A,STS ALUF,PASSD
          IDBS,ARG T,RETURN T,POP;
          ALUD,NONE
          T,JMP T,HOLD
          2173;
          A,A B,R7 ALUF,PASSA ALUD,B
          COMM,CLIRQ T,JMP T,HOLD
          2202;
          A,B B,R6 ALUF,ORDQ ALUD,B
          IDBS,BMG COMM,CLIRQ T,JMP T,HOLD
          2210;
          A,A B,R7 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          2214;
          ALUD,NONE
          T,JMP T,HOLD
          2221;
          AB,SINGL A,R4 B,R4 ALUF,PASSD
          IDBS,REG COMM,SSTOP T,NEXT T,HOLD CYCL,SLOW
          COND,F=0 F,NEXT F,HOLD;
          AB,BPFLG A,R4 B,R3 ALUF,PASSD ALUD,NONE
          IDBS,REG T,JMP T,HOLD CYCL,SLOW
          3550 CONDENABL;
          AB,SINGL A,R4 B,R4 ALUF,Q-1 ALUD,NONE
          COMM,EWRF T,JMP T,HOLD CYCL,SLOW
          2376;
          AB,BRKPT A,R4 B,R6 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2366 CONDENABL;
          A,P ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,T ALUF,D-1
          IDBS,AARG T,NEXT T,HOLD
          2376 CONDENABL;
          AB,PRCHR A,R6 B,R6 ALUF,Q-1 ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          2305;
          AB,OCTNR A,R5 B,R5 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD;
          AB,BRKPT A,R4 B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,BPFLG A,R4 B,R3 ALUD,NONE
          IDBS,ARG COMM,EWRF T,JMP T,HOLD
          2311;
          AB,ACTLV A,R4 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          2230;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          2120;
          A,R7 ALUF,MASKDQ
          IDBS,BMG T,JMP T,HOLD
          1277;
          A,R7 ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD CYCL,WAIT
          1301;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
          A,R6 ALUF,MASKDQ
          IDBS,BMG T,JMP T,HOLD CYCL,WAIT
          1300;
          A,R6 ALUF,MASKDQ
          IDBS,BMG T,JMP T,HOLD
          3561;
          A,R5 ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD CYCL,WAIT
          1300;
          A,R5 ALUF,MASKDQ
          IDBS,BMG T,JMP T,HOLD CYCL,WAIT
          1300;
          A,R6 ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD CYCL,WAIT
          1300;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
          A,R6 ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD
          3562;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
          A,X ALUD,NONE
          IDBS,BMG COMM,SMPID T,JMP T,HOLD CYCL,WAIT
          20;
          ALUD,NONE
          T,JMP T,HOLD
          1111;
          A,R2 ALUF,D+1
          IDBS,AARG T,JMP T,HOLD
          1303;
          A,R2 ALUF,D+1
          IDBS,AARG T,JMP T,HOLD
          1306;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1366;
          B,A ALUF,PASSD ALUD,B
          IDBS,STS T,RETURN T,HOLD;
          AB,OPR A,R6 B,R1 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1362;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1375;
          AB,PVL A,R7 B,R5 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1363;
          PIC,RSTS B,R5 ALUF,PASSD ALUD,B
          IDBS,PIC COMM,EPIC T,JMP T,HOLD
          1343;
          PIC,RMSK B,R1 ALUF,PASSD ALUD,B
          IDBS,DSABL COMM,EPIC T,JMP T,HOLD
          1320;
          AB,PIE A,R7 B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1362;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1401;
          A,PIL B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,RETURN T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1364;
          B,A ALUF,INVD ALUD,B
          IDBS,PES T,RETURN T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1367;
          B,A ALUF,INVD ALUD,B
          IDBS,PEA T,RETURN T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1366;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1366;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1443;
          ALUF,PASSQ ALUD,NONE STS,LO
          T,RETURN T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          1435;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1373;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          A,A
          T,JMP T,HOLD
          1407;
          AB,PID A,R7 B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          1431;
          AB,PIE A,R7 B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          1422;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD
          1440;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          1436;
          A,Z ALUF,PASSD
          IDBS,IOR T,JMP T,HOLD
          1133;
          ALUD,NONE
          T,RETURN T,POP;
          A,Z B,A ALUF,PASSD ALUD,B
          IDBS,IOR T,JMP T,HOLD
          1136;
          A,A B,R2 ALUF,INVA ALUD,B
          T,JMP T,HOLD
          1156;
          B,A ALUF,ZERO ALUD,B
          T,RETURN T,POP;
          A,A ALUF,PASSA ALUD,NONE
          COMM,TBSTR T,RETURN T,POP CYCL,SLOW;
          B,A ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          1165;
          AB,STATUS A,R6 B,R7 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD
          1172;
          A,A ALUF,ZERO ALUD,B
          T,RETURN T,POP;
          A,X ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD
          1175;
          B,A ALUF,ANDDQ ALUD,B
          IDBS,ARG T,RETURN T,POP
          11;
          A,Z ALUF,ORDQ
          IDBS,BMG T,JMP T,HOLD
          1177;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3671;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,JMP MIS,APT T,HOLD
          3671;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3670;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,JMP MIS,APT T,HOLD
          3670;
          A,P B,P ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
          A,B B,P ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
          A,P B,R1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3654;
          A,B B,R1 ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3655;
          A,X B,P ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
          A,X B,P ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD
          3672;
          A,P B,R1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3656;
          A,B B,R1 ALUF,A+Q+1 ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          3657;
          A,X B,P ALUF,D+A ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          20;
          B,P ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          20;
          A,B B,P ALUF,A+B ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          20;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,RETURN T,RETURN MIS,APT T,POP;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,RETURN T,RETURN MIS,APT T,POP;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,RETURN T,RETURN MIS,HOLD T,POP;
          A,P B,R1 ALUF,A-B ALUD,NONE
          COMM,ESRP T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,B+1 ALUD,B
          COMM,WRRQ T,RETURN T,RETURN MIS,HOLD T,POP;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3717;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3673;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3710;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3711;
          A,X B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3673;
          A,X B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3716;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3713;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3714;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3712;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          3673;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3715;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,X B,R1 ALUF,D+A ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          3673;
          A,B B,R1 ALUF,A+B ALUD,B
          COMM,WRRQ T,RETURN T,RETURN MIS,APT T,POP;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,RETURN T,RETURN MIS,PT T,POP;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3737;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3674;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3730;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3731;
          A,X B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3674;
          A,X B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3736;
          A,P B,R1 ALUF,A+B ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3733;
          A,B B,R1 ALUF,A+B+1 ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          3734;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3732;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          3674;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,JMP MIS,PT T,HOLD
          3735;
          B,R1 ALUF,PASSB ALUD,NONE
          COMM,IRDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,X B,R1 ALUF,D+A ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          3674;
          A,B B,R1 ALUF,A+B ALUD,B
          COMM,RDRQ T,RETURN T,RETURN MIS,APT T,POP;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,RETURN T,RETURN MIS,PT T,POP;
          B,R2 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1501;
          B,R3 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1501;
          B,R4 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1501;
          B,R5 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1501;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R6 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1476;
          B,R7 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          1501;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1707;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2026;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2034;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2405;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1747;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1751;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1736;
          AB,MACL A,R4 B,R1 ALUD,NONE
          IDBS,ARG COMM,EWRF T,JMP T,HOLD
          1543;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1707;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2026;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2034;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          2405;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1747;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1751;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          1736;
          AB,MACL A,R4 B,R1 ALUD,NONE
          IDBS,ARG COMM,EWRF T,JMP T,HOLD
          1543;
          A,P B,R1 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD CYCL,WAIT
          4340;
          A,Z ALUD,NONE
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          4337;
          A,Z B,R7 ALUD,NONE EN_EXT
          IDBS,BARG COMM,EWRF T,JMP T,HOLD CYCL,WAIT
          4111;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          6623;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          5346;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          5737;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          4735;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          6627;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          2725;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          3003;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          3005;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          6635;
          ALUD,NONE
          IDBS,DBR COMM,LDGPR T,JMP T,HOLD CYCL,WAIT
          6652;
          ALUD,NONE
          T,JMP T,HOLD
          6710;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          6700;
          B,R5 ALUF,XORDQ ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          ALUF,Q-D-1 STS,EA CRY,C
          IDBS,GPR T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,XORAQ ALUD,B
          T,JMP T,HOLD
          4024 CONDENABL;
          A,T ALUF,Q-D
          IDBS,ARG T,NEXT T,HOLD;
          A,L B,R5 ALUF,ANDAB ALUD,SRB
          T,NEXT T,HOLD;
          AB,WRTYP A,R5 B,R2 ALUF,PASSA ALUD,SRB
          T,NEXT T,HOLD;
          A,R2 B,R5 ALUF,ORAB ALUD,SRB
          T,RETURN T,POP;
          B,R5 ALUF,XORDQ ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,T ALUF,D+Q
          IDBS,ARG T,NEXT T,HOLD
          3146;
          ALUF,D+Q STS,EA CRY,C
          IDBS,GPR T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,XNORAQ ALUD,B
          T,JMP T,HOLD
          4034 CONDENABL;
          A,T ALUF,Q-D
          IDBS,ARG T,NEXT T,HOLD;
          A,L B,R5 ALUF,ANDAB ALUD,SRB
          T,NEXT T,HOLD;
          AB,WRTYP A,R5 B,R2 ALUF,PASSA ALUD,SRB
          T,NEXT T,HOLD;
          A,R2 B,R5 ALUF,ORAB ALUD,SRB
          T,RETURN T,POP;
L4037:
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          60;
          ALUF,ANDDQ
          IDBS,GPR T,NEXT T,HOLD;
          A,P ALUF,XORDQ ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,R6 ALUD,NONE
          IDBS,STS COMM,EWRF T,NEXT T,HOLD
          L0027 CONDENABL;
          A,P B,R5 ALUD,NONE
          IDBS,BARG COMM,EWRF T,JMP0-3 T,HOLD
          4000;
          A,L ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          A,A B,R3 ALUD,NONE
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          A,B ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          A,A B,R2 ALUD,NONE
          IDBS,GPR COMM,EWRF T,RETURN T,POP;
          A,A B,R2 ALUD,NONE
          IDBS,REG COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          B,B ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,A B,R3 ALUD,NONE
          IDBS,REG COMM,LDGPR T,NEXT T,HOLD CYCL,NORM;
          B,L ALUF,PASSD ALUD,B
          IDBS,GPR T,RETURN T,POP;
          B,R2 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R2 B,R7 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          4057 CONDENABL;
          B,R7 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,R7 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSA ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD
          4063 CONDENABL;
          AB,TXT1 A,R6 B,R4 ALUF,A+B
          T,NEXT T,HOLD;
          B,R6 ALUF,Q-1 ALUD,B
          T,RETURN T,POP;
          AB,SINGL A,R4 B,R4 ALUF,B+1 ALUD,B,YA
          COMM,LDGPR T,NEXT T,HOLD;
          AB,PRCHR A,R6 B,R6 ALUF,D+A ALUD,B
          IDBS,GPR T,RETURN T,POP;
          A,R2 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R2 B,STS ALUF,ANDDA ALUD,B
          IDBS,GPR T,JMP T,HOLD
          4070 CONDENABL;
          B,STS ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,R2 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,STS ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD
          4073 CONDENABL;
          B,STS ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,STS B,R3 ALUF,PASSA ALUD,SLB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,STS B,R1 ALUF,A+B ALUD,B
          T,JMP T,HOLD
          4100 CONDENABL;
          B,STS ALUF,B+1 ALUD,B
          IDBS,ARG COMM,LDGPR T,RETURN T,POP
          L0037;
          B,R1 ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,RETURN T,POP
          L0037;
          A,R2 ALUF,PASSA ALUD,NONE
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          4106 CONDENABL;
          A,R2 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,POP;
          A,R4 ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          0 CONDENABL;
          B,Z ALUF,D-1 ALUD,B
          IDBS,BARG T,RETURN T,POP;
          A,R2 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,POP;
          A,L ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          0 CONDENABL;
          A,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,RETURN T,POP;
          B,R4 ALUF,A+1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          16;
          A,T B,R7 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          4132 CONDENABL;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,X B,R7 ALUF,A-1
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          ALUF,Q+1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R1 B,LC ALUF,A-Q-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,R3 B,R7 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,STS B,R4 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          B,R5 ALUF,D-1 ALUD,B
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,ANDAQ
          T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,A B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          4137 CONDENABL;
          A,D B,R7 ALUD,NONE EN_EXT
          IDBS,BARG COMM,EWRF T,NEXT T,HOLD;
          A,Z B,STS ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,BARG T,JMP T,HOLD
          4151;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,A B,R7 ALUF,A-1
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          ALUF,Q+1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R1 B,LC ALUF,A-Q-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          B,R6 ALUF,D-1 ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,ANDAQ
          T,NEXT T,HOLD;
          A,D B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          B,R5 ALUF,B+1 ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4157 CONDENABL;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,Z B,LC ALUF,MASKAQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          4162;
          B,R2 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,R6 ALUF,B+1 ALUD,NONE
          COMM,LDLC T,JMP T,PUSH
          4327;
          B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,L ALUF,PASSA
          T,NEXT T,HOLD
          4166 CONDENABL;
          ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,R2 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,A B,R3 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          4171 CONDENABL;
          B,R2 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,R2 ALUF,XORAB
          T,NEXT T,HOLD;
          A,Z ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,B B,R2 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          4246 CONDENABL;
          A,R4 B,STS ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,T ALUD,NONE STS,LO
          IDBS,BMG T,JMP T,HOLD
          4211 CONDENABL;
          A,R4 B,STS ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          AB,WRADR A,R5 B,R1 ALUF,A+1 ALUD,B
          T,JMP T,HOLD
          4223 CONDENABL;
          B,R6 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          B,R5 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          AB,STATUS A,R6 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,POP;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,HOLD
          0 CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH;
          B,R5 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          AB,DEPOS A,R5 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,POP;
          A,D B,LC ALUF,ZERO ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,HOLD
          4223 CONDENABL;
          AB,OPR A,R6 B,R1 ALUF,A+1 ALUD,B
          T,NEXT T,PUSH;
          B,R5 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          B,R6 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          AB,DEPOS A,R5 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,POP;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,HOLD
          0 CONDENABL;
          ALUD,NONE
          T,NEXT T,PUSH;
          B,R6 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,POP;
          A,Z B,LC ALUF,ZERO ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,HOLD
          0 CONDENABL;
          AB,PIE A,R7 B,R3 ALUF,XORAB
          T,NEXT T,HOLD;
          A,D ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          4263 CONDENABL;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,PUSH CYCL,NORM
          4020;
          A,R5 ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,R1 B,LC ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          4243 CONDENABL;
          A,T B,A ALUF,ZERO ALUD,B STS,LO
          IDBS,BMG T,NEXT T,POP LCOUNT;
          A,B B,R2 ALUF,PASSD ALUD,B
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R2 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,A B,R3 ALUF,PASSD
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          4242 CONDENABL;
          B,A ALUF,INVB ALUD,B
          T,NEXT T,HOLD;
          B,A ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          B,L ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          4676;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          4262 CONDENABL;
          A,Z B,A ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          4235;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          B,R4 ALUF,B+1 ALUD,B
          T,NEXT T,PUSH;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          4260 CONDENABL;
          ALUD,NONE
          T,NEXT T,POP LCOUNT;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          B,STS ALUF,B+1 ALUD,B
          T,NEXT T,PUSH;
          A,D B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          4260 CONDENABL;
          B,A ALUF,ZERO ALUD,B
          T,JMP T,POP LCOUNT
          4235;
          A,Z ALUF,ANDDA ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,B B,R2 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          4245 CONDENABL;
          B,A ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          4235;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,T B,R7 ALUF,ZERO ALUD,B STS,LO
          IDBS,BMG T,NEXT T,HOLD
          4306 CONDENABL;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          B,R6 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          B,R3 ALUF,PASSB
          T,JMP T,PUSH
          4020;
          A,R5 ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4243 CONDENABL;
          B,R5 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          B,R7 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,T B,R6 ALUF,PASSB STS,LO
          IDBS,BMG T,NEXT T,HOLD;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,PUSH
          4020;
          A,R5 ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          ALUD,NONE
          T,NEXT T,HOLD
          4243 CONDENABL;
          A,R1 B,LC ALUF,D-A-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,T B,A ALUF,ZERO ALUD,B STS,LO
          IDBS,BMG T,JMP T,POP LCOUNT
          4235;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          B,R6 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,R7 ALUF,PASSA
          T,NEXT T,HOLD;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,PUSH
          4020;
          A,R5 ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4243 CONDENABL;
          B,R5 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          B,R7 ALUF,ANDAQ ALUD,B
          T,NEXT T,HOLD;
          A,T B,R5 ALUF,PASSB STS,LO
          IDBS,BMG T,NEXT T,HOLD;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,PUSH
          4020;
          A,R5 ALUF,Q-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          ALUD,NONE
          T,NEXT T,HOLD
          4243 CONDENABL;
          A,R1 B,LC ALUF,D-A-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,T B,A ALUF,ZERO ALUD,B STS,LO
          IDBS,BMG T,JMP T,POP LCOUNT
          4235;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4334 CONDENABL;
          ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          ALUF,MASKDQ
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,POP;
          ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,POP;
          A,P B,R1 ALUD,NONE
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,T ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,R7 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          4345 CONDENABL;
          A,A B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          4354 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP CYCL,WAIT
          20;
          A,A B,R6 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,A B,R7 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R1 B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,STS B,R4 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,R7 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          4402;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          4364 CONDENABL;
          B,R4 ALUF,ANDDQ ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L7400;
          B,R4 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          ALUF,MASKDQ
          IDBS,GPR T,JMP T,HOLD
          4366;
          B,R4 ALUF,ANDDQ ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          17;
          ALUF,MASKDQ
          IDBS,GPR T,NEXT T,HOLD;
          A,R5 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          4372 CONDENABL;
          A,P B,R4 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          4375;
          A,R4 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,BARG T,JMP T,HOLD
          4375 CONDENABL;
          B,R4 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R4 ALUF,PASSB ALUD,NONE
          T,JMP T,HOLD
          4400 CONDENABL;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R4 ALUF,ORAQ ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          4344;
          A,D B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,A B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          4406 CONDENABL;
          A,D B,R7 ALUD,NONE EN_EXT
          IDBS,BARG COMM,EWRF T,NEXT T,HOLD;
          A,Z B,STS ALUF,D ALUD,B
          IDBS,BMG T,JMP T,HOLD
          4426;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          B,R1 ALUF,B+1
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          17;
          ALUF,Q-1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A B,LC ALUF,Q-A-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,HOLD CYCL,WAIT
          COND,COND F,JMP F,HOLD;
          ALUF,PASSQ ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          ALUF,PASSB
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD;
          A,P B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R2 ALUF,MASKAQ ALUD,B
          T,NEXT T,HOLD;
          ALUF,ANDAQ
          T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,P B,R2 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          AB,PIE A,R7 B,R3 ALUF,XORAB
          T,NEXT T,HOLD;
          A,D ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,STS B,R2 ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          4462 CONDENABL;
          B,R6 ALUF,B+1 ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,PUSH
          17;
          B,R6 ALUF,B-1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,X B,R6 ALUF,B-A-1 ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          B,LC ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,Z B,LC ALUF,ANDAQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,PUSH
          4044;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4452 CONDENABL;
          ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          ALUF,MASKDQ
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,D B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          ALUF,MASKDQ
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,Z B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          4514;
          A,R2 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          B,B ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,D B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          AB,NUMBR A,R2 B,R2 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          4514;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R2 B,R7 ALUF,INVA ALUD,B
          IDBS,BARG COMM,LDLC T,JMP T,HOLD
          4512 CONDENABL;
          AB,PRCHR A,R6 B,R6 ALUF,B-1 ALUD,B,YA
          COMM,RDRQ T,JMP MIS,APT T,PUSH
          4044;
          A,R6 B,X ALUF,A-B ALUD,NONE
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F15 F,NEXT F,HOLD;
          A,R2 ALUF,ANDDA ALUD,B
          IDBS,SWAP T,JMP T,HOLD
          4477 CONDENABL;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          B,R6 ALUF,PASSB ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R6 ALUF,B-1 ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          AB,PVL A,R7 B,R5 ALUF,ANDDA ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          A,R5 ALUF,ORAB
          T,NEXT T,HOLD;
          A,R2 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,R6 B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP LCOUNT;
          B,LC ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,L B,R2 ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          4506 CONDENABL;
          A,T B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R4 ALUF,B-1 ALUD,B
          IDBS,GPR COMM,LDLC T,JMP T,HOLD
          4441 CONDENABL;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          7777;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          4441;
          A,T B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          4511 CONDENABL;
          A,R2 ALUF,ANDAB ALUD,B
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSA ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          4441;
          ALUF,ZERO ALUD,B
          T,JMP T,PUSH
          4044;
          B,R4 ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          4467;
          A,R2 B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,R1 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4517 CONDENABL;
          B,R2 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,LC ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R2 ALUF,XORAQ
          T,NEXT T,HOLD
          4522 CONDENABL;
          ALUF,A-1 ALUD,B
          T,NEXT T,HOLD;
          A,R4 B,STS ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUF,XORAQ
          T,JMP T,HOLD
          4525 CONDENABL;
          A,STS B,R6 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          4526;
          AB,BRKPT A,R4 B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          A,Z ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,A B,R4 ALUD,NONE
          IDBS,BARG COMM,EWRF T,JMP T,HOLD
          4677 CONDENABL;
          A,T ALUD,NONE STS,LO
          IDBS,BMG T,JMP T,PUSH
          4533;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,PUSH CYCL,NORM
          4020;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUF,Q-A
          T,NEXT T,POP LCOUNT;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,A B,R6 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,A B,R7 ALUF,Q-D ALUD,B
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F15 F,NEXT F,HOLD;
          A,R4 B,STS ALUF,A-B
          T,JMP T,HOLD
          4615 CONDENABL;
          A,R7 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R5 ALUF,Q+1 ALUD,B
          T,JMP T,HOLD
          4560 CONDENABL;
          B,R5 ALUF,B-1 ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,LC ALUF,ZERO
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          4560 CONDENABL;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,R5 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          4552 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          4560;
          ALUF,Q ALUD,NONE CRY,C
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          4562 CONDENABL;
          A,R4 B,STS ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,D-1 ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD
          4562 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          4562 CONDENABL;
          A,P B,R5 ALUD,NONE
          IDBS,BARG COMM,EWRF T,JMP T,HOLD
          4562;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          4632 CONDENABL;
          A,STS B,R6 ALUF,PASSA ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          17;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          360;
          AB,PID A,R7 B,R4 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          A,D B,R7 ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,PUSH CYCL,NORM
          4571;
          B,R7 ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          A,D B,LC ALUF,ANDDQ ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,HOLD CYCL,NORM
          4572;
          ALUF,ZERO ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,R5 ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          4577 CONDENABL;
          A,R7 ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          4601 CONDENABL;
          A,R4 ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          4603 CONDENABL;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          4605 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          4632;
          A,R1 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          4633;
          B,R6 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          4606;
          A,R1 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          4641;
          B,R6 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          4606;
          A,R1 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          5001;
          B,R6 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          4606;
          A,R2 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          1;
          B,R6 ALUF,B+1 ALUD,B STS,EA
          T,JMP T,PUSH
          4610;
          A,R1 ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          4631;
          A,D B,LC ALUF,ZERO ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,PUSH CYCL,NORM
          4020;
          A,R5 ALUF,Q-A
          T,NEXT T,HOLD;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP LCOUNT;
          A,Z ALUF,XORDA ALUD,B
          IDBS,BMG T,JMP T,HOLD
          4632;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R6 ALUF,-Q ALUD,B STS,LO
          IDBS,AARG T,NEXT T,HOLD
          4632 CONDENABL;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,Z ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          4562 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          4020;
          A,R5 ALUF,Q-A
          T,NEXT T,HOLD;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD
          4632 CONDENABL;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE STS,LO
          IDBS,AARG T,JMP T,POP LCOUNT
          4562;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          4734 CONDENABL;
          A,A B,R7 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          4640 CONDENABL;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          4637 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          4675 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          4675;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R4 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          4643 CONDENABL;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          4646;
          B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          4646 CONDENABL;
          ALUF,Q+1 ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          4651 CONDENABL;
          ALUF,ORAQ
          T,JMP T,HOLD
          4655;
          ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,ORDQ
          IDBS,SWAP T,NEXT T,HOLD;
          ALUF,MASKDQ
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,B ALUF,ORAQ
          T,NEXT T,HOLD;
          A,D B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,P B,R6 ALUD,NONE STS,LO
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R1 B,A ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,JMP T,HOLD
          4665 CONDENABL;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          A,R1 B,A ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R1 ALUF,B-1 ALUD,B
          COMM,LDGPR T,NEXT T,POP LCOUNT;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          4671 CONDENABL;
          A,P B,R4 ALUF,MASKDQ ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          4673 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,P B,R2 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,A ALUF,PASSB ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          4050;
          A,P B,R6 ALUD,NONE STS,LO
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          4344;
          ALUD,NONE STS,LO
          IDBS,AARG T,JMP T,PUSH
          4701;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,PUSH CYCL,NORM
          4027;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUF,Q-A
          T,NEXT T,POP LCOUNT;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,A B,R6 ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,A B,R7 ALUF,D-Q ALUD,B
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F15 F,JMP F,HOLD;
          A,R4 B,STS ALUF,A-B
          T,NEXT T,HOLD
          4720 CONDENABL;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R6 ALUF,Q+1 ALUD,B
          T,NEXT T,HOLD
          4734 CONDENABL;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          ALUD,NONE
          T,JMP T,HOLD
          4632 CONDENABL;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          4734 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          4632;
          A,R7 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,STS B,R4 ALUF,A-B
          T,JMP T,HOLD
          4630 CONDENABL;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,R6 ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          4632 CONDENABL;
          B,Z ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          4734 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          4027;
          A,R5 ALUF,Q-A
          T,NEXT T,HOLD;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,POP
          4632 CONDENABL;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP LCOUNT;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          4632;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD
          4742 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          4770 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          20;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R1 B,R2 ALUF,ZERO ALUD,B,YA
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,COND F,NEXT F,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          4752 CONDENABL;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          377;
          A,P B,R2 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD CYCL,WAIT;
          A,STS B,R4 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R1 B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,R7 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,X ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          B,STS ALUF,ZERO ALUD,B,YA
          COMM,LDGPR T,NEXT T,HOLD;
          A,P B,R4 ALUD,NONE
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          ALUF,INVB ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,X ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUF,ANDAQ
          T,NEXT T,HOLD CYCL,WAIT;
          A,P B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,D B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,A B,R1 ALUF,A ALUD,B STS,EA
          T,JMP T,HOLD
          4773 CONDENABL;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R3 B,B ALUF,PASSA
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,R5 ALUF,PASSQ ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          1740;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD;
          A,T B,R2 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,PUSH;
          B,R2 ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,R2 ALUF,A-Q
          T,NEXT T,HOLD;
          AB,PIE A,R7 B,R3 ALUF,XORAB ALUD,B
          T,NEXT T,HOLD;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          5005 CONDENABL;
          B,R3 ALUF,-B ALUD,B
          T,NEXT T,HOLD;
          A,Z B,R7 ALUD,NONE EN_EXT
          IDBS,ARG COMM,EWRF T,NEXT T,HOLD
          14;
          AB,CURNR A,R3 B,R3 ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,JMP T,HOLD
          5173 CONDENABL;
          AB,DEPOS A,R5 B,R7 ALUF,PASSA
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          5013 CONDENABL;
          A,P B,R1 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5021;
          A,A ALUF,A-1
          T,NEXT T,PUSH;
          ALUF,Q+1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R1 B,LC ALUF,A-Q-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,ANDAQ
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,PUSH
          4044;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,PUSH
          5040;
          A,R1 B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,L B,R4 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,R5 ALUF,A-1
          T,JMP T,PUSH
          5031;
          B,B ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          5050;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,RETURN F,POP;
          ALUD,NONE
          T,NEXT T,PUSH
          0 CONDENABL;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,LC ALUF,D-Q ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          5171 CONDENABL;
          ALUD,NONE
          T,NEXT T,POP LCOUNT;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          5171;
          A,R5 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          5044 CONDENABL;
          B,L ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          B,R7 ALUF,MASKDQ
          IDBS,BARG T,JMP T,HOLD
          5046;
          B,L ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,L B,STS ALUF,PASSA ALUD,NONE
          COMM,EWRF T,RETURN T,POP;
          A,R3 B,L ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,P B,B ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5057 CONDENABL;
          AB,UPPNR A,R3 B,R2 ALUF,PASSA ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R2 ALUF,PASSB ALUD,SRB
          IDBS,ARG COMM,LDGPR T,NEXT T,NEXT MIS,APT T,PUSH
          3;
          B,R5 ALUF,B-1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R2 ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          3;
          A,Z B,LC ALUF,ZERO ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP LCOUNT;
          AB,CURNR A,R3 B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R4 B,STS ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          5102 CONDENABL;
          B,R2 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          17;
          B,R3 ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R5 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,R3 ALUF,PASSB ALUD,SLD
          IDBS,ARG COMM,LDGPR T,NEXT T,NEXT MIS,APT T,HOLD
          2;
          AB,CURNR A,R3 B,R3 ALUF,A-D ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,P B,L ALUF,D-1 ALUD,B
          IDBS,AARG T,NEXT T,PUSH;
          B,R3 ALUF,PASSB ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,PUSH;
          B,R1 ALUF,PASSB ALUD,SLD
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          A,L B,R4 ALUF,B-1 ALUD,B,YA
          COMM,LDLC T,NEXT T,HOLD;
          A,R2 B,R1 ALUF,ORAB ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          B,L ALUF,B-1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          A,R5 B,LC ALUF,D-A-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          B,R2 ALUF,PASSQ ALUD,B
          T,NEXT T,POP
          0 CONDENABL;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,R5 B,STS ALUF,A+B ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          A,STS B,R7 ALUF,A-D-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R2 B,R3 ALUF,INVB ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,PUSH
          5271 CONDENABL;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,STS ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,HOLD
          5270 CONDENABL;
          A,STS B,R7 ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,RETURN F,HOLD;
          B,STS ALUF,PASSA ALUD,NONE
          T,JMP T,POP
          5271 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,PUSH;
          A,R1 B,R7 ALUF,A-D-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,POP;
          B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          5123 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          4027;
          A,R5 ALUF,Q-A
          T,NEXT T,HOLD;
          A,R1 B,R4 ALUF,B-1 ALUD,B,YA
          COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP
          0 CONDENABL;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          5335 CONDENABL;
          A,L B,STS ALUF,PASSD
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R5 ALUF,PASSQ ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,B+1 ALUD,B,YA
          COMM,LDLC T,JMP T,HOLD
          5130 CONDENABL;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5135;
          B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          5134 CONDENABL;
          B,R5 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          5134 CONDENABL;
          ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          5135;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          14;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          5141 CONDENABL;
          B,R7 ALUF,MASKDQ
          IDBS,BARG T,NEXT T,HOLD;
          ALUF,ORAQ
          T,JMP T,HOLD
          5145;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,ORDQ
          IDBS,SWAP T,NEXT T,HOLD;
          A,P B,R2 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          5275 CONDENABL;
          A,X B,R6 ALUF,B-A ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          AB,DUMPF A,R5 B,R6 ALUF,B+1 ALUD,B,YA
          COMM,LDLC T,JMP T,HOLD
          5161 CONDENABL;
          B,R6 ALUF,B-1 ALUD,B
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          AB,DEPOS A,R5 B,R7 ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD CYCL,WAIT
          COND,F15 F,NEXT F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          5160 CONDENABL;
          A,R6 B,X ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          B,R5 ALUF,B+1 ALUD,B
          COMM,LDLC T,NEXT T,POP
          0 CONDENABL;
          B,R6 ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          5161;
          B,Z ALUF,D STS,EA CRY,C
          IDBS,BARG T,RETURN T,POP;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,P B,R4 ALUF,MASKDQ ALUD,NONE
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5164 CONDENABL;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5166 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,P B,R1 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,X B,P ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          4050;
          A,P B,R6 ALUD,NONE STS,LO
          IDBS,REG T,JMP T,POP CYCL,NORM
          20;
          A,R5 ALUF,PASSA
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5202 CONDENABL;
          B,R1 ALUF,B+1
          T,NEXT T,PUSH;
          ALUF,Q-1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A B,LC ALUF,Q-A-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,HOLD LCOUNT CYCL,WAIT;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          4044;
          A,L B,R4 ALUF,PASSB ALUD,B
          COMM,EWRF T,NEXT T,HOLD;
          B,LC ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          B,R7 ALUF,ANDAQ
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,B ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,PUSH
          5040;
          A,B B,R7 ALUF,A-1
          IDBS,BARG COMM,LDLC T,JMP T,PUSH
          5031;
          B,R3 ALUF,-B ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD;
          A,P B,R5 ALUF,D-1 ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          A,R3 B,B ALUF,A-D-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,R7 ALUF,PASSD
          IDBS,BARG T,JMP T,HOLD
          5227 CONDENABL;
          AB,UPPNR A,R3 B,R2 ALUF,PASSA ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R2 ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R2 B,R5 ALUF,B-A ALUD,B
          T,NEXT T,HOLD;
          B,B ALUF,B-1 ALUD,B
          COMM,LDLC T,NEXT T,PUSH
          COND,F=0 F,JMP F,HOLD;
          B,R2 ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          3;
          A,Z B,LC ALUF,ZERO ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,POP LCOUNT;
          B,LC ALUF,PASSD
          IDBS,BARG T,NEXT T,HOLD;
          B,B ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R1 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          5255 CONDENABL;
          B,R3 ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R5 B,L ALUF,PASSA ALUD,B
          COMM,LDLC T,NEXT T,HOLD;
          B,R5 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          B,R3 ALUF,B-1 ALUD,SLB
          T,NEXT T,PUSH;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          AB,EXMOD A,R3 B,R1 ALUF,PASSQ ALUD,B,YA
          COMM,LDLC T,NEXT T,HOLD;
          A,Z B,R7 ALUF,ZERO EN_EXT
          COMM,EWRF T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          B,R1 ALUF,PASSB ALUD,SRD
          T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,L ALUF,PASSB ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          A,R2 ALUF,ORAQ
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,L ALUF,B-1 ALUD,B
          COMM,LDLC T,JMP T,POP
          5261 CONDENABL;
          A,B B,LC ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,R1 B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,POP
          0 CONDENABL;
          A,R2 ALUF,PASSA
          T,NEXT T,PUSH;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R2 ALUF,ZERO
          IDBS,BMG COMM,LDGPR T,JMP T,POP LCOUNT
          5271;
          A,STS B,R4 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          5250 CONDENABL;
          AB,RONLY A,R5 B,R4 ALUF,A-B ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R2 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          5270 CONDENABL;
          A,B B,LC ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,PUSH;
          ALUD,NONE
          T,JMP T,HOLD
          5271 CONDENABL;
          A,Z B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          A,B B,LC ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          5270 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          5271;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,P B,R6 ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,CURNR A,R3 B,R3 ALUF,INVA ALUD,B
          T,JMP T,HOLD
          5123 CONDENABL;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          5305;
          A,R6 B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          A,R5 ALUF,A-1 ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          5161 CONDENABL;
          B,R6 ALUF,PASSB ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          A,R6 B,X ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,POP LCOUNT;
          ALUD,NONE
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5161;
          A,R7 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          5336 CONDENABL;
          B,R1 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          ALUF,MASKDQ
          IDBS,ARG T,NEXT T,HOLD
          17;
          A,R1 B,A ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,L ALUF,ZERO ALUD,NONE STS,EA
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          5123 CONDENABL;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4027;
          A,R5 ALUF,Q-A
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R5 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          5123 CONDENABL;
          A,L B,R4 ALUF,D-1 ALUD,B
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,R5 ALUF,A-1 ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          5335 CONDENABL;
          B,R3 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R5 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          5111 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          5327;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          4027;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUF,Q-A
          T,NEXT T,POP LCOUNT;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          B,Z ALUF,D ALUD,NONE CRY,C
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R5 ALUF,PASSA ALUD,B
          COMM,LDLC T,JMP T,HOLD
          5123 CONDENABL;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          5123;
          B,R1 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          2400;
          A,R1 ALUF,A-D ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,R4 ALUF,ZERO ALUD,NONE STS,EA
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          5123 CONDENABL;
          A,D B,L ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          420;
          AB,WRADR A,R5 B,R1 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4027;
          A,R5 ALUF,Q-A
          T,JMP T,HOLD
          5316;
          B,R5 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,T B,R1 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD
          5355 CONDENABL;
          A,Z B,STS ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          5353 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          20;
          A,B B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,B B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          5403;
          A,B B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,B B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R1 B,R2 ALUF,ZERO ALUD,B,YA
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,COND F,NEXT F,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          5370 CONDENABL;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          377;
          A,D B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          A,P B,R2 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD CYCL,WAIT;
          A,X ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4101;
          ALUF,INVA ALUD,B,YA
          COMM,LDGPR T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,X ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUF,ANDAQ
          T,NEXT T,HOLD CYCL,WAIT;
          A,P B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,P B,R4 ALUD,NONE
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,B B,R2 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,HOLD;
          A,A B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          5412 CONDENABL;
          A,B B,R3 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          60;
          B,R2 ALUF,ZERO ALUD,B
          T,JMP T,PUSH
          4044;
          B,B ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          16;
          A,A B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          B,R4 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          5506;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4054;
          AB,STATUS A,R6 B,R7 ALUF,A+1
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          ALUF,Q-1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A B,LC ALUF,Q-A-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,D ALUF,PASSA ALUD,NONE
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R2 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD
          5424 CONDENABL;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,B ALUF,ORDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,PUSH
          4044;
          B,B ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          16;
          A,R7 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG COMM,LDGPR T,JMP T,HOLD CYCL,NORM
          5432 CONDENABL;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD;
          A,D B,R2 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          L0177;
          A,A B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          AB,RONLY A,R5 B,R4 ALUF,B-1 ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD;
          A,R4 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          5506 CONDENABL;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,R1 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          5510 CONDENABL;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F11 F,NEXT F,HOLD;
          A,R1 B,R2 ALUF,A+B ALUD,B
          T,JMP T,HOLD
          5524 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0173;
          ALUF,D-Q ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 ALUF,A+1 ALUD,B
          T,JMP T,HOLD
          5457 CONDENABL;
          ALUF,D-Q ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          L0175;
          ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          5457 CONDENABL;
          ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          112;
          ALUF,Q-D ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          5461 CONDENABL;
          ALUF,D-Q ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          122;
          A,R1 ALUF,Q-D-1
          IDBS,AARG T,JMP T,HOLD
          5724 CONDENABL;
          A,D ALUF,B+1 ALUD,B
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          5460;
          B,P ALUF,ZERO
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,HOLD
          5470;
          A,STS ALUF,D-Q ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,X B,L ALUF,D+1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5466 CONDENABL;
          A,T ALUF,Q-D ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,L ALUF,A-Q ALUD,NONE
          T,JMP T,HOLD
          5724 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          5724 CONDENABL;
          ALUF,ANDDQ
          IDBS,GPR T,NEXT T,HOLD;
          A,D ALUD,NONE
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          5460;
          A,R4 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,D ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,P B,R1 ALUF,D+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          5502 CONDENABL;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,HOLD
          5476 CONDENABL;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD;
          A,Z B,LC ALUF,ORDQ EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          5533;
          A,D B,R7 ALUF,PASSQ ALUD,B
          IDBS,BMG COMM,LDLC T,NEXT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          A,D B,R1 ALUF,D+1 ALUD,B
          IDBS,AARG T,NEXT T,PUSH;
          B,R7 ALUF,PASSB ALUD,SLB
          T,NEXT T,POP LCOUNT;
          A,R7 ALUF,ORAB ALUD,B
          T,JMP T,HOLD
          5533;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          14;
          A,P B,R1 ALUF,D+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          5533;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG COMM,LDGPR T,NEXT T,HOLD CYCL,NORM
          5513 CONDENABL;
          A,T ALUF,PASSD
          IDBS,AARG T,JMP T,HOLD
          5515;
          ALUD,NONE
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,B ALUF,ORDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          L0177;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F11 F,JMP F,HOLD;
          ALUF,ANDDQ
          IDBS,GPR T,NEXT T,HOLD
          5444 CONDENABL;
          A,Z B,R7 ALUD,NONE EN_EXT
          IDBS,REG COMM,LDGPR T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,P B,R1 ALUF,D+1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          53;
          B,R4 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          5554 CONDENABL;
          ALUF,Q-D ALUD,NONE
          IDBS,ARG T,NEXT T,HOLD
          L0055;
          ALUF,D+1 ALUD,B
          IDBS,GPR T,JMP T,HOLD
          5533 CONDENABL;
          A,L ALUF,Q-D ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          5724 CONDENABL;
          A,R5 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R7 ALUF,MASKDA
          IDBS,BARG T,JMP T,HOLD
          5537 CONDENABL;
          ALUF,ORDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          B,R5 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R1 B,R5 ALUF,A+B ALUD,B
          T,NEXT T,HOLD
          5543 CONDENABL;
          B,R1 ALUF,PASSA ALUD,B
          COMM,LDGPR T,NEXT T,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5553;
          AB,DEPOS A,R5 B,R7 ALUF,A-D-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSB ALUD,NONE
          T,JMP T,HOLD
          5547 CONDENABL;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5553;
          B,R1 ALUF,ZERO ALUD,B
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD;
          ALUF,D-1 ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          17;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R5 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          5615 CONDENABL;
          A,D B,R7 ALUD,NONE EN_EXT
          IDBS,GPR COMM,EWRF T,JMP T,HOLD
          5555;
          ALUF,PASSD ALUD,B
          IDBS,GPR T,JMP T,HOLD
          5533;
          A,B B,STS ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,B B,R7 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,PUSH
          4400;
          A,R2 B,STS ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,X B,R6 ALUF,D+1 ALUD,B
          IDBS,AARG T,JMP T,PUSH
          5632 CONDENABL;
          A,T B,R2 ALUF,PASSB ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R3 ALUF,PASSA
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD
          5576 CONDENABL;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          L0177;
          A,T ALUF,Q-D ALUD,NONE
          IDBS,AARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          AB,STATUS A,R6 B,R7 ALUF,A-Q ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          5703 CONDENABL;
          B,L ALUF,ANDDQ ALUD,B
          IDBS,GPR T,JMP T,HOLD
          5703 CONDENABL;
          AB,WRTYP A,R5 B,R2 ALUF,A-B ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,R2 B,R5 ALUF,A-B-1 ALUD,NONE
          COMM,LDLC T,JMP T,HOLD
          5574 CONDENABL;
          B,L ALUF,PASSB ALUD,SRB
          IDBS,GPR COMM,LDLC T,NEXT T,NEXT MIS,PT T,HOLD
          COND,LC=0 F,JMP F,HOLD;
          B,L ALUF,PASSB ALUD,SRB
          COMM,CLFF T,NEXT T,NEXT MIS,PT T,PUSH;
          A,D B,L ALUF,PASSB ALUD,SLB
          IDBS,AARG COMM,LDGPR T,JMP MIS,PT T,POP LCOUNT
          5603;
          B,L ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,D B,L ALUF,PASSB ALUD,SRB
          IDBS,AARG COMM,LDGPR T,JMP MIS,PT T,POP LCOUNT
          5603;
          A,X ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          ALUF,Q-D ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          AB,CNT10 A,R7 B,R7 ALUF,A-Q ALUD,NONE
          IDBS,BARG T,JMP T,HOLD
          5701 CONDENABL;
          ALUF,ANDDQ
          IDBS,SWAP T,JMP T,HOLD
          5701 CONDENABL;
          B,L ALUF,PASSQ ALUD,B
          T,JMP T,HOLD
          5567;
          AB,NUMBR A,R2 B,R2 ALUF,D+A ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,R3 B,L ALUF,PASSA
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,D+A ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          AB,RONLY A,R5 B,R4 ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,RETURN F,HOLD;
          A,L B,R1 ALUF,ORAB ALUD,B
          COMM,LDGPR T,NEXT T,HOLD
          0 CONDENABL;
          B,R5 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,B-1 ALUD,B,YA
          COMM,LDLC T,JMP T,HOLD
          5615 CONDENABL;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,GPR COMM,EWRF T,RETURN T,HOLD;
          A,R2 B,R7 ALUF,A-D-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,JMP T,HOLD
          5620 CONDENABL;
          A,R3 ALUF,ANDAQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD
          5631 CONDENABL;
          A,B B,R4 ALUF,PASSB ALUD,B,YA
          COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          5641 CONDENABL;
          A,B B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,PUSH
          60;
          A,X ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD
          7577;
          A,Z B,LC ALUF,ANDDQ EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R1 ALUF,XORAQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,POP;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          5631 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          5641;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          5641;
          A,R4 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,B B,R2 ALUF,ZERO ALUD,B,YA
          COMM,LDLC T,JMP T,HOLD
          5640 CONDENABL;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R3 ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          B,B ALUF,B-1 ALUD,B
          T,RETURN T,POP;
          A,B B,R3 ALUF,PASSD ALUD,B
          IDBS,ARG T,RETURN T,POP
          60;
          A,X B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,B B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,A B,R1 ALUF,PASSD ALUD,B
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5671 CONDENABL;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          5660;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5651 CONDENABL;
          A,P B,R4 ALUF,MASKDQ ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          5655 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D B,D ALUF,MASKDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,D B,D ALUF,D+A+1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,P B,R1 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R6 B,P ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          6265;
          A,P B,R2 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,D B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,R1 B,R6 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,RETURN T,POP
          0 CONDENABL;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          A,R1 B,R6 ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R1 ALUF,B-1 ALUD,B
          T,NEXT T,POP LCOUNT;
          ALUD,NONE
          T,RETURN T,POP;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,L B,R1 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5677 CONDENABL;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          B,R7 ALUF,MASKDQ ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          5677 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          6265;
          A,R1 B,D ALUF,MASKAB ALUD,B
          T,NEXT T,HOLD;
          A,D B,D ALUF,D+A+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6265;
          A,X B,STS ALUF,A+B ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,D B,R3 ALUF,MASKDA ALUD,B
          IDBS,SWAP T,JMP T,HOLD
          5705;
          A,X B,STS ALUF,A+B ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          A,D B,R3 ALUF,ORDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,B B,STS ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,L B,R1 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5714 CONDENABL;
          A,STS B,R6 ALUF,A-1 ALUD,B
          T,NEXT T,HOLD;
          A,B B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R3 ALUF,MASKAB ALUD,B
          T,JMP T,HOLD
          5677 CONDENABL;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,A B,R1 ALUF,PASSD ALUD,B
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          5660;
          A,R6 B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          5722 CONDENABL;
          A,R7 ALUF,D-1
          IDBS,BMG T,NEXT T,HOLD;
          A,P B,R4 ALUF,ANDDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,LC ALUF,Q-D ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,L B,R1 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5677 CONDENABL;
          A,R4 B,A ALUF,A+B ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,D ALUF,D+A+1 ALUD,B
          IDBS,BARG T,JMP T,HOLD
          6265;
          A,B B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,L B,R1 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          5677 CONDENABL;
          A,R4 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          A,D ALUF,ANDAQ ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,R7 B,D ALUF,PASSB
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          5735 CONDENABL;
          A,R7 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R6 B,A ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          5734 CONDENABL;
          A,D ALUF,MASKDA
          IDBS,GPR T,JMP T,HOLD
          5735;
          A,D ALUF,ORDA
          IDBS,GPR T,NEXT T,HOLD;
          B,D ALUF,MASKDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0037;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6265;
          B,R5 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,T B,R1 ALUF,ANDDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD
          5744 CONDENABL;
          A,Z B,R4 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          5751 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          20;
          A,B B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,B B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,X B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,T B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4054;
          AB,OCTA2 A,R6 B,R2 ALUF,ZERO ALUD,B,YA
          COMM,RDRQ T,JMP MIS,APT T,HOLD
          5753;
          A,B B,R1 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,B B,R2 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,JMP T,HOLD
          5771;
          A,R7 B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,COND F,NEXT F,HOLD;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          5762 CONDENABL;
          B,R2 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          377;
          A,D B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          A,X B,T ALUF,PASSB ALUD,B,YA
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,P B,R2 ALUF,PASSB ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD
          5765 CONDENABL;
          A,R7 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          ALUF,ANDDA
          IDBS,DBR COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          A,X ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD CYCL,WAIT;
          A,P B,R1 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD CYCL,WAIT;
          A,B B,R2 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,HOLD;
          A,A B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          5777 CONDENABL;
          A,D B,R7 ALUD,NONE EN_EXT
          IDBS,BARG COMM,EWRF T,NEXT T,HOLD;
          B,R3 ALUF,ZERO ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          17;
          A,Z B,STS ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6011;
          B,R3 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          6046;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D B,R2 ALUF,PASSA ALUD,B
          T,JMP T,PUSH
          4065;
          A,R1 B,R7 ALUF,A+1
          IDBS,BARG COMM,LDLC T,NEXT T,PUSH;
          ALUF,Q-1
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A B,LC ALUF,Q-A-1 ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,D B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,D B,R2 ALUF,PASSA ALUD,B
          IDBS,GPR COMM,LDLC T,JMP T,PUSH
          4101;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,ANDAQ
          T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,P ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,PUSH
          4044;
          A,R3 B,P ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,D B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          6017 CONDENABL;
          ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          17;
          B,R7 ALUF,MASKDQ
          IDBS,BARG T,NEXT T,HOLD;
          A,D B,R2 ALUF,D+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6022;
          ALUF,ANDDA ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R7 ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD;
          B,R2 ALUF,D+1 ALUD,B
          IDBS,BARG T,NEXT T,HOLD;
          A,B B,R1 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,HOLD;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          6036 CONDENABL;
          B,R6 ALUF,PASSQ ALUD,NONE
          IDBS,BARG COMM,LDLC T,NEXT T,HOLD
          6027 CONDENABL;
          ALUD,NONE
          T,NEXT T,HOLD
          6033 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          6265;
          B,STS ALUF,B+1 ALUD,B
          T,NEXT T,PUSH
          6033 CONDENABL;
          A,D B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          6033 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          6026;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D B,D ALUF,MASKDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,D B,D ALUF,D+A+1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6265;
          AB,OCTAD A,R5 B,R3 ALUF,PASSQ ALUD,B
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,P B,B ALUF,D-1 ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          6111 CONDENABL;
          A,L B,R1 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD;
          B,R7 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R5 ALUF,A-D ALUD,NONE
          IDBS,BARG COMM,LDGPR T,JMP T,HOLD
          5776 CONDENABL;
          B,D ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          5776 CONDENABL;
          A,R1 ALUF,ORDA
          IDBS,GPR T,NEXT T,HOLD;
          A,P B,R4 ALUF,PASSQ ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          B,R1 ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD;
          AB,BPFLG A,R4 B,R3 ALUF,PASSB
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R2 ALUF,B-1 ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          6111 CONDENABL;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F11 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,HOLD
          6077 CONDENABL;
          A,R3 ALUF,PASSA ALUD,B
          T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,P ALUF,PASSB ALUD,SRB
          IDBS,BMG COMM,LDGPR T,NEXT T,NEXT MIS,APT T,POP LCOUNT;
          B,R7 ALUF,ANDDA
          IDBS,BARG T,NEXT T,HOLD;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          16;
          B,R2 ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,D+A ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          6300 CONDENABL;
          ALUD,NONE
          T,JMP T,PUSH
          6071;
          A,R5 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R1 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          6102 CONDENABL;
          B,R3 ALUF,PASSB
          T,NEXT T,HOLD;
          A,D B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,JMP T,HOLD
          6112;
          A,R1 B,L ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,JMP T,HOLD
          6075 CONDENABL;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,RETURN T,POP
          L0175 CONDENABL;
          B,R1 ALUF,D+Q ALUD,B
          IDBS,ARG T,RETURN T,POP
          111;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,RETURN T,POP
          L0173 CONDENABL;
          A,STS B,R1 ALUF,D+Q ALUD,B
          IDBS,AARG T,RETURN T,POP;
          A,R5 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,D B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,JMP T,HOLD
          6112 CONDENABL;
          A,P B,R4 ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,Z B,R7 ALUD,NONE EN_EXT
          IDBS,SWAP COMM,EWRF T,NEXT T,HOLD;
          B,B ALUF,PASSD ALUD,B
          IDBS,ARG COMM,LDLC T,NEXT T,HOLD
          16;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          16;
          B,R4 ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R3 ALUF,PASSB
          T,JMP T,HOLD
          6160 CONDENABL;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          B,R5 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          6114;
          B,R1 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD;
          A,Z B,R7 ALUD,NONE EN_EXT
          IDBS,GPR COMM,EWRF T,NEXT T,HOLD;
          B,R2 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,PUSH
          16;
          A,R2 B,R4 ALUF,D-A ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          ALUD,NONE
          T,JMP T,PUSH
          6150 CONDENABL;
          A,R2 B,R5 ALUF,A-B ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,R3 B,L ALUF,PASSA ALUD,B
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD
          6125 CONDENABL;
          AB,WRTYP A,R5 B,R2 ALUF,A-B-1 ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          B,L ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,PT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          B,L ALUF,PASSB ALUD,SLB
          T,JMP MIS,PT T,POP LCOUNT
          6130;
          B,L ALUF,PASSB ALUD,SLB
          COMM,CLFF T,NEXT T,NEXT MIS,PT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          B,L ALUF,PASSB ALUD,SRB
          T,NEXT T,NEXT MIS,PT T,POP LCOUNT;
          B,L ALUF,PASSB ALUD,SLB
          T,NEXT T,NEXT MIS,PT T,HOLD;
          A,L ALUF,PASSA
          T,NEXT T,HOLD;
          A,R5 B,L ALUF,PASSA ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,D+A ALUD,B
          IDBS,GPR T,JMP T,HOLD
          6144 CONDENABL;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          L7400;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          5000;
          ALUF,Q-D ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R5 ALUF,ZERO ALUD,B
          T,NEXT T,HOLD
          6302 CONDENABL;
          A,B ALUF,ORDQ
          IDBS,ARG T,NEXT T,HOLD;
          A,R1 ALUF,ORAQ
          T,NEXT T,HOLD;
          A,B B,R4 ALUF,B-1 ALUD,B,YA
          COMM,LDLC T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,B ALUF,B-1 ALUD,B
          T,JMP T,POP
          6161 CONDENABL;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,RETURN T,HOLD;
          ALUF,ANDDQ
          IDBS,ARG T,NEXT T,HOLD
          17;
          B,R2 ALUF,Q-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,D B,R5 ALUF,PASSD ALUD,B
          IDBS,AARG T,NEXT T,HOLD
          6302 CONDENABL;
          B,R1 ALUF,ORDQ ALUD,B
          IDBS,ARG T,RETURN T,HOLD
          60;
          B,STS ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,R2 ALUF,ZERO ALUD,B,YA
          COMM,LDLC T,JMP T,HOLD
          6155 CONDENABL;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          A,D B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          6156;
          ALUF,ZERO
          T,NEXT T,HOLD;
          B,R3 ALUF,PASSQ ALUD,B
          T,RETURN T,POP;
          B,L ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          6165;
          B,R2 ALUF,B+1 ALUD,B
          T,NEXT T,HOLD;
          A,R2 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          A,R2 B,R7 ALUF,A-D-1 ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,LC B,L ALUF,D-1 ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6157 CONDENABL;
          A,L B,R3 ALUF,MASKAB ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,STS ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD
          6175 CONDENABL;
          ALUF,PASSB ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD
          6171 CONDENABL;
          A,R5 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          6177;
          B,STS ALUF,B+1 ALUD,B
          T,NEXT T,PUSH;
          A,D B,LC ALUF,PASSD ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,JMP F,POP;
          B,STS ALUF,B-1 ALUD,B
          T,NEXT T,HOLD
          6175 CONDENABL;
          ALUD,NONE
          T,JMP T,POP LCOUNT
          6170;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          6170;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD
          6243 CONDENABL;
          A,R4 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R3 ALUD,NONE
          IDBS,BMG COMM,LDGPR T,JMP T,HOLD
          6243 CONDENABL;
          A,T ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          B,R3 ALUF,PASSQ ALUD,B
          T,NEXT T,HOLD
          6227 CONDENABL;
          A,P B,R4 ALUD,NONE
          IDBS,REG COMM,LDGPR T,NEXT T,HOLD CYCL,NORM;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          6220 CONDENABL;
          B,R7 ALUF,ANDDQ
          IDBS,BARG T,JMP T,PUSH
          6071;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          377;
          A,R3 ALUF,MASKDA
          IDBS,GPR T,NEXT T,HOLD;
          A,R1 ALUF,ORAQ
          T,NEXT T,HOLD;
          A,B ALUF,A+1 ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          A,X B,R1 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,Z B,LC ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,JMP T,HOLD
          6243;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,SWAP T,NEXT T,HOLD;
          B,R7 ALUF,ANDDQ
          IDBS,BARG T,JMP T,PUSH
          6071;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          377;
          A,R3 ALUF,ANDDA
          IDBS,GPR T,NEXT T,HOLD;
          A,R1 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,ORDQ
          IDBS,SWAP T,JMP T,HOLD
          6215;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          A,STS ALUF,D-1
          IDBS,BMG T,JMP T,HOLD
          6236 CONDENABL;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L7400;
          A,R3 ALUF,ANDDA ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          A,R3 ALUF,ANDAQ
          T,NEXT T,HOLD
          6242 CONDENABL;
          A,P B,R4 ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          ALUF,ORDQ
          IDBS,SWAP T,JMP T,HOLD
          6215;
          ALUF,INVQ
          T,NEXT T,HOLD;
          A,R3 B,R7 ALUF,ANDDA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,PUSH;
          A,R3 ALUF,ANDAQ
          T,NEXT T,HOLD
          6242 CONDENABL;
          A,P B,R4 ALUF,ORDQ
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          6215;
          A,P B,R5 ALUF,ZERO ALUD,NONE
          COMM,EWRF T,RETURN T,POP;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          6267;
          A,P B,R5 ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,HOLD CYCL,NORM
          6253 CONDENABL;
          A,T B,R7 ALUF,PASSA ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          ALUD,NONE
          IDBS,SWAP COMM,LDGPR T,NEXT T,HOLD
          6262 CONDENABL;
          A,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          ALUF,ANDDQ ALUD,NONE
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          ALUF,ANDAQ
          T,JMP T,HOLD
          6262 CONDENABL;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          A,STS ALUF,D-1 ALUD,B
          IDBS,BMG T,NEXT T,HOLD
          6256 CONDENABL;
          ALUF,ANDAQ
          T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          L0037;
          A,D B,D ALUF,MASKDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          B,P ALUF,B-1 ALUD,B
          IDBS,ARG COMM,LDGPR T,NEXT T,HOLD
          3;
          A,D B,D ALUF,ORDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,P B,R1 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,R6 B,P ALUF,B+1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,PUSH CYCL,WAIT
          4050;
          A,P B,R6 ALUD,NONE STS,LO
          IDBS,REG T,JMP T,POP CYCL,NORM
          20;
          A,P B,R2 ALUF,ORDQ
          IDBS,REG T,NEXT T,HOLD CYCL,NORM;
          A,Z B,R7 ALUF,PASSQ ALUD,NONE EN_EXT
          COMM,EWRF T,NEXT T,HOLD;
          AB,OPR A,R6 B,R1 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,NEXT F,PUSH;
          B,R7 ALUD,NONE
          IDBS,BARG COMM,LDLC T,RETURN T,POP
          0 CONDENABL;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          AB,OPR A,R6 B,R1 ALUF,A-B-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,JMP F,HOLD;
          B,R6 ALUF,B-1 ALUD,B
          T,NEXT T,POP LCOUNT;
          ALUD,NONE
          T,RETURN T,POP;
          B,STS ALUD,NONE
          IDBS,BARG COMM,LDGPR T,NEXT T,HOLD;
          AB,OCTNR A,R5 B,R5 ALUF,D+A ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,R2 B,R4 ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,PID A,R7 B,R4 ALUF,PASSB
          IDBS,BMG COMM,LDGPR T,NEXT T,HOLD
          6305 CONDENABL;
          A,D B,R3 ALUF,ORDA ALUD,B
          IDBS,GPR T,JMP T,HOLD
          6306;
          A,D B,R3 ALUF,MASKDA ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,B B,STS ALUF,PASSD ALUD,NONE
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          COND,F=0 F,NEXT F,HOLD;
          A,L B,R7 ALUF,D-1 ALUD,B
          IDBS,AARG T,JMP T,HOLD
          6312 CONDENABL;
          A,X
          T,NEXT T,HOLD;
          B,R1 ALUF,Q-1 ALUD,B
          T,JMP T,HOLD
          6313;
          A,X B,R1 ALUD,B
          T,NEXT T,HOLD;
          AB,PIE A,R7 B,R3 ALUF,MASKAB ALUD,B
          T,NEXT T,HOLD;
          A,Z B,R7 ALUF,PASSD EN_EXT
          IDBS,REG T,JMP T,PUSH CYCL,NORM
          6267;
          A,R1 B,X ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          A,Z B,LC ALUF,PASSD EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,NORM
          6323 CONDENABL;
          A,T ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          6323 CONDENABL;
          A,R5 B,STS ALUF,A-D ALUD,NONE
          IDBS,BARG T,NEXT T,HOLD
          COND,F=0 F,JMP F,HOLD;
          ALUD,NONE
          T,NEXT T,HOLD
          6033 CONDENABL;
          A,STS B,A ALUF,A+B ALUD,B
          T,NEXT T,HOLD;
          A,R3 B,D ALUF,D+A+1 ALUD,B
          IDBS,BARG T,JMP T,HOLD
          6265;
L6325:
          B,R2 ALUF,PASSD ALUD,B
          IDBS,GPR COMM,LDLC T,NEXT T,HOLD CYCL,WAIT
          COND,LC=0 F,JMP F,HOLD;
          A,D B,R1 ALUF,A ALUD,B STS,EA
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          A,A B,R7 ALUF,PASSA ALUD,B
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          B,R7 ALUF,B ALUD,B CRY,C
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R1 B,R1 ALUF,A+1 ALUD,B,YA STS,EA
          COMM,IRDRQ T,NEXT T,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,DBR COMM,EWRF T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,B B,R1 ALUF,PASSA ALUD,B
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          AB,EXMOD A,R3 B,R1 ALUD,NONE
          IDBS,REG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R2 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,PUSH
          COND,LC=0 F,JMP F,HOLD;
          A,R1 B,R1 ALUF,A+1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,Z B,LC ALUD,NONE EN_EXT
          IDBS,REG T,NEXT T,HOLD CYCL,WAIT;
          A,R2 B,R7 ALUF,ANDDA
          IDBS,BARG T,NEXT T,POP LCOUNT CYCL,WAIT;
          A,L B,D ALUF,A+B ALUD,B STS,EA
          T,NEXT T,HOLD;
          B,A ALUF,B ALUD,B CRY,C
          T,NEXT T,HOLD;
          A,B B,B ALUF,A+Q+1 ALUD,B STS,EA
          T,NEXT T,HOLD;
          B,X ALUF,B+1 ALUD,B
          T,NEXT T,HOLD
          COND,F15 F,NEXT F,HOLD;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,HOLD
          20 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,HOLD
          20;
L6350:
          A,A ALUF,A+1
          IDBS,DBR COMM,LDGPR T,JMP0-3 T,HOLD CYCL,WAIT
          7360;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUF,ZERO ALUD,NONE
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          6413;
          B,R1 ALUF,B+1 ALUD,B
          COMM,IRDRQ T,JMP T,PUSH
          6425;
          B,R1 ALUF,B+1 ALUD,B
          COMM,IRDRQ T,NEXT T,HOLD;
          B,D ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,B ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R7 B,A ALUF,MASKAB ALUD,B
          T,NEXT T,HOLD CYCL,WAIT;
          A,B ALUF,A+1 ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD
          COND,IRQ F,JMP F,HOLD;
          A,D ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          6415 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,POP
          6423;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD;
          A,D B,D ALUF,A+B
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          B,R4 ALUF,ANDDQ ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          600;
          ALUF,ZERO ALUD,NONE
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          6413;
          A,B ALUF,PASSA
          COMM,RDRQ T,JMP MIS,APT T,PUSH
          6425;
          A,A B,R7 ALUF,ANDAB ALUD,NONE
          T,JMP T,HOLD
          6415 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          COMM,DERQ T,NEXT T,HOLD
          COND,COND F,NEXT F,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,R4 ALUF,Q-A
          T,JMP T,HOLD CYCL,WAIT
          6410 CONDENABL;
          B,R3 ALUF,ANDDQ ALUD,SRB
          IDBS,ARG T,NEXT T,HOLD
          36;
          B,R6 ALUF,ANDDQ ALUD,SLB
          IDBS,ARG T,NEXT T,HOLD
          L0740;
          AB,PRCHR A,R6 B,R6 ALUF,A+B ALUD,SLB
          T,NEXT T,HOLD;
          B,R6 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD;
          A,L B,R6 ALUF,D+A ALUD,B
          IDBS,SWAP T,NEXT T,HOLD;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,IRDRQ T,NEXT T,HOLD;
          A,R3 ALUF,PASSA ALUD,NONE
          COMM,LDLC T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,LC ALUF,ORDQ
          IDBS,BMG T,NEXT T,HOLD;
          A,R6 ALUF,PASSA ALUD,NONE
          COMM,DERQ T,NEXT T,HOLD;
          ALUF,PASSQ ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,NEXT T,HOLD CYCL,WAIT;
          A,B ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD
          COND,IRQ F,JMP F,HOLD;
          ALUF,ZERO ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          6415 CONDENABL;
          B,P ALUF,B-1 ALUD,B
          T,JMP T,POP
          6423;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          A,T ALUF,PASSA ALUD,NONE
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,X B,R1 ALUF,PASSA ALUD,B
          COMM,IRDRQ T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          B,X ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          6423 CONDENABL;
          B,R1 ALUF,B+1 ALUD,B
          COMM,IRDRQ T,NEXT T,HOLD;
          B,B ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,B B,B ALUF,A+B
          T,NEXT T,HOLD;
          A,R7 B,B ALUF,ORDQ ALUD,B
          IDBS,ARG T,RETURN T,HOLD
          7000;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          AB,EXMOD A,R3 B,R1 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,POP CYCL,SLOW
          26;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,RETURN T,POP CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,GPR T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,POP CYCL,WAIT
          26 CONDENABL;
          B,R7 ALUF,ANDDQ ALUD,SLB
          IDBS,ARG T,NEXT T,HOLD
          300;
          AB,CDIGI A,R7 B,R1 ALUF,D+A ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          7000;
          A,X ALUF,PASSA
          T,NEXT T,HOLD;
          B,R2 ALUF,D+Q ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          25;
          A,T B,R3 ALUD,B
          T,NEXT T,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,A+1 ALUD,B,YA
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R4 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R7 ALUF,PASSA
          IDBS,BARG COMM,LDLC T,JMP T,HOLD
          6453 CONDENABL;
          A,Z B,R6 ALUF,PASSD ALUD,B
          IDBS,BMG T,NEXT T,HOLD;
          B,P ALUF,PASSD
          IDBS,BARG T,NEXT T,PUSH
          COND,F=0 F,NEXT F,HOLD;
          AB,BRKPT A,R4 B,R6 ALUF,ANDAB ALUD,NONE
          T,JMP T,PUSH
          6450;
          B,R6 ALUF,PASSB ALUD,SLB
          T,NEXT T,POP LCOUNT
          COND,F=0 F,NEXT F,HOLD;
          AB,UPPNR A,R3 B,R2 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD
          COND,F15 F,JMP F,HOLD;
          AB,NUMBR A,R2 B,R2 ALUF,A+1 ALUD,B,YA
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD
          6437 CONDENABL;
          A,R5 ALUF,PASSA ALUD,NONE
          COMM,LDGPR T,JMP T,POP CYCL,WAIT
          26;
          A,R1 B,R1 ALUD,B
          T,RETURN T,POP
          COND,LC=0 F,JMP F,HOLD CONDENABL;
          A,R1 ALUF,A-Q ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,ZERO ALUD,NONE
          T,RETURN T,POP CYCL,WAIT;
          A,A B,R1 ALUF,D+Q ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6445;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUF,ZERO ALUD,NONE
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          122;
          A,D B,R6 ALUF,PASSA ALUD,B
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,X B,R7 ALUF,PASSA ALUD,B
          COMM,IRDRQ T,NEXT T,HOLD;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          A,T B,R1 ALUF,B+1 ALUD,B,YA
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          6475 CONDENABL;
          A,R1 ALUF,A+1 ALUD,NONE
          COMM,IRDRQ T,NEXT T,HOLD;
          A,R4 ALUF,ANDDA ALUD,NONE
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,R1 ALUF,A-1 ALUD,B
          COMM,IRDRQ T,JMP T,HOLD
          6473 CONDENABL;
          B,R2 ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R6 B,D ALUF,PASSA ALUD,B
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,R7 B,A ALUF,PASSA ALUD,B
          COMM,DERQ T,NEXT T,HOLD;
          A,R2 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,R1 B,X ALUF,PASSA ALUD,B
          T,JMP T,HOLD CYCL,WAIT
          6423;
          A,T B,R6 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          A,R1 B,R7 ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          6461;
          B,P ALUF,B+1 ALUD,B
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          AB,EXMOD A,R3 B,R1 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,HOLD CYCL,SLOW
          20;
L6477:
          A,R3 ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD;
          A,L ALUF,A-Q-1 ALUD,NONE
          T,NEXT T,HOLD
          COND,CRY F,NEXT F,HOLD;
          ALUD,NONE
          T,RETURN T,HOLD
          COND,F=0 F,JMP F,HOLD CONDENABL;
          A,L ALUF,PASSA ALUD,NONE
          T,JMP0-3 T,HOLD
          7340;
          A,D ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6572;
          A,T ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6572;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6601;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6611;
          A,D ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6572;
          A,T ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6573;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6601;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6614;
          ALUF,Q+1 ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          COND,RESTR F,NEXT F,HOLD;
          A,X ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          L0030 CONDENABL;
          A,D ALUF,PASSA
          T,JMP T,PUSH
          6572;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUD,NONE
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6601;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6617;
          A,D ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6573;
          A,T ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6572;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6602;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6611;
          A,D ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6573;
          A,T ALUF,PASSA
          T,JMP T,PUSH CYCL,WAIT
          6573;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6602;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6614;
          ALUF,Q+1 ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          COND,RESTR F,NEXT F,HOLD;
          A,X ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          L0030 CONDENABL;
          A,D ALUF,PASSA
          T,JMP T,PUSH
          6573;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUD,NONE
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6602;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6617;
          ALUF,Q+1 ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          COND,RESTR F,NEXT F,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          L0030 CONDENABL;
          A,T ALUF,PASSA
          T,JMP T,PUSH
          6572;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUD,NONE
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6603;
          B,A ALUF,B ALUD,B CRY,C
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          6611;
          ALUF,Q+1 ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          COND,RESTR F,NEXT F,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          L0030 CONDENABL;
          A,T ALUF,PASSA
          T,JMP T,PUSH
          6573;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUD,NONE
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          ALUD,NONE
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6603;
          B,A ALUF,B ALUD,B CRY,C
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          6614;
          ALUF,Q+1 ALUD,NONE
          COMM,LDIR T,NEXT T,HOLD CYCL,WAIT
          COND,RESTR F,NEXT F,PUSH;
          ALUD,NONE
          T,JMP T,HOLD
          L0030 CONDENABL;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          ALUD,NONE
          IDBS,ARG COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,PUSH CYCL,SLOW
          122;
          A,A ALUF,PASSA ALUD,NONE
          COMM,XMM T,JMP T,PUSH CYCL,SLOW
          6603;
          A,X B,A ALUF,B ALUD,B,YA CRY,C
          COMM,XMM T,JMP T,HOLD CYCL,SLOW
          6617;
          ALUF,PASSQ ALUD,NONE
          COMM,RDRQ T,JMP MIS,PT T,HOLD
          6574;
          ALUF,PASSQ ALUD,NONE
          COMM,RDRQ T,JMP MIS,APT T,HOLD
          6574;
          A,L B,R2 ALUF,PASSA ALUD,SRB
          IDBS,DBR T,NEXT T,NEXT MIS,APT T,HOLD CYCL,WAIT;
          A,R2 ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,HOLD T,HOLD;
          A,L B,R2 ALUF,A-1 ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R2 ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,HOLD T,HOLD
          COND,IRQ F,RETURN F,POP;
          ALUD,NONE
          IDBS,DBR T,RETURN T,HOLD CYCL,WAIT;
          A,D B,D ALUF,B+1 ALUD,B,YA
          COMM,RDRQ T,JMP MIS,PT T,HOLD
          6605 CONDENABL;
          A,D B,D ALUF,B+1 ALUD,B,YA
          COMM,RDRQ T,JMP MIS,APT T,HOLD
          6605 CONDENABL;
          A,D B,D ALUF,B+1 ALUD,B,YA STS,EA
          COMM,IRDRQ T,NEXT T,HOLD
          COND,IRQ F,RETURN F,POP;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,HOLD CYCL,WAIT
          6605 CONDENABL;
          B,D ALUF,B-1 ALUD,B
          T,NEXT T,HOLD CYCL,WAIT;
          B,P ALUF,B-1 ALUD,B
          T,NEXT T,HOLD;
          ALUD,NONE
          IDBS,ARG COMM,LDIR T,NEXT T,HOLD CYCL,SLOW
          121;
          AB,EXMOD A,R3 B,R1 ALUD,NONE
          IDBS,REG COMM,XMM T,JMP T,HOLD CYCL,SLOW
          20;
          A,T B,L ALUF,B-1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,PT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,R1 B,T ALUF,B+1 ALUD,B,YA
          T,NEXT T,HOLD CYCL,WAIT
          COND,IRQ F,RETURN F,POP CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          6607;
          A,T B,L ALUF,B-1 ALUD,B,YA
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,R1 B,T ALUF,B+1 ALUD,B,YA
          T,NEXT T,HOLD CYCL,WAIT
          COND,IRQ F,RETURN F,POP CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD CYCL,WAIT
          6607;
          A,T B,L ALUF,B-1 ALUD,B,YA
          COMM,DERQ T,NEXT T,HOLD
          COND,F=0 F,RETURN F,HOLD;
          A,R1 B,T ALUF,B+1 ALUD,B,YA STS,EA
          T,NEXT T,HOLD CYCL,WAIT
          COND,COND F,RETURN F,HOLD;
          B,X ALUF,B ALUD,B CRY,C
          COMM,XMM T,NEXT T,HOLD CYCL,WAIT
          COND,IRQ F,RETURN F,POP CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          6607;
          B,R3 ALUD,NONE
          IDBS,BARG COMM,LDIR T,JMP T,PUSH CYCL,SLOW
          6632;
          A,T ALUF,PASSA ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUF,A-1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          26;
          B,R3 ALUD,NONE
          IDBS,BARG COMM,LDIR T,JMP T,PUSH CYCL,SLOW
          6632;
          A,T ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          ALUD,NONE
          T,JMP T,POP CYCL,WAIT
          26;
          ALUD,NONE
          COMM,XMM T,NEXT T,HOLD CYCL,SLOW;
          A,T ALUF,PASSA ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,A ALUF,PASSD ALUD,B
          IDBS,DBR T,RETURN T,POP CYCL,WAIT;
          A,P B,R1 ALUF,A+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0176;
          A,B B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6664;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0172;
          B,R7 ALUF,D+Q ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6673;
          ALUF,PASSD
          IDBS,STS T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,B+1 ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,PT T,HOLD;
          ALUF,XORDQ
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,Z ALUF,ANDDQ ALUD,NONE
          IDBS,BMG T,NEXT T,HOLD
          COND,F=0 F,NEXT F,HOLD;
          A,R1 B,P ALUF,A+1 ALUD,B
          T,JMP T,HOLD
          6661 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          6715;
          B,R6 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0176;
          A,B B,R6 ALUF,A-B ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,B B,R2 ALUF,PASSA ALUD,B
          T,NEXT T,HOLD;
          ALUF,PASSD
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6664;
          A,R2 B,R4 ALUF,A-B ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R5 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD
          L0172;
          B,R7 ALUF,PASSD ALUD,B
          IDBS,DBR T,JMP T,PUSH CYCL,WAIT
          6673;
          AB,PIE A,R7 B,R3 ALUF,A-B ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT
          COND,CRY F,JMP F,POP;
          B,P ALUF,B+1 ALUD,B
          T,NEXT T,HOLD
          6715 CONDENABL;
          B,P ALUF,B+1 ALUD,B
          T,JMP T,POP
          6715;
          ALUF,PASSQ ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,L ALUF,B+1 ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,X B,STS ALUF,D+Q ALUD,B
          IDBS,BMG T,NEXT T,HOLD CYCL,WAIT;
          AB,TXT2 A,R6 B,R3 ALUF,A+1 ALUD,B
          T,NEXT T,HOLD;
          A,STS B,R3 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,R2 ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          AB,TXT1 A,R6 B,R4 ALUF,A-1 ALUD,B
          T,RETURN T,POP CYCL,WAIT;
          A,STS B,R4 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,R7 ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          A,R5 ALUF,D-A
          IDBS,GPR T,NEXT T,HOLD CYCL,WAIT;
          A,STS B,R6 ALUF,A-B ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,STS B,R3 ALUD,B
          T,RETURN T,POP CYCL,WAIT;
          A,X ALUF,PASSD
          IDBS,BMG T,NEXT T,HOLD CYCL,WAIT;
          A,B ALUF,A-Q
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,D-1 ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSQ ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSB ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          ALUF,PASSD
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          L0173;
          A,B ALUF,A-Q ALUD,NONE
          COMM,WRRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          A,A ALUF,PASSA ALUD,NONE
          T,NEXT T,HOLD CYCL,WAIT;
          B,R1 ALUF,PASSD ALUD,B
          IDBS,ARG T,NEXT T,HOLD CYCL,WAIT
          L0177;
          A,B B,R1 ALUF,A-B ALUD,B
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,STS ALUF,PASSD ALUD,B
          IDBS,DBR T,NEXT T,HOLD CYCL,WAIT;
          A,R1 ALUF,A-1 ALUD,NONE
          COMM,RDRQ T,NEXT T,NEXT MIS,APT T,HOLD;
          B,P ALUF,PASSD ALUD,B
          IDBS,DBR COMM,LDGPR T,JMP T,POP CYCL,WAIT
          6715;
          A,STS B,B ALUF,PASSA ALUD,B
          T,JMP T,HOLD
          20;

7340/
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6503 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6507 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6513 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6523 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6527 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6533 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6543 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6553 CONDENABL;
          A,R2 ALUF,D+1
          IDBS,AARG T,RETURN T,HOLD CYCL,WAIT
          6563 CONDENABL;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          A,R3 B,R7 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6351;
          B,R7 ALUF,ZERO ALUD,B
          T,JMP T,HOLD
          6364;
          ALUF,Q+1 ALUD,NONE
          COMM,RDRQ T,JMP T,HOLD
          6426;
          AB,SINGL A,R4 B,R4 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6454;
          A,R3 B,R7 ALUF,PASSD ALUD,B
          IDBS,BMG T,JMP T,HOLD
          6363;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7400:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7402:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7403:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7404:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7405:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7406:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7407:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7410:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7411:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
L7412:
          ALUD,NONE
          T,JMP T,HOLD
          L0027;
