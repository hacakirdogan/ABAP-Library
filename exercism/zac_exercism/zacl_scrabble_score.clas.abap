*&---------------------------------------------------------------------*
*Letter                           Value
*A, E, I, O, U, L, N, R, S, T       1
*D, G                               2
*B, C, M, P                         3
*F, H, V, W, Y                      4
*K                                  5
*J, X                               8
*Q, Z                               10

"cabbage" should be scored as worth 14 points
*&---------------------------------------------------------------------*
CLASS zacl_scrabble_score DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS score
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_scrabble_score IMPLEMENTATION.
  METHOD score.
    DO strlen( input ) TIMES.
      sy-index -= 1.
      IF to_upper( input+sy-index(1) ) CA 'AEIOULNRST'.
        result += 1.
      ELSEIF to_upper( input+sy-index(1) ) CA 'DG'.
        result += 2.
      ELSEIF to_upper( input+sy-index(1) ) CA 'BCMP'.
        result += 3.
      ELSEIF to_upper( input+sy-index(1) ) CA 'FHVWY'.
        result += 4.
      ELSEIF to_upper( input+sy-index(1) ) CA 'K'.
        result += 5.
      ELSEIF to_upper( input+sy-index(1) ) CA 'JX'.
        result += 8.
      ELSEIF to_upper( input+sy-index(1) ) CA 'QZ'.
        result += 10.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( me->score( 'cabbage' ) ).
  ENDMETHOD.

ENDCLASS.
