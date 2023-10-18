\ ******************************************************************************
\
\       Name: UpdateViewWithFade
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Fade the screen to black, if required, hide all sprites and update
\             the view
\
\ ******************************************************************************

.UpdateViewWithFade

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

                        \ Fall through into UpdateView to update the view

