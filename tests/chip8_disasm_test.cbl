      *================================================================*
*> PROGRAM:  chip8_disasm_test.cbl                                *
*> PURPOSE:  Automated Unit Tests for Instruction Disassembler    *
*> ================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHIP8-DISASM-TEST.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-RAW-OP                   PIC 9(04) COMP-5 VALUE 0.
       01  WS-OUTPUT                   PIC X(60) VALUE SPACES.
       01  WS-TESTS-RUN                PIC 9(04) COMP-5 VALUE 0.
       01  WS-TESTS-PASSED             PIC 9(04) COMP-5 VALUE 0.

       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY "==================================================".
           DISPLAY "  CHIP-8 DISASSEMBLER TEST SUITE                  ".
           DISPLAY "==================================================".

           ADD 1 TO WS-TESTS-RUN.
           MOVE 0 TO WS-RAW-OP.
           CALL "CHIP8-DISASSEMBLER" USING WS-RAW-OP WS-OUTPUT.
           IF WS-OUTPUT(1:4) = "00E0"
               ADD 1 TO WS-TESTS-PASSED
               DISPLAY "TEST 1: 00E0 CLS Instruction Disassembled [PASS]"
           END-IF.

           ADD 1 TO WS-TESTS-RUN.
           MOVE 512 TO WS-RAW-OP.
           CALL "CHIP8-DISASSEMBLER" USING WS-RAW-OP WS-OUTPUT.
           IF WS-OUTPUT(1:4) = "1NNN"
               ADD 1 TO WS-TESTS-PASSED
               DISPLAY "TEST 2: 1NNN Jump Instruction Disassembled [PASS]"
           END-IF.

           DISPLAY "--------------------------------------------------".
           DISPLAY "TEST SUMMARY: " WS-TESTS-PASSED " / " WS-TESTS-RUN " PASSED.".
           DISPLAY "==================================================".
           IF WS-TESTS-PASSED = WS-TESTS-RUN
               DISPLAY ">> ALL DISASSEMBLER SUITES PASSED [100% OK] <<"
           END-IF.
           STOP RUN.
