*&---------------------------------------------------------------------*
*& Report ZAC_REVERSE_STRING
*&---------------------------------------------------------------------*
*  Reverse a string.
*  For example:
*  input: cool
*  output: looc
*&---------------------------------------------------------------------*
REPORT zac_reverse_string.
CLASS zcl_reverse_string DEFINITION.
  PUBLIC SECTION.
    METHODS reverse_string
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_reverse_string IMPLEMENTATION.

  METHOD reverse_string.
*    DO strlen( input ) TIMES.
*      result = result && substring( val = input off = strlen( input ) - sy-index len = 1 ).
*    ENDDO.
    result = reverse( input ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lr_reverse) = NEW zcl_reverse_string( ).

  WRITE lr_reverse->reverse_string( input = 'cool' ).
