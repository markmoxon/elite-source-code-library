\ ******************************************************************************
\
\       Name: MT18
\       Type: Subroutine
\   Category: Text
\    Summary: 
\
\ ******************************************************************************

.MT18

 JSR MT19
 JSR DORND
 AND #3
 TAY

.MT18L

 JSR DORND
 AND #62
 TAX
 LDA TKN2+2,X
 JSR DTS
 LDA TKN2+3,X
 JSR DTS
 DEY
 BPL MT18L

 RTS                    \ Return from the subroutine

