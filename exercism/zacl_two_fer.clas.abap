*&---------------------------------------------------------------------*
*Name    String to return
*Alice   One for Alice, one for me.
*        One for you, one for me.
*Zaphod  One for Zaphod, one for me.
*&---------------------------------------------------------------------*
CLASS zacl_two_fer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS two_fer
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_two_fer IMPLEMENTATION.
  METHOD two_fer.
    result = |One for { COND string( WHEN input = '' THEN 'you' ELSE input ) }, one for me.|.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->two_fer( 'Alice' ) ).
  ENDMETHOD.

ENDCLASS.
