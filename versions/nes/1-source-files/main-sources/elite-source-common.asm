\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 Y = 72                 \ The centre y-coordinate of the space view

 OIL = 5                \ Ship type for a cargo canister
 COPS = 16              \ Ship type for a Viper
 SH3 = 17               \ Ship type for a Sidewinder
 KRA = 19               \ Ship type for a Krait

 NI% = 42               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

 LL = 29                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

 S% = &C007             \ The game's main entry point in bank 7

 PPU_CTRL   = &2000     \ NES PPU registers
 PPU_MASK   = &2001
 PPU_STATUS = &2002
 OAM_ADDR   = &2003
 OAM_DATA   = &2004
 PPU_SCROLL = &2005
 PPU_ADDR   = &2006
 PPU_DATA   = &2007
 OAM_DMA    = &4014

 SNE                = &C500
 ACT                = &C520
 XX21               = &C540
 SetPPUTablesTo0    = &D06D
 LD8C5              = &D8C5
 TWOS               = &D9F7
 yLookupLo          = &DA18
 yLookupHi          = &DAF8
 subm_DBD8          = &DBD8
 LOIN               = &DC0F
 LE04A              = &E04A
 LE0BA              = &E0BA
 PIXEL              = &E4F0
 subm_E909          = &E909
 LE5B0_EN           = &E5B0
 LE602_DE           = &E602
 LE653_FR           = &E653
 DELAY              = &EBA2
 SetupPPUForIconBar = &EC7D
 PAS1               = &EF7A
 DETOK_b2           = &F082
 DTS_b2             = &F09D
 C8980_b0           = &F186
 MVS5_b0            = &F1A2
 TT27_b0            = &F237
 TT66               = &F26E
 LF2BD              = &F2BD
 LF2CE              = &F2CE
 CLYNS              = &F2DE
 subm_F362          = &F362
 NLIN4              = &F473
 DORND2             = &F4AC
 DORND              = &F4AD
 PROJ               = &F4C1
 UnpackToRAM        = &F52D
 UnpackToPPU        = &F5AF
 MLS2               = &F6BA
 MLS1               = &F6C2
 MULTS              = &F6C6
 SQUA2              = &F70E
 MLU1               = &F718
 MLU2               = &F71D
 MULTU              = &F721
 FMLTU2             = &F766
 FMLTU              = &F770
 MUT2               = &F7D2
 MUT1               = &F7D6
 MULT1              = &F7DA
 MULT12             = &F83C
 MAD                = &F86F
 ADD                = &F872
 TIS1               = &F8AE
 DV42               = &F8D1
 DV41               = &F8D4
 DVID4              = &F8D8
 DVID3B2            = &F962
 LL5                = &FA55
 LL28               = &FA91
 NORM               = &FAF8

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/nes/main/workspace/sprite_buffer.asm"

\ ******************************************************************************
\
\       Name: WP
\       Type: Workspace
\    Address: &0300 to &05FF
\   Category: Workspaces
\    Summary: Ship slots, variables
\
\ ******************************************************************************

 FRIN                = &036A
 L0374               = &0374
 L037E               = &037E
 MJ                  = &038A
 VIEW                = &038E
 EV                  = &0392
 TP                  = &039E
 QQ0                 = &039F
 QQ1                 = &03A0
 CASH                = &03A1
 GCNT                = &03A7
 CRGO                = &03AC
 QQ20                = &03AD
 BST                 = &03BF
 GHYP                = &03C3
 FIST                = &03C9
 AVL                 = &03CA
 QQ26                = &03DB
 TALLY               = &03DC
 L03DD               = &03DD
 QQ21                = &03DF
 NOSTM               = &03E5
 L03E6               = &03E6
 L03EE               = &03EE
 L03F1               = &03F1
 DTW6                = &03F3
 DTW2                = &03F4
 DTW3                = &03F5
 DTW4                = &03F6
 DTW5                = &03F7
 DTW1                = &03F8
 DTW8                = &03F9
 L040A               = &040A
 QQ19                = &044D
 K2                  = &0459
 pictureTile         = &046C
 SWAP                = &047F
 XSAV2               = &0481
 YSAV2               = &0482
 QQ24                = &0487
 QQ25                = &0488
 QQ28                = &0489
 QQ29                = &048A
 systemFlag          = &048B
 QQ2                 = &048E
 QQ8                 = &049B
 QQ9                 = &049D
 QQ10                = &049E
 L049F               = &049F
 QQ18Lo              = &04A4
 QQ18Hi              = &04A5
 TKN1Lo              = &04A6
 TKN1Hi              = &04A7
 language            = &04A8
 L04B2               = &04B2
 L04B4               = &04B4
 L04BC               = &04BC
 L04BD               = &04BD
 SX                  = &04C8
 SY                  = &04DD
 SZ                  = &04F2
 BUFm1               = &0506
 BUF                 = &0507
 HANGFLAG            = &0561
 MANY                = &0562
 SXL                 = &05A5
 SYL                 = &05BA
 SZL                 = &05CF
 safehouse           = &05E4
 L05EA               = &05EA
 L05EB               = &05EB
 L05EC               = &05EC
 L05ED               = &05ED
 L05EE               = &05EE
 L05EF               = &05EF
 L05F0               = &05F0
 L05F1               = &05F1

INCLUDE "library/common/main/workspace/k_per_cent.asm"

\ ******************************************************************************
\
\       Name: pattBuffer0
\       Type: Variable
\   Category: Drawing lines
\    Summary: Pattern buffer for colour 0 (1 bit per pixel)
\
\ ******************************************************************************

 ORG &6000

.pattBuffer0

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)

\ ******************************************************************************
\
\       Name: pattBuffer1
\       Type: Variable
\   Category: Drawing lines
\    Summary: Pattern buffer for colour 1 (1 bit per pixel)
\
\ ******************************************************************************

.pattBuffer1

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)
