*&---------------------------------------------------------------------*
*& CONVERSION_EXIT_ALPHA
*&---------------------------------------------------------------------*
REPORT zac_conversion_exit_alpha.

DATA: vbeln_in  TYPE vbak-vbeln, "C10
      vbeln_out TYPE vbak-vbeln.

vbeln_in = '12345'.

" OLD
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = vbeln_in
  IMPORTING
    output = vbeln_out. " 0000012345

" NEW
DATA(int_val) = |{ vbeln_in ALPHA = IN }|.
**********************************************************************

CLEAR: vbeln_in, vbeln_out.

vbeln_out = '0012345'.

" OLD
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input  = vbeln_out
  IMPORTING
    output = vbeln_in. " 12345

" NEW
DATA(ext_val) = |{ vbeln_out ALPHA = OUT }|.

BREAK-POINT.
