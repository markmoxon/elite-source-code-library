\ ******************************************************************************
\
\       Name: BEGIN%
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Single-byte decryption and copying routine, run on the stack
\
\ ------------------------------------------------------------------------------
\
\ This code is not run in the unprotected version of the loader. In the full
\ version it is stored with the instructions reversed so it can be copied onto
\ the stack to be run, and it doesn't contain any NOPs, so this is presumably a
\ remnant of the cracking process.
\
\ ******************************************************************************

 PLA
 PLA
 LDA &0C24,Y
 PHA
 EOR &0B3D,Y
 NOP
 NOP
 NOP
 JMP (David9)

