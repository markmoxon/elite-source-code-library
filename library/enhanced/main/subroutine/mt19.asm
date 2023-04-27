\ ******************************************************************************
\
\       Name: MT19
\       Type: Subroutine
\   Category: Text
\    Summary: Capitalise the next letter
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This routine sets the following:
\
IF NOT(_NES_VERSION)
\   * DTW8 = %11011111 (capitalise the next letter)
ELIF _NES_VERSION
\   * DTW8 = %00000000 (capitalise the next letter)
ENDIF
\
\ ******************************************************************************

.MT19

IF NOT(_NES_VERSION)

 LDA #%11011111         \ Set DTW8 = %11011111
 STA DTW8

ELIF _NES_VERSION

 LDA #%00000000         \ Set DTW8 = %00000000
 STA DTW8

ENDIF

 RTS                    \ Return from the subroutine

