*>================================================================
*> PROGRAM:  chip8_profiler.cbl
*> PURPOSE:  Opcode Family Instruction Counter & Execution Metrics
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-PROFILER.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01  WS-SLOT                PIC 9(02) COMP-5 VALUE 1.

 LINKAGE SECTION.
 COPY "PROFILER-STATE.cpy".
 01  LS-OPCODE-HIGH-NIBBLE  PIC 9(02) COMP-5.

 PROCEDURE DIVISION USING PROFILER-STATE-BLOCK, LS-OPCODE-HIGH-NIBBLE.
 0000-MAIN.
     ADD 1 TO PRF-TOTAL-INSTRUCTIONS
     ADD 1 TO PRF-TOTAL-CYCLES
     IF LS-OPCODE-HIGH-NIBBLE >= 0 AND LS-OPCODE-HIGH-NIBBLE <= 15
         COMPUTE WS-SLOT = LS-OPCODE-HIGH-NIBBLE + 1
         ADD 1 TO PRF-OP-EXEC-COUNT(WS-SLOT)
     END-IF
     GOBACK.
