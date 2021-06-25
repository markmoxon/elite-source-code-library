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
\ ******************************************************************************

.fwl

 LDA #105               \ Print recursive token 105 ("FUEL") followed by a
 JSR TT68               \ colon

 LDX QQ14               \ Load the current fuel level from QQ14

 SEC                    \ We want to print the fuel level with a decimal point,
                        \ so set the C flag for pr2 to take as an argument

 JSR pr2                \ Call pr2, which prints the number in X to a width of
                        \ 3 figures (i.e. in the format x.x, which will always
                        \ be exactly 3 characters as the maximum fuel is 7.0)

 LDA #195               \ Print recursive token 35 ("LIGHT YEARS") followed by
 JSR plf                \ a newline

.PCASH

 LDA #119               \ Print recursive token 119 ("CASH:" then control code
 BNE TT27               \ 0, which prints cash levels, then " CR" and newline)

