*&---------------------------------------------------------------------*
*return an internal table with one record per group.
*This record should contain the number of records in the original table per group (COUNT),
*the sum of all NUMBER values in this group (SUM), the minimum value in the group (MIN),
*the maximum value in the group (MAX)
*and the average of all values in that group (AVERAGE)
*&---------------------------------------------------------------------*
CLASS zacl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.
    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.
    METHODS fill_itab
      RETURNING
        VALUE(initial_numbers) TYPE initial_numbers.
    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_itab_aggregation IMPLEMENTATION.
  METHOD fill_itab.
    initial_numbers = VALUE #( ( group = 'A' number = 10  )
                               ( group = 'B' number = 5   )
                               ( group = 'A' number = 6   )
                               ( group = 'C' number = 22  )
                               ( group = 'A' number = 13  )
                               ( group = 'C' number = 500 ) ).
  ENDMETHOD.

  METHOD perform_aggregation.
    LOOP AT initial_numbers INTO DATA(ls_nums)
          GROUP BY ( group = ls_nums-group ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_nums>).
      TRY.
          aggregated_data = VALUE #( BASE aggregated_data
                                    ( group = <lfs_nums>-group
                                      count = REDUCE i( INIT c = 0 FOR line_c IN GROUP <lfs_nums>
                                                        NEXT c += 1 )
                                      sum   = REDUCE i( INIT s = 0 FOR line_s IN GROUP <lfs_nums>
                                                         NEXT s += line_s-number )
                                      min   = REDUCE i( INIT n = 0 FOR line_n IN GROUP <lfs_nums>
                                                        NEXT n = COND #( WHEN n = 0 THEN line_n-number
                                                                         WHEN n < line_n-number THEN n
                                                                         ELSE line_n-number ) )
                                      max   = REDUCE i( INIT x = 0 FOR line_x IN GROUP <lfs_nums>
                                                        NEXT x = COND #( WHEN x > line_x-number THEN x
                                                                         ELSE line_x-number ) )
                                       ) ).
        CATCH cx_sy_itab_line_not_found INTO DATA(exc).
          MESSAGE exc->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
      ENDTRY.
      LOOP AT aggregated_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
        <lfs_data>-average = <lfs_data>-sum / <lfs_data>-count.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->perform_aggregation( me->fill_itab(  ) ) ).
  ENDMETHOD.

ENDCLASS.
