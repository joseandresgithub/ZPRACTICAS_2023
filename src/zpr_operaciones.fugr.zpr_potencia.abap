FUNCTION ZPR_POTENCIA.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(OP1) TYPE  I
*"     VALUE(OP2) TYPE  I
*"  EXPORTING
*"     VALUE(RESULTADO) TYPE  ZPR_TIPO_P2
*"  EXCEPTIONS
*"      RESULT_VALUE_TOO_HIGH
*"      POWER_VALUE_TOO_HIGH
*"----------------------------------------------------------------------

  TRY.
      resultado = op1 **  op2.
      CATCH cx_sy_conversion_overflow.
        RAISE POWER_VALUE_TOO_HIGH.
      CATCH cx_sy_arithmetic_overflow .
        resultado = 0.
        RAISE RESULT_VALUE_TOO_HIGH.
    ENDTRY.

  ENDFUNCTION.
