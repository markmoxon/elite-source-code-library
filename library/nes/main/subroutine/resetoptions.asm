\ ******************************************************************************
\
\       Name: ResetOptions
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the game options to their default values
\
\ ******************************************************************************

.ResetOptions

 LDA #0                 \ Configure the controller y-axis to the default
 STA JSTGY              \ direction (i.e. not reversed) by setting JSTGY to 0

 STA disableMusic       \ Configure music to be enabled by default by setting
                        \ disableMusic to 0

 LDA #&FF               \ Configure damping to be enabled by default by setting
 STA DAMP               \ DAMP to &FF

 STA DNOIZ              \ Configure sound to be enabled by default by setting
                        \ DNOIZ to &FF

 RTS                    \ Return from the subroutine

