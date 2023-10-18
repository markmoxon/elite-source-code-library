\ ******************************************************************************
\
\       Name: SetEquipmentSprite
\       Type: Subroutine
\   Category: Equipment
\    Summary: Set up the sprites in the sprite buffer for a specific bit of
\             equipment to show on our Cobra Mk III on the Equip Ship screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of sprites to set up for the equipment
\
\   Y                   The offset into the equipSprites table where we can find
\                       the data for the first sprite to set up for this piece
\                       of equipment (i.e. the equipment sprite number * 4)
\
\ ******************************************************************************

.SetEquipmentSprite

 LDA #0                 \ Set A = 0 to set as the laser offset in SetLaserSprite
                        \ so we just draw the equipment's sprites

                        \ Fall through into SetLaserSprite to draw the sprites
                        \ for the equipment specified in Y

