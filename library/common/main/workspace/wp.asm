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

.L0300

 SKIP 1                 \ ???

.L0301

 SKIP 1                 \ ???

.L0302

 SKIP 1                 \ ???

.L0303

 SKIP 1                 \ ???

.L0304

 SKIP 1                 \ ???

.L0305

 SKIP 1                 \ ???

.L0306

 SKIP 1                 \ ???

.L0307

 SKIP 1                 \ ???

.L0308

 SKIP 1                 \ ???

.L0309

 SKIP 1                 \ ???

.L030A

 SKIP 1                 \ ???

.L030B

 SKIP 1                 \ ???

.L030C

 SKIP 1                 \ ???

.L030D

 SKIP 1                 \ ???

.L030E

 SKIP 1                 \ ???

.L030F

 SKIP 1                 \ ???

.L0310

 SKIP 1                 \ ???

.L0311

 SKIP 1                 \ ???

.L0312

 SKIP 1                 \ ???

.L0313

 SKIP 1                 \ ???

.L0314

 SKIP 1                 \ ???

.L0315

 SKIP 1                 \ ???

.L0316

 SKIP 1                 \ ???

.L0317

 SKIP 1                 \ ???

.L0318

 SKIP 1                 \ ???

.L0319

 SKIP 1                 \ ???

.L031A

 SKIP 1                 \ ???

.L031B

 SKIP 1                 \ ???

.L031C

 SKIP 1                 \ ???

.L031D

 SKIP 1                 \ ???

.L031E

 SKIP 1                 \ ???

.L031F

 SKIP 1                 \ ???

.L0320

 SKIP 1                 \ ???

.L0321

 SKIP 1                 \ ???

.L0322

 SKIP 1                 \ ???

.L0323

 SKIP 1                 \ ???

.L0324

 SKIP 1                 \ ???

.L0325

 SKIP 1                 \ ???

.L0326

 SKIP 1                 \ ???

.L0327

 SKIP 1                 \ ???

.L0328

 SKIP 1                 \ ???

.L0329

 SKIP 1                 \ ???

.L032A

 SKIP 1                 \ ???

.L032B

 SKIP 1                 \ ???

.L032C

 SKIP 1                 \ ???

.L032D

 SKIP 1                 \ ???

.L032E

 SKIP 1                 \ ???

.L032F

 SKIP 1                 \ ???

.L0330

 SKIP 1                 \ ???

.L0331

 SKIP 1                 \ ???

.L0332

 SKIP 1                 \ ???

.L0333

 SKIP 1                 \ ???

.L0334

 SKIP 1                 \ ???

.L0335

 SKIP 1                 \ ???

.L0336

 SKIP 1                 \ ???

.L0337

 SKIP 1                 \ ???

.L0338

 SKIP 1                 \ ???

.L0339

 SKIP 1                 \ ???

.L033A

 SKIP 1                 \ ???

.L033B

 SKIP 1                 \ ???

.L033C

 SKIP 1                 \ ???

.L033D

 SKIP 1                 \ ???

.L033E

 SKIP 1                 \ ???

.L033F

 SKIP 1                 \ ???

.L0340

 SKIP 1                 \ ???

.L0341

 SKIP 1                 \ ???

.L0342

 SKIP 1                 \ ???

.L0343

 SKIP 1                 \ ???

.L0344

 SKIP 1                 \ ???

.L0345

 SKIP 1                 \ ???

.L0346

 SKIP 1                 \ ???

.L0347

 SKIP 1                 \ ???

.L0348

 SKIP 1                 \ ???

.L0349

 SKIP 1                 \ ???

.L034A

 SKIP 1                 \ ???

.L034B

 SKIP 1                 \ ???

.L034C

 SKIP 1                 \ ???

.L034D

 SKIP 1                 \ ???

.L034E

 SKIP 1                 \ ???

.L034F

 SKIP 1                 \ ???

.L0350

 SKIP 1                 \ ???

.L0351

 SKIP 1                 \ ???

.L0352

 SKIP 1                 \ ???

.L0353

 SKIP 1                 \ ???

.L0354

 SKIP 1                 \ ???

.L0355

 SKIP 1                 \ ???

.L0356

 SKIP 1                 \ ???

.L0357

 SKIP 1                 \ ???

.L0358

 SKIP 1                 \ ???

.L0359

 SKIP 1                 \ ???

.L035A

 SKIP 1                 \ ???

.L035B

 SKIP 1                 \ ???

.L035C

 SKIP 1                 \ ???

.L035D

 SKIP 1                 \ ???

.L035E

 SKIP 1                 \ ???

.L035F

 SKIP 1                 \ ???

.L0360

 SKIP 1                 \ ???

.L0361

 SKIP 1                 \ ???

.L0362

 SKIP 1                 \ ???

.L0363

 SKIP 1                 \ ???

.L0364

 SKIP 1                 \ ???

.L0365

 SKIP 1                 \ ???

.L0366

 SKIP 1                 \ ???

.L0367

 SKIP 1                 \ ???

.L0368

 SKIP 1                 \ ???

.L0369

 SKIP 1                 \ ???

INCLUDE "library/common/main/variable/frin.asm"
INCLUDE "library/enhanced/main/variable/junk.asm"

.scannerFlags

 SKIP 10                \ ??? Bytes 1-8 contain flags for ships on scanner
                        \ Bytes 0 and 9 are unused

.scannerAttrs

 SKIP 10                \ ??? Bytes 1-8 contain attributes for ships on scanner
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

.L0395

 SKIP 1                 \ ???

INCLUDE "library/advanced/main/variable/name.asm"
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
INCLUDE "library/common/main/variable/svc.asm"
INCLUDE "library/common/main/variable/qq21.asm"
INCLUDE "library/common/main/variable/nostm.asm"

.L03E6

 SKIP 1                 \ ???

.L03E7

 SKIP 1                 \ ???

.L03E8

 SKIP 1                 \ ???

.L03E9

 SKIP 1                 \ ??? Unused?

.DAMP

 SKIP 1                 \ Damping config option

.JSTGY

 SKIP 1                 \ Flip up-down (y-axis)

.DNOIZ

 SKIP 1                 \ Disable sound

.disableMusic

 SKIP 1                 \ Disable music

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
                        \     * 0 = set the last tile number to lastTileNumber
                        \           for this bitplane
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

 SKIP 1                 \ Increments every VBlank ???

.L03F2

 SKIP 1                 \ ???

INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/variable/xp.asm"
INCLUDE "library/6502sp/main/variable/yp.asm"

.L03FC

 SKIP 1                 \ ???

.decimalPoint

 SKIP 1                 \ The decimal point character for the chosen language

.L03FE

 SKIP 1                 \ ???

.L03FF

 SKIP 1                 \ ???

INCLUDE "library/common/main/variable/las.asm"
INCLUDE "library/common/main/variable/mstg.asm"

.L0402

 SKIP 1

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

.L040A

 SKIP 1                 \ ???

.L040B

 SKIP 1                 \ ???

.L040C

 SKIP 1                 \ ???

.L040D

 SKIP 1                 \ ???

.L040E

 SKIP 1                 \ ???

.L040F

 SKIP 1                 \ ???

.L0410

 SKIP 1                 \ ???

.L0411

 SKIP 1                 \ ???

.L0412

 SKIP 1                 \ ???

.L0413

 SKIP 1                 \ ???

.L0414

 SKIP 1                 \ ???

.L0415

 SKIP 1                 \ ???

.L0416

 SKIP 1                 \ ???

.L0417

 SKIP 1                 \ ???

.L0418

 SKIP 1                 \ ???

.L0419

 SKIP 1                 \ ???

.L041A

 SKIP 1                 \ ???

.L041B

 SKIP 1                 \ ???

.L041C

 SKIP 1                 \ ???

.L041D

 SKIP 1                 \ ???

.L041E

 SKIP 1                 \ ???

.L041F

 SKIP 1                 \ ???

.L0420

 SKIP 1                 \ ???

.L0421

 SKIP 1                 \ ???

.L0422

 SKIP 1                 \ ???

.L0423

 SKIP 1                 \ ???

.L0424

 SKIP 1                 \ ???

.L0425

 SKIP 1                 \ ???

.L0426

 SKIP 1                 \ ???

.L0427

 SKIP 1                 \ ???

.L0428

 SKIP 1                 \ ???

.L0429

 SKIP 1                 \ ???

.L042A

 SKIP 1                 \ ???

.L042B

 SKIP 1                 \ ???

.L042C

 SKIP 1                 \ ???

.L042D

 SKIP 1                 \ ???

.L042E

 SKIP 1                 \ ???

.L042F

 SKIP 1                 \ ???

.L0430

 SKIP 1                 \ ???

.L0431

 SKIP 1                 \ ???

.L0432

 SKIP 1                 \ ???

.L0433

 SKIP 1                 \ ???

.L0434

 SKIP 1                 \ ???

.L0435

 SKIP 1                 \ ???

.L0436

 SKIP 1                 \ ???

.L0437

 SKIP 1                 \ ???

.L0438

 SKIP 1                 \ ???

.L0439

 SKIP 1                 \ ???

.L043A

 SKIP 1                 \ ???

.L043B

 SKIP 1                 \ ???

.L043C

 SKIP 1                 \ ???

.L043D

 SKIP 1                 \ ???

.L043E

 SKIP 1                 \ ???

.L043F

 SKIP 1                 \ ???

.L0440

 SKIP 1                 \ ???

.L0441

 SKIP 1                 \ ???

.L0442

 SKIP 1                 \ ???

.L0443

 SKIP 1                 \ ???

.L0444

 SKIP 1                 \ ???

.L0445

 SKIP 1                 \ ???

.L0446

 SKIP 1                 \ ???

.L0447

 SKIP 1                 \ ???

.L0448

 SKIP 1                 \ ???

.L0449

 SKIP 1                 \ ???

.L044A

 SKIP 1                 \ ???

.L044B

 SKIP 1                 \ ???

.L044C

 SKIP 1                 \ ???

INCLUDE "library/common/main/variable/qq19.asm"

.L0453

 SKIP 6                 \ ???

INCLUDE "library/common/main/variable/k2.asm"

.demoInProgress

 SKIP 1                 \ A flag to determine whether we are playing the demo:
                        \
                        \   * 0 = we are not playing the demo
                        \
                        \   * Non-zero = we are initialising or playing the demo
                        \
                        \   * Bit 7 set = we are initialising the demo

.L045E

 SKIP 1                 \ Sound-related, looks like bits 0-6 are the number of
                        \ the new tune we need to change to in ChooseMusic,
                        \ bit 7 set means we need to change to this tune ???

IF _PAL

.pointerTimerOn

 SKIP 1                 \ A flag to denote whether pointerTimer is non-zero:
                        \
                        \   * 0 = pointerTimer is zero
                        \
                        \   * 1 = pointerTimer is non-zero

ENDIF

.L045F

 SKIP 1                 \ ???

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

.pointerButton

 SKIP 1                 \ The button number from the iconBarButtons table for
                        \ the button under the icon bar pointer
                        \
                        \ Set to 80 if Start is pressed to pause the game

.L0466

 SKIP 1                 \ ??? Unused

.pointerTimer

 SKIP 1                 \ A timer that starts counting down when B is released
                        \ when moving the icon bar pointer, so that a double-tap
                        \ on B can be interpreted as a selection

.L0468

 SKIP 1                 \ ???

.nmiStoreA

 SKIP 1                 \ Temporary storage for the A register during NMI

.nmiStoreX

 SKIP 1                 \ Temporary storage for the X register during NMI

.nmiStoreY

 SKIP 1                 \ Temporary storage for the Y register during NMI

.pictureTile

 SKIP 1                 \ The number of the first tile where system pictures
                        \ are stored ???

.L046D

 SKIP 1                 \ ???

.boxEdge1

 SKIP 1                 \ Tile number for drawing box edge ???

.boxEdge2

 SKIP 1                 \ Tile number for drawing box edge ???

.L0470

 SKIP 1                 \ ???

.previousCondition

 SKIP 1                 \ ???

.statusCondition

 SKIP 1                 \ ???

.L0473

 SKIP 1                 \ ???

.L0474

 SKIP 1                 \ ???

.scanController2

 SKIP 1                 \ If non-zero, scan controller 2 ???
                        \
                        \ Toggled between 0 and 1 by the "one or two pilots"
                        \ configuration icon

INCLUDE "library/common/main/variable/jstx.asm"
INCLUDE "library/common/main/variable/jsty.asm"

.L0478

 SKIP 3                 \ ???

INCLUDE "library/common/main/variable/lasx.asm"
INCLUDE "library/common/main/variable/lasy.asm"

.L047D

 SKIP 1                 \ ???

INCLUDE "library/common/main/variable/altit.asm"
INCLUDE "library/common/main/variable/swap.asm"
INCLUDE "library/master/main/variable/distaway.asm"
INCLUDE "library/common/main/variable/xsav2.asm"
INCLUDE "library/common/main/variable/ysav2.asm"

.L0483

 SKIP 1                 \ ???

INCLUDE "library/common/main/variable/fsh.asm"
INCLUDE "library/common/main/variable/ash.asm"
INCLUDE "library/common/main/variable/energy.asm"
INCLUDE "library/common/main/variable/qq24.asm"
INCLUDE "library/common/main/variable/qq25.asm"
INCLUDE "library/common/main/variable/qq28.asm"
INCLUDE "library/common/main/variable/qq29.asm"

.imageFlags

 SKIP 1                 \ Contains data for the system and commander images:
                        \
                        \   * Bits 0-3 contain system image number from bank 5
                        \   * Bits 6 and 7 are set in bank 5 routine ???

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

.L04A0

 SKIP 1                 \ ???

.L04A1

 SKIP 1                 \ ???

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

 SKIP 1                 \ The language that was chosen on the start screen as an
                        \ index into the various lookup tables:
                        \
                        \   * 0 = English
                        \
                        \   * 1 = German
                        \
                        \   * 2 = French

.languageNumber

 SKIP 1                 \ The language that was chosen on the start screen as a
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

.L04BC

 SKIP 1                 \ ???

.L04BD

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

.L04C2

 SKIP 4                 \ ???

.ppuToBuffNameHi

 SKIP 1                 \ Add this to a nametable buffer address to get the
                        \ corresponding PPU nametable address (high byte) in
                        \ bitplane 0 ???

 SKIP 1                 \ Add this to a nametable buffer address to get the
                        \ corresponding PPU nametable address (high byte) in
                        \ bitplane 1 ???

INCLUDE "library/common/main/variable/sx.asm"
INCLUDE "library/common/main/variable/sy.asm"
INCLUDE "library/common/main/variable/sz.asm"
INCLUDE "library/advanced/main/variable/buf.asm"
INCLUDE "library/master/main/variable/hangflag.asm"
INCLUDE "library/common/main/variable/many.asm"
INCLUDE "library/common/main/variable/sspr.asm"

.L0584

 SKIP 1                 \ ???

.messageBuffer

 SKIP 32                \ A buffer for the in-flight message text

INCLUDE "library/common/main/variable/sxl.asm"
INCLUDE "library/common/main/variable/syl.asm"
INCLUDE "library/common/main/variable/szl.asm"
INCLUDE "library/advanced/main/variable/safehouse.asm"

.L05EA

 SKIP 1                 \ ???

.L05EB

 SKIP 1                 \ ???

.L05EC

 SKIP 1                 \ ???

.L05ED

 SKIP 1                 \ ???

.L05EE

 SKIP 1                 \ ???

.L05EF

 SKIP 1                 \ ???

.L05F0

 SKIP 1                 \ ???

.L05F1

 SKIP 1                 \ ???

.L05F2

 SKIP 1                 \ ???

 CLEAR BUF+32, P%       \ The following tables share space with BUF through to
 ORG BUF+32             \ K%, which we can do as the scroll text is not shown
                        \ at the same time as ships, stardust and so on

INCLUDE "library/6502sp/main/variable/x1tb.asm"
INCLUDE "library/6502sp/main/variable/y1tb.asm"
INCLUDE "library/6502sp/main/variable/x2tb.asm"

ENDIF

 PRINT "WP workspace from  ", ~WP," to ", ~P%

