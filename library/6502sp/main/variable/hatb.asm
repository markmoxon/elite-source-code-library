\ ******************************************************************************
\
\       Name: HATB
\       Type: Variable
\   Category: Ship hanger
\    Summary: Ship hanger group table
\
\ ------------------------------------------------------------------------------
\
\ This table contains groups of ships to show in the ship hanger. A group of
\ ships is shown half the time (the other half shows a solo ship), and each of
\ the four groups is equally likely.
\
\ The the bytes for each ship in the group contain the following information:
\
\   Byte #0             Non-zero = Ship type to draw
\                       0        = don't draw anything
\
\   Byte #1             Bits 0-7 = Ship's x_hi
\                       Bit 0    = Ship's z_hi (1 if clear, or 2 if set)
\
\   Byte #2             Bits 0-7 = Ship's z_lo
\                       Bit 0    = Ship's x_sign
\
\ Ths ship's y-coordinate is calculated in the has1 routine from the size of
\ its targetable area. Ships of type 0 are not shown.
\
\ ******************************************************************************

.HATB

                        \ Hanger group for X = 0
                        \
                        \ Shuttle (left) and Transporter (right)

 EQUB 9                 \ Ship type = 9 = Shuttle
 EQUB %01010100         \ x_hi = %01010100 = 84, z_hi   = 1     -> x = -84
 EQUB %00111011         \ z_lo = %00111011 = 59, x_sign = 1        z = +315

 EQUB 10                \ Ship type = 10 = Transporter
 EQUB %10000010         \ x_hi = %10000010 = 130, z_hi   = 1    -> x = +130
 EQUB %10110000         \ z_lo = %10110000 = 176, x_sign = 0       z = +432

 EQUB 0                 \ No third ship
 EQUB 0
 EQUB 0

                        \ Hanger group for X = 9
                        \
                        \ Three cargo canisters (left, far right and forward,
                        \ right)

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %01010000         \ x_hi = %01010000 = 80, z_hi   = 1     -> x = -80
 EQUB %00010001         \ z_lo = %00010001 = 17, x_sign = 1        z = +273

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %11010001         \ x_hi = %11010001 = 209, z_hi = 2      -> x = +209
 EQUB %00101000         \ z_lo = %00101000 =  40, x_sign = 0       z = +552

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %01000000         \ x_hi = %01000000 = 64, z_hi   = 1     -> x = +64
 EQUB %00000110         \ z_lo = %00000110 = 6,  x_sign = 0        z = +262

                        \ Hanger group for X = 18
                        \
                        \ Viper (right) and Krait (left)
                        \
                        \ (This group consists of a Transporter and Cobra Mk III
                        \ in the disc version)

 EQUB COPS              \ Ship type = COPS = Viper
 EQUB %01100000         \ x_hi = %01100000 =  96, z_hi   = 1    -> x = +96
 EQUB %10010000         \ z_lo = %10010000 = 144, x_sign = 0       z = +400

 EQUB KRA               \ Ship type = KRA = Krait
 EQUB %00010000         \ x_hi = %00010000 =  16, z_hi   = 1    -> x = -16
 EQUB %11010001         \ z_lo = %11010001 = 209, x_sign = 1       z = +465

 EQUB 0                 \ No third ship
 EQUB 0
 EQUB 0

                        \ Hanger group for X = 27
                        \
                        \ Viper (right and forward) and Krait (left)

 EQUB 16                \ Ship type = 16 = Viper
 EQUB %01010001         \ x_hi = %01010001 =  81, z_hi  = 2     -> x = +81
 EQUB %11111000         \ z_lo = %11111000 = 248, x_sign = 0       z = +760

 EQUB 19                \ Ship type = 19 = Krait
 EQUB %01100000         \ x_hi = %01100000 = 96,  z_hi   = 1    -> x = -96
 EQUB %01110101         \ z_lo = %01110101 = 117, x_sign = 1       z = +373

 EQUB 0                 \ No third ship
 EQUB 0
 EQUB 0

