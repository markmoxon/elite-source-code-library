\ ******************************************************************************
\
\       Name: VERTEX
\       Type: Macro
\   Category: Drawing ships
\    Summary: Macro definition for adding vertices to ship blueprints
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the ship blueprints:
\
\   VERTEX x, y, z, face1, face2, face3, face4, visibility
\
\ See the deep dive on "Ship blueprints" for details of how vertices are stored
\ in ship blueprints.
\
\ ******************************************************************************

MACRO VERTEX x, y, z, face1, face2, face3, face4, visibility
  IF x < 0
    s_x = 1 << 7
  ELSE
    s_x = 0
  ENDIF
  IF y < 0
    s_y = 1 << 6
  ELSE
    s_y = 0
  ENDIF
  IF z < 0
    s_z = 1 << 5
  ELSE
    s_z = 0
  ENDIF
  s = s_x + s_y + s_z + visibility
  f1 = face1 + (face2 << 4)
  f2 = face3 + (face4 << 4)
  ax = ABS(x)
  ay = ABS(y)
  az = ABS(z)
  EQUB ax, ay, az, s, f1, f2
ENDMACRO

