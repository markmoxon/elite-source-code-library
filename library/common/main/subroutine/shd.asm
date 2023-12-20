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

 DEX                    \ Increment the shield value so that it doesn't go past
                        \ a maximum of 255

 RTS                    \ Return from the subroutine

.SHD

 INX                    \ Increment the shield value

 BEQ SHD-2              \ If the shield value is 0 then this means it was 255
                        \ before, which is the maximum value, so jump to SHD-2
                        \ to bring it back down to 258 and return

                        \ Otherwise fall through into DENGY to drain our energy
                        \ to pay for all this shield charging

