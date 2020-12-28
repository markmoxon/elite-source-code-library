\ ******************************************************************************
\
\       Name: HATB
\       Type: Variable
\   Category: Ship hanger
\    Summary: Ship hanger group table
\
\ ------------------------------------------------------------------------------
\
\   Byte #0             Non-zero = Ship type to draw
\                       0        = don't draw anything
\
\   Byte #1             Bits 0-7 = Ship's x_hi
\                       Bit 0    = Ship's z_hi (1 if clear, or 2 if set)
\
\   Byte #2             Bits 0-6 = Ship's z_lo
\                       Bit 7    = Ship's x_sign
\
\ ******************************************************************************

.HATB

                        \ Hanger group for X = 0: Shuttle and Transporter

 EQUB 9                 \ Ship type = 9 = Shuttle
 EQUB %01010100         \ x_hi = %01010100 = 84, z_hi   = 1     -> x = +84
 EQUB %00111011         \ z_lo =  %0111011 = 59, x_sign = 0        z = +315

 EQUB 10                \ Ship type = 10 = Transporter
 EQUB %10000010         \ x_hi = %10000010 = 130, z_hi   = 1    -> x = -130
 EQUB %10110000         \ z_lo =  %0110000 =  48, x_sign = 1       z = +304

 EQUB 0                 \ No ship
 EQUB 0
 EQUB 0

                        \ Hanger group for X = 9: Three cargo canisters

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %01010000         \ x_hi = %01010000 = 80, z_hi   = 1     -> x = +80
 EQUB %00010001         \ z_lo =  %0010001 = 17, x_sign = 0        z = +273

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %11010001         \ x_hi = %11010001 = 209, z_hi = 2      -> x = +209
 EQUB %00101000         \ z_lo =  %0101000 =  40, x_sign = 0       z = +552

 EQUB OIL               \ Ship type = OIL = Cargo canister
 EQUB %01000000         \ x_hi = %01000000 = 64, z_hi   = 1     -> x = +64
 EQUB %00000110         \ z_lo =  %0000110 = 6,  x_sign = 0        z = +262

                        \ Hanger group for X = 18: Viper and Krait
                        \ (Transporter and Cobra Mk III in the disc version)

 EQUB COPS              \ Ship type = COPS = Viper
 EQUB %01100000         \ x_hi = %01100000 = 96, z_hi   = 1     -> x = -96
 EQUB %10010000         \ z_lo =  %0010000 = 16, x_sign = 1        z = +272

 EQUB KRA               \ Ship type = KRA = Krait
 EQUB %00010000         \ x_hi = %00010000 = 16, z_hi   = 1     -> x = -16
 EQUB %11010001         \ z_lo =  %1010001 = 81, x_sign = 1        z = +337

 EQUB 0                 \ No ship
 EQUB 0
 EQUB 0

                        \ Hanger group for X = 27: Viper and Krait

 EQUB 16                \ Ship type = 16 = Viper
 EQUB %01010001         \ x_hi = %01010001 =  81, z_hi  = 2     -> x = -81
 EQUB %11111000         \ z_lo =  %1111000 = 120, x_sign = 1       z = +632

 EQUB 19                \ Ship type = 19 = Krait
 EQUB %01100000         \ x_hi = %01100000 = 96,  z_hi   = 1    -> x = +96
 EQUB %01110101         \ z_lo =  %1110101 = 117, x_sign = 0       z = +373

 EQUB 0                 \ No ship
 EQUB 0
 EQUB 0

