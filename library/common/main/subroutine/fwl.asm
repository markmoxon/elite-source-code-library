\ ******************************************************************************
\
\       Name: fwl
\       Type: Subroutine
\   Category: Status
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

 LDA languageNumber     \ If bit 1 of languageNumber is set then the chosen
 AND #%00000010         \ language is French, so jump to fuel3 to print the fuel
 BNE fuel3              \ and cash levels with different indents, to cater for
                        \ the difference in language

ENDIF

 LDA #105               \ Print recursive token 105 ("FUEL") followed by a
 JSR TT68               \ colon

IF _NES_VERSION

 JSR Print2Spaces       \ Print two spaces

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to fuel1 to skip the
 BEQ fuel1              \ following

 JSR Print2Spaces       \ Print two spaces

.fuel1

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

 LDA #197               \ Print recursive token 37 ("CASH") followed by a colon
 JSR TT68

 LDA languageNumber     \ If bit 2 of languageNumber is set then the chosen
 AND #%00000100         \ language is French, so jump to fuel2 to skip the
 BNE fuel2              \ following two instructions

 JSR Print2Spaces       \ Print two spaces

 JSR TT162              \ Print a space

.fuel2

 LDA #0                 \ Set A = 0 so we print recursive token 0 at fuel4,
                        \ which prints control code 0 (current amount of cash
                        \ and newline)

 BEQ fuel4              \ Jump to fuel4 to print the token in A (this BNE is
                        \ effectively a JMP as A is always zero)

.fuel3

                        \ If we get here then the chosen language is French

 LDA #105               \ Print recursive token 105 ("FUEL") followed by a
 JSR PrintTokenAndColon \ colon, ensuring that the colon is printed in green
                        \ despite being in a 2x2 attribute block set for white
                        \ text

 JSR TT162              \ Print a space

 LDX QQ14               \ Load the current fuel level from QQ14

 SEC                    \ We want to print the fuel level with a decimal point,
                        \ so set the C flag for pr2 to take as an argument

 JSR pr2                \ Call pr2, which prints the number in X to a width of
                        \ 3 figures (i.e. in the format x.x, which will always
                        \ be exactly 3 characters as the maximum fuel is 7.0)

 LDA #195               \ Print recursive token 35 ("LIGHT YEARS") followed by
 JSR plf                \ a newline

 LDA #197               \ Print recursive token 37 ("CASH") followed by a colon
 JSR TT68

 LDA #0                 \ Set A = 0 so we print recursive token 0 at fuel4,
                        \ which prints control code 0 (current amount of cash
                        \ and newline)

 BEQ fuel4              \ Jump to fuel4 to print the token in A (this BNE is
                        \ effectively a JMP as A is always zero)

ENDIF

.PCASH

IF NOT(_NES_VERSION)

 LDA #119               \ Print recursive token 119 ("CASH:" then control code
 BNE TT27               \ 0, which prints cash levels, then " CR" and newline)

ELIF _NES_VERSION

 LDA #119               \ Set A = 119 so we print recursive token 119 below
                        \ ("CASH:" then control code 0, which prints cash
                        \ levels, then " CR" and newline)

.fuel4

 JMP spc                \ Print the recursive token in A and return from the
                        \ subroutine using a tail call

ENDIF

