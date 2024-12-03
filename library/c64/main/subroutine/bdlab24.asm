\ ******************************************************************************
\
\       Name: BDlab24
\       Type: Subroutine
\   Category: Sound
\    Summary: Apply a vibrato frequency change to voice 2
\
\ ******************************************************************************

 LDA #0                 \ Reset the vibrato counter for voice 2 so it starts to
 STA vibrato2           \ count up towards the next vibrato change once again

 LDA #&AE               \ Modify the BEQ instruction at BDbeqmod1 so next time
 STA BDbeqmod1+1        \ it jumps to the second half of this routine

 LDA voice2lo2          \ Set SID registers &7 and &8 to the vibrato frequency
 STA SID+&8             \ in (voice2lo2 voice2hi2), which sets the frequency
 LDA voice2hi2          \ for voice 2 to the second (i.e. the higher) frequency
 STA SID+&7             \ that we set up for vibrato in BDlab5

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

.BDlab24

 LDA #0                 \ Reset the vibrato counter for voice 2 so it starts to
 STA vibrato2           \ count up towards the next vibrato change once again

 LDA #&98               \ Modify the BEQ instruction at BDbeqmod1 so next time
 STA BDbeqmod1+1        \ it jumps to the first half of this routine

 LDA voice2lo1          \ Set SID registers &7 and &8 to the vibrato frequency
 STA SID+&8             \ in (voice2lo1 voice2hi1), which sets the frequency
 LDA voice2hi1          \ for voice 2 to the first (i.e. the lower) frequency
 STA SID+&7             \ that we set up for vibrato in BDlab5

 JMP BDlab21            \ Jump to BDlab21 to clean up and return from the
                        \ interrupt routine

