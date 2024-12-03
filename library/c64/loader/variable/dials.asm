\ ******************************************************************************
\
\       Name: DIALS
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The dashboard bitmap and colour data for screen RAM
\
\ ******************************************************************************

.DIALS

 SKIP 24                \ This indents the image by three character blocks to
                        \ skip past the first three chracters of the left screen
                        \ margin (the fourth character contains the border box
                        \ along the edge of the dashboard)

 INCBIN "versions/c64/1-source-files/images/C.CODIALS.bin"

