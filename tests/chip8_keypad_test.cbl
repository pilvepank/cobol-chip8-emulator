*>================================================================
*> PROGRAM:  chip8_keypad_test.cbl
*> PURPOSE:  Test Harness for CHIP-8 16-Key Matrix
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-KEYPAD-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "KEYPAD-MAP.cpy".
 01  WS-KEY                 PIC 9(02) COMP-5 VALUE 5.
 01  WS-ACT                 PIC X(01) VALUE 'D'.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 16-KEY MATRIX INPUT TEST SUITE           "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 'Y' TO KP-WAITING-KEYPRESS
     MOVE 5 TO WS-KEY
     MOVE 'D' TO WS-ACT
     CALL "CHIP8-KEYPAD" USING KEYPAD-MATRIX-STATE, WS-KEY, WS-ACT
     IF KEY-IS-DOWN(5) = 'Y' AND KP-WAITING-KEYPRESS = 'N'
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Keypress 0x5 Unblocks Wait Loop [PASS]"
     ELSE
         DISPLAY "TEST 1: Keypress 0x5 Unblocks Wait Loop [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 'U' TO WS-ACT
     CALL "CHIP8-KEYPAD" USING KEYPAD-MATRIX-STATE, WS-KEY, WS-ACT
     IF KEY-IS-DOWN(5) = 'N'
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Key Release Invariant Verified [PASS]"
     ELSE
         DISPLAY "TEST 2: Key Release Invariant Verified [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Keypad Tests Run:    " WS-TESTS-RUN
     DISPLAY "Keypad Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL KEYPAD TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME KEYPAD TESTS FAILED <<"
     END-IF
     STOP RUN.
