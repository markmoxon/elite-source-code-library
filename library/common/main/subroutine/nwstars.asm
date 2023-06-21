\ ******************************************************************************
\
\       Name: NWSTARS
\       Type: Subroutine
\   Category: Stardust
\    Summary: Initialise the stardust field
\
\ ------------------------------------------------------------------------------
\
\ This routine is called when the space view is initialised in routine LOOK1.
\
\ ******************************************************************************

.NWSTARS

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA QQ11               \ If this is not a space view, jump to WPSHPS to skip
\ORA MJ                 \ the initialisation of the SX, SY and SZ tables. The OR
 BNE WPSHPS             \ instruction is commented out in the original source,
                        \ but it would have the effect of also skipping the
                        \ initialisation if we had mis-jumped into witchspace

ELIF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT

 LDA QQ11               \ If this is not a space view, jump to WPSHPS to skip
 BNE WPSHPS             \ the initialisation of the SX, SY and SZ tables

ELIF _ELITE_A_6502SP_PARA

 LDA QQ11               \ If this is not a space view, jump to WPSHPS via
 BNE WPSHPSS            \ WPSHPSS to skip the initialisation of the SX, SY and
                        \ SZ tables

ELIF _NES_VERSION

 LDA QQ11               \ If this is not a space view (in which case QQ11 > 0),
 ORA demoInProgress     \ or demoInProgress > 0 (in which case we are playing
 BNE WPSHPS             \ the demo), jump to WPSHPS to skip the initialisation
                        \ of the SX, SY and SZ tables

ENDIF
