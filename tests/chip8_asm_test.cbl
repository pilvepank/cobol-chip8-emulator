*>================================================================
*> PROGRAM:  chip8_asm_test.cbl
*> PURPOSE:  Test Harness for CHIP-8 Assembler
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-ASM-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "ASM-TABLES.cpy".
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 BYTECODE ASSEMBLER TEST SUITE            "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE "CLS                             " TO ASM-SOURCE-LINE
     CALL "CHIP8-ASSEMBLER" USING ASM-INSTRUCTION-BUFFER
     IF ASM-SUCCESS AND ASM-OPCODE-HEX = "00E0"
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Assemble CLS Opcode (0x00E0) [PASS]"
     ELSE
         DISPLAY "TEST 1: Assemble CLS Opcode (0x00E0) [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     MOVE "RET                             " TO ASM-SOURCE-LINE
     CALL "CHIP8-ASSEMBLER" USING ASM-INSTRUCTION-BUFFER
     IF ASM-SUCCESS AND ASM-OPCODE-HEX = "00EE"
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Assemble RET Opcode (0x00EE) [PASS]"
     ELSE
         DISPLAY "TEST 2: Assemble RET Opcode (0x00EE) [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Assembler Tests Run:    " WS-TESTS-RUN
     DISPLAY "Assembler Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL ASSEMBLER TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME ASSEMBLER TESTS FAILED <<"
     END-IF
     STOP RUN.
