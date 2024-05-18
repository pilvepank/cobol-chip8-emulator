*>================================================================
*> COPYBOOK: AUDIO-SYNTH.cpy
*> PURPOSE:  XO-CHIP Audio Synthesizer Waveform & Pitch Descriptor
*> ================================================================
 01  AUDIO-SYNTH-STATE.
     05  AUD-PITCH-VALUE         PIC 9(04) COMP-5 VALUE 64.
     05  AUD-FREQUENCY-HZ        PIC 9(06) COMP-5 VALUE 440.
     05  AUD-WAVE-PATTERN OCCURS 16 TIMES INDEXED BY AUD-IDX.
         10  AUD-SAMPLE-BYTE     PIC 9(03) COMP-5 VALUE 170.
     05  AUD-PLAYING-FLAG        PIC X(01) VALUE 'N'.
         88  AUD-IS-PLAYING      VALUE 'Y'.
