\ ******************************************************************************
\
\       Name: MakeScoopSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of the fuel scoops working
\
\ ******************************************************************************

.MakeScoopSound

 LDY #1                 \ Call the NOISE routine with Y = 1 to make the sound of
 BNE NOISE              \ the fuel scoops working, returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as Y
                        \ will never be zero)

