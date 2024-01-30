*>================================================================
*> COPYBOOK: LOADER-STATE.cpy
*> PURPOSE:  CHIP-8 Binary ROM Validation & Loader Context
*> ================================================================
 01  ROM-LOADER-BLOCK.
     05  RL-FILE-SIZE            PIC 9(06) COMP-5 VALUE 0.
     05  RL-ENTRY-POINT          PIC 9(04) COMP-5 VALUE 512.
     05  RL-MAX-CAPACITY         PIC 9(04) COMP-5 VALUE 3584.
     05  RL-LOAD-STATUS          PIC X(02) VALUE '00'.
         88  RL-STATUS-OK        VALUE '00'.
         88  RL-FILE-TOO-LARGE   VALUE 'TL'.
         88  RL-ZERO-BYTE-FILE   VALUE 'ZE'.
