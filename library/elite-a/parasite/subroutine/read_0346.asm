\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Get the value of the I/O processor's copy of LASCT
\
\ ******************************************************************************

.read_0346

 LDA #&98               \ Send command &98 to the I/O processor:
 JSR tube_write         \
                        \   =read_0346()
                        \
                        \ which will ask the I/O processor to send the value of
                        \ its copy of LASCT

 JSR tube_read          \ Get the value that the I/O processor sends into A

 STA LASCT              \ Update LASCT to the value received from the I/O
                        \ processor

 RTS                    \ Return from the subroutine

