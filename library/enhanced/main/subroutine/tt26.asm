\ ******************************************************************************
\
\       Name: TT26
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor, with support for verified
\             text in extended tokens
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ Returns:
\
\   X                   X is preserved
\
\   C flag              The C flag is cleared
\
\ Other entry points:
\
\   DASC                DASC does exactly the same as TT26 and prints a
\                       character at the text cursor, with support for verified
\                       text in extended tokens
\
\   rT9                 Contains an RTS
\
\ ******************************************************************************

.DASC

.TT26

 STX SC                 \ Store X in SC, so we can retrieve it below

 LDX #%11111111         \ Set DTW8 = %11111111, to disable the effect of {19} if
 STX DTW8               \ it was set (as {19} capitalises one character only)

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

 INX                    \ Increment X to 0, so DTW2 gets set to %00000000 below

.DA8

 STX DTW2               \ Store X in DTW2, so DTW2 is now:
                        \
                        \   * %00000000 if this character is a word terminator
                        \
                        \   * %11111111 if it isn't
                        \
                        \ so DTW2 indicates whether or not we are currently
                        \ printing a word

 LDX SC                 \ Retrieve the original value of X from SC

 BIT DTW4               \ If bit 7 of DTW4 is set then we are currently printing
 BMI P%+5               \ justified text, so skip the next instruction

 JMP CHPR               \ Bit 7 of DTW4 is clear, so jump down to CHPR to print
                        \ this character, as we are not printing justified text

                        \ If we get here then we are printing justified text, so
                        \ we need to buffer the text until we reach the end of
                        \ the paragraph, so we can then pad it out with spaces

IF _6502SP_VERSION \ Platform: The enhanced versions use this routine for in-flight text, where carriage returns are buffered

 BVS P%+6               \ If bit 6 of DTW4 is set, then this is an in-flight
                        \ message and we should buffer the carriage return
                        \ character {12}, so skip the following two instructions

ENDIF

 CMP #12                \ If the character in A is a carriage return, then we
 BEQ DA1                \ have reached the end of the paragraph, so jump down to
                        \ DA1 to print out the contents of the buffer,
                        \ justifying it as we go

                        \ If we get here then we need to buffer this character
                        \ in the line buffer at BUF

 LDX DTW5               \ DTW5 contains the current size of the buffer, so this
 STA BUF,X              \ stores the character in A at BUF + DTW5, the next free
                        \ space in the buffer

 LDX SC                 \ Retrieve the original value of X from SC so we can
                        \ preserve it through this subroutine call

 INC DTW5               \ Increment the size of the BUF buffer that is stored in
                        \ DTW5

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

.DA1

                        \ If we get here then we are justifying text and we have
                        \ reached the end of the paragraph, so we need to print
                        \ out the contents of the buffer, justifying it as we go

 TXA                    \ Store X and Y on the stack
 PHA
 TYA
 PHA

.DA5

 LDX DTW5               \ Set X = DTW5, which contains the size of the buffer

 BEQ DA6+3              \ If X = 0 then the buffer is empty, so jump down to
                        \ DA6+3 to print a newline

 CPX #(LL+1)            \ If X < LL+1, i.e. X <= LL, then the buffer contains
 BCC DA6                \ fewer than LL characters, which is less then a line
                        \ length, so jump down to DA6 to print the contents of
                        \ BUF followed by a newline, as we don't justify the
                        \ last line of the paragraph

                        \ Otherwise X > LL, so the buffer does not fit into one
                        \ line, and we therefore need to justify the text, which
                        \ we do one line at a time

 LSR SC+1               \ Shift SC+1 to the right, which clears bit 7 of SC+1,
                        \ so we pass through the following comparison on the
                        \ first iteration of the loop and set SC+1 to %01000000

.DA11

 LDA SC+1               \ If bit 7 of SC+1 is set, skip the following two
 BMI P%+6               \ instructions

 LDA #%01000000         \ Set SC+1 = %01000000
 STA SC+1

 LDY #(LL-1)            \ Set Y = line length, so we can loop backwards from the
                        \ end of the first line in the buffer using Y as the
                        \ loop counter

.DAL1

 LDA BUF+LL             \ If the LL-th byte in BUF is a space, jump down to DA2
 CMP #' '               \ to print out the first line from the buffer, as it
 BEQ DA2                \ fits the line width exactly (i.e. it's justified)

                        \ We now want to find the last space character in the
                        \ first line in the buffer, so we loop through the line
                        \ using Y as a counter

.DAL2

 DEY                    \ Decrement the loop counter in Y

 BMI DA11               \ If Y <= 0, loop back to DA11, as we have now looped
 BEQ DA11               \ through the whole line

 LDA BUF,Y              \ If the Y-th byte in BUF is not a space, loop back up
 CMP #' '               \ to DAL2 to check the next character
 BNE DAL2

                        \ Y now points to a space character in the line buffer

 ASL SC+1               \ Shift SC+1 to the left

 BMI DAL2               \ If bit 7 of SC+1 is set, jump to DAL2 to find the next
                        \ space character

                        \ We now want to insert a space into the line buffer at
                        \ position Y, which we do by shifting every character
                        \ after position Y along by 1, and then inserting the
                        \ space

 STY SC                 \ Store Y in SC, so we want to insert the space at
                        \ position SC

 LDY DTW5               \ Fetch the buffer size from DTW5 into Y, to act as a
                        \ loop counter for moving the line buffer along by 1

.DAL6

 LDA BUF,Y              \ Copy the Y-th character from BUF into the Y+1-th
 STA BUF+1,Y            \ position

 DEY                    \ Decrement the loop counter in Y

 CPY SC                 \ Loop back to shift the next character along, until we
 BCS DAL6               \ have moved the SC-th character (i.e. Y < SC)

 INC DTW5               \ Increment the buffer size in DTW5

\LDA #' '               \ This instruction is commented out in the original
                        \ source, as it has no effect because A already contains
                        \ ASCII " ". This is because the last character that is
                        \ tested in the above loop is at position SC, which we
                        \ know contains a space, so we know A contains a space
                        \ character when the loop finishes

                        \ We've now shifted the line to the right by 1 from
                        \ position SC onwards, so SC and SC+1 both contain
                        \ spaces, and Y is now SC-1 as we did a DEY just before
                        \ the end of the loop - in other words, we have inserted
                        \ a space at position SC, and Y points to the character
                        \ before the newly inserted space

                        \ We now want to move the pointer Y left to find the
                        \ next space in the line buffer, before looping back to
                        \ check whether we are done, and if not, insert another
                        \ space

.DAL3

 CMP BUF,Y              \ If the character at position Y is not a space, jump to
 BNE DAL1               \ DAL1 to see whether we have now justified the line

 DEY                    \ Decrement the loop counter in Y

 BPL DAL3               \ Loop back to check the next character to the left,
                        \ until we have found a space

 BMI DA11               \ Jump back to DA11 (this BMI is effectively a JMP as
                        \ we already passed through a BPL to get here)

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

 LDA BUF,Y              \ Print the Y-th character in BUF using CHPR, which also
 JSR CHPR               \ clears the C flag for when we return from the
                        \ subroutine below

 INY                    \ Increment Y to point to the next character

 DEX                    \ Decrement the loop counter

 BNE DAL5               \ Loop back for the next character until we have printed
                        \ X characters from BUF

.rT9

 RTS                    \ Return from the subroutine

.DA6

 JSR DAS1               \ Call DAS1 to print X characters from BUF, returning
                        \ with X = 0

 STX DTW5               \ Set the buffer size in DTW5 to 0, as the buffer is now
                        \ empty

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

                        \ Fall through into CHPR (skipping BELL) to print the
                        \ character and return with the C flag cleared

