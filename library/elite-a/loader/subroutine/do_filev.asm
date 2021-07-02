\ ******************************************************************************
\
\       Name: do_FILEV
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

 \ trap FILEV

.do_FILEV

 JSR restorews \ restore workspace

.old_FILEV

 JSR &100 \ address modified by master set-up

.savews

 PHP \ save workspace, copy in characters
 PHA
 PHX
 PHY
 LDA #8 \ select ROM workspace at &C000
 TSB VIA+&34
 LDX #0

.putws

 LDA &C000,X \ save absolute workspace

.put0

 STA &C000,X \ address modified by master set-up
 LDA &C100,X

.put1

 STA &C100,X \ address modified by master set-up
 LDA &C200,X

.put2

 STA &C200,X \ address modified by master set-up
 INX
 BNE putws
 LDA LATCH \ save ROM number
 PHA
 LDA #&80 \ select RAM from &8000-&8FFF
 STA LATCH
 STA VIA+&30
 LDX #0

.copych

 LDA &8900,X \ copy character definitions
 STA &C000,X
 LDA &8A00,X
 STA &C100,X
 LDA &8B00,X
 STA &C200,X
 INX
 BNE copych
 PLA \ restore ROM selection
 STA LATCH
 STA VIA+&30
 PLY
 PLX
 PLA
 PLP
 RTS

