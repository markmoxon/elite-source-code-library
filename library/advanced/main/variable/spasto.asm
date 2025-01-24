IF NOT(_NES_VERSION OR _APPLE_VERSION)

\ ******************************************************************************
\
\       Name: spasto
\       Type: Variable
\   Category: Universe
\    Summary: Contains the address of the Coriolis space station's ship
\             blueprint
\
\ ******************************************************************************

.spasto

 EQUW &8888             \ This variable is set by routine BEGIN to the address
                        \ of the Coriolis space station's ship blueprint

ELIF _APPLE_VERSION

\ ******************************************************************************
\
\       Name: spasto
\       Type: Variable
\   Category: Universe
\    Summary: Contains the address of the Coriolis space station's ship
\             blueprint
\
\ ******************************************************************************

.spasto

IF _IB_DISK

 EQUW SHIP_CORIOLIS     \ This variable is set by routine BEGIN to the address
                        \ of the Coriolis space station's ship blueprint (the
                        \ initial address in this instruction is overwritten)

ELIF _SOURCE_DISK OR _4AM_CRACK

 EQUW &8888             \ This variable is set by routine BEGIN to the address
                        \ of the Coriolis space station's ship blueprint

ENDIF

ELIF _NES_VERSION

.spasto

 SKIP 2                 \ Contains the address of the ship blueprint of the
                        \ space station (which can be a Coriolis or Dodo)

ENDIF

