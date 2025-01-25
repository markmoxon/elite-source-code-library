\ ******************************************************************************
\
\       Name: COPYNAME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from INWK+5 to comnam and pad
\             out the rest of comnam with spaces, so we can use it as a filename
\
\ ******************************************************************************

.COPYNAME

 LDX #0                 \ Set X = 0 to use as a character index for copying the
                        \ commander name from INWK+5 to comnam

.COPYL1

 LDA INWK+5,X           \ Set A to the X-th character of the name at INWK+5

 CMP #13                \ If A = 13 then we have reached the end of the name, so
 BEQ COPYL2             \ jump to COPYL2 to pad out the rest of comnam with
                        \ spaces

 STA comnam,X           \ Otherwise this is a character from the commander name,
                        \ so store it in the X-th character of comnam

 INX                    \ Increment X to move on to the next character

 CPX #7                 \ Loop back to copy the next character until we have
 BCC COPYL1             \ copied up to seven characters (the maximum size of the
                        \ commander name)

.COPYL2

 LDA #' '               \ We now want to pad out the rest of comnam with spaces,
                        \ so set A to the ASCII value for the space character

.COPYL3

 STA comnam,X           \ Store a space at the X-th character of comnam

 INX                    \ Increment X to move on to the next character

 CPX #30                \ Loop back until we have written spaces to all
 BCC COPYL3             \ remaining characters in the 30-character string at
                        \ comnam

 RTS                    \ Return from the subroutine

