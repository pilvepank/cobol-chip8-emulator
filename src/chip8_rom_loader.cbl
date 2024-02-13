*>================================================================
*> PROGRAM:  chip8_rom_loader.cbl
*> PURPOSE:  Binary ROM Boundary Verification & Memory Mapping
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-ROM-LOADER.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "LOADER-STATE.cpy".
 01  LS-INPUT-SIZE          PIC 9(06) COMP-5.

 PROCEDURE DIVISION USING ROM-LOADER-BLOCK, LS-INPUT-SIZE.
 0000-MAIN.
     MOVE LS-INPUT-SIZE TO RL-FILE-SIZE
     IF RL-FILE-SIZE = 0
         MOVE 'ZE' TO RL-LOAD-STATUS
     ELSE
         IF RL-FILE-SIZE > RL-MAX-CAPACITY
             MOVE 'TL' TO RL-LOAD-STATUS
         ELSE
             MOVE '00' TO RL-LOAD-STATUS
         END-IF
     END-IF
     GOBACK.
