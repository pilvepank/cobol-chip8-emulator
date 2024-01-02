      *================================================================*
*> PROGRAM:  chip8_timer_audio.cbl                                *
*> PURPOSE:  CHIP-8 60Hz Sound & Delay Timer Countdown Manager    *
*> ================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHIP8-TIMER-AUDIO.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-SOUND-ACTIVE             PIC X(01) VALUE 'N'.

       LINKAGE SECTION.
       01  LS-DELAY-TIMER              PIC 9(03) COMP-5.
       01  LS-SOUND-TIMER              PIC 9(03) COMP-5.
       01  LS-BEEP-FLAG                PIC X(01).

       PROCEDURE DIVISION USING LS-DELAY-TIMER
                                LS-SOUND-TIMER
                                LS-BEEP-FLAG.
       0000-TICK-TIMERS.
           IF LS-DELAY-TIMER > 0
               SUBTRACT 1 FROM LS-DELAY-TIMER
           END-IF.

           IF LS-SOUND-TIMER > 0
               SUBTRACT 1 FROM LS-SOUND-TIMER
               MOVE 'Y' TO LS-BEEP-FLAG
           ELSE
               MOVE 'N' TO LS-BEEP-FLAG
           END-IF.
           GOBACK.
