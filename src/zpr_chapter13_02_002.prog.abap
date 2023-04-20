*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER13_02_002
*&
*&---------------------------------------------------------------------*
*&
*&Acceso a ficheros
*&---------------------------------------------------------------------*

REPORT zpr_chapter13_02_002.

DATA lt_ca TYPE TABLE OF scarr.
DATA ls_ca TYPE scarr.
DATA lv_file_output TYPE string.
DATA lv_file_input TYPE string.
DATA ls_line TYPE string.
DATA ls_line_csv TYPE string.
DATA ls_nombre_comp TYPE string.
DATA ls_web TYPE string.
DATA lt_line_csv TYPE TABLE OF string.

DATA lv_lineas TYPE i.

PARAMETERS p_file TYPE string DEFAULT 'tabla_scarr_002.csv' LOWER CASE. "Declaramos el parámetro con su valor por defecto el cual será el nombre del archivo a crear.

SELECT * FROM scarr INTO TABLE lt_ca. "Extraemos los detados que vamos a introducir en el archivo y los metemos en la tabla creada anteriormente.

OPEN DATASET p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "Abrimos el dataset, le decimos que sra de tipo output (Escritura) y que utilizará codificación por defecto.
"open DATASET p_file for APPENDING in TEXT MODE ENCODING DEFAULT. "De esta forma se usaria para hacer append.

* ---------------------------------------------------------------------
* Escritura del fichero
* ---------------------------------------------------------------------

IF sy-subrc = 0."Si ha sido capaz de crear el fichero...
  LOOP AT lt_ca INTO ls_ca.
    TRANSFER ls_ca TO p_file. "Escribe una linea en el fichero con el valor de la fila leida de la tabla.
  ENDLOOP.
  CLOSE DATASET p_file. "Cerramos el dataset.
  DESCRIBE TABLE lt_ca LINES lv_lineas. "Sacamos el numero de lineas de la tabla.
  WRITE: / 'Lineas añadadidas al archivo', lv_lineas.
ELSE.
  WRITE: / 'No se puede abrir el archivo'.
ENDIF.

* ---------------------------------------------------------------------
* Lectura del fichero
* ---------------------------------------------------------------------

lv_file_input = p_file.
OPEN DATASET lv_file_input FOR INPUT IN TEXT MODE ENCODING DEFAULT. "Abrimos el dataset, le decimos que sra de tipo input (Lectura) y que utilizará codificación por defecto.

IF sy-subrc = 0. "Si ha sido capaz de leer el archivo...
  WRITE: / 'Entradas en el fichero', p_file, /.

  DO.
    READ DATASET lv_file_input INTO ls_line. "Leemos una linea del fichero y asignamos el valor a la variable 'ls_line'.

    IF sy-subrc <> 0. EXIT. ENDIF. "Mientras haya lineas que leer...

    ls_web = ls_line+29.
    condense ls_web.
    ls_nombre_comp = ls_line+6(20).
    condense ls_nombre_comp.

    ls_line_csv = ls_line(3) && ';' && ls_line+3(2) && ';' && ls_nombre_comp && ';' && ls_line+26(3) && ';' && ls_web. "Modificamos la linea leida con formato csv.
    APPEND ls_line_csv TO lt_line_csv. "Añadimos la linea anterior a la tabla.
    "CONDENSE ls_line_csv. "Hacemos trim al string.

    WRITE: / ls_line. "Mostramos cada linea sin formato por pantalla.
    WRITE: / ls_line_csv, /. "Mostramos cada linea con formato csv por pantalla.

  ENDDO.

ELSE.
  WRITE: / 'No hay datos.'.
ENDIF.
