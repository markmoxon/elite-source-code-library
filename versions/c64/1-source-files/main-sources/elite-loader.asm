\ ******************************************************************************
\
\ COMMODORE 64 ELITE LOADER FILE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * COMLOD.unprot.bin
\
\ after reading in the following files:
\
\   * LODATA.bin
\   * SHIPS.bin
\   * CODIALS.bin
\	* SPRITE.bin
\	* DATE4.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85                 = (_VARIANT = 1)
 _SOURCE_DISC_BUILD     = (_VARIANT = 2)
 _SOURCE_DISC_FILES     = (_VARIANT = 3)

 CODE% = &4000
 LOAD% = &4000

 KEY3 = &8E
 KEY4 = &6C

 ZP = &18
 ZP2 = &1A
 L1 = 1
 D% = &D000
 CIA = &DC00
 CIA2 = &DD00
 VIC = &D000
 SCBASE = &4000
 DSTORE% = SCBASE + &2800
 SPRITELOC% = SCBASE + &3100
 COLMEM = &D800

 ORG CODE%

.W%

.LODATA

 INCBIN "versions/c64/3-assembled-output/LODATA.bin"

.SHIPS

IF _GMA85 OR _SOURCE_DISC_BUILD

 INCBIN "versions/c64/1-source-files/other-files/source-disc-build/C.SHIPS.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/other-files/source-disc-files/C.SHIPS.bin"

ENDIF

IF _GMA85 OR _SOURCE_DISC_BUILD

 EQUB &B3, &1F, &3F, &58, &98, &A0, &40, &20
 EQUB &1F, &F0, &8C, &98, &1A, &46, &10, &8C
 EQUB &CF, &3C, &B2, &CF, &C2, &7D, &FF, &2A
 EQUB &92, &AB, &A8, &BD, &3E, &85, &9E, &19
 EQUB &85, &F5, &3A, &EF, &06, &E6, &E4, &04
 EQUB &07, &E7, &E5, &EA, &AA, &2E, &98, &2F
 EQUB &10, &F0, &E2, &02, &12, &F2, &E3, &03
 EQUB &DA, &BA, &E4, &04, &DB, &BB, &E5, &19
 EQUB &39, &85, &25, &2E, &98, &3A, &BB, &B0
 EQUB &12, &13, &03, &E3, &F3, &F2, &E2, &7D
 EQUB &1A, &B2, &5D, &02, &E2, &F0, &10, &03
 EQUB &E3, &F2, &8D, &1A, &B2, &40, &78, &2F
 EQUB &E4, &01, &2C, &ED, &E3, &21, &2B, &5C
 EQUB &52, &22, &A8, &CB, &07, &2E, &DB, &BB
 EQUB &E5, &05, &DC, &BC

ELIF _SOURCE_DISC_FILES

 EQUB &38, &E0, &60, &3F, &0F, &7C, &24, &B2
 EQUB &60, &56, &9C, &67, &23, &FA, &81, &91
 EQUB &3F, &7C, &29, &BC, &3D, &53, &65, &FB
 EQUB &C3, &23, &B7, &9E, &7A, &2F, &29, &F5
 EQUB &EC, &CA, &E8, &0B, &EE, &CC, &CF, &94
 EQUB &D8, &C6, &C7, &3F, &00, &D2, &E4, &14
 EQUB &04, &D5, &E6, &DD, &94, &9E, &E8, &DF
 EQUB &96, &A0, &FE, &52, &BE, &AA, &53, &C6
 EQUB &D2, &F5, &6B, &C2, &25, &16, &E6, &D6
 EQUB &E5, &D4, &5F, &A3, &E5, &1D, &60, &E4
 EQUB &D2, &00, &13, &E6, &D5, &7F, &B3, &E5
 EQUB &00, &B9, &A7, &13, &E5, &2D, &19, &D0
 EQUB &04, &4C, &87, &AE, &74, &CA, &73, &D2
 EQUB &35, &09, &96, &A0, &EA, &E1, &98, &A2
 EQUB &66, &AE, &C6, &04

ENDIF

.X%

 JMP &185

.FRIN

 JSR &134

.ENTRY

 CLD
\DEEOR 
 LDA #((U%-1)MOD256) 
 STA FRIN 
 LDA #((U%-1)DIV256) 
 STA FRIN+1 
 LDA #((V%-1)DIV256) 
 LDY #((V%-1)MOD256) 
 LDX #KEY3 
 JSR DEEORS
 LDA #((W%-1)MOD256) 
 STA FRIN 
 LDA #((W%-1)DIV256) 
 STA FRIN+1 
 LDA #((X%-1)DIV256) 
 LDY #((X%-1)MOD256) 
 LDX #KEY4 
 JSR DEEORS 
 JMP U%

.DEEORS 

 STX ZP2 
 STA ZP+1 
 LDA #0 
 STA ZP 

.DEEORL

 LDA (ZP),Y 
 SEC  
 SBC ZP2 
 STA (ZP),Y 
 STA ZP2 
 TYA  
 BNE P%+4 
 DEC ZP+1 
 DEY  
 CPY FRIN 
 BNE DEEORL 
 LDA ZP+1 
 CMP FRIN+1 
 BNE DEEORL 
 RTS 

.U%

 LDX #&16 
 LDA #0 
 STA ZP 
 LDA #&7 
 STA ZP+1 
 LDA #(LODATA MOD256) 
 STA ZP2 
 LDA #(LODATA DIV256) 
 JSR mvblock
 SEI 
 LDA L1 
 AND #&F8 
 ORA #4 
 STA L1 \RAM paging
 LDX #&20 
 LDA #(D% MOD256) 
 STA ZP 
 LDA #(D% DIV256) 
 STA ZP+1 
 LDA #(SHIPS MOD256) 
 STA ZP2 
 LDA #(SHIPS DIV256) 
 JSR mvblock
 LDA L1 
 AND #&F8 
 ORA #5 
 STA L1 \I/O in
 LDA CIA2+2 
 ORA #3 
 STA CIA2+2 \Port A Direction
 LDA CIA2+0 
 AND #&FC 
 ORA #2 
 STA CIA2+0 \Port A (BANK=&4000)
 LDA #3 
 STA CIA+&D 
 STA CIA2+&D \**
 \.. ..VIC....
 LDA #&81 
 STA VIC+&18 \Screen Mem=BANK+&2000
 LDA #0 
 STA VIC+&20 \Border Colour
 LDA #0 
 STA VIC+&21 \Background Col 0
 LDA #&3B 
 STA VIC+&11 
 LDA #&C0 
 STA VIC+&16 \Set HIRES
 LDA #0 
 STA VIC+&15 \Disable Sprites
 LDA #9 
 STA VIC+&29 
 LDA #12 
 STA VIC+&2A 
 LDA #6 
 STA VIC+&2B 
 LDA #1 
 STA VIC+&2C 
 LDA #5 
 STA VIC+&2D 
 LDA #9 
 STA VIC+&2E \Sprite Cols
 LDA #8 
 STA VIC+&25 
 LDA #7 
 STA VIC+&26 \Sprite Multicol Regs
 LDA #0 
 STA VIC+&1C \Sprites Hires
 LDA #&FF 
 STA VIC+&17 
 STA VIC+&1D \Expand Sprites
 LDA #0 
 STA VIC+&10 \Sprites X Coord high bits
 LDX #&A1 
 LDY #&65 
 STX VIC+0 
 STY VIC+1 
 LDA #18 
 LDY #12 
 STA VIC+2 
 STY VIC+3 
 ASL A 
 STA VIC+4 
 STY VIC+5 
 ASL A 
 STA VIC+6 
 STY VIC+7 
 ASL A 
 STA VIC+8 
 STY VIC+9
 LDA #14 
 STA VIC+10 
 STY VIC+11 
 ASL A 
 STA VIC+12 
 STY VIC+13 
 ASL A 
 STA VIC+14 
 STY VIC+15 \Sprite coords
 LDA #2 
 STA VIC+&1B \Sprite Priority
 \.. .Screen Mems....
 LDA #0 
 STA ZP 
 TAY  
 LDX #&40 

.LOOP2

 STX ZP+1 

.LOOP1

 STA (ZP),Y 
 INY  
 BNE LOOP1 
 LDX ZP+1 
 INX  
 CPX #&60 
 BNE LOOP2 \Bit map region
 LDA #&10 

.LOOP3

 STX ZP+1 

.LOOP4

 STA (ZP),Y 
 INY  
 BNE LOOP4 
 LDX ZP+1 
 INX  
 CPX #&68 
 BNE LOOP3 \Screen Mem for upper screen
 LDA #((SCBASE+&2400+&2D0)MOD256) 
 STA ZP 
 LDA #((SCBASE+&2400+&2D0)DIV256) 
 STA ZP+1 
 LDA #(sdump MOD256) 
 STA ZP2 
 LDA #(sdump DIV256) 
 JSR mvsm
 \LD X#0LOOP20 LDAdate,X\STASCBASE+&7A0,X\DEX\BNELOOP20
 LDA #0 
 STA ZP 
 LDA #&60 
 STA ZP+1 
 LDX #25

.LOOP10

 LDA #&70 
 LDY #36 
 STA (ZP),Y 
 LDY #3 
 STA (ZP),Y 
 DEY  
 LDA #0 

.frogl

 STA (ZP),Y 
 DEY  
 BPL frogl 
 LDY #37 
 STA (ZP),Y 
 INY  
 STA (ZP),Y 
 INY  
 STA (ZP),Y 
 LDA ZP 
 CLC  
 ADC #40 
 STA ZP 
 BCC P%+4 
 INC ZP+1 
 DEX  
 BNE LOOP10
 LDA #0 
 STA ZP 
 LDA #&64 
 STA ZP+1 
 LDX #18

.LOOP11

 LDA #&70 
 LDY #36 
 STA (ZP),Y 
 LDY #3 
 STA (ZP),Y 
 DEY  
 LDA #0 

.newtl

 STA (ZP),Y 
 DEY  
 BPL newtl 
 LDY #37 
 STA (ZP),Y 
 INY  
 STA (ZP),Y 
 INY  
 STA (ZP),Y 
 LDA ZP 
 CLC  
 ADC #40 
 STA ZP 
 BCC P%+4 
 INC ZP+1 
 DEX  
 BNE LOOP11
 LDA #&70 
 LDY #31 

.LOOP16

 STA &63C4,Y 
 DEY  
 BPL LOOP16 \Bottom Row Yellow
 LDA #0 
 STA ZP 
 TAY  
 LDX #(COLMEM DIV256) 
 STX ZP+1 
 LDX #4 

.LOOP19

 STA (ZP),Y 
 INY  
 BNE LOOP19 
 INC ZP+1 
 DEX  
 BNE LOOP19
 LDA #((COLMEM+&2D0)MOD256) 
 STA ZP 
 LDA #((COLMEM+&2D0)DIV256) 
 STA ZP+1 
 LDA #(cdump MOD256) 
 STA ZP2 
 LDA #(cdump DIV256) 
 JSR mvsm
 LDY #34 
 LDA #7 

.LOOP15

 STA COLMEM+2,Y 
 DEY  
 BNE LOOP15
 LDA #&C4 
 STA &63F8 
 STA &67F8 
 LDA #&C8 
 STA &63F9 
 STA &67F9 
 LDA #&C9 
 STA &63FA 
 STA &67FA 
 STA &63FC 
 STA &67FC 
 STA &63FE 
 STA &67FE 
 LDA #&CA 
 STA &63FB 
 STA &67FB 
 STA &63FD 
 STA &67FD 
 STA &63FF 
 STA &67FF \Sprite Pointers
 LDA L1 
 AND #&F8 
 ORA #6 
 STA L1 \hiram=1, loram=0  (page KERNAL etc)
 CLI 
 LDX #9 
 LDA #(DSTORE%MOD256) 
 STA ZP 
 LDA #(DSTORE%DIV256) 
 STA ZP+1 
 LDA #(DIALS MOD256) 
 STA ZP2 
 LDA #(DIALS  DIV256) 
 JSR mvblock
 LDY #0 

.LOOP12

 LDA spritp,Y 
 STA SPRITELOC%,Y 
 DEY  
 BNE LOOP12

.LOOP13

 LDA spritp+&100,Y 
 STA SPRITELOC%+&100,Y 
 DEY  
 BNE LOOP13
 JMP &CE0E

.mvblock

 STA ZP2+1 
 LDY #0 

.LOOP5

 LDA (ZP2),Y 
 STA (ZP),Y 
 DEY  
 BNE LOOP5 
 INC ZP2+1 
 INC ZP+1 
 DEX  
 BNE LOOP5 
 RTS 

.mvsm LDX#1 

 JSR mvblock 
 LDY #&17 
 LDX #1 

\was JMPLOOP5 

.LOOP5new

 LDA (ZP2),Y 
 STA (ZP),Y 
 DEY  
 BPL LOOP5new 
 LDX #0 
 RTS  \<<

.sdump

 EQUB &00, &00, &00, &07, &17, &17, &74, &74
 EQUB &74, &74, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &67, &27, &27, &27
 EQUB &27, &27, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &17, &17, &24, &24
 EQUB &24, &24, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &67, &67, &67, &67, &23, &23
 EQUB &23, &23, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &29, &29
 EQUB &29, &29, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &67, &27, &23, &23
 EQUB &23, &23, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &28, &28
 EQUB &28, &28, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &2A, &2A
 EQUB &2A, &2A, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &2D, &2D
 EQUB &2D, &2D, &27, &07, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &07, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &C7, &C7, &07, &07
 EQUB &07, &07, &27, &07, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &07, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00

IF _GMA85 OR _SOURCE_DISC_BUILD

 EQUB &B4, &48, &9F, &CD, &EA, &11, &F1, &19

ELIF _SOURCE_DISC_FILES

 EQUB &99, &02, &E5, &6B, &26, &B9, &37, &D7

ENDIF

.cdump

 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &0F, &0F, &07, &07
 EQUB &07, &07, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &03, &03, &03, &03, &03, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &07, &07
 EQUB &07, &07, &05, &05, &00, &00, &00, &00

IF _GMA85 OR _SOURCE_DISC_BUILD

 EQUB &B3, &56, &2B, &6B, &74, &D4, &D8, &FF

ELIF _SOURCE_DISC_FILES

 EQUB &00, &FB, &0E, &F3, &79, &7D, &48, &96

ENDIF

.spritp

IF _GMA85 OR _SOURCE_DISC_BUILD

 INCBIN "versions/c64/1-source-files/images/source-disc-build/C.SPRITE.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/images/source-disc-files/C.SPRITE.bin"

ENDIF

IF _GMA85 OR _SOURCE_DISC_BUILD

 EQUB &97, &F3, &4F, &73, &B6, &DB, &39, &7A
 EQUB &56, &EE, &F5, &D3, &4F, &E4, &C4, &F5
 EQUB &FE, &05, &D3, &4F, &68, &91, &3E, &F9
 EQUB &00, &D3, &4F, &27, &53, &41, &F6, &FD
 EQUB &D6, &26, &CB, &24, &C5, &ED, &14, &3C
 EQUB &E9, &F0, &D3, &4F, &62, &8E, &41, &F1
 EQUB &F8, &D3, &4F, &30, &5F, &44, &05, &0C
 EQUB &D3, &4F, &68, &99, &A1, &CB, &B7, &34

ELIF _SOURCE_DISC_FILES

 EQUB &DC, &80, &1F, &87, &29, &80, &80, &E3
 EQUB &8A, &42, &CE, &41, &9D, &20, &CB, &DC
 EQUB &44, &E3, &C8, &22, &33, &A8, &B9, &F3
 EQUB &03, &D8, &22, &B7, &F9, &CF, &37, &F9
 EQUB &D3, &22, &76, &7A, &94, &37, &F3, &D3
 EQUB &FC, &F1, &EF, &E9, &B2, &01, &50, &25
 EQUB &D9, &C3, &22, &B1, &F0, &CF, &32, &E9
 EQUB &CB, &22, &7F, &8F, &A3, &49, &11, &48

ENDIF

.date

IF _GMA85 OR _SOURCE_DISC_BUILD

 INCBIN "versions/c64/1-source-files/images/source-disc-build/C.DATE4.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/images/source-disc-files/C.DATE4.bin"

ENDIF

.DIALS

 SKIP &18

IF _GMA85 OR _SOURCE_DISC_BUILD

 INCBIN "versions/c64/1-source-files/images/source-disc-build/C.CODIALS.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/images/source-disc-files/C.CODIALS.bin"

ENDIF

IF _GMA85 OR _SOURCE_DISC_BUILD

 EQUB &B2

ELIF _SOURCE_DISC_FILES

 EQUB &DB

ENDIF

.V%

.end

\ ******************************************************************************
\
\ Save COMLOD.unprot.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.COMLOD ", ~LOAD%, ~P%, " ", ~LOAD%, ~LOAD%
 SAVE "versions/c64/3-assembled-output/COMLOD.unprot.bin", CODE%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "U% = ", ~U%
 PRINT "V% = ", ~V%
 PRINT "W% = ", ~W%
 PRINT "X% = ", ~X%