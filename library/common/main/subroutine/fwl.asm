\ ******************************************************************************
\
\       Name: fwl
\       Type: Subroutine
\   Category: Text
\    Summary: Print fuel and cash levels
\
\ ------------------------------------------------------------------------------
\
\ Print control code 5 ("FUEL: ", fuel level, " LIGHT YEARS", newline, "CASH:",
\ control code 0).
\
IF _NES_VERSION
\ Other entry points:
\
\   PCASH               Print the amount of cash only
\
ENDIF
\ ******************************************************************************

.fwl

IF _NES_VERSION

 LDA languageNumber     \ ???
 AND #%00000010
 BNE CA87D

ENDIF

 LDA #105               \ Print recursive token 105 ("FUEL") followed by a
 JSR TT68               \ colon

IF _NES_VERSION

 JSR Print2Newlines     \ Print two newlines

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so ???
 BEQ CA85B

 JSR Print2Newlines     \ Print two newlines

.CA85B

ENDIF

 LDX QQ14               \ Load the current fuel level from QQ14

 SEC                    \ We want to print the fuel level with a decimal point,
                        \ so set the C flag for pr2 to take as an argument

 JSR pr2                \ Call pr2, which prints the number in X to a width of
                        \ 3 figures (i.e. in the format x.x, which will always
                        \ be exactly 3 characters as the maximum fuel is 7.0)

 LDA #195               \ Print recursive token 35 ("LIGHT YEARS") followed by
 JSR plf                \ a newline

IF _NES_VERSION

 LDA #197               \ ???
 JSR TT68

 LDA languageNumber     \ If bit 2 of languageNumber is set then the chosen
 AND #%00000100         \ language is French, so ???
 BNE CA879

 JSR Print2Newlines     \ Print two newlines
 JSR TT162

.CA879

 LDA #0
 BEQ CA89C

.CA87D

 LDA #105
 JSR PrintTokenAndColon
 JSR TT162
 LDX QQ14
 SEC
 JSR pr2

 LDA #195
 JSR plf

 LDA #197
 JSR TT68
 LDA #0
 BEQ CA89C

ENDIF

.PCASH

IF NOT(_NES_VERSION)

 LDA #119               \ Print recursive token 119 ("CASH:" then control code
 BNE TT27               \ 0, which prints cash levels, then " CR" and newline)

ELIF _NES_VERSION

 LDA #119               \ Set A = 119 so we print recursive token 119 below

.CA89C

 JMP spc                \ Print recursive token 119 ("CASH:" then control code
                        \ 0, which prints cash levels, then " CR" and newline),
                        \ followed by a space, and return from the subroutine
                        \ using a tail call

ENDIF

