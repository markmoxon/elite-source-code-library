\ ******************************************************************************
\
\       Name: check_keys
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.check_keys

 JSR WSCAN
 JSR RDKEY
 CPX #&69
 BNE not_freeze

.freeze_loop

 JSR WSCAN
 JSR RDKEY
 CPX #&70
 BNE dont_quit
 JMP DEATH2_FLIGHT

.dont_quit

 \CPX #&37
 \BNE dont_dump
 \JSR printer
 \dont_dump
 CPX #&59
 BNE freeze_loop

.l_release

 JSR RDKEY
 BNE l_release
 LDX #0 \ no key was pressed

.not_freeze

 RTS

