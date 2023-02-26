*&---------------------------------------------------------------------*
*Write a class that returns the string "Hello, World!".
*&---------------------------------------------------------------------*
CLASS zacl_hello_world DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS say_hello RETURNING VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_hello_world IMPLEMENTATION.
  METHOD say_hello.
    result = 'Hello, World!'.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->say_hello( ) ).
  ENDMETHOD.

ENDCLASS.
