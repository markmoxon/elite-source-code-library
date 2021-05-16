INCLUDE "versions/elite-a/sources/elite-header.h.asm"

_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

 \ a.dcode - ELITE III in-flight code

INCLUDE "versions/elite-a/sources/a.global.asm"

CODE% = &11E3
ORG CODE%
LOAD% = &11E3
EXEC% = &11E3


.dcode_in

 JMP start

.boot_in

 JMP start

.wrch_in

 JMP wrchdst
 EQUW &114B

.brk_in

 JMP brkdst

\ a.dcode_1

.l_11f1

 LDX #LO(l_11f8)
 LDY #HI(l_11f8)
 JSR oscli

.l_11f8

 EQUS "L.1.D", &0D

.run_tcode

 LDA #'R'
 STA l_11f8

.l_1220

 JSR l_3ee1
 \	JMP l_11f1
 BMI l_11f1

.l_1228

 LDA &0900
 STA &00
 LDX adval_x
 CPX new_max
 BCC n_highx
 LDX new_max

.n_highx

 CPX new_min
 BCS n_lowx
 LDX new_min

.n_lowx

 JSR l_29ff
 JSR l_29ff
 TXA
 EOR #&80
 TAY
 AND #&80
 STA &32
 STX adval_x
 EOR #&80
 STA &33
 TYA
 BPL l_124d
 EOR #&FF
 CLC
 ADC #&01

.l_124d

 LSR A
 LSR A
 CMP #&08
 BCS l_1254
 LSR A

.l_1254

 STA &31
 ORA &32
 STA &8D
 LDX adval_y
 CPX new_max
 BCC n_highy
 LDX new_max

.n_highy

 CPX new_min
 BCS n_lowy
 LDX new_min

.n_lowy

 JSR l_29ff
 TXA
 EOR #&80
 TAY
 AND #&80
 STX adval_y
 STA &7C
 EOR #&80
 STA &7B
 TYA
 BPL l_1274
 EOR #&FF

.l_1274

 ADC #&04
 LSR A
 LSR A
 LSR A
 LSR A
 CMP #&03
 BCS l_127f
 LSR A

.l_127f

 STA &2B
 ORA &7B
 STA &2A
 \	LDA b_flag
 \	BEQ l_129e
 \	LDX #&03
 \	LDA #&80
 \	JSR osbyte
 \	TYA
 \	LSR A
 \	LSR A
 \	CMP new_speed
 \	BCC l_129a
 \	LDA new_speed
 \l_129a
 \	STA &7D
 \	BNE l_12b6
 \l_129e
 LDA &0302
 BEQ l_12ab
 LDA &7D
 CMP new_speed
 BCC speed_up
 \	BCS l_12ab
 \	INC &7D

.l_12ab

 LDA &0301
 BEQ l_12b6
 DEC &7D
 BNE l_12b6

.speed_up

 INC &7D

.l_12b6

 LDA &030B
 AND cmdr_misl
 BEQ l_12cd
 LDY #&EE
 JSR l_3805
 JSR l_439f
 LDA #&00
 STA target

.l_12cd

 LDA &45
 BPL l_12e3
 LDA &030A
 BEQ l_12e3
 LDX cmdr_misl
 BEQ l_12e3
 STA target
 LDY #&E0
 DEX
 JSR l_383d

.l_12e3

 LDA &030C
 BEQ l_12ef
 LDA &45
 BMI l_1326
 JSR l_252e

.l_12ef

 LDA &0308
 AND cmdr_bomb
 BEQ l_12f7
 \	LDA #&03
 \	JSR l_54c8
 \	JSR l_2623
 \	JSR l_3ee1
 \	STY &0341
 INC cmdr_bomb
 INC new_hold	\***
 \	JSR l_32c1
 JSR l_3f86
 STA data_homex	\cmdr_homex
 STX data_homey	\cmdr_homey
 JSR l_2f75
 JSR hyper_snap

.l_12f7

 LDA &030F
 AND cmdr_dock
 BNE dock_toggle
 \	BEQ l_1331
 \	STA &033F
 \l_1331
 LDA &0310
 BEQ l_1301
 LDA #&00

.dock_toggle

 STA &033F

.l_1301

 LDA &0309
 AND cmdr_escape
 BEQ l_130c
 JMP l_20c1

.l_130c

 LDA &030E
 BEQ l_1314
 JSR l_434e

.l_1314

 LDA &030D
 AND cmdr_ecm
 BEQ l_1326
 LDA &30
 BNE l_1326
 DEC &0340
 JSR l_3813

.l_1326

 LDA #&00
 STA &44
 STA &7E
 LDA &7D
 LSR A
 ROR &7E
 LSR A
 ROR &7E
 STA &7F
 LDA &0346
 BNE l_1374
 LDA &0307
 BEQ l_1374
 LDA laser_t
 CMP #&F2
 BCS l_1374
 LDX view_dirn
 LDA cmdr_laser,X
 BEQ l_1374
 PHA
 AND #&7F
 STA &0343
 STA &44
 LDA #&00
 JSR l_43f3
 JSR l_2a82
 PLA
 BPL l_136f
 LDA #&00

.l_136f

 STA &0346

.l_1374

 LDX #&00

.l_1376

 STX &84
 LDA ship_type,X
 BNE ins_ship
 JMP l_153f

.ins_ship

 STA &8C
 JSR ship_ptr
 LDY #&24

.l_1387

 LDA (&20),Y
 STA &46,Y
 DEY
 BPL l_1387
 LDA &8C
 BMI l_13b6
 ASL A
 TAY
 LDA &55FE,Y
 STA &1E
 LDA &55FF,Y
 STA &1F

.l_13b6

 JSR l_50a0
 LDY #&24

.l_13bb

 LDA &46,Y
 STA (&20),Y
 DEY
 BPL l_13bb
 LDA &65
 AND #&A0
 JSR l_41bf
 BNE l_141d
 LDA &46
 ORA &49
 ORA &4C
 BMI l_141d
 LDX &8C
 BMI l_141d
 CPX #&02
 BEQ l_1420
 AND #&C0
 BNE l_141d
 CPX #&01
 BEQ l_141d
 LDA cmdr_scoop
 AND &4B
 BPL l_1464
 CPX #&05
 BEQ l_13fd
 LDY #&00
 LDA (&1E),Y
 LSR A
 LSR A
 LSR A
 LSR A
 BEQ l_1464
 ADC #&01
 BNE l_1402

.l_13fd

 JSR l_3f86
 \	AND #&07
 AND #&0F

.l_1402

 TAX
 JSR l_2aec
 BCS l_1464
 INC cmdr_cargo,X
 TXA
 ADC #&D0
 JSR l_45c6
 JSR top_6a

.l_141d

 JMP l_1473

.l_1420

 LDA &0949
 AND #&04
 BNE l_1449
 LDA &54
 CMP #&D6
 BCC l_1449
 LDY #&25
 JSR l_42ae
 LDA &36
 CMP #&56
 BCC l_1449
 LDA &56
 AND #&7F
 CMP #&50
 BCC l_1449

.l_143e

 JSR l_3ee1
 LDA #&08
 JSR l_263d
 JMP run_tcode
 \l_1452
 \	JSR l_43b1
 \	JSR l_2160
 \	BNE l_1473

.l_1449

 LDA &7D
 CMP #&05
 BCS n_crunch
 LDA &033F
 AND #&04
 EOR #&05
 \	LDA #&04
 BNE l_146d

.l_1464

 LDA #&40
 JSR n_hit
 JSR anger_8c

.n_crunch

 LDA #&80

.l_146d

 JSR n_through
 JSR l_43b1

.l_1473

 LDA &6A
 BPL l_147a
 JSR l_5558

.l_147a

 LDA &87
 BNE l_14f0
 LDX view_dirn
 BEQ l_1486
 JSR l_5404

.l_1486

 JSR l_24c7
 BCC l_14ed
 LDA target
 BEQ l_149a
 JSR l_43ba
 LDX &84
 LDY #&0E
 JSR l_3807

.l_149a

 LDA &44
 BEQ l_14ed
 LDX #&0F
 JSR l_43dd
 LDA &44
 LDY &8C
 CPY #&02
 BEQ l_14e8
 CPY #&1F
 BNE l_14b7
 LSR A

.l_14b7

 LSR A
 JSR n_hit	\ hit enemy
 BCS l_14e6
 LDA &8C
 CMP #&07
 BNE l_14d9
 LDA &44
 CMP new_mining
 BNE l_14d9
 JSR l_3f86
 LDX #&08
 AND #&03
 JSR l_1687

.l_14d9

 LDY #&04
 JSR l_1678
 LDY #&05
 JSR l_1678
 JSR l_43ce

.l_14e6


.l_14e8

 JSR anger_8c

.l_14ed

 JSR l_488c

.l_14f0

 LDY #&23
 LDA &69
 STA (&20),Y
 LDA &6A
 BMI l_1527
 LDA &65
 BPL l_152a
 AND #&20
 BEQ l_152a
 \	AND &6A	\ A=&20
 \	BEQ n_trader
 \	INC cmdr_legal
 \	BNE n_trader
 \	DEC cmdr_legal
 \n_trader
 \	LDA &6A
 \	AND #&40
 \	ORA cmdr_legal
 \	STA cmdr_legal
 BIT &6A	\ A=&20
 BVS n_badboy
 BEQ n_goodboy
 LDA #&80

.n_badboy

 ASL A
 ROL A

.n_bitlegal

 LSR A
 BIT cmdr_legal
 BNE n_bitlegal
 ADC cmdr_legal
 BCS l_1527
 STA cmdr_legal
 BCC l_1527

.n_goodboy

 LDA &034A
 ORA &0341
 BNE l_1527
 \	LDA &6A
 \	AND #&60
 \	BNE l_1527
 LDY #&0A
 LDA (&1E),Y
 \	BEQ l_1527
 TAX
 INY
 LDA (&1E),Y
 TAY
 JSR l_32d0
 LDA #&00
 JSR l_45c6

.l_1527

 JMP l_3d7f

.n_hit

 \ hit opponent
 STA &D1
 SEC
 LDY #&0E	\ opponent shield
 LDA (&1E),Y
 AND #&07
 SBC &D1
 BCS n_kill
 \	BCC n_defense
 \	LDA #&FF
 \n_defense
 CLC
 ADC &69
 STA &69
 BCS n_kill
 JSR l_2160

.n_kill

 \ C clear if dead
 RTS

.l_152a

 LDA &8C
 BMI l_1533
 JSR l_41b2
 BCC l_1527

.l_1533

 LDY #&1F
 LDA &65
 STA (&20),Y
 LDX &84
 INX
 JMP l_1376

.l_153f

 LDA &8A
 AND #&07
 BNE l_15c2
 LDX energy
 BPL l_156c
 LDX r_shield
 JSR l_3626
 STX r_shield
 LDX f_shield
 JSR l_3626
 STX f_shield

.l_156c

 SEC
 LDA cmdr_eunit
 ADC energy
 BCS l_1578
 STA energy

.l_1578

 LDA &0341
 BNE l_15bf
 LDA &8A
 AND #&1F
 BNE l_15cb
 LDA &0320
 BNE l_15bf
 TAY
 JSR l_1c43
 BNE l_15bf
 LDX #&1C

.l_1590

 LDA &0900,X
 STA &46,X
 DEX
 BPL l_1590
 INX
 LDY #&09
 JSR l_1c20
 BNE l_15bf
 LDX #&03
 LDY #&0B
 JSR l_1c20
 BNE l_15bf
 LDX #&06
 LDY #&0D
 JSR l_1c20
 BNE l_15bf
 LDA #&C0
 JSR l_41b4
 BCC l_15bf
 JSR l_3c30
 JSR l_3740

.l_15bf

 JMP l_1648

.l_15c2

 LDA &0341
 BNE l_15bf
 LDA &8A
 AND #&1F

.l_15cb

 CMP #&0A
 BNE l_15fd
 LDA #&32
 CMP energy
 BCC l_15da
 ASL A
 JSR l_45c6

.l_15da

 LDY #&FF
 STY altitude
 INY
 JSR l_1c41
 BNE l_1648
 JSR l_1c4f
 BCS l_1648
 SBC #&24
 BCC l_15fa
 STA &82
 JSR l_47b8
 LDA &81
 STA altitude
 BNE l_1648

.l_15fa

 JMP l_41c6

.l_15fd

 CMP #&0F
 BNE l_160a
 LDA &033F
 BEQ l_1648
 LDA #&7B
 BNE l_1645

.l_160a

 CMP #&14
 BNE l_1648
 LDA #&1E
 STA cabin_t
 LDA &0320
 BNE l_1648
 LDY #&25
 JSR l_1c43
 BNE l_1648
 JSR l_1c4f
 EOR #&FF
 ADC #&1E
 STA cabin_t
 BCS l_15fa
 CMP #&E0
 BCC l_1648
 LDA cmdr_scoop
 BEQ l_1648
 LDA &7F
 LSR A
 ADC cmdr_fuel
 CMP new_range
 BCC l_1640
 LDA new_range

.l_1640

 STA cmdr_fuel
 LDA #&A0

.l_1645

 JSR l_45c6

.l_1648

 LDA &0343
 BEQ l_165c
 LDA &0346
 CMP #&08
 BCS l_165c
 JSR l_2aa1
 LDA #&00
 STA &0343

.l_165c

 LDA &0340
 BEQ l_1666
 JSR l_3629
 BEQ l_166e

.l_1666

 LDA &30
 BEQ l_1671
 DEC &30
 BNE l_1671

.l_166e

 JSR l_43a3

.l_1671

 LDA &87
 BNE l_1694
 JMP l_1a25

.l_1678

 JSR l_3f86
 BPL l_1694
 PHA
 TYA
 TAX
 PLA
 LDY #&00
 AND (&1E),Y
 AND #&0F

.l_1687

 STA &93
 BEQ l_1694

.l_168b

 LDA #&00
 JSR l_2592
 DEC &93
 BNE l_168b

.l_1694

 RTS

.l_1695

 EQUW &0900, &0925, &094A, &096F, &0994, &09B9, &09DE, &0A03
 EQUW &0A28, &0A4D, &0A72, &0A97, &0ABC

.pixels

 EQUB &80, &40, &20, &10, &08, &04, &02, &01, &C0, &60, &30, &18
 EQUB &0C, &06, &03, &03, &88, &44, &22, &11, &88

.l_16c4

 STY &85
 LDA #&80
 STA &83
 ASL A
 STA &90
 LDA &36
 SBC &34
 BCS l_16d8
 EOR #&FF
 ADC #&01
 SEC

.l_16d8

 STA &1B
 LDA &37
 SBC &35
 BCS l_16e4
 EOR #&FF
 ADC #&01

.l_16e4

 STA &81
 CMP &1B
 BCC l_16ed
 JMP l_1797

.l_16ed

 LDX &34
 CPX &36
 BCC l_1704
 DEC &90
 LDA &36
 STA &34
 STX &36
 TAX
 LDA &37
 LDY &35
 STA &35
 STY &37

.l_1704

 LDA &35
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA ptr+&01
 LDA &35
 AND #&07
 TAY
 TXA
 AND #&F8
 STA ptr
 TXA
 AND #&07
 TAX
 LDA pixels,X
 STA &82
 LDA &81
 LDX #&FE
 STX &81

.l_1726

 ASL A
 BCS l_172d
 CMP &1B
 BCC l_1730

.l_172d

 SBC &1B
 SEC

.l_1730

 ROL &81
 BCS l_1726
 LDX &1B
 INX
 LDA &37
 SBC &35
 BCS l_1769
 LDA &90
 BNE l_1748
 DEX

.l_1742

 LDA &82
 EOR (ptr),Y
 STA (ptr),Y

.l_1748

 LSR &82
 BCC l_1754
 ROR &82
 LDA ptr
 ADC #&08
 STA ptr

.l_1754

 LDA &83
 ADC &81
 STA &83
 BCC l_1763
 DEY
 BPL l_1763
 DEC ptr+&01
 LDY #&07

.l_1763

 DEX
 BNE l_1742
 LDY &85
 RTS

.l_1769

 LDA &90
 BEQ l_1774
 DEX

.l_176e

 LDA &82
 EOR (ptr),Y
 STA (ptr),Y

.l_1774

 LSR &82
 BCC l_1780
 ROR &82
 LDA ptr
 ADC #&08
 STA ptr

.l_1780

 LDA &83
 ADC &81
 STA &83
 BCC l_1791
 INY
 CPY #&08
 BNE l_1791
 INC ptr+&01
 LDY #&00

.l_1791

 DEX
 BNE l_176e
 LDY &85
 RTS

.l_1797

 LDY &35
 TYA
 LDX &34
 CPY &37
 BCS l_17b0
 DEC &90
 LDA &36
 STA &34
 STX &36
 TAX
 LDA &37
 STA &35
 STY &37
 TAY

.l_17b0

 LSR A
 LSR A
 LSR A
 ORA #&60
 STA ptr+&01
 TXA
 AND #&F8
 STA ptr
 TXA
 AND #&07
 TAX
 LDA pixels,X
 STA &82
 LDA &35
 AND #&07
 TAY
 LDA &1B
 LDX #&01
 STX &1B

.l_17d0

 ASL A
 BCS l_17d7
 CMP &81
 BCC l_17da

.l_17d7

 SBC &81
 SEC

.l_17da

 ROL &1B
 BCC l_17d0
 LDX &81
 INX
 LDA &36
 SBC &34
 BCC l_1814
 CLC
 LDA &90
 BEQ l_17f3
 DEX

.l_17ed

 LDA &82
 EOR (ptr),Y
 STA (ptr),Y

.l_17f3

 DEY
 BPL l_17fa
 DEC ptr+&01
 LDY #&07

.l_17fa

 LDA &83
 ADC &1B
 STA &83
 BCC l_180e
 LSR &82
 BCC l_180e
 ROR &82
 LDA ptr
 ADC #&08
 STA ptr

.l_180e

 DEX
 BNE l_17ed
 LDY &85
 RTS

.l_1814

 LDA &90
 BEQ l_181f
 DEX

.l_1819

 LDA &82
 EOR (ptr),Y
 STA (ptr),Y

.l_181f

 DEY
 BPL l_1826
 DEC ptr+&01
 LDY #&07

.l_1826

 LDA &83
 ADC &1B
 STA &83
 BCC l_183b
 ASL &82
 BCC l_183b
 ROL &82
 LDA ptr
 SBC #&07
 STA ptr
 CLC

.l_183b

 DEX
 BNE l_1819
 LDY &85

.l_1840

 RTS

.l_1847

 JSR l_339a

.l_184a

 LDA #&13
 BNE l_1852

.l_184e

 LDA #&17
 INC cursor_y

.l_1852

 STA &35
 LDX #&02
 STX &34
 LDX #&FE
 STX &36
 BNE l_1868

.l_185e

 JSR l_3c4f
 STY &35
 LDA #&00
 STA &0E00,Y

.l_1868

 STY &85
 LDX &34
 CPX &36
 BEQ l_1840
 BCC l_1879
 LDA &36
 STA &34
 STX &36
 TAX

.l_1879

 DEC &36
 LDA &35
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA ptr+&01
 LDA &35
 AND #&07
 STA ptr
 TXA
 AND #&F8
 TAY
 TXA
 AND #&F8
 STA &D1
 LDA &36
 AND #&F8
 SEC
 SBC &D1
 BEQ l_18d3
 LSR A
 LSR A
 LSR A
 STA &82
 LDA &34
 AND #&07
 TAX
 LDA l_18ee+&07,X
 EOR (ptr),Y
 STA (ptr),Y
 TYA
 ADC #&08
 TAY
 LDX &82
 DEX
 BEQ l_18c4
 CLC

.l_18b7

 LDA #&FF
 EOR (ptr),Y
 STA (ptr),Y
 TYA
 ADC #&08
 TAY
 DEX
 BNE l_18b7

.l_18c4

 LDA &36
 AND #&07
 TAX
 LDA l_18ee,X
 EOR (ptr),Y
 STA (ptr),Y
 LDY &85
 RTS

.l_18d3

 LDA &34
 AND #&07
 TAX
 LDA l_18ee+&07,X
 STA &D1
 LDA &36
 AND #&07
 TAX
 LDA l_18ee,X
 AND &D1
 EOR (ptr),Y
 STA (ptr),Y
 LDY &85
 RTS

.l_18ee

 EQUB &80, &C0, &E0, &F0, &F8, &FC, &FE, &FF, &7F, &3F, &1F, &0F
 EQUB &07, &03, &01
 \l_18fd
 \	LDA pixels,X
 \	EOR (ptr),Y
 \	STA (ptr),Y
 \	LDY &06
 \	RTS

.l_1907

 JSR l_28ff
 STA &27
 TXA
 STA &0F95,Y

.l_1910

 LDA &34
 BPL l_1919
 EOR #&7F
 CLC
 ADC #&01

.l_1919

 EOR #&80
 TAX
 LDA &35
 AND #&7F
 CMP #&60
 BCS l_196a
 LDA &35
 BPL l_192c
 EOR #&7F
 ADC #&01

.l_192c

 STA &D1
 LDA #&61
 SBC &D1

.l_1932

 STY &06
 TAY
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA ptr+&01
 TXA
 AND #&F8
 STA ptr
 TYA
 AND #&07
 TAY
 TXA
 AND #&07
 TAX
 LDA &88
 CMP #&90
 \	BCS l_18fd
 BCC thick_dot
 LDA pixels,X
 BCS plot_dot

.thick_dot

 LDA pixels+&08,X
 EOR (ptr),Y
 STA (ptr),Y
 LDA &88
 CMP #&50
 BCS l_1968
 DEY
 BPL l_1961
 LDY #&01

.l_1961

 LDA pixels+&08,X

.plot_dot

 EOR (ptr),Y
 STA (ptr),Y

.l_1968

 LDY &06

.l_196a

 RTS

.l_196b

 TXA
 ADC &E0
 STA &78
 LDA &E1
 ADC &D1
 STA &79
 LDA &92
 BEQ l_198c
 INC &92

.l_197c

 LDY &6B
 LDA #&FF
 CMP &0F0D,Y
 BEQ l_19ed
 STA &0F0E,Y
 INC &6B
 BNE l_19ed

.l_198c

 LDA vdu_stat
 STA &34
 LDA &73
 STA &35
 LDA &74
 STA &36
 LDA &75
 STA &37
 LDA &76
 STA &38
 LDA &77
 STA &39
 LDA &78
 STA &3A
 LDA &79
 STA &3B
 JSR l_4e19
 BCS l_197c
 LDA &90
 BEQ l_19c5
 LDA &34
 LDY &36
 STA &36
 STY &34
 LDA &35
 LDY &37
 STA &37
 STY &35

.l_19c5

 LDY &6B
 LDA &0F0D,Y
 CMP #&FF
 BNE l_19d9
 LDA &34
 STA &0EC0,Y
 LDA &35
 STA &0F0E,Y
 INY

.l_19d9

 LDA &36
 STA &0EC0,Y
 LDA &37
 STA &0F0E,Y
 INY
 STY &6B
 JSR l_16c4
 LDA &89
 BNE l_197c

.l_19ed

 LDA &76
 STA vdu_stat
 LDA &77
 STA &73
 LDA &78
 STA &74
 LDA &79
 STA &75
 LDA &93
 CLC
 ADC &95
 STA &93
 RTS

.l_1a05

 LDY &03C3

.l_1a08

 LDX &0F82,Y
 LDA &0F5C,Y
 STA &35
 STA &0F82,Y
 TXA
 STA &34
 STA &0F5C,Y
 LDA &0FA8,Y
 STA &88
 JSR l_1910
 DEY
 BNE l_1a08
 RTS

.l_1a25

 LDX view_dirn
 BEQ l_1a33
 DEX
 BNE l_1a30
 JMP l_1b20

.l_1a30

 JMP l_2679

.l_1a33

 LDY &03C3

.l_1a36

 JSR l_295e
 LDA &82
 LSR &1B
 ROR A
 LSR &1B
 ROR A
 ORA #&01
 STA &81
 LDA &0FBB,Y
 SBC &7E
 STA &0FBB,Y
 LDA &0FA8,Y
 STA &88
 SBC &7F
 STA &0FA8,Y
 JSR l_2817
 STA &27
 LDA &1B
 ADC &0F95,Y
 STA &26
 STA &82
 LDA &35
 ADC &27
 STA &27
 STA &83
 LDA &0F5C,Y
 STA &34
 JSR l_281c
 STA &25
 LDA &1B
 ADC &0F6F,Y
 STA &24
 LDA &34
 ADC &25
 STA &25
 EOR &33
 JSR l_27c6
 JSR l_28ff
 STA &27
 STX &26
 EOR &32
 JSR l_27be
 JSR l_28ff
 STA &25
 STX &24
 LDX &2B
 LDA &27
 EOR &7C
 JSR l_27c8
 STA &81
 JSR l_289e
 ASL &1B
 ROL A
 STA &D1
 LDA #&00
 ROR A
 ORA &D1
 JSR l_28ff
 STA &25
 TXA
 STA &0F6F,Y
 LDA &26
 STA &82
 LDA &27
 STA &83
 LDA #&00
 STA &1B
 LDA &2A
 EOR #&80
 JSR l_1907
 LDA &25
 STA &34
 STA &0F5C,Y
 AND #&7F
 CMP #&78
 BCS l_1afd
 LDA &27
 STA &0F82,Y
 STA &35
 AND #&7F
 CMP #&78
 BCS l_1afd
 LDA &0FA8,Y
 CMP #&10
 BCC l_1afd
 STA &88

.l_1af3

 JSR l_1910
 DEY
 BEQ l_1afc
 JMP l_1a36

.l_1afc

 RTS

.l_1afd

 JSR l_3f86
 ORA #&04
 STA &35
 STA &0F82,Y
 JSR l_3f86
 ORA #&08
 STA &34
 STA &0F5C,Y
 JSR l_3f86
 ORA #&90
 STA &0FA8,Y
 STA &88
 LDA &35
 JMP l_1af3

.l_1b20

 LDY &03C3

.l_1b23

 JSR l_295e
 LDA &82
 LSR &1B
 ROR A
 LSR &1B
 ROR A
 ORA #&01
 STA &81
 LDA &0F5C,Y
 STA &34
 JSR l_281c
 STA &25
 LDA &0F6F,Y
 SBC &1B
 STA &24
 LDA &34
 SBC &25
 STA &25
 JSR l_2817
 STA &27
 LDA &0F95,Y
 SBC &1B
 STA &26
 STA &82
 LDA &35
 SBC &27
 STA &27
 STA &83
 LDA &0FBB,Y
 ADC &7E
 STA &0FBB,Y
 LDA &0FA8,Y
 STA &88
 ADC &7F
 STA &0FA8,Y
 LDA &25
 EOR &32
 JSR l_27c6
 JSR l_28ff
 STA &27
 STX &26
 EOR &33
 JSR l_27be
 JSR l_28ff
 STA &25
 STX &24
 LDA &27
 EOR &7C
 LDX &2B
 JSR l_27c8
 STA &81
 LDA &25
 STA &83
 EOR #&80
 JSR l_28a2
 ASL &1B
 ROL A
 STA &D1
 LDA #&00
 ROR A
 ORA &D1
 JSR l_28ff
 STA &25
 TXA
 STA &0F6F,Y
 LDA &26
 STA &82
 LDA &27
 STA &83
 LDA #&00
 STA &1B
 LDA &2A
 JSR l_1907
 LDA &25
 STA &34
 STA &0F5C,Y
 LDA &27
 STA &0F82,Y
 STA &35
 AND #&7F
 CMP #&6E
 BCS l_1bea
 LDA &0FA8,Y
 CMP #&A0
 BCS l_1bea
 STA &88

.l_1be0

 JSR l_1910
 DEY
 BEQ l_1be9
 JMP l_1b23

.l_1bea

 JSR l_3f86
 AND #&7F
 ADC #&0A
 STA &0FA8,Y
 STA &88
 LSR A
 BCS l_1c0d
 LSR A
 LDA #&FC
 ROR A
 STA &34
 STA &0F5C,Y
 JSR l_3f86
 STA &35
 STA &0F82,Y
 JMP l_1be0

.l_1c0d

 JSR l_3f86
 STA &34
 STA &0F5C,Y
 LSR A
 LDA #&E6
 ROR A
 STA &35
 STA &0F82,Y
 BNE l_1be0

.l_1c20

 LDA &46,Y
 ASL A
 STA &41
 LDA &47,Y
 ROL A
 STA &42
 LDA #&00
 ROR A
 STA &43
 JSR l_1d4c
 STA &48,X
 LDY &41
 STY &46,X
 LDY &42
 STY &47,X
 AND #&7F

.l_1be9

 RTS

.l_1c41

 LDA #&00

.l_1c43

 ORA &0902,Y
 ORA &0905,Y
 ORA &0908,Y
 AND #&7F
 RTS

.l_1c4f

 LDA &0901,Y
 JSR l_280d
 STA &82
 LDA &0904,Y
 JSR l_280d
 ADC &82
 BCS l_1c6d
 STA &82
 LDA &0907,Y
 JSR l_280d
 ADC &82
 BCC l_1c6f

.l_1c6d

 LDA #&FF

.l_1c6f

 RTS

.l_1c70

 LDX #&09
 CMP #&19
 BCS l_1ccf
 DEX
 CMP #&0A
 BCS l_1ccf
 DEX
 CMP #&02
 BCS l_1ccf
 DEX
 BNE l_1ccf

.l_1c83

 LDA #&08
 JSR l_54c8
 JSR l_2f75
 LDA #&07
 STA cursor_x
 LDA #&7E
 JSR l_1847
 LDA #&E6
 LDY &033E
 LDX ship_type+&02,Y
 BEQ l_1ca5
 LDY energy
 CPY #&80
 ADC #&01

.l_1ca5

 JSR l_338f
 LDA #&7D
 JSR l_2b6d
 LDA #&13
 LDY cmdr_legal
 BEQ l_1cb8
 CPY #&32
 ADC #&01

.l_1cb8

 JSR l_338f
 LDA #&10
 JSR l_2b6d
 LDA cmdr_kills+&01
 BNE l_1c70
 TAX
 LDA cmdr_kills
 LSR A
 LSR A

.l_1ccb

 INX
 LSR A
 BNE l_1ccb

.l_1ccf

 TXA
 CLC
 ADC #&15
 JSR l_338f
 LDA #&12
 JSR l_1d44
 LDA cmdr_hold
 BEQ l_1ce7
 LDA #&6B
 JSR l_1d44

.l_1ce7

 LDA cmdr_scoop
 BEQ l_1cf1
 LDA #&6F
 JSR l_1d44

.l_1cf1

 LDA cmdr_ecm
 BEQ l_1cfb
 LDA #&6C
 JSR l_1d44

.l_1cfb

 LDA #&71
 STA &96

.l_1cff

 TAY
 LDX ship_type,Y
 BEQ l_1d08
 JSR l_1d44

.l_1d08

 INC &96
 LDA &96
 CMP #&75
 BCC l_1cff
 LDX #&00

.l_1d12

 STX &93
 LDY cmdr_laser,X
 BEQ l_1d3c
 TXA
 ORA #&60
 JSR l_2b6d
 LDA #&67
 LDX &93
 LDY cmdr_laser,X
 CPY new_beam
 BNE l_1d2d
 LDA #&68

.l_1d2d

 CPY new_military
 BNE l_1d33
 LDA #&75

.l_1d33

 CPY new_mining
 BNE l_1d39
 LDA #&76

.l_1d39

 JSR l_1d44

.l_1d3c

 LDX &93
 INX
 CPX #&04
 BCC l_1d12
 RTS

.l_1d44

 JSR l_338f
 LDX #&08
 STX cursor_x
 RTS

.l_1d4c

 LDA &43
 STA &83
 AND #&80
 STA &D1
 EOR &48,X
 BMI l_1d70
 LDA &41
 CLC
 ADC &46,X
 STA &41
 LDA &42
 ADC &47,X
 STA &42
 LDA &43
 ADC &48,X
 AND #&7F
 ORA &D1
 STA &43
 RTS

.l_1d70

 LDA &83
 AND #&7F
 STA &83
 LDA &46,X
 SEC
 SBC &41
 STA &41
 LDA &47,X
 SBC &42
 STA &42
 LDA &48,X
 AND #&7F
 SBC &83
 ORA #&80
 EOR &D1
 STA &43
 BCS l_1da7
 LDA #&01
 SBC &41
 STA &41
 LDA #&00
 SBC &42
 STA &42
 LDA #&00
 SBC &43
 AND #&7F
 ORA &D1
 STA &43

.l_1da7

 RTS

.l_1da8

 LDA &47,X
 AND #&7F
 LSR A
 STA &D1
 LDA &46,X
 SEC
 SBC &D1
 STA &82
 LDA &47,X
 SBC #&00
 STA &83
 LDA &46,Y
 STA &1B
 LDA &47,Y
 AND #&80
 STA &D1
 LDA &47,Y
 AND #&7F
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 ORA &D1
 EOR &9A
 STX &81
 JSR l_28ff
 STA &41
 STX &40
 LDX &81
 LDA &47,Y
 AND #&7F
 LSR A
 STA &D1
 LDA &46,Y
 SEC
 SBC &D1
 STA &82
 LDA &47,Y
 SBC #&00
 STA &83
 LDA &46,X
 STA &1B
 LDA &47,X
 AND #&80
 STA &D1
 LDA &47,X
 AND #&7F
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 ORA &D1
 EOR #&80
 EOR &9A
 STX &81
 JSR l_28ff
 STA &47,Y
 STX &46,Y
 LDX &81
 LDA &40
 STA &46,X
 LDA &41
 STA &47,X
 RTS

.l_1e34

 EQUD &00E87648

.c_1e38

 CLC

.l_1e38

 LDA #&03

.l_1e3a

 LDY #&00

.l_1e3c

 STA &80
 LDA #&00
 STA &40
 STA &41
 STY &42
 STX &43

.l_1e48

 LDX #&0B
 STX &D1
 PHP
 BCC l_1e53
 DEC &D1
 DEC &80

.l_1e53

 LDA #&0B
 SEC
 STA &86
 SBC &80
 STA &80
 INC &80
 LDY #&00
 STY &83
 JMP l_1ea4

.l_1e65

 ASL &43
 ROL &42
 ROL &41
 ROL &40
 ROL &83
 LDX #&03

.l_1e71

 LDA &40,X
 STA &34,X
 DEX
 BPL l_1e71
 LDA &83
 STA &38
 ASL &43
 ROL &42
 ROL &41
 ROL &40
 ROL &83
 ASL &43
 ROL &42
 ROL &41
 ROL &40
 ROL &83
 CLC
 LDX #&03

.l_1e93

 LDA &40,X
 ADC &34,X
 STA &40,X
 DEX
 BPL l_1e93
 LDA &38
 ADC &83
 STA &83
 LDY #&00

.l_1ea4

 LDX #&03
 SEC

.l_1ea7

 LDA &40,X
 SBC l_1e34,X
 STA &34,X
 DEX
 BPL l_1ea7
 LDA &83
 SBC #&17
 STA &38
 BCC l_1eca
 LDX #&03

.l_1ebb

 LDA &34,X
 STA &40,X
 DEX
 BPL l_1ebb
 LDA &38
 STA &83
 INY
 JMP l_1ea4

.l_1eca

 TYA
 BNE l_1ed9
 LDA &D1
 BEQ l_1ed9
 DEC &80
 BPL l_1ee3
 LDA #&20
 BNE l_1ee0

.l_1ed9

 LDY #&00
 STY &D1
 CLC
 ADC #&30

.l_1ee0

 JSR wrchdst

.l_1ee3

 DEC &D1
 BPL l_1ee9
 INC &D1

.l_1ee9

 DEC &86
 BMI l_1f5b
 BNE l_1ef7
 PLP
 BCC l_1ef7
 LDA #&2E
 JSR wrchdst

.l_1ef7

 JMP l_1e65

.l_1efa

 LDA #&07

.wrchdst

 STA &D2
 STY &034F
 STX &034E
 LDY vdu_stat
 CPY #&FF
 BEQ l_1f52
 CMP #&07
 BEQ l_1f5c
 CMP #&20
 BCS l_1f1e
 CMP #&0A
 BEQ l_1f1a
 LDX #&01
 STX cursor_x

.l_1f1a

 INC cursor_y
 BNE l_1f52

.l_1f1e

 LDX #&BF
 ASL A
 ASL A
 BCC l_1f26
 LDX #&C1

.l_1f26

 ASL A
 BCC l_1f2a
 INX

.l_1f2a

 STA font
 STX font+&01
 LDA cursor_x
 ASL A
 ASL A
 ASL A
 STA ptr
 INC cursor_x
 LDA cursor_y
 CMP #&18
 BCC l_1f43
 JSR l_54c8
 JMP l_1f52

.l_1f43

 ORA #&60

.l_1f45

 STA ptr+&01
 LDY #&07

.l_1f49

 LDA (font),Y
 EOR (ptr),Y
 STA (ptr),Y
 DEY
 BPL l_1f49

.l_1f52

 LDY &034F
 LDX &034E
 LDA &D2
 CLC

.l_1f5b

 RTS

.l_1f5c

 JSR l_43ba
 JMP l_1f52

.l_1f62

 LDA #&D0
 STA ptr
 LDA #&78
 STA ptr+&01
 JSR l_2026
 STX &41
 STA &40
 LDA #&0E
 STA &06
 LDA &7D
 JSR l_2039
 LDA #&00
 STA &82
 STA &1B
 LDA #&08
 STA &83
 LDA &31
 LSR A
 LSR A
 ORA &32
 EOR #&80
 JSR l_28ff
 JSR l_208d
 LDA &2A
 LDX &2B
 BEQ l_1f9a
 SBC #&01

.l_1f9a

 JSR l_28ff
 JSR l_208d
 LDA &8A
 AND #&03
 BNE l_1f5b
 LDY #&00
 JSR l_2026
 STX &40
 STA &41
 LDX #&03
 STX &06

.l_1fb3

 STY &3A,X
 DEX
 BPL l_1fb3
 LDX #&03
 LDA energy
 LSR A
 LSR A
 STA &81

.l_1fc1

 SEC
 SBC #&10
 BCC l_1fd3
 STA &81
 LDA #&10
 STA &3A,X
 LDA &81
 DEX
 BPL l_1fc1
 BMI l_1fd7

.l_1fd3

 LDA &81
 STA &3A,X

.l_1fd7

 LDA &3A,Y
 STY &1B
 JSR l_203a
 LDY &1B
 INY
 CPY #&04
 BNE l_1fd7
 LDA #&78
 STA ptr+&01
 LDA #&10
 STA ptr
 LDA f_shield
 JSR l_2036
 LDA r_shield
 JSR l_2036
 LDA cmdr_fuel
 JSR l_2038
 JSR l_2026
 STX &41
 STA &40
 LDX #&0B
 STX &06
 LDA cabin_t
 JSR l_2036
 LDA laser_t
 JSR l_2036
 LDA #&F0
 STA &06
 STA &41
 LDA altitude
 JSR l_2036
 JMP l_3634

.l_2026

 LDX #&F0
 LDA &8A
 AND #&08
 AND f_flag
 BEQ l_2033
 TXA
 EQUB &2C

.l_2033

 LDA #&0F
 RTS

.l_2036

 LSR A
 LSR A

.l_2038

 LSR A

.l_2039

 LSR A

.l_203a

 STA &81
 LDX #&FF
 STX &82
 CMP &06
 BCS l_2048
 LDA &41
 BNE l_204a

.l_2048

 LDA &40

.l_204a

 STA &91
 LDY #&02
 LDX #&03

.l_2050

 LDA &81
 CMP #&04
 BCC l_2070
 SBC #&04
 STA &81
 LDA &82

.l_205c

 AND &91
 STA (ptr),Y
 INY
 STA (ptr),Y
 INY
 STA (ptr),Y
 TYA
 CLC
 ADC #&06
 TAY
 DEX
 BMI l_208a
 BPL l_2050

.l_2070

 EOR #&03
 STA &81
 LDA &82

.l_2076

 ASL A
 AND #&EF
 DEC &81
 BPL l_2076
 PHA
 LDA #&00
 STA &82
 LDA #&63
 STA &81
 PLA
 JMP l_205c

.l_208a

 INC ptr+&01
 RTS

.l_208d

 LDY #&01
 STA &81

.l_2091

 SEC
 LDA &81
 SBC #&04
 BCS l_20a6
 LDA #&FF
 LDX &81
 STA &81
 LDA pixels+&10,X
 AND #&F0
 JMP l_20aa

.l_20a6

 STA &81
 LDA #&00

.l_20aa

 STA (ptr),Y
 INY
 STA (ptr),Y
 INY
 STA (ptr),Y
 INY
 STA (ptr),Y
 TYA
 CLC
 ADC #&05
 TAY
 CPY #&1E
 BCC l_2091
 INC ptr+&01
 RTS

.l_20c1

 JSR l_3ee1
 LDX #&03	\ escape capsule
 STX &8C
 JSR l_2508
 LDA #&10
 STA &61
 LDA #&C2
 STA &64
 LSR A
 STA &66

.l_20dd

 JSR l_50a0
 JSR l_488c
 DEC &66
 BNE l_20dd
 JSR l_5558
 LDA #&00
 STA cmdr_cargo+&10
 LDX #&0C	\LDX #&10	\ save gold/plat/gems

.l_20ee

 STA cmdr_cargo,X
 DEX
 BPL l_20ee
 STA cmdr_legal
 STA cmdr_escape
 INC new_hold	\**
 LDA new_range
 STA cmdr_fuel
 JSR l_3d68
 JSR l_2f75
 JSR l_309f
 JMP l_143e

.l_2102

 LDA #&00
 JSR l_41bf
 BEQ l_210c
 JMP l_21c5

.l_210c

 JSR l_2160
 JSR l_43b1
 LDA #&FA
 JMP l_36e4

.l_2117

 LDA &30
 BNE l_2150
 LDA &66
 ASL A
 BMI l_2102
 LSR A
 TAX
 LDA l_1695,X
 STA &22
 LDA l_1695+&01,X
 JSR l_2409
 LDA &D4
 ORA &D7
 ORA &DA
 AND #&7F
 ORA &D3
 ORA &D6
 ORA &D9
 BNE l_2166
 LDA &66
 CMP #&82
 BEQ l_2150
 LDY #&23	\ missile damage
 SEC
 LDA (&22),Y
 SBC #&40
 BCS n_misshit
 LDY #&1F
 LDA (&22),Y
 BIT l_216d+&01
 BNE l_2150
 ORA #&80	\ missile hits

.n_misshit

 STA (&22),Y

.l_2150

 LDA &46
 ORA &49
 ORA &4C
 BNE l_215d
 LDA #&50
 JSR l_36e4

.l_215d

 JSR l_43ce

.l_2160

 ASL &65
 SEC
 ROR &65

.l_2165

 RTS

.l_2166

 JSR l_3f86
 CMP #&10
 BCS l_2174

.l_216d

 LDY #&20
 LDA (&22),Y
 LSR A
 BCS l_2177

.l_2174

 JMP l_221a

.l_2177

 JMP l_3813

.l_217a

 LDY #&03
 STY &99
 INY
 STY &9A
 LDA #&16
 STA &94
 CPX #&01
 BEQ l_2117
 CPX #&02
 BNE l_21bb
 LDA &6A
 AND #&04
 BNE l_21a6
 LDA &0328
 ORA &033F	\ no shuttles if docking computer on
 BNE l_2165
 JSR l_3f86
 CMP #&FD
 BCC l_2165
 AND #&01
 ADC #&08
 TAX
 BNE l_21b6	\ BRA

.l_21a6

 JSR l_3f86
 CMP #&F0
 BCC l_2165
 LDA &032E
 CMP #&07	\ viper hordes
 BCS l_21d4
 LDX #&10

.l_21b6

 LDA #&F1
 JMP l_2592

.l_21bb

 LDY #&0E
 LDA &69
 CMP (&1E),Y
 BCS l_21c5
 INC &69

.l_21c5

 CPX #&1E
 BNE l_21d5
 LDA &033B
 BNE l_21d5
 LSR &66
 ASL &66
 LSR &61

.l_21d4

 RTS

.l_21d5

 JSR l_3f86
 LDA &6A
 LSR A
 BCC l_21e1
 CPX #&64
 BCS l_21d4

.l_21e1

 LSR A
 BCC l_21f3
 LDX cmdr_legal
 CPX #&28
 BCC l_21f3
 LDA &6A
 ORA #&04
 STA &6A
 LSR A
 LSR A

.l_21f3

 LSR A
 BCS l_2203
 LSR A
 LSR A
 BCC l_21fd
 JMP l_2346

.l_21fd

 LDY #&00
 JSR l_42ae
 JMP l_2324

.l_2203

 LSR A
 BCC l_2211
 LDA &0320
 BEQ l_2211
 LDA &66
 AND #&81
 STA &66

.l_2211

 LDX #&08

.l_2213

 LDA &46,X
 STA &D2,X
 DEX
 BPL l_2213

.l_221a

 JSR l_42bd
 JSR l_28de
 STA &93
 LDA &8C
 CMP #&01
 BNE l_222b
 JMP l_22dd

.l_222b

 CMP #&0E
 BNE l_223b
 JSR l_3f86
 CMP #&C8
 BCC l_223b
 LDX #&0F
 JMP l_21b6

.l_223b

 JSR l_3f86
 CMP #&FA
 BCC l_2249
 JSR l_3f86
 ORA #&68
 STA &63

.l_2249

 LDY #&0E
 LDA (&1E),Y
 LSR A
 CMP &69
 BCC l_2294
 LSR A
 LSR A
 CMP &69
 BCC l_226d
 JSR l_3f86
 CMP #&E6
 BCC l_226d
 LDX &8C
 LDA l_563d,X
 BPL l_226d
 LDA #&00
 STA &66
 JMP l_258e

.l_226d

 LDA &65
 AND #&07
 BEQ l_2294
 STA &D1
 JSR l_3f86
 \	AND #&1F
 AND #&0F
 CMP &D1
 BCS l_2294
 LDA &30
 BNE l_2294
 DEC &65
 LDA &8C
 CMP #&1D
 BNE l_2291
 LDX #&1E
 LDA &66
 JMP l_2592

.l_2291

 JMP l_43be

.l_2294

 LDA #&00
 JSR l_41bf
 AND #&E0
 BNE l_22c6
 LDX &93
 CPX #&A0
 BCC l_22c6
 LDY #&13
 LDA (&1E),Y
 AND #&F8
 BEQ l_22c6
 LDA &65
 ORA #&40
 STA &65
 CPX #&A3
 BCC l_22c6
 LDA (&1E),Y
 LSR A
 JSR l_36e4
 DEC &62
 LDA &30
 BNE l_2311
 LDA #&08
 JMP l_43f3

.l_22c6

 LDA &4D
 CMP #&03
 BCS l_22d4
 LDA &47
 ORA &4A
 AND #&FE
 BEQ l_22e6

.l_22d4

 JSR l_3f86
 ORA #&80
 CMP &66
 BCS l_22e6

.l_22dd

 JSR l_245d
 LDA &93
 EOR #&80

.l_22e4

 STA &93

.l_22e6

 LDY #&10
 JSR l_28e0
 TAX
 JSR l_2332
 STA &64
 LDA &63
 ASL A
 CMP #&20
 BCS l_2305
 LDY #&16
 JSR l_28e0
 TAX
 EOR &64
 JSR l_2332
 STA &63

.l_2305

 LDA &93
 BMI l_2312
 CMP &94
 BCC l_2312
 LDA #&03
 STA &62

.l_2311

 RTS

.l_2312

 AND #&7F
 CMP #&12
 BCC l_2323
 LDA #&FF
 LDX &8C
 CPX #&01
 BNE l_2321
 ASL A

.l_2321

 STA &62

.l_2323

 RTS

.l_2324

 JSR l_28de
 CMP #&98
 BCC l_232f
 LDX #&00
 STX &9A

.l_232f

 JMP l_22e4

.l_2332

 EOR #&80
 AND #&80
 STA &D1
 TXA
 ASL A
 CMP &9A
 BCC l_2343
 LDA &99
 ORA &D1
 RTS

.l_2343

 LDA &D1
 RTS

.l_2346

 LDA #&06
 STA &9A
 LSR A
 STA &99
 LDA #&1D
 STA &94
 LDA &0320
 BNE l_2359

.l_2356

 JMP l_21fd

.l_2359

 JSR l_2403
 LDA &D4
 ORA &D7
 ORA &DA
 AND #&7F
 BNE l_2356
 JSR l_42e0
 LDA &81
 STA &40
 JSR l_42bd
 LDY #&0A
 JSR l_243b
 BMI l_239a
 CMP #&23
 BCC l_239a
 JSR l_28de
 CMP #&A2
 BCS l_23b4
 LDA &40
 CMP #&9D
 BCC l_238c
 LDA &8C
 BMI l_23b4

.l_238c

 JSR l_245d
 JSR l_2324

.l_2392

 LDX #&00
 STX &62
 INX
 STX &61
 RTS

.l_239a

 JSR l_2403
 JSR l_2470
 JSR l_2470
 JSR l_42bd
 JSR l_245d
 JMP l_2324

.l_23ac

 INC &62
 LDA #&7F
 STA &63
 BNE l_23f9

.l_23b4

 LDX #&00
 STX &9A
 STX &64
 LDA &8C
 BPL l_23de
 EOR &34
 EOR &35
 ASL A
 LDA #&02
 ROR A
 STA &63
 LDA &34
 ASL A
 CMP #&0C
 BCS l_2392
 LDA &35
 ASL A
 LDA #&02
 ROR A
 STA &64
 LDA &35
 ASL A
 CMP #&0C
 BCS l_2392

.l_23de

 STX &63
 LDA &5C
 STA &34
 LDA &5E
 STA &35
 LDA &60
 STA &36
 LDY #&10
 JSR l_243b
 ASL A
 CMP #&42
 BCS l_23ac
 JSR l_2392

.l_23f9

 LDA &DC
 BNE l_2402

.top_6a

 ASL &6A
 SEC
 ROR &6A

.l_2402

 RTS

.l_2403

 LDA #&25
 STA &22
 LDA #&09

.l_2409

 STA &23
 LDY #&02
 JSR l_2417
 LDY #&05
 JSR l_2417
 LDY #&08

.l_2417

 LDA (&22),Y
 EOR #&80
 STA &43
 DEY
 LDA (&22),Y
 STA &42
 DEY
 LDA (&22),Y
 STA &41
 STY &80
 LDX &80
 JSR l_1d4c
 LDY &80
 STA &D4,X
 LDA &42
 STA &D3,X
 LDA &41
 STA &D2,X
 RTS

.l_243b

 LDX &0925,Y
 STX &81
 LDA &34
 JSR l_28d4
 LDX &0927,Y
 STX &81
 LDA &35
 JSR l_28fc
 STA &83
 STX &82
 LDX &0929,Y
 STX &81
 LDA &36
 JMP l_28fc

.l_245d

 LDA &34
 EOR #&80
 STA &34
 LDA &35
 EOR #&80
 STA &35
 LDA &36
 EOR #&80
 STA &36
 RTS

.l_2470

 JSR l_2473

.l_2473

 LDA &092F
 LDX #&00
 JSR l_2488
 LDA &0931
 LDX #&03
 JSR l_2488
 LDA &0933
 LDX #&06

.l_2488

 ASL A
 STA &82
 LDA #&00
 ROR A
 EOR #&80
 EOR &D4,X
 BMI l_249f
 LDA &82
 ADC &D2,X
 STA &D2,X
 BCC l_249e
 INC &D3,X

.l_249e

 RTS

.l_249f

 LDA &D2,X
 SEC
 SBC &82
 STA &D2,X
 LDA &D3,X
 SBC #&00
 STA &D3,X
 BCS l_249e
 LDA &D2,X
 EOR #&FF
 ADC #&01
 STA &D2,X
 LDA &D3,X
 EOR #&FF
 ADC #&00
 STA &D3,X
 LDA &D4,X
 EOR #&80
 STA &D4,X
 JMP l_249e

.l_24c7

 CLC
 LDA &4E
 BNE l_2505
 LDA &8C
 BMI l_2505
 LDA &65
 AND #&20
 ORA &47
 ORA &4A
 BNE l_2505
 LDA &46
 JSR l_280d
 STA &83
 LDA &1B
 STA &82
 LDA &49
 JSR l_280d
 TAX
 LDA &1B
 ADC &82
 STA &82
 TXA
 ADC &83
 BCS l_2506
 STA &83
 LDY #&02
 LDA (&1E),Y
 CMP &83
 BNE l_2505
 DEY
 LDA (&1E),Y
 CMP &82

.l_2505

 RTS

.l_2506

 CLC
 RTS

.l_2508

 JSR l_3f26
 LDA #&1C
 STA &49
 LSR A
 STA &4C
 LDA #&80
 STA &4B
 LDA &45
 ASL A
 ORA #&80
 STA &66

.l_251d

 LDA #&60
 STA &54
 ORA #&80
 STA &5C
 LDA &7D
 ROL A
 STA &61
 TXA
 JMP l_3768

.l_252e

 LDX #&01
 JSR l_2508
 BCC l_2589
 LDX &45
 JSR ship_ptr
 LDA ship_type,X
 JSR l_254d
 DEC cmdr_misl
 JSR l_3f3b	\ redraw missiles
 STY target
 STX &45
 JMP n_sound30

.anger_8c

 LDA &8C

.l_254d

 CMP #&02
 BEQ l_2580
 LDY #&24
 LDA (&20),Y
 AND #&20
 BEQ l_255c
 JSR l_2580

.l_255c

 LDY #&20
 LDA (&20),Y
 BEQ l_2505
 ORA #&80
 STA (&20),Y
 LDY #&1C
 LDA #&02
 STA (&20),Y
 ASL A
 LDY #&1E
 STA (&20),Y
 LDA &8C
 CMP #&0B
 BCC l_257f
 LDY #&24
 LDA (&20),Y
 ORA #&04
 STA (&20),Y

.l_257f

 RTS

.l_2580

 LDA &0949
 ORA #&04
 STA &0949
 RTS

.l_2589

 LDA #&C9
 JMP l_45c6

.l_258e

 LDX #&03

.l_2590

 LDA #&FE

.l_2592

 STA &06
 TXA
 PHA
 LDA &1E
 PHA
 LDA &1F
 PHA
 LDA &20
 PHA
 LDA &21
 PHA
 LDY #&24

.l_25a4

 LDA &46,Y
 STA &0100,Y
 LDA (&20),Y
 STA &46,Y
 DEY
 BPL l_25a4
 LDA &6A
 AND #&1C
 STA &6A
 LDA &8C
 CMP #&02
 BNE l_25db
 TXA
 PHA
 LDA #&20
 STA &61
 LDX #&00
 LDA &50
 JSR l_261a
 LDX #&03
 LDA &52
 JSR l_261a
 LDX #&06
 LDA &54
 JSR l_261a
 PLA
 TAX

.l_25db

 LDA &06
 STA &66
 LSR &63
 ASL &63
 TXA
 CMP #&09
 BCS l_25fe
 CMP #&04
 BCC l_25fe
 PHA
 JSR l_3f86
 ASL A
 STA &64
 TXA
 AND #&0F
 STA &61
 LDA #&FF
 ROR A
 STA &63
 PLA

.l_25fe

 JSR l_3768
 PLA
 STA &21
 PLA
 STA &20
 LDX #&24

.l_2609

 LDA &0100,X
 STA &46,X
 DEX
 BPL l_2609
 PLA
 STA &1F
 PLA
 STA &1E
 PLA
 TAX
 RTS

.l_261a

 ASL A
 STA &82
 LDA #&00
 ROR A
 JMP l_524c

.l_2623

 LDA #&38
 JSR l_43f3
 LDA #&01
 STA &0348
 LDA #&04
 JSR l_263d
 DEC &0348
 RTS

.l_2636

 JSR n_sound30
 LDA #&08

.l_263d

 STA &95
 JSR l_54ca

.l_2642

 LDX #&80
 STX &D2
 LDX #&60
 STX &E0
 LDX #&00
 STX &96
 STX &D3
 STX &E1

.l_2652

 JSR l_265e
 INC &96
 LDX &96
 CPX #&08
 BNE l_2652
 RTS

.l_265e

 LDA &96
 AND #&07
 CLC
 ADC #&08
 STA &40

.l_2667

 LDA #&01
 STA &6B
 JSR l_3b90
 ASL &40
 BCS l_2678
 LDA &40
 CMP #&A0
 BCC l_2667

.l_2678

 RTS

.l_2679

 LDA #&00
 CPX #&02
 ROR A
 STA &99
 EOR #&80
 STA &9A
 JSR l_272d
 LDY &03C3

.l_268a

 LDA &0FA8,Y
 STA &88
 LSR A
 LSR A
 LSR A
 JSR l_2961
 LDA &1B
 EOR &9A
 STA &83
 LDA &0F6F,Y
 STA &1B
 LDA &0F5C,Y
 STA &34
 JSR l_28ff
 STA &83
 STX &82
 LDA &0F82,Y
 STA &35
 EOR &7B
 LDX &2B
 JSR l_27c8
 JSR l_28ff
 STX &24
 STA &25
 LDX &0F95,Y
 STX &82
 LDX &35
 STX &83
 LDX &2B
 EOR &7C
 JSR l_27c8
 JSR l_28ff
 STX &26
 STA &27
 LDX &31
 EOR &32
 JSR l_27c8
 STA &81
 LDA &24
 STA &82
 LDA &25
 STA &83
 EOR #&80
 JSR l_28fc
 STA &25
 TXA
 STA &0F6F,Y
 LDA &26
 STA &82
 LDA &27
 STA &83
 JSR l_28fc
 STA &83
 STX &82
 LDA #&00
 STA &1B
 LDA &8D
 JSR l_1907
 LDA &25
 STA &0F5C,Y
 STA &34
 AND #&7F
 CMP #&74
 BCS l_2748
 LDA &27
 STA &0F82,Y
 STA &35
 AND #&7F
 CMP #&74
 BCS l_275b

.l_2724

 JSR l_1910
 DEY
 BEQ l_272d
 JMP l_268a

.l_272d

 LDA &8D
 EOR &99
 STA &8D
 LDA &32
 EOR &99
 STA &32
 EOR #&80
 STA &33
 LDA &7B
 EOR &99
 STA &7B
 EOR #&80
 STA &7C
 RTS

.l_2748

 JSR l_3f86
 STA &35
 STA &0F82,Y
 LDA #&73
 ORA &99
 STA &34
 STA &0F5C,Y
 BNE l_276c

.l_275b

 JSR l_3f86
 STA &34
 STA &0F5C,Y
 LDA #&6E
 ORA &33
 STA &35
 STA &0F82,Y

.l_276c

 JSR l_3f86
 ORA #&08
 STA &88
 STA &0FA8,Y
 BNE l_2724

.l_2778

 STA &40

.n_store

 STA &41
 STA &42
 STA &43
 CLC
 RTS

.l_2782

 STA &82
 AND #&7F
 STA &42
 LDA &81
 AND #&7F
 BEQ l_2778
 SEC
 SBC #&01
 STA &D1
 LDA font
 LSR &42
 ROR A
 STA &41
 LDA &1B
 ROR A
 STA &40
 LDA #&00
 LDX #&18

.l_27a3

 BCC l_27a7
 ADC &D1

.l_27a7

 ROR A
 ROR &42
 ROR &41
 ROR &40
 DEX
 BNE l_27a3
 STA &D1
 LDA &82
 EOR &81
 AND #&80
 ORA &D1
 STA &43
 RTS

.l_27be

 LDX &24
 STX &82
 LDX &25
 STX &83

.l_27c6

 LDX &31

.l_27c8

 STX &1B
 TAX
 AND #&80
 STA &D1
 TXA
 AND #&7F
 BEQ l_2838
 TAX
 DEX
 STX &06
 LDA #&00
 LSR &1B
 BCC l_27e0
 ADC &06

.l_27e0

 ROR A
 ROR &1B
 BCC l_27e7
 ADC &06

.l_27e7

 ROR A
 ROR &1B
 BCC l_27ee
 ADC &06

.l_27ee

 ROR A
 ROR &1B
 BCC l_27f5
 ADC &06

.l_27f5

 ROR A
 ROR &1B
 BCC l_27fc
 ADC &06

.l_27fc

 ROR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 ORA &D1
 RTS

.l_280b

 AND #&7F

.l_280d

 STA &1B
 TAX
 BNE l_2824

.l_2812

 CLC
 STX &1B
 TXA
 RTS

.l_2817

 LDA &0F82,Y
 STA &35

.l_281c

 AND #&7F
 STA &1B

.l_2820

 LDX &81
 BEQ l_2812

.l_2824

 DEX
 STX &D1
 LDA #&00
 LDX #&08
 LSR &1B

.l_282d

 BCC l_2831
 ADC &D1

.l_2831

 ROR A
 ROR &1B
 DEX
 BNE l_282d
 RTS

.l_2838

 STA font
 STA &1B
 RTS

.l_283d

 AND #&1F
 TAX
 LDA &07C0,X
 STA &81
 LDA &40

.l_2847

 EOR #&FF
 SEC
 ROR A
 STA &1B
 LDA #&00

.l_284f

 BCS l_2859
 ADC &81
 ROR A
 LSR &1B
 BNE l_284f
 RTS

.l_2859

 LSR A
 LSR &1B
 BNE l_284f
 RTS

.l_286c

 BCC l_2870
 ADC &D1

.l_2870

 ROR A
 ROR &1B
 DEX
 BNE l_286c
 RTS

.l_2877

 STX &81

.l_2879

 EOR #&FF
 LSR A
 STA font
 LDA #&00
 LDX #&10
 ROR &1B

.l_2884

 BCS l_2891
 ADC &81
 ROR A
 ROR font
 ROR &1B
 DEX
 BNE l_2884
 RTS

.l_2891

 LSR A
 ROR font
 ROR &1B
 DEX
 BNE l_2884
 RTS

.l_289e

 LDX &25
 STX &83

.l_28a2

 LDX &24
 STX &82

.l_28a6

 TAX
 AND #&7F
 LSR A
 \	LSR A	\ manoevre
 STA &1B
 TXA
 EOR &81
 AND #&80
 STA &D1
 LDA &81
 AND #&7F
 BEQ l_28d1
 TAX
 DEX
 STX &06
 LDA #&00
 LDX #&07

.l_28c1

 BCC l_28c5
 ADC &06

.l_28c5

 ROR A
 ROR &1B
 DEX
 BNE l_28c1
 LSR A
 ROR &1B
 ORA &D1
 RTS

.l_28d1

 STA &1B
 RTS

.l_28d4

 JSR l_28a6
 STA &83
 LDA &1B
 STA &82
 RTS

.l_28de

 LDY #&0A

.l_28e0

 LDX &46,Y
 STX &81
 LDA &34
 JSR l_28d4
 LDX &48,Y
 STX &81
 LDA &35
 JSR l_28fc
 STA &83
 STX &82
 LDX &4A,Y
 STX &81
 LDA &36

.l_28fc

 JSR l_28a6

.l_28ff

 STA &06
 AND #&80
 STA &D1
 EOR &83
 BMI l_2916
 LDA &82
 CLC
 ADC &1B
 TAX
 LDA &83
 ADC &06
 ORA &D1
 RTS

.l_2916

 LDA &83
 AND #&7F
 STA &80
 LDA &1B
 SEC
 SBC &82
 TAX
 LDA &06
 AND #&7F
 SBC &80
 BCS l_2938
 STA &80
 TXA
 EOR #&FF
 ADC #&01
 TAX
 LDA #&00
 SBC &80
 ORA #&80

.l_2938

 EOR &D1
 RTS

.l_293b

 STX &81
 EOR #&80
 JSR l_28fc
 TAX
 AND #&80
 STA &D1
 TXA
 AND #&7F
 LDX #&FE
 STX &06

.l_294e

 ASL A
 CMP #&60
 BCC l_2955
 SBC #&60

.l_2955

 ROL &06
 BCS l_294e
 LDA &06
 ORA &D1
 RTS

.l_295e

 LDA &0FA8,Y

.l_2961

 STA &81
 LDA &7D

.l_2965

 LDX #&08
 ASL A
 STA &1B
 LDA #&00

.l_296c

 ROL A
 BCS l_2973
 CMP &81
 BCC l_2976

.l_2973

 SBC &81
 SEC

.l_2976

 ROL &1B
 DEX
 BNE l_296c
 JMP l_47f3

.l_297e

 STA font+&01
 LDA &4C
 STA &81
 LDA &4D
 STA &82
 LDA &4E
 STA &83
 LDA &1B
 ORA #&01
 STA &1B
 LDA font+&01
 EOR &83
 AND #&80
 STA &D1
 LDY #&00
 LDA font+&01
 AND #&7F

.l_29a0

 CMP #&40
 BCS l_29ac
 ASL &1B
 ROL font
 ROL A
 INY
 BNE l_29a0

.l_29ac

 STA font+&01
 LDA &83
 AND #&7F
 BMI l_29bc

.l_29b4

 DEY
 ASL &81
 ROL &82
 ROL A
 BPL l_29b4

.l_29bc

 STA &81
 LDA #&FE
 STA &82
 LDA font+&01
 JSR l_47f7
 LDA #&00
 JSR n_store	\ swapped
 TYA
 BPL l_29f0
 LDA &82

.l_29d4

 ASL A
 ROL &41
 ROL &42
 ROL &43
 INY
 BNE l_29d4
 STA &40
 LDA &43
 ORA &D1
 STA &43
 RTS

.l_29e7

 LDA &82
 STA &40
 LDA &D1
 STA &43
 RTS

.l_29f0

 BEQ l_29e7
 LDA &82

.l_29f4

 LSR A
 DEY
 BNE l_29f4
 STA &40
 LDA &D1
 STA &43
 RTS

.l_29ff

 LDA &033F
 BNE l_2a09
 LDA cap_flag
 BNE l_2a15

.l_2a09

 TXA
 BPL l_2a0f
 DEX
 BMI l_2a15

.l_2a0f

 INX
 BNE l_2a15
 DEX
 BEQ l_2a0f

.l_2a15

 RTS

.l_2a16

 STA &D1
 TXA
 CLC
 ADC &D1
 TAX
 BCC l_2a21
 LDX #&FF

.l_2a21

 BPL l_2a33

.l_2a23

 LDA &D1
 RTS

.l_2a26

 STA &D1
 TXA
 SEC
 SBC &D1
 TAX
 BCS l_2a31
 LDX #&01

.l_2a31

 BPL l_2a23

.l_2a33

 LDA a_flag
 BNE l_2a23
 LDX #&80
 BMI l_2a23

.l_2a3c

 LDA &1B
 EOR &81
 STA &06
 LDA &81
 BEQ l_2a6b
 ASL A
 STA &81
 LDA &1B
 ASL A
 CMP &81
 BCS l_2a59
 JSR l_2a75
 SEC

.l_2a54

 LDX &06
 BMI l_2a6e
 RTS

.l_2a59

 LDX &81
 STA &81
 STX &1B
 TXA
 JSR l_2a75
 STA &D1
 LDA #&40
 SBC &D1
 BCS l_2a54

.l_2a6b

 LDA #&3F
 RTS

.l_2a6e

 STA &D1
 LDA #&80
 SBC &D1
 RTS

.l_2a75

 JSR l_47ef
 LDA &82
 LSR A
 LSR A
 LSR A
 TAX
 LDA &07E0,X

.l_2a81

 RTS

.l_2a82

 JSR l_3f86
 AND #&07
 ADC #&5C
 STA &0FCF
 JSR l_3f86
 AND #&07
 ADC #&7C
 STA &0FCE
 LDA laser_t
 ADC #&08
 STA laser_t
 JSR l_3629

.l_2aa1

 LDA &87
 BNE l_2a81
 LDA #&20
 LDY #&E0
 JSR l_2ab0
 LDA #&30
 LDY #&D0

.l_2ab0

 STA &36
 LDA &0FCE
 STA &34
 LDA &0FCF
 STA &35
 LDA #&BF
 STA &37
 JSR l_16c4
 LDA &0FCE
 STA &34
 LDA &0FCF
 STA &35
 STY &36
 LDA #&BF
 STA &37
 JMP l_16c4

.l_2aec

 CPX #&10
 BEQ n_aliens
 CPX #&0D
 BCS l_2b04

.n_aliens

 LDY #&0C
 SEC
 LDA cmdr_cargo+&10

.l_2af9

 ADC cmdr_cargo,Y
 BCS n_cargo
 DEY
 BPL l_2af9
 CMP new_hold

.n_cargo

 RTS

.l_2b04

 LDA cmdr_cargo,X
 ADC #&00
 RTS

.l_2b0e

 JSR l_2b11

.l_2b11

 JSR l_2b14

.l_2b14

 LDA &6C
 CLC
 ADC &6E
 TAX
 LDA &6D
 ADC &6F
 TAY
 LDA &6E
 STA &6C
 LDA &6F
 STA &6D
 LDA &71
 STA &6F
 LDA &70
 STA &6E
 CLC
 TXA
 ADC &6E
 STA &70
 TYA
 ADC &6F
 STA &71
 RTS

.l_2b3b

 LDA hype_dist
 ORA hype_dist+&01
 BNE l_2b46
 INC cursor_y
 RTS

.l_2b46

 LDA #&BF
 JSR l_3395
 LDX hype_dist
 LDY hype_dist+&01
 SEC
 JSR l_30b4
 LDA #&C3

.l_2b57

 JSR l_339a

.l_2b5a

 INC cursor_y

.l_2b5c

 JSR vdu_80

.l_2b60

 LDA #&0C
 JMP l_339a

.l_2b65

 LDA #&AD
 JSR l_339a
 JMP l_2ba9

.l_2b6d

 JSR l_339a
 JMP l_3142

.l_2b73

 LDA #&01
 JSR l_54c8
 LDA #&09
 STA cursor_x
 LDA #&A3
 JSR l_339a
 JSR l_184e
 JSR l_2b5a
 INC cursor_y
 JSR l_2b3b
 LDA #&C2
 JSR l_3395
 LDA data_econ
 CLC
 ADC #&01
 LSR A
 CMP #&02
 BEQ l_2b65
 LDA data_econ
 BCC l_2ba4
 SBC #&05
 CLC

.l_2ba4

 ADC #&AA
 JSR l_339a

.l_2ba9

 LDA data_econ
 LSR A
 LSR A
 CLC
 ADC #&A8
 JSR l_2b57
 LDA #&A2
 JSR l_3395
 LDA data_govm
 CLC
 ADC #&B1
 JSR l_2b57
 LDA #&C4
 JSR l_3395
 LDX data_tech
 INX
 JSR c_1e38
 JSR l_2b5a
 LDA #&C0
 JSR l_3395
 SEC
 LDX data_popn
 JSR l_1e38
 LDA #&C6
 JSR l_2b57
 LDA #&28
 JSR l_339a
 LDA &70
 BMI l_2bf4
 LDA #&BC
 JSR l_339a
 JMP l_2c30

.l_2bf4

 LDA &71
 LSR A
 LSR A
 PHA
 AND #&07
 CMP #&03
 BCS l_2c04
 ADC #&E3
 JSR l_2b6d

.l_2c04

 PLA
 LSR A
 LSR A
 LSR A
 CMP #&06
 BCS l_2c11
 ADC #&E6
 JSR l_2b6d

.l_2c11

 LDA &6F
 EOR &6D
 AND #&07
 STA &73
 CMP #&06
 BCS l_2c22
 ADC #&EC
 JSR l_2b6d

.l_2c22

 LDA &71
 AND #&03
 CLC
 ADC &73
 AND #&07
 ADC #&F2
 JSR l_339a

.l_2c30

 LDA #&53
 JSR l_339a
 LDA #&29
 JSR l_2b57
 LDA #&C1
 JSR l_3395
 LDX data_gnp
 LDY data_gnp+&01
 JSR l_30b3
 JSR l_3142
 JSR vdu_00
 LDA #&4D
 JSR l_339a
 LDA #&E2
 JSR l_2b57
 LDA #&FA
 JSR l_3395
 LDA &71
 LDX &6F
 AND #&0F
 CLC
 ADC #&0B
 TAY
 JSR l_30b4
 JSR l_3142
 LDA #&6B
 JSR wrchdst
 LDA #&6D
 JMP wrchdst

.l_2c78

 LDA &6D
 AND #&07
 STA data_econ
 LDA &6E
 LSR A
 LSR A
 LSR A
 AND #&07
 STA data_govm
 LSR A
 BNE l_2c94
 LDA data_econ
 ORA #&02
 STA data_econ

.l_2c94

 LDA data_econ
 EOR #&07
 CLC
 STA data_tech
 LDA &6F
 AND #&03
 ADC data_tech
 STA data_tech
 LDA data_govm
 LSR A
 ADC data_tech
 STA data_tech
 ASL A
 ASL A
 ADC data_econ
 ADC data_govm
 ADC #&01
 STA data_popn
 LDA data_econ
 EOR #&07
 ADC #&03
 STA &1B
 LDA data_govm
 ADC #&04
 STA &81
 JSR l_2820
 LDA data_popn
 STA &81
 JSR l_2820
 ASL &1B
 ROL A
 ASL &1B
 ROL A
 ASL &1B
 ROL A
 STA data_gnp+&01
 LDA &1B
 STA data_gnp
 RTS

.l_2ceb

 LDA #&40
 JSR l_54c8
 LDA #&07
 STA cursor_x
 JSR l_2f6a
 LDA #&C7
 JSR l_339a
 JSR l_184e
 LDA #&98
 JSR l_1852
 JSR l_2da1
 LDX #&00

.l_2d09

 STX &84
 LDX &6F
 LDY &70
 TYA
 ORA #&50
 STA &88
 LDA &6D
 LSR A
 CLC
 ADC #&18
 STA &35
 JSR l_1932
 JSR l_2b0e
 LDX &84
 INX
 BNE l_2d09
 LDA data_homex
 STA &73
 LDA data_homey
 LSR A
 STA &74
 LDA #&04
 STA &75

.l_2d36

 LDA #&18
 LDX &87
 BPL l_2d3e
 LDA #&00

.l_2d3e

 STA &78
 LDA &73
 SEC
 SBC &75
 BCS l_2d49
 LDA #&00

.l_2d49

 STA &34
 LDA &73
 CLC
 ADC &75
 BCC l_2d54
 LDA #&FF

.l_2d54

 STA &36
 LDA &74
 CLC
 ADC &78
 STA &35
 JSR l_1868
 LDA &74
 SEC
 SBC &75
 BCS l_2d69
 LDA #&00

.l_2d69

 CLC
 ADC &78
 STA &35
 LDA &74
 CLC
 ADC &75
 ADC &78
 CMP #&98
 BCC l_2d7f
 LDX &87
 BMI l_2d7f
 LDA #&97

.l_2d7f

 STA &37
 LDA &73
 STA &34
 STA &36
 JMP l_16c4

.l_2d8a

 LDA #&68
 STA &73
 LDA #&5A
 STA &74
 LDA #&10
 STA &75
 JSR l_2d36
 LDA cmdr_fuel
 STA &40
 JMP l_2dc5

.l_2da1

 LDA &87
 BMI l_2d8a
 LDA cmdr_fuel
 LSR A
 LSR A
 STA &40
 LDA cmdr_homex
 STA &73
 LDA cmdr_homey
 LSR A
 STA &74
 LDA #&07
 STA &75
 JSR l_2d36
 LDA &74
 CLC
 ADC #&18
 STA &74

.l_2dc5

 LDA &73
 STA &D2
 LDA &74
 STA &E0
 LDX #&00
 STX &E1
 STX &D3
 INX
 STX &6B
 INX
 STX &95
 JMP l_3b90

.l_2dde

 LDY #&00

.l_2de0

 STY &03AD
 LDX cmdr_cargo,Y
 BEQ l_2e0c
 TYA
 ASL A
 ASL A
 TAY
 LDA l_4619+&01,Y
 STA &74
 TXA
 PHA
 JSR l_2b5c
 CLC
 LDA &03AD
 ADC #&D0
 JSR l_339a
 LDA #&0E
 STA cursor_x
 PLA
 TAX
 JSR c_1e38
 JSR l_3135

.l_2e0c

 LDY &03AD
 INY
 CPY #&11
 BCC l_2de0
 RTS

.l_2e15

 LDA #&08
 JSR l_54c8
 LDA #&0B
 STA cursor_x
 LDA #&A4
 JSR l_2b57
 JSR l_184a
 JSR l_3366
 LDA #&0E
 JSR l_3395
 LDX new_hold
 DEX
 JSR c_1e38
 JSR l_3147
 JMP l_2dde

.l_2e38

 TXA
 PHA
 DEY
 TYA
 EOR #&FF
 PHA
 \	JSR l_55f7
 JSR l_2e65
 PLA
 STA &76
 LDA data_homey
 JSR l_2e7b
 LDA &77
 STA data_homey
 STA &74
 PLA
 STA &76
 LDA data_homex
 JSR l_2e7b
 LDA &77
 STA data_homex
 STA &73

.l_2e65

 LDA &87
 BMI l_2e8c
 LDA data_homex
 STA &73
 LDA data_homey
 LSR A
 STA &74
 LDA #&04
 STA &75
 JMP l_2d36

.l_2e7b

 STA &77
 CLC
 ADC &76
 LDX &76
 BMI l_2e87
 BCC l_2e89
 RTS

.l_2e87

 BCC l_2e8b

.l_2e89

 STA &77

.l_2e8b

 RTS

.l_2e8c

 LDA data_homex
 SEC
 SBC cmdr_homex
 CMP #&26
 BCC l_2e9b
 CMP #&E6
 BCC l_2e8b

.l_2e9b

 ASL A
 ASL A
 CLC
 ADC #&68
 STA &73
 LDA data_homey
 SEC
 SBC cmdr_homey
 CMP #&26
 BCC l_2eb1
 CMP #&DC
 BCC l_2e8b

.l_2eb1

 ASL A
 CLC
 ADC #&5A
 STA &74
 LDA #&08
 STA &75
 JMP l_2d36

.l_2ebe

 LDA #&80
 JSR l_54c8
 LDA #&07
 STA cursor_x
 LDA #&BE
 JSR l_1847
 JSR l_2da1
 JSR l_2e65
 JSR l_2f6a
 LDA #&00
 STA &97
 LDX #&18

.l_2edb

 STA &46,X
 DEX
 BPL l_2edb

.l_2ee0

 LDA &6F
 SEC
 SBC cmdr_homex
 STA &3A
 BCS l_2eec
 EOR #&FF
 ADC #&01

.l_2eec

 CMP #&14
 BCS l_2f60
 LDA &6D
 SEC
 SBC cmdr_homey
 STA &E0
 BCS l_2efc
 EOR #&FF
 ADC #&01

.l_2efc

 CMP #&26
 BCS l_2f60
 LDA &3A
 ASL A
 ASL A
 ADC #&68
 STA &3A
 LSR A
 LSR A
 LSR A
 STA cursor_x
 INC cursor_x
 LDA &E0
 ASL A
 ADC #&5A
 STA &E0
 LSR A
 LSR A
 LSR A
 TAY
 LDX &46,Y
 BEQ l_2f31
 INY
 LDX &46,Y
 BEQ l_2f31
 DEY
 DEY
 LDX &46,Y
 BNE l_2f43

.l_2f31

 STY cursor_y
 CPY #&03
 BCC l_2f60
 LDA #&FF
 STA &46,Y
 JSR vdu_80
 JSR l_330a

.l_2f43

 LDA #&00
 STA &D3
 STA &E1
 STA &41
 LDA &3A
 STA &D2
 LDA &71
 AND #&01
 ADC #&02
 STA &40
 JSR l_360a
 JSR l_3a54
 JSR l_360a

.l_2f60

 JSR l_2b0e
 INC &97
 BEQ l_2f74
 JMP l_2ee0

.l_2f6a

 LDX #&05

.l_2f6c

 LDA cmdr_gseed,X
 STA &6C,X
 DEX
 BPL l_2f6c

.l_2f74

 RTS

.l_2f75

 JSR l_2f6a
 LDY #&7F
 STY &D1
 LDA #&00
 STA &80

.l_2f80

 LDA &6F
 SEC
 SBC data_homex
 BCS l_2f8c
 EOR #&FF
 ADC #&01

.l_2f8c

 LSR A
 STA &83
 LDA &6D
 SEC
 SBC data_homey
 BCS l_2f9b
 EOR #&FF
 ADC #&01

.l_2f9b

 LSR A
 CLC
 ADC &83
 CMP &D1
 BCS l_2fae
 STA &D1
 LDX #&05

.l_2fa7

 LDA &6C,X
 STA &73,X
 DEX
 BPL l_2fa7

.l_2fae

 JSR l_2b0e
 INC &80
 BNE l_2f80
 LDX #&05

.l_2fb7

 LDA &73,X
 STA &6C,X
 DEX
 BPL l_2fb7
 LDA &6D
 STA data_homey
 LDA &6F
 STA data_homex
 SEC
 SBC cmdr_homex
 BCS l_2fd2
 EOR #&FF
 ADC #&01

.l_2fd2

 JSR l_280d
 STA &41
 LDA &1B
 STA &40
 LDA data_homey
 SEC
 SBC cmdr_homey
 BCS l_2fe8
 EOR #&FF
 ADC #&01

.l_2fe8

 LSR A
 JSR l_280d
 PHA
 LDA &1B
 CLC
 ADC &40
 STA &81
 PLA
 ADC &41
 STA &82
 JSR l_47b8
 LDA &81
 ASL A
 LDX #&00
 STX hype_dist+&01
 ROL hype_dist+&01
 ASL A
 ROL hype_dist+&01
 STA hype_dist
 JMP l_2c78

.l_3011

 LDA &2F
 ORA &8E
 BNE l_3084+&01
 JSR l_4437
 BMI l_305e
 LDA &87
 BNE l_3023
 \	JMP l_30c3
 \l_30c3
 JSR l_2f75
 JMP l_3026

.l_3023

 JSR l_32fe

.l_3026

 LDA hype_dist
 ORA hype_dist+&01
 BEQ l_3084+&01
 LDA #&07
 STA cursor_x
 LDA #&17
 STA cursor_y
 JSR vdu_00
 LDA #&BD
 JSR l_339a
 LDA hype_dist+&01
 BNE l_30b9
 LDA cmdr_fuel
 CMP hype_dist
 BCC l_30b9
 LDA #&2D
 JSR l_339a
 JSR l_330a

.l_3054

 LDA #&0F
 STA &2F
 STA &2E
 TAX
 \	JMP l_30ac
 BNE l_30ac

.l_305e

 LDX cmdr_ghype
 BEQ l_3084+&01
 INC new_hold	\**
 INX
 STX cmdr_ghype
 STX cmdr_legal
 STX cmdr_cour
 STX cmdr_cour+1
 JSR l_3054
 LDX #&05
 INC cmdr_galxy
 LDA cmdr_galxy
 AND #&07
 STA cmdr_galxy

.l_307a

 LDA cmdr_gseed,X
 ASL A
 ROL cmdr_gseed,X
 DEX
 BPL l_307a

.l_3084

 LDA #&60
 STA data_homex
 STA data_homey
 JSR l_3292
 JSR l_2f75
 LDX #&00
 STX hype_dist
 STX hype_dist+&01
 LDA #&74
 JSR l_45c6

.l_309f

 LDA data_homex
 STA cmdr_homex
 LDA data_homey
 STA cmdr_homey
 RTS

.l_30ac

 LDY #&01
 STY cursor_x
 STY cursor_y
 DEY

.l_30b3

 CLC

.l_30b4

 LDA #&05
 JMP l_1e3c

.l_30b9

 LDA #&CA
 JSR l_339a
 LDA #&3F
 JMP l_339a

.l_30c9

 PHA
 STA &77
 ASL A
 ASL A
 STA &73
 LDA #&01
 STA cursor_x
 PLA
 ADC #&D0
 JSR l_339a
 LDA #&0E
 STA cursor_x
 LDX &73
 LDA l_4619+&01,X
 STA &74
 LDA cmdr_price
 AND l_4619+&03,X
 CLC
 ADC l_4619,X
 STA &03AA
 JSR l_3135
 JSR l_318e
 LDA &74
 BMI l_3104
 LDA &03AA
 ADC &76
 JMP l_310a

.l_3104

 LDA &03AA
 SEC
 SBC &76

.l_310a

 STA &03AA
 STA &1B
 LDA #&00
 JSR l_32f4
 SEC
 JSR l_30b4
 LDY &77
 LDA #&05
 LDX cmdr_avail,Y
 STX &03AB
 CLC
 BEQ l_312b
 JSR l_1e3a
 JMP l_3135

.l_312b

 LDA cursor_x
 ADC #&04
 STA cursor_x
 LDA #&2D
 BNE l_3144

.l_3135

 LDA &74
 AND #&60
 BEQ l_3147
 CMP #&20
 BEQ l_314e
 JSR l_3153

.l_3142

 LDA #&20

.l_3144

 JMP l_339a

.l_3147

 LDA #&74
 JSR wrchdst
 BCC l_3142

.l_314e

 LDA #&6B
 JSR wrchdst

.l_3153

 LDA #&67
 JMP wrchdst

.l_3158

 LDA #&11
 STA cursor_x
 LDA #&FF
 BNE l_3144

.l_3160

 LDA #&10
 JSR l_54c8
 LDA #&05
 STA cursor_x
 LDA #&A7
 JSR l_1847
 LDA #&03
 STA cursor_y
 JSR l_3158
 LDA #&00
 STA &03AD

.l_317a

 \	LDX #&80
 \	STX vdu_stat
 JSR vdu_80
 JSR l_30c9
 INC cursor_y
 INC &03AD
 LDA &03AD
 CMP #&11
 BCC l_317a
 RTS

.l_318e

 LDA &74
 AND #&1F
 LDY home_econ
 STA &75
 CLC
 LDA #&00
 STA cmdr_avail+&10

.l_319d

 DEY
 BMI l_31a5
 ADC &75
 JMP l_319d

.l_31a5

 STA &76
 RTS

.l_31ab

 JSR l_309f
 LDX #&05

.l_31b0

 LDA &6C,X
 STA &03B2,X
 DEX
 BPL l_31b0
 INX
 STX &0349
 LDA data_econ
 STA home_econ
 LDA data_tech
 STA home_tech
 LDA data_govm
 STA home_govmt
 JSR l_3f86
 STA cmdr_price
 LDX #&00
 STX &96

.l_31d8

 LDA l_4619+&01,X
 STA &74
 JSR l_318e
 LDA l_4619+&03,X
 AND cmdr_price
 CLC
 ADC l_4619+&02,X
 LDY &74
 BMI l_31f4
 SEC
 SBC &76
 JMP l_31f7

.l_31f4

 CLC
 ADC &76

.l_31f7

 BPL l_31fb
 LDA #&00

.l_31fb

 LDY &96
 AND #&3F
 STA cmdr_avail,Y
 INY
 TYA
 STA &96
 ASL A
 ASL A
 TAX
 CMP #&3F
 BCC l_31d8
 RTS

.l_320e

 JSR l_3f62
 LDA #&FF
 STA &66
 LDA #&1D
 JSR l_3768
 LDA #&1E
 JMP l_3768

.l_3226

 LDA #&03
 JSR l_427e
 LDA #&03
 JSR l_54c8
 JSR l_2623
 JSR l_3ee1
 STY &0341

.l_3239

 JSR l_320e
 LDA #&03
 CMP &033B
 BCS l_3239
 STA &03C3
 LDX #&00
 JSR l_5493
 LDA cmdr_homey
 EOR #&1F
 STA cmdr_homey

.r_rts

 RTS

.l_3254

 LDA cmdr_fuel
 SEC
 SBC hype_dist
 STA cmdr_fuel

.hyper_snap

 LDA &87
 BNE l_3268
 JSR l_54c8
 JSR l_2623

.l_3268

 \	JSR l_4437
 \	AND x_flag
 \	BMI l_321f
 JSR l_3f86
 CMP #&FD
 BCS l_3226
 JSR l_31ab
 JSR l_3ee1
 JSR l_3580
 JSR l_4255
 LDA &87
 AND #&3F
 BNE r_rts
 JSR l_54ca
 LDA &87
 BNE l_32c8
 INC &87

.l_3292

 LDX &8E
 BEQ l_32c1
 JSR l_2636
 JSR l_3ee1
 JSR l_2f75
 INC &4E
 JSR l_356d
 LDA #&80
 STA &4E
 INC &4D
 JSR l_3740
 LDA #&0C
 STA &7D
 JSR l_41a6
 ORA cmdr_legal
 STA cmdr_legal
 LDA #&FF
 STA &87
 JSR l_2642

.l_32c1

 LDX #&00
 STX &8E
 JMP l_5493

.l_32c8

 BMI l_32cd
 JMP l_2ceb

.l_32cd

 JMP l_2ebe

\ a.dcode_2

.l_32d0

 TXA
 CLC
 ADC cmdr_money+&03
 STA cmdr_money+&03
 TYA
 ADC cmdr_money+&02
 STA cmdr_money+&02
 BCC l_32f0
 INC cmdr_money+&01
 BNE n_addmny
 INC cmdr_money

.n_addmny

 CLC

.l_32f0

 RTS

.l_32f4

 ASL &1B
 ROL A
 ASL &1B
 ROL A
 TAY
 LDX &1B
 RTS

.l_32fe

 JSR l_2e65
 JSR l_2f75
 JSR l_2e65
 JMP l_5537

.l_330a

 LDX #&05

.l_330c

 LDA &6C,X
 STA &73,X
 DEX
 BPL l_330c
 LDY #&03
 BIT &6C
 BVS l_331a
 DEY

.l_331a

 STY &D1

.l_331c

 LDA &71
 AND #&1F
 BEQ l_3327
 ORA #&80
 JSR l_339a

.l_3327

 JSR l_2b14
 DEC &D1
 BPL l_331c
 LDX #&05

.l_3330

 LDA &73,X
 STA &6C,X
 DEX
 BPL l_3330
 RTS

.l_3338

 LDY #&00

.l_333a

 LDA &0350,Y
 CMP #&0D
 BEQ l_3347
 JSR wrchdst
 INY
 BNE l_333a

.l_3347

 RTS

.l_3348

 JSR l_334e
 JSR l_330a

.l_334e

 LDX #&05

.l_3350

 LDA &6C,X
 LDY &03B2,X
 STA &03B2,X
 STY &6C,X
 DEX
 BPL l_3350
 RTS

.l_335e

 LDX cmdr_galxy
 INX
 JMP c_1e38

.l_3366

 LDA #&69
 JSR l_3395
 LDX cmdr_fuel
 SEC
 JSR l_1e38
 LDA #&C3
 JSR l_338f
 LDA #&77
 BNE l_339a

.l_337b

 LDX #&03

.l_337d

 LDA cmdr_money,X
 STA &40,X
 DEX
 BPL l_337d
 LDA #&09
 STA &80
 SEC
 JSR l_1e48
 LDA #&E2

.l_338f

 JSR l_339a
 JMP l_2b60

.l_3395

 JSR l_339a

.l_3398

 LDA #&3A

.l_339a

 TAX
 BEQ l_337b
 BMI l_3413
 DEX
 BEQ l_335e
 DEX
 BEQ l_3348
 DEX
 BNE l_33ab
 JMP l_330a

.l_33ab

 DEX
 BEQ l_3338
 DEX
 BEQ l_3366
 DEX
 BNE l_33b9

.vdu_80

 LDX #&80
 EQUB &2C

.vdu_00

 LDX #&00
 STX vdu_stat
 RTS

.l_33b9

 DEX
 DEX
 BEQ vdu_00
 DEX
 BEQ l_33fb
 CMP #&60
 BCS l_342d
 CMP #&0E
 BCC l_33cf
 CMP #&20
 BCC l_33f7

.l_33cf

 LDX vdu_stat
 BEQ l_3410
 BMI l_33e6
 BIT vdu_stat
 BVS l_3409

.l_33d9

 CMP #&41
 BCC l_33e3
 CMP #&5B
 BCS l_33e3
 ADC #&20

.l_33e3

 JMP wrchdst

.l_33e6

 BIT vdu_stat
 BVS l_3401
 CMP #&41
 BCC l_3410
 PHA
 TXA
 ORA #&40
 STA vdu_stat
 PLA
 BNE l_33e3

.l_33f7

 ADC #&72
 BNE l_342d

.l_33fb

 LDA #&15
 STA cursor_x
 BNE l_3398

.l_3401

 CPX #&FF
 BEQ l_3468
 CMP #&41
 BCS l_33d9

.l_3409

 PHA
 TXA
 AND #&BF
 STA vdu_stat
 PLA

.l_3410

 JMP wrchdst

.l_3413

 CMP #&A0
 BCS l_342b
 AND #&7F
 ASL A
 TAY
 LDA &0880,Y
 JSR l_339a
 LDA &0881,Y
 CMP #&3F
 BEQ l_3468
 JMP l_339a

.l_342b

 SBC #&A0

.l_342d

 TAX
 LDY #&00
 STY &22
 LDA #&04
 STA &23
 TXA
 BEQ l_344e

.l_343b

 LDA (&22),Y
 BEQ l_3446
 INY
 BNE l_343b
 INC &23
 BNE l_343b

.l_3446

 INY
 BNE l_344b
 INC &23

.l_344b

 DEX
 BNE l_343b

.l_344e

 TYA
 PHA
 LDA &23
 PHA
 LDA (&22),Y
 EOR #&23
 JSR l_339a
 PLA
 STA &23
 PLA
 TAY
 INY
 BNE l_3464
 INC &23

.l_3464

 LDA (&22),Y
 BNE l_344e

.l_3468

 RTS

.l_3469

 LDA &65
 ORA #&A0
 STA &65
 RTS

.l_3470

 LDA &65
 AND #&40
 BEQ l_3479
 JSR l_34d3

.l_3479

 LDA &4C
 STA &D1
 LDA &4D
 CMP #&20
 BCC l_3487
 LDA #&FE
 BNE l_348f

.l_3487

 ASL &D1
 ROL A
 ASL &D1
 ROL A
 SEC
 ROL A

.l_348f

 STA &81
 LDY #&01
 LDA (&67),Y
 ADC #&04
 BCS l_3469
 STA (&67),Y
 JSR l_2965
 LDA &1B
 CMP #&1C
 BCC l_34a8
 LDA #&FE
 BNE l_34b1

.l_34a8

 ASL &82
 ROL A
 ASL &82
 ROL A
 ASL &82
 ROL A

.l_34b1

 DEY
 STA (&67),Y
 LDA &65
 AND #&BF
 STA &65
 AND #&08
 BEQ l_3468
 LDY #&02
 LDA (&67),Y
 TAY

.l_34c3

 LDA &F9,Y
 STA (&67),Y
 DEY
 CPY #&06
 BNE l_34c3
 LDA &65
 ORA #&40
 STA &65

.l_34d3

 LDY #&00
 LDA (&67),Y
 STA &81
 INY
 LDA (&67),Y
 BPL l_34e0
 EOR #&FF

.l_34e0

 LSR A
 LSR A
 LSR A
 ORA #&01
 STA &80
 INY
 LDA (&67),Y
 STA &8F
 LDA &01
 PHA
 LDY #&06

.l_34f1

 LDX #&03

.l_34f3

 INY
 LDA (&67),Y
 STA &D2,X
 DEX
 BPL l_34f3
 STY &93
 LDY #&02

.l_34ff

 INY
 LDA (&67),Y
 EOR &93
 STA &FFFD,Y
 CPY #&06
 BNE l_34ff
 LDY &80

.l_350d

 JSR l_3f85
 STA &88
 LDA &D3
 STA &82
 LDA &D2
 JSR l_354b
 BNE l_3545
 CPX #&BF
 BCS l_3545
 STX &35
 LDA &D5
 STA &82
 LDA &D4
 JSR l_354b
 BNE l_3533
 LDA &35
 JSR l_1932

.l_3533

 DEY
 BPL l_350d
 LDY &93
 CPY &8F
 BCC l_34f1
 PLA
 STA &01
 LDA &0906
 STA &03
 RTS

.l_3545

 JSR l_3f85
 JMP l_3533

.l_354b

 STA &83
 JSR l_3f85
 ROL A
 BCS l_355e
 JSR l_2847
 ADC &82
 TAX
 LDA &83
 ADC #&00
 RTS

.l_355e

 JSR l_2847
 STA &D1
 LDA &82
 SBC &D1
 TAX
 LDA &83
 SBC #&00
 RTS

.l_356d

 JSR l_3f3b
 LDA #&7F
 STA &63
 STA &64
 LDA home_tech
 AND #&02
 ORA #&80
 JMP l_3768

.l_3580

 LDA hype_dist
 LDY #3

.legal_div

 LSR hype_dist+1
 ROR A
 DEY
 BNE legal_div
 SEC
 SBC cmdr_legal
 BCC legal_over
 LDA #&FF

.legal_over

 EOR #&FF
 STA cmdr_legal
 \	LDA cmdr_legal
 \	BEQ legal_over
 \legal_next
 \	DEC cmdr_legal
 \	LSR a
 \	BNE legal_next
 \legal_over
 \\	LSR cmdr_legal
 JSR l_3f26
 LDA &6D
 AND #&03
 ADC #&03
 STA &4E
 ROR A
 STA &48
 STA &4B
 JSR l_356d
 LDA &6F
 AND #&07
 ORA #&81
 STA &4E
 LDA &71
 AND #&03
 STA &48
 STA &47
 LDA #&00
 STA &63
 STA &64
 LDA #&81
 JSR l_3768

.l_35b1

 LDA &87
 BNE l_35d8

.l_35b5

 LDY &03C3

.l_35b8

 JSR l_3f86
 ORA #&08
 STA &0FA8,Y
 STA &88
 JSR l_3f86
 STA &0F5C,Y
 STA &34
 JSR l_3f86
 STA &0F82,Y
 STA &35
 JSR l_1910
 DEY
 BNE l_35b8

.l_35d8

 LDX #&00

.l_35da

 LDA ship_type,X
 BEQ l_3602
 BMI l_35ff
 STA &8C
 JSR ship_ptr
 LDY #&1F

.l_35e8

 LDA (&20),Y
 STA &46,Y
 DEY
 BPL l_35e8
 STX &84
 JSR l_5558
 LDX &84
 LDY #&1F
 LDA (&20),Y
 AND #&A7
 STA (&20),Y

.l_35ff

 INX
 BNE l_35da

.l_3602

 LDX #&FF
 STX &0EC0
 STX &0F0E

.l_360a

 LDY #&BF
 LDA #&00

.l_360e

 STA &0E00,Y
 DEY
 BNE l_360e
 DEY
 STY &0E00
 RTS

.l_3619

 LDA #&06
 SEI
 STA &FE00
 STX &FE01
 CLI
 RTS

.l_3624

 DEX
 RTS

.l_3626

 INX
 BEQ l_3624

.l_3629

 DEC energy
 PHP
 BNE l_3632
 INC energy

.l_3632

 PLP
 RTS

.l_3642

 ASL A
 TAX
 LDA #&00
 ROR A
 TAY
 LDA #&14
 STA &81
 TXA
 JSR l_2965
 LDX &1B
 TYA
 BMI l_3658
 LDY #&00
 RTS

.l_3658

 LDY #&FF
 TXA
 EOR #&FF
 TAX
 INX
 RTS

.l_3634

 JSR l_3694
 LDY #&25
 LDA &0320
 BNE l_station
 LDY &9F	\ finder

.l_station

 JSR l_42ae
 LDA &34
 JSR l_3642
 TXA
 ADC #&C3
 STA &03A8
 LDA &35
 JSR l_3642
 STX &D1
 LDA #&CC
 SBC &D1
 STA &03A9
 LDA #&F0
 LDX &36
 BPL l_3691
 LDA #&FF

.l_3691

 STA &03C5

.l_3694

 LDA &03A9
 STA &35
 LDA &03A8
 STA &34
 LDA &03C5
 STA &91
 CMP #&F0
 BNE l_36ac

.l_36a7

 JSR l_36ac
 DEC &35

.l_36ac

 LDA &35
 TAY
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA ptr+&01
 LDA &34
 AND #&F8
 STA ptr
 TYA
 AND #&07
 TAY
 LDA &34
 AND #&06
 LSR A
 TAX
 LDA pixels+&10,X
 AND &91
 EOR (ptr),Y
 STA (ptr),Y
 LDA pixels+&11,X
 BPL l_36dd
 LDA ptr
 ADC #&08
 STA ptr
 LDA pixels+&11,X

.l_36dd

 AND &91
 EOR (ptr),Y
 STA (ptr),Y
 RTS

.l_36e4

 SEC	\ reduce damage
 SBC new_shields
 BCC n_shok

.n_through

 STA &D1
 LDX #&00
 LDY #&08
 LDA (&20),Y
 BMI l_36fe
 LDA f_shield
 SBC &D1
 BCC l_36f9
 STA f_shield

.n_shok

 RTS

.l_36f9

 STX f_shield
 BCC l_370c

.l_36fe

 LDA r_shield
 SBC &D1
 BCC l_3709
 STA r_shield
 RTS

.l_3709

 STX r_shield

.l_370c

 ADC energy
 STA energy
 BEQ l_3716
 BCS l_3719

.l_3716

 JMP l_41c6

.l_3719

 JSR l_43b1
 JMP l_45ea

.l_371f

 LDA &0901,Y
 STA &D2,X
 LDA &0902,Y
 PHA
 AND #&7F
 STA &D3,X
 PLA
 AND #&80
 STA &D4,X
 INY
 INY
 INY
 INX
 INX
 INX
 RTS

.ship_ptr

 TXA
 ASL A
 TAY
 LDA l_1695,Y
 STA &20
 LDA l_1695+&01,Y
 STA &21
 RTS

.l_3740

 JSR l_3821
 LDX #&81
 STX &66
 LDX #&FF
 STX &63
 INX
 STX &64
 STX ship_type+&01
 STX &67
 LDA cmdr_legal
 BPL n_enemy
 LDX #&04

.n_enemy

 STX &6A
 LDX #&0A
 JSR l_37fc
 JSR l_37fc
 STX &68
 JSR l_37fc
 LDA #&02

.l_3768

 STA &D1
 LDX #&00

.l_376c

 LDA ship_type,X
 BEQ l_3778
 INX
 CPX #&0C
 BCC l_376c

.l_3776

 CLC

.l_3777

 RTS

.l_3778

 JSR ship_ptr
 LDA &D1
 BMI l_37d1
 ASL A
 TAY
 LDA &55FF,Y
 BEQ l_3776
 STA &1F
 LDA &55FE,Y
 STA &1E
 CPY #&04
 BEQ l_37c1
 LDY #&05
 LDA (&1E),Y
 STA &06
 LDA &03B0
 SEC
 SBC &06
 STA &67
 LDA &03B1
 SBC #&00
 STA &68
 LDA &67
 SBC &20
 TAY
 LDA &68
 SBC &21
 BCC l_3777
 BNE l_37b7
 CPY #&25
 BCC l_3777

.l_37b7

 LDA &67
 STA &03B0
 LDA &68
 STA &03B1

.l_37c1

 LDY #&0E
 LDA (&1E),Y
 STA &69
 LDY #&13
 LDA (&1E),Y
 AND #&07
 STA &65
 LDA &D1

.l_37d1

 STA ship_type,X
 TAX
 BMI l_37e5
 CPX #&03
 BCC l_37e2
 CPX #&0B
 BCS l_37e2
 INC &033E

.l_37e2

 INC &031E,X

.l_37e5

 LDY &D1
 LDA l_563d,Y
 AND #&6F
 ORA &6A
 STA &6A
 LDY #&24

.l_37f2

 LDA &46,Y
 STA (&20),Y
 DEY
 BPL l_37f2
 SEC
 RTS

.l_37fc

 LDA &46,X
 EOR #&80
 STA &46,X
 INX
 INX
 RTS

.l_3805

 LDX #&FF

.l_3807

 STX &45
 LDX cmdr_misl
 DEX
 JSR l_383d
 STY target
 RTS

.l_3813

 LDA #&20
 STA &30
 ASL A
 JSR l_43f3

.l_381b

 LDA #&38
 LDX #LO(l_3832)
 BNE l_3825

.l_3821

 LDA #&C0
 LDX #LO(l_3832)+3

.l_3825

 LDY #HI(l_3832)
 STA ptr
 LDA #&7D
 STX font
 STY font+&01
 JMP l_1f45

.l_3832

 EQUB &E0, &E0, &80, &E0, &E0, &80, &E0, &E0, &20, &E0, &E0

.l_383d

 CPX #4
 BCC n_mok
 LDX #3

.n_mok

 TXA
 ASL A
 ASL A
 ASL A
 STA &D1
 LDA #&31-8
 SBC &D1
 STA ptr
 LDA #&7E
 STA ptr+&01
 TYA
 LDY #&05

.l_3850

 STA (ptr),Y
 DEY
 BNE l_3850
 RTS

.l_3856

 LDA &46
 STA &1B
 LDA &47
 STA font
 LDA &48
 JSR l_3cfa
 BCS l_388d
 LDA &40
 ADC #&80
 STA &D2
 TXA
 ADC #&00
 STA &D3
 LDA &49
 STA &1B
 LDA &4A
 STA font
 LDA &4B
 EOR #&80
 JSR l_3cfa
 BCS l_388d
 LDA &40
 ADC #&60
 STA &E0
 TXA
 ADC #&00
 STA &E1
 CLC

.l_388d

 RTS

.l_388e

 LDA &8C
 LSR A
 BCS l_3896
 JMP l_3bed

.l_3896

 JMP l_3c30

.l_3899

 LDA &4E
 BMI l_388e
 CMP #&30
 BCS l_388e
 ORA &4D
 BEQ l_388e
 JSR l_3856
 BCS l_388e
 LDA #&60
 STA font
 LDA #&00
 STA &1B
 JSR l_297e
 LDA &41
 BEQ l_38bd
 LDA #&F8
 STA &40

.l_38bd

 LDA &8C
 LSR A
 BCC l_38c5
 JMP l_3a54

.l_38c5

 JSR l_3bed
 JSR l_3b76
 BCS l_38d1
 LDA &41
 BEQ l_38d2

.l_38d1

 RTS

.l_38d2

 LDA &8C
 CMP #&80
 BNE l_3914
 LDA &40
 CMP #&06
 BCC l_38d1
 LDA &54
 EOR #&80
 STA &1B
 LDA &5A
 JSR l_3cdb
 LDX #&09
 JSR l_3969
 STA &9B
 STY &09
 JSR l_3969
 STA &9C
 STY &0A
 LDX #&0F
 JSR l_3ceb
 JSR l_3987
 LDA &54
 EOR #&80
 STA &1B
 LDA &60
 JSR l_3cdb
 LDX #&15
 JSR l_3ceb
 JMP l_3987

.l_3914

 LDA &5A
 BMI l_38d1
 LDX #&0F
 JSR l_3cba
 CLC
 ADC &D2
 STA &D2
 TYA
 ADC &D3
 STA &D3
 JSR l_3cba
 STA &1B
 LDA &E0
 SEC
 SBC &1B
 STA &E0
 STY &1B
 LDA &E1
 SBC &1B
 STA &E1
 LDX #&09
 JSR l_3969
 LSR A
 STA &9B
 STY &09
 JSR l_3969
 LSR A
 STA &9C
 STY &0A
 LDX #&15
 JSR l_3969
 LSR A
 STA &9D
 STY &0B
 JSR l_3969
 LSR A
 STA &9E
 STY &0C
 LDA #&40
 STA &8F
 LDA #&00
 STA &94
 BEQ l_398b

.l_3969

 LDA &46,X
 STA &1B
 LDA &47,X
 AND #&7F
 STA font
 LDA &47,X
 AND #&80
 JSR l_297e
 LDA &40
 LDY &41
 BEQ l_3982
 LDA #&FE

.l_3982

 LDY &43
 INX
 INX
 RTS

.l_3987

 LDA #&1F
 STA &8F

.l_398b

 LDX #&00
 STX &93
 DEX
 STX &92

.l_3992

 LDA &94
 AND #&1F
 TAX
 LDA &07C0,X
 STA &81
 LDA &9D
 JSR l_2847
 STA &82
 LDA &9E
 JSR l_2847
 STA &40
 LDX &94
 CPX #&21
 LDA #&00
 ROR A
 STA &0E
 LDA &94
 CLC
 ADC #&10
 AND #&1F
 TAX
 LDA &07C0,X
 STA &81
 LDA &9C
 JSR l_2847
 STA &42
 LDA &9B
 JSR l_2847
 STA &1B
 LDA &94
 ADC #&0F
 AND #&3F
 CMP #&21
 LDA #&00
 ROR A
 STA &0D
 LDA &0E
 EOR &0B
 STA &83
 LDA &0D
 EOR &09
 JSR l_28ff
 STA &D1
 BPL l_39fb
 TXA
 EOR #&FF
 CLC
 ADC #&01
 TAX
 LDA &D1
 EOR #&7F
 ADC #&00
 STA &D1

.l_39fb

 TXA
 ADC &D2
 STA &76
 LDA &D1
 ADC &D3
 STA &77
 LDA &40
 STA &82
 LDA &0E
 EOR &0C
 STA &83
 LDA &42
 STA &1B
 LDA &0D
 EOR &0A
 JSR l_28ff
 EOR #&80
 STA &D1
 BPL l_3a30
 TXA
 EOR #&FF
 CLC
 ADC #&01
 TAX
 LDA &D1
 EOR #&7F
 ADC #&00
 STA &D1

.l_3a30

 JSR l_196b
 CMP &8F
 BEQ l_3a39
 BCS l_3a45

.l_3a39

 LDA &94
 CLC
 ADC &95
 AND #&3F
 STA &94
 JMP l_3992

.l_3a45

 RTS

.l_3a46

 JMP l_3c30

.l_3a49

 TXA
 EOR #&FF
 TAX
 INX

.l_3a50

 LDA #&FF
 BNE l_3a99

.l_3a54

 LDA #&01
 STA &0E00
 JSR l_3c80
 BCS l_3a46
 LDA #&00
 LDX &40
 CPX #&60
 ROL A
 CPX #&28
 ROL A
 CPX #&10
 ROL A
 STA &93
 LDA #&BF
 LDX font+&01
 BNE l_3a7d
 CMP font
 BCC l_3a7d
 LDA font
 BNE l_3a7d
 LDA #&01

.l_3a7d

 STA &8F
 LDA #&BF
 SEC
 SBC &E0
 TAX
 LDA #&00
 SBC &E1
 BMI l_3a49
 BNE l_3a95
 INX
 DEX
 BEQ l_3a50
 CPX &40
 BCC l_3a99

.l_3a95

 LDX &40
 LDA #&00

.l_3a99

 STX &22
 STA &23
 LDA &40
 JSR l_280d
 STA &9C
 LDA &1B
 STA &9B
 LDY #&BF
 LDA &28
 STA &26
 LDA &29
 STA &27

.l_3ab2

 CPY &8F
 BEQ l_3ac1
 LDA &0E00,Y
 BEQ l_3abe
 JSR l_185e

.l_3abe

 DEY
 BNE l_3ab2

.l_3ac1

 LDA &22
 JSR l_280d
 STA &D1
 LDA &9B
 SEC
 SBC &1B
 STA &81
 LDA &9C
 SBC &D1
 STA &82
 STY &35
 JSR l_47b8
 LDY &35
 JSR l_3f86
 AND &93
 CLC
 ADC &81
 BCC l_3ae8
 LDA #&FF

.l_3ae8

 LDX &0E00,Y
 STA &0E00,Y
 BEQ l_3b3a
 LDA &28
 STA &26
 LDA &29
 STA &27
 TXA
 JSR l_3c4f
 LDA &34
 STA &24
 LDA &36
 STA &25
 LDA &D2
 STA &26
 LDA &D3
 STA &27
 LDA &0E00,Y
 JSR l_3c4f
 BCS l_3b1f
 LDA &36
 LDX &24
 STX &36
 STA &24
 JSR l_1868

.l_3b1f

 LDA &24
 STA &34
 LDA &25
 STA &36

.l_3b27

 JSR l_1868

.l_3b2a

 DEY
 BEQ l_3b6c
 LDA &23
 BNE l_3b4e
 DEC &22
 BNE l_3ac1
 DEC &23

.l_3b37

 JMP l_3ac1

.l_3b3a

 LDX &D2
 STX &26
 LDX &D3
 STX &27
 JSR l_3c4f
 BCC l_3b27
 LDA #&00
 STA &0E00,Y
 BEQ l_3b2a

.l_3b4e

 LDX &22
 INX
 STX &22
 CPX &40
 BCC l_3b37
 BEQ l_3b37
 LDA &28
 STA &26
 LDA &29
 STA &27

.l_3b61

 LDA &0E00,Y
 BEQ l_3b69
 JSR l_185e

.l_3b69

 DEY
 BNE l_3b61

.l_3b6c

 CLC
 LDA &D2
 STA &28
 LDA &D3
 STA &29

.l_3b75

 RTS

.l_3b76

 JSR l_3c80
 BCS l_3b75
 LDA #&00
 STA &0EC0
 LDX &40
 LDA #&08
 CPX #&08
 BCC l_3b8e
 LSR A
 CPX #&3C
 BCC l_3b8e
 LSR A

.l_3b8e

 STA &95

.l_3b90

 LDX #&FF
 STX &92
 INX
 STX &93

.l_3b97

 LDA &93
 JSR l_283d
 LDX #&00
 STX &D1
 LDX &93
 CPX #&21
 BCC l_3bb3
 EOR #&FF
 ADC #&00
 TAX
 LDA #&FF
 ADC #&00
 STA &D1
 TXA
 CLC

.l_3bb3

 ADC &D2
 STA &76
 LDA &D3
 ADC &D1
 STA &77
 LDA &93
 CLC
 ADC #&10
 JSR l_283d
 TAX
 LDA #&00
 STA &D1
 LDA &93
 ADC #&0F
 AND #&3F
 CMP #&21
 BCC l_3be1
 TXA
 EOR #&FF
 ADC #&00
 TAX
 LDA #&FF
 ADC #&00
 STA &D1
 CLC

.l_3be1

 JSR l_196b
 CMP #&41
 BCS l_3beb
 JMP l_3b97

.l_3beb

 CLC
 RTS

.l_3bed

 LDY &0EC0
 BNE l_3c26

.l_3bf2

 CPY &6B
 BCS l_3c26
 LDA &0F0E,Y
 CMP #&FF
 BEQ l_3c17
 STA &37
 LDA &0EC0,Y
 STA &36
 JSR l_16c4
 INY
 LDA &90
 BNE l_3bf2
 LDA &36
 STA &34
 LDA &37
 STA &35
 JMP l_3bf2

.l_3c17

 INY
 LDA &0EC0,Y
 STA &34
 LDA &0F0E,Y
 STA &35
 INY
 JMP l_3bf2

.l_3c26

 LDA #&01
 STA &6B
 LDA #&FF
 STA &0EC0

.l_3c2f

 RTS

.l_3c30

 LDA &0E00
 BMI l_3c2f
 LDA &28
 STA &26
 LDA &29
 STA &27
 LDY #&BF

.l_3c3f

 LDA &0E00,Y
 BEQ l_3c47
 JSR l_185e

.l_3c47

 DEY
 BNE l_3c3f
 DEY
 STY &0E00
 RTS

.l_3c4f

 STA &D1
 CLC
 ADC &26
 STA &36
 LDA &27
 ADC #&00
 BMI l_3c79
 BEQ l_3c62
 LDA #&FE
 STA &36

.l_3c62

 LDA &26
 SEC
 SBC &D1
 STA &34
 LDA &27
 SBC #&00
 BEQ n_clcrts
 BPL l_3c79
 LDA #&02
 STA &34

.n_clcrts

 CLC
 RTS

.l_3c79

 LDA #&00
 STA &0E00,Y
 SEC
 RTS

.l_3c80

 LDA &D2
 CLC
 ADC &40
 LDA &D3
 ADC #&00
 BMI l_3cb8
 LDA &D2
 SEC
 SBC &40
 LDA &D3
 SBC #&00
 BMI l_3c98
 BNE l_3cb8

.l_3c98

 LDA &E0
 CLC
 ADC &40
 STA font
 LDA &E1
 ADC #&00
 BMI l_3cb8
 STA font+&01
 LDA &E0
 SEC
 SBC &40
 TAX
 LDA &E1
 SBC #&00
 BMI l_3d1d
 BNE l_3cb8
 CPX #&BF
 RTS

.l_3cb8

 SEC
 RTS

.l_3cba

 JSR l_3969
 STA &1B
 LDA #&DE
 STA &81
 STX &80
 JSR l_2820
 LDX &80
 LDY &43
 BPL l_3cd8
 EOR #&FF
 CLC
 ADC #&01
 BEQ l_3cd8
 LDY #&FF
 RTS

.l_3cd8

 LDY #&00
 RTS

.l_3cdb

 STA &81
 JSR l_2a3c
 LDX &54
 BMI l_3ce6
 EOR #&80

.l_3ce6

 LSR A
 LSR A
 STA &94
 RTS

.l_3ceb

 JSR l_3969
 STA &9D
 STY &0B
 JSR l_3969
 STA &9E
 STY &0C
 RTS

.l_3cfa

 JSR l_297e
 LDA &43
 AND #&7F
 ORA &42
 BNE l_3cb8
 LDX &41
 CPX #&04
 BCS l_3d1e
 LDA &43
 BPL l_3d1e
 LDA &40
 EOR #&FF
 ADC #&01
 STA &40
 TXA
 EOR #&FF
 ADC #&00
 TAX

.l_3d1d

 CLC

.l_3d1e

 RTS

.l_3d1f

 JSR l_44af
 LDA k_flag
 BEQ l_3d4c
 LDA adval_x
 EOR #&FF
 JSR l_3d34
 TYA
 TAX
 LDA adval_y

.l_3d34

 TAY
 LDA #&00
 CPY #&10
 SBC #&00
 CPY #&40
 SBC #&00
 CPY #&C0
 ADC #&00
 CPY #&E0
 ADC #&00
 TAY
 LDA last_key
 RTS

.l_3d4c

 LDA last_key
 LDX #&00
 LDY #&00
 CMP #&19
 BNE l_3d58
 DEX

.l_3d58

 CMP #&79
 BNE l_3d5d
 INX

.l_3d5d

 CMP #&39
 BNE l_3d62
 INY

.l_3d62

 CMP #&29
 BNE l_3d67
 DEY

.l_3d67

 RTS

.l_3d68

 LDX #&01

.l_3d6a

 LDA cmdr_homex,X
 STA data_homex,X
 DEX
 BPL l_3d6a
 RTS

.l_3d74

 LDA &1B
 STA &03B0
 LDA font
 STA &03B1
 RTS

.l_3d7f

 LDX &84
 JSR l_3dd8
 LDX &84
 JMP l_1376

.l_3d89

 JSR l_3f26
 JSR l_360a
 STA ship_type+&01
 STA &0320
 JSR l_3821
 LDA #&06
 STA &4B
 LDA #&81
 JMP l_3768

.l_3da1

 LDX #&FF

.l_3da3

 INX
 LDA ship_type,X
 BEQ l_3d74
 CMP #&01
 BNE l_3da3
 TXA
 ASL A
 TAY
 LDA l_1695,Y
 STA ptr
 LDA l_1695+&01,Y
 STA ptr+&01
 LDY #&20
 LDA (ptr),Y
 BPL l_3da3
 AND #&7F
 LSR A
 CMP &96
 BCC l_3da3
 BEQ l_3dd2
 SBC #&01
 ASL A
 ORA #&80
 STA (ptr),Y
 BNE l_3da3

.l_3dd2

 LDA #&00
 STA (ptr),Y
 BEQ l_3da3

.l_3dd8

 STX &96
 CPX &45
 BNE l_3de8
 LDY #&EE
 JSR l_3805
 LDA #&C8
 JSR l_45c6

.l_3de8

 LDY &96
 LDX ship_type,Y
 CPX #&02
 BEQ l_3d89
 CPX #&1F
 BNE l_3dfd
 LDA cmdr_mission
 ORA #&02
 STA cmdr_mission

.l_3dfd

 CPX #&03
 BCC l_3e08
 CPX #&0B
 BCS l_3e08
 DEC &033E

.l_3e08

 DEC &031E,X
 LDX &96
 LDY #&05
 LDA (&1E),Y
 LDY #&21
 CLC
 ADC (&20),Y
 STA &1B
 INY
 LDA (&20),Y
 ADC #&00
 STA font

.l_3e1f

 INX
 LDA ship_type,X
 STA &0310,X
 BNE l_3e2b
 JMP l_3da1

.l_3e2b

 ASL A
 TAY
 LDA &55FE,Y
 STA ptr
 LDA &55FF,Y
 STA ptr+&01
 LDY #&05
 LDA (ptr),Y
 STA &D1
 LDA &1B
 SEC
 SBC &D1
 STA &1B
 LDA font
 SBC #&00
 STA font
 TXA
 ASL A
 TAY
 LDA l_1695,Y
 STA ptr
 LDA l_1695+&01,Y
 STA ptr+&01
 LDY #&24
 LDA (ptr),Y
 STA (&20),Y
 DEY
 LDA (ptr),Y
 STA (&20),Y
 DEY
 LDA (ptr),Y
 STA &41
 LDA font
 STA (&20),Y
 DEY
 LDA (ptr),Y
 STA &40
 LDA &1B
 STA (&20),Y
 DEY

.l_3e75

 LDA (ptr),Y
 STA (&20),Y
 DEY
 BPL l_3e75
 LDA ptr
 STA &20
 LDA ptr+&01
 STA &21
 LDY &D1

.l_3e86

 DEY
 LDA (&40),Y
 STA (&1B),Y
 TYA
 BNE l_3e86
 BEQ l_3e1f

.l_3e90

 EQUB &12, &01, &00, &10, &12, &02, &2C, &08, &11, &03, &F0, &18
 EQUB &10, &F1, &07, &1A, &03, &F1, &BC, &01, &13, &F4, &0C, &08
 EQUB &10, &F1, &06, &0C, &10, &02, &60, &10, &13, &04, &C2, &FF
 EQUB &13, &00, &00, &00

.rand_posn

 JSR l_3f26
 JSR l_3f86
 STA &46
 STX &49
 STA &06
 LSR A
 ROR &48
 LSR A
 ROR &4B
 LSR A
 STA &4A
 TXA
 AND #&1F
 STA &47
 LDA #&50
 SBC &47
 SBC &4A
 STA &4D
 JMP l_3f86

.l_3eb8

 LDX cmdr_galxy
 DEX
 BNE l_3ecc
 LDA cmdr_homex
 CMP #&90
 BNE l_3ecc
 LDA cmdr_homey
 CMP #&21
 BEQ l_3ecd

.l_3ecc

 CLC

.l_3ecd

 RTS

.l_3ece

 JSR clr_ships
 LDX #&08

.l_3ed3

 STA &2A,X
 DEX
 BPL l_3ed3
 TXA
 LDX #&02

.l_3edb

 STA f_shield,X
 DEX
 BPL l_3edb

.l_3ee1

 LDA #&12
 STA &03C3
 LDX #&FF
 STX &0EC0
 STX &0F0E
 STX &45
 LDA #&80
 STA adval_x
 STA adval_y
 ASL A
 STA &8A
 STA &2F
 LDA #&03
 STA &7D
 LDA &0320
 BEQ l_3f09
 JSR l_3821

.l_3f09

 LDA &30
 BEQ l_3f10
 JSR l_43a3

.l_3f10

 JSR l_35d8
 JSR clr_ships
 LDA #&FF
 STA &03B0
 LDA #&0C
 STA &03B1
 JSR l_1f62
 JSR l_44a4

.l_3f26

 LDY #&24
 LDA #&00

.l_3f2a

 STA &46,Y
 DEY
 BPL l_3f2a
 LDA #&60
 STA &58
 STA &5C
 ORA #&80
 STA &54
 RTS

.l_3f3b

 LDX #&03

.l_3f3d

 LDY #&00
 CPX cmdr_misl
 BCS miss_miss	\BCC l_3f4b
 LDY #&EE

.miss_miss

 JSR l_383d
 DEX
 BPL l_3f3d
 RTS
 \l_3f4b
 \	LDY #&EE
 \	JSR l_383d
 \	DEX
 \	BPL l_3f4b
 \	RTS

.l_3f54

 LDA &03A4
 JSR l_45c6
 LDA #&00
 STA &034A
 JMP l_3fcd

.l_3f62

 JSR rand_posn	\ IN
 CMP #&F5
 ROL A
 ORA #&C0
 STA &66

.l_3f85

 CLC

.l_3f86

 LDA &00
 ROL A
 TAX
 ADC &02
 STA &00
 STX &02
 LDA &01
 TAX
 ADC &03
 STA &01
 STX &03
 RTS

.l_3f9a

 JSR l_3f86
 LSR A
 STA &66
 STA &63
 ROL &65
 AND #&0F
 STA &61
 JSR l_3f86
 BMI l_3fb9
 LDA &66
 ORA #&C0
 STA &66
 LDX #&10
 STX &6A

.l_3fb9

 LDA #&0B
 LDX #&03
 JMP hordes

.l_3fc0

 JSR l_1228
 DEC &034A
 BEQ l_3f54
 BPL l_3fcd
 INC &034A

.l_3fcd

 DEC &8A
 BEQ l_3fd4

.l_3fd1

 JMP l_40db

.l_3fd4

 LDA &0341
 BNE l_3fd1
 JSR l_3f86
 CMP #&33	\ trader fraction
 BCS l_402e
 LDA &033E
 CMP #&03
 BCS l_402e
 JSR rand_posn	\ IN
 BVS l_3f9a
 ORA #&6F
 STA &63
 LDA &0320
 BNE l_4033
 TXA
 BCS l_401e
 AND #&0F
 STA &61
 BCC l_4022

.l_401e

 ORA #&7F
 STA &64

.l_4022

 JSR l_3f86
 CMP #&0A
 AND #&01
 ADC #&05
 BNE horde_plain

.l_402e

 LDA &0320
 BEQ l_4036

.l_4033

 JMP l_40db

.l_4036

 JSR l_41a6
 ASL A
 LDX &032E
 BEQ l_4042
 ORA cmdr_legal

.l_4042

 STA &D1
 JSR l_3f62
 CMP &D1
 BCS l_4050
 LDA #&10

.horde_plain

 LDX #&00
 BEQ hordes

.l_4050

 LDA &032E
 BNE l_4033
 DEC &0349
 BPL l_4033
 INC &0349
 LDA cmdr_mission
 AND #&0C
 CMP #&08
 BNE l_4070
 JSR l_3f86
 CMP #&C8
 BCC l_4070
 JSR l_320e

.l_4070

 JSR l_3f86
 LDY home_govmt
 BEQ l_4083
 CMP #&78
 BCS l_4033
 AND #&07
 CMP home_govmt
 BCC l_4033

.l_4083

 CPX #&64
 BCS l_40b2
 INC &0349
 AND #&03
 ADC #&19
 TAY
 JSR l_3eb8
 BCC l_40a8
 LDA #&F9
 STA &66
 LDA cmdr_mission
 AND #&03
 LSR A
 BCC l_40a8
 ORA &033D
 BEQ l_40aa

.l_40a8

 TYA
 EQUB &2C

.l_40aa

 LDA #&1F
 JSR l_3768
 JMP l_40db

.l_40b2

 LDA #&11
 LDX #&07

.hordes

 STA horde_base+1
 STX horde_mask+1
 JSR l_3f86
 CMP #&F8
 BCS horde_large
 STA &89
 TXA
 AND &89
 AND #&03

.horde_large

 AND #&07
 STA &0349
 STA &89

.l_40b9

 JSR l_3f86
 STA &D1
 TXA
 AND &D1

.horde_mask

 AND #&FF
 STA &0FD2

.l_40c8

 LDA &0FD2
 CLC

.horde_base

 ADC #&00
 INC &61	\ space out horde
 INC &47
 INC &4A
 JSR l_3768
 CMP #&18
 BCS l_40d7
 DEC &0FD2
 BPL l_40c8

.l_40d7

 DEC &89
 BPL l_40b9

.l_40db

 LDX #&FF
 TXS
 LDX laser_t
 BEQ l_40e6
 DEC laser_t

.l_40e6

 JSR l_1f62
 LDA &87
 BEQ l_40f8
 \	AND x_flag
 \	LSR A
 \	BCS l_40f8
 LDY #&02
 JSR l_5530

.l_40f8

 JSR l_3d1f

.l_40fb

 PHA
 LDA &2F
 BNE l_locked
 PLA
 JSR l_4101
 JMP l_3fc0

.l_locked

 PLA
 JSR l_416c
 JMP l_3fc0

.l_4101

 CMP #&76
 BNE l_4108
 JMP l_1c83

.l_4108

 CMP #&14
 BNE l_410f
 JMP l_2ceb

.l_410f

 CMP #&74
 BNE l_4116
 JMP l_2ebe

.l_4116

 CMP #&75
 BNE l_4120
 JSR l_2f75
 JMP l_2b73

.l_4120

 CMP #&77
 BNE l_4127
 JMP l_2e15

.l_4127

 CMP #&16
 BNE l_412e
 JMP l_3160

.l_412e

 CMP #&20
 BNE l_4135
 JMP l_3292

.l_4135

 CMP #&71
 BCC l_4143
 CMP #&74
 BCS l_4143
 AND #&03
 TAX
 JMP l_5493

.l_4143

 CMP #&54
 BNE l_414a
 JMP l_3011

.l_414a

 CMP #&32
 BEQ l_418b
 CMP #&43	\ planet finder
 BNE n_finder
 LDA &9F
 EOR #&25
 STA &9F
 JMP l_55f7	\RTS

.n_finder

 STA &06
 LDA &87
 AND #&C0
 BEQ l_416c
 LDA &06
 CMP #&36
 BNE l_notdist
 JSR l_2e65
 JSR l_3d68
 JMP l_2e65	\JSR l_2e65

.l_4169

 JSR l_2e38

.l_416c

 LDA &2F
 BEQ l_418a
 DEC &2E
 BNE l_418a
 LDX &2F
 DEX
 JSR l_30ac
 LDA #&05
 STA &2E
 LDX &2F
 JSR l_30ac
 DEC &2F
 BNE l_418a
 JMP l_3254

.l_41a6

 LDA cmdr_cargo+&03
 CLC
 ADC cmdr_cargo+&06
 ASL A
 ADC cmdr_cargo+&0A
 \	RTS

.l_418a

 RTS

.l_notdist

 CMP #&21
 BNE l_4169
 LDA cmdr_cour
 ORA cmdr_cour+1
 BEQ l_4169
 JSR l_2e65
 LDA cmdr_courx
 STA data_homex
 LDA cmdr_coury
 STA data_homey
 JSR l_2e65

.l_418b

 LDA &87
 AND #&C0
 BEQ l_418a
 JSR l_32fe
 STA vdu_stat
 JSR l_330a
 JSR vdu_80
 LDA #&01
 STA cursor_x
 INC cursor_y
 JMP l_2b3b

.l_41b2

 LDA #&E0

.l_41b4

 CMP &47
 BCC l_41be
 CMP &4A
 BCC l_41be
 CMP &4D

.l_41be

 RTS

.l_41bf

 ORA &47
 ORA &4A
 ORA &4D
 RTS

.l_41c6

 JSR l_43b1
 JSR l_3ee1
 ASL &7D
 ASL &7D
 LDX #&18
 JSR l_3619
 JSR l_54c8
 JSR l_54eb
 JSR l_35b5
 LDA #&0C
 STA cursor_y
 STA cursor_x
 LDA #&92
 JSR l_342d

.l_41e9

 JSR l_3f62
 LSR A
 LSR A
 STA &46
 LDY #&00
 STY &87
 STY &47
 STY &4A
 STY &4D
 STY &66
 DEY
 STY &8A
 STY &0346
 EOR #&2A
 STA &49
 ORA #&50
 STA &4C
 TXA
 AND #&8F
 STA &63
 ROR A
 AND #&87
 STA &64
 LDX #&05
 LDA &5607
 BEQ l_421e
 BCC l_421e
 DEX

.l_421e

 JSR l_251d
 JSR l_3f86
 AND #&80
 LDY #&1F
 STA (&20),Y
 LDA ship_type+&04
 BEQ l_41e9
 JSR l_44a4
 STA &7D

.l_4234

 JSR l_1228
 LDA &0346
 BNE l_4234
 LDX #&1F
 JSR l_3619
 JMP l_1220

.start

 JSR l_4255
 JSR l_3ece
 LDA #&FF
 STA &8E
 STA &87
 LDA #&20
 JMP l_40fb

.l_4255

 LDA #0
 STA &9F	\ reset finder
 JSR l_3eb8
 LDA #&06
 BCS l_427e
 JSR l_3f86
 AND #&03
 LDX home_govmt
 CPX #&03
 ROL A
 LDX home_tech
 CPX #&0A
 ROL A
 ADC cmdr_galxy	\ 16+7 -> 23 files !
 TAX
 LDA cmdr_mission
 AND #&0C
 CMP #&08
 BNE l_427d
 TXA
 AND #&01
 ORA #&02
 TAX

.l_427d

 TXA

.l_427e

 CLC
 ADC #&41
 STA d_mox+&04
 LDX #LO(d_mox)
 LDY #HI(d_mox)
 JMP oscli

.d_mox

 EQUS "L.S.0", &0D

.clr_ships

 LDX #&3A
 LDA #&00

.l_429a

 STA ship_type,X
 DEX
 BPL l_429a
 RTS

.l_42a1

 STX ptr+&01
 LDA #&00
 STA ptr
 TAY

.l_42a8

 STA (ptr),Y
 DEY
 BNE l_42a8
 RTS

.l_42ae

 LDX #&00
 JSR l_371f
 JSR l_371f
 JSR l_371f

.l_42bd

 LDA &D2
 ORA &D5
 ORA &D8
 ORA #&01
 STA &DB
 LDA &D3
 ORA &D6
 ORA &D9

.l_42cd

 ASL &DB
 ROL A
 BCS l_42e0
 ASL &D2
 ROL &D3
 ASL &D5
 ROL &D6
 ASL &D8
 ROL &D9
 BCC l_42cd

.l_42e0

 LDA &D3
 LSR A
 ORA &D4
 STA &34
 LDA &D6
 LSR A
 ORA &D7
 STA &35
 LDA &D9
 LSR A
 ORA &DA
 STA &36

.l_42f5

 LDA &34
 JSR l_280b
 STA &82
 LDA &1B
 STA &81
 LDA &35
 JSR l_280b
 \	STA &D1
 TAY
 LDA &1B
 ADC &81
 STA &81
 \	LDA &D1
 TYA
 ADC &82
 STA &82
 LDA &36
 JSR l_280b
 \	STA &D1
 TAY
 LDA &1B
 ADC &81
 STA &81
 \	LDA &D1
 TYA
 ADC &82
 STA &82
 JSR l_47b8
 LDA &34
 JSR l_46ff
 STA &34
 LDA &35
 JSR l_46ff
 STA &35
 LDA &36
 JSR l_46ff
 STA &36
 RTS

.l_433f

 LDX #&10

.l_4341

 JSR l_4439
 BMI l_434a
 INX
 BPL l_4341
 TXA

.l_434a

 EOR #&80
 TAX
 RTS

.l_434e

 LDX &033E
 LDA ship_type+&02,X
 ORA &033E	\ no jump if any ship
 ORA &0320
 ORA &0341
 BNE l_439f
 LDY &0908
 BMI l_4368
 TAY
 JSR l_1c43
 LSR A
 BEQ l_439f

.l_4368

 LDY &092D
 BMI l_4375
 LDY #&25
 JSR l_1c41
 LSR A
 BEQ l_439f

.l_4375

 LDA #&81
 STA &83
 STA &82
 STA &1B
 LDA &0908
 JSR l_28ff
 STA &0908
 LDA &092D
 JSR l_28ff
 STA &092D
 LDA #&01
 STA &87
 STA &8A
 LSR A
 STA &0349
 LDX view_dirn
 JMP l_5493

.l_439f

 LDA #&28
 BNE l_43f3

.l_43a3

 LDA #&00
 STA &30
 STA &0340
 JSR l_381b
 LDA #&48
 BNE l_43f3

.l_43b1

 JSR n_sound10
 LDA #&18
 BNE l_43f3

.l_43ba

 LDA #&20
 BNE l_43f3

.l_43be

 LDX #&01
 JSR l_2590
 BCC l_4418
 LDA #&78
 JSR l_45c6

.n_sound30

 LDA #&30
 BNE l_43f3

.l_43ce

 INC cmdr_kills
 BNE l_43db
 INC cmdr_kills+&01
 LDA #&65
 JSR l_45c6

.l_43db

 LDX #&07

.l_43dd

 STX &D1
 LDA #&18
 JSR l_4404
 LDA &4D
 LSR A
 LSR A
 AND &D1
 ORA #&F1
 STA &0B
 JSR l_43f6

.n_sound10

 LDA #&10

.l_43f3

 JSR l_4404

.l_43f6

 \	LDX s_flag
 LDY s_flag
 BNE l_4418
 LDX #&09
 \	LDY #&00
 LDA #&07
 JMP osword

.l_4404

 LSR A
 ADC #&03
 TAY
 LDX #&07

.l_440a

 LDA #&00
 STA &09,X
 DEX
 LDA l_3e90,Y
 STA &09,X
 DEY
 DEX
 BPL l_440a

.l_4418

 RTS

.l_4419

 EQUB &E8, &E2, &E6, &E7, &C2, &D1, &C1
 EQUB &60, &70, &23, &35, &65, &22, &45, &63, &37

.b_table

 EQUB &61, &31, &80, &80, &80, &80, &51
 EQUB &64, &34, &32, &62, &52, &54, &58, &38, &68

.b_13

 LDA #&00

.b_14

 TAX
 EOR b_table-1,Y
 BEQ b_quit
 STA &FE60
 AND #&0F
 AND &FE60
 BEQ b_pressed
 TXA
 BMI b_13
 RTS

.l_4429

 LDA b_flag
 BMI b_14
 LDX l_4419-1,Y
 JSR l_4439
 BPL b_quit

.b_pressed

 LDA #&FF
 STA last_key,Y

.b_quit

 RTS

.l_4437

 LDX #&01

.l_4439

 LDA #&03
 SEI
 STA &FE40
 LDA #&7F
 STA &FE43
 STX &FE4F
 LDX &FE4F
 LDA #&0B
 STA &FE40
 CLI
 TXA
 RTS

.l_4452

 LDA #&80
 JSR osbyte
 TYA
 EOR j_flag
 RTS

.l_445c

 STY &D1
 CPX &D1
 BNE l_4472
 LDA &0387,X
 EOR #&FF
 STA &0387,X
 JSR l_1efa
 JSR l_5530
 LDY &D1

.l_4472

 RTS

.l_4473

 LDA &033F
 BNE l_44c7
 LDY #&01
 JSR l_4429
 INY
 JSR l_4429
 LDA #&51
 STA &FE60
 LDA &FE40
 TAX
 AND #&10
 EOR #&10
 STA &0307
 LDX #&01
 JSR l_4452
 ORA #&01
 STA adval_x
 LDX #&02
 JSR l_4452
 EOR y_flag
 STA adval_y
 JMP l_4555

.l_44a4

 LDA #&00
 LDY #&10

.l_44a8

 STA last_key,Y
 DEY
 BNE l_44a8
 RTS

.l_44af

 JSR l_44a4
 LDA &2F
 BEQ l_open
 JMP l_4555

.l_open

 LDA k_flag
 BNE l_4473
 \	STA b_flag
 LDY #&07

.l_44bc

 JSR l_4429
 DEY
 BNE l_44bc
 LDA &033F
 BEQ l_4526

.l_44c7

 JSR l_3f26
 LDA #&60
 STA &54
 ORA #&80
 STA &5C
 STA &8C
 LDA &7D	\ ? Too Fast
 STA &61
 JSR l_2346
 LDA &61
 CMP #&16
 BCC l_44e3
 LDA #&16

.l_44e3

 STA &7D
 LDA #&FF
 LDX #&00
 LDY &62
 BEQ l_44f3
 BMI l_44f0
 INX

.l_44f0

 STA &0301,X

.l_44f3

 LDA #&80
 LDX #&00
 ASL &63
 BEQ l_450f
 BCC l_44fe
 INX

.l_44fe

 BIT &63
 BPL l_4509
 LDA #&40
 STA adval_x
 LDA #&00

.l_4509

 STA &0303,X
 LDA adval_x

.l_450f

 STA adval_x
 LDA #&80
 LDX #&00
 ASL &64
 BEQ l_4523
 BCS l_451d
 INX

.l_451d

 STA &0305,X
 LDA adval_y

.l_4523

 STA adval_y

.l_4526

 LDX adval_x
 LDA #&07
 LDY &0303
 BEQ l_4533
 JSR l_2a16

.l_4533

 LDY &0304
 BEQ l_453b
 JSR l_2a26

.l_453b

 STX adval_x
 ASL A
 LDX adval_y
 LDY &0305
 BEQ l_454a
 JSR l_2a26

.l_454a

 LDY &0306
 BEQ l_4552
 JSR l_2a16

.l_4552

 STX adval_y

.l_4555

 JSR l_433f
 STX last_key
 CPX #&69
 BNE l_459c

.l_455f

 JSR l_55f7
 JSR l_433f
 CPX #&51
 BNE l_456e
 LDA #&00
 STA s_flag

.l_456e

 LDY #&40

.l_4570

 JSR l_445c
 INY
 \	CPY #&47
 CPY #&48
 BNE l_4570
 CPX #&10
 BNE l_457f
 STX s_flag

.l_457f

 CPX #&70
 BNE l_4586
 JMP l_1220

.l_4586

 CPX #&59
 BNE l_455f

.l_459c

 LDA &87
 BNE l_45b4
 LDY #&10
 \	LDA #&FF

.l_45a4

 JSR l_4429
 \	LDX l_4419-1,Y
 \	CPX last_key
 \	BNE l_45af
 \	STA last_key,Y
 \l_45af
 DEY
 CPY #&07
 BNE l_45a4

.l_45b4

 RTS

.l_45b5

 STX &034A
 PHA
 LDA &03A4
 JSR l_45dd
 PLA
 EQUB &2C

.cargo_mtok

 ADC #&D0

.l_45c6

 \	LDX #&00
 \	STX vdu_stat
 JSR vdu_00
 LDY #&09
 STY cursor_x
 LDY #&16
 STY cursor_y
 CPX &034A
 BNE l_45b5
 STY &034A
 STA &03A4

.l_45dd

 JSR l_339a
 LSR &034B
 BCC l_45b4
 LDA #&FD
 JMP l_339a

.l_45ea

 JSR l_3f86
 BMI l_45b4
 \	CPX #&16
 CPX #&18
 BCS l_45b4
 \	LDA cmdr_cargo,X
 LDA cmdr_hold,X
 BEQ l_45b4
 LDA &034A
 BNE l_45b4
 LDY #&03
 STY &034B
 \	STA cmdr_cargo,X
 STA cmdr_hold,X
 DEX
 BMI l_45c1
 CPX #&11
 BEQ l_45c1
 TXA
 BCC cargo_mtok	\BCS l_460e

.l_460e

 CMP #&12
 BNE equip_mtok	\BEQ l_45c4
 \l_45c4
 LDA #&6F-&6B-1
 \	EQUB &2C

.l_45c1

 \	LDA #&6C
 ADC #&6B-&5D
 \	EQUB &2C

.equip_mtok

 ADC #&5D
 INC new_hold	\**
 BNE l_45c6

.l_4619

 EQUB &13, &82, &06, &01, &14, &81, &0A, &03, &41, &83, &02, &07
 EQUB &28, &85, &E2, &1F, &53, &85, &FB, &0F, &C4, &08, &36, &03
 EQUB &EB, &1D, &08, &78, &9A, &0E, &38, &03, &75, &06, &28, &07
 EQUB &4E, &01, &11, &1F, &7C, &0D, &1D, &07, &B0, &89, &DC, &3F
 EQUB &20, &81, &35, &03, &61, &A1, &42, &07, &AB, &A2, &37, &1F
 EQUB &2D, &C1, &FA, &0F, &35, &0F, &C0, &07

.l_465d

 TYA
 LDY #&02
 JSR l_472c
 STA &5A
 JMP l_46a5

.l_4668

 TAX
 LDA &35
 AND #&60
 BEQ l_465d
 LDA #&02
 JSR l_472c
 STA &58
 JMP l_46a5

.l_4679

 LDA &50
 STA &34
 LDA &52
 STA &35
 LDA &54
 STA &36
 JSR l_42f5
 LDA &34
 STA &50
 LDA &35
 STA &52
 LDA &36
 STA &54
 LDY #&04
 LDA &34
 AND #&60
 BEQ l_4668
 LDX #&02
 LDA #&00
 JSR l_472c
 STA &56

.l_46a5

 LDA &56
 STA &34
 LDA &58
 STA &35
 LDA &5A
 STA &36
 JSR l_42f5
 LDA &34
 STA &56
 LDA &35
 STA &58
 LDA &36
 STA &5A
 LDA &52
 STA &81
 LDA &5A
 JSR l_28d4
 LDX &54
 LDA &58
 JSR l_293b
 EOR #&80
 STA &5C
 LDA &56
 JSR l_28d4
 LDX &50
 LDA &5A
 JSR l_293b
 EOR #&80
 STA &5E
 LDA &58
 JSR l_28d4
 LDX &52
 LDA &56
 JSR l_293b
 EOR #&80
 STA &60
 LDA #&00
 LDX #&0E

.l_46f8

 STA &4F,X
 DEX
 DEX
 BPL l_46f8
 RTS

.l_46ff

 TAY
 AND #&7F
 CMP &81
 BCS l_4726
 LDX #&FE
 STX &D1

.l_470a

 ASL A
 CMP &81
 BCC l_4711
 SBC &81

.l_4711

 ROL &D1
 BCS l_470a
 LDA &D1
 LSR A
 LSR A
 STA &D1
 LSR A
 ADC &D1
 STA &D1
 TYA
 AND #&80
 ORA &D1
 RTS

.l_4726

 TYA
 AND #&80
 ORA #&60
 RTS

.l_472c

 STA font+&01
 LDA &50,X
 STA &81
 LDA &56,X
 JSR l_28d4
 LDX &50,Y
 STX &81
 LDA &56,Y
 JSR l_28fc
 STX &1B
 LDY font+&01
 LDX &50,Y
 STX &81
 EOR #&80
 STA font
 EOR &81
 AND #&80
 STA &D1
 LDA #&00
 LDX #&10
 ASL &1B
 ROL font
 ASL &81
 LSR &81

.l_475f

 ROL A
 CMP &81
 BCC l_4766
 SBC &81

.l_4766

 ROL &1B
 ROL font
 DEX
 BNE l_475f
 LDA &1B
 ORA &D1
 RTS

.l_4772

 JSR l_48de
 JSR l_3856
 ORA &D3
 BNE l_479d
 LDA &E0
 CMP #&BE
 BCS l_479d
 LDY #&02
 JSR l_47a4
 LDY #&06
 LDA &E0
 ADC #&01
 JSR l_47a4
 LDA #&08
 ORA &65
 STA &65
 LDA #&08
 JMP l_4f74

.l_479b

 PLA
 PLA

.l_479d

 LDA #&F7
 AND &65
 STA &65
 RTS

.l_47a4

 STA (&67),Y
 INY
 INY
 STA (&67),Y
 LDA &D2
 DEY
 STA (&67),Y
 ADC #&03
 BCS l_479b
 DEY
 DEY
 STA (&67),Y
 RTS

.l_47b8

 LDY &82
 LDA &81
 STA &83
 LDX #&00
 STX &81
 LDA #&08
 STA &D1

.l_47c6

 CPX &81
 BCC l_47d8
 BNE l_47d0
 CPY #&40
 BCC l_47d8

.l_47d0

 TYA
 SBC #&40
 TAY
 TXA
 SBC &81
 TAX

.l_47d8

 ROL &81
 ASL &83
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 ASL &83
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 DEC &D1
 BNE l_47c6
 RTS

.l_47ef

 CMP &81
 BCS l_480d

.l_47f3

 LDX #&FE
 STX &82

.l_47f7

 ASL A
 BCS l_4805
 CMP &81
 BCC l_4800
 SBC &81

.l_4800

 ROL &82
 BCS l_47f7
 RTS

.l_4805

 SBC &81
 SEC
 ROL &82
 BCS l_47f7
 RTS

.l_480d

 LDA #&FF
 STA &82
 RTS

.l_4812

 EOR &83
 BMI l_481c
 LDA &81
 CLC
 ADC &82
 RTS

.l_481c

 LDA &82
 SEC
 SBC &81
 BCC l_4825
 CLC
 RTS

.l_4825

 PHA
 LDA &83
 EOR #&80
 STA &83
 PLA
 EOR #&FF
 ADC #&01
 RTS

.l_4832

 LDX #&00
 LDY #&00

.l_4836

 LDA &34
 STA &81
 LDA &09,X
 JSR l_2847
 STA &D1
 LDA &35
 EOR &0A,X
 STA &83
 LDA &36
 STA &81
 LDA &0B,X
 JSR l_2847
 STA &81
 LDA &D1
 STA &82
 LDA &37
 EOR &0C,X
 JSR l_4812
 STA &D1
 LDA &38
 STA &81
 LDA &0D,X
 JSR l_2847
 STA &81
 LDA &D1
 STA &82
 LDA &39
 EOR &0E,X
 JSR l_4812
 STA &3A,Y
 LDA &83
 STA &3B,Y
 INY
 INY
 TXA
 CLC
 ADC #&06
 TAX
 CMP #&11
 BCC l_4836
 RTS

.l_4889

 JMP l_3899

.l_488c

 LDA &8C
 BMI l_4889
 LDA #&1F
 STA &96
 LDA &6A
 BMI l_48de
 LDA #&20
 BIT &65
 BNE l_48cb
 BPL l_48cb
 ORA &65
 AND #&3F
 STA &65
 LDA #&00
 LDY #&1C
 STA (&20),Y
 LDY #&1E
 STA (&20),Y
 JSR l_48de
 LDY #&01
 LDA #&12
 STA (&67),Y
 LDY #&07
 LDA (&1E),Y
 LDY #&02
 STA (&67),Y

.l_48c1

 INY
 JSR l_3f86
 STA (&67),Y
 CPY #&06
 BNE l_48c1

.l_48cb

 LDA &4E
 BPL l_48ec

.l_48cf

 LDA &65
 AND #&20
 BEQ l_48de
 LDA &65
 AND #&F7
 STA &65
 JMP l_3470

.l_48de

 LDA #&08
 BIT &65
 BEQ l_48eb
 EOR &65
 STA &65
 JMP l_4f78

.l_48eb

 RTS

.l_48ec

 LDA &4D
 CMP #&C0
 BCS l_48cf
 LDA &46
 CMP &4C
 LDA &47
 SBC &4D
 BCS l_48cf
 LDA &49
 CMP &4C
 LDA &4A
 SBC &4D
 BCS l_48cf
 LDY #&06
 LDA (&1E),Y
 TAX
 LDA #&FF
 STA &0100,X
 STA &0101,X
 LDA &4C
 STA &D1
 LDA &4D
 LSR A
 ROR &D1
 LSR A
 ROR &D1
 LSR A
 ROR &D1
 LSR A
 BNE l_492f
 LDA &D1
 ROR A
 LSR A
 LSR A
 LSR A
 STA &96
 BPL l_4940

.l_492f

 LDY #&0D
 LDA (&1E),Y
 CMP &4D
 BCS l_4940
 LDA #&20
 AND &65
 BNE l_4940
 JMP l_4772

.l_4940

 LDX #&05

.l_4942

 LDA &5B,X
 STA &09,X
 LDA &55,X
 STA &0F,X
 LDA &4F,X
 STA &15,X
 DEX
 BPL l_4942
 LDA #&C5
 STA &81
 LDY #&10

.l_4957

 LDA &09,Y
 ASL A
 LDA &0A,Y
 ROL A
 JSR l_47ef
 LDX &82
 STX &09,Y
 DEY
 DEY
 BPL l_4957
 LDX #&08

.l_496c

 LDA &46,X
 STA vdu_stat,X
 DEX
 BPL l_496c
 LDA #&FF
 STA &E1
 LDY #&0C
 LDA &65
 AND #&20
 BEQ l_4991
 LDA (&1E),Y
 LSR A
 LSR A
 TAX
 LDA #&FF

.l_4986

 STA &D2,X
 DEX
 BPL l_4986
 INX
 STX &96

.l_498e

 JMP l_4b04

.l_4991

 LDA (&1E),Y
 BEQ l_498e
 STA &97
 LDY #&12
 LDA (&1E),Y
 TAX
 LDA &79
 TAY
 BEQ l_49b0

.l_49a1

 INX
 LSR &76
 ROR &75
 LSR &73
 ROR vdu_stat
 LSR A
 ROR &78
 TAY
 BNE l_49a1

.l_49b0

 STX &86
 LDA &7A
 STA &39
 LDA vdu_stat
 STA &34
 LDA &74
 STA &35
 LDA &75
 STA &36
 LDA &77
 STA &37
 LDA &78
 STA &38
 JSR l_4832
 LDA &3A
 STA vdu_stat
 LDA &3B
 STA &74
 LDA &3C
 STA &75
 LDA &3D
 STA &77
 LDA &3E
 STA &78
 LDA &3F
 STA &7A
 LDY #&04
 LDA (&1E),Y
 CLC
 ADC &1E
 STA &22
 LDY #&11
 LDA (&1E),Y
 ADC &1F
 STA &23
 LDY #&00

.l_49f8

 LDA (&22),Y
 STA &3B
 AND #&1F
 CMP &96
 BCS l_4a11
 TYA
 LSR A
 LSR A
 TAX
 LDA #&FF
 STA &D2,X
 TYA
 ADC #&04
 TAY
 JMP l_4afd

.l_4a11

 LDA &3B
 ASL A
 STA &3D
 ASL A
 STA &3F
 INY
 LDA (&22),Y
 STA &3A
 INY
 LDA (&22),Y
 STA &3C
 INY
 LDA (&22),Y
 STA &3E
 LDX &86
 CPX #&04
 BCC l_4a51
 LDA vdu_stat
 STA &34
 LDA &74
 STA &35
 LDA &75
 STA &36
 LDA &77
 STA &37
 LDA &78
 STA &38
 LDA &7A
 STA &39
 JMP l_4aaf

.l_4a49

 LSR vdu_stat
 LSR &78
 LSR &75
 LDX #&01

.l_4a51

 LDA &3A
 STA &34
 LDA &3C
 STA &36
 LDA &3E
 DEX
 BMI l_4a66

.l_4a5e

 LSR &34
 LSR &36
 LSR A
 DEX
 BPL l_4a5e

.l_4a66

 STA &82
 LDA &3F
 STA &83
 LDA &78
 STA &81
 LDA &7A
 JSR l_4812
 BCS l_4a49
 STA &38
 LDA &83
 STA &39
 LDA &34
 STA &82
 LDA &3B
 STA &83
 LDA vdu_stat
 STA &81
 LDA &74
 JSR l_4812
 BCS l_4a49
 STA &34
 LDA &83
 STA &35
 LDA &36
 STA &82
 LDA &3D
 STA &83
 LDA &75
 STA &81
 LDA &77
 JSR l_4812
 BCS l_4a49
 STA &36
 LDA &83
 STA &37

.l_4aaf

 LDA &3A
 STA &81
 LDA &34
 JSR l_2847
 STA &D1
 LDA &3B
 EOR &35
 STA &83
 LDA &3C
 STA &81
 LDA &36
 JSR l_2847
 STA &81
 LDA &D1
 STA &82
 LDA &3D
 EOR &37
 JSR l_4812
 STA &D1
 LDA &3E
 STA &81
 LDA &38
 JSR l_2847
 STA &81
 LDA &D1
 STA &82
 LDA &39
 EOR &3F
 JSR l_4812
 PHA
 TYA
 LSR A
 LSR A
 TAX
 PLA
 BIT &83
 BMI l_4afa
 LDA #&00

.l_4afa

 STA &D2,X
 INY

.l_4afd

 CPY &97
 BCS l_4b04
 JMP l_49f8

.l_4b04

 LDY &0B
 LDX &0C
 LDA &0F
 STA &0B
 LDA &10
 STA &0C
 STY &0F
 STX &10
 LDY &0D
 LDX &0E
 LDA &15
 STA &0D
 LDA &16
 STA &0E
 STY &15
 STX &16
 LDY &13
 LDX &14
 LDA &17
 STA &13
 LDA &18
 STA &14
 STY &17
 STX &18
 LDY #&08
 LDA (&1E),Y
 STA &97
 LDA &1E
 CLC
 ADC #&14
 STA &22
 LDA &1F
 ADC #&00
 STA &23
 LDY #&00
 STY &93

.l_4b4b

 STY &86
 LDA (&22),Y
 STA &34
 INY
 LDA (&22),Y
 STA &36
 INY
 LDA (&22),Y
 STA &38
 INY
 LDA (&22),Y
 STA &D1
 AND #&1F
 CMP &96
 BCC l_4b94
 INY
 LDA (&22),Y
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_4b97
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_4b97
 INY
 LDA (&22),Y
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_4b97
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_4b97

.l_4b94

 JMP l_4d0c

.l_4b97

 LDA &D1
 STA &35
 ASL A
 STA &37
 ASL A
 STA &39
 JSR l_4832
 LDA &48
 STA &36
 EOR &3B
 BMI l_4bbc
 CLC
 LDA &3A
 ADC &46
 STA &34
 LDA &47
 ADC #&00
 STA &35
 JMP l_4bdf

.l_4bbc

 LDA &46
 SEC
 SBC &3A
 STA &34
 LDA &47
 SBC #&00
 STA &35
 BCS l_4bdf
 EOR #&FF
 STA &35
 LDA #&01
 SBC &34
 STA &34
 BCC l_4bd9
 INC &35

.l_4bd9

 LDA &36
 EOR #&80
 STA &36

.l_4bdf

 LDA &4B
 STA &39
 EOR &3D
 BMI l_4bf7
 CLC
 LDA &3C
 ADC &49
 STA &37
 LDA &4A
 ADC #&00
 STA &38
 JMP l_4c1c

.l_4bf7

 LDA &49
 SEC
 SBC &3C
 STA &37
 LDA &4A
 SBC #&00
 STA &38
 BCS l_4c1c
 EOR #&FF
 STA &38
 LDA &37
 EOR #&FF
 ADC #&01
 STA &37
 LDA &39
 EOR #&80
 STA &39
 BCC l_4c1c
 INC &38

.l_4c1c

 LDA &3F
 BMI l_4c6a
 LDA &3E
 CLC
 ADC &4C
 STA &D1
 LDA &4D
 ADC #&00
 STA &80
 JMP l_4c89

.l_4c30

 LDX &81
 BEQ l_4c50
 LDX #&00

.l_4c36

 LSR A
 INX
 CMP &81
 BCS l_4c36
 STX &83
 JSR l_47ef
 LDX &83
 LDA &82

.l_4c45

 ASL A
 ROL &80
 BMI l_4c50
 DEX
 BNE l_4c45
 STA &82
 RTS

.l_4c50

 LDA #&32
 STA &82
 STA &80
 RTS

.l_4c57

 LDA #&80
 SEC
 SBC &82
 STA &0100,X
 INX
 LDA #&00
 SBC &80
 STA &0100,X
 JMP l_4cc9

.l_4c6a

 LDA &4C
 SEC
 SBC &3E
 STA &D1
 LDA &4D
 SBC #&00
 STA &80
 BCC l_4c81
 BNE l_4c89
 LDA &D1
 CMP #&04
 BCS l_4c89

.l_4c81

 LDA #&00
 STA &80
 LDA #&04
 STA &D1

.l_4c89

 LDA &80
 ORA &35
 ORA &38
 BEQ l_4ca0
 LSR &35
 ROR &34
 LSR &38
 ROR &37
 LSR &80
 ROR &D1
 JMP l_4c89

.l_4ca0

 LDA &D1
 STA &81
 LDA &34
 CMP &81
 BCC l_4cb0
 JSR l_4c30
 JMP l_4cb3

.l_4cb0

 JSR l_47ef

.l_4cb3

 LDX &93
 LDA &36
 BMI l_4c57
 LDA &82
 CLC
 ADC #&80
 STA &0100,X
 INX
 LDA &80
 ADC #&00
 STA &0100,X

.l_4cc9

 TXA
 PHA
 LDA #&00
 STA &80
 LDA &D1
 STA &81
 LDA &37
 CMP &81
 BCC l_4cf2
 JSR l_4c30
 JMP l_4cf5

.l_4cdf

 LDA #&60
 CLC
 ADC &82
 STA &0100,X
 INX
 LDA #&00
 ADC &80
 STA &0100,X
 JMP l_4d0c

.l_4cf2

 JSR l_47ef

.l_4cf5

 PLA
 TAX
 INX
 LDA &39
 BMI l_4cdf
 LDA #&60
 SEC
 SBC &82
 STA &0100,X
 INX
 LDA #&00
 SBC &80
 STA &0100,X

.l_4d0c

 CLC
 LDA &93
 ADC #&04
 STA &93
 LDA &86
 ADC #&06
 TAY
 BCS l_4d21
 CMP &97
 BCS l_4d21
 JMP l_4b4b

.l_4d21

 LDA &65
 AND #&20
 BEQ l_4d30
 LDA &65
 ORA #&08
 STA &65
 JMP l_3470

.l_4d30

 LDA #&08
 BIT &65
 BEQ l_4d3b
 JSR l_4f78
 LDA #&08

.l_4d3b

 ORA &65
 STA &65
 LDY #&09
 LDA (&1E),Y
 STA &97
 LDY #&00
 STY &80
 STY &86
 INC &80
 BIT &65
 BVC l_4da5
 LDA &65
 AND #&BF
 STA &65
 LDY #&06
 LDA (&1E),Y
 TAY
 LDX &0100,Y
 STX &34
 INX
 BEQ l_4da5
 LDX &0101,Y
 STX &35
 INX
 BEQ l_4da5
 LDX &0102,Y
 STX &36
 LDX &0103,Y
 STX &37
 LDA #&00
 STA &38
 STA &39
 STA &3B
 LDA &4C
 STA &3A
 LDA &48
 BPL l_4d88
 DEC &38

.l_4d88

 JSR l_4e19
 BCS l_4da5
 LDY &80
 LDA &34
 STA (&67),Y
 INY
 LDA &35
 STA (&67),Y
 INY
 LDA &36
 STA (&67),Y
 INY
 LDA &37
 STA (&67),Y
 INY
 STY &80

.l_4da5

 LDY #&03
 CLC
 LDA (&1E),Y
 ADC &1E
 STA &22
 LDY #&10
 LDA (&1E),Y
 ADC &1F
 STA &23
 LDY #&05
 LDA (&1E),Y
 STA &06
 LDY &86

.l_4dbe

 LDA (&22),Y
 CMP &96
 BCC l_4ddc
 INY
 LDA (&22),Y
 INY
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_4ddf
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_4ddf

.l_4ddc

 JMP l_4f5b

.l_4ddf

 LDA (&22),Y
 TAX
 INY
 LDA (&22),Y
 STA &81
 LDA &0101,X
 STA &35
 LDA &0100,X
 STA &34
 LDA &0102,X
 STA &36
 LDA &0103,X
 STA &37
 LDX &81
 LDA &0100,X
 STA &38
 LDA &0103,X
 STA &3B
 LDA &0102,X
 STA &3A
 LDA &0101,X
 STA &39
 JSR l_4e1f
 BCS l_4ddc
 JMP l_4f3f

.l_4e19

 LDA #&00
 STA &90
 LDA &39

.l_4e1f

 LDX #&BF
 ORA &3B
 BNE l_4e2b
 CPX &3A
 BCC l_4e2b
 LDX #&00

.l_4e2b

 STX &89
 LDA &35
 ORA &37
 BNE l_4e4f
 LDA #&BF
 CMP &36
 BCC l_4e4f
 LDA &89
 BNE l_4e4d

.l_4e3d

 LDA &36
 STA &35
 LDA &38
 STA &36
 LDA &3A
 STA &37
 CLC
 RTS

.l_4e4b

 SEC
 RTS

.l_4e4d

 LSR &89

.l_4e4f

 LDA &89
 BPL l_4e82
 LDA &35
 AND &39
 BMI l_4e4b
 LDA &37
 AND &3B
 BMI l_4e4b
 LDX &35
 DEX
 TXA
 LDX &39
 DEX
 STX &3C
 ORA &3C
 BPL l_4e4b
 LDA &36
 CMP #&C0
 LDA &37
 SBC #&00
 STA &3C
 LDA &3A
 CMP #&C0
 LDA &3B
 SBC #&00
 ORA &3C
 BPL l_4e4b

.l_4e82

 TYA
 PHA
 LDA &38
 SEC
 SBC &34
 STA &3C
 LDA &39
 SBC &35
 STA &3D
 LDA &3A
 SEC
 SBC &36
 STA &3E
 LDA &3B
 SBC &37
 STA &3F
 EOR &3D
 STA &83
 LDA &3F
 BPL l_4eb3
 LDA #&00
 SEC
 SBC &3E
 STA &3E
 LDA #&00
 SBC &3F
 STA &3F

.l_4eb3

 LDA &3D
 BPL l_4ec2
 SEC
 LDA #&00
 SBC &3C
 STA &3C
 LDA #&00
 SBC &3D

.l_4ec2

 TAX
 BNE l_4ec9
 LDX &3F
 BEQ l_4ed3

.l_4ec9

 LSR A
 ROR &3C
 LSR &3F
 ROR &3E
 JMP l_4ec2

.l_4ed3

 STX &D1
 LDA &3C
 CMP &3E
 BCC l_4ee5
 STA &81
 LDA &3E
 JSR l_47ef
 JMP l_4ef0

.l_4ee5

 LDA &3E
 STA &81
 LDA &3C
 JSR l_47ef
 DEC &D1

.l_4ef0

 LDA &82
 STA &3C
 LDA &83
 STA &3D
 LDA &89
 BEQ l_4efe
 BPL l_4f11

.l_4efe

 JSR l_4f9f
 LDA &89
 BPL l_4f36
 LDA &35
 ORA &37
 BNE l_4f3b
 LDA &36
 CMP #&C0
 BCS l_4f3b

.l_4f11

 LDX &34
 LDA &38
 STA &34
 STX &38
 LDA &39
 LDX &35
 STX &39
 STA &35
 LDX &36
 LDA &3A
 STA &36
 STX &3A
 LDA &3B
 LDX &37
 STX &3B
 STA &37
 JSR l_4f9f
 DEC &90

.l_4f36

 PLA
 TAY
 JMP l_4e3d

.l_4f3b

 PLA
 TAY
 SEC
 RTS

.l_4f3f

 LDY &80
 LDA &34
 STA (&67),Y
 INY
 LDA &35
 STA (&67),Y
 INY
 LDA &36
 STA (&67),Y
 INY
 LDA &37
 STA (&67),Y
 INY
 STY &80
 CPY &06
 BCS l_4f72

.l_4f5b

 INC &86
 LDY &86
 CPY &97
 BCS l_4f72
 LDY #&00
 LDA &22
 ADC #&04
 STA &22
 BCC l_4f6f
 INC &23

.l_4f6f

 JMP l_4dbe

.l_4f72

 LDA &80

.l_4f74

 LDY #&00
 STA (&67),Y

.l_4f78

 LDY #&00
 LDA (&67),Y
 STA &97
 CMP #&04
 BCC l_4f9e
 INY

.l_4f83

 LDA (&67),Y
 STA &34
 INY
 LDA (&67),Y
 STA &35
 INY
 LDA (&67),Y
 STA &36
 INY
 LDA (&67),Y
 STA &37
 JSR l_16c4
 INY
 CPY &97
 BCC l_4f83

.l_4f9e

 RTS

.l_4f9f

 LDA &35
 BPL l_4fba
 STA &83
 JSR l_5019
 TXA
 CLC
 ADC &36
 STA &36
 TYA
 ADC &37
 STA &37
 LDA #&00
 STA &34
 STA &35
 TAX

.l_4fba

 BEQ l_4fd5
 STA &83
 DEC &83
 JSR l_5019
 TXA
 CLC
 ADC &36
 STA &36
 TYA
 ADC &37
 STA &37
 LDX #&FF
 STX &34
 INX
 STX &35

.l_4fd5

 LDA &37
 BPL l_4ff3
 STA &83
 LDA &36
 STA &82
 JSR l_5048
 TXA
 CLC
 ADC &34
 STA &34
 TYA
 ADC &35
 STA &35
 LDA #&00
 STA &36
 STA &37

.l_4ff3

 LDA &36
 SEC
 SBC #&C0
 STA &82
 LDA &37
 SBC #&00
 STA &83
 BCC l_5018
 JSR l_5048
 TXA
 CLC
 ADC &34
 STA &34
 TYA
 ADC &35
 STA &35
 LDA #&BF
 STA &36
 LDA #&00
 STA &37

.l_5018

 RTS

.l_5019

 LDA &34
 STA &82
 JSR l_5084
 PHA
 LDX &D1
 BNE l_5050

.l_5025

 LDA #&00
 TAX
 TAY
 LSR &83
 ROR &82
 ASL &81
 BCC l_503a

.l_5031

 TXA
 CLC
 ADC &82
 TAX
 TYA
 ADC &83
 TAY

.l_503a

 LSR &83
 ROR &82
 ASL &81
 BCS l_5031
 BNE l_503a
 PLA
 BPL l_5077
 RTS

.l_5048

 JSR l_5084
 PHA
 LDX &D1
 BNE l_5025

.l_5050

 LDA #&FF
 TAY
 ASL A
 TAX

.l_5055

 ASL &82
 ROL &83
 LDA &83
 BCS l_5061
 CMP &81
 BCC l_506c

.l_5061

 SBC &81
 STA &83
 LDA &82
 SBC #&00
 STA &82
 SEC

.l_506c

 TXA
 ROL A
 TAX
 TYA
 ROL A
 TAY
 BCS l_5055
 PLA
 BMI l_5083

.l_5077

 TXA
 EOR #&FF
 ADC #&01
 TAX
 TYA
 EOR #&FF
 ADC #&00
 TAY

.l_5083

 RTS

.l_5084

 LDX &3C
 STX &81
 LDA &83
 BPL l_509d
 LDA #&00
 SEC
 SBC &82
 STA &82
 LDA &83
 PHA
 EOR #&FF
 ADC #&00
 STA &83
 PLA

.l_509d

 EOR &3D
 RTS

.l_50a0

 LDA &65
 AND #&A0
 BNE l_50cb
 LDA &8A
 EOR &84
 AND #&0F
 BNE l_50b1
 JSR l_4679

.l_50b1

 LDX &8C
 BPL l_50b8
 JMP l_533d

.l_50b8

 LDA &66
 BPL l_50cb
 CPX #&01
 BEQ l_50c8
 LDA &8A
 EOR &84
 AND #&07
 BNE l_50cb

.l_50c8

 JSR l_217a

.l_50cb

 JSR l_5558
 LDA &61
 ASL A
 ASL A
 STA &81
 LDA &50
 AND #&7F
 JSR l_2847
 STA &82
 LDA &50
 LDX #&00
 JSR l_524a
 LDA &52
 AND #&7F
 JSR l_2847
 STA &82
 LDA &52
 LDX #&03
 JSR l_524a
 LDA &54
 AND #&7F
 JSR l_2847
 STA &82
 LDA &54
 LDX #&06
 JSR l_524a
 LDA &61
 CLC
 ADC &62
 BPL l_510d
 LDA #&00

.l_510d

 LDY #&0F
 CMP (&1E),Y
 BCC l_5115
 LDA (&1E),Y

.l_5115

 STA &61
 LDA #&00
 STA &62
 LDX &31
 LDA &46
 EOR #&FF
 STA &1B
 LDA &47
 JSR l_2877
 STA font+&01
 LDA &33
 EOR &48
 LDX #&03
 JSR l_5308
 STA &9E
 LDA font
 STA &9C
 EOR #&FF
 STA &1B
 LDA font+&01
 STA &9D
 LDX &2B
 JSR l_2877
 STA font+&01
 LDA &9E
 EOR &7B
 LDX #&06
 JSR l_5308
 STA &4E
 LDA font
 STA &4C
 EOR #&FF
 STA &1B
 LDA font+&01
 STA &4D
 JSR l_2879
 STA font+&01
 LDA &9E
 STA &4B
 EOR &7B
 EOR &4E
 BPL l_517d
 LDA font
 ADC &9C
 STA &49
 LDA font+&01
 ADC &9D
 STA &4A
 JMP l_519d

.l_517d

 LDA &9C
 SBC font
 STA &49
 LDA &9D
 SBC font+&01
 STA &4A
 BCS l_519d
 LDA #&01
 SBC &49
 STA &49
 LDA #&00
 SBC &4A
 STA &4A
 LDA &4B
 EOR #&80
 STA &4B

.l_519d

 LDX &31
 LDA &49
 EOR #&FF
 STA &1B
 LDA &4A
 JSR l_2877
 STA font+&01
 LDA &32
 EOR &4B
 LDX #&00
 JSR l_5308
 STA &48
 LDA font+&01
 STA &47
 LDA font
 STA &46

.l_51bf

 LDA &7D
 STA &82
 LDA #&80
 LDX #&06
 JSR l_524c
 LDA &8C
 AND #&81
 CMP #&81
 BNE l_51d3
 RTS

.l_51d3

 LDY #&09
 JSR l_52a1
 LDY #&0F
 JSR l_52a1
 LDY #&15
 JSR l_52a1
 LDA &64
 AND #&80
 STA &9A
 LDA &64
 AND #&7F
 BEQ l_520b
 CMP #&7F
 SBC #&00
 ORA &9A
 STA &64
 LDX #&0F
 LDY #&09
 JSR l_1da8
 LDX #&11
 LDY #&0B
 JSR l_1da8
 LDX #&13
 LDY #&0D
 JSR l_1da8

.l_520b

 LDA &63
 AND #&80
 STA &9A
 LDA &63
 AND #&7F
 BEQ l_5234
 CMP #&7F
 SBC #&00
 ORA &9A
 STA &63
 LDX #&0F
 LDY #&15
 JSR l_1da8
 LDX #&11
 LDY #&17
 JSR l_1da8
 LDX #&13
 LDY #&19
 JSR l_1da8

.l_5234

 LDA &65
 AND #&A0
 BNE l_5243
 LDA &65
 ORA #&10
 STA &65
 JMP l_5558

.l_5243

 LDA &65
 AND #&EF
 STA &65
 RTS

.l_524a

 AND #&80

.l_524c

 ASL A
 STA &83
 LDA #&00
 ROR A
 STA &D1
 LSR &83
 EOR &48,X
 BMI l_526f
 LDA &82
 ADC &46,X
 STA &46,X
 LDA &83
 ADC &47,X
 STA &47,X
 LDA &48,X
 ADC #&00
 ORA &D1
 STA &48,X
 RTS

.l_526f

 LDA &46,X
 SEC
 SBC &82
 STA &46,X
 LDA &47,X
 SBC &83
 STA &47,X
 LDA &48,X
 AND #&7F
 SBC #&00
 ORA #&80
 EOR &D1
 STA &48,X
 BCS l_52a0
 LDA #&01
 SBC &46,X
 STA &46,X
 LDA #&00
 SBC &47,X
 STA &47,X
 LDA #&00
 SBC &48,X
 AND #&7F
 ORA &D1
 STA &48,X

.l_52a0

 RTS

.l_52a1

 LDA &8D
 STA &81
 LDX &48,Y
 STX &82
 LDX &49,Y
 STX &83
 LDX &46,Y
 STX &1B
 LDA &47,Y
 EOR #&80
 JSR l_28fc
 STA &49,Y
 STX &48,Y
 STX &1B
 LDX &46,Y
 STX &82
 LDX &47,Y
 STX &83
 LDA &49,Y
 JSR l_28fc
 STA &47,Y
 STX &46,Y
 STX &1B
 LDA &2A
 STA &81
 LDX &48,Y
 STX &82
 LDX &49,Y
 STX &83
 LDX &4A,Y
 STX &1B
 LDA &4B,Y
 EOR #&80
 JSR l_28fc
 STA &49,Y
 STX &48,Y
 STX &1B
 LDX &4A,Y
 STX &82
 LDX &4B,Y
 STX &83
 LDA &49,Y
 JSR l_28fc
 STA &4B,Y
 STX &4A,Y
 RTS

.l_5308

 TAY
 EOR &48,X
 BMI l_531c
 LDA font
 CLC
 ADC &46,X
 STA font
 LDA font+&01
 ADC &47,X
 STA font+&01
 TYA
 RTS

.l_531c

 LDA &46,X
 SEC
 SBC font
 STA font
 LDA &47,X
 SBC font+&01
 STA font+&01
 BCC l_532f
 TYA
 EOR #&80
 RTS

.l_532f

 LDA #&01
 SBC font
 STA font
 LDA #&00
 SBC font+&01
 STA font+&01
 TYA
 RTS

.l_533d

 LDA &8D
 EOR #&80
 STA &81
 LDA &46
 STA &1B
 LDA &47
 STA font
 LDA &48
 JSR l_2782
 LDX #&03
 JSR l_1d4c
 LDA &41
 STA &9C
 STA &1B
 LDA &42
 STA &9D
 STA font
 LDA &2A
 STA &81
 LDA &43
 STA &9E
 JSR l_2782
 LDX #&06
 JSR l_1d4c
 LDA &41
 STA &1B
 STA &4C
 LDA &42
 STA font
 STA &4D
 LDA &43
 STA &4E
 EOR #&80
 JSR l_2782
 LDA &43
 AND #&80
 STA &D1
 EOR &9E
 BMI l_53a8
 LDA &40
 CLC
 ADC &9B
 LDA &41
 ADC &9C
 STA &49
 LDA &42
 ADC &9D
 STA &4A
 LDA &43
 ADC &9E
 JMP l_53db

.l_53a8

 LDA &40
 SEC
 SBC &9B
 LDA &41
 SBC &9C
 STA &49
 LDA &42
 SBC &9D
 STA &4A
 LDA &9E
 AND #&7F
 STA &1B
 LDA &43
 AND #&7F
 SBC &1B
 STA &1B
 BCS l_53db
 LDA #&01
 SBC &49
 STA &49
 LDA #&00
 SBC &4A
 STA &4A
 LDA #&00
 SBC &1B
 ORA #&80

.l_53db

 EOR &D1
 STA &4B
 LDA &8D
 STA &81
 LDA &49
 STA &1B
 LDA &4A
 STA font
 LDA &4B
 JSR l_2782
 LDX #&00
 JSR l_1d4c
 LDA &41
 STA &46
 LDA &42
 STA &47
 LDA &43
 STA &48
 JMP l_51bf

.l_5404

 DEX
 BNE l_5438
 LDA &48
 EOR #&80
 STA &48
 LDA &4E
 EOR #&80
 STA &4E
 LDA &50
 EOR #&80
 STA &50
 LDA &54
 EOR #&80
 STA &54
 LDA &56
 EOR #&80
 STA &56
 LDA &5A
 EOR #&80
 STA &5A
 LDA &5C
 EOR #&80
 STA &5C
 LDA &60
 EOR #&80
 STA &60
 RTS

.l_5438

 LDA #&00
 CPX #&02
 ROR A
 STA &9A
 EOR #&80
 STA &99
 LDA &46
 LDX &4C
 STA &4C
 STX &46
 LDA &47
 LDX &4D
 STA &4D
 STX &47
 LDA &48
 EOR &99
 TAX
 LDA &4E
 EOR &9A
 STA &48
 STX &4E
 LDY #&09
 JSR l_546c
 LDY #&0F
 JSR l_546c
 LDY #&15

.l_546c

 LDA &46,Y
 LDX &4A,Y
 STA &4A,Y
 STX &46,Y
 LDA &47,Y
 EOR &99
 TAX
 LDA &4B,Y
 EOR &9A
 STA &47,Y
 STX &4B,Y

.l_5486

 RTS

.l_5487

 STX view_dirn
 JSR l_54c8
 JSR l_54aa
 JMP l_35b1

.l_5493

 LDA #&00
 LDY &87
 BNE l_5487
 CPX view_dirn
 BEQ l_5486
 STX view_dirn
 JSR l_54c8
 JSR l_1a05
 JSR l_35d8

.l_54aa

 LDY view_dirn
 LDA cmdr_laser,Y
 BEQ l_5486
 LDA #&80
 STA &73
 LDA #&48
 STA &74
 LDA #&14
 STA &75
 JSR l_2d36
 LDA #&0A
 STA &75
 JMP l_2d36

\ a.dcode_3

.l_54c8

 STA &87

.l_54ca

 JSR vdu_80
 JSR l_360a
 STA &0343
 STA &034A
 STA &034B
 LDX #&60

.l_54dc

 JSR l_42a1
 INX
 CPX #&78
 BNE l_54dc
 LDX &2F
 BEQ l_54eb
 JSR l_30ac

.l_54eb

 LDY #&01
 STY cursor_y
 LDA &87
 BNE l_5507
 LDY #&0B
 STY cursor_x
 LDA view_dirn
 ORA #&60
 JSR l_339a
 JSR l_3142
 LDA #&AF
 JSR l_339a

.l_5507

 LDX #&00
 STX &34
 STX &35
 STX vdu_stat
 DEX
 STX &36
 JSR l_1868
 LDA #&02
 STA &34
 STA &36
 JSR l_551e

.l_551e

 JSR l_5521

.l_5521

 LDA #&00
 STA &35
 LDA #&BF
 STA &37
 DEC &34
 DEC &36
 JMP l_16c4

.l_5530

 JSR l_55f7
 DEY
 BNE l_5530
 RTS

.l_5537

 LDA #&14
 STA cursor_y
 LDA #&75
 STA ptr+&01
 LDA #&07
 STA ptr
 JSR l_2b60
 LDA #&00
 JSR l_5550
 INC ptr+&01
 INY
 STY cursor_x

.l_5550

 LDY #&E9

.l_5552

 STA (ptr),Y
 DEY
 BNE l_5552

.l_5557

 RTS

.iff_xor

 EQUB &00, &00, &0F	\, &FF, &F0 overlap

.iff_base

 EQUB &FF, &F0, &FF, &F0, &FF

.l_5558

 LDA &65
 AND #&10
 BEQ l_5557
 LDA &8C
 BMI l_5557
 JSR iff_index
 LDA iff_base,X
 STA &91
 LDA iff_xor,X
 STA &37
 LDA &47
 ORA &4A
 ORA &4D
 AND #&C0
 BNE l_5557
 LDA &47
 CLC
 LDX &48
 BPL l_5581
 EOR #&FF
 ADC #&01

.l_5581

 ADC #&7B
 STA &34
 LDA &4D
 LSR A
 LSR A
 CLC
 LDX &4E
 BPL l_5591
 EOR #&FF
 SEC

.l_5591

 ADC #&23
 EOR #&FF
 STA ptr
 LDA &4A
 LSR A
 CLC
 LDX &4B
 BMI l_55a2
 EOR #&FF
 SEC

.l_55a2

 ADC ptr
 BPL l_55b0
 CMP #&C2
 BCS l_55ac
 LDA #&C2

.l_55ac

 CMP #&F7
 BCC l_55b2

.l_55b0

 LDA #&F6

.l_55b2

 STA &35
 SEC
 SBC ptr
 \	PHP
 PHA
 JSR l_36a7
 LDA pixels+&11,X
 TAX
 AND &91	\ iff
 STA &34
 TXA
 AND &37
 STA &35
 PLA
 \	PLP
 TAX
 BEQ l_55da
 \	BCC l_55db
 BMI l_55db

.l_55ca

 DEY
 BPL l_55d1
 LDY #&07
 DEC ptr+&01

.l_55d1

 LDA &34
 EOR &35	\ iff
 STA &34	\ iff
 EOR (ptr),Y
 STA (ptr),Y
 DEX
 BNE l_55ca

.l_55da

 RTS

.l_55db

 INY
 CPY #&08
 BNE l_55e4
 LDY #&00
 INC ptr+&01

.l_55e4

 INY
 CPY #&08
 BNE l_55ed
 LDY #&00
 INC ptr+&01

.l_55ed

 LDA &34
 EOR &35	\ iff
 STA &34	\ iff
 EOR (ptr),Y
 STA (ptr),Y
 INX
 BNE l_55e4
 RTS

.l_55f7

 LDA #&00
 STA &8B

.l_55fb

 LDA &8B
 BEQ l_55fb
 RTS 

SAVE "versions/elite-a/output/1.F.bin", CODE%, P%, LOAD%