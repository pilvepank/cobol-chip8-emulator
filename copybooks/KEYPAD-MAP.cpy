*>================================================================
*> COPYBOOK: KEYPAD-MAP.cpy
*> PURPOSE:  16-Key Hexadecimal Keypad State Matrix
*> ================================================================
 01  KEYPAD-MATRIX-STATE.
     05  KP-KEY-PRESSED OCCURS 16 TIMES INDEXED BY KP-IDX.
         10  KEY-IS-DOWN         PIC X(01) VALUE 'N'.
             88  IS-PRESSED      VALUE 'Y'.
             88  IS-RELEASED     VALUE 'N'.
     05  KP-WAIT-REGISTER-VX     PIC 9(02) COMP-5 VALUE 0.
     05  KP-WAITING-KEYPRESS     PIC X(01) VALUE 'N'.
         88  KP-IS-BLOCKED       VALUE 'Y'.
