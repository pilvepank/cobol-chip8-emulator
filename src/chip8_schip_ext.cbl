      *================================================================*
*> PROGRAM:  chip8_schip_ext.cbl                                  *
*> PURPOSE:  Super-CHIP 1.1 Extended Instruction Dispatcher       *
*> ================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHIP8-SCHIP-EXT.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY "SCHIP-CONFIG.cpy".

       LINKAGE SECTION.
       01  LS-SCHIP-OPCODE             PIC X(04).
       01  LS-STATUS                   PIC 9(02) COMP-5.

       PROCEDURE DIVISION USING LS-SCHIP-OPCODE
                                LS-STATUS.
       0000-EXECUTE-SCHIP.
           MOVE 0 TO LS-STATUS.
           EVALUATE LS-SCHIP-OPCODE
               WHEN "00FF"
                   SET HIRES-ACTIVE TO TRUE
               WHEN "00FE"
                   SET LORES-ACTIVE TO TRUE
               WHEN "00FB"
                   *> Scroll right 4 pixels
                   MOVE 1 TO LS-STATUS
               WHEN "00FC"
                   *> Scroll left 4 pixels
                   MOVE 2 TO LS-STATUS
               WHEN OTHER
                   MOVE 99 TO LS-STATUS
           END-EVALUATE.
           GOBACK.
