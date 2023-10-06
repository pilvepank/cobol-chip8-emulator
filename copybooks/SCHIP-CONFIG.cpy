      *================================================================*
*> COPYBOOK: SCHIP-CONFIG.cpy                                     *
*> PURPOSE:  Super-CHIP 1.1 Extended Registers & 128x64 Buffers   *
*> ================================================================*
       01  SCHIP-EXTENSIONS.
           05  SCHIP-HIRES-MODE        PIC X(01) VALUE 'N'.
               88  HIRES-ACTIVE        VALUE 'Y'.
               88  LORES-ACTIVE        VALUE 'N'.
           05  SCHIP-RPL-FLAGS OCCURS 16 TIMES INDEXED BY RPL-IDX.
               10  RPL-VAL             PIC 9(03) COMP-5 VALUE 0.
           05  SCHIP-SCREEN-MATRIX.
               10  SCHIP-ROW OCCURS 64 TIMES.
                   15  SCHIP-COL OCCURS 128 TIMES.
                       20  SCHIP-PIXEL PIC 9(01) VALUE 0.
