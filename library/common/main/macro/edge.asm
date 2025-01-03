\ ******************************************************************************
\
\       Name: EDGE
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding edges to ship blueprints
\  Deep dive: Ship blueprints
\             Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   EDGE vertex1, vertex2, face1, face2, visibility
\
\ When stored in memory, bytes #2 and #3 contain the vertex numbers multiplied
\ by 4, so we can use them as indices into the heap at XX3 to fetch the screen
\ coordinates for each vertex, as they are stored as four bytes containing two
\ 16-bit numbers (see part 10 of the LL9 routine for details).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   vertex1             The number of the vertex at the start of the edge
\
\   vertex1             The number of the vertex at the end of the edge
\
\   face1               The number of face 1 associated with this edge
\
\   face2               The number of face 2 associated with this edge
\
\   visibility          The visibility distance, beyond which the edge is not
\                       shown
\
\ ******************************************************************************

MACRO EDGE vertex1, vertex2, face1, face2, visibility

 f = face1 + (face2 << 4)
 EQUB visibility, f, vertex1 << 2, vertex2 << 2

ENDMACRO

