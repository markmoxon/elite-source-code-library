\ ******************************************************************************
\
\       Name: BlankAllButtons
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Blank all the buttons on the icon bar
\
\ ******************************************************************************

.BlankAllButtons

 JSR DrawIconBar        \ Draw the icon bar into the nametable buffers for both
                        \ bitplanes
                        \
                        \ This also sets the following variables, which we pass
                        \ to the following routines:
                        \
                        \   * SC(1 0) is the address of the nametable entries
                        \     for the on-screen icon bar in nametable buffer 0
                        \
                        \   * SC2(1 0) is the address of the nametable entries
                        \     for the on-screen icon bar in nametable buffer 1

 LDY #2                 \ Blank the first button on the icon bar
 JSR DrawBlankButton2x2

 LDY #4                 \ Blank the second button on the icon bar
 JSR DrawBlankButton3x2

 LDY #7                 \ Blank the third button on the icon bar
 JSR DrawBlankButton2x2

 LDY #9                 \ Blank the fourth button on the icon bar
 JSR DrawBlankButton3x2

 LDY #12                \ Blank the fifth button on the icon bar
 JSR DrawBlankButton2x2

 LDY #29                \ Blank the twelfth button on the icon bar
 JSR DrawBlankButton3x2

