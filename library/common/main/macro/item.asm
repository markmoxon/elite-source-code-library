\ ******************************************************************************
\
\       Name: ITEM
\       Type: Macro
\   Category: Market
\    Summary: Macro definition for the market prices table
\  Deep dive: Market item prices and availability
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to build the market prices table:
\
\   ITEM price, factor, units, quantity, mask
\
\ It inserts an item into the market prices table at QQ23.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   price               Base price
\
\   factor              Economic factor
\
\   units               Units: "t", "g" or "k"
\
\   quantity            Base quantity
\
\   mask                Fluctuations mask
\
\ ******************************************************************************

MACRO ITEM price, factor, units, quantity, mask

 IF factor < 0
  s = 1 << 7
 ELSE
  s = 0
 ENDIF

 IF units = 't'
  u = 0
 ELIF units = 'k'
  u = 1 << 5
 ELSE
  u = 1 << 6
 ENDIF

 e = ABS(factor)

 EQUB price
 EQUB s + u + e
 EQUB quantity
 EQUB mask

ENDMACRO

