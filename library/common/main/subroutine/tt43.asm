\ ******************************************************************************
\
\       Name: TT43
\       Type: Subroutine
\   Category: Text
\    Summary: Print a two-letter token or recursive token 0-95
\
\ ------------------------------------------------------------------------------
\
\ Print a two-letter token, or a recursive token where the token number is in
\ 0-95 (so the value passed to TT27 is in the range 160-255).
\
\ Arguments:
\
\   A                   One of the following:
\
\                         * 128-159 (two-letter token)
\
\                         * 160-255 (the argument to TT27 that refers to a
\                           recursive token in the range 0-95)
\
\ ******************************************************************************

.TT43

 CMP #160               \ If token >= 160, then this is a recursive token, so
 BCS TT47               \ jump to TT47 below to process it

 AND #127               \ This is a two-letter token with number 128-159. The
 ASL A                  \ set of two-letter tokens is stored in a lookup table
                        \ at QQ16, with each token taking up two bytes, so to
                        \ convert this into the token's position in the table,
                        \ we subtract 128 (or just clear bit 7) and multiply
                        \ by 2 (or shift left)

 TAY                    \ Transfer the token's position into Y so we can look
                        \ up the token using absolute indexed mode

 LDA QQ16,Y             \ Get the first letter of the token and print it
 JSR TT27

 LDA QQ16+1,Y           \ Get the second letter of the token

 CMP #'?'               \ If the second letter of the token is a question mark
 BEQ TT48               \ then this is a one-letter token, so just return from
                        \ the subroutine without printing (as TT48 contains an
                        \ RTS)

 JMP TT27               \ Print the second letter and return from the
                        \ subroutine

.TT47

 SBC #160               \ This is a recursive token in the range 160-255, so
                        \ subtract 160 from the argument to get the token
                        \ number 0-95 and fall through into ex to print it

