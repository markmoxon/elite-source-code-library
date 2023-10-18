\ ******************************************************************************
\
\       Name: MakeSoundsAtVBlank
\       Type: Subroutine
\   Category: Sound
\    Summary: Wait for the next VBlank and make the current sounds (music and
\             sound effects)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\ ******************************************************************************

.MakeSoundsAtVBlank

 TXA                    \ Store X on the stack, so we can retrieve it below
 PHA

 JSR WaitForVBlank      \ Wait for the next VBlank to pass

 JSR MakeSounds_b6      \ Call the MakeSounds routine to make the current sounds
                        \ (music and sound effects)

 PLA                    \ Restore X from the stack so it is preserved
 TAX

 RTS                    \ Return from the subroutine

