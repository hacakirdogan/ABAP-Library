*&---------------------------------------------------------------------*
*  Reverse a string.
*  For example:
*  input : cool
*  output: looc
*&---------------------------------------------------------------------*
CLASS zacl_reverse_string DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS reverse_string
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_reverse_string IMPLEMENTATION.
  METHOD reverse_string.
    result = reverse( input ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->reverse_string( 'cool' ) ).
  ENDMETHOD.

ENDCLASS.
