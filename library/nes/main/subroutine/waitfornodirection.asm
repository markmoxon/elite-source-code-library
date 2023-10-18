\ ******************************************************************************
\
\       Name: WaitForNoDirection
\       Type: Subroutine
\   Category: Controllers
\    Summary: Wait until the left and right buttons on controller 1 have been
\             released and remain released for at least four VBlanks
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.WaitForNoDirection

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

.ndir1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1Left03  \ Keep looping back to ndir1 until both the left and
 ORA controller1Right03 \ right button on controller 1 have been released and
 BMI ndir1              \ remain released for at least four VBlanks

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

