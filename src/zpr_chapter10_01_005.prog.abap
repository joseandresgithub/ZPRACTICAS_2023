*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER10_01_005
*&
*&---------------------------------------------------------------------*
*&
*&Ejercicio clase local
*&---------------------------------------------------------------------*

REPORT zpr_chapter10_01_005.

TYPES: BEGIN OF telefono,
       prefijo TYPE c LENGTH 3,
       numero TYPE n LENGTH 9,
  END OF telefono.


CLASS usuario DEFINITION.
  PUBLIC SECTION.
    DATA lv_usuario TYPE string.
    DATA lv_contrasenia type string.
    DATA lv_telefono type telefono.
    DATA lv_fecha_nac type d.
    METHODS set_usuario
      IMPORTING iv_nombre type string.
    METHODS set_contrasenia
      IMPORTING iv_pass type string.
    METHODS set_telefono
      IMPORTING iv_tlf type telefono.
    METHODS set_fecha
      IMPORTING iv_fecha type d.
    METHODS set_edad
      IMPORTING iv_fecha type d
      RETURNING VALUE(rv_edad) TYPE i.
ENDCLASS.

CLASS usuario IMPLEMENTATION.
   METHOD set_usuario.
     me->lv_usuario = iv_nombre.
   endmethod.
    METHOD set_contrasenia.
      me->lv_contrasenia = iv_pass.
    endmethod.
    METHOD set_telefono.
      me->lv_telefono = iv_tlf.
    endmethod.
    METHOD set_fecha.
      me->lv_fecha_nac = iv_fecha.
    endmethod.
    METHOD set_edad.
      data lv_nac type d.
      lv_nac = iv_fecha.
      rv_edad = ( sy-datum - lv_nac ) div '365'.
    endmethod.
ENDCLASS.

START-OF-SELECTION.

data lv_edad type i.
data lv_numero type telefono.
lv_numero-prefijo = '+34'.
lv_numero-numero = '612345678'.
data lv_usuario type string value 'Pepe'.
data lv_contrasenia type string value '123456'.
data lv_fecha_nac type d value '19920628'.


data: usuario1 type REF TO usuario.

create OBJECT usuario1.

call METHOD usuario1->set_edad
      EXPORTING iv_fecha = lv_fecha_nac
      RECEIVING rv_edad = lv_edad.

call METHOD usuario1->set_telefono
      EXPORTING iv_tlf = lv_numero.

call METHOD usuario1->set_usuario
      EXPORTING iv_nombre = lv_usuario.

call METHOD usuario1->set_contrasenia
      EXPORTING iv_pass = lv_contrasenia.

call METHOD usuario1->set_fecha
      EXPORTING iv_fecha = lv_fecha_nac.

write: / 'Usuario:', usuario1->lv_usuario.
write: / 'Contraseña:', usuario1->lv_contrasenia.
write: / 'Fecha de nacimiento:', usuario1->lv_fecha_nac DD/MM/YYYY.
WRITE: / 'Edad:',lv_edad.
write: / 'Teléfono:',usuario1->lv_telefono-prefijo,usuario1->lv_telefono-numero.
