\ ******************************************************************************
\
\       Name: LASNO
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of our laser firing
\
\ ******************************************************************************

.LASNO

 LDY #3                 \ Call the NOISE routine with Y = 3 to make the first
 JSR NOISE              \ sound of us firing our lasers

 LDY #5                 \ Set Y = 5 and fall through into the NOISE routine to
                        \ make the second sound of us firing our lasers

