*>================================================================
*> COPYBOOK: PROFILER-STATE.cpy
*> PURPOSE:  CPU Opcode Execution Frequency & Bottleneck Profiler
*> ================================================================
 01  PROFILER-STATE-BLOCK.
     05  PRF-TOTAL-CYCLES        PIC 9(12) COMP-5 VALUE 0.
     05  PRF-TOTAL-INSTRUCTIONS  PIC 9(12) COMP-5 VALUE 0.
     05  PRF-OPCODE-COUNTS OCCURS 16 TIMES INDEXED BY PRF-OP-IDX.
         10  PRF-OP-NAME         PIC X(08).
         10  PRF-OP-EXEC-COUNT   PIC 9(09) COMP-5 VALUE 0.
