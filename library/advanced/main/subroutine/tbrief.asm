\ ******************************************************************************
\
\       Name: TBRIEF
\       Type: Subroutine
\   Category: Missions
\    Summary: Start mission 3
\
\ ******************************************************************************

IF _MASTER_VERSION \ Comment

\.TBRIEF                \ These instructions are commented out in the original
\LDA TP                 \ source
\ORA #&10
\STA TP
\LDA #199
\JSR DETOK
\JSR YESNO
\BCC BAYSTEP
\LDY #HI(50000)
\LDX #LO(50000)
\JSR LCASH
\INC TRIBBLE
\JMP BAY

ELIF _NES_VERSION

.TBRIEF

 JSR ClearScreen_b3     \ Clear the screen by zeroing patterns 66 to 255 in
                        \ both pattern buffer, and clearing both nametable
                        \ buffers to the background tile

 LDA #&95               \ Clear the screen and and set the view type in QQ11 to
 JSR TT66               \ &95 (Text-based mission briefing)

 LDA TP                 \ Set bit 4 of TP to indicate that mission 3 has been
 ORA #%00010000         \ triggered
 STA TP

 LDA #199               \ Print extended token 199, which is the briefing for
 JSR DETOK_b2           \ the Trumbles mission

 JSR UpdateView         \ Update the view

 JSR YESNO              \ Call YESNO to wait until either "Y" or "N" is pressed

 CMP #1                 \ If "N" was pressed, then the mission was not accepted,
 BNE BAYSTEP            \ jump to BAYSTEP to go to the docking bay (i.e. show
                        \ the Status Mode screen)

 LDY #HI(50000)         \ Otherwise the mission was accepted, so subtract
 LDX #LO(50000)         \ 50,000 CR from the cash pot to pay for the Trumble
 JSR LCASH

 INC TRIBBLE            \ Increment the number of Trumbles from 0 to 1, so they
                        \ start breeding

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen)

ENDIF

