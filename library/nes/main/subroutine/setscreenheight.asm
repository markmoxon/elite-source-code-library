\ ******************************************************************************
\
\       Name: SetScreenHeight
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the screen height variables to the specified height
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The y-coordinate of the centre of the screen (i.e. half
\                       the screen height)
\
\ ******************************************************************************

.SetScreenHeight

 STA halfScreenHeight   \ Store the half-screen height in halfScreenHeight

 ASL A                  \ Double the half-screen height in A to get the full
                        \ screen height, while setting the C flag to bit 7 of
                        \ the original argument
                        \
                        \ This routine is only ever called with A set to either
                        \ 72 or 77, so the C flag is never set

 STA screenHeight       \ Store the full screen height in screenHeight

 SBC #0                 \ Set the value of Yx2M1 as follows:
 STA Yx2M1              \
                        \   * If the C flag is set: Yx2M1 = screenHeight
                        \
                        \   * If the C flag is clear: Yx2M1 = screenHeight - 1
                        \
                        \ This routine is only ever called with A set to either
                        \ 72 or 77, so the C flag is never set, so we always set
                        \ Yx2M1 = screenHeight - 1

 RTS                    \ Return from the subroutine

