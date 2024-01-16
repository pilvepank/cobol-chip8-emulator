*>================================================================
*> COPYBOOK: ASM-TABLES.cpy
*> PURPOSE:  CHIP-8 Mnemonic Lookup & Instruction Assembly Layout
*> ================================================================
 01  ASM-INSTRUCTION-BUFFER.
     05  ASM-SOURCE-LINE         PIC X(32).
     05  ASM-OPCODE-HEX          PIC X(04).
     05  ASM-STATUS              PIC X(02) VALUE '00'.
         88  ASM-SUCCESS         VALUE '00'.
         88  ASM-SYNTAX-ERROR    VALUE '99'.
