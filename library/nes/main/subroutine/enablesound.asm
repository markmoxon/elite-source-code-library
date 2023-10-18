\ ******************************************************************************
\
\       Name: EnableSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Enable sounds (music and sound effects)
\
\ ******************************************************************************

.EnableSound

 LDA playMusic          \ If playMusic = 0 then the music has been disabled by
 BEQ enas1              \ note command &FE, so jump to enas1 to leave the value
                        \ of enableSound alone and return from the subroutine
                        \ as only a new call to ChooseMusic can enable the music
                        \ again

 LDA enableSound        \ If enableSound is already non-zero, jump to enas1 to
 BNE enas1              \ leave it and return from the subroutine

 INC enableSound        \ Otherwise increment enableSound from 0 to 1

.enas1

 RTS                    \ Return from the subroutine

