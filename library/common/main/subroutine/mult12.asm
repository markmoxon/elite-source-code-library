\ ******************************************************************************
\
\       Name: MULT12
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (S R) = Q * A
\
\ ------------------------------------------------------------------------------
\
\ Calculate:
\
\   (S R) = Q * A
\
\ ******************************************************************************

.MULT12

 JSR MULT1              \ Set (A P) = Q * A

IF NOT(_NES_VERSION)

 STA S                  \ Set (S R) = (A P)
 LDA P                  \           = Q * A
 STA R

ELIF _NES_VERSION

 STA S                  \ Set (S P) = (A P)
                        \           = Q * A

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA P                  \ Set (S R) = (S P)
 STA R                  \           = Q * A

ENDIF

 RTS                    \ Return from the subroutine

