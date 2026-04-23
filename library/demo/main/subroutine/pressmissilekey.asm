\ ******************************************************************************
\
\       Name: PressMissileKey
\       Type: Subroutine
\   Category: Demo
\    Summary: "Press" a key by populating the key logger directly
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The internal key number to be "pressed"
\
\ ******************************************************************************

.PressMissileKey

 ORA #%10000000         \ Set bit 7 of the key that we need to "press", so that
                        \ it registers as a key press when we add it to the key
                        \ logger

 STA KL                 \ Store the key press in the key logger to "press" the
                        \ specified key

 RTS                    \ Return from the subroutine

