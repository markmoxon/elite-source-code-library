\ ******************************************************************************
\
\       Name: WP
\       Type: Workspace
IF _CASSETTE_VERSION \ Comment
\    Address: &0D40 to &0F33
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _ELECTRON_VERSION
\    Address: &0BE0 to &0CF3
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\    Address: &0E00 to &0E3B
\   Category: Workspaces
\    Summary: Variables
ELIF _6502SP_VERSION
\    Address: &0D00 to &0E3B
\   Category: Workspaces
\    Summary: Variables
ELIF _MASTER_VERSION
\    Address: &0E41 to &12A9
\   Category: Workspaces
\    Summary: Ship slots, variables
ELIF _NES_VERSION
\    Address: &0300 to &05FF
\   Category: Workspaces
\    Summary: Ship slots, variables
ENDIF
\
\ ******************************************************************************

IF _CASSETTE_VERSION \ Platform

 ORG &0D40

ELIF _ELECTRON_VERSION

 ORG &0BE0

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 ORG &0E00

ELIF _6502SP_VERSION

 ORG &0D00

ELIF _MASTER_VERSION

 ORG &0E41

ELIF _NES_VERSION

 ORG &0300

ENDIF

.WP

 SKIP 0                 \ The start of the WP workspace

IF _CASSETTE_VERSION \ Platform

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"
INCLUDE "library/common/main/variable/nostm.asm"

ELIF _ELECTRON_VERSION

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/electron/main/variable/sfxpr.asm"
INCLUDE "library/electron/main/variable/sfxdu.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"

ELIF _DISC_VERSION OR _ELITE_A_VERSION

INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/disc/main/variable/cpir.asm"

ELIF _6502SP_VERSION

INCLUDE "library/common/main/variable/lsx.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"
INCLUDE "library/6502sp/main/variable/ys.asm"
INCLUDE "library/6502sp/main/variable/bali.asm"
INCLUDE "library/6502sp/main/variable/upo.asm"

ELIF _MASTER_VERSION

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"
INCLUDE "library/enhanced/main/variable/auto.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"
INCLUDE "library/common/main/variable/lsx2.asm"
INCLUDE "library/common/main/variable/lsy2.asm"
INCLUDE "library/common/main/variable/lso.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"
INCLUDE "library/common/main/variable/xx24.asm"
INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"

.XP

 SKIP 1                 \ This byte appears to be unused

.YP

 SKIP 1                 \ This byte appears to be unused

.YS

 SKIP 1                 \ This byte appears to be unused

.BALI

 SKIP 1                 \ This byte appears to be unused

.UPO

 SKIP 1                 \ This byte appears to be unused

.boxsize

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"
INCLUDE "library/master/main/variable/nmi.asm"
INCLUDE "library/advanced/main/variable/name.asm"
INCLUDE "library/common/main/variable/tp.asm"
INCLUDE "library/common/main/variable/qq0.asm"
INCLUDE "library/common/main/variable/qq1.asm"
INCLUDE "library/common/main/variable/qq21.asm"
INCLUDE "library/common/main/variable/cash.asm"
INCLUDE "library/common/main/variable/qq14.asm"
INCLUDE "library/common/main/variable/cok.asm"
INCLUDE "library/common/main/variable/gcnt.asm"
INCLUDE "library/common/main/variable/laser.asm"

 SKIP 2                 \ These bytes appear to be unused (they were originally
                        \ used for up/down lasers, but they were dropped)

INCLUDE "library/common/main/variable/crgo.asm"
INCLUDE "library/common/main/variable/qq20.asm"
INCLUDE "library/common/main/variable/ecm.asm"
INCLUDE "library/common/main/variable/bst.asm"
INCLUDE "library/common/main/variable/bomb.asm"
INCLUDE "library/common/main/variable/engy.asm"
INCLUDE "library/common/main/variable/dkcmp.asm"
INCLUDE "library/common/main/variable/ghyp.asm"
INCLUDE "library/common/main/variable/escp.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/master/main/variable/tribble.asm"
INCLUDE "library/master/main/variable/tallyl.asm"
INCLUDE "library/common/main/variable/nomsl.asm"
INCLUDE "library/common/main/variable/fist.asm"
INCLUDE "library/common/main/variable/avl.asm"
INCLUDE "library/common/main/variable/qq26.asm"
INCLUDE "library/common/main/variable/tally.asm"
INCLUDE "library/common/main/variable/svc.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/mch.asm"
INCLUDE "library/common/main/variable/comx.asm"
INCLUDE "library/common/main/variable/comy.asm"

.dialc

 SKIP 14                \ These bytes appear to be unused

INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"
INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/slsp.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"
INCLUDE "library/master/main/variable/frump.asm"
INCLUDE "library/master/main/variable/jopos.asm"

ELIF _NES_VERSION

.allowInSystemJump

 SKIP 1                 \ Bits 6 and 7 record whether it is safe to perform an
                        \ in-system jump
                        \
                        \ Bits are set if, for example, hostile ships are in the
                        \ vicinity, or we are too near a station, the planet or
                        \ the sun
                        \
                        \ We can can only do a jump if both bits are clear

.soundVar01

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar02

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar03

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar04

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar05

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar06

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar07

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar08

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar09

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar0F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar10

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar11

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar12

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar13

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar14

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar15

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar16

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar17

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar18

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar19

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar1F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar20

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar21

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar22

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar23

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar24

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar25

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar26

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar27

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar28

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar29

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar2F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar30

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar31

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar32

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar33

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar34

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar35

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar36

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar37

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar38

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar39

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar3F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar40

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar41

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar42

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar43

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar44

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar45

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar46

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar47

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar48

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar49

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar4F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar50

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar51

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar52

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar53

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar54

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar55

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar56

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar57

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar58

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar59

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar5F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar60

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar61

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar62

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar63

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar64

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar65

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar66

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar67

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar68

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar69

 SKIP 1                 \ A variable used by David Whittaker's sound module

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"

.scannerNumber

 SKIP 10                \ Details of which scanner numbers are allocated to
                        \ ships on the scanner
                        \
                        \ Bytes 1 to 8 contain the following:
                        \
                        \   * &FF indicates that this scanner number (1 to 8)
                        \     is allocated to a ship so that is it shown on
                        \     the scanner (the scanner number is stored in byte
                        \     #33 of the ship's data block)
                        \
                        \   * 0 indicates that this scanner number (1 to 8) is
                        \     not yet allocated to a ship
                        \
                        \ Bytes 0 and 9 in the table are unused

.scannerColour

 SKIP 10                \ The colour of each ship number on the scanner, stored
                        \ as the sprite palette number for that ship's three
                        \ scanner sprites
                        \
                        \ Bytes 1 to 8 contain palettes for ships with non-zero
                        \ entries in the scannerNumber table (i.e. for ships on
                        \ the scanner)
                        \
                        \ Bytes 0 and 9 are unused

INCLUDE "library/enhanced/main/variable/auto.asm"
INCLUDE "library/common/main/variable/ecmp.asm"
INCLUDE "library/common/main/variable/mj.asm"
INCLUDE "library/common/main/variable/cabtmp.asm"
INCLUDE "library/common/main/variable/las2.asm"
INCLUDE "library/common/main/variable/msar.asm"
INCLUDE "library/common/main/variable/view.asm"
INCLUDE "library/common/main/variable/lasct.asm"
INCLUDE "library/common/main/variable/gntmp.asm"
INCLUDE "library/common/main/variable/hfx.asm"
INCLUDE "library/common/main/variable/ev.asm"
INCLUDE "library/common/main/variable/dly.asm"
INCLUDE "library/common/main/variable/de.asm"

.selectedSystemFlag

 SKIP 1                 \ Flags for the currently selected system
                        \
                        \   * Bit 6 is set when we can hyperspace to the
                        \     currently selected system, clear otherwise
                        \
                        \   * Bit 7 is set when when there is a currently
                        \     selected system, clear otherwise (such as when we
                        \     are moving the crosshairs between systems)

INCLUDE "library/advanced/main/variable/name.asm"
INCLUDE "library/common/main/variable/svc.asm"
INCLUDE "library/common/main/variable/tp.asm"
INCLUDE "library/common/main/variable/qq0.asm"
INCLUDE "library/common/main/variable/qq1.asm"
INCLUDE "library/common/main/variable/cash.asm"
INCLUDE "library/common/main/variable/qq14.asm"
INCLUDE "library/common/main/variable/cok.asm"
INCLUDE "library/common/main/variable/gcnt.asm"
INCLUDE "library/common/main/variable/laser.asm"
INCLUDE "library/common/main/variable/crgo.asm"
INCLUDE "library/common/main/variable/qq20.asm"
INCLUDE "library/common/main/variable/ecm.asm"
INCLUDE "library/common/main/variable/bst.asm"
INCLUDE "library/common/main/variable/bomb.asm"
INCLUDE "library/common/main/variable/engy.asm"
INCLUDE "library/common/main/variable/dkcmp.asm"
INCLUDE "library/common/main/variable/ghyp.asm"
INCLUDE "library/common/main/variable/escp.asm"
INCLUDE "library/master/main/variable/tribble.asm"
INCLUDE "library/master/main/variable/tallyl.asm"
INCLUDE "library/common/main/variable/nomsl.asm"
INCLUDE "library/common/main/variable/fist.asm"
INCLUDE "library/common/main/variable/avl.asm"
INCLUDE "library/common/main/variable/qq26.asm"
INCLUDE "library/common/main/variable/tally.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/qq21.asm"
INCLUDE "library/common/main/variable/nostm.asm"

.burstSpriteIndex

 SKIP 1                 \ The index into the sprite buffer of the explosion
                        \ burst sprite that is set up in PTCLS2

.unusedVariable

 SKIP 1                 \ This variable is zeroed in RES2 but is never read

.chargeDockingFee

 SKIP 1                 \ Records whether we have been charged a docking fee, so
                        \ we don't get charged twice:
                        \
                        \   * 0 = we have not been charged a docking fee
                        \
                        \   * Non-zero = we have been charged a docking fee
                        \
                        \ The docking fee is 5.0 credits

.priceDebug

 SKIP 1                 \ This is only referenced by some disabled test code in
                        \ the prx routine, where it was presumably used for
                        \ testing different equipment prices

INCLUDE "library/common/main/variable/damp.asm"
INCLUDE "library/common/main/variable/jstgy.asm"
INCLUDE "library/common/main/variable/dnoiz.asm"

.disableMusic

 SKIP 1                 \ Music on/off configuration setting
                        \
                        \   * 0 = music is on (default)
                        \
                        \   * Non-zero = sound is off

.autoPlayDemo

 SKIP 1                 \ Controls whether to play the demo automatically (which
                        \ happens after it is left idle for a while)
                        \
                        \   * Bit 7 clear = do not play the demo automatically
                        \
                        \   * Bit 7 set = play the demo automatically using
                        \                 the controller key presses in the
                        \                 autoplayKeys table

.bitplaneFlags

 SKIP 1                 \ Flags for bitplane 0 that control the sending of data
                        \ for this bitplane to the PPU during VBlank in the NMI
                        \ handler:
                        \
                        \   * Bit 0 is ignored and is always clear
                        \
                        \   * Bit 1 is ignored and is always clear
                        \
                        \   * Bit 2 overrides the number of the last tile to
                        \     send to the PPU nametable in SendBuffersToPPU:
                        \
                        \     * 0 = set the last tile number to lastNameTile or
                        \           lastPatternTile for this bitplane (when
                        \           sending nametable and pattern entries
                        \           respectively)
                        \
                        \     * 1 = set the last tile number to 128 (which means
                        \           tile 8 * 128 = 1024)
                        \
                        \   * Bit 3 controls the clearing of this bitplane's
                        \     buffer in NMI handler, once it has been sent to
                        \
                        \     * 0 = do not clear this bitplane's buffer
                        \
                        \     * 1 = clear this bitplane's buffer once it has
                        \           been sent to the PPU
                        \
                        \   * Bit 4 determines whether a tile data transfer is
                        \     already in progress for this bitplane:
                        \
                        \     * 0 = we are not currently in the process of
                        \           sending tile data to the PPU for this
                        \           bitplane
                        \
                        \     * 1 = we are in the process of sending tile data
                        \           to the PPU for the this bitplane, possibly
                        \           spread across multiple VBlanks
                        \
                        \   * Bit 5 determines whether we have already sent all
                        \     the data to the PPU for this bitplane:
                        \
                        \     * 0 = we have not already sent all the data to the
                        \           PPU for this bitplane
                        \
                        \     * 1 = we have already sent all the data to the PPU
                        \           for this bitplane
                        \
                        \   * Bit 6 determines whether to send nametable data as
                        \     well as pattern data
                        \
                        \     * 0 = only send pattern data for this bitplane,
                        \           and stop sending it if the other bitplane is
                        \           ready to be sent
                        \
                        \     * 1 = send both pattern and nametable data for
                        \           this bitplane
                        \
                        \   * Bit 7 determines whether we should send data to
                        \     the PPU for this bitplane
                        \
                        \     * 0 = do not send data to the PPU
                        \
                        \     * 1 = send data to the PPU

 SKIP 1                 \ Flags for bitplane 1 (see above)

.frameCounter

 SKIP 1                 \ The frame counter, which increments every VBlank at
                        \ the start of the NMI handler

.screenReset

 SKIP 1                 \ Gets set to 245 when the screen is reset, but this
                        \ value is only read once (in SetupViewInNMI) and the
                        \ value is ignored, so this doesn't have any effect

INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"

.tempVar

 SKIP 1                 \ Temporary storage, used in various places

.decimalPoint

 SKIP 1                 \ The decimal point character for the chosen language

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"

.scrollTextSpeed

 SKIP 1                 \ Controls the speed of the scroll text in the demo

\INCLUDE "library/common/main/variable/kl.asm"

.KL

 SKIP 0                 \ The following bytes implement a key logger that
                        \ enables Elite to scan for concurrent key presses on
                        \ both controllers

INCLUDE "library/common/main/variable/ky1.asm"
INCLUDE "library/common/main/variable/ky2.asm"
INCLUDE "library/common/main/variable/ky3.asm"
INCLUDE "library/common/main/variable/ky4.asm"
INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky6.asm"
INCLUDE "library/common/main/variable/ky7.asm"

.cloudSize

 SKIP 1                 \ Used to store the explosion cloud size in PTCLS

.soundVar6B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar6C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar6D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar6E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar6F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar70

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar71

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar72

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar73

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar74

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar75

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar76

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar77

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar78

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar79

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar7F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar80

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar81

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar82

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar83

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar84

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar85

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar86

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar87

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar88

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar89

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar8F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar90

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar91

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar92

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar93

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar94

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar95

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar96

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar97

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar98

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar99

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9A

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9B

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9C

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9D

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9E

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVar9F

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA0

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA1

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA2

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA3

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA4

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA5

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA6

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA7

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA8

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarA9

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarAA

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarAB

 SKIP 1                 \ A variable used by David Whittaker's sound module

.soundVarAC

 SKIP 1                 \ A variable used by David Whittaker's sound module

INCLUDE "library/common/main/variable/qq19.asm"

.selectedSystem

 SKIP 6                 \ The three 16-bit seeds for the selected system, i.e.
                        \ the one we most recently snapped the crosshairs to
                        \ in a chart view

INCLUDE "library/common/main/variable/k2.asm"

.demoInProgress

 SKIP 1                 \ A flag to determine whether we are playing the demo:
                        \
                        \   * 0 = we are not playing the demo
                        \
                        \   * Non-zero = we are initialising or playing the demo
                        \
                        \   * Bit 7 set = we are initialising the demo

.newTune

 SKIP 1                 \ The number of the new tune when choosing the
                        \ background music
                        \
                        \   * Bits 0-6 = the tune number (1-4)
                        \                0 indicates no tune is selected
                        \
                        \   * Bit 7 set = we are still in the process of
                        \                 changing to this tune

IF _PAL

.pointerTimerOn

 SKIP 1                 \ A flag to denote whether pointerTimer is non-zero:
                        \
                        \   * 0 = pointerTimer is zero
                        \
                        \   * 1 = pointerTimer is non-zero

ENDIF

.showIconBarPointer

 SKIP 1                 \ Controls whether to show the icon bar pointer
                        \
                        \   * 0 = do not show the icon bar pointer
                        \
                        \   * &FF = show the icon bar pointer

.xIconBarPointer

 SKIP 1                 \ The x-coordinate of the icon bar pointer
                        \
                        \ Each of the 12 buttons on the bar is positioned at an
                        \ interval of 4, so the buttons have x-coordinates of
                        \ of 0, 4, 8 and so on, up to 44 for the rightmost
                        \ button

.yIconBarPointer

 SKIP 1                 \ The y-coordinate of the icon bar pointer
                        \
                        \ This is either 148 (when the dashboard is visible) or
                        \ 204 (when there is no dashboard and the icon bar is
                        \ along the bottom of the screen)

.pointerDirection

 SKIP 1                 \ The direction in which the icon bar pointer is moving:
                        \
                        \   * 0 = pointer is not moving
                        \
                        \   * 1 = pointer is moving to the right
                        \
                        \   * &FF = pointer is moving to the left

.pointerPosition

 SKIP 1                 \ The position of the icon bar pointer as it moves
                        \ between icons, counting down from 12 (at the start of
                        \ the move) to 0 (at the end of the move)

.iconBarType

 SKIP 1                 \ The type of the current icon bar:
                        \
                        \   * 0 = docked
                        \   * 1 = flight
                        \   * 2 = charts
                        \   * 3 = pause options
                        \   * 4 = title screen copyright message

.iconBarChoice

 SKIP 1                 \ The number of the icon bar button that's just been
                        \ selected
                        \
                        \   * 0 means no button has been selected
                        \
                        \   * A button number from the iconBarButtons table
                        \     means that button has been selected by pressing
                        \     Select on that button (or the B button has been
                        \     tapped twice)
                        \
                        \   * 80 means the Start has been pressed to pause the
                        \     game
                        \
                        \ This variable is set in the NMI handler, so the
                        \ selection is recorded in the background

 SKIP 1                 \ This byte appears to be unused

.pointerTimer

 SKIP 1                 \ A timer that starts counting down when B is released
                        \ when moving the icon bar pointer, so that a double-tap
                        \ on B can be interpreted as a selection

.pointerSelection

 SKIP 1                 \ Can be 0 or 30, iconBarChoice is only updated when
                        \ this is non-zero ???

.nmiStoreA

 SKIP 1                 \ Temporary storage for the A register during NMI

.nmiStoreX

 SKIP 1                 \ Temporary storage for the X register during NMI

.nmiStoreY

 SKIP 1                 \ Temporary storage for the Y register during NMI

.pictureTile

 SKIP 1                 \ The number of the first free tile where commander and
                        \ system images can be stored in the buffers

.flipEveryBitplane0

 SKIP 1                 \ A flag that flips every time we run the main loop and
                        \ the drawing bitplane is set to 0
                        \
                        \ Flips between 0 or &FF after the screen has been drawn
                        \ in the main loop, but only if drawingBitplane = 0

.boxEdge1

 SKIP 1                 \ The tile number for drawing the left edge of a box
                        \
                        \   * 0 = no box, for use in the Game Over screen
                        \
                        \   * 1 = standard box, for use in all other screens

.boxEdge2

 SKIP 1                 \ The tile number for drawing the right edge of a box
                        \
                        \   * 0 = no box, for use in the Game Over screen
                        \
                        \   * 2 = standard box, for use in all other screens

.chartToShow

 SKIP 1                 \ Controls which chart is shown when choosing the chart
                        \ icon on the icon bar (as the Long-range and Short-range
                        \ Charts share the same button)
                        \
                        \   * Bit 7 clear = show Short-range Chart
                        \
                        \   * Bit 7 clear = show Long-range Chart

.previousCondition

 SKIP 1                 \ Used to store the ship's previous status condition
                        \ (i.e. docked, green, yellow or red), so we can tell
                        \ how the situation is changing

.statusCondition

 SKIP 1                 \ Used to store the ship's current status condition
                        \ (i.e. docked, green, yellow or red)

.screenFadedToBlack

 SKIP 1                 \ Records whether the screen has been faded to black
                        \
                        \   * Bit 7 clear = screen is full colour
                        \
                        \   * Bit 7 set = screen has been faded to black

 SKIP 1                 \ This byte appears to be unused

.scanController2

 SKIP 1                 \ A flag to determine whether to scan controller 2 for
                        \ button presses
                        \
                        \   * 0 = do not scan controller 2
                        \
                        \   * Non-zero = scan controller 2
                        \
                        \ This value is toggled between 0 and 1 by the "one or
                        \ two pilots" configuration icon in the pause menu

INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"

.channelPriority

 SKIP 3                 \ The priority of the sound on the current channel
                        \ (0 to 2)

INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"

 SKIP 1                 \ This byte appears to be unused

INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"

.inputNameSize

 SKIP 1                 \ The maximum size of the name to be fetched by the
                        \ InputName routine

INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"

.imageSentToPPU

 SKIP 1                 \ Records when images have been sent to the PPU or
                        \ unpacked into the buffers, so we don't repeat the
                        \ process unnecessarily
                        \
                        \   * 0 = dashboard image has been sent to the PPU
                        \
                        \   * 1 = font image has been sent to the PPU
                        \
                        \   * 2 = Cobra Mk III image has been sent to the PPU
                        \         for the Equip Ship screen
                        \
                        \   * 3 = the small Elite logo has been sent to the PPU
                        \         for the Save and load screen
                        \
                        \   * 245 = the inventory icon image has been sent to
                        \           the PPU for the Market Price screen
                        \
                        \   * %1000xxxx = the headshot image has been sent to
                        \                 the PPU for the Status Mode screen,
                        \                 where %xxxx is the headshot number
                        \                 (0-13)
                        \
                        \   * %1100xxxx = the system background image has been
                        \                 unpacked into the buffers for the Data
                        \                 on System screen, where %xxxx is the
                        \                 system image number (0-14)

INCLUDE "library/common/main/variable/gov.asm"
INCLUDE "library/common/main/variable/tek.asm"
INCLUDE "library/common/main/variable/qq2.asm"
INCLUDE "library/common/main/variable/qq3.asm"
INCLUDE "library/common/main/variable/qq4.asm"
INCLUDE "library/common/main/variable/qq5.asm"
INCLUDE "library/common/main/variable/qq6.asm"
INCLUDE "library/common/main/variable/qq7.asm"
INCLUDE "library/common/main/variable/qq8.asm"
INCLUDE "library/common/main/variable/qq9.asm"
INCLUDE "library/common/main/variable/qq10.asm"

.systemNumber

 SKIP 1                 \ The current system number, as calculated in TT111 when
                        \ finding the nearest system in the galaxy

 SKIP 1                 \ This byte appears to be unused

.systemsOnChart

 SKIP 1                 \ A counter for the number of systems drawn on the
                        \ Short-range Chart, so it gets limited to 24 systems

.spasto

 SKIP 2                 \ Contains the address of the ship blueprint of the
                        \ space station (which can be a Coriolis or Dodo)

.QQ18Lo

 SKIP 1                 \ Gets set to the low byte of the address of the text
                        \ token table used by the ex routine (QQ18)

.QQ18Hi

 SKIP 1                 \ Gets set to the high byte of the address of the text
                        \ token table used by the ex routine (QQ18)

.TKN1Lo

 SKIP 1                 \ Gets set to the low byte of the address of the text
                        \ token table used by the DETOK routine (TKN1)

.TKN1Hi

 SKIP 1                 \ Gets set to the high byte of the address of the text
                        \ token table used by the DETOK routine (TKN1)

.languageIndex

 SKIP 1                 \ The language that was chosen on the Start screen as an
                        \ index into the various lookup tables:
                        \
                        \   * 0 = English
                        \
                        \   * 1 = German
                        \
                        \   * 2 = French

.languageNumber

 SKIP 1                 \ The language that was chosen on the Start screen as a
                        \ number:
                        \
                        \   * 1 = Bit 0 set = English
                        \
                        \   * 2 = Bit 1 set = German
                        \
                        \   * 4 = Bit 2 set = French

.controller1Down

 SKIP 1                 \ ???

.controller2Down

 SKIP 1                 \ ???

.controller1Up

 SKIP 1                 \ ???

.controller2Up

 SKIP 1                 \ ???

.controller1Left

 SKIP 1                 \ ???

.controller2Left

 SKIP 1                 \ ???

.controller1Right

 SKIP 1                 \ ???

.controller2Right

 SKIP 1                 \ ???

.controller1A

 SKIP 1                 \ ???

.controller2A

 SKIP 1                 \ ???

.controller1B

 SKIP 1                 \ ???

.controller2B

 SKIP 1                 \ ???

.controller1Start

 SKIP 1                 \ ???

.controller2Start

 SKIP 1                 \ ???

.controller1Select

 SKIP 1                 \ ???

.controller2Select

 SKIP 1                 \ ???

.controller1Leftx8

 SKIP 1                 \ ???

.controller1Rightx8

 SKIP 1                 \ ???

.autoplayKey

 SKIP 1                 \ ???

.demoLoopCounter

 SKIP 1                 \ ???

.pattTileBuffHi

 SKIP 1                 \ (pattTileBuffHi pattTileBuffLo) contains the address
                        \ of the pattern buffer for the tile we are sending to
                        \ the PPU from bitplane 0 (i.e. for tile number
                        \ sendingPattTile in bitplane 0)

 SKIP 1                 \ (pattTileBuffHi pattTileBuffLo) contains the address
                        \ of the pattern buffer for the tile we are sending to
                        \ the PPU from bitplane 1 (i.e. for tile number
                        \ sendingPattTile in bitplane 1)

.nameTileBuffHi

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 0 (i.e. for tile number
                        \ sendingNameTile in bitplane 0)

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 1 (i.e. for tile number
                        \ sendingNameTile in bitplane 1)

 SKIP 4                 \ These bytes appear to be unused

.ppuToBuffNameHi

 SKIP 1                 \ A high byte that we can add to an address in nametable
                        \ buffer 0 to get the corresponding address in the PPU
                        \ nametable

 SKIP 1                 \ A high byte that we can add to an address in nametable
                        \ buffer 1 to get the corresponding address in the PPU
                        \ nametable

INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/master/main/variable/hangflag.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"

.messageLength

 SKIP 1                 \ The length of the message stored in the message buffer

.messageBuffer

 SKIP 32                \ A buffer for the in-flight message text

INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"

.sunWidth0

 SKIP 1                 \ The half-width of the sun on pixel row 0 in the tile
                        \ row that is currently being drawn

.sunWidth1

 SKIP 1                 \ The half-width of the sun on pixel row 1 in the tile
                        \ row that is currently being drawn

.sunWidth2

 SKIP 1                 \ The half-width of the sun on pixel row 2 in the tile
                        \ row that is currently being drawn

.sunWidth3

 SKIP 1                 \ The half-width of the sun on pixel row 3 in the tile
                        \ row that is currently being drawn

.sunWidth4

 SKIP 1                 \ The half-width of the sun on pixel row 4 in the tile
                        \ row that is currently being drawn

.sunWidth5

 SKIP 1                 \ The half-width of the sun on pixel row 5 in the tile
                        \ row that is currently being drawn

.sunWidth6

 SKIP 1                 \ The half-width of the sun on pixel row 6 in the tile
                        \ row that is currently being drawn

.sunWidth7

 SKIP 1                 \ The half-width of the sun on pixel row 7 in the tile
                        \ row that is currently being drawn

.shipIsAggressive

 SKIP 1                 \ A flag to record just how aggressive the current ship
                        \ is in the TACTICS routine
                        \
                        \ Bit 7 set indicates the ship in tactics is looking
                        \ for a fight

 CLEAR BUF+32, P%       \ The following tables share space with BUF through to
 ORG BUF+32             \ K%, which we can do as the scroll text is not shown
                        \ at the same time as ships, stardust and so on

INCLUDE "library/6502sp/main/variable/x1tb.asm"
INCLUDE "library/6502sp/main/variable/y1tb.asm"
INCLUDE "library/6502sp/main/variable/x2tb.asm"

ENDIF

 PRINT "WP workspace from  ", ~WP," to ", ~P%

