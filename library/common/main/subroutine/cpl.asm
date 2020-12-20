\ ******************************************************************************
\
\       Name: cpl
\       Type: Subroutine
\   Category: Text
\    Summary: Print the selected system name
\  Deep dive: Generating system names
\
\ ------------------------------------------------------------------------------
\
\ Print control code 3 (the selected system name, i.e. the one in the crosshairs
\ in the Short-range Chart).
\
\ Other entry points:
\
\   cmn-1               Contains an RTS
\
\ ******************************************************************************

.cpl

 LDX #5                 \ First we need to backup the seeds in QQ15, so set up
                        \ a counter in X to cover three 16-bit seeds (i.e.
                        \ 6 bytes)

.TT53

 LDA QQ15,X             \ Copy byte X from QQ15 to QQ19
 STA QQ19,X

 DEX                    \ Decrement the loop counter

 BPL TT53               \ Loop back for the next byte to backup

 LDY #3                 \ Step 1: Now that the seeds are backed up, we can
                        \ start the name-generation process. We will either
                        \ need to loop three or four times, so for now set
                        \ up a counter in Y to loop four times

 BIT QQ15               \ Check bit 6 of s0_lo, which is stored in QQ15

 BVS P%+3               \ If bit 6 is set then skip over the next instruction

 DEY                    \ Bit 6 is clear, so we only want to loop three times,
                        \ so decrement the loop counter in Y

 STY T                  \ Store the loop counter in T

.TT55

 LDA QQ15+5             \ Step 2: Load s2_hi, which is stored in QQ15+5, and
 AND #%00011111         \ extract bits 0-4 by AND'ing with %11111

 BEQ P%+7               \ If all those bits are zero, then skip the following
                        \ 2 instructions to go to step 3

 ORA #%10000000         \ We now have a number in the range 1-31, which we can
                        \ easily convert into a two-letter token, but first we
                        \ need to add 128 (or set bit 7) to get a range of
                        \ 129-159

 JSR TT27               \ Print the two-letter token in A

 JSR TT54               \ Step 3: twist the seeds in QQ15

 DEC T                  \ Decrement the loop counter

 BPL TT55               \ Loop back for the next two letters

 LDX #5                 \ We have printed the system name, so we can now
                        \ restore the seeds we backed up earlier. Set up a
                        \ counter in X to cover three 16-bit seeds (i.e. 6
                        \ bytes)

.TT56

 LDA QQ19,X             \ Copy byte X from QQ19 to QQ15
 STA QQ15,X

 DEX                    \ Decrement the loop counter

 BPL TT56               \ Loop back for the next byte to restore

 RTS                    \ Once all the seeds are restored, return from the
                        \ subroutine

