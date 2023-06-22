\ ******************************************************************************
\
\       Name: mes9
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token, possibly followed by " DESTROYED"
\
\ ------------------------------------------------------------------------------
\
\ Print a text token, followed by " DESTROYED" if the destruction flag is set
\ (for when a piece of equipment is destroyed).
\
\ ******************************************************************************

.mes9

IF NOT(_NES_VERSION)

 JSR TT27               \ Call TT27 to print the text token in A

ELIF _NES_VERSION

 JSR TT27_b2            \ Call TT27 to print the text token in A

.CB7E8

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC out                \ subroutine (as out contains an RTS)

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LSR de                 \ If bits 1-7 of variable de are clear, return from the
 BEQ out                \ subroutine (as out contains an RTS). This means that
                        \ " DESTROYED" is never shown, even if bit 0 of de is
                        \ set, which makes sense as we are docked

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC DK5                \ subroutine (as DK5 contains an RTS)

ELIF _NES_VERSION

 LDA de                 \ If de is zero, then jump to CB7F2 to skip the
 BEQ CB7F2              \ following, as we don't need to print " DESTROYED"

ENDIF

IF NOT(_NES_VERSION)

 LDA #253               \ Print recursive token 93 (" DESTROYED") and return
 JMP TT27               \ from the subroutine using a tail call

ELIF _NES_VERSION

 LDA #253               \ Print recursive token 93 (" DESTROYED")
 JSR TT27_b2

.CB7F2

 LDA #&20               \ ???
 SEC
 SBC DTW5
 BCS CB801

 LDA #&1F
 STA DTW5

 LDA #2

.CB801

 LSR A
 STA messXC

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX DTW5
 STX L0584
 INX

.loop_CB818

 LDA BUF-1,X
 STA L0584,X
 DEX
 BNE loop_CB818

 STX de

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ Fall through into subm_B831 to reset DTW4 and DTW5 ???

ENDIF

