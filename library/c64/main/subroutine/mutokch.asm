\ ******************************************************************************
\
\       Name: MUTOKCH
\       Type: Subroutine
\   Category: Sound
\    Summary: Process a change in the docking music configuration setting
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of MUTOK
\
\ ******************************************************************************

.MUTOKCH

 STA MUTOKOLD           \ Store the new value of MUTOK in MUTOKOLD so we can
                        \ check whether it changes again

 EOR #&FF               \ If MUTOK = 0 and bit 7 of auto is set, then the
 AND auto               \ docking music has just been enabled and the docking
 BMI april16            \ computer is running, so jump to april16 to start
                        \ playing the docking music

                        \ Otherwise either the docking music has just been
                        \ disabled and/or the docking computer is not running,
                        \ so fall through into stopbd to stop playing the
                        \ docking music

