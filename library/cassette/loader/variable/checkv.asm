\ ******************************************************************************
\
\       Name: CHECKV
\       Type: Variable
\   Category: Copy protection
\    Summary: The address of the LBL routine in the decryption header
\
\ ------------------------------------------------------------------------------
\
\ CHECKV contains the address of the LBL routine at the very start of the main
\ game code file, in the decryption header code that gets prepended to the main
\ game code by elite-bcfs.asm and saved as ELThead.bin
\
\ ******************************************************************************

.CHECKV

 EQUW LOAD%+1           \ The address of the LBL routine

