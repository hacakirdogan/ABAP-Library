*&---------------------------------------------------------------------*
*& Upload TXT file with 'GUI_UPLOAD' method
*&---------------------------------------------------------------------*
REPORT  zac_gui_upload.

TYPES: BEGIN OF gty_data,
         f1  TYPE char255,
         f2  TYPE char255,
         f3  TYPE char255,
       END OF gty_data.

DATA: gt_data   TYPE TABLE OF gty_data,
      gs_data   LIKE LINE OF gt_data,
      gt_file   TYPE filetable,
      gs_file   LIKE LINE OF gt_file,
      gv_rc     TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file TYPE string.
SELECTION-SCREEN END OF BLOCK b1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  cl_gui_frontend_services=>file_open_dialog(
    CHANGING
      file_table              = gt_file
      rc                      = gv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5
         ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  READ TABLE gt_file INDEX 1 INTO gs_file.
  p_file = gs_file-filename.

START-OF-SELECTION.

  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = p_file
      has_field_separator     = 'X'
    CHANGING
      data_tab                = gt_data
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19
         ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ELSE.
    LOOP AT gt_data INTO gs_data.
      WRITE: gs_data-f1, gs_data-f2, gs_data-f3.
    ENDLOOP.
  ENDIF.
