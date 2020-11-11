\ ******************************************************************************
\       Name: OSWVECS
\ ******************************************************************************

\ ......... Revectoring of OSWORD ...............................

.OSWVECS

 EQUW KEYBOARD
 EQUW PIXEL
 EQUW MSBAR
 EQUW WSCAN
 EQUW SC48
 EQUW DOT
 EQUW DODKS4
 EQUW HLOIN
 EQUW HANGER
 EQUW SOMEPROT
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE
 EQUW SAFE

\ Above vector lookup table is JSRed below, after registers are preserved.
\ OSSC points to the parameter block, and should not be corrupted.
\ Copy into SC if it may be corrupted.  End with an RTS

