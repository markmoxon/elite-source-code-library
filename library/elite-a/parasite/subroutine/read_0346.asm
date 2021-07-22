\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Get the value of LASCT by sending a read_0346 command to the I/O
\             processor
\
\ ******************************************************************************

.read_0346

 LDA #&98               \ Send command &98 to the I/O processor:
 JSR tube_write         \
                        \   =read_0346()
                        \
                        \ which will ask the I/O processor to send the value of
                        \ its copy of LASCT

 JSR tube_read          \ Set A to the response from the I/O processor, which
                        \ will be the value of LASCT that's stored in the I/O
                        \ processor

 STA LASCT              \ Update LASCT to the value received from the I/O
                        \ processor

 RTS                    \ Return from the subroutine

