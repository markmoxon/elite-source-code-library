\ ******************************************************************************
\
\       Name: SUN (Part 2 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Start from bottom of screen and erase the old sun
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases the old sun, starting at the bottom of the screen and working
\ upwards until we reach the bottom of the new sun.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the Master version, the screen size is not hard-coded, but is stored in a dedicated location, an approach that was presumably inherited from the non-BBC versions of the game

 LDY #2*Y-1             \ Set Y = y-coordinate of the bottom of the screen,
                        \ which we use as a counter in the following routine to
                        \ redraw the old sun

ELIF _MASTER_VERSION

 LDY Yx2M1              \ Set Y = y-coordinate of the bottom of the screen,
                        \ which we use as a counter in the following routine to
                        \ redraw the old sun

ENDIF

IF NOT(_NES_VERSION)

 LDA SUNX               \ Set YY(1 0) = SUNX(1 0), the x-coordinate of the
 STA YY                 \ vertical centre axis of the old sun that's currently
 LDA SUNX+1             \ on-screen
 STA YY+1

.PLFL2

 CPY TGT                \ If Y = TGT, we have reached the line where we will
 BEQ PLFL               \ start drawing the new sun, so there is no need to
                        \ keep erasing the old one, so jump down to PLFL

 LDA LSO,Y              \ Fetch the Y-th point from the sun line heap, which
                        \ gives us the half-width of the old sun's line on this
                        \ line of the screen

 BEQ PLF13              \ If A = 0, skip the following call to HLOIN2 as there
                        \ is no sun line on this line of the screen

 JSR HLOIN2             \ Call HLOIN2 to draw a horizontal line on pixel line Y,
                        \ with centre point YY(1 0) and half-width A, and remove
                        \ the line from the sun line heap once done

.PLF13

 DEY                    \ Decrement the loop counter

 BNE PLFL2              \ Loop back for the next line in the line heap until
                        \ we have either gone through the entire heap, or
                        \ reached the bottom row of the new sun

ELIF _NES_VERSION

 LDA XX2                \ ???
 STA YY
 LDA XX2+1
 STA YY+1
 LDY TGT
 LDA #0
 STA L05EB
 STA L05EC
 STA L05ED
 STA L05EE
 STA L05EF
 STA L05F0
 STA L05F1
 TYA
 TAX
 AND #&F8
 TAY
 LDA V+1
 BNE CAD1D
 TXA
 AND #7
 BEQ CAD04
 CMP #2
 BCC CACFA
 BEQ CACF0
 CMP #4
 BCC CACE6
 BEQ CACDC
 CMP #6
 BCC CACD2
 BEQ CACC8
.CACBE
 JSR sub_CAF35
 STA L05F1
 DEC V
 BEQ CAD2C
.CACC8
 JSR sub_CAF35
 STA L05F0
 DEC V
 BEQ CAD3B
.CACD2
 JSR sub_CAF35
 STA L05EF
 DEC V
 BEQ CAD4A
.CACDC
 JSR sub_CAF35
 STA L05EE
 DEC V
 BEQ CAD59
.CACE6
 JSR sub_CAF35
 STA L05ED
 DEC V
 BEQ CAD68
.CACF0
 JSR sub_CAF35
 STA L05EC
 DEC V
 BEQ CAD77
.CACFA
 JSR sub_CAF35
 STA L05EB
 DEC V
 BEQ CAD1B
.CAD04
 JSR sub_CAF35
 STA L05EA
 DEC V
 BEQ CAD19
 JSR CADC6
 TYA
 SEC
 SBC #8
 TAY
 BCS CACBE
 RTS

.CAD19
 BEQ CAD95
.CAD1B
 BEQ CAD86
.CAD1D
 JSR sub_CAF35
 STA L05F1
 LDX V
 INX
 STX V
 CPX K
 BCS CADA3
.CAD2C
 JSR sub_CAF35
 STA L05F0
 LDX V
 INX
 STX V
 CPX K
 BCS CADA8
.CAD3B
 JSR sub_CAF35
 STA L05EF
 LDX V
 INX
 STX V
 CPX K
 BCS CADAD
.CAD4A
 JSR sub_CAF35
 STA L05EE
 LDX V
 INX
 STX V
 CPX K
 BCS CADB2
.CAD59
 JSR sub_CAF35
 STA L05ED
 LDX V
 INX
 STX V
 CPX K
 BCS CADB7
.CAD68
 JSR sub_CAF35
 STA L05EC
 LDX V
 INX
 STX V
 CPX K
 BCS CADBC
.CAD77
 JSR sub_CAF35
 STA L05EB
 LDX V
 INX
 STX V
 CPX K
 BCS CADC1
.CAD86
 JSR sub_CAF35
 STA L05EA
 LDX V
 INX
 STX V
 CPX K
 BCS CADC6
.CAD95
 JSR CADC6
 TYA
 SEC
 SBC #8
 TAY
 BCC CADA2
 JMP CAD1D

.CADA2
 RTS

.CADA3
 LDA #0
 STA L05F0
.CADA8
 LDA #0
 STA L05EF
.CADAD
 LDA #0
 STA L05EE
.CADB2
 LDA #0
 STA L05ED
.CADB7
 LDA #0
 STA L05EC
.CADBC
 LDA #0
 STA L05EB
.CADC1
 LDA #0
 STA L05EA
.CADC6
 LDA L05EA
 CMP L05EB
 BCC CADD1
 LDA L05EB
.CADD1
 CMP L05EC
 BCC CADD9
 LDA L05EC
.CADD9
 CMP L05ED
 BCC CADE1
 LDA L05EC
.CADE1
 CMP L05EE
 BCC CADE9
 LDA L05EE
.CADE9
 CMP L05EF
 BCC CADF1
 LDA L05EF
.CADF1
 CMP L05F0
 BCC CADF9
 LDA L05F0
.CADF9
 CMP L05F1
 BCC CAE03
 LDA L05F1
 BEQ CAE29
.CAE03
 JSR EDGES
 BCS CAE29
 LDA X2
 AND #&F8
 STA P+1
 LDA XX15
 ADC #7
 BCS CAE29
 AND #&F8
 CMP P+1
 BCS CAE29
 STA P
 CMP #&F8
 BCS CAE26
 JSR sub_CAEE8
 JSR LE04A
.CAE26
 JMP CAE9B

.CAE29
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR EDGES-2
 BCS CAE46
 JSR LE0BA
.CAE46
 DEY
 LDA L05F0
 JSR EDGES-2
 BCS CAE52
 JSR LE0BA
.CAE52
 DEY
 LDA L05EF
 JSR EDGES-2
 BCS CAE5E
 JSR LE0BA
.CAE5E
 DEY
 LDA L05EE
 JSR EDGES-2
 BCS CAE6A
 JSR LE0BA
.CAE6A
 DEY
 LDA L05ED
 JSR EDGES-2
 BCS CAE76
 JSR LE0BA
.CAE76
 DEY
 LDA L05EC
 JSR EDGES-2
 BCS CAE82
 JSR LE0BA
.CAE82
 DEY
 LDA L05EB
 JSR EDGES-2
 BCS CAE8E
 JSR LE0BA
.CAE8E
 DEY
 LDA L05EA
 JSR EDGES-2
 BCS CAE9A
 JMP LE0BA

.CAE9A
 RTS

.CAE9B
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX P
 BEQ CAE9A
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR CB039
 DEY
 LDA L05F0
 JSR CB039
 DEY
 LDA L05EF
 JSR CB039
 DEY
 LDA L05EE
 JSR CB039
 DEY
 LDA L05ED
 JSR CB039
 DEY
 LDA L05EC
 JSR CB039
 DEY
 LDA L05EB
 JSR CB039
 DEY
 LDA L05EA
 JMP CB039

.sub_CAEE8
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX P+1
 STX XX15
 TYA
 CLC
 ADC #7
 TAY
 LDA L05F1
 JSR CB05D
 DEY
 LDA L05F0
 JSR CB05D
 DEY
 LDA L05EF
 JSR CB05D
 DEY
 LDA L05EE
 JSR CB05D
 DEY
 LDA L05ED
 JSR CB05D
 DEY
 LDA L05EB
 JSR CB05D
 DEY
 LDA L05EB
 JSR CB05D
 DEY
 LDA L05EA
 JMP CB05D

.sub_CAF35
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 STY Y1

ENDIF

