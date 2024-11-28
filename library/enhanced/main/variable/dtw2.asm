IF NOT(_NES_VERSION)
\ ******************************************************************************
\
\       Name: DTW2
\       Type: Variable
\   Category: Text
\    Summary: A flag that indicates whether we are currently printing a word
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This variable is used to indicate whether we are currently printing a word. It
\ has two values:
\
\   * 0 = we are currently printing a word
\
\   * Non-zero = we are not currently printing a word
\
\ The default value is %11111111 (we are not currently printing a word).
\
\ The flag is set to %00000000 (we are currently printing a word) whenever a
\ non-terminator character is passed to DASC for printing.
\
\ The flag is set to %11111111 (we are not currently printing a word) whenever a
\ terminator character (full stop, colon, carriage return, line feed, space) is
\ passed to DASC for printing. It is also set to %11111111 by jump token 8,
\ {tab 6}, which calls routine MT8 to change the value of DTW2, and to %10000000
\ by TTX66 when we clear the screen.
\
\ ******************************************************************************

ENDIF

IF NOT(_NES_VERSION OR _APPLE_VERSION)

.DTW2

 EQUB %11111111

ELIF _APPLE_VERSION

.DTW2

IF _IB_DISK

 EQUB 0

ELIF _SOURCE_DISK

 EQUB %11111111

ENDIF

ELIF _NES_VERSION

.DTW2

 SKIP 1                 \ A flag that indicates whether we are currently
                        \ printing a word
                        \
                        \   * 0 = we are currently printing a word
                        \
                        \   * Non-zero = we are not currently printing a word

ENDIF

