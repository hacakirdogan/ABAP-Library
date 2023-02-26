CLASS zacl_abap2ui5_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF flight,
             carrid    TYPE sflight-carrid,
             connid    TYPE sflight-connid,
             fldate    TYPE sflight-fldate,
             price     TYPE sflight-price,
             currency  TYPE sflight-currency,
             planetype TYPE sflight-planetype,
             capacity  TYPE sflight-seatsmax,
             occupied  TYPE sflight-seatsocc,
           END OF flight,
           BEGIN OF airline,
             key  TYPE scarr-carrid,
             text TYPE scarr-carrname,
           END OF airline.

    DATA: flights     TYPE TABLE OF flight,
          airlines    TYPE TABLE OF airline,
          carrid      TYPE string,
          fldate_low  TYPE string,
          fldate_high TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zacl_abap2ui5_demo IMPLEMENTATION.

  METHOD z2ui5_if_app~controller.

    CASE client->get( )-lifecycle_method.

      WHEN client->cs-lifecycle_method-on_init.

        carrid        = 'TK'.
        fldate_low    = sy-datum.
        fldate_high   = '20231231'.

        SELECT DISTINCT carrid AS key, carrname AS text
         FROM scarr INTO TABLE @airlines.

        client->display_view( 'MAIN' ).

      WHEN client->cs-lifecycle_method-on_event.

        CASE client->get( )-event.

          WHEN 'BUTTON_RUN'.

            IF strlen( fldate_low ) GT 8.
              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                EXPORTING
                  date_external = fldate_low
                IMPORTING
                  date_internal = fldate_low.
            ENDIF.

            IF strlen( fldate_high ) GT 8.
              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
                EXPORTING
                  date_external = fldate_high
                IMPORTING
                  date_internal = fldate_high.
            ENDIF.

            SELECT carrid, connid, fldate, price, currency, planetype,
                 seatsmax + seatsmax_b + seatsmax_f AS capacity,
                 seatsocc + seatsocc_b + seatsocc_f AS occupied
              FROM sflight INTO TABLE @flights
              WHERE carrid = @carrid AND
                    fldate BETWEEN @fldate_low AND @fldate_high
              ORDER BY fldate.

            client->display_view( 'SECOND' ).
        ENDCASE.

      WHEN client->cs-lifecycle_method-on_rendering.

        DATA(view) = client->factory_view( 'MAIN' ).
        DATA(page) = view->page( title = 'Demo App' ).

        page->sub_header( )->overflow_toolbar(
           )->text( 'Selection-Screen'
           )->toolbar_spacer(
           )->button( text = 'RUN' icon = 'sap-icon://accept' press = view->_event( 'BUTTON_RUN' ) ).

        page->simple_form(
           )->content( 'f'
           )->label( 'Airline'
           )->combobox(
                selectedkey = view->_bind( carrid )
                items       = view->_bind_one_way( airlines )
                )->get( )->item( key = '{KEY}' text = '{TEXT}'
                )->get_parent( )->get_parent(
            )->label( 'Flight Date'
            )->date_picker( view->_bind( fldate_low )
            )->date_picker( view->_bind( fldate_high ) ).


        view = client->factory_view( 'SECOND' ).
        page = view->page( title = 'Flight List' nav_button_tap = view->_event_display_id( client->get( )-id_prev ) ).

        "set table and container
        DATA(tab) = page->scroll_container( '100%' )->table( view->_bind_one_way( flights ) ).

        "set header
        tab->columns(
            )->column( )->text( 'AIRLINE' )->get_parent(
            )->column( )->text( 'CONNECTION' )->get_parent(
            )->column( )->text( 'DATE' )->get_parent(
            )->column( )->text( 'PRICE' )->get_parent(
            )->column( )->text( 'CURRENCY' )->get_parent(
            )->column( )->text( 'PLANETYPE' )->get_parent(
            )->column( )->text( 'CAPACITY' )->get_parent(
            )->column( )->text( 'OCCUPIED' ).

        "set content
        tab->items( )->column_list_item( )->cells(
           )->text( '{CARRID}'
           )->text( '{CONNID}'
           )->text( '{FLDATE}'
           )->text( '{PRICE}'
           )->text( '{CURRENCY}'
           )->text( '{PLANETYPE}'
           )->text( '{CAPACITY}'
           )->text( '{OCCUPIED}' ).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
