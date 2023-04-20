FUNCTION ZPR_DIVIDIR_001.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(NUM1) TYPE  I
*"     VALUE(NUM2) TYPE  I
*"  EXPORTING
*"     VALUE(RESULT) TYPE  ZPR_DEC2_001
*"----------------------------------------------------------------------


if num2 <> 0.
  result = num1 / num2.
endif.


ENDFUNCTION.
