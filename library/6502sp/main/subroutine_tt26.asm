\ ******************************************************************************
\
\       Name: TT26
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor, supporting right-alignment
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ Other entry points:
\
\  rT9                  Contains an RTS
\
\ ******************************************************************************

.DASC

.TT26

 STX SC                 \ Store X in SC, so we can retrieve it below

 LDX #%11111111         \ Set DTW8 = %11111111, so we don't change case
 STX DTW8

 CMP #'.'               \ If the character in A is a word terminator:
 BEQ DA8                \
 CMP #':'               \   * Full stop
 BEQ DA8                \   * Colon
 CMP #10                \   * Line feed
 BEQ DA8                \   * Carriage return
 CMP #12                \   * Space
 BEQ DA8                \
 CMP #' '               \ then skip the following instruction
 BEQ DA8

 INX                    \ Increment X to 0, so DTW2 gets set to 0 below

.DA8

 STX DTW2               \ Store X in DTW2, so DTW2 is now:
                        \
                        \   * 0 if this character is a word terminator
                        \   * %11111111 if it isn't

 LDX SC                 \ Retrieve the original value of X from SC

 BIT DTW4               \ If bit 7 of DTW4 is set, skip the following
 BMI P%+5               \ instruction

 JMP CHPR               \ Bit 7 of DTW4 is clear, so jump down to DHPR to print
                        \ the character

 BVS P%+6               \ If bit 6 of DTW4 is set, skip the following two
                        \ instructions

 CMP #12                \ If the character in A is a carriage return, jump down
 BEQ DA1                \ to DA1

                        \ If we get here, bit 7 of DTW4 is set, and either bit 6
                        \ of DTW4 is set or this is a carriage return

 LDX DTW5               \ Store the character in A in byte #DTW5 in BUF
 STA BUF,X

 LDX SC                 \ Retrieve the original value of X from SC

 INC DTW5               \ Increment DTW5 to point to the next byte in BUF

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

.DA1

                        \ If we get here, bit 7 of DTW4 is set, bit 6
                        \ of DTW4 is clear and this is a carriage return

 TXA                    \ Store X and Y on the stack
 PHA
 TYA
 PHA

.DA5

 LDX DTW5               \ If DTW5 = 0 then jump down to DA6+3 to print a newline
 BEQ DA6+3

 CPX #(LL+1)            \ If X < LL+1, i.e. X <= LL, jump down to DA6 to print
 BCC DA6                \ the contents of BUF followed by a newline

                        \ Otherwise X > LL, so this word does not fit on the
                        \ line

 LSR SC+1               \ Shift SC+1 to the right

.DA11

 LDA SC+1               \ If bit 7 of SC+1 is set, skip the following two
 BMI P%+6               \ instructions

 LDA #%01000000         \ Set bit 6 of SC+1
 STA SC+1

 LDY #(LL-1)            \ Set Y = line length

.DAL1

 LDA BUF+LL             \ If the LL-th byte in BUF is a space, jump down to DA2
 CMP #' '
 BEQ DA2

.DAL2

 DEY                    \ Decrement the loop counter in Y

 BMI DA11               \ If Y <= 0, loop back to DA11
 BEQ DA11

 LDA BUF,Y              \ If the Y-th byte in BUF is not a space, jump down to
 CMP #' '               \ DAL2
 BNE DAL2

 ASL SC+1               \ 
 BMI DAL2

                        \ We now want to insert a character into the buffer BUF at position SC

 STY SC                 \ Store Y in SC

 LDY DTW5               \ Fetch the buffer pointer from DTW5 into Y

.DAL6

 LDA BUF,Y              \ Copy the Y-th character from BUF into the Y+1-th
 STA BUF+1,Y            \ position

 DEY                    \ Decrement the loop counter in Y

 CPY SC                 \ Loop back to shift the next character along, until we
 BCS DAL6               \ have moved the SC-th character (i.e. Y < SC)

 INC DTW5               \ Increment the buffer pointer in DTW5

\LDA #' '

.DAL3

 CMP BUF,Y              \ If the 
 BNE DAL1

 DEY

 BPL DAL3

 BMI DA11

.DA2

                        \ This subroutine prints out a full line of characters
                        \ from the start of the line buffer in BUF, followed by
                        \ a newline. It then removes that line from the buffer,
                        \ shuffling the rest of the buffer contents down

 LDX #LL                \ Call DAS1 to print out the first LL characters from
 JSR DAS1               \ the line buffer in BUF

 LDA #12                \ Print a newline
 JSR CHPR

 LDA DTW5               \ Subtract #LL from the end-of-buffer pointer in DTW5
\CLC                    \
 SBC #LL                \ The CLC instruction is commented out in the original
 STA DTW5               \ source. It isn't needed as CHPR clears the C flag

 TAX                    \ Copy the new value of DTW5 into X

 BEQ DA6+3              \ If DTW5 = 0 then jump down to DA6+3 to print a newline
                        \ as the buffer is now empty

                        \ If we get here then we have printed our line but there
                        \ is more in the buffer, so we now want to remove the
                        \ line we just printed from the start of BUF

 LDY #0                 \ Set Y = 0 to count through the characters in BUF

 INX                    \ Increment X, so it now contains the number of
                        \ characters in the buffer (as DTW5 is a zero-based
                        \ pointer and is therefore equal to the number of
                        \ characters minus 1)

.DAL4

 LDA BUF+LL+1,Y         \ Copy the Y-th character from BUF+LL to BUF
 STA BUF,Y

 INY                    \ Increment the character pointer

 DEX                    \ Decrement the character count

 BNE DAL4               \ Loop back to copy the next character until we have
                        \ shuffled down the whole buffer

 BEQ DA5                \ Jump back to DA5 (this BEQ is effectively a JMP as we
                        \ have already passed through the BNE above)

.DAS1

                        \ This subroutine prints out X characters from BUF,
                        \ returning with X = 0

 LDY #0                 \ Set Y = 0 to point to the first character in BUF

.DAL5

 LDA BUF,Y              \ Print the Y-th character in BUF
 JSR CHPR

 INY                    \ Increment Y to point to the next character

 DEX                    \ Decrement the loop counter

 BNE DAL5               \ Loop back for the next character until we have printed
                        \ X characters from BUF

.rT9

 RTS                    \ Return from the subroutine

.DA6

 JSR DAS1               \ Call DAS1 to print X characters from BUF, returning
                        \ with X = 0

 STX DTW5               \ Set DTW5 = 0

 PLA                    \ Restore Y and X from the stack
 TAY
 PLA
 TAX

 LDA #12                \ Set A = 12, so when we skip BELL and fall through into
                        \ CHPR, we print character 12, which is a newline

.DA7

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &07, or BIT &07A9, which does nothing apart
                        \ from affect the flags

