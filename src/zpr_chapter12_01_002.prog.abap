*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER12_01_002
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zpr_chapter12_01_002.

DATA lt_companias TYPE TABLE OF scarr. "Tabla que contendrá el resultado de la select.
DATA ls_compania TYPE scarr. "Dato que contendra el valor de una fila.

DATA lt_companias2 TYPE TABLE OF scarr with header line. "Tabla qcon linea de cabecera.

data lv_idx_corto type c LENGTH 4.

*Crea una pantalla de input separada.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-tit.

PARAMETERS p_car TYPE s_carr_id.
SELECT-OPTIONS s_car FOR ls_compania-carrid."Permite seleccionar un rango.

SELECTION-SCREEN END OF BLOCK b1.

*Selecciona todos los datos que coincidadn con la búsqueda.
SELECT *  INTO TABLE lt_companias FROM scarr WHERE carrid in s_car.
LOOP AT lt_companias INTO ls_compania.
  WRITE: / ls_compania-carrid, ls_compania-carrname, ls_compania-currcode, ls_compania-url.
ENDLOOP.
IF sy-subrc <> 0.
  WRITE: 'No se han encontrado datos.'.
ENDIF.

*Crea una linea horizontal.
WRITE: / sy-uline.

*Selecciona solo un valor de la tabla en caso de haber varios.
SELECT SINGLE * INTO ls_compania FROM scarr WHERE carrid = p_car.
IF sy-subrc = 0.
  WRITE: / ls_compania-carrid, ls_compania-carrname, ls_compania-currcode, ls_compania-url.
ELSE.
  WRITE: 'No se han encontrado datos.'.
ENDIF.

lt_companias2[] = lt_companias[].
*Al estar definida la tabla con cabecera (header line) podemos iterar sobre ella cn su propio nombre.
loop at lt_companias2.
  lv_idx_corto = sy-tabix.
  write: / lv_idx_corto, lt_companias2-carrid, lt_companias2-carrname, lt_companias2-currcode, lt_companias2-url.
ENDLOOP.

read table lt_companias2 INDEX 6.
write: / 'Valor en la posición 6: ',sy-tabix, lt_companias2-carrid, lt_companias2-carrname, lt_companias2-currcode, lt_companias2-url.
