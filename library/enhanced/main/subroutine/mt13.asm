\ ******************************************************************************
\
\       Name: MT13
\       Type: Subroutine
\   Category: Text
\    Summary: Switch to lower case when printing extended tokens
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This routine sets the following:
\
IF NOT(_NES_VERSION)
\   * DTW1 = %00100000 (apply lower case to the second letter of a word onwards)
ELIF _NES_VERSION
\   * DTW1 = %10000000 (apply lower case to the second letter of a word onwards)
ENDIF
\
\   * DTW6 = %10000000 (lower case is enabled)
\
\ ******************************************************************************

.MT13

IF NOT(_NES_VERSION)

 LDA #%10000000         \ Set DTW6 = %10000000
 STA DTW6

 LDA #%00100000         \ Set DTW1 = %00100000
 STA DTW1

ELIF _NES_VERSION

 LDA #%10000000         \ Set DTW1 = %10000000
 STA DTW1

 STA DTW6               \ Set DTW6 = %10000000

ENDIF

 RTS                    \ Return from the subroutine

