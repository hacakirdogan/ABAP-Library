*&---------------------------------------------------------------------*
*& Current contents of selection screen
*&---------------------------------------------------------------------*
REPORT  zac_get_selscr_values.

DATA: lt_selscr TYPE TABLE OF rsparams,
      ls_selscr TYPE rsparams.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS p_cmpny TYPE bukrs AS LISTBOX VISIBLE LENGTH 10.

SELECT-OPTIONS: s_bdate FOR (zacde_bdate),
                s_net   FOR (zacde_net).


PARAMETERS c_mltry TYPE zact_personnel-mltry_srvc AS CHECKBOX.

PARAMETERS: r_male   RADIOBUTTON GROUP g1,
            r_female RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b1.

CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
  EXPORTING
    curr_report     = sy-cprog
  TABLES
    selection_table = lt_selscr
  EXCEPTIONS
    not_found       = 1
    no_report       = 2
    OTHERS          = 3.

READ TABLE lt_selscr INTO ls_selscr WITH KEY selname = 'R_MALE'.
IF sy-subrc IS INITIAL.
  IF ls_selscr-low EQ 'X'.
    MESSAGE 'The male button was selected.' TYPE 'I'.
  ENDIF.
ENDIF.
