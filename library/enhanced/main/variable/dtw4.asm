IF NOT(_NES_VERSION)
\ ******************************************************************************
\
\       Name: DTW4
\       Type: Variable
\   Category: Text
\    Summary: Flags that govern how justified extended text tokens are printed
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This variable is used to control how justified text tokens are printed as part
\ of the extended text token system. There are two bits that affect justified
\ text:
\
\   * Bit 7: 1 = justify text
\            0 = do not justify text
\
\   * Bit 6: 1 = buffer the entire token before printing, including carriage
\                returns (used for in-flight messages only)
\            0 = print the contents of the buffer whenever a carriage return
\                appears in the token
\
\ The default value is %00000000 (do not justify text, print buffer on carriage
\ return).
\
\ The flag is set to %10000000 (justify text, print buffer on carriage return)
\ by jump token 14, {justify}, which calls routine MT14 to change the value of
\ DTW4.
\
\ The flag is set to %11000000 (justify text, buffer entire token) by routine
\ MESS, which printe in-flight messages.
\
\ The flag is set to %00000000 (do not justify text, print buffer on carriage
\ return) by jump token 15, {left align}, which calls routine MT1 to change the
\ value of DTW4.
\
\ ******************************************************************************

.DTW4

 EQUB 0

ELIF _NES_VERSION

.DTW4

 SKIP 1                 \ Flags that govern how justified extended text tokens
                        \ are printed
                        \
                        \   * Bit 7: 1 = justify text
                        \            0 = do not justify text
                        \
                        \   * Bit 6: 1 = buffer the entire token before
                        \                printing, including carriage returns
                        \                (used for in-flight messages only)
                        \            0 = print the contents of the buffer
                        \                whenever a carriage return appears
                        \                in the token

ENDIF

