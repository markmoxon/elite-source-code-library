\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Decrypt the loader code
\
\ ******************************************************************************

.BEGIN

IF _STH_DISC

 JMP ENTRY              \ Jump over the copy protection to disable it

ELIF _IB_DISC

IF _REMOVE_CHECKSUMS OR TRUE

 JMP ENTRY              \ Jump over the copy protection to disable it

ELSE

 LDX p1c+1              \ Set X to the comporison value of the CMP instruction
                        \ at p1c

ENDIF

ENDIF

.p1

 LDA BEGIN

.p1a

 EOR BEGIN,X
 STA BEGIN,X
 INX
 BNE p1a

.p1b

 INC p1+1
 BEQ p1d

 LDA p1+1

.p1c

 CMP #&1E
 BEQ p1b

 JMP BEGIN

.p1d

 BIT &020B
 BPL BEGIN

