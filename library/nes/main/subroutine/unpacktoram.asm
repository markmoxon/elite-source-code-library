\ ******************************************************************************
\
\       Name: UnpackToRAM
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unpack compressed image data to RAM
\
\ ------------------------------------------------------------------------------
\
\ This routine unpacks compressed data into RAM. The data is typically nametable
\ or pattern data that is unpacked into the nametable or pattern buffers.
\
\ UnpackToRAM reads packed data from V(1 0) and writes unpacked data to SC(1 0)
\ by fetching bytes one at a time from V(1 0), incrementing V(1 0) after each
\ fetch, and unpacking and writing the data to SC(1 0) as it goes.
\
\ If we fetch byte &xx from V(1 0), then we unpack it as follows:
\
\   * If &xx >= &40, output byte &xx as it is and move on to the next byte
\
\   * If &xx = &x0, output byte &x0 as it is and move on to the next byte
\
\   * If &xx = &3F, stop and return from the subroutine, as we have finished
\
\   * If &xx >= &20, jump to upac6 to do the following:
\
\     * If &xx >= &30, jump to upac7 to output the next &0x bytes from V(1 0) as
\                      they are, incrementing V(1 0) as we go
\
\     * If &xx >= &20, fetch the next byte from V(1 0), increment V(1 0), and
\                      output the fetched byte for &0x bytes
\
\   * If &xx >= &10, jump to upac5 to output &FF for &0x bytes
\
\   * If &xx < &10, output 0 for &0x bytes
\
\ In summary, this is how each byte gets unpacked:
\
\   &00 = unchanged
\   &0x = output 0 for &0x bytes
\   &10 = unchanged
\   &1x = output &FF for &0x bytes
\   &20 = unchanged
\   &2x = output the next byte for &0x bytes
\   &30 = unchanged
\   &3x = output the next &0x bytes unchanged
\   &40 and above = unchanged
\
\ ******************************************************************************

.UnpackToRAM

 LDY #0                 \ We work our way through the packed data at SC(1 0), so
                        \ set an index counter in Y, starting from the first
                        \ data byte at offset zero

.upac1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ Set X = 0, so we can use a LDA (V,X) instruction below
                        \ to fetch the next data byte from V(1 0), as the 6502
                        \ doesn't have a LDA (V) instruction

 LDA (V,X)              \ Set A to the byte of packed data at V(1 0), which is
                        \ the next byte of data to unpack
                        \
                        \ As X = 0, this instruction is effectively LDA (V),
                        \ which isn't a valid 6502 instruction on its own

 INC V                  \ Increment V(1 0) to point to the next byte of packed
 BNE upac2              \ data
 INC V+1

.upac2

 CMP #&40               \ If A >= &40, jump to unpac12 to output the data in A
 BCS upac12             \ as it is, and move on to the next byte

                        \ If we get here then we know that the data byte in A is
                        \ of the form &0x, &1x, &2x or &3x

 TAX                    \ Store the packed data byte in X so we can retrieve it
                        \ below

 AND #&0F               \ If the data byte in A is in the format &x0, jump to
 BEQ upac11             \ upac11 to output the data in X as it is, and move on
                        \ to the next byte

 CPX #&3F               \ If the data byte in X is &3F, then this indicates we
 BEQ upac13             \ have reached the end of the packed data, so jump to
                        \ upac13 to return from the subroutine, as we are done

 TXA                    \ Set A back to the unpacked data byte, which we stored
                        \ in X above

 CMP #&20               \ If A >= &20, jump to upac6 to process values of &2x
 BCS upac6              \ and &3x (as we already processed values above &40)

                        \ If we get here then we know that the data byte in A is
                        \ of the form &0x or &1x (and not &x0)

 CMP #&10               \ If A >= &10, set the C flag

 AND #&0F               \ Set X to the low nibble of A, so it contains the
 TAX                    \ number of zeroes or &FF bytes that we need to output
                        \ when the data byte is &0x or &1x

 BCS upac5              \ If the data byte in A was >= &10, then we know that A
                        \ is of the form &1x, so jump to upac5 to output the
                        \ number of &FF bytes specified in X

                        \ If we get here then we know that A is of the form
                        \ &0x, so we need to output the number of zero bytes
                        \ specified in X

 LDA #0                 \ Set A as the byte to write to SC(1 0), so we output
                        \ zeroes

.upac3

                        \ This loop writes byte A to SC(1 0), X times

 STA (SC),Y             \ Write the byte in A to SC(1 0)

 INY                    \ Increment Y to point to the next data byte

 BNE upac4              \ If Y has now wrapped round to zero, loop back to upac1
                        \ to unpack the next data byte

 INC SC+1               \ Otherwise Y is now zero, so increment the high byte of
                        \ SC(1 0) to point to the next page, so that SC(1 0) + Y
                        \ still points to the next data byte

.upac4

 DEX                    \ Decrement the byte counter in X

 BNE upac3              \ Loop back to upac3 to write the byte in A again, until
                        \ we have written it X times

 JMP upac1              \ Jump back to upac1 to unpack the next byte

.upac5

                        \ If we get here then we know that A is of the form
                        \ &1x, so we need to output the number of &FF bytes
                        \ specified in X

 LDA #&FF               \ Set A as the byte to write to SC(1 0), so we output
                        \ &FF

 BNE upac3              \ Jump to the loop at upac3 to output &FF to SC(1 0),
                        \ X times (this BNE is effectively a JMP as A is never
                        \ zero)

.upac6

                        \ If we get here then we know that the data byte in A is
                        \ of the form &2x or &3x (and not &x0)

 LDX #0                 \ Set X = 0, so we can use a LDA (V,X) instruction below
                        \ to fetch the next data byte from V(1 0), as the 6502
                        \ doesn't have a LDA (V) instruction

 CMP #&30               \ If A >= &30 then jump to upac7 to process bytes in the
 BCS upac7              \ for &3x

                        \ If we get here then we know that the data byte in A is
                        \ of the form &2x (and not &x0)

 AND #&0F               \ Set T to the low nibble of A, so it contains the
 STA T                  \ number of times that we need to output the byte
                        \ following the &2x data byte

 LDA (V,X)              \ Set A to the byte of packed data at V(1 0), which is
                        \ the next byte of data to unpack, i.e. the byte that we
                        \ need to write X times
                        \
                        \ As X = 0, this instruction is effectively LDA (V),
                        \ which isn't a valid 6502 instruction on its own

 LDX T                  \ Set X to the number of times we need to output the
                        \ byte in A

 INC V                  \ Increment V(1 0) to point to the next data byte (as we
 BNE upac3              \ just read the one after the &2x data byte), and jump
 INC V+1                \ to the loop in upac3 to output the byte in A, X times
 JMP upac3

.upac7

                        \ If we get here then we know that the data byte in A is
                        \ of the form &3x (and not &x0), and we jump here with
                        \ X set to 0

 AND #&0F               \ Set T to the low nibble of A, so it contains the
 STA T                  \ number of unchanged bytes that we need to output
                        \ following the &3x data byte

.upac8

 LDA (V,X)              \ Set A to the byte of packed data at V(1 0), which is
                        \ the next byte of data to unpack
                        \
                        \ As X = 0, this instruction is effectively LDA (V),
                        \ which isn't a valid 6502 instruction on its own

 INC V                  \ Increment V(1 0) to point to the next data byte (as we
 BNE upac9              \ just read the one after the &2x data byte)
 INC V+1

                        \ We now loop T times, outputting the next data byte on
                        \ each iteration, so we end up writing the next T bytes
                        \ unchanged

.upac9

 STA (SC),Y             \ Write the unpacked data in A to the Y-th byte of
                        \ SC(1 0)

 INY                    \ Increment Y to point to the next data byte

 BNE upac10             \ If Y has now wrapped round to zero, increment the
 INC SC+1               \ high byte of SC(1 0) to point to the next page, so
                        \ that SC(1 0) + Y still points to the next data byte

.upac10

 DEC T                  \ Decrement the loop counter in T

 BNE upac8              \ Loop back until we have copied the next T bytes
                        \ unchanged from V(1 0) to SC(1 0)

 JMP upac1              \ Jump back to upac1 to unpack the next byte

.upac11

 TXA                    \ Set A back to the unpacked data byte, which we stored
                        \ in X before jumping here

.upac12

 STA (SC),Y             \ Write the unpacked data in A to the Y-th byte of
                        \ SC(1 0)

 INY                    \ Increment Y to point to the next data byte

 BNE upac1              \ If Y has now wrapped round to zero, loop back to upac1
                        \ to unpack the next data byte

 INC SC+1               \ Otherwise Y is now zero, so increment the high byte of
 JMP upac1              \ SC(1 0) to point to the next page, so that SC(1 0) + Y
                        \ still points to the next data byte

.upac13

 RTS                    \ Return from the subroutine

