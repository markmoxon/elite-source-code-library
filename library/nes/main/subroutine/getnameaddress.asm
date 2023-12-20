\ ******************************************************************************
\
\       Name: GetNameAddress
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Get the addresses in the nametable buffers for a given tile
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XC                  The tile column
\
\   YC                  The tile row
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   SC(1 0)             The address in nametable buffer 0 for the tile
\
\   SC2(1 0)            The address in nametable buffer 1 for the tile
\
\ ******************************************************************************

.GetNameAddress

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDA SC                 \ Set SC(1 0) = SC(1 0) + XC
 CLC                    \
 ADC XC                 \ Starting with the low bytes
 STA SC                 \
                        \ So SC(1 0) contains the address in nametable buffer 0
                        \ of the text character at column XC on row YC

 STA SC2                \ Set SC2(1 0) = SC2(1 0) + XC
                        \
                        \ Starting with the low bytes
                        \
                        \ So SC2(1 0) contains the address in nametable buffer 1
                        \ of the text character at column XC on row YC

 BCC nadd1              \ If the above addition overflowed, then increment the
 INC SC+1               \ high bytes of SC(1 0) and SC2(1 0) accordingly
 INC SC2+1

.nadd1

 RTS                    \ Return from the subroutine

