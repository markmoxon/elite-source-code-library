\ ******************************************************************************
\
\       Name: SetScreenForUpdate
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Get the screen ready for updating by hiding all sprites, after
\             fading the screen to black if we are changing view
\
\ ******************************************************************************

.SetScreenForUpdate

 LDA QQ11a              \ If QQ11 = QQ11a, then we are not currently changing
 CMP QQ11               \ view, so jump to HideMostSprites to hide all sprites
 BEQ HideMostSprites    \ except for sprite 0 and the icon bar pointer

                        \ Otherwise fall through into FadeAndHideSprites to fade
                        \ the screen to black and hide all the sprites

