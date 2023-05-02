*&---------------------------------------------------------------------*
*& Dialog box for the display and request of values
*&---------------------------------------------------------------------*
REPORT zac_popup_get_values.

CONSTANTS: lc_fieldtext TYPE scrtext_m  VALUE 'Warning',
           lc_title(50) TYPE c          VALUE 'Title',
           lc_value(50) TYPE c          VALUE 'Enter comment!'.

DATA: BEGIN OF lt_fields OCCURS 1.
        INCLUDE STRUCTURE sval.
DATA: END OF lt_fields,
lv_return.

lt_fields-tabname    = 'FTPT_REQUEST'.  "any table with a description field is selected
lt_fields-fieldname  = 'COMMENT1'.
lt_fields-fieldtext  = lc_fieldtext.
lt_fields-value      = lc_value.
lt_fields-field_attr = '03'.            "highlighted, protected against input
APPEND lt_fields.

CLEAR lt_fields.
lt_fields-tabname    = '*FTPT_REQUEST'.
lt_fields-fieldname  = 'COMMENT1'.
lt_fields-field_obl  = 'X'.             "the field is obligatory
APPEND lt_fields.

CALL FUNCTION 'POPUP_GET_VALUES'
  EXPORTING
*   NO_VALUE_CHECK = ' '
    popup_title = lc_title
*   START_COLUMN   = '5'
*   START_ROW   = '5'
  IMPORTING
    returncode  = lv_return
  TABLES
    fields      = lt_fields.

IF lv_return EQ 'A'.      "cancel
  EXIT.
ELSE.                     "continue
  WRITE lt_fields-value.
ENDIF.
