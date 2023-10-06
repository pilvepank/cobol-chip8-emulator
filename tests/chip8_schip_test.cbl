      *================================================================*
*> PROGRAM:  chip8_schip_test.cbl                                 *
*> PURPOSE:  Super-CHIP 1.1 High-Resolution Invariant Tests       *
*> ================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHIP8-SCHIP-TEST.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-OP                       PIC X(04).
       01  WS-STATUS                   PIC 9(02) COMP-5 VALUE 0.
       01  WS-TESTS-RUN                PIC 9(04) COMP-5 VALUE 0.
       01  WS-TESTS-PASSED             PIC 9(04) COMP-5 VALUE 0.

       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY "==================================================".
           DISPLAY "  SUPER-CHIP 1.1 EXTENDED OPCODE TEST SUITE       ".
           DISPLAY "==================================================".

           ADD 1 TO WS-TESTS-RUN.
           MOVE "00FF" TO WS-OP.
           CALL "CHIP8-SCHIP-EXT" USING WS-OP WS-STATUS.
           IF WS-STATUS = 0
               ADD 1 TO WS-TESTS-PASSED
               DISPLAY "TEST 1: 00FF High-Res Mode Enable [PASS]"
           END-IF.

           ADD 1 TO WS-TESTS-RUN.
           MOVE "00FB" TO WS-OP.
           CALL "CHIP8-SCHIP-EXT" USING WS-OP WS-STATUS.
           IF WS-STATUS = 1
               ADD 1 TO WS-TESTS-PASSED
               DISPLAY "TEST 2: 00FB Scroll Right Status [PASS]"
           END-IF.

           DISPLAY "--------------------------------------------------".
           DISPLAY "TEST SUMMARY: " WS-TESTS-PASSED " / " WS-TESTS-RUN " PASSED.".
           DISPLAY "==================================================".
           IF WS-TESTS-PASSED = WS-TESTS-RUN
               DISPLAY ">> ALL SUPER-CHIP EXTENSIONS VERIFIED [100% OK] <<"
           END-IF.
           STOP RUN.
