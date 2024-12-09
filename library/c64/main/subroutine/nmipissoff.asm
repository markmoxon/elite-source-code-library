\ ******************************************************************************
\
\       Name: NMIpissoff
\       Type: Subroutine
\   Category: Loader
\    Summary: Acknowledge NMI interrupts and ignore them
\
\ ******************************************************************************

IF _MASTER_VERSION

IF _SNG47

.NMIpissoff

 CLI                    \ These instructions are never reached and have no
 RTI                    \ effect

ENDIF

ELIF _APPLE_VERSION OR _C64_VERSION

.NMIpissoff

 CLI                    \ Enable interrupts, so we acknowledge the NMI and
                        \ basically ignore it

 RTI                    \ Return from the interrupt

ENDIF

