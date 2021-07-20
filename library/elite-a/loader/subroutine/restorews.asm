\ ******************************************************************************
\
\       Name: restorews
\       Type: Subroutine
\   Category: Loader
\    Summary: Restore the filing system workspace
\
\ ******************************************************************************

 \ restore ROM workspace

.restorews

 PHA                    \ Store A and X on the stack, so we can retrieve them
 PHX                    \ later to preserve them across calls to the subroutine

                        \ We now want to copy the first three pages from the
                        \ safe place back to &C00), reversing the copy that we
                        \ did in savews. As with savews, the location of the
                        \ safe place was poked directly into the get0, get1 and
                        \ get2 instructions below, back in part 1 of the loader

 LDX #0                 \ Set a byte counter in X so we can copy an entire page
                        \ of bytes, starting from 0

.getws

.get0

 LDA &C000,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the first page of the safe
                        \ place where we copied the filing system workspace in
                        \ the savews routine

 STA &C000,X            \ Copy the X-th byte from the first page of the safe
                        \ place to the X-th byte of the first page of the &C000
                        \ block

.get1

 LDA &C100,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the second page of the safe
                        \ place where we copied the filing system workspace in
                        \ the savews routine

 STA &C100,X            \ Copy the X-th byte from the second page of the safe
                        \ place to the X-th byte of the second page of the &C000
                        \ block (i.e. &C100)

.get2

 LDA &C200,X            \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it points to the third page of the safe
                        \ place where we copied the filing system workspace in
                        \ the savews routine

 STA &C200,X            \ Copy the X-th byte from the third page of the safe
                        \ place to the X-th byte of the third page of the &C000
                        \ block (i.e. &C200)

 INX                    \ Increment the byte counter

 BNE getws              \ Loop back until we have copied a whole page of bytes
                        \ (three times)

 PLX                    \ Retore A and X from the stack, so they are preserved
 PLA                    \ by the subroutine

 RTS                    \ Return from the subroutine

