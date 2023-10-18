\ ******************************************************************************
\
\       Name: SendInventoryToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send X batches of 16 bytes from SC(1 0) to the PPU, for sending
\             the inventory icon bar image
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of batches of 16 bytes to send to the PPU
\
\   SC(1 0)             The address of the data to send
\
\ ******************************************************************************

.SendInventoryToPPU

 LDY #0                 \ Set Y as an index counter for the following block,
                        \ which sends 16 bytes of data from SC(1 0) to the PPU,
                        \ using Y as an index that starts at 0 and increments
                        \ after each byte
                        \
                        \ We repeat this process for X iterations

                        \ We repeat the following code 16 times, so it sends
                        \ one whole pattern of 16 bytes to the PPU (eight bytes
                        \ for each bitplane)

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 16
 CLC                    \
 ADC #16                \ Starting with the low bytes
 STA SC

 BCC smis1              \ And then the high bytes
 INC SC+1

.smis1

 DEX                    \ Decrement the block counter in X

 BNE SendInventoryToPPU \ Loop back to the start of the subroutine until we have
                        \ sent X batches of 16 bytes

 RTS                    \ Return from the subroutine

