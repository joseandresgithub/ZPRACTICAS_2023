FUNCTION zpr_dividir.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(OP1) TYPE  I
*"     VALUE(OP2) TYPE  I
*"  EXPORTING
*"     VALUE(RESULTADO) TYPE  ZPR_TIPO_P2
*"  EXCEPTIONS
*"      DIVISION_POR_CERO
*"----------------------------------------------------------------------
*
*  IF op2 <> 0.
*    resultado = op1 / op2.
*  ELSE.
*    resultado = 0.
*    raise division_por_cero.
*  ENDIF.
*
  TRY.
      resultado = op1 / op2.
      CATCH CX_NO_CHECK .
        resultado = 0.
        RAISE division_por_cero.
    ENDTRY.

  ENDFUNCTION.
