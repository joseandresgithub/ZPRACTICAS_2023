*&---------------------------------------------------------------------*
*& Report  ZPR_CHAPTER10_01_000
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report zpr_chapter10_02_000.

types lty_p2 type p decimals 2.

parameters p_op1 type i.
parameters p_op2 type i.
*parameters p_op type c OBLIGATORY DEFAULT '+'.
parameters p_op type zpr_operacion obligatory default '+'.

data: lv_result type zpr_tipo_p2.
data lv_test(10) type c.
data lv_test2(10) type c.

if p_op ca '+-*/%^'.

  perform operame using p_op p_op1 p_op2
                  changing lv_result.

  if p_op = '%'.
    write: / 'Resultado : ' , lv_result && '%'.
  else.
    write: / 'Resultado : ' , lv_result.
  endif.

else.
  write: / 'Operación no válida'.
endif.



*&---------------------------------------------------------------------*
*&      Form  OPERAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_OP  text
*      -->P_P_OP1  text
*      -->P_P_OP2  text
*----------------------------------------------------------------------*
form operame  using   value(pp_op) type c
                      value(pp_op1) type i
                      value(pp_op2) type i   "Forma de poner en parámetro formal el changing.
               changing
                        p_result type zpr_tipo_p2. " colocar directamente el tipo
  case pp_op.
    when '+'.
      call function 'ZPR_SUMAR'
        exporting
          op1       = pp_op1
          op2       = pp_op2
        importing
          resultado = p_result.

    when '-'.
      call function 'ZPR_RESTAR'
        exporting
          op1       = pp_op1
          op2       = pp_op2
        importing
          resultado = p_result.

    when '*'.
      call function 'ZPR_MULTIPLICAR'
        exporting
          op1       = pp_op1
          op2       = pp_op2
        importing
          resultado = p_result.

    when '/'.
      call function 'ZPR_DIVIDIR'
        exporting
          op1               = pp_op1
          op2               = pp_op2
        importing
          resultado         = p_result
        exceptions
          division_por_cero = 1
          others            = 2.
      if sy-subrc <> 0.
        if sy-subrc = 1.
          write: 'División por cero.'.
        else.
          write: 'Error desconocido.'.
        endif.
* Implement suitable error handling here
      endif.
    when '%'.
      call function 'ZPR_POCENTAJE'
        exporting
          op1               = pp_op1
          op2               = pp_op2
        importing
          resultado         = p_result
        exceptions
          division_por_cero = 1
          others            = 2.
      if sy-subrc <> 0.
        if sy-subrc = 1.
          write: 'Error en el cálculo del porcentaje'.
        else.
          write: 'Error desconocido'.
        endif.
      endif.
    when '^'.
      call function 'ZPR_POTENCIA'
        exporting
          op1             = pp_op1
          op2             = pp_op2
        importing
          resultado       = p_result
        exceptions
         RESULT_VALUE_TOO_HIGH       = 1
         POWER_VALUE_TOO_HIGH        = 2
         OTHERS                      = 3.
      if sy-subrc <> 0.
        if sy-subrc = 1.
          write: 'Exponente muy grande'.
        elseif sy-subrc = 2.
          write: 'Resultado muy grande'.
        else.
          write: 'Error desconocido'.
        endif.
      endif.

  endcase.

endform.                    " OPERAME
