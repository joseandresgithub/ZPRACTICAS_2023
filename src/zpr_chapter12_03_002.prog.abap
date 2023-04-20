*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER12_03_000
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zpr_chapter12_03_002.


SELECT-OPTIONS s_fec FOR sy-datum."Parametros desde - hasta de tipo fecha.


*Creamos un tipo nuevo que definirá los campos de la tabla local.
TYPES: BEGIN OF lty_importes,
        contador TYPE i,
        neto TYPE p DECIMALS 2,
        moneda TYPE waerk,
END OF lty_importes.

DATA lv_contador TYPE i.
DATA lv_neto TYPE p DECIMALS 2.
DATA lt_importes TYPE TABLE OF lty_importes."Declaramos la tabla y asignamos el tipo creado anteriormente.

*Select con varios filtros
SELECT COUNT(*) AS contador
   SUM( netwr ) AS neto
   waerk AS moneda
   INTO CORRESPONDING FIELDS OF TABLE lt_importes
   FROM vbak
   WHERE erdat IN s_fec
   GROUP BY waerk.

*Recorremos la tabla y escribimos el resultdo de cada campo.
LOOP AT lt_importes INTO DATA(ls_importes).
  WRITE: / ls_importes-contador, ls_importes-neto, ls_importes-moneda.
ENDLOOP.

BREAK-POINT.

SELECT COUNT(*) SUM( netwr ) FROM vbak INTO ( lv_contador, lv_neto )  WHERE erdat IN s_fec.

WRITE: / lv_contador, lv_neto.
