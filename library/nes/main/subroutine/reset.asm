\ ******************************************************************************
\
\       Name: RESET
\       Type: Variable
\   Category: Start and end
\    Summary: The reset routine at the start of the ROM bank
\
\ ******************************************************************************

 ORG CODE%

 SEI
 INC &C006
 JMP &C007

