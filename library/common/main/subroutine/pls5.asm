\ ******************************************************************************
\
\       Name: PLS5
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Calculate roofv_x / z and roofv_y / z
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following divisions of a specified value from one of the
\ orientation vectors (in this example, roofv):
\
\   (XX16+2 K2+2) = roofv_x / z
\
\   (XX16+3 K2+3) = roofv_y / z
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Determines which of the INWK orientation vectors to
\                       divide:
\
\                         * X = 15: divides roofv_x and roofv_y
\
\                         * X = 21: divides sidev_x and sidev_y
\
\   INWK                The planet's ship data block
\
\ ******************************************************************************

.PLS5

 JSR PLS1               \ Call PLS1 to calculate the following:
 STA K2+2               \
 STY XX16+2             \   K+2    = |roofv_x / z|
                        \   XX16+2 = sign of roofv_x / z
                        \
                        \ i.e. (XX16+2 K2+2) = roofv_x / z
                        \
                        \ and increment X to point to roofv_y for the next call

 JSR PLS1               \ Call PLS1 to calculate the following:
 STA K2+3               \
 STY XX16+3             \   K+3    = |roofv_y / z|
                        \   XX16+3 = sign of roofv_y / z
                        \
                        \ i.e. (XX16+3 K2+3) = roofv_y / z
                        \
                        \ and increment X to point to roofv_z for the next call

 RTS                    \ Return from the subroutine

