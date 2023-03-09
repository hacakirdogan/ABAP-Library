*&---------------------------------------------------------------------*
*& A summary of a statement list for internal reuse within a program
*& between DEFINE and END-OF-DEFINITION.
*&---------------------------------------------------------------------*
REPORT zac_macros.

" A macro can contain up to nine placeholders, &1 to &9,
" in place of ABAP words and operands (or parts of operands).
" These placeholders must be replaced by fixed words when the macro is included.

" Since the use of macros is not recommended, alternative ways should be preferred.
" For example, use the VALUE operator to fill internal tables.

" To debug a macro press right-click in the debugger and choose ABAP Byte Code (Debug Macro).

DATA: BEGIN OF bdcdata OCCURS 100.
        INCLUDE STRUCTURE bdcdata.
DATA: END OF bdcdata.

RANGES carrid_range FOR scarr-carrid.

DEFINE append_range.
  &1-sign   = &2.
  &1-option = &3.
  &1-low    = &4.
  &1-high   = &5.
  APPEND &1.
END-OF-DEFINITION.

DEFINE append_bdc.
  bdcdata-fnam = &1.
  bdcdata-fval = &2.
  APPEND bdcdata.
END-OF-DEFINITION.

append_range carrid_range 'I' 'BT' 'AA' 'LH'.

bdcdata-program   = 'SAPMDEMO_TRANSACTION'.
bdcdata-dynpro    = '0100'.
bdcdata-dynbegin  = 'X'.
APPEND bdcdata.
CLEAR bdcdata.

append_bdc 'SPFLI-CARRID' 'AA'.
append_bdc 'SPFLI-CONNID' '17'.
append_bdc 'BDC_OKCODE'   '=SHOW'.

CALL TRANSACTION 'DEMO_TRANSACTION' USING bdcdata MODE 'E'.

" An Alternative way for append_range
DATA carrid_rangetab TYPE RANGE OF spfli-carrid.
carrid_rangetab = VALUE #(
                    ( sign = 'I' option = 'BT' low = 'AA' high = 'LH') ).

" An Alternative way for append_bdc
DATA(bdcdata_tab) = VALUE bdcdata_tab(
                      ( program  = 'SAPMDEMO_TRANSACTION' dynpro = '0100' dynbegin = 'X' )
                      ( fnam = 'SPFLI-CARRID' fval = 'AA' )
                      ( fnam = 'SPFLI-CONNID' fval = '17' )
                      ( fnam = 'BDC_OKCODE'   fval = '=SHOW' ) ).

BREAK-POINT.
