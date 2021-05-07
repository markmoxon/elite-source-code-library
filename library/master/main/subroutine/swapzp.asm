\ ******************************************************************************
\
\       Name: SWAPZP
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Swap zero page (&0090 to &00EF) with the buffer at &3000
\
\ ******************************************************************************


.SWAPZP

IF _COMPACT

 JSR $158D              \ ???

ENDIF

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 LDX #&90               \ We want to swap zero page from &0090 and up, so set an
                        \ index in X, starting from &90

.SWPL1

 LDA ZP,X               \ Swap the X-th byte of ZP with the X-th byte of &3000
 LDY &3000,X
 STY ZP,X
 STA &3000,X

 INX                    \ Increment the loop counter

 CPX #&F0               \ Loop back until we have swapped up to location &00EF
 BNE SWPL1

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 LDA #6                 \ Set bits 0-3 of the ROM Select latch at SHEILA &30 to
 STA VIA+&30            \ 6, to switch sideways ROM bank 6 into into &8000-&BFFF
                        \ in main memory (we already confirmed that this bank
                        \ contains RAM rather than ROM in the loader)

 RTS                    \ Return from the subroutine

