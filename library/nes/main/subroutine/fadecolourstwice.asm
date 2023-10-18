\ ******************************************************************************
\
\       Name: FadeColoursTwice
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Fade the screen colours towards black twice
\
\ ******************************************************************************

.FadeColoursTwice

 JSR FadeColours        \ Call FadeColours to fade the screen colours towards
                        \ black

                        \ Fall through into FadeColours to fade the screen
                        \ colours a second time

