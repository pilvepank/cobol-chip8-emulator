*>================================================================
*> PROGRAM:  chip8_loader_test.cbl
*> PURPOSE:  Test Harness for CHIP-8 Binary ROM Loader
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-LOADER-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "LOADER-STATE.cpy".
 01  WS-SIZE                PIC 9(06) COMP-5 VALUE 0.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 ROM LOADER VALIDATION TEST SUITE         "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 512 TO WS-SIZE
     CALL "CHIP8-ROM-LOADER" USING ROM-LOADER-BLOCK, WS-SIZE
     IF RL-STATUS-OK
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Valid 512-Byte ROM Mapping [PASS]"
     ELSE
         DISPLAY "TEST 1: Valid 512-Byte ROM Mapping [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 4000 TO WS-SIZE
     CALL "CHIP8-ROM-LOADER" USING ROM-LOADER-BLOCK, WS-SIZE
     IF RL-FILE-TOO-LARGE
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Oversized ROM > 3584 Bytes Rejected [PASS]"
     ELSE
         DISPLAY "TEST 2: Oversized ROM > 3584 Bytes Rejected [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Loader Tests Run:    " WS-TESTS-RUN
     DISPLAY "Loader Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL LOADER TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME LOADER TESTS FAILED <<"
     END-IF
     STOP RUN.
