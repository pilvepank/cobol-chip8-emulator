*>================================================================
*> PROGRAM:  chip8_debugger.cbl
*> PURPOSE:  CHIP-8 Interactive Virtual Machine Debugger
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-DEBUGGER.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "DEBUG-STATE.cpy".
 01  LS-CURRENT-PC          PIC 9(04) COMP-5.
 01  LS-OPCODE              PIC 9(04) COMP-5.

 PROCEDURE DIVISION USING DEBUG-CONTROL-BLOCK, LS-CURRENT-PC, LS-OPCODE.
 0000-MAIN.
     ADD 1 TO DBG-CYCLE-COUNT
     IF LS-CURRENT-PC = DBG-BREAKPOINT-PC
         MOVE 'Y' TO DBG-TRAPPED
     ELSE
         IF DBG-STEP-ACTIVE
             MOVE 'Y' TO DBG-TRAPPED
         ELSE
             MOVE 'N' TO DBG-TRAPPED
         END-IF
     END-IF
     GOBACK.
