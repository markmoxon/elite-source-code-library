\ ******************************************************************************
\
\       Name: Elite loader
\       Type: Subroutine
\   Category: Loader
\    Summary: Reset vectors, change to mode 7, and load and run the ELITE3
\             loader
\
\ ******************************************************************************

.ENTRY

 LDA #0                 \ Call OSBYTE with A = 0 and X = 1 to fetch bit 0 of the
 LDX #1                 \ operating system version into X
 JSR OSBYTE

 LDY #0                 \ Set Y to 0 so we can use it as an index for setting
                        \ all the vectors to their default states

 SEI                    \ Disable all interrupts

 CPX #1                 \ If X = 1 then this is OS 1.20, so jump to os120
 BEQ os120

.os100

 LDA &D941,Y            \ Copy the Y-th byte from the default vector table at
 STA &200               \ &D941 into location &0200 (this is surely supposed to
                        \ be the Y-th byte in &0200, i.e. STA &200,Y, but it
                        \ isn't, which feels like a bug)

 INY                    \ Increment the loop counter

 CPY #54                \ Loop back to copy the next byte until we have copied
 BNE os100              \ 54 bytes (27 vectors)

 BEQ disk               \ Jump down to disk to skip the OS 1.20 routine

.os120

 LDA &FFB7              \ Set ZP(1 0) to the location stored in &FFB7-&FFB8,
 STA ZP                 \ which contains the address of the default vector table
 LDA &FFB8
 STA ZP+1

.ABCDEFG

 LDA (ZP),Y             \ Copy the Y-th byte from the default vector table into
 STA &200,Y             \ the vector table in &0200

 INY                    \ Increment the loop counter

 CPY &FFB6              \ Compare the loop counter with the contents of &FFB6,
                        \ which contains the length of the default vector table

 BNE ABCDEFG            \ Loop back for the next vector until we have done them
                        \ all

.disk

 CLI                    \ Re-enable interrupts

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("DISK")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which
                        \ switches to the disc filing system (DFS)

 LDA #201               \ Call OSBYTE with A = 201, X = 1 and Y = 0 to disable
 LDX #1                 \ the keyboard
 LDY #0
 JSR OSBYTE

 LDA #200               \ Call OSBYTE with A = 200, X = 0 and Y = 0 to enable
 LDX #0                 \ the ESCAPE key and disable memory clearing if the
 LDY #0                 \ BREAK key is pressed
 JSR OSBYTE

 LDA #119               \ Call OSBYTE with A = 119 to close any *SPOOL or *EXEC
 JSR OSBYTE             \ files

 LDY #0                 \ Set Y to 0 so we can use it as an index for the
                        \ following, which has been disabled (so perhaps this
                        \ was part of the copy protection)

.loop1

 LDA BLOCK,Y            \ Fetch the Y-th byte from BLOCK

 NOP                    \ This instruction has been disabled, so this loop does
                        \ nothing

 INY                    \ Increment the loop counter

 CPY #9                 \ Loop back to do the next byte until we have done 9 of
 BNE loop1              \ them

 LDY #0                 \ We are now going to send the 12 VDU bytes in the table
                        \ at B% to OSWRCH to switch to mode 7

.loop2

 LDA B%,Y               \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #12                \ Loop back for the next byte until we have done all 10
 BNE loop2              \ of them

.load3

 LDX #LO(MESS2)         \ Set (Y X) to point to MESS2 ("LOAD Elite3")
 LDY #HI(MESS2)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS2, which loads
                        \ the ELITE3 binary to its load address of &5700

 JMP &5700              \ Jump to the start of the ELITE3 loader code at &5700

