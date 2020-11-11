\ ******************************************************************************
\
\       Name: EDGE
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding edges to ship blueprints
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   EDGE vertex1, vertex2, face1, face2, visibility
\
\ See the deep dive on "Ship blueprints" for details of how edges are stored
\ in ship blueprints.
\
\ ******************************************************************************

MACRO EDGE vertex1, vertex2, face1, face2, visibility
  f = face1 + (face2 << 4)
  EQUB visibility, f, vertex1 << 2, vertex2 << 2
ENDMACRO

