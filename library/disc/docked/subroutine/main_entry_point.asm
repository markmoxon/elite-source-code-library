\ ******************************************************************************
\
\       Name: Main entry point
\       Type: Subroutine
\   Category: Loader
\    Summary: Decrypt and run the docked code
\
\ ******************************************************************************

 JMP DOENTRY
 JMP DOBEGIN
 JMP CHPR

 EQUW &114B

 EQUB &4C

.BRKV

 EQUW &11D5

