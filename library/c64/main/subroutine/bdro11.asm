\ ******************************************************************************
\
\       Name: BDRO11
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#11>, which does the same as command <#9>
\             and restarts the current tune
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDRO11

 JMP BDRO9              \ Jump to BDRO9 to process command <#9> (so command
                        \ <#11> is the same as command <#9> and restarts the
                        \ current tune)

