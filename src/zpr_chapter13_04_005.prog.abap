*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER13_04_005
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zpr_chapter13_04_005.

TYPES: BEGIN OF ty_cliente,
      lv_cliente TYPE string,
      lv_denominacion TYPE string,
      lv_deuda TYPE string,
      lv_fecha TYPE string,
END OF ty_cliente.


PARAMETER p_local TYPE string.
PARAMETER p_fich LIKE filename-fileextern.
DATA: lt_ficheros TYPE TABLE OF file_table,
      ls_fichero TYPE file_table,
      lt_contenido TYPE TABLE OF string,
      lv_contador TYPE i,
      ls_ruta TYPE string,
      ls_cliente TYPE ty_cliente,
      lt_cliente TYPE TABLE OF ty_cliente.

INITIALIZATION.

  p_local = 'c:/temp'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_local.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title = 'Seleccion de archivo'
*     default_extension       =
*     default_filename        =
      file_filter  = '*.csv'
*     with_encoding           =
*     initial_directory       =
*     multiselection          =
    CHANGING
      file_table   = lt_ficheros
      rc           = lv_contador
*     user_action  =
*     file_encoding           =
    EXCEPTIONS
*     file_open_dialog_failed = 1
*     cntl_error   = 2
*     error_no_gui = 3
*     not_supported_by_gui    = 4
      OTHERS       = 5.
  IF sy-subrc = 0.
    READ TABLE lt_ficheros INTO ls_fichero INDEX 1.
    IF sy-subrc = 0.
      p_local = ls_fichero-filename.
      p_fich = ls_fichero-filename.
    ENDIF.
  ELSE.
    WRITE: / 'ERROR: No se ha podido seleccionar el fichero.'.
  ENDIF.

START-OF-SELECTION.
*  p_fich = p_local.
    CALL FUNCTION 'FILE_READ_AND_CONVERT_SAP_DATA'
      EXPORTING
        i_filename           = p_fich
*       I_SERVERTYP          = C_APPLICATION_SERVER
*       I_FILEFORMAT         =
        i_field_seperator    = ';'
*       I_LINE_HEADER        =
*       IMPORTING
*       E_BIN_FILELENGTH     =
*       TABLES
*       I_TAB_RECEIVER       =
      EXCEPTIONS
        file_not_found       = 1
        close_failed         = 2
        authorization_failed = 3
        open_failed          = 4
        conversion_failed    = 5
        OTHERS               = 6.
    IF sy-subrc <> 0.

      IF sy-subrc = 3.
        WRITE: / 'ERROR: Autorización denegada'.
      ENDIF.
      IF sy-subrc = 6.
        WRITE: / 'ERROR: Excepción desconocida'.
      ENDIF.

    ELSE.
       write: / 'Conversion realizada correctamente'.
    ENDIF.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename              = p_local
*     filetype              = 'ASC'
      has_field_separator   = abap_true
*     header_length         =
*     read_by_line          = 'X'
*     dat_mode              = SPACE
*     codepage              = SPACE
*     ignore_cerr           = ABAP_TRUE
*     replacement           = '#'
*     virus_scan_profile    =
*    IMPORTING
*     filelength            =
*     header                =
    CHANGING
      data_tab              = lt_cliente
*     isscanperformed       = SPACE
    EXCEPTIONS
*     file_open_error       = 1
*     file_read_error       = 2
*     no_batch              = 3
*     gui_refuse_filetransfer = 4
*     invalid_type          = 5
*     no_authority          = 6
*     unknown_error         = 7
*     bad_data_format       = 8
*     header_not_allowed    = 9
      separator_not_allowed = 10
*     header_too_long       = 11
*     unknown_dp_error      = 12
*     access_denied         = 13
*     dp_out_of_memory      = 14
*     disk_full             = 15
*     dp_timeout            = 16
*     not_supported_by_gui  = 17
*     error_no_gui          = 18
      OTHERS                = 19.
  IF sy-subrc = 0.
    WRITE: / 'Todo correcto'.
*        SPLIT lt_contenido at ';' into TABLE lt_cliente.
*      loop at lt_contenido into data(linea).
*        write: / linea.
*      ENDLOOP.
  ELSEIF sy-subrc = 10.
    WRITE: / 'ERROR: No se reconoce el separador'.
  ELSE.
    WRITE: / 'ERROR: No se ha podido leer el fichero.'.
  ENDIF.
