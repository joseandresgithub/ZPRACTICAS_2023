*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER12_02_000
*&
*&---------------------------------------------------------------------*
*&
*&Ejemplo CRUD e inner join
*&---------------------------------------------------------------------*

REPORT ZPR_CHAPTER12_02_002.

*Creamos un tipo que contiene los tipos de datos que nos interesan de ambas tablas
types: begin of lty_vuelos,
   carrid type s_carr_id,
   connid type s_conn_id,
   carrname type s_carrname,
   COUNTRYFR type land1,
   cityfrom type S_FROM_CIT,
   COUNTRYTO type land1,
   CITYTO type s_to_city,
end of lty_vuelos.


* pantalla
PARAMETERS p_car type s_carr_id.


* Datos
data lv_carrname type S_CARRNAME.
data lv_moneda type S_CURRCODE.
data ls_scarr type scarr.
data lt_scarr type table of scarr.

data lt_vuelos type table of lty_vuelos.
data ls_vuelos type lty_vuelos.

* Varios tipos de selección
select single carrname into lv_carrname from scarr where carrid = 'AA'. "Seleccionamos solo  los datos de una fila la cual introduciremos en lv_carrname.
select single carrname currcode into (lv_carrname, lv_moneda) from scarr where carrid = 'AA'."Seleccionamos los datos de 2 columnas (carrname, currcode) que introduciremos en la variables lv_carrname, lv_moneda.
select single carrname currcode into CORRESPONDING FIELDS OF ls_scarr from scarr where carrid = 'AA'."Introduce los datos de una fila que sus columnas corrrespondan con las del tipo de dato de ls_scarr
select carrname currcode into CORRESPONDING FIELDS OF table lt_scarr from scarr. " where carrid = 'AA'."Introduce los datos de la tabla SCARR que tengan las mismas columnas y tipo de dato en la tabla lt_scarr.

*
select * into corresponding fields of table lt_vuelos from scarr as a inner join spfli as b on ( a~carrid = b~carrid ) where a~carrid <> p_car.
"select * into corresponding fields of table lt_vuelos from scarr as a left outer join spfli as b on ( a~carrid = b~carrid ) where a~carrid <> p_car.

loop at lt_vuelos into ls_vuelos.
  at first.
    write: / sy-uline(120).
  endat.

  write: / sy-vline, ls_vuelos-carrid, sy-vline, ls_vuelos-carrname, sy-vline, ls_vuelos-connid, sy-vline, ls_vuelos-countryfr, sy-vline, ls_vuelos-cityfrom, sy-vline, ls_vuelos-countryto, sy-vline, ls_vuelos-cityto, sy-vline.
  write: / sy-uline(120).

endloop.

ls_scarr-carrid = 'IB'.
ls_scarr-carrname = 'Iberia'.
ls_scarr-currcode = 'EUR'.
ls_scarr-url = 'www.iberia.com'.

modify scarr from ls_scarr.
WRITE: / sy-subrc.
write: / sy-dbcnt.

*modify scarr from table lt_scarr.

delete from scarr  where carrid = 'ZZ'.
WRITE: / sy-subrc.
write: / sy-dbcnt.
