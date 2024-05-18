*>================================================================
*> PROGRAM:  chip8_synth_test.cbl
*> PURPOSE:  Unit Test Suite for XO-CHIP Audio Synthesizer
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-SYNTH-TEST.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 COPY "AUDIO-SYNTH.cpy".
 01  WS-PITCH               PIC 9(04) COMP-5 VALUE 64.
 01  WS-TESTS-RUN           PIC 9(04) VALUE 0.
 01  WS-TESTS-PASSED        PIC 9(04) VALUE 0.

 PROCEDURE DIVISION.
 0000-MAIN.
     DISPLAY "=================================================="
     DISPLAY "  CHIP-8 XO-CHIP AUDIO SYNTHESIZER TEST SUITE     "
     DISPLAY "=================================================="
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 64 TO WS-PITCH
     CALL "CHIP8-AUDIO-SYNTH" USING AUDIO-SYNTH-STATE, WS-PITCH
     IF AUD-FREQUENCY-HZ = 440 AND AUD-IS-PLAYING
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 1: Pitch 64 Standard Tuning 440Hz [PASS]"
     ELSE
         DISPLAY "TEST 1: Pitch 64 Standard Tuning 440Hz [FAIL]"
     END-IF
     
     ADD 1 TO WS-TESTS-RUN
     MOVE 80 TO WS-PITCH
     CALL "CHIP8-AUDIO-SYNTH" USING AUDIO-SYNTH-STATE, WS-PITCH
     IF AUD-FREQUENCY-HZ = 568
         ADD 1 TO WS-TESTS-PASSED
         DISPLAY "TEST 2: Pitch 80 Higher Octave Frequency [PASS]"
     ELSE
         DISPLAY "TEST 2: Pitch 80 Higher Octave Frequency [FAIL]"
     END-IF

     DISPLAY "--------------------------------------------------"
     DISPLAY "Synth Tests Run:    " WS-TESTS-RUN
     DISPLAY "Synth Tests Passed: " WS-TESTS-PASSED
     IF WS-TESTS-RUN = WS-TESTS-PASSED
         DISPLAY ">> ALL AUDIO SYNTH TESTS PASSED [100% OK] <<"
     ELSE
         DISPLAY ">> SOME AUDIO SYNTH TESTS FAILED <<"
     END-IF
     STOP RUN.
