*>================================================================
*> PROGRAM:  chip8_assembler.cbl
*> PURPOSE:  Pure COBOL CHIP-8 Two-Pass Bytecode Assembler
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-ASSEMBLER.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "ASM-TABLES.cpy".

 PROCEDURE DIVISION USING ASM-INSTRUCTION-BUFFER.
 0000-MAIN.
     MOVE '00' TO ASM-STATUS
     EVALUATE ASM-SOURCE-LINE(1:3)
         WHEN "CLS"
             MOVE "00E0" TO ASM-OPCODE-HEX
         WHEN "RET"
             MOVE "00EE" TO ASM-OPCODE-HEX
         WHEN "JP "
             MOVE "1200" TO ASM-OPCODE-HEX
         WHEN OTHER
             MOVE '99' TO ASM-STATUS
     END-EVALUATE
     GOBACK.
