*>================================================================
*> COPYBOOK: REWIND-STATE.cpy
*> PURPOSE:  CHIP-8 Time-Travel State History Ring Buffer
*> ================================================================
 01  REWIND-RING-BUFFER.
     05  RW-HEAD-IDX             PIC 9(04) COMP-5 VALUE 1.
     05  RW-SAVED-FRAMES         PIC 9(04) COMP-5 VALUE 0.
     05  RW-FRAMES OCCURS 32 TIMES INDEXED BY RW-IDX.
         10  RW-PC               PIC 9(04) COMP-5 VALUE 512.
         10  RW-I                PIC 9(04) COMP-5 VALUE 0.
         10  RW-SP               PIC 9(02) COMP-5 VALUE 0.
         10  RW-DELAY-TIMER      PIC 9(02) COMP-5 VALUE 0.
         10  RW-SOUND-TIMER      PIC 9(02) COMP-5 VALUE 0.
