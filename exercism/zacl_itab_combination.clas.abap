*&---------------------------------------------------------------------*
*return an internal table with records which combine the values of each
*cell of interal table ALPHAS and internal table NUMS together.
*For example the value of the first column of the first row of the
*COMBINED_DATA internal table should be "A1".
*&---------------------------------------------------------------------*
CLASS zacl_itab_combination DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF alphatab_type,
             cola TYPE string,
             colb TYPE string,
             colc TYPE string,
           END OF alphatab_type.
    TYPES alphas TYPE STANDARD TABLE OF alphatab_type WITH EMPTY KEY.
    TYPES: BEGIN OF numtab_type,
             col1 TYPE string,
             col2 TYPE string,
             col3 TYPE string,
           END OF numtab_type.
    TYPES nums TYPE STANDARD TABLE OF numtab_type WITH EMPTY KEY.
    TYPES: BEGIN OF combined_data_type,
             colx TYPE string,
             coly TYPE string,
             colz TYPE string,
           END OF combined_data_type.
    TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.
    METHODS fill_alphas
      RETURNING
        VALUE(alphas) TYPE alphas.
    METHODS fill_nums
      RETURNING
        VALUE(nums) TYPE nums.
    METHODS perform_combination
      IMPORTING
        alphas               TYPE alphas
        nums                 TYPE nums
      RETURNING
        VALUE(combined_data) TYPE combined_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_itab_combination IMPLEMENTATION.
  METHOD fill_alphas.
    alphas = VALUE #( ( cola = 'A' colb = 'B' colc = 'C' )
                      ( cola = 'D' colb = 'E' colc = 'F' )
                      ( cola = 'G' colb = 'H' colc = 'I' ) ).
  ENDMETHOD.

  METHOD fill_nums.
    nums   = VALUE #( ( col1 = '1' col2 = '2' col3 = '3' )
                      ( col1 = '4' col2 = '5' col3 = '6' )
                      ( col1 = '7' col2 = '8' col3 = '9' ) ).
  ENDMETHOD.

  METHOD perform_combination.
    TRY.
        combined_data = VALUE #( FOR ls_alphas IN alphas
                               ( colx = ls_alphas-cola && nums[ sy-tabix ]-col1
                                 coly = ls_alphas-colb && nums[ sy-tabix ]-col2
                                 colz = ls_alphas-colc && nums[ sy-tabix ]-col3 ) ).
      CATCH cx_sy_itab_line_not_found INTO DATA(exc).
        MESSAGE exc->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
