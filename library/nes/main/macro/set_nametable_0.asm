\ ******************************************************************************
\
\       Name: SET_NAMETABLE_0
\       Type: Macro
\   Category: NES graphics
\    Summary: Switch the base nametable address to nametable 0 (&2000) when
\             conditions are met
\
\ ******************************************************************************

MACRO SET_NAMETABLE_0

 LDA L00E9              \ If bit 7 of L00E9 and bit 6 of PPUSTATUS are set, then
 BPL skip               \ call LD06D to:
 LDA PPUSTATUS          \
 ASL A                  \   * Zero L00E9 to disable calls to NAMETABLE0 until
 BPL skip               \     both conditions are met once again
 JSR NAMETABLE0         \
                        \   * Clear bits 0 and 4 of L00F5 and PPUCTRL, to set
                        \     the base nametable address to &2000 (nametable 0)
                        \     or &2800 (which is a mirror of &2000)
                        \
                        \   * Clear the C flag
 
.skip

ENDMACRO

