\ ******************************************************************************
\
\       Name: COMIRQ1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: The split screen and sound interrupt handler (the IRQ interrupt
\             service hardware vector at &FFFE points here)
\  Deep dive: The split-screen mode in Commodore 64 Elite
\             Colouring the Commodore 64 bitmap screen
\
\ ******************************************************************************

.COMIRQ3

                        \ If we get here then we want to return from the
                        \ interrupt, so we first have to restore the registers
                        \ we want to preserve, and restore the correct memory
                        \ configuration

 PLA                    \ Retrieve the value of X we stored on the stack at the
 TAX                    \ start of the interrupt routine, so it is preserved

 LDA l1                 \ Set bits 0 to 2 of the port register at location l1
 AND #%11111000         \ (&0001) to bits 0 to 2 of L1M, leaving bits 3 to 7
 ORA L1M                \ unchanged
 STA l1                 \
                        \ This sets LORAM, HIRAM and CHAREN to the values in
                        \ L1M, which ensures we return memory to the same
                        \ configuration as when we entered the interrupt routine

 PLA                    \ Retrieve the value of A we stored on the stack at the
                        \ start of the interrupt routine, so it is preserved

 RTI                    \ Return from the interrupt

.COMIRQ1

 PHA                    \ Store A on the stack, so we can preserve it across
                        \ calls to the interrupt handler

 LDA l1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ l1 to %101 to set the input/output port to the
 ORA #%00000101         \ following:
 STA l1                 \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

.iansint

 LDA VIC+&19            \ Set bit 7 of VIC register &19, to acknowledge any IRQ
 ORA #%10000000         \ interrupts that are pending
 STA VIC+&19            \
                        \ I'm not sure why we acknowledge IRQ interrupts by
                        \ setting bit 7 rather than setting bit 0 to acknowledge
                        \ the raster interrupt, but perhaps this prevents any
                        \ pending IRQ interrupts from being triggered and
                        \ messing up the timing of the split screen and sound
                        \ interrupt routines

 TXA                    \ Store X on the stack, so we can preserve it across
 PHA                    \ calls to the interrupt handler

 LDX RASTCT             \ Set X to the current raster count
                        \
                        \ The code below flips this on each interrupt between
                        \ the two values in innersec, which are set to 0 and 1,
                        \ so X oscillates between 0 and 1 each time the
                        \ interrupt routine is called
                        \
                        \ The COMIRQ1 interrupt handler is called when the
                        \ raster interrupt is triggered, which happens when the
                        \ VIC-II starts to draw the raster lines defined in the
                        \ shango variable (see below)
                        \
                        \ These raster lines coincide with the top of the screen
                        \ and the top of the dashboard, so this routine gets
                        \ called twice on each screen redraw, once when the
                        \ raster starts drawing the top of the screen, and again
                        \ when the raster returns to the top of the dashboard
                        \
                        \ When the interrupt routine is called at the top of the
                        \ screen, the value of RASCT is 0, so the various VIC-II
                        \ registers in the following get set up for the upper
                        \ part of the screen; this includes setting the raster
                        \ interrupt to fire at the top of the dashboard. RASCT
                        \ is flipped to a value of 1 after the upper part of the
                        \ screen has been configured
                        \
                        \ When the raster reaches the top of the dashboard, the
                        \ interrupt routine is called and RASCT is still 1, so
                        \ the screen is configured for the dashboard (if there
                        \ is one); this includes setting the raster interrupt to
                        \ fire at the top of the screen once again. RASCT is
                        \ flipped back to a value of 0 after the lower part of
                        \ the screen has been configured, ready for the whole
                        \ process to repeat
                        \
                        \ So, in the following:
                        \
                        \   * X = RASCT = 0 indicates that we are drawing the
                        \                   upper part of the screen
                        \
                        \   * X = RASCT = 1 indicates that we are drawing the
                        \                   lower part of the screen

 LDA zebop,X            \ Set VIC register &18 to the value in zebop (when
 STA VIC+&18            \ X = 0, for the upper part of the screen) or abraxas
                        \ (when X = 1, for the lower part of the screen)
                        \
                        \ zebop is always set to &81, which will set the address
                        \ of screen RAM to offset &2000 within the VIC-II bank
                        \ at &4000 (so the screen's colour data is at &6000)
                        \
                        \ abraxas is &81 by default, in which case this will
                        \ also set screen RAM to &6000, but the wantdials
                        \ routine sets it to &91 when we need to display the
                        \ space view and the dashboard, which sets the address
                        \ of screen RAM to offset &2400 within the VIC-II bank
                        \ at &4000 (so the screen's colour data is at &6400)
                        \
                        \ In other words:
                        \
                        \   * When abraxas is &81, the colour of the lower part
                        \     of the screen is determined by screen RAM at &6000
                        \     (i.e. when the dashboard is not being shown)
                        \
                        \   * When abraxas is &91, the colour of the lower part
                        \     of the screen is determined by screen RAM at &6400
                        \     (i.e. when the dashboard is being shown)
                        \
                        \ This enables us to colour the dashboard independently
                        \ from the corresponding lower part of the text view

 LDA moonflower,X       \ Set VIC register &16 to the value in moonflower (when
 STA VIC+&16            \ X = 0, for the upper part of the screen) or
                        \ caravanserai (when X = 1, for the lower part of the
                        \ screen)
                        \
                        \ moonflower has bit 4 clear by default, so this sets
                        \ the upper part of the screen to standard bitmap mode,
                        \ for the space and text views
                        \
                        \ Bit 4 of moonflower gets set in part 3 of the main
                        \ flight loop when the energy bomb is set off, which
                        \ changes the space view into multicolour bitmap mode
                        \ for the duration of the explosion; this makes the
                        \ space view turn into a coloured mess of double-width
                        \ pixels while the energy bomb is going off
                        \
                        \ Bit 4 of moonflower gets cleared again in the BOMBOFF
                        \ routine, which is called once the energy bomb has
                        \ finished exploding
                        \
                        \ caravanserai has bit 4 clear by default, which sets
                        \ the lower part of the screen to standard bitmap mode,
                        \ but the wantdials routine sets bit 4 when we need to
                        \ display the space view and the dashboard, so this
                        \ ensures that the dashboard in the lower part of the
                        \ screen is shown in multicolour bitmap mode

 LDA shango,X           \ Set VIC register &12 to the X-th entry in shango,
 STA VIC+&12            \ which configures a raster interrupt to fire when the
                        \ VIC-II reaches the relevant line
                        \
                        \ When X = 0, we are currently configuring the VIC-II
                        \ for the upper part of the screen, so this sets the
                        \ next interrupt to fire at line 51 + 143, which is at
                        \ the top of the dashboard
                        \
                        \ When X = 1, we are currently configuring the VIC-II
                        \ for the lower part of the screen, this sets the next
                        \ interrupt to fire at line 51, which is at the top of
                        \ the visible screen
                        \
                        \ So this ensures that the interrupt routine will be
                        \ called once the raster reaches the next line at which
                        \ we need to reconfigure the VIC-II

 LDA santana,X          \ Set VIC register &12 to the X-th entry in santana,
 STA VIC+&1C            \ so it sets bit 1 of the register for the upper part of
                        \ the screen, and clears it again for the lower part
                        \
                        \ This switches sprite 1, the explosion sprite, between
                        \ multicolour in the upper part of the screen and single
                        \ colour in the bottom part

 LDA lotus,X            \ Set VIC register &28 to the X-th entry in lotus, so
 STA VIC+&28            \ this sets the colour of sprite 1 to red (colour 2)
                        \ when it's in the upper part of the screen, and to
                        \ colour 0 in the lower part of the screen
                        \
                        \ As we just switched sprite 1 between multicolour and
                        \ single colour mode (for the upper and lower parts of
                        \ the screen respectively), this means the explosion
                        \ sprite appears in multicolour in the space view (as
                        \ VIC+&28 is used to define the colour of %10 bits in
                        \ the bitmap, so those are shown in red), but in the
                        \ lower part of the screen the sprite is single colour
                        \ with any set bits mapped to colour 0, making the
                        \ sprite transparent
                        \
                        \ In other words, this restricts the explosion sprite
                        \ to appear in the space view only, so explosions don't
                        \ occur in front of the dashboard

 BIT BOMB               \ If bit 7 of BOMB is zero then the energy bomb is not
 BPL nobombef           \ currently going off, so jump to nobombef to skip the
                        \ following instruction

 INC welcome            \ The energy bomb is going off, so increment welcome so
                        \ we work our way through a range of background colours

.nobombef

 LDA welcome,X          \ Set VIC register &21 to the X-th entry in welcome, so
 STA VIC+&21            \ we change the background colour of the space view
                        \ through a whole range of colours while the energy bomb
                        \ is going off
                        \
                        \ The value of welcome+1 is never changed, so the colour
                        \ change only applies to the upper part of the screen,
                        \ i.e. the space view
                        \
                        \ The value of welcome gets set to 0 in the BOMBOFF
                        \ routine, which is called once the energy bomb has
                        \ finished exploding, so this stops the background
                        \ colour from changing

 LDA innersec,X         \ Set RASCT to the X-th entry from innersec, so this
 STA RASTCT             \ flips the value of RASCT from 0 to 1 or from 1 to 0

 BNE COMIRQ3            \ If we just flipped RASCT from 0 to 1 then jump to
                        \ COMIRQ3 to return from the interrupt handler

                        \ We now play the background music, if configured
                        \
                        \ The BNE above means that we only do the following
                        \ every other call to the interrupt handler, which is
                        \ once per frame (so that's 60 or 50 times a second,
                        \ depending on whether this is an NTSC or PAL machine)

 TYA                    \ Store Y on the stack, so we can preserve it across
 PHA                    \ calls to the interrupt handler

 BIT MUPLA              \ If bit 7 of MUPLA is clear then there is no music
 BPL SOINT              \ currently playing, so jump to SOINT to make any sound
                        \ effects that are in progress

 JSR BDirqhere          \ Play the background music for this frame

 BIT MUSILLY            \ If bit 7 of MUSILLY is set then sounds are configured
 BMI SOINT              \ to be played during music, and we know that music is
                        \ already playing, so jump to SOINT to make any sound
                        \ effects that are in progress

 JMP coffee             \ Otherwise sounds are configured not to play during
                        \ music, and we know that music is playing, so jmp to
                        \ coffee to return from the interrupt handler without
                        \ making the sound effect

