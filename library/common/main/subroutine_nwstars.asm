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

 LDA QQ11               \ If this is not a space view, jump to WPSHPS to skip
\ORA MJ                 \ the initialisation of the SX, SY and SZ tables. The OR
 BNE WPSHPS             \ instruction is commented out in the original source,
                        \ but it would have the effect of also skipping the
                        \ initialisation if we had mis-jumped into witchspace

