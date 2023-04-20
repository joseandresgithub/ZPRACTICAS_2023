*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER13_03_000
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zpr_chapter13_03_005.

PARAMETERS p_local TYPE string LOWER CASE.
PARAMETERS p_server TYPE string LOWER CASE.

DATA lt_ficheros TYPE TABLE OF file_table.
DATA ls_fichero TYPE file_table.
DATA lv_retorno TYPE i.
DATA lv_action TYPE i.
DATA lv_ruta_final TYPE string.
DATA lt_contenido TYPE TABLE OF string.
DATA ls_linea TYPE string.


INITIALIZATION.
  p_local = 'c:\temp\mifichero.txt'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_local .

  "Función para abrir el explorador de archivos y seleccionar la ruta de lectura.
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title      = 'Abrir archive' "Título del explorador.
      default_extension = '*.txt'
      default_filename  = 'test.txt' "Nombre del fichero por defecto.
*     file_filter       =
*     with_encoding     =
      initial_directory = 'c:\temp' "Directorio inicial en el que se abrirá el explorador de archivos, si la misma existe.
      multiselection    = 'X' "Booleano que habilita el poder seleccionar varios archivos ('X' equivale a true)
    CHANGING
      file_table        = lt_ficheros "Tabla que contendrá el contenido del archivo seleccionado.
      rc                = lv_retorno "Número de ficheros seleccionados.
      user_action       = lv_action
*     file_encoding     =
    EXCEPTIONS
      OTHERS            = 4.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ELSE.
    READ TABLE lt_ficheros INTO ls_fichero INDEX 1.
    IF sy-subrc = 0.
      p_local = ls_fichero-filename.
    ENDIF.
  ENDIF.


START-OF-SELECTION.
  "Función para leer el archivo seleccionado previamente mediante su ruta.
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename = p_local "Ruta del fichero a leer.
      filetype = 'ASC' "Tipo de codificación (ASCI).
*     has_field_separator     = SPACE
*     header_length           = 0
*     read_by_line            = 'X'
*     dat_mode = SPACE
*     codepage = SPACE
*     ignore_cerr             = ABAP_TRUE
*     replacement             = '#'
*     virus_scan_profile      =
*                IMPORTING
*     filelength              =
*     header   =
    CHANGING
      data_tab = lt_contenido "Tabla que contendrá el contenido del archivo leido.
*     isscanperformed         = SPACE
    EXCEPTIONS
      OTHERS   = 4.

  IF sy-subrc = 0.
    OPEN DATASET p_server FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "Abre o crea un archivo en la ruta especificada del servidor.
    IF sy-subrc = 0."Si ha sido capaz de crear el fichero...
      LOOP AT lt_contenido INTO ls_linea. "Por cada fila de la tabla...
        TRANSFER ls_linea TO p_server. "Escribe una linea en el fichero con el valor de la fila leida de la tabla.
        "WRITE : / ls_linea.
      ENDLOOP.
      CLOSE DATASET p_server. "Cerramos el dataset.
      WRITE: / 'Guardado correctamente'.
    ELSE.
      WRITE: / 'No se puede crear el archivo'.
    ENDIF.
  ELSE.
    write: / 'ERROR: No se ha podido leer el archivo local'.
  ENDIF.
  "Función para abrir el explorador de archivos y seleccionar la ruta de guardado.
  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title        = 'Guardar como'
*     default_extension   =
      default_file_name   = p_local
*     with_encoding       =
*     file_filter         =
      initial_directory   = 'c:\temp'
      prompt_on_overwrite = 'X'
    CHANGING
      filename            = p_local
      path                = lv_ruta_final
      fullpath            = lv_ruta_final
*     user_action         =
*     file_encoding       =
    EXCEPTIONS
      OTHERS              = 4.
  IF sy-subrc = 0.
    "Función para guardar un archivo en local.
    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
*        bin_filesize              =
        filename                  = lv_ruta_final && p_local "Ruta completa donde se guardará el archivo.
*        filetype                  = 'ASC'
*        append                    = SPACE
*        write_field_separator     = SPACE
*        header                    = '00'
*        trunc_trailing_blanks     = SPACE
*        write_lf                  = 'X'
*        col_select                = SPACE
*        col_select_mask           = SPACE
*        dat_mode                  = SPACE
*        confirm_overwrite         = SPACE
*        no_auth_check             = SPACE
*        codepage                  = SPACE
*        ignore_cerr               = ABAP_TRUE
*        replacement               = '#'
*        write_bom                 = SPACE
*        trunc_trailing_blanks_eol = 'X'
*        wk1_n_format              = SPACE
*        wk1_n_size                = SPACE
*        wk1_t_format              = SPACE
*        wk1_t_size                = SPACE
*        show_transfer_status      = 'X'
*        fieldnames                =
*        write_lf_after_last_line  = 'X'
*        virus_scan_profile        = '/SCET/GUI_DOWNLOAD'
*      IMPORTING
*        filelength                =
      changing
        data_tab                  = lt_contenido "Contenido que se guardará en el archivo.
      EXCEPTIONS
        others                    = 4
            .
    IF sy-subrc = 0.
      WRITE: / 'El archivo con nombre', p_local, 'Se ha guardado correctamente en la ruta', lv_ruta_final.
    else.
      write: / 'ERROR: No se ha podido guardar el archivo.'.
    ENDIF.
  ELSE.
    WRITE: / 'ERROR: No se ha podido abrir el explorador de archivos.'.
  ENDIF.
