*&---------------------------------------------------------------------*
* Your task is to write methods that return the
* highest score from the list,
* the last added score and
* the three highest scores.
*&---------------------------------------------------------------------*
CLASS zacl_high_scores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        scores TYPE integertab.

    METHODS list_scores
      RETURNING
        VALUE(result) TYPE integertab.

    METHODS latest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personalbest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personaltopthree
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA scores_list TYPE integertab.

ENDCLASS.


CLASS zacl_high_scores IMPLEMENTATION.

  METHOD constructor.
    me->scores_list = scores.
*    me->scores_list = VALUE integertab( ( 30 ) ( 50 ) ( 20 ) ( 70 ) ).
  ENDMETHOD.

  METHOD list_scores.
    result = me->scores_list.
  ENDMETHOD.

  METHOD latest.
    READ TABLE scores_list INTO result INDEX lines( scores_list ).
  ENDMETHOD.

  METHOD personalbest.
    SORT scores_list BY table_line DESCENDING.
    READ TABLE scores_list INTO result INDEX 1.
  ENDMETHOD.

  METHOD personaltopthree.
    SORT scores_list BY table_line DESCENDING.
    LOOP AT scores_list INTO DATA(score).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<result>).
      <result> = score.
      IF sy-tabix EQ 3.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

