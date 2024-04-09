\ ******************************************************************************
\
\       Name: FileHandler
\       Type: Subroutine
\   Category: Loader
\    Summary: The custom file handler that checks whether OSFILE is loading a
\             ship blueprint file and if so, redirects the load to sideways RAM
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y X)               The address of the OSFILE parameter block
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\   (Y X)               (Y X) is preserved
\
\ ******************************************************************************

.FileHandler

 PHA                    \ Store A on the stack, so we can preserve it through
                        \ the subroutine call

 STX &F0                \ Store (Y X) in (&F1 F0), so we can preserve it through
 STY &F1                \ the subroutine call (&F0 and F1 are reserved by the
                        \ MOS for storing the values of X and Y during OS calls,
                        \ so we can use them accordingly)

 LDY #0                 \ Set (&F3 F2) to the address at (Y X)
 LDA (&F0),Y            \
 STA &F2                \ (Y X) points to the OSFILE parameter block, and the
 INY                    \ first entry in the parameter block is the address of
 LDA (&F0),Y            \ the filename being loaded, so this sets (&F3 F2) to
 STA &F3                \ the address of the filename, terminated by a carriage
                        \ return

                        \ We now check whether the file that's being loaded by
                        \ OSFILE matches the pattern in filenamePattern
                        \
                        \ The patten contains D.MO, then a zero, then a carriage
                        \ return
                        \
                        \ The following code matches the zero with any filename
                        \ character, so this pattern matches the ship blueprint
                        \ files from D.MOA to D.MOP (it also matches files D.MOQ
                        \ to D.MOZ and so on, but this isn't an issue as Elite
                        \ doesn't load those files)

 LDY #5                 \ Set a counter in Y to loop through the six characters
                        \ in the filename pattern to match

.file1

 LDA filenamePattern,Y  \ Set A to the Y-th character to match from the filename
                        \ pattern

 BEQ file2              \ If the character fetched is zero then this matches any
                        \ character, so jump to file2 to move on to the next
                        \ character in the pattern

 CMP (&F2),Y            \ If the Y-th character in the pattern doesn't match the
 BNE file5              \ Y-th character in the OSFILE filename, then we are not
                        \ loading a ship blueprint file, so jump to file5 to
                        \ pass the OSFILE call down the vector chain to FILEV
                        \ via IND1V

.file2

 DEY                    \ Decrement the loop counter to move on to the next
                        \ character to match

 BPL file1              \ Loop back until we have matched all six characters

                        \ If we get here then OSFILE has been called to load a
                        \ ship blueprint file, so we want to intercept it to
                        \ point the game to the ship blueprints in sideways RAM
                        \ instead
                        \
                        \ We do this by copying the ROM_XX21 table from the
                        \ Elite ROM in sideways RAM to XX21 in the main flight
                        \ code (which is where the ship blueprint file would
                        \ normally be loaded)
                        \
                        \ ROM_XX21 contains addresses for all of the ship
                        \ blueprints in sideways RAM, so this ensures that when
                        \ the game fetches any data from a ship blueprint, it
                        \ fetches it from the Elite ROM
                        \
                        \ We don't need to copy an entire page of data from the
                        \ ROM to XX21 (we only need to copy the XX21 and E%
                        \ tables), but copying 256 bytes keeps the loop logic
                        \ simple

 INY                    \ Increment Y to 0, so we can use it as a byte counter

.file3

 LDA ROM_XX21,Y         \ Copy the Y-th byte of ROM_XX21 to XX21
 STA XX21,Y

 INY                    \ Increment the byte counter

 BNE file3              \ Loop back until we have copied all 256 bytes from the
                        \ start of the Elite ROM to XX21 in the main flight code

                        \ We now check whether the ship blueprint file being
                        \ loaded needs to contain a Coriolis space station, as
                        \ the ROM_XX21 table has the address of the Dodo station
                        \ as its second blueprint, which might not be what we
                        \ want

 LDY #4                 \ Set A to the fifth character of the ship blueprint
 LDA (&F2),Y            \ filename in (&F3 &F2), which contains the letter of
                        \ blueprint file (i.e. A for D.MOA, B for D.MOB and so
                        \ on)

 AND #%00000001         \ If the letter has an even ASCII code (which is true of
 BEQ file4              \ files B, D, F, H, J, L, N, P) then the file being
                        \ loaded needs to contain a Dodo station, which is the
                        \ default address of the ROM table, so jump to file4 to
                        \ skip the following as we already have the correct
                        \ XX21 address in XX21

 LDA coriolisStation    \ Set the second address in the XX21 table at XX21(3 2)
 STA XX21+2             \ to the address of the Coriolis space station, to
 LDA coriolisStation+1  \ override the Dodo station address that we just copied
 STA XX21+3             \ from the Elite ROM

.file4

 TSX                    \ Set X to the stack pointer, so &100+X is the address
                        \ of the next free space on the stack

 LDA &F4                \ Set A to the ROM bank number of the Elite ROM

 STA &100+4,X           \ Change the "previous ROM bank" that the MOS puts on
                        \ the stack when calling an extended vector, so the MOS
                        \ switches "back" to the Elite ROM after calling the
                        \ XFILEV handler, which ensures that the Elite ROM
                        \ remains switched into memory at &8000, so the game
                        \ code can load ship blueprint data directly from the
                        \ sideways RAM image

 STA LANGROM            \ Set the current language in MOS workspace to the Elite
                        \ ROM, to prevent any other language ROM from switching
                        \ into memory at &8000

 LDX &F0                \ Retrieve the value of (Y X) from (&F1 F0), so it is
 LDY &F1                \ unchanged by the routine

 PLA                    \ Retrieve the value of A from the stack, so it is
                        \ unchanged by the routine

 RTS                    \ Return from the subroutine, as we have processed the
                        \ request to load the file and do not want to pass it
                        \ on down the chain

.file5

 LDX &F0                \ Retrieve the value of (Y X) from (&F1 F0), so it is
 LDY &F1                \ unchanged by the routine

 PLA                    \ Retrieve the value of A from the stack, so it is
                        \ unchanged by the routine

 JMP (IND1V)            \ Jump to the IND1V vector, which we set above to point
                        \ to the original FILEV file vector, so this passes the
                        \ file operation on down the chain

