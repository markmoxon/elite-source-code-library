\ ******************************************************************************
\
\       Name: MT17
\       Type: Subroutine
\   Category: Text
\    Summary: 
\
\ ******************************************************************************

.MT17

 LDA QQ17
 AND #191
 STA QQ17
 LDA #3
 JSR TT27
 LDX DTW5
 LDA BUF-1,X
 JSR VOWEL
 BCC MT171
 DEC DTW5

.MT171

 LDA #153
 JMP DETOK

