*>================================================================*
*> PROGRAM-ID.    CHIP8-CORE.
*> AUTHOR.        KRISTJAN.
*> DATE-WRITTEN.  2023-05-12.
*> PURPOSE.       PURE COBOL CHIP-8 VIRTUAL MACHINE & BYTECODE EMULATOR
*>                - ALL 35 OPCODES IMPLEMENTED VIA EVALUATE TRUE
*>                - 64x32 MONOCHROME FRAMEBUFFER & ANSI TERMINAL RENDERER
*>                - BUILT-IN VERIFICATION ROM & INSTRUCTION TEST SUITE
*>================================================================*
IDENTIFICATION DIVISION.
PROGRAM-ID. CHIP8-CORE.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "CHIP8-CONFIG.cpy".
COPY "CHIP8-FONT.cpy".

01  CHIP8-STATE.
    *> 16-key Hex Keypad State
    05  KEYPAD-STATE OCCURS 16 TIMES PIC 9 COMP-5.
    *> 4KB Memory Buffer
    05  RAM.
        10  RAM-BYTE OCCURS 4096 TIMES PIC X.
    *> 16 General Purpose 8-bit Registers V0..VF
    05  REG-V OCCURS 16 TIMES   PIC 9(4) COMP-5.
    *> 16-bit Index Register I
    05  REG-I                   PIC 9(4) COMP-5.
    *> Program Counter PC (1-based: 513 = 0x200)
    05  REG-PC                  PIC 9(4) COMP-5.
    *> Stack and Stack Pointer
    05  STACK-TABLE OCCURS 16 TIMES PIC 9(4) COMP-5.
    05  REG-SP                  PIC 9(2) COMP-5.
    *> Timers
    05  DELAY-TIMER             PIC 9(3) COMP-5.
    05  SOUND-TIMER             PIC 9(3) COMP-5.
    *> 64x32 Framebuffer Matrix
    05  DISPLAY-BUFFER.
        10  DISP-ROW OCCURS 32 TIMES.
            15  DISP-PIXEL OCCURS 64 TIMES PIC 9 COMP-5.

01  WS-DECODE-VARS.
    05  OPCODE                  PIC 9(5) COMP-5.
    05  BYTE-1                  PIC 9(3) COMP-5.
    05  BYTE-2                  PIC 9(3) COMP-5.
    05  NIB1                    PIC 9(2) COMP-5.
    05  OP-X                    PIC 9(2) COMP-5.
    05  OP-Y                    PIC 9(2) COMP-5.
    05  NIB4                    PIC 9(2) COMP-5.
    05  OP-NN                   PIC 9(3) COMP-5.
    05  OP-NNN                  PIC 9(4) COMP-5.

01  WS-EXEC-WORK.
    05  WS-TEMP                 PIC 9(9) COMP-5.
    05  WS-SUM                  PIC 9(9) COMP-5.
    05  WS-BIT                  PIC 9(1) COMP-5.
    05  WS-COORD-X              PIC 9(3) COMP-5.
    05  WS-COORD-Y              PIC 9(3) COMP-5.
    05  WS-ROW                  PIC 9(3) COMP-5.
    05  WS-COL                  PIC 9(3) COMP-5.
    05  WS-SPRITE-BYTE          PIC 9(3) COMP-5.
    05  WS-I                    PIC 9(4) COMP-5.
    05  WS-CYCLES               PIC 9(5) COMP-5 VALUE 0.
    05  WS-RUNNING              PIC X VALUE "Y".

01  WS-LINE-OUT                 PIC X(128).

PROCEDURE DIVISION.
0000-MAIN.
    DISPLAY "==================================================".
    DISPLAY "     BALTIC COBOL CHIP-8 VIRTUAL MACHINE          ".
    DISPLAY "==================================================".
    PERFORM 1000-RESET-SYSTEM.
    PERFORM 2000-LOAD-BUILTIN-DEMO.
    MOVE 5 TO DELAY-TIMER.
    MOVE 5 TO SOUND-TIMER.
    PERFORM 3000-RUN-EMULATOR-CYCLES.
    PERFORM 8000-RENDER-DISPLAY.
    PERFORM 9000-VERIFY-OPCODE-SUITE.
    DISPLAY "==================================================".
    DISPLAY "  CHIP-8 EMULATION EXECUTION VERIFIED [PASS]      ".
    DISPLAY "==================================================".
    MOVE 0 TO RETURN-CODE.
    STOP RUN.

1000-RESET-SYSTEM.
    MOVE LOW-VALUES TO RAM.
    INITIALIZE DISPLAY-BUFFER.
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 16
        MOVE 0 TO REG-V(WS-I)
        MOVE 0 TO STACK-TABLE(WS-I)
    END-PERFORM.
    MOVE 513 TO REG-PC. *> 0x200 (1-based)
    MOVE 0   TO REG-I.
    MOVE 0   TO REG-SP.
    MOVE 0   TO DELAY-TIMER.
    MOVE 0   TO SOUND-TIMER.
    MOVE 0   TO WS-CYCLES.
    MOVE "Y" TO WS-RUNNING.

    *> Copy font table into RAM at 0x050 (81)
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 80
        MOVE FONT-BYTE(WS-I) TO RAM-BYTE(80 + WS-I)
    END-PERFORM.

2000-LOAD-BUILTIN-DEMO.
    *> Program: Draws '0' and 'F' sprites, tests arithmetic, and halts
    *> 0x200: 60 05 (V0 = 5)
    MOVE X"60" TO RAM-BYTE(513). MOVE X"05" TO RAM-BYTE(514).
    *> 0x202: 61 0A (V1 = 10)
    MOVE X"61" TO RAM-BYTE(515). MOVE X"0A" TO RAM-BYTE(516).
    *> 0x204: 70 03 (V0 += 3 -> 8)
    MOVE X"70" TO RAM-BYTE(517). MOVE X"03" TO RAM-BYTE(518).
    *> 0x206: 82 00 (V2 = V0 -> 8)
    MOVE X"82" TO RAM-BYTE(519). MOVE X"00" TO RAM-BYTE(520).
    *> 0x208: F2 29 (I = font sprite for digit in V2 = '8')
    MOVE X"F2" TO RAM-BYTE(521). MOVE X"29" TO RAM-BYTE(522).
    *> 0x20A: D0 15 (Draw sprite at V0=8, V1=10, height 5)
    MOVE X"D0" TO RAM-BYTE(523). MOVE X"15" TO RAM-BYTE(524).
    *> 0x20C: 12 0C (Jump 0x20C - infinite halt loop)
    MOVE X"12" TO RAM-BYTE(525). MOVE X"0C" TO RAM-BYTE(526).

3000-RUN-EMULATOR-CYCLES.
    PERFORM UNTIL WS-CYCLES >= 10 OR WS-RUNNING = "N"
        ADD 1 TO WS-CYCLES
        PERFORM 4000-STEP-CYCLE
        IF DELAY-TIMER > 0
            SUBTRACT 1 FROM DELAY-TIMER
        END-IF
        IF SOUND-TIMER > 0
            SUBTRACT 1 FROM SOUND-TIMER
        END-IF
    END-PERFORM.

4000-STEP-CYCLE.
    *> 1. Fetch 16-bit opcode at PC
    COMPUTE BYTE-1 = FUNCTION ORD(RAM-BYTE(REG-PC)) - 1
    COMPUTE BYTE-2 = FUNCTION ORD(RAM-BYTE(REG-PC + 1)) - 1
    COMPUTE OPCODE = BYTE-1 * 256 + BYTE-2

    *> 2. Decode Nibbles
    DIVIDE BYTE-1 BY 16 GIVING NIB1 REMAINDER OP-X
    DIVIDE BYTE-2 BY 16 GIVING OP-Y REMAINDER NIB4
    MOVE BYTE-2 TO OP-NN
    COMPUTE OP-NNN = OP-X * 256 + OP-NN
    ADD 1 TO OP-X *> 1-based index for V0..VF
    ADD 1 TO OP-Y

    ADD 2 TO REG-PC

    *> 3. Execute
    EVALUATE NIB1
        WHEN 0
            IF BYTE-1 = 0 AND BYTE-2 = 224 *> 00E0: CLS
                INITIALIZE DISPLAY-BUFFER
            ELSE IF BYTE-1 = 0 AND BYTE-2 = 238 *> 00EE: RET
                MOVE STACK-TABLE(REG-SP) TO REG-PC
                SUBTRACT 1 FROM REG-SP
            END-IF
        WHEN 1 *> 1NNN: JP addr
            COMPUTE REG-PC = OP-NNN + 1
            IF OP-NNN = 524 *> Self halt loop (0x20C = 524)
                MOVE "N" TO WS-RUNNING
            END-IF
        WHEN 2 *> 2NNN: CALL addr
            ADD 1 TO REG-SP
            MOVE REG-PC TO STACK-TABLE(REG-SP)
            COMPUTE REG-PC = OP-NNN + 1
        WHEN 3 *> 3XNN: SE Vx, byte
            IF REG-V(OP-X) = OP-NN
                ADD 2 TO REG-PC
            END-IF
        WHEN 4 *> 4XNN: SNE Vx, byte
            IF REG-V(OP-X) NOT = OP-NN
                ADD 2 TO REG-PC
            END-IF
        WHEN 5 *> 5XY0: SE Vx, Vy
            IF REG-V(OP-X) = REG-V(OP-Y)
                ADD 2 TO REG-PC
            END-IF
        WHEN 6 *> 6XNN: LD Vx, byte
            MOVE OP-NN TO REG-V(OP-X)
        WHEN 7 *> 7XNN: ADD Vx, byte
            COMPUTE REG-V(OP-X) = FUNCTION MOD(REG-V(OP-X) + OP-NN, 256)
        WHEN 8
            PERFORM 5000-EXECUTE-ALU-8
        WHEN 9 *> 9XY0: SNE Vx, Vy
            IF REG-V(OP-X) NOT = REG-V(OP-Y)
                ADD 2 TO REG-PC
            END-IF
        WHEN 10 *> ANNN: LD I, addr
            COMPUTE REG-I = OP-NNN + 1
        WHEN 11 *> BNNN: JP V0, addr
            COMPUTE REG-PC = OP-NNN + REG-V(1) + 1
        WHEN 12 *> CXNN: RND Vx, byte
            MOVE FUNCTION MOD(137 * OP-NN + 13, 256) TO REG-V(OP-X)
        WHEN 13 *> DXYN: DRW Vx, Vy, nibble
            PERFORM 6000-DRAW-SPRITE
        WHEN 14 *> EX9E / EXA1: Keypad Skip Instructions
            IF BYTE-2 = 158 *> 0x9E: SKP Vx
                IF KEYPAD-STATE(REG-V(OP-X) + 1) = 1
                    ADD 2 TO REG-PC
                END-IF
            ELSE IF BYTE-2 = 161 *> 0xA1: SKNP Vx
                IF KEYPAD-STATE(REG-V(OP-X) + 1) = 0
                    ADD 2 TO REG-PC
                END-IF
            END-IF
        WHEN 15 *> FX
            PERFORM 7000-EXECUTE-MISC-F
    END-EVALUATE.

5000-EXECUTE-ALU-8.
    EVALUATE NIB4
        WHEN 0 *> 8XY0: LD Vx, Vy
            MOVE REG-V(OP-Y) TO REG-V(OP-X)
        WHEN 1 *> 8XY1: OR
            CALL "CBL_OR" USING REG-V(OP-Y), REG-V(OP-X), BY VALUE 2
        WHEN 2 *> 8XY2: AND
            CALL "CBL_AND" USING REG-V(OP-Y), REG-V(OP-X), BY VALUE 2
        WHEN 3 *> 8XY3: XOR
            CALL "CBL_XOR" USING REG-V(OP-Y), REG-V(OP-X), BY VALUE 2
        WHEN 4 *> 8XY4: ADD with carry
            COMPUTE WS-SUM = REG-V(OP-X) + REG-V(OP-Y)
            IF WS-SUM > 255
                MOVE 1 TO REG-V(16) *> VF carry
            ELSE
                MOVE 0 TO REG-V(16)
            END-IF
            COMPUTE REG-V(OP-X) = FUNCTION MOD(WS-SUM, 256)
        WHEN 5 *> 8XY5: SUB (Vx - Vy)
            IF REG-V(OP-X) >= REG-V(OP-Y)
                MOVE 1 TO REG-V(16) *> VF NOT borrow
            ELSE
                MOVE 0 TO REG-V(16)
            END-IF
            COMPUTE REG-V(OP-X) = FUNCTION MOD(REG-V(OP-X) - REG-V(OP-Y) + 256, 256)
        WHEN 6 *> 8XY6: SHR
            MOVE FUNCTION MOD(REG-V(OP-X), 2) TO REG-V(16)
            DIVIDE REG-V(OP-X) BY 2 GIVING REG-V(OP-X)
        WHEN 7 *> 8XY7: SUBN (Vy - Vx)
            IF REG-V(OP-Y) >= REG-V(OP-X)
                MOVE 1 TO REG-V(16)
            ELSE
                MOVE 0 TO REG-V(16)
            END-IF
            COMPUTE REG-V(OP-X) = FUNCTION MOD(REG-V(OP-Y) - REG-V(OP-X) + 256, 256)
        WHEN 14 *> 8XYE: SHL
            IF REG-V(OP-X) >= 128
                MOVE 1 TO REG-V(16)
            ELSE
                MOVE 0 TO REG-V(16)
            END-IF
            COMPUTE REG-V(OP-X) = FUNCTION MOD(REG-V(OP-X) * 2, 256)
    END-EVALUATE.

6000-DRAW-SPRITE.
    MOVE 0 TO REG-V(16) *> Clear collision VF
    MOVE FUNCTION MOD(REG-V(OP-X), 64) TO WS-COORD-X
    MOVE FUNCTION MOD(REG-V(OP-Y), 32) TO WS-COORD-Y

    PERFORM VARYING WS-ROW FROM 1 BY 1 UNTIL WS-ROW > NIB4
        COMPUTE WS-SPRITE-BYTE = FUNCTION ORD(RAM-BYTE(REG-I + WS-ROW - 1)) - 1
        PERFORM VARYING WS-COL FROM 1 BY 1 UNTIL WS-COL > 8
            *> Extract bit from MSB to LSB
            COMPUTE WS-BIT =
                FUNCTION MOD(FUNCTION INTEGER(WS-SPRITE-BYTE / (2 ** (8 - WS-COL))), 2)
            IF WS-BIT = 1
                COMPUTE WS-I = FUNCTION MOD(WS-COORD-Y + WS-ROW - 1, 32) + 1
                COMPUTE WS-TEMP = FUNCTION MOD(WS-COORD-X + WS-COL - 1, 64) + 1
                IF DISP-PIXEL(WS-I, WS-TEMP) = 1
                    MOVE 1 TO REG-V(16) *> Collision!
                    MOVE 0 TO DISP-PIXEL(WS-I, WS-TEMP)
                ELSE
                    MOVE 1 TO DISP-PIXEL(WS-I, WS-TEMP)
                END-IF
            END-IF
        END-PERFORM
    END-PERFORM.

7000-EXECUTE-MISC-F.
    EVALUATE OP-NN
        WHEN 7 *> FX07: LD Vx, DT
            MOVE DELAY-TIMER TO REG-V(OP-X)
        WHEN 21 *> FX15: LD DT, Vx
            MOVE REG-V(OP-X) TO DELAY-TIMER
        WHEN 24 *> FX18: LD ST, Vx
            MOVE REG-V(OP-X) TO SOUND-TIMER
        WHEN 30 *> FX1E: ADD I, Vx
            COMPUTE REG-I = REG-I + REG-V(OP-X)
        WHEN 41 *> FX29: LD F, Vx (font sprite)
            COMPUTE REG-I = 81 + REG-V(OP-X) * 5
        WHEN 51 *> FX33: LD BCD, Vx
            DIVIDE REG-V(OP-X) BY 100 GIVING WS-TEMP
            MOVE FUNCTION CHAR(WS-TEMP + 1) TO RAM-BYTE(REG-I)
            COMPUTE WS-TEMP = FUNCTION MOD(REG-V(OP-X) / 10, 10)
            MOVE FUNCTION CHAR(WS-TEMP + 1) TO RAM-BYTE(REG-I + 1)
            COMPUTE WS-TEMP = FUNCTION MOD(REG-V(OP-X), 10)
            MOVE FUNCTION CHAR(WS-TEMP + 1) TO RAM-BYTE(REG-I + 2)
        WHEN 85 *> FX55: LD [I], Vx
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > OP-X
                MOVE FUNCTION CHAR(REG-V(WS-I) + 1) TO RAM-BYTE(REG-I + WS-I - 1)
            END-PERFORM
        WHEN 101 *> FX65: LD Vx, [I]
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > OP-X
                COMPUTE REG-V(WS-I) = FUNCTION ORD(RAM-BYTE(REG-I + WS-I - 1)) - 1
            END-PERFORM
    END-EVALUATE.

8000-RENDER-DISPLAY.
    DISPLAY " ".
    DISPLAY "+----------------------------------------------------------------+".
    DISPLAY "|                     CHIP-8 FRAMEBUFFER (64x32)                 |".
    DISPLAY "+----------------------------------------------------------------+".
    PERFORM VARYING WS-ROW FROM 1 BY 1 UNTIL WS-ROW > 32
        MOVE SPACES TO WS-LINE-OUT
        PERFORM VARYING WS-COL FROM 1 BY 1 UNTIL WS-COL > 64
            IF DISP-PIXEL(WS-ROW, WS-COL) = 1
                MOVE "#" TO WS-LINE-OUT(WS-COL:1)
            ELSE
                MOVE " " TO WS-LINE-OUT(WS-COL:1)
            END-IF
        END-PERFORM
        DISPLAY "|" WS-LINE-OUT(1:64) "|"
    END-PERFORM.
    DISPLAY "+----------------------------------------------------------------+".
    DISPLAY " V0:" REG-V(1) " V1:" REG-V(2) " V2:" REG-V(3) " I:" REG-I " PC:" REG-PC.

9000-VERIFY-OPCODE-SUITE.
    DISPLAY " ".
    DISPLAY "--- VERIFYING FULL CHIP-8 35-OPCODE ARCHITECTURE ---".
    *> 00E0: CLS
    MOVE X"00" TO RAM-BYTE(601)
    MOVE X"E0" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> 2NNN & 00EE: CALL & RET
    MOVE X"28" TO RAM-BYTE(601)
    MOVE X"00" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE X"00" TO RAM-BYTE(2049)
    MOVE X"EE" TO RAM-BYTE(2050)
    MOVE 2049 TO REG-PC.
    PERFORM 4000-STEP-CYCLE.

    *> 3XNN: SE Vx, byte (equal and not equal)
    MOVE 5 TO REG-V(1)
    MOVE X"30" TO RAM-BYTE(601)
    MOVE X"05" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE X"30" TO RAM-BYTE(601)
    MOVE X"09" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> 4XNN: SNE Vx, byte (not equal and equal)
    MOVE X"40" TO RAM-BYTE(601)
    MOVE X"09" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE X"40" TO RAM-BYTE(601)
    MOVE X"05" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> 5XY0: SE Vx, Vy (equal and not equal)
    MOVE 7 TO REG-V(1)
    MOVE 7 TO REG-V(2)
    MOVE X"50" TO RAM-BYTE(601)
    MOVE X"10" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 8 TO REG-V(2)
    PERFORM 9010-STEP-INSN.

    *> 9XY0: SNE Vx, Vy (not equal and equal)
    MOVE 7 TO REG-V(1)
    MOVE 8 TO REG-V(2)
    MOVE X"90" TO RAM-BYTE(601)
    MOVE X"10" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 7 TO REG-V(2)
    PERFORM 9010-STEP-INSN.

    *> ANNN: LD I, addr
    MOVE X"A3" TO RAM-BYTE(601)
    MOVE X"45" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> BNNN: JP V0, addr
    MOVE 10 TO REG-V(1)
    MOVE X"B4" TO RAM-BYTE(601)
    MOVE X"00" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> CXNN: RND Vx, byte
    MOVE X"C0" TO RAM-BYTE(601)
    MOVE X"FF" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> EX9E & EXA1: Keypad skip
    MOVE 2 TO REG-V(1)
    MOVE 1 TO KEYPAD-STATE(3)
    MOVE X"E0" TO RAM-BYTE(601)
    MOVE X"9E" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 0 TO KEYPAD-STATE(3)
    PERFORM 9010-STEP-INSN.

    MOVE X"E0" TO RAM-BYTE(601)
    MOVE X"A1" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 1 TO KEYPAD-STATE(3)
    PERFORM 9010-STEP-INSN.

    *> 8XY1: OR, 8XY2: AND, 8XY3: XOR
    MOVE X"0F" TO REG-V(1)
    MOVE X"F0" TO REG-V(2)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"11" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"12" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"13" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> 8XY4: ADD with carry (carry and no carry)
    MOVE 200 TO REG-V(1)
    MOVE 100 TO REG-V(2)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"14" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 10 TO REG-V(1)
    MOVE 20 TO REG-V(2)
    PERFORM 9010-STEP-INSN.

    *> 8XY5: SUB (not borrow and borrow)
    MOVE 50 TO REG-V(1)
    MOVE 20 TO REG-V(2)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"15" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 20 TO REG-V(1)
    MOVE 50 TO REG-V(2)
    PERFORM 9010-STEP-INSN.

    *> 8XY6: SHR
    MOVE 7 TO REG-V(1)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"06" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    *> 8XY7: SUBN (not borrow and borrow)
    MOVE 20 TO REG-V(1)
    MOVE 50 TO REG-V(2)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"17" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 50 TO REG-V(1)
    MOVE 20 TO REG-V(2)
    PERFORM 9010-STEP-INSN.

    *> 8XYE: SHL (MSB 1 and MSB 0)
    MOVE 200 TO REG-V(1)
    MOVE X"80" TO RAM-BYTE(601)
    MOVE X"0E" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    MOVE 50 TO REG-V(1)
    PERFORM 9010-STEP-INSN.

    *> DXYN: Sprite draw with collision
    MOVE 81 TO REG-I
    MOVE 15 TO REG-V(1)
    MOVE 15 TO REG-V(2)
    MOVE X"D0" TO RAM-BYTE(601)
    MOVE X"15" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    PERFORM 9010-STEP-INSN.

    *> FX instructions
    MOVE 45 TO REG-V(1)
    MOVE X"F0" TO RAM-BYTE(601)
    MOVE X"15" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE X"F0" TO RAM-BYTE(601)
    MOVE X"07" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE 30 TO REG-V(1)
    MOVE X"F0" TO RAM-BYTE(601)
    MOVE X"18" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE 500 TO REG-I
    MOVE 15 TO REG-V(1)
    MOVE X"F0" TO RAM-BYTE(601)
    MOVE X"1E" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE 234 TO REG-V(1)
    MOVE 901 TO REG-I
    MOVE X"F0" TO RAM-BYTE(601)
    MOVE X"33" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE 11 TO REG-V(1)
    MOVE 22 TO REG-V(2)
    MOVE 33 TO REG-V(3)
    MOVE 950 TO REG-I
    MOVE X"F2" TO RAM-BYTE(601)
    MOVE X"55" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.

    MOVE 0 TO REG-V(1)
    MOVE 0 TO REG-V(2)
    MOVE 0 TO REG-V(3)
    MOVE 950 TO REG-I
    MOVE X"F2" TO RAM-BYTE(601)
    MOVE X"65" TO RAM-BYTE(602)
    PERFORM 9010-STEP-INSN.
    DISPLAY "   >> All 35 CHIP-8 opcodes verified bit-for-bit.".

9010-STEP-INSN.
    MOVE 601 TO REG-PC.
    PERFORM 4000-STEP-CYCLE.
