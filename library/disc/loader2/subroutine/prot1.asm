\ ******************************************************************************
\
\       Name: PROT1
\       Type: Subroutine
\   Category: Loader
\    Summary: Various copy protection shenanigans in preparation for showing
\             the Acornsoft loading screen
\
\ ******************************************************************************

.PROT1

 LDA #&68               \ Poke the following routine into &0100 to &0108:
 STA &0100              \
 STA &0103              \   0100 : &68            PLA
 LDA #&85               \   0101 : &85 &71        STA ZP
 STA &0101              \   0103 : &68            PLA
 STA &0104              \   0104 : &85 &72        STA ZP+1
 LDX #&71               \   0106 : &6C &71 &00    JMP (ZP)
 STX &0107              \
 STX &0102              \ This routine pulls an address off the stack into a
 INX                    \ location in zero page, and then jumps to that address
 STX &0105
 LDA #&6C
 STA &0106
 LDA #&00
 STA &0108

.do

 JSR &0100              \ Call the subroutine at &0100, which does the
 EQUB 0                 \ following:
                        \
                        \   * The JSR puts the address of the last byte of the
                        \     JSR instruction on the stack (i.e. the address of
                        \     the &01), pushing the high byte first
                        \
                        \   * It then jumps to &0100, which pulls the address
                        \     off the stack and puts it in ZP(1 0)
                        \
                        \   * The final instruction of the routine at &0100
                        \     jumps to the address in ZP(1 0), i.e. it jumps to
                        \     the &01 of the JSR instruction. The &01 byte is
                        \     followed by a &00 byte, and &01 &00 is the opcode
                        \     for ORA (&00,X), which doesn't do anything apart
                        \     from affect the value of the accumulator
                        \
                        \ In other words, this whole routine is a complicated
                        \ way of pointing ZP(1 0) to the &01 byte in the JSR
                        \ instruction above, i.e. to do + 2

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) - (2 + do - PROT1)
 SEC                    \             = do + 2 - 2 - do + PROT1
 SBC #(2 + do - PROT1)  \             = PROT1
 STA ZP
 LDA ZP+1
 SBC #&00
 STA ZP+1

 LDY #(TABLE - PROT1)   \ We're now going to loop through the words in TABLE, so
                        \ set Y as an index we can add to PROT1 (i.e. ZP) to
                        \ reach TABLE

.PROT1a

 LDA (ZP),Y             \ Set SC(1 0) = ZP(1 0) + Y-th word from TABLE
 CLC                    \
 ADC ZP                 \ so, for example, the first entry in TABLE does this:
 STA SC                 \
 INY                    \   SC(1 0) = ZP + first word from TABLE
 LDA (ZP),Y             \           = PROT1 + jsr1 + 1 - PROT1
 ADC ZP+1               \           = jsr1 + 1
 STA SC+1               \
                        \ which is the address of the destination adress in the
                        \ JSR instruction at jsr1

 LDX #0                 \ Add ZP(1 0), i.e. PROT1, to the word at SC(1 0),
 LDA (SC,X)             \ starting with the low bytes
 CLC
 ADC ZP
 STA (SC,X)

 INC SC                 \ And then adding the high bytes
 BNE P%+4               \
 INC SC+1               \ So, for example, the first entry in TABLE modifies the
 LDA (SC,X)             \ destination address of the JSR at jsr1 by adding PROT1
 ADC ZP+1               \ to it, so the address now points to prstr
 STA (SC,X)

 INY                    \ Increment Y to point to the next word in TABLE

 CPY #&7D               \ Loop until we have done them all
 BNE PROT1a

 BEQ LOADSCR            \ Jump to LOADSCR (this BEQ is effectively a JMP as we
                        \ didn't take the BNE branch)

.TABLE

 EQUW jsr1 + 1 - PROT1  \ Offsets within PROT1 of JSR destination addresses that
 EQUW jsr2 + 1 - PROT1  \ we modify with the code above
 EQUW jsr3 + 1 - PROT1
 EQUW jsr4 + 1 - PROT1
 EQUW jsr5 + 1 - PROT1
 EQUW jsr6 + 1 - PROT1

