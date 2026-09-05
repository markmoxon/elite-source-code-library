\ ******************************************************************************
\
\       Name: LoadScreen
\       Type: Subroutine
\   Category: Loader
\    Summary: Print the screen data onto the mode 7 screen
\
\ ******************************************************************************

.LoadScreen

                        \ We print the screen data onto the screen memory, one
                        \ character at a time, which will display the loading
                        \ screen in mode 7
                        \
                        \ The screen data is exactly 1000 characters long,
                        \ though we only print 999 of these to prevent a newline
                        \ being inserted at the end, as that would scroll the
                        \ screen up by a line (the bottom-right character is a
                        \ space, so this is fine)
                        \
                        \ The following loop prints characters in batches of
                        \ 256, so we start the first inner loop at 25 to give
                        \ us the correct total at the end of the fourth outer
                        \ loop (so the first loop prints 256 - 25 = 231
                        \ characters, and the other three print 256 characters,
                        \ giving a total of 231 + 256 * 3 = 999 characters)

 LDY #25                \ We will use Y as a character counter in the inner loop
                        \ to work through each character, so set it to 25 to
                        \ skip to the correct number for the first outer loop

 LDX #4                 \ Set X to the outer loop counter

.loop1

 LDA screenData-25,Y    \ Set A to byte Y - 25 from the screen data, so we start
                        \ printing characters from the start of the screen data
                        \ (as we start with Y set to 25)

 JSR OSWRCH             \ Print the character in A

 INY                    \ Increment the inner loop counter in Y

 BNE loop1              \ Loop back until we have finished the inner loop (which
                        \ will print 231 characters on the first inner loop and
                        \ 256 on each of the next three loops)

 INC loop1+2            \ Increment the high byte of the LDA instruction above
                        \ to move on to the next page of bytes

 DEX                    \ Decrement the outer loop counter in X

 BNE loop1              \ Loop back until we have done all four outer loops

 RTS                    \ Return from the subroutine

