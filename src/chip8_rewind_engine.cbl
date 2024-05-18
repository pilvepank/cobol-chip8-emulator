*>================================================================
*> PROGRAM:  chip8_rewind_engine.cbl
*> PURPOSE:  State Snapshot Ring-Buffer for Time-Travel Reverse Stepping
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-REWIND-ENGINE.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "REWIND-STATE.cpy".
 01  LS-OP                  PIC X(01).
 01  LS-CUR-PC              PIC 9(04) COMP-5.
 01  LS-OUT-PC              PIC 9(04) COMP-5.

 PROCEDURE DIVISION USING REWIND-RING-BUFFER, LS-OP, LS-CUR-PC, LS-OUT-PC.
 0000-MAIN.
     IF LS-OP = 'P'
         MOVE LS-CUR-PC TO RW-PC(RW-HEAD-IDX)
         ADD 1 TO RW-HEAD-IDX
         IF RW-HEAD-IDX > 32
             MOVE 1 TO RW-HEAD-IDX
         END-IF
         IF RW-SAVED-FRAMES < 32
             ADD 1 TO RW-SAVED-FRAMES
         END-IF
         MOVE LS-CUR-PC TO LS-OUT-PC
     ELSE
         IF RW-SAVED-FRAMES > 0
             IF RW-HEAD-IDX = 1
                 MOVE 32 TO RW-HEAD-IDX
             ELSE
                 SUBTRACT 1 FROM RW-HEAD-IDX
             END-IF
             MOVE RW-PC(RW-HEAD-IDX) TO LS-OUT-PC
             SUBTRACT 1 FROM RW-SAVED-FRAMES
         ELSE
             MOVE LS-CUR-PC TO LS-OUT-PC
         END-IF
     END-IF
     GOBACK.
