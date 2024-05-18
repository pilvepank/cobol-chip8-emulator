*>================================================================
*> PROGRAM:  chip8_rewind_test.cbl
*> PURPOSE:  Unit Test Suite for CHIP-8 Time-Travel Rewind Engine
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-REWIND-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "REWIND-STATE.cpy".
 01  WS-OP                  PIC X(01) VALUE 'P'.
 01  WS-IN-PC               PIC 9(04) COMP-5 VALUE 512.
 01  WS-OUT-PC              PIC 9(04) COMP-5 VALUE 0.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 TIME-TRAVEL REWIND ENGINE TEST SUITE     "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 512 TO WS-IN-PC
     MOVE 'P' TO WS-OP
     CALL "CHIP8-REWIND-ENGINE" USING REWIND-RING-BUFFER, WS-OP, WS-IN-PC, WS-OUT-PC
     
     MOVE 514 TO WS-IN-PC
     CALL "CHIP8-REWIND-ENGINE" USING REWIND-RING-BUFFER, WS-OP, WS-IN-PC, WS-OUT-PC
     
     MOVE 'R' TO WS-OP
     CALL "CHIP8-REWIND-ENGINE" USING REWIND-RING-BUFFER, WS-OP, WS-IN-PC, WS-OUT-PC
     IF WS-OUT-PC = 514 AND RW-SAVED-FRAMES = 1
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Rewind Most Recent Execution Frame [PASS]"
     ELSE
         DISPLAY "TEST 1: Rewind Most Recent Execution Frame [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     CALL "CHIP8-REWIND-ENGINE" USING REWIND-RING-BUFFER, WS-OP, WS-IN-PC, WS-OUT-PC
     IF WS-OUT-PC = 512 AND RW-SAVED-FRAMES = 0
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Rewind to Initial Inception State [PASS]"
     ELSE
         DISPLAY "TEST 2: Rewind to Initial Inception State [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Rewind Tests Run:    " WS-TESTS-RUN
     DISPLAY "Rewind Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL REWIND TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME REWIND TESTS FAILED <<"
     END-IF
     STOP RUN.
