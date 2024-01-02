*>================================================================
*> PROGRAM:  chip8_debug_test.cbl
*> PURPOSE:  Test Harness for CHIP-8 Debugger
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-DEBUG-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "DEBUG-STATE.cpy".
 01  WS-PC                  PIC 9(04) COMP-5 VALUE 512.
 01  WS-OPCODE              PIC 9(04) COMP-5 VALUE 0.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 DEBUGGER & TRAP TEST SUITE               "
     DISPLAY "=================================================="
     
     *> Test 1: Breakpoint Trigger
     ADD 1 TO WS-TESTS-RUN
     MOVE 520 TO DBG-BREAKPOINT-PC
     MOVE 512 TO WS-PC
     CALL "CHIP8-DEBUGGER" USING DEBUG-CONTROL-BLOCK, WS-PC, WS-OPCODE
     IF DBG-TRAPPED = 'N'
         MOVE 520 TO WS-PC
         CALL "CHIP8-DEBUGGER" USING DEBUG-CONTROL-BLOCK, WS-PC, WS-OPCODE
         IF DBG-IS-TRAPPED
             ADD 1 TO WS-TESTS-PASSED
             DISPLAY "TEST 1: Breakpoint PC Trigger [PASS]"
         ELSE
             DISPLAY "TEST 1: Breakpoint PC Trigger [FAIL]"
         END-IF
     ELSE
         DISPLAY "TEST 1: Breakpoint PC Trigger [FAIL]"
     END-IF
     
     DISPLAY "--------------------------------------------------"
     DISPLAY "Debug Tests Run:    " WS-TESTS-RUN
     DISPLAY "Debug Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL DEBUGGER TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME DEBUGGER TESTS FAILED <<"
     END-IF
     STOP RUN.
