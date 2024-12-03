\ ******************************************************************************
\
\       Name: BDlab23
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply a vibrato frequency change to voice 3
\
\ ******************************************************************************

 LDA #0                 \ Reset the vibrato counter for voice 3 so it starts to
 STA vibrato3           \ count up towards the next vibrato change once again

 LDA #&E2               \ Modify the BEQ instruction at BDbeqmod2 so next time
 STA BDbeqmod2+1        \ it jumps to the second half of this routine

 LDA voice3lo2          \ Set SID registers &E and &F to the vibrato frequency
 STA SID+&F             \ in (voice3lo2 voice3hi2), which sets the frequency
 LDA voice3hi2          \ for voice 3 to the second (i.e. the higher) frequency
 STA SID+&E             \ that we set up for vibrato in BDlab7

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

.BDlab23

 LDA #0                 \ Reset the vibrato counter for voice 3 so it starts to
 STA vibrato3           \ count up towards the next vibrato change once again

 LDA #&CC               \ Modify the BEQ instruction at BDbeqmod2 so next time
 STA BDbeqmod2+1        \ it jumps to the first half of this routine

 LDA voice3lo1          \ Set SID registers &E and &F to the vibrato frequency
 STA SID+&F             \ in (voice3lo1 voice3hi1), which sets the frequency
 LDA voice3hi1          \ for voice 3 to the second (i.e. the higher) frequency
 STA SID+&E             \ that we set up for vibrato in BDlab7

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

