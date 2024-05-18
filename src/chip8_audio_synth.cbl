*>================================================================
*> PROGRAM:  chip8_audio_synth.cbl
*> PURPOSE:  XO-CHIP 16-Byte Waveform Synthesizer & Frequency Calculator
*> ================================================================
 IDENTIFICATION DIVISION.
 PROGRAM-ID. CHIP8-AUDIO-SYNTH.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 COPY "AUDIO-SYNTH.cpy".
 01  LS-PITCH-INPUT         PIC 9(04) COMP-5.

 PROCEDURE DIVISION USING AUDIO-SYNTH-STATE, LS-PITCH-INPUT.
 0000-MAIN.
     MOVE LS-PITCH-INPUT TO AUD-PITCH-VALUE
     IF AUD-PITCH-VALUE >= 64
         COMPUTE AUD-FREQUENCY-HZ = 440 + ((AUD-PITCH-VALUE - 64) * 8)
     ELSE
         COMPUTE AUD-FREQUENCY-HZ = 440 - ((64 - AUD-PITCH-VALUE) * 5)
     END-IF
     MOVE 'Y' TO AUD-PLAYING-FLAG
     GOBACK.
