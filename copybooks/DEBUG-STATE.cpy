*>================================================================
*> COPYBOOK: DEBUG-STATE.cpy
*> PURPOSE:  CHIP-8 Interactive Debugger & Breakpoint Layout
*> ================================================================
 01  DEBUG-CONTROL-BLOCK.
     05  DBG-BREAKPOINT-PC       PIC 9(04) COMP-5 VALUE 0.
     05  DBG-STEP-MODE           PIC X(01) VALUE 'N'.
         88  DBG-STEP-ACTIVE     VALUE 'Y'.
     05  DBG-TRAPPED             PIC X(01) VALUE 'N'.
         88  DBG-IS-TRAPPED      VALUE 'Y'.
     05  DBG-LAST-OPCODE         PIC X(04).
     05  DBG-CYCLE-COUNT         PIC 9(08) COMP-5 VALUE 0.
