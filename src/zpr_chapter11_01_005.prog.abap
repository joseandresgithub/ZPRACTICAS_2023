*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER11_01_000
*&
*&---------------------------------------------------------------------*
*&
*&Practica tablas
*&---------------------------------------------------------------------*

REPORT zpr_chapter11_01_005.

INCLUDE zpr_mistipos.

*TYPES: BEGIN OF lty_scarr,
*  mandt TYPE  s_mandt,
*  carrid TYPE  s_carr_id,
*  carrname TYPE  s_carrname,
*  currcode TYPE  s_currcode,
*  url TYPE  s_carrurl,
*END OF lty_scarr.

*Estructura y tabla de tipo scarr
DATA ls_scarr TYPE lty_scarr.
DATA lt_scarr TYPE TABLE OF lty_scarr.

DATA ls_uno_to_cuatro TYPE zpr_scarr.               "Estructura tipo uno, dos, tres y cuatro.
DATA lt_uno_to_cuatro TYPE TABLE OF zpr_scarr.      "Tabla normal de tipo uno, dos, tres y cuatro.
DATA lt_uno_to_cuatro_5 TYPE TABLE OF zpr_scarr.    "Otra tabla igual, tipo uno, dos, tres y cuatro.
DATA lt_uno_to_cuatro2 TYPE zpr_t_scarr.            "Tabla creada con una tabla global

DATA lt_uno_to_cuatro_3 TYPE SORTED TABLE OF zpr_scarr WITH NON-UNIQUE KEY uno. "Tabla supuestamente ordenada de tipo uno, dos, tres y cuatro.
*DATA lt_uno_to_cuatro_4 TYPE HASHED TABLE OF zpr_scarr WITH UNIQUE KEY uno.    "Tabla hashed de tipo uno, dos, tres y cuatro.

*Rellenamos la estructura para introducirla a la tabla
ls_uno_to_cuatro-uno = 'h'.
ls_uno_to_cuatro-dos = 'ho'.
ls_uno_to_cuatro-tres = 'hol'.
ls_uno_to_cuatro-cuatro = 'hola'.

*Se introduce a las tablas (append es al final)
APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro_3.
*APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro_4.
APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro.

*Se cambian los valores de la estructura para introducir otros
ls_uno_to_cuatro-uno = 'a'.
ls_uno_to_cuatro-dos = 'al'.
ls_uno_to_cuatro-tres = 'alo'.
ls_uno_to_cuatro-cuatro = 'aloh'.

*Se introduce varias veces a la tabla normal (a la ordenada no permite introducir valores que interfieren en la ordenación).
APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro.
APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro.
APPEND ls_uno_to_cuatro TO lt_uno_to_cuatro.

*Bucle para recorrer la tabla normal e imprimirla
LOOP AT lt_uno_to_cuatro INTO ls_uno_to_cuatro.
  WRITE: / ls_uno_to_cuatro-uno.
  WRITE: / ls_uno_to_cuatro-dos.
  WRITE: / ls_uno_to_cuatro-tres.
  WRITE: / ls_uno_to_cuatro-cuatro.
ENDLOOP.

lt_uno_to_cuatro_5[] = lt_uno_to_cuatro[].    "Clonamos la tabla que hemos usado en otra del mismo tipo

DATA(ls_copia) = ls_uno_to_cuatro.            "Creamos una variable en el acto y la usamos para clonar la estructura anterior.

APPEND LINES OF lt_uno_to_cuatro FROM 1 TO 2 TO lt_uno_to_cuatro_5. "Se introducen al final de la tabla varias líneas de otra tabla

INSERT ls_copia INTO lt_uno_to_cuatro_5 INDEX 3.    "Con insert tienes que especificar el sitio donde se inserta moviendo el resto de registros una posición
INSERT LINES OF lt_uno_to_cuatro INTO lt_uno_to_cuatro_5 INDEX 3. "Se insertan varias líneas de otra tabla en esa posición

*NEW-LINE.
WRITE: /,/. "Saltos de línea para ver las dos tablas separadas

*Recorremos la tabla e imprimimos sus valores
LOOP AT lt_uno_to_cuatro_5 INTO ls_uno_to_cuatro.
  WRITE: / ls_uno_to_cuatro-uno.
  WRITE: / ls_uno_to_cuatro-dos.
  WRITE: / ls_uno_to_cuatro-tres.
  WRITE: / ls_uno_to_cuatro-cuatro.
ENDLOOP.

LOOP AT lt_uno_to_cuatro_5 INTO ls_uno_to_cuatro.

   WRITE: / 'Resultado actual, num de fila: ', sy-tabix,
          ls_uno_to_cuatro-uno,
          ls_uno_to_cuatro-dos,
          ls_uno_to_cuatro-tres,
          ls_uno_to_cuatro-cuatro.

  AT FIRST.
    WRITE: / 'Leo el primer resultado de la tabla',
          ls_uno_to_cuatro-uno,
          ls_uno_to_cuatro-dos,
          ls_uno_to_cuatro-tres,
          ls_uno_to_cuatro-cuatro.
  ENDAT.

  AT LAST.
    WRITE: / 'Leo el último resultado de la tabla',
          ls_uno_to_cuatro-uno,
          ls_uno_to_cuatro-dos,
          ls_uno_to_cuatro-tres,
          ls_uno_to_cuatro-cuatro.
    WRITE: / 'Total de filas en la tabla: ', sy-tabix.
  ENDAT.
ENDLOOP.
