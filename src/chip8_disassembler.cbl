*>================================================================
*> PROGRAM:  chip8_disassembler.cbl
*> PURPOSE:  CHIP-8 Instruction Decoder & Assembly Disassembler
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-DISASSEMBLER.

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.
     COPY "DISASM-TABLES.cpy".
 01  WS-BYTE-HIGH                PIC X(02).
 01  WS-BYTE-LOW                 PIC X(02).
 01  WS-OPCODE-DISP              PIC 9(04).

 LINKAGE SECTION.
 01  LS-OPCODE-RAW               PIC 9(04) COMP-5.
 01  LS-OUTPUT-LINE              PIC X(60).

 PROCEDURE DIVISION USING LS-OPCODE-RAW
                          LS-OUTPUT-LINE.
 0000-DISASSEMBLE.
     MOVE SPACES TO LS-OUTPUT-LINE.
     MOVE LS-OPCODE-RAW TO WS-OPCODE-DISP.

     IF LS-OPCODE-RAW = 0
         MOVE "00E0: CLS (Clear Screen)" TO LS-OUTPUT-LINE
     ELSE
         EVALUATE TRUE
             WHEN LS-OPCODE-RAW < 4096
                 STRING "1NNN: JP 0x" DELIMITED BY SIZE
                        WS-OPCODE-DISP DELIMITED BY SIZE
                        INTO LS-OUTPUT-LINE
             WHEN LS-OPCODE-RAW < 8192
                 STRING "2NNN: CALL 0x" DELIMITED BY SIZE
                        WS-OPCODE-DISP DELIMITED BY SIZE
                        INTO LS-OUTPUT-LINE
             WHEN OTHER
                 STRING "OPCODE: 0x" DELIMITED BY SIZE
                        WS-OPCODE-DISP DELIMITED BY SIZE
                        INTO LS-OUTPUT-LINE
         END-EVALUATE
     END-IF.
     GOBACK.
