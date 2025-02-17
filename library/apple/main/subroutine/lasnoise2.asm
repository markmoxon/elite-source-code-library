\ ******************************************************************************
\
\       Name: LASNOISE2
\       Type: Subroutine
\   Category: Sound
\    Summary: An unused routine that makes a different laser sound
\
\ ******************************************************************************

.LASNOISE2

 LDY #11                \ Set Y = 11, though this has no effect as Y is set to
                        \ 25 in the following

 LDX #130               \ Set X = 130, though this has no effect as X is
                        \ overwritten with a random number before it is used

                        \ We now fall through into SOBOMB to make the sound of
                        \ an energy bomb going off, but it is unlikely that this
                        \ is how thie routine was used
                        \
                        \ The above variables make no difference to the sound
                        \ made by SOBOMB, and given the title of the routine,
                        \ it was presumably designed to jump to the SOBLOP entry
                        \ point to make a higher-pitched variation of the laser
                        \ sound, rather than falling in to SOBOMB
                        \
                        \ All that is missing is a BNE SOBLOP instruction to do
                        \ the jump

