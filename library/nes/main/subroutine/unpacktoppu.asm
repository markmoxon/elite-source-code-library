\ ******************************************************************************
\
\       Name: UnpackToPPU
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unpack compressed image data and send it to the PPU
\  Deep dive: Image and data compression
\
\ ------------------------------------------------------------------------------
\
\ This routine unpacks compressed data and sends it straight to the PPU. The
\ data is typically nametable or pattern data that is unpacked into the PPU's
\ nametable or pattern tables.
\
\ The algorithm is described in the deep dive on "Image and data compression".
\
\ ******************************************************************************

.UnpackToPPU

 LDY #0                 \ We work our way through the packed data at SC(1 0), so
                        \ set an index counter in Y, starting from the first
                        \ data byte at offset zero

.upak1

 LDA (V),Y              \ Set A to the Y-th byte of packed data at V(1 0), which
                        \ is the next byte of data to unpack

 INY                    \ Increment Y to point to the next byte of packed data

 BNE upak2              \ If Y has now wrapped round to zero, increment the
 INC V+1                \ high byte of V(1 0) to point to the next page, so
                        \ that V(1 0) + Y still points to the next data byte

.upak2

 CMP #&40               \ If A >= &40, jump to upak10 to send the data in A
 BCS upak10             \ as it is, and move on to the next byte

 TAX                    \ Store the packed data byte in X so we can retrieve it
                        \ below

 AND #&0F               \ If the data byte in A is in the format &x0, jump to
 BEQ upak9              \ upak9 to send the data in X as it is, and move on
                        \ to the next byte

 CPX #&3F               \ If the data byte in X is &3F, then this indicates we
 BEQ upak11             \ have reached the end of the packed data, so jump to
                        \ upak11 to return from the subroutine, as we are done

 TXA                    \ Set A back to the unpacked data byte, which we stored
                        \ in X above

 CMP #&20               \ If A >= &20, jump to upak5 to process values of &2x
 BCS upak5              \ and &3x (as we already processed values above &40)

                        \ If we get here then we know that the data byte in A is
                        \ of the form &0x or &1x (and not &x0)

 CMP #&10               \ If A >= &10, set the C flag

 AND #&0F               \ Set X to the low nibble of A, so it contains the
 TAX                    \ number of zeroes or &FF bytes that we need to send
                        \ when the data byte is &0x or &1x


 BCS upak4              \ If the data byte in A was >= &10, then we know that A
                        \ is of the form &1x, so jump to upak4 to send the
                        \ number of &FF bytes specified in X

                        \ If we get here then we know that A is of the form
                        \ &0x, so we need to send the number of zero bytes
                        \ specified in X

 LDA #0                 \ Set A as the byte to write to the PPU, so we send
                        \ zeroes

.upak3

                        \ This loop sends byte A to the PPU, X times

 STA PPU_DATA           \ Send the byte in A to the PPU

 DEX                    \ Decrement the byte counter in X

 BNE upak3              \ Loop back to upak3 to send the byte in A again, until
                        \ we have sent it X times

 JMP upak1              \ Jump back to upak1 to unpack the next byte

.upak4

                        \ If we get here then we know that A is of the form
                        \ &1x, so we need to send the number of &FF bytes
                        \ specified in X

 LDA #&FF               \ Set A as the byte to send to the PPU

 BNE upak3              \ Jump to the loop at upak3 to send &FF to the PPU,
                        \ X times (this BNE is effectively a JMP as A is never
                        \ zero)

.upak5

                        \ If we get here then we know that the data byte in A is
                        \ of the form &2x or &3x (and not &x0)

 CMP #&30               \ If A >= &30 then jump to upak6 to process bytes in the
 BCS upak6              \ for &3x

 AND #&0F               \ Set X to the low nibble of A, so it contains the
 TAX                    \ number of times that we need to send the byte
                        \ following the &2x data byte

 LDA (V),Y              \ Set A to the Y-th byte of packed data at V(1 0), which
                        \ is the next byte of data to unpack, i.e. the byte that
                        \ we need to write X times

 INY                    \ Increment Y to point to the next byte of packed data

 BNE upak3              \ If Y has now wrapped round to zero, increment the
 INC V+1                \ high byte of V(1 0) to point to the next page, so
 JMP upak3              \ that V(1 0) + Y still points to the next data byte,
                        \ and jump to the loop in upak3 to send the byte in A,
                        \ X times

.upak6

                        \ If we get here then we know that the data byte in A is
                        \ of the form &3x (and not &x0), and we jump here with
                        \ X set to 0

 AND #&0F               \ Set X to the low nibble of A, so it contains the
 TAX                    \ number of unchanged bytes that we need to send
                        \ following the &3x data byte

.upak7

 LDA (V),Y              \ Set A to the Y-th byte of packed data at V(1 0), which
                        \ is the next byte of data to unpack

 INY                    \ Increment Y to point to the next byte of packed data

 BNE upak8              \ If Y has now wrapped round to zero, increment the
 INC V+1                \ high byte of V(1 0) to point to the next page, so
                        \ that V(1 0) + Y still points to the next data byte

.upak8

 STA PPU_DATA           \ Send the unpacked data in A to the PPU

 DEX                    \ Decrement the byte counter in X

 BNE upak7              \ Loop back to upak7 to send the next byte, until we
                        \ have sent the next X bytes

 JMP upak1              \ Jump back to upak1 to unpack the next byte

.upak9

 TXA                    \ Set A back to the unpacked data byte, which we stored
                        \ in X before jumping here

.upak10

 STA PPU_DATA           \ Send the byte in A to the PPU

 JMP upak1              \ Jump back to upak1 to unpack the next byte

.upak11

 RTS                    \ Return from the subroutine

