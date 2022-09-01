*>================================================================*
*> CHIP8-FONT.cpy - Hexadecimal Font Sprite Table (0-F, 5 bytes each)
*>================================================================*
 01  FONT-SPRITES-DATA.
     *> 0: F0 90 90 90 F0
     05  F-0 PIC X(5) VALUE X"F0909090F0".
     *> 1: 20 60 20 20 70
     05  F-1 PIC X(5) VALUE X"2060202070".
     *> 2: F0 10 F0 80 F0
     05  F-2 PIC X(5) VALUE X"F010F080F0".
     *> 3: F0 10 F0 10 F0
     05  F-3 PIC X(5) VALUE X"F010F010F0".
     *> 4: 90 90 F0 10 10
     05  F-4 PIC X(5) VALUE X"9090F01010".
     *> 5: F0 80 F0 10 F0
     05  F-5 PIC X(5) VALUE X"F080F010F0".
     *> 6: F0 80 F0 90 F0
     05  F-6 PIC X(5) VALUE X"F080F090F0".
     *> 7: F0 10 20 40 40
     05  F-7 PIC X(5) VALUE X"F010204040".
     *> 8: F0 90 F0 90 F0
     05  F-8 PIC X(5) VALUE X"F090F090F0".
     *> 9: F0 90 F0 10 F0
     05  F-9 PIC X(5) VALUE X"F090F010F0".
     *> A: F0 90 F0 90 90
     05  F-A PIC X(5) VALUE X"F090F09090".
     *> B: E0 90 E0 90 E0
     05  F-B PIC X(5) VALUE X"E090E090E0".
     *> C: F0 80 80 80 F0
     05  F-C PIC X(5) VALUE X"F0808080F0".
     *> D: E0 90 90 90 E0
     05  F-D PIC X(5) VALUE X"E0909090E0".
     *> E: F0 80 F0 80 F0
     05  F-E PIC X(5) VALUE X"F080F080F0".
     *> F: F0 80 F0 80 80
     05  F-F PIC X(5) VALUE X"F080F08080".
 01  FONT-TABLE REDEFINES FONT-SPRITES-DATA.
     05  FONT-BYTE OCCURS 80 TIMES PIC X.
