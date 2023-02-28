*&---------------------------------------------------------------------*
*& Methods for formatting date types
*&---------------------------------------------------------------------*
REPORT zac_date_conversion.

DATA(date_c) = '20230103'.
DATA date_n(10)   TYPE n.
DATA date_d       TYPE d      VALUE '20230102'.
DATA date_s       TYPE string VALUE '20230104'.
DATA date_in      TYPE d.
DATA date_ex(10).
**********************************************************************

" Convert D(8) type 'YYYYMMDD' to char or string type user's default date format e.g. 'DD.MM.YYYY'
"                              or numc 'DDMMYYYY'
CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
  EXPORTING
    date_internal            = CONV d( date_c )
  IMPORTING
    date_external            = date_ex
  EXCEPTIONS
    date_internal_is_invalid = 1
    OTHERS                   = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
**********************************************************************

" Convert char or string type user's default date format e.g. 'DD.MM.YYYY' to c, n, d or string type 'YYYYMMDD'
CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
  EXPORTING
    date_external            = date_ex
*   ACCEPT_INITIAL_DATE      =
  IMPORTING
    date_internal            = date_in
  EXCEPTIONS
    date_external_is_invalid = 1
    OTHERS                   = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
**********************************************************************

" Convert D(8) type 'YYYYMMDD' to char or numc type user's default date format e.g. 'DD.MM.YYYY'
" also date format can be specified explicitly e.g. WRITE date_d TO date_n DD/MM/YY.
WRITE date_d TO date_n.
**********************************************************************

" Convert D(8) type 'YYYYMMDD' to char or string type 'YYYY-MM-DD'
DATA(date_iso)  = |{ date_d   DATE = ISO }|.

" Convert D(8) type 'YYYYMMDD' to char or string type user's default date format e.g. 'DD.MM.YYYY'
DATA(date_user) = |{ sy-datum DATE = USER }|.

" Convert D(8) type 'YYYYMMDD' to char or string type country-specific format e.g. 'DD.MM.YYYY'
" Without using SET COUNTRY, the use of ENVIRONMENT has the same effect as the use of USER.
SET COUNTRY 'TR'. " SELECT land FROM t005x
DATA(date_env)  = |{ sy-datlo DATE = ENVIRONMENT }|.
**********************************************************************

" Convert c, n, d or string type 'YYYYMMDD' to char or string type 'DD.MM.YYYY'
DATA(date_temp_ex) = |{ date_d+6(2) }.{ date_d+4(2) }.{ date_d(4) }|.

" Convert char or string type 'DD.MM.YYYY' to c, n, d or string type 'YYYYMMDD'
DATA(date_temp_in) = |{ date_temp_ex+6 }{ date_temp_ex+3(2) }{ date_temp_ex(2) }|.
**********************************************************************

" Convert char or string type 'YYYYMMDD' to char or string type 'DD.MM.YYYY'
REPLACE FIRST OCCURRENCE OF REGEX '(\d{4})(\d{2})(\d{2})' IN date_s WITH '$3.$2.$1'.


BREAK-POINT.
