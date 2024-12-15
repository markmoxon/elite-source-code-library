\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: TT67
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\       Name: TT67K
ENDIF
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline
\
\ ******************************************************************************

IF _6502SP_VERSION \ Label

.TT67

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

.TT67K

                        \ This does the same as the existing TT67 routine, which
                        \ is also present in this source, so it isn't clear why
                        \ this duplicate exists
                        \
                        \ In the original source, this version also has the name
                        \ TT67, but because BeebAsm doesn't allow us to redefine
                        \ labels, I gave renamed this this one to TT67K

ENDIF

 LDA #12                \ Set A to a carriage return character

IF NOT(_C64_VERSION OR _APPLE_VERSION OR _NES_VERSION)

                        \ Fall through into TT26 to print the newline

ELIF _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

                        \ Fall through into CHPR to print the newline

ENDIF

