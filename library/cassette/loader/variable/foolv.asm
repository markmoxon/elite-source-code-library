\ ******************************************************************************
\
\       Name: FOOLV
\       Type: Variable
\   Category: Copy protection
\    Summary: Part of the AFOOL roundabout obfuscation routine
\
\ ------------------------------------------------------------------------------
\
\ FOOLV contains the address of FOOL. This is part of the JSR AFOOL obfuscation
\ routine, which calls AFOOL, which then jumps to the address in FOOLV, which
\ contains the address of FOOL, which contains an RTS instruction... so overall
\ it does nothing, but in a rather roundabout fashion.
\
\ ******************************************************************************

.FOOLV

 EQUW FOOL              \ The address of FOOL, which contains an RTS

