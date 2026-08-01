\ ******************************************************************************
\
\       Name: SetLanguage
\       Type: Subroutine
\   Category: Start and end
\    Summary: Set the language-related variables for a specific language
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the language choice to set
\
\ ******************************************************************************

.SetLanguage

 LDA tokensLo,Y         \ Set QQ18(Hi Lo) to the language's entry from the
 STA QQ18Lo             \ tokens(Hi Lo) table
 LDA tokensHi,Y
 STA QQ18Hi

 LDA extendedTokensLo,Y \ Set TKN1(Hi Lo) to the language's entry from the
 STA TKN1Lo             \ extendedTokens(Hi Lo) table
 LDA extendedTokensHi,Y
 STA TKN1Hi

 LDA languageIndexes,Y  \ Set languageIndex to the language's index from the
 STA languageIndex      \ languageIndexes table

 LDA languageNumbers,Y  \ Set languageNumber to the language's flags from the
 STA languageNumber     \ languageNumbers table

 LDA characterEndLang,Y \ Set characterEnd to the end of the language's
 STA characterEnd       \ character set from the characterEndLang table

 LDA decimalPointLang,Y \ Set decimalPoint to the language's decimal point
 STA decimalPoint       \ character from the decimalPointLang table

 RTS                    \ Return from the subroutine

