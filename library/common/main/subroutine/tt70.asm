\ ******************************************************************************
\
\       Name: TT70
\       Type: Subroutine
\   Category: Universe
\    Summary: Display "MAINLY " and jump to TT72
\
\ ------------------------------------------------------------------------------
\
\ This subroutine is called by TT25 when displaying a system's economy.
\
\ ******************************************************************************

.TT70

IF NOT(_NES_VERSION)

 LDA #173               \ Print recursive token 13 ("MAINLY ")
 JSR TT27

ELIF _NES_VERSION

 LDA #173               \ Print recursive token 13 ("MAINLY ")
 JSR TT27_b2

ENDIF

 JMP TT72               \ Jump to TT72 to continue printing system data as part
                        \ of routine TT25

