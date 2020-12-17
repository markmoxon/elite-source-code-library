\ ******************************************************************************
\
\       Name: CTWOS
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Ready-made single-pixel character row bytes for mode 2
\
\ ------------------------------------------------------------------------------
\
\ Ready-made bytes for plotting one-pixel points in mode 2 (the bottom part of
\ the split screen).
\
\ In mode 2, each character row is one byte, which is two pixels. Rows 0 and 1
\ of the table contain a character row byte with just the left pixel plotted,
\ while rows 2 and 3 contain a character row byte with just the right pixel
\ plotted.
\
\ In other words, looking up row X will return a character row byte with pixel
\ X/2 plotted (if the pixels are numbered 0 and 1).
\
\ There are two extra rows to support the use of CTWOS+2,X indexing in the CPIX2
\ routine. The extra rows are repeats of the first two rows, and save us from
\ having to work out whether CTWOS+2+X needs to be wrapped around when drawing a
\ two-pixel dash that crosses from one character block into another. See CPIX2
\ for more details.
\
\ ******************************************************************************

.CTWOS

 EQUB %10101010
 EQUB %10101010
 EQUB %01010101
 EQUB %01010101
 EQUB %10101010
 EQUB %10101010

