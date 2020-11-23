.XSAV2

IF _CASSETTE_VERSION

 SKIP 1                 \ Temporary storage, used for storing the value of the X
                        \ register in the TT26 routine

ELIF _6502SP_VERSION

 SKIP 1                 \ This byte is unused in this version of Elite

ENDIF

