\ ******************************************************************************
\
\       Name: SCANCOL
\       Type: Subroutine
\   Category: Dashboard
\    Summary: ???
\
\ ******************************************************************************

IF _SRAM_DISC

.SCANCOL

 LDX #&F0               \ Set X to the default scanner colour of yellow/white
                        \ (a 4-pixel mode 5 byte in colour 2)

 CMP #1                 \ ???
 BEQ scol1

 LDX #&FF               \ Set X to the default scanner colour of green/cyan
                        \ (a 4-pixel mode 5 byte in colour 3)

 CMP #9                 \ ???
 BCS scol1

 LDX #&0F               \ Set X to the default scanner colour of red
                        \ (a 4-pixel mode 5 byte in colour 1)

.scol1

 RTS                    \ Return from the subroutine

 NOP                    \ This code is never run, and just pads out the DEEOR
 NOP                    \ routine in the sideways RAM variant to be the same
 NOP					\ size as in the original version (the sideways RAM
 NOP					\ variant is not encrypted, so the decryption routine
 NOP					\ is disabled and is replaced by NOPs and the SCANCOL
 JMP RSHIPS				\ routine)

ENDIF

