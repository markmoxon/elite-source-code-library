\ ******************************************************************************
\
\       Name: TestBBC
\       Type: Subroutine
\   Category: Loader
\    Summary: Fetch details on all the ROMs in the BBC Micro (i.e. the host) and
\             populate the sram%, used%, dupl% and eliterom% variables
\
\ ******************************************************************************

.TestBBC

 LDA &F4                \ Store the current ROM bank on the stack
 PHA

 LDX #15                \ We loop through each sideways ROM, so set a counter in
                        \ X to keep track of the bank number we are testing

.tbbc1

 STX &F4                \ Switch ROM bank X into memory
 STX VIA+&30

                        \ We start by checking if ROM bank X contains RAM, and
                        \ update the X-th entry in the sram% table accordingly

 LDA &8000+6            \ Set A to the type of ROM in bank X, which is in byte
 PHA                    \ #6 of the ROM header, and store it on the stack
 
 EOR #%00000001         \ Flip bit 0 of the ROM type and store the updated type
 STA &8000+6            \ in byte #6 of bank X

 CMP &8000+6            \ If the flipped bit was not stored properly then this
 BNE tbbc2              \ bank is not writeable sideways RAM, so jump to tbbc2
                        \ to move on to the next test

 DEC sram%,X            \ Otherwise this bank is sideways RAM, so decrement the
                        \ X-th entry in the sram% table to &FF

.tbbc2

 PLA                    \ Retrieve the type of ROM in bank X and store it in
 STA &8000+6            \ byte #6 of the ROM header, to reverse the above change

                        \ We now check if ROM bank X contains a ROM image, and
                        \ update the X-th entry in the used% table accordingly

 LDY &8000+7            \ Set Y to the offset of the ROM's copyright message,
                        \ which is in byte #7 of bank X

 LDX #&FC               \ Set X = -4 to use as a counter for checking whether
                        \ bank X contains a copyright message, in which case it
                        \ contains a ROM image
                        \
                        \ We do this by checking for the four copyright
                        \ characters from copyMatch (the negation makes the loop
                        \ check slightly simpler)

.tbbc3

 LDA copyMatch-&FC,X    \ Fetch the next character of the copyright message from
                        \ copyMatch

 CMP &8000,Y            \ If the character from bank X does not match the same
 BNE tbbc4              \ character from the copyright message in copyMatch,
                        \ then bank X is not a valid ROM, so jump to tbbc4 to
                        \ the top four bits of the first byte in ROM bank X and
                        \ move on to the next test

 INY                    \ Increment the character pointer into the copyright
                        \ message in bank X

 INX                    \ Increment the character pointer into the copyright
                        \ message in copyMatch

 BNE tbbc3              \ Loop back until we have checked all four characters

 LDX &F4                \ If we get here then bank X contains the correct
 DEC used%,X            \ copyright string for identifying a ROM, so decrement
                        \ the X-th entry in the used% table to &FF

 JMP tbbc5              \ Jump to tbbc5 to skip the following

.tbbc4

                        \ If we get here then ROM bank X is not a valid ROM

 LDX &F4                \ Set the first byte in ROM bank X to &FX (e.g. set it
 TXA                    \ to &F9 when X = 9), assuming it contains writeable
 ORA #&F0               \ sideways RAM
 STA &8000              \
                        \ I am not sure why we do this

.tbbc5

                        \ We now check if ROM bank X contains the Elite ROM, and
                        \ update the bank number in eliterom% if it does

 BIT eliterom%          \ If bit 7 of eliterom% is clear then we have already
 BPL tbbc7              \ set it to the bank number of the Elite ROM, so jump to
                        \ tbbc7 to move on to the next test
                        \
                        \ Otherwise eliterom% is still set to the default value
                        \ of &FF, so we now check bank X to see if it has the
                        \ correct title for the Elite ROM

 LDY #&F2               \ Set X = -14 to use as a counter for checking whether
                        \ bank X contains a copyright message, in which case it
                        \ contains a ROM image
                        \
                        \ We do this by checking for the 10 title characters in
                        \ titleMatch and the four characters in copyMatch (the
                        \ negation makes the loop check slightly simpler)

.tbbc6

 LDA titleMatch-&F2,Y   \ Fetch the next character of the ROM title message from
                        \ titleMatch

 CMP &8009-&F2,Y        \ If the character from bank X does not match the same
 BNE tbbc7              \ character from the ROM title in titleMatch, then bank
                        \ X is not the Elite ROM, so jump to tbbc7 to move on to
                        \ the next test

 INY                    \ Increment the character pointer into the ROM title in
                        \ bank X

 BNE tbbc6              \ Loop back until we have checked all 14 characters

 STX eliterom%          \ If we get here then bank X contains the correct ROM
                        \ title for the Elite ROM, so store the bank number in
                        \ eliterom%

.tbbc7

                        \ We now check if ROM bank X contains a duplicate ROM,
                        \ update the X-th entry in the dupl% table accordingly

 TXA                    \ Copy the bank number we are checking into A

                        \ We now loop through each of the sideways ROM banks
                        \ that we have already checked to see whether any of
                        \ them contain the same ROM as in in bank X

 LDY #16                \ Set a counter in Y to keep track of the bank number we
                        \ are testing against bank X, starting from the highest
                        \ bank number and working down to bank X

.tbbc8

 STX &F4                \ Switch ROM bank X into memory
 STX VIA+&30

 DEY                    \ Decrement the ROM bank counter in Y, so it counts down
                        \ from 15 to X over the course of the loop

 TYA                    \ If Y = X then we have checked all the ROMs that we
 CMP &F4                \ have already processed, so jump tbbc10 with Y set to X
 BEQ tbbc10             \ to store this value in the dupl% to indicate that this
                        \ ROM is not a duplicate of a ROM in a higher bank

 TYA                    \ Set (&F7 &F6) = (&7F ~Y)
 EOR #%11111111         \
 STA &F6                \ So this goes from &7FF0 to &7FFF as Y decrements from
 LDA #&7F               \ 15 to 1, and (&F7 &F6) + Y is always &7FFF
 STA &F7                \
                        \ This seems wrong, as (&F7 &F6) + Y should start from
                        \ &8000 (though there's no harm as location &7FFF will
                        \ always contain the same value, irrespective of which
                        \ ROM bank is switched in)

.tbbc9

 STX &F4                \ Switch ROM bank X into memory
 STX VIA+&30

 LDA (&F6),Y            \ Fetch the Y-th byte from (&F7 &F6)

 STY &F4                \ Switch ROM bank Y into memory
 STY VIA+&30

 CMP (&F6),Y            \ Compare the byte from ROM bank X with the same byte
                        \ from ROM bank Y

 BNE tbbc8              \ If the bytes do not match, jump to tbbc8 to move on
                        \ to the next ROM, as the ROM in bank Y does not match
                        \ the ROM in bank X

 INC &F6                \ Increment (&F7 &F6), starting with the low byte

 BNE tbbc9              \ Loop back to tbbc9 until we have checked the first
                        \ 256 bytes

 INC &F7                \ Increment the high byte of (&F7 &F6) to move on to
                        \ the next page

 LDA &F7                \ Loop back to keep checking until (&F7 &F6) = &8400,
 CMP #&84               \ by which point we have checked the first three pages
 BNE tbbc9              \ of the ROM

                        \ If we get here then the first three pages of ROM bank
                        \ X match the first three pages of ROM bank Y, so we can
                        \ assume the ROMs are identical, so we fall through to
                        \ set the value of dupl% + X to Y to record that bank X
                        \ is a duplicate

.tbbc10

 TYA                    \ Set the dupl% flag for bank X to Y (so this will be
 STA dupl%,X            \ set to X is bank X is not a duplicate of a ROM in a
                        \ higher bank, otherwise it will be set to the bank
                        \ number of the ROM that bank X is a duplicate of)

 DEX                    \ Decrement the bank number we are testing in X

 BMI tbbc11             \ If we have tested all 16 banks, jump to tbbc11 to
                        \ return from the subroutine

 JMP tbbc1              \ Otherwise loop back to tbbc1 to test the next ROM bank

.tbbc11

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine

