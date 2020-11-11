\ ******************************************************************************
\
\       Name: PROJ
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Project the current ship onto the screen
\
\ ------------------------------------------------------------------------------
\
\ Project the current ship's location onto the screen, either returning the
\ screen coordinates of the projection (if it's on-screen), or returning an
\ error via the C flag.
\
\ In this context, "on-screen" means that the point is projected into the
\ following range:
\
\   centre of screen - 1024 < x < centre of screen + 1024
\   centre of screen - 1024 < y < centre of screen + 1024
\
\ This is to cater for ships (and, more likely, planets and suns) whose centres
\ are off-screen but whose edges may still be visible.
\
\ The projection calculation is:
\
\   K3(1 0) = #X + x / z
\   K4(1 0) = #Y + y / z
\
\ where #X and #Y are the pixel x-coordinate and y-coordinate of the centre of
\ the screen.
\
\ Arguments:
\
\   INWK                The ship data block for the ship to project on-screen
\
\ Returns:
\
\   K3(1 0)             The x-coordinate of the ship's projection on-screen
\
\   K4(1 0)             The y-coordinate of the ship's projection on-screen
\
\   C flag              Set if the ship's projection doesn't fit on the screen,
\                       clear if it does project onto the screen
\
\   A                   Contains K4+1, the high byte of the y-coordinate
\
\ ******************************************************************************

.PROJ

 LDA INWK               \ Set P(1 0) = (x_hi x_lo)
 STA P                  \            = x
 LDA INWK+1
 STA P+1

 LDA INWK+2             \ Set A = x_sign

 JSR PLS6               \ Call PLS6 to calculate:
                        \
                        \   (X K) = (A P) / (z_sign z_hi z_lo)
                        \         = (x_sign x_hi x_lo) / (z_sign z_hi z_lo)
                        \         = x / z

 BCS PL2-1              \ If the C flag is set then the result overflowed and
                        \ the coordinate doesn't fit on the screen, so return
                        \ from the subroutine with the C flag set (as PL2-1
                        \ contains an RTS)

 LDA K                  \ Set K3(1 0) = (X K) + #X
 ADC #X                 \             = #X + x / z
 STA K3                 \
                        \ first doing the low bytes

 TXA                    \ And then the high bytes. #X is the x-coordinate of
 ADC #0                 \ the centre of the mode 4 screen, so this converts the
 STA K3+1               \ space x-coordinate into a screen x-coordinate

 LDA INWK+3             \ Set P(1 0) = (y_hi y_lo)
 STA P
 LDA INWK+4
 STA P+1

 LDA INWK+5             \ Set A = -y_sign
 EOR #%10000000

 JSR PLS6               \ Call PLS6 to calculate:
                        \
                        \   (X K) = (A P) / (z_sign z_hi z_lo)
                        \         = -(y_sign y_hi y_lo) / (z_sign z_hi z_lo)
                        \         = -y / z

 BCS PL2-1              \ If the C flag is set then the result overflowed and
                        \ the coordinate doesn't fit on the screen, so return
                        \ from the subroutine with the C flag set (as PL2-1
                        \ contains an RTS)

 LDA K                  \ Set K4(1 0) = (X K) + #Y
 ADC #Y                 \             = #Y - y / z
 STA K4                 \
                        \ first doing the low bytes

 TXA                    \ And then the high bytes. #Y is the y-coordinate of
 ADC #0                 \ the centre of the mode 4 screen, so this converts the
 STA K4+1               \ space x-coordinate into a screen y-coordinate

 CLC                    \ Clear the C flag to indicate success

 RTS                    \ Return from the subroutine

