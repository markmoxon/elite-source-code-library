\ ******************************************************************************
\
\       Name: ResetMusicAfterNMI
\       Type: Subroutine
\   Category: Sound
\    Summary: Wait for the next NMI before resetting the current tune to 0 and
\             stopping the music
\
\ ******************************************************************************

.ResetMusicAfterNMI

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

                        \ Fall through into ResetMusic to reset the current tune
                        \ to 0 and stop the music

