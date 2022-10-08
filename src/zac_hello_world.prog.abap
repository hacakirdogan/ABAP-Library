*&---------------------------------------------------------------------*
*& Report ZAC_HELLO_WORLD
*&---------------------------------------------------------------------*
*Write a class that returns the string "Hello, World!".
*&---------------------------------------------------------------------*
REPORT zac_hello_world.
CLASS zcl_hello_world DEFINITION.
  PUBLIC SECTION.
    METHODS hello RETURNING VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_hello_world IMPLEMENTATION.

  METHOD hello.
    result = 'Hello, World!'.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lr_hello) = NEW zcl_hello_world( ).

  WRITE lr_hello->hello( ).
