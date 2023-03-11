*&---------------------------------------------------------------------*
*Step 1
* complete the method fill_itab and place 6 records into this table
*Step 2
* implement the method add_to_itab to add a record to the end of the itab
*Step 3
* sort the internal table in the method sort_itab with the GROUP column
* in alphabetical order and the NUMBER column in descending order
*Step 4
* In the method search_itab, search the sorted table and return the index
* of the record that has a NUMBER column value of 6.
*&---------------------------------------------------------------------*
CLASS zacl_itab_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_type,
             group       TYPE group,
             number      TYPE i,
             description TYPE string,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY,
           stru_data_type TYPE initial_type.
    METHODS fill_itab
      RETURNING VALUE(initial_data) TYPE itab_data_type.
    METHODS add_to_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING VALUE(updated_data) TYPE itab_data_type.
    METHODS sort_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING VALUE(updated_data) TYPE itab_data_type.
    METHODS search_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING VALUE(result_index) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_itab_basics IMPLEMENTATION.
  METHOD fill_itab.
    initial_data = VALUE #( ( group = 'A' number = 10 description = 'Group A-2' )
                            ( group = 'B' number = 5 description = 'Group B' )
                            ( group = 'A' number = 6 description = 'Group A-1' )
                            ( group = 'C' number = 22 description = 'Group C-1' )
                            ( group = 'A' number = 13 description = 'Group A-3' )
                            ( group = 'C' number = 500 description = 'Group C-2' ) ).
  ENDMETHOD.

  METHOD add_to_itab.
    updated_data = VALUE #( BASE initial_data
                               ( group = 'A' number = 19 description = 'Group A-4' ) ).
  ENDMETHOD.

  METHOD sort_itab.
    updated_data = initial_data.
    SORT updated_data BY group number DESCENDING.
  ENDMETHOD.

  METHOD search_itab.
    READ TABLE me->sort_itab( initial_data ) TRANSPORTING NO FIELDS
                                             WITH KEY number = 6
                                             BINARY SEARCH.
    result_index = sy-tabix.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->search_itab( me->add_to_itab( me->fill_itab( ) ) ) ).
  ENDMETHOD.

ENDCLASS.
