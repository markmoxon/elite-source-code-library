\ ******************************************************************************
\
\       Name: MT2
\       Type: Subroutine
\   Category: Text
\    Summary: Switch to Sentence Case when printing extended tokens
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
\   * DTW6 = %00000000 (lower case is not enabled)
\
\ ******************************************************************************

.MT2

IF NOT(_NES_VERSION)

 LDA #%00100000         \ Set DTW1 = %00100000
 STA DTW1

ELIF _NES_VERSION

 LDA #%10000000         \ Set DTW1 = %10000000
 STA DTW1

ENDIF

 LDA #00000000          \ Set DTW6 = %00000000
 STA DTW6

 RTS                    \ Return from the subroutine

