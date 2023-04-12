\ ******************************************************************************
\
\       Name: SOUS1
\       Type: Subroutine
\   Category: Sound
\    Summary: Write sound data directly to the 76489 sound chip
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The sound byte to send to the 76489 sound chip
\
\ Other entry points:
\
\   SOUR1               Contains an RTS
\
\ ******************************************************************************

.SOUS1

 LDX #%11111111         \ Set 6522 System VIA data direction register DDRA
 STX VIA+&43            \ (SHEILA &43) to %11111111. This sets the ORA register
                        \ so that bits 0-7 of ORA will be sent to the 76489
                        \ sound chip

 STA VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to A, the sound data we want to send

 LDA #%00000000         \ Activate the sound chip by clearing bit 3 of the
 STA VIA+&40            \ 6522 System VIA output register ORB (SHEILA &40)

 PHA                    \ These instructions don't do anything apart from
 PLA                    \ keeping the sound chip activated for at least 8us,
 PHA                    \ which we need to do in order for the data to make
 PLA                    \ it to the chip

 LDA #%00001000         \ Deactivate the sound chip by setting bit 3 of the
 STA VIA+&40            \ 6522 System VIA output register ORB (SHEILA &40)

.SOUR1

 RTS                    \ Return from the subroutine

