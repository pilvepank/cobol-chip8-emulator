*>================================================================
*> PROGRAM:  chip8_keypad.cbl
*> PURPOSE:  Hexadecimal Keypad Input Dispatcher & Keywait Blocker
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-KEYPAD.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "KEYPAD-MAP.cpy".
 01  LS-KEY-INDEX           PIC 9(02) COMP-5.
 01  LS-ACTION              PIC X(01).

 PROCEDURE DIVISION USING KEYPAD-MATRIX-STATE, LS-KEY-INDEX, LS-ACTION.
 0000-MAIN.
     IF LS-KEY-INDEX >= 1 AND LS-KEY-INDEX <= 16
         IF LS-ACTION = 'D'
             MOVE 'Y' TO KEY-IS-DOWN(LS-KEY-INDEX)
             IF KP-IS-BLOCKED
                 MOVE 'N' TO KP-WAITING-KEYPRESS
             END-IF
         ELSE
             MOVE 'N' TO KEY-IS-DOWN(LS-KEY-INDEX)
         END-IF
     END-IF
     GOBACK.
