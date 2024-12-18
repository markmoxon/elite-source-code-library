\ ******************************************************************************
\
\       Name: SHD
\       Type: Subroutine
\   Category: Flight
\    Summary: Charge a shield and drain some energy from the energy banks
\
\ ------------------------------------------------------------------------------
\
\ Charge up a shield, and if it needs charging, drain some energy from the
\ energy banks.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The value of the shield to recharge
\
\ ******************************************************************************

 DEX                    \ If we get here then we just incremented the shield
                        \ value back around to zero, so decrement it back down
                        \ to 255 so it stays at the maximum value of 255

 RTS                    \ Return from the subroutine

.SHD

 INX                    \ Increment the shield value

 BEQ SHD-2              \ If the shield value is 0 then this means it was 255
                        \ before, which is the maximum value, so jump to SHD-2
                        \ to bring it back down to 255 and return without
                        \ draining our energy banks

                        \ Otherwise fall through into DENGY to drain our energy
                        \ to pay for all this shield charging

