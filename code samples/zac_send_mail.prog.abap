*&---------------------------------------------------------------------*
*& Send salv table as a mail attachment
*&---------------------------------------------------------------------*
REPORT zac_send_mail.

TYPES: BEGIN OF artists_stype,
         artist_id   TYPE string,
         artist_name TYPE string,
       END OF artists_stype,
       artists_ttype TYPE STANDARD TABLE OF artists_stype WITH KEY artist_id.

DATA(artists) = VALUE artists_ttype( ( artist_id = '1' artist_name = 'Godsmack' )
                                     ( artist_id = '2' artist_name = 'Shinedown' ) ).

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = DATA(gr_table)
      CHANGING
        t_table        = artists ).
  CATCH cx_salv_msg.
ENDTRY.

DATA(lv_xls) = gr_table->to_xml( xml_type = if_salv_bs_xml=>c_type_xlsx ).

DATA(lv_subj) = `Artists List`.
DATA(lv_body) = `<html><head></head><body><br>` &&
                `The list of nominees for the award is attached.` &&
                `<br></body></html>`.

DATA(lo_msg) = NEW cl_bcs_message( ).

lo_msg->set_subject( lv_subj ).
lo_msg->set_main_doc(
  EXPORTING
    iv_contents_txt = lv_body
    iv_doctype      = 'htm'
).

lo_msg->set_sender(
  EXPORTING
    iv_address      = 'sender@mail.com'
).

lo_msg->add_recipient(
  EXPORTING
    iv_address      = 'recipient@mail.com'
).
" carbon copy
lo_msg->add_recipient(
  EXPORTING
    iv_address      = 'copy@mail.com'
    iv_copy         = abap_true
).

lo_msg->add_attachment( iv_filename     = 'artists.xlsx'
                        iv_contents_bin = lv_xls ).

TRY.
    lo_msg->send( ).
    MESSAGE 'Email sent successfully.' TYPE 'I' DISPLAY LIKE 'S'.
  CATCH cx_bcs_send INTO DATA(lr_exc).
    MESSAGE lr_exc->get_text( ) TYPE 'I' DISPLAY LIKE 'E'.
ENDTRY.
