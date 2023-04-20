*&---------------------------------------------------------------------*
*& Report  ZP_TEST_02_00
*&
*&---------------------------------------------------------------------*
*& Primer programa de prueba
*&
*&---------------------------------------------------------------------*

REPORT ZP_TEST_02_00.

data lv_usuario type string value 'admin'.
data lv_pass type string value 'Admin'.

data lv_fecha type d.
data lv_tiempo type t.
data lv_suma type p.

lv_fecha = sy-datum.
lv_tiempo = sy-UZEIT.

PARAMETERS p_usu type string OBLIGATORY LOWER CASE. "contempla el uso de minúsculas
PARAMETERS p_pass type string OBLIGATORY LOWER CASE.

IF P_USU = lv_usuario.
  IF p_pass = LV_PASS.
    write 'Usuario logueado correctamente'.
    write: / 'Fecha:',lv_fecha DD/MM/YYYY,/ 'Hora:',LV_TIEMPO+0(2) && ':' && LV_TIEMPO+2(2) && ':' && LV_TIEMPO+4(2).
    PARAMETERS p_num1 type p DECIMALS 2 OBLIGATORY.
    PARAMETERS p_num2 type p DECIMALS 2 OBLIGATORY.

    LV_SUMA = p_num1 + p_num2.

    write: / 'La suma de los números es:', lv_suma.

  else.
    write 'La contraseña introducida es incorrecta'.
  ENDIF.
ELSE.
  write 'El usuario introducido no existe'.
ENDIF.

WHILE 1 = 1.
  lv_suma = LV_SUMA + 1.
  write: / 'Num actual:',LV_SUMA.
  IF lv_suma >= 20.
    write: / 'Saliendo del bucle...'.
    EXIT.
  ENDIF.
ENDWHILE.


write: / 'Iniciando loop for-each'.
do STRLEN( lv_usuario )  times.
  write: / 'Vuelta actual:', sy-index.
enddo.
