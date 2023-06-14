\ ******************************************************************************
\
\       Name: write_card
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Display a ship card in the encyclopedia
\  Deep dive: The Encyclopedia Galactica
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the ship whose card we want to display,
\                       in the range 0 to 27 (see card_addr for a list of
\                       ship numbers)
\
\ ******************************************************************************

.write_card

 ASL A                  \ Set Y = A * 2, so we can use it as an index into the
 TAY                    \ card_addr table (which has two bytes per entry)

 LDA card_addr,Y        \ Set V(1 0) to the Y-th entry from card_addr, so it
 STA V                  \ points to the data for the ship card that we want to
 LDA card_addr+1,Y      \ show
 STA V+1

.card_repeat

                        \ We now loop around card_repeat, with each iteration
                        \ printing a different section of the ship card. We
                        \ update V(1 0) so it always points to the data to print
                        \ in the ship card, and we look up the corresponding
                        \ section of the card_pattern table to see how to lay
                        \ out the card (card_pattern contains text coordinates
                        \ and label data that describe the layout of the ship
                        \ cards)

 JSR MT1                \ Switch to ALL CAPS when printing extended tokens

 LDY #0                 \ Fetch the byte at V(1 0) into X, which will either be
 LDA (V),Y              \ the number of a card section (e.g. 1 for inservice
 TAX                    \ date, 2 for combat factor and so on), or a 0 if we
                        \ have reached the end of the card data

 BEQ quit_card          \ If the byte we just fetched is a zero, jump to
                        \ quit_card to return from the subroutine, as we have
                        \ reached the end of the card data

 BNE card_check         \ Otherwise we have found a valid card section, so jump
                        \ to card_check to start looking for the corresponding
                        \ layout pattern in card_pattern (the BNE is effectively
                        \ a JMP as we just passed through a BEQ)

.card_find

                        \ If we get here than we want to increment Y until it
                        \ points to the start of the next pattern that comes
                        \ after our current position of card_pattern + Y

 INY                    \ Increment Y by 3 to step to the next line of data (as
 INY                    \ the card_pattern table is made up of lines of 3 bytes
 INY                    \ each)

 LDA card_pattern-1,Y   \ Fetch the last byte of the previous 3-byte line

 BNE card_find          \ If it is non-zero then we are still in the same
                        \ pattern as in the previous iteration, so loop back to
                        \ move onto the next line of 3 bytes

                        \ Otherwise we have moved onto the next pattern, so now
                        \ we check whether we have reached the pattern we seek

.card_check

                        \ When we first jump here from above, we want to search
                        \ through the card_pattern table for the pattern that
                        \ corresponds to card section X, where X starts at 1. We
                        \ also jump here with Y set to 0
                        \
                        \ We find what we are looking for by stepping through
                        \ each pattern, decreasing X as we go past each pattern,
                        \ and increasing Y so that Y points to the start of the
                        \ next pattern to check (as an offset from card_pattern)
                        \
                        \ So as we iterate round the loop, at any one point, we
                        \ want to skip over X - 1 more patterns, starting from
                        \ the pattern at card_pattern + Y

 DEX                    \ Decrement the section number in X

 BNE card_find          \ If X hasn't reached 0, then we haven't stepped through
                        \ the right number of patterns yet, so jump to card_find
                        \ to increment Y so that it points to the start of the
                        \ next pattern in card_pattern

.card_found

                        \ When we get here, we have stepped through the correct
                        \ number of patterns for the card section we want to
                        \ print, and Y will point to the pattern within the
                        \ card_pattern table that corresponds to the section we
                        \ want to print, so we now fetch the pattern from
                        \ card_pattern and print the data in that pattern
                        \
                        \ The pattern for each section is made up of multiple
                        \ lines of 3 bytes each, with each line consisting of:
                        \
                        \   * Text column
                        \   * Text row
                        \   * What to print (i.e. a label or ship data)

 LDA card_pattern,Y     \ The first byte of each 3-byte line in the pattern is
 STA XC                 \ the x-coordinate where we should print the text, so
                        \ move the text cursor to the correct column

 LDA card_pattern+1,Y   \ The second byte of each 3-byte line in the pattern
 STA YC                 \ is the y-coordinate where we should print the text, so
                        \ move the text cursor to the correct row

 LDA card_pattern+2,Y   \ The third byte of each 3-byte line in the pattern is
                        \ either a text token to print for the label (if it's
                        \ non-zero) or it denotes that we should print the
                        \ relevant ship data (if it's zero), so fetch the value
                        \ into A

 BEQ card_details       \ If A = 0 then we should print the relevant ship data,
                        \ so jump to card_details to do just that

 JSR write_msg3         \ Otherwise this is a label, so print the text token in
                        \ A, which prints the label in the right place

 INY                    \ We now need to fetch the next line of the pattern, so
 INY                    \ we increment Y by 3 to step to the next 3-byte line of
 INY                    \ pattern data

 BNE card_found         \ Loop back to card_found to move onto the next line in
                        \ the pattern (the BNE is effectively a JMP as Y is
                        \ never zero)

.card_details

                        \ If we get here, then we have printed all the labels in
                        \ the pattern, and it's time to print the ship data,
                        \ which is at V(1 0) (the first time we get here, V(1 0)
                        \ points to the start of the ship data, and as we loop
                        \ through each bit of data, we update V(1 0) so that it
                        \ always points to the next bit of data to print)

 JSR MT2                \ Switch to Sentence Case when printing extended tokens

 LDY #0                 \ We now loop through each character or token in the
                        \ ship data, which is stored as a recursive token, so
                        \ set a counter in Y for each character or token in the
                        \ ship data (we start this at 0 and increment it
                        \ straight away, as the first byte in the ship data at
                        \ V(1 0) is the section number, rather than the data
                        \ itself

.card_loop

 INY                    \ Increment the character counter to point to the next
                        \ character or token in the ship data

 LDA (V),Y              \ Set A to the next character or token to print

 BEQ card_end           \ If A = 0 then we have reached the end of this bit of
                        \ ship data, so jump to card_end to move onto the next
                        \ one

 BMI card_msg           \ If A > 127 then this is a recursive token, so jump to
                        \ card_msg to print it

 CMP #32                \ If A < 32 then this is a jump token, so jump to
 BCC card_macro         \ card_macro to print it

 JSR DTS                \ Otherwise this is a character rather than a token, so
                        \ call DTS to print it in the correct case

 JMP card_loop          \ Jump back to card_loop to print the next token in the
                        \ ship data

.card_macro

 JSR DT3                \ Call DT3 to print the jump token given in A

 JMP card_loop          \ Jump back to card_loop to print the next token in the
                        \ ship data

.card_msg

 CMP #215               \ If A >= 215, then this is a two-letter token, so jump
 BCS card_pairs         \ to card_pairs to print it

 AND #%01111111         \ This is a recursive token and A is in the range 128 to
                        \ 214, so clear bit 7 to reduce it to the range 0 to 86,
                        \ which corresponds to tokens in the msg_3 table (as we
                        \ set bit 7 when inserting msg_3 tokens into the ship
                        \ data with the CTOK macro)

 JSR write_msg3         \ Print the extended token in A

 JMP card_loop          \ Jump back to card_loop to print the next token in the
                        \ ship data

.card_pairs

 JSR msg_pairs          \ Print the extended two-letter token in A

 JMP card_loop          \ Jump back to card_loop to print the next token in the
                        \ ship data

.card_end

                        \ We have now printed this bit of ship data and the last
                        \ character we printed was at V(1 0) + Y, so we now
                        \ update V(1 0) so that it points to the first byte of
                        \ the next bit of ship data, by doing this:
                        \
                        \   V(1 0) = V(1 0) + Y + 1

 TYA                    \ First we add the low bytes, setting the C flag to add
 SEC                    \ an extra 1
 ADC V
 STA V

 BCC card_repeat        \ If the above addition didn't overflow, we are done, so
                        \ loop back to card_repeat to move onto the next bit of
                        \ ship data

 INC V+1                \ The addition overflowed, so increment the high byte,
                        \ as V(1 0) just passed a page boundary

 BCS card_repeat        \ Loop back to card_repeat to move onto the next bit of
                        \ ship data (this BCS is effectively a JMP as we passed
                        \ through the BCC above)

.quit_card

 RTS                    \ Return from the subroutine

