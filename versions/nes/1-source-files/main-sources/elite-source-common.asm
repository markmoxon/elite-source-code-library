\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK CONFIGURATION)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains configuration that is common to all eight banks.
\
\ ******************************************************************************

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 NOST = 20              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 8               \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 33               \ The number of different ship types

 MSL = 1                \ Ship type for a missile
 SST = 2                \ Ship type for a Coriolis space station
 ESC = 3                \ Ship type for an escape pod
 PLT = 4                \ Ship type for an alloy plate
 OIL = 5                \ Ship type for a cargo canister
 AST = 7                \ Ship type for an asteroid
 SPL = 8                \ Ship type for a splinter
 SHU = 9                \ Ship type for a Shuttle
 CYL = 11               \ Ship type for a Cobra Mk III
 ANA = 14               \ Ship type for an Anaconda
 HER = 15               \ Ship type for a rock hermit (asteroid)
 COPS = 16              \ Ship type for a Viper
 SH3 = 17               \ Ship type for a Sidewinder
 KRA = 19               \ Ship type for a Krait
 ADA = 20               \ Ship type for a Adder
 WRM = 23               \ Ship type for a Worm
 CYL2 = 24              \ Ship type for a Cobra Mk III (pirate)
 ASP = 25               \ Ship type for an Asp Mk II
 THG = 29               \ Ship type for a Thargoid
 TGL = 30               \ Ship type for a Thargon
 CON = 31               \ Ship type for a Constrictor
 COU = 32               \ Ship type for a Cougar
 DOD = 33               \ Ship type for a Dodecahedron ("Dodo") space station

 NI% = 42               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 Y = 72                 \ The centre y-coordinate of the space view

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

 LL = 29                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

\ ******************************************************************************
\
\ NES PPU registers
\
\ See https://www.nesdev.org/wiki/PPU_registers
\
\ ******************************************************************************

 PPU_CTRL   = &2000
 PPU_MASK   = &2001
 PPU_STATUS = &2002
 OAM_ADDR   = &2003
 OAM_DATA   = &2004
 PPU_SCROLL = &2005
 PPU_ADDR   = &2006
 PPU_DATA   = &2007
 OAM_DMA    = &4014

\ ******************************************************************************
\
\ NES 2A03 CPU registers (I/O and sound)
\
\ See https://www.nesdev.org/wiki/2A03
\
\ ******************************************************************************

 SQ1_VOL    = &4000
 SQ1_SWEEP  = &4001
 SQ1_LO     = &4002
 SQ1_HI     = &4003
 SQ2_VOL    = &4004
 SQ2_SWEEP  = &4005
 SQ2_LO     = &4006
 SQ2_HI     = &4007
 TRI_LINEAR = &4008
 TRI_LO     = &400A
 TRI_HI     = &400B
 NOISE_VOL  = &400C
 L400D      = &400D
 NOISE_LO   = &400E
 NOISE_HI   = &400F
 DMC_FREQ   = &4010
 DMC_RAW    = &4011
 DMC_START  = &4012
 DMC_LEN    = &4013
 SND_CHN    = &4015
 JOY1       = &4016
 JOY2       = &4017

\ ******************************************************************************
\
\ Commander file?
\
\ ******************************************************************************

 L7800 = &7800

\ ******************************************************************************
\
\ Addresses in bank 7
\
\ ******************************************************************************

IF _BANK = 7

 L8012              = &8012
 L8021              = &8021
 L8041              = &8041
 L8062              = &8062
 L8083              = &8083
 PlayMusic          = &811E
 slvy2              = &81B6
 L8926              = &8926
 L8980              = &8980
 L89D1              = &89D1
 MVS5               = &8A14
 DemoShips          = &9522
 tnpr               = &9620
 L9FFF              = &9FFF
 LL9                = &A070
 LA082              = &A082
 LA0F8              = &A0F8
 LA166              = &A166
 DIALS              = &A2C3
 BR1                = &A379
 LA4A5              = &A4A5
 LA5AB              = &A5AB
 LA65D              = &A65D
 LA730              = &A730
 LA775              = &A775
 LA7B7              = &A7B7
 TT27_0             = &A8D9
 LA972              = &A972
 LA9D1              = &A9D1
 LAABC              = &AABC
 LAC1D              = &AC1D
 SUN                = &AC25
 LAC5C              = &AC5C
 LAE03              = &AE03
 LAE18              = &AE18
 LAF9D              = &AF9D
 LAFCD              = &AFCD
 LB0E1              = &B0E1
 DETOK              = &B0EF
 DTS                = &B187
 LB18E              = &B18E
 STARS              = &B1BE
 MAS4               = &B1CA
 LB1D4              = &B1D4
 LB219              = &B219
 LB248              = &B248
 LB2BC              = &B2BC
 subm_B2C3          = &B2C3
 LB2EF              = &B2EF
 LB2FB              = &B2FB
 ClearTiles         = &B341
 LB358              = &B358
 LB39D              = &B39D
 LB3BC              = &B3BC
 PDESC              = &B3E8
 TT27               = &B44F
 LB459              = &B459
 ex                 = &B4AA
 DASC               = &B4F5
 CHPR               = &B635
 LB63D              = &B63D
 LB673              = &B673
 HALL               = &B738
 TIDY               = &B85C
 LB882              = &B882
 LB88C              = &B88C
 PAS1               = &B8F7
 GetSystemImage2    = &B8F9
 LB8FE              = &B8FE
 LB90D              = &B90D
 LB919              = &B919
 SetSystemImage2    = &B93C
 LB96B              = &B96B
 SCAN               = &B975
 LL164              = &B980
 LB9C1              = &B9C1
 LB9E2              = &B9E2
 LB9F9              = &B9F9
 LBA17              = &BA17
 LBA23              = &BA23
 LBA63              = &BA63
 LBAF3              = &BAF3
 LBB37              = &BB37
 LBBDE              = &BBDE
 TITLE              = &BC83
 LBE52              = &BE52
 TT66               = &BEB5
 LBED2              = &BED2
 SetSystemImage1    = &BED7
 GetSystemImage1    = &BEEA
 LBF41              = &BF41
 LBFFF              = &BFFF

ELSE

 S%                 = &C007
 ResetVariables     = &C03E
 subm_C0A8          = &C0A8
 ResetBank          = &C0AD
 SetBank            = &C0AE
 LC0DF              = &C0DF
 LC0E3              = &C0E3
 log                = &C100
 logL               = &C200
 antilog            = &C300
 antilogODD         = &C400
 SNE                = &C500
 ACT                = &C520
 XX21               = &C540
 subm_C582          = &C582
 subm_C5D2          = &C5D2
 subm_C630          = &C630
 subm_C6C0          = &C6C0
 subm_C6C6          = &C6C6
 subm_C6F4          = &C6F4
 subm_C836          = &C836
 subm_CA56          = &CA56
 subm_CB42          = &CB42
 subm_CB9C          = &CB9C
 subm_CC1F          = &CC1F
 SendToPPU1         = &CC2E
 CopyNametable0To1  = &CD34
 subm_CD62          = &CD62
 DrawBoxEdges       = &CD6F
 UNIV               = &CE7E
 GINF               = &CE90
 subm_CE9E          = &CE9E
 subm_CEA5          = &CEA5
 nameBufferAddr     = &CED0
 pattBufferAddr     = &CED2
 IRQ                = &CED4
 NMI                = &CED5
 SetPalette         = &CF2E
 ResetNametable1    = &D02D
 SetPPUTablesTo0    = &D06D
 ReadControllers    = &D0F8
 KeepPPUTablesAt0x2 = &D164
 KeepPPUTablesAt0   = &D167
 LD17F              = &D17F
 FillMemory         = &D710
 subm_D8C5          = &D8C5
 ChangeDrawingPhase = &D8E1
 subm_D8EC          = &D8EC
 LD8FD              = &D8FD
 subm_D908          = &D908
 subm_D919          = &D919
 subm_D933          = &D933
 subm_D946          = &D946
 subm_D951          = &D951
 subm_D96F          = &D96F
 LD975              = &D975
 LD977              = &D977
 SendToPPU2         = &D986
 TWOS               = &D9F7
 TWOS2              = &DA01
 TWFL               = &DA09
 TWFR               = &DA10
 yLookupLo          = &DA18
 yLookupHi          = &DAF8
 subm_DBD8          = &DBD8
 LOIN               = &DC0F
 subm_DEA5          = &DEA5
 subm_DF76          = &DF76
 subm_E04A          = &E04A
 subm_E0BA          = &E0BA
 subm_E18E          = &E18E
 subm_E33E          = &E33E
 PIXEL              = &E4F0
 DrawDash           = &E543
 ECBLB2             = &E596
 MSBAR              = &E59F
 LE5B0_EN           = &E5B0
 LE602_DE           = &E602
 LE653_FR           = &E653
 subm_E802          = &E802
 subm_E8DE          = &E8DE
 subm_E909          = &E909
 subm_E91D          = &E91D
 subm_EA8D          = &EA8D
 subm_EAB0          = &EAB0
 subm_EB0D          = &EB0D
 subm_EB19          = &EB19
 subm_EB67          = &EB67
 subm_EB86          = &EB86
 LEB8C              = &EB8C
 LEB8F              = &EB8F
 DELAY              = &EBA2
 BEEP               = &EBA9
 EXNO3              = &EBAD
 ECBLB              = &EBBF
 BOOP               = &EBE5
 LEBE9              = &EBE9
 LEBED              = &EBED
 NOISE              = &EBF2
 noiseLookup1       = &EC3C
 noiseLookup2       = &EC5C
 SetupPPUForIconBar = &EC7D
 LDA_XX0_Y          = &EC8D
 LDA_Epc_Y          = &ECA0
 IncreaseTally      = &ECAE
 CB1D4_b0           = &ECE2
 LECE7              = &ECE7
 Set_K_K3_XC_YC     = &ECF9
 PlayMusic_b6       = &ED16
 C8021_b6           = &ED24
 C89D1_b6           = &ED50
 ResetSound_b6      = &ED6B
 ResetSoundNow_b6   = &ED6E
 LED73              = &ED73
 CBF41_b5           = &ED81
 CB9F9_b4           = &ED8F
 CB96B_b4           = &ED9D
 CB63D_b3           = &EDAB
 CB88C_b6           = &EDB9
 LL9_b1             = &EDC7
 CBA23_b3           = &EDDC
 TIDY_b1            = &EDEA
 TITLE_b6           = &EDFF
 SpawnDemoShips_b0  = &EE0D
 STARS_b1           = &EE15
 LEE2A              = &EE2A
 SUN_b1             = &EE3F
 CB2FB_b3           = &EE54
 CB219_b3           = &EE62
 CB9C1_b4           = &EE78
 LEE7D              = &EE7D
 CA082_b6           = &EE8B
 CA0F8_b6           = &EE99
 CB882_b4           = &EEA7
 CA4A5_b6           = &EEB5
 CB2EF_b0           = &EEC3
 LEECB              = &EECB
 CB9E2_b3           = &EED3
 CB673_b3           = &EEE8
 CB2BC_b3           = &EEF6
 CB248_b3           = &EF04
 CBA17_b6           = &EF12
 CAFCD_b3           = &EF20
 CBE52_b6           = &EF35
 CBED2_b6           = &EF43
 CB0E1_b3           = &EF51
 CB18E_b3           = &EF6C
 PAS1_b0            = &EF7A
 SetSystemImage_b5  = &EF88
 GetSystemImage_b5  = &EF96
 SetSystemImage2_b4 = &EFA4
 GetSystemImage2_b4 = &EFB2
 DIALS_b6           = &EFC0
 CBA63_b6           = &EFCE
 CB39D_b0           = &EFDC
 LL164_b6           = &EFF7
 CB919_b6           = &F005
 CA166_b6           = &F013
 CBBDE_b6           = &F021
 CBB37_b6           = &F02F
 CB8FE_b6           = &F03D
 CB90D_b6           = &F04B
 CA5AB_b6           = &F059
 subm_F06F          = &F06F
 BEEP_b7            = &F074
 DETOK_b2           = &F082
 DTS_b2             = &F09D
 PDESC_b2           = &F0B8
 CAE18_b3           = &F0C6
 CAC1D_b3           = &F0E1
 CA730_b3           = &F0FC
 CA775_b3           = &F10A
 DrawTitleScreen_b3 = &F118
 CA7B7_b3           = &F126
 LF12B              = &F12B
 CA9D1_b3           = &F139
 LF13F              = &F13F
 CA972_b3           = &F15C
 CAC5C_b3           = &F171
 C8980_b0           = &F186
 CB459_b6           = &F194
 MVS5_b0            = &F1A2
 HALL_b1            = &F1BD
 CHPR_b2            = &F1CB
 DASC_b2            = &F1E6
 TT27_b2            = &F201
 ex_b2              = &F21C
 TT27_b0            = &F237
 BR1_b0             = &F245
 CBAF3_b1           = &F25A
 LF260              = &F260
 TT66_b0            = &F26E
 CLIP_b1            = &F280
 ClearTiles_b3      = &F293
 SCAN_b1            = &F2A8
 C8926_b0           = &F2BD
 LF2C0              = &F2C0
 subm_F2CE          = &F2CE
 CLYNS              = &F2DE
 LF2E6              = &F2E6
 LF333              = &F333
 subm_F338          = &F338
 subm_F359          = &F359
 subm_F362          = &F362
 LF39A              = &F39A
 sub_CF3AB          = &F3AB
 subm_F3BC          = &F3BC
 subm_F42A          = &F42A
 Ze                 = &F42E
 subm_F454          = &F454
 NLIN3              = &F46A
 NLIN4              = &F473
 LF47D              = &F47D
 subm_F48D          = &F48D
 subm_F493          = &F493
 DORND2             = &F4AC
 DORND              = &F4AD
 PROJ               = &F4C1
 subm_F4FB          = &F4FB
 UnpackToRAM        = &F52D
 UnpackToPPU        = &F5AF
 FAROF2             = &F60C
 MU5                = &F65A
 MULT3              = &F664
 MLS2               = &F6BA
 MLS1               = &F6C2
 MULTS              = &F6C6
 MU6                = &F707
 SQUA               = &F70C
 SQUA2              = &F70E
 MU1                = &F713
 MLU1               = &F718
 MLU2               = &F71D
 MULTU              = &F721
 MU11               = &F725
 FMLTU2             = &F766
 FMLTU              = &F770
 MLTU2              = &F7AD
 MUT3               = &F7CE
 MUT2               = &F7D2
 MUT1               = &F7D6
 MULT1              = &F7DA
 MULT12             = &F83C
 TAS3               = &F853
 MAD                = &F86F
 ADD                = &F872
 TIS1               = &F8AE
 DV42               = &F8D1
 DV41               = &F8D4
 DVID4              = &F8D8
 DVID3B2            = &F962
 subm_FA16          = &FA16
 BUMP2              = &FA33
 REDU2              = &FA43
 LL5                = &FA55
 LL28               = &FA91
 subm_FACB          = &FACB
 NORM               = &FAF8
 SetupMMC1          = &FB89

ENDIF

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/nes/main/workspace/sprite_buffer.asm"
INCLUDE "library/common/main/workspace/wp.asm"
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

\ ******************************************************************************
\
\       Name: nameBuffer0
\       Type: Variable
\   Category: Drawing lines
\    Summary: Buffer for nametable and attribute table 0
\
\ ******************************************************************************

.nameBuffer0

 SKIP 30 * 32           \ 30 rows of 32 tile numbers

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)

\ ******************************************************************************
\
\       Name: nameBuffer1
\       Type: Variable
\   Category: Drawing lines
\    Summary: Buffer for nametable and attribute table 1
\
\ ******************************************************************************

.nameBuffer1

 SKIP 30 * 32           \ 30 rows of 32 tile numbers

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)

