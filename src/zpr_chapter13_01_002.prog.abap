*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER13_01_000
*&
*&---------------------------------------------------------------------*
*&
*&Ejecución de codigo en varios pasos y eventos de selección
*&---------------------------------------------------------------------*

REPORT ZPR_CHAPTER13_01_002 MESSAGE-ID ZPR_CHAPTER09."Clase de mensaje que será mostrado.

PARAMETERS p_mat type matnr.
PARAMETERS p_cli type kunnr.
PARAMETERS P_OTRO TYPE s_carrid.

INITIALIZATION. "Bloque de ejecución antes de mostrarse al usuario.

   P_OTRO = 'AvvvhgvA'."Asigna el valor de selección por defecto del parámetro antes de mostrarlo al usuario.

at SELECTION-SCREEN."Si no se define el selection en el que se quiere disparar, se disparará al seleccionar cualquier dato en cualquier selection.
   MESSAGE i003 with 'Estoy en selection screen'.

at SELECTION-SCREEN on p_mat."Evento que se dispara al seleccionar un material (mostrará un mensaje en este caso).
     MESSAGE i003 with 'Estoy en selection del material' p_mat.

START-OF-SELECTION. "Evento  que se dispara al ejecutar el progarma despues de haber seleccionado los valores de los parámetros.
   data lt_pedidos type table of vbak.
   data ls_pedidos type vbak.

   select * into table lt_pedidos from vbak  where kunnr = p_cli.

end-of-SELECTION."Evento que se ejecutará al finalizar la ejecución anterior (Obsoleto).
  loop at lt_pedidos into ls_pedidos.
   write: / ls_pedidos-vbeln,
            ls_pedidos-kunnr,
            ls_pedidos-netwr,
            ls_pedidos-waerk.

  endloop.

at LINE-SELECTION. "Evento que se ejecutará al seleccionar una linea.
  DATA lv_fecha type SYMSGV.
  data lv_hora type SYMSGV.

  lv_fecha = sy-datum.
  lv_hora = sy-uzeit.

  CALL FUNCTION 'POPUP_DISPLAY_MESSAGE' "Función que muestra un popup.
    EXPORTING
      TITEL         = 'título'
      msgid         = 'ZPR_CHAPTER09'
      msgty         = 'W'
      msgno         = '003'
      MSGV1         = 'Esto es una prueba'
     MSGV2         = lv_fecha
     MSGV3         = lv_hora
     MSGV4         = '.'
            .


     set PARAMETER ID 'AUN' field sy-lisel(10). "Obtenemos los 10 primeros caracteres de la linea seleccionada.


     call TRANSACTION 'VA03' AND SKIP FIRST SCREEN. "Llamamos a la transacción 'VA03' y nos saltamos la primera pantalla.
