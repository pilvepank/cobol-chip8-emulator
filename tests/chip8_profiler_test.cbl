*>================================================================
*> PROGRAM:  chip8_profiler_test.cbl
*> PURPOSE:  Unit Test Suite for CHIP-8 CPU Opcode Profiler
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-PROFILER-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "PROFILER-STATE.cpy".
 01  WS-NIBBLE              PIC 9(02) COMP-5 VALUE 0.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 CPU PROFILER TEST SUITE                  "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 0 TO PRF-TOTAL-INSTRUCTIONS
     MOVE 0 TO PRF-TOTAL-CYCLES
     MOVE 1 TO WS-NIBBLE
     CALL "CHIP8-PROFILER" USING PROFILER-STATE-BLOCK, WS-NIBBLE
     CALL "CHIP8-PROFILER" USING PROFILER-STATE-BLOCK, WS-NIBBLE
     IF PRF-TOTAL-INSTRUCTIONS = 2 AND PRF-OP-EXEC-COUNT(2) = 2
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Opcode Family Jump 1NNN Counter [PASS]"
     ELSE
         DISPLAY "TEST 1: Opcode Family Jump 1NNN Counter [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 6 TO WS-NIBBLE
     CALL "CHIP8-PROFILER" USING PROFILER-STATE-BLOCK, WS-NIBBLE
     IF PRF-TOTAL-INSTRUCTIONS = 3 AND PRF-OP-EXEC-COUNT(7) = 1
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Opcode Family Set 6XNN Counter [PASS]"
     ELSE
         DISPLAY "TEST 2: Opcode Family Set 6XNN Counter [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Profiler Tests Run:    " WS-TESTS-RUN
     DISPLAY "Profiler Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL PROFILER TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME PROFILER TESTS FAILED <<"
     END-IF
     STOP RUN.
