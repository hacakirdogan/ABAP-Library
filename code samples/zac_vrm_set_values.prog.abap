*&---------------------------------------------------------------------*
*& Fill the listbox from table
*&---------------------------------------------------------------------*
REPORT zac_vrm_set_values.

DATA: lv_id     TYPE vrm_id,
      lt_values TYPE vrm_values,
      ls_value  LIKE LINE OF lt_values,
      lt_distid TYPE TABLE OF spfli-distid,
      lv_distid TYPE spfli-distid.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS: p_carrid TYPE spfli-carrid OBLIGATORY DEFAULT 'THY',
              p_cfrom  TYPE spfli-cityfrom LOWER CASE,
              p_cto    TYPE spfli-cityto LOWER CASE,
              p_dist   TYPE spfli-distance,
              p_distid TYPE spfli-distid AS LISTBOX VISIBLE LENGTH 5.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_distid.

  SELECT DISTINCT distid FROM spfli INTO TABLE lt_distid.

  LOOP AT lt_distid INTO lv_distid.
    ls_value-key  = lv_distid.
    ls_value-text = lv_distid.
    APPEND ls_value TO lt_values.
  ENDLOOP.

  lv_id = 'P_DISTID'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = lv_id
      values = lt_values.
