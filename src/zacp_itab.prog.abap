*&---------------------------------------------------------------------*
*& Report zac_itab
*&---------------------------------------------------------------------*
REPORT zacp_itab.

"Exercism itab tasks

*CLASS zcl_itab_basics DEFINITION.
*
*
*  PUBLIC SECTION.
*    TYPES group TYPE c LENGTH 1.
*    TYPES: BEGIN OF initial_type,
*             group       TYPE group,
*             number      TYPE i,
*             description TYPE string,
*           END OF initial_type,
*           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.
*
*    METHODS fill_itab
*      RETURNING
*        VALUE(initial_data) TYPE itab_data_type.
*
*    METHODS add_to_itab
*      IMPORTING initial_data        TYPE itab_data_type
*      RETURNING
*                VALUE(updated_data) TYPE itab_data_type.
*
*    METHODS sort_itab
*      IMPORTING initial_data        TYPE itab_data_type
*      RETURNING
*                VALUE(updated_data) TYPE itab_data_type.
*
*    METHODS search_itab
*      IMPORTING initial_data        TYPE itab_data_type
*      RETURNING
*                VALUE(result_index) TYPE i.
*
*  PROTECTED SECTION.
*  PRIVATE SECTION.
*ENDCLASS.
*
*
*
*CLASS zcl_itab_basics IMPLEMENTATION.
*  METHOD fill_itab.
*    initial_data = VALUE #( ( group = 'A' number = 10 description = 'Group A-2' )
*                            ( group = 'B' number = 5 description = 'Group B' )
*                            ( group = 'A' number = 6 description = 'Group A-1' )
*                            ( group = 'C' number = 22 description = 'Group C-1' )
*                            ( group = 'A' number = 13 description = 'Group A-3' )
*                            ( group = 'C' number = 500 description = 'Group C-2' ) ).
*  ENDMETHOD.
*
*  METHOD add_to_itab.
*    updated_data = VALUE #( BASE initial_data
*                           ( group = 'A' number = 19 description = 'Group A-4' ) ).
*  ENDMETHOD.
*
*  METHOD sort_itab.
*    updated_data = initial_data.
*    SORT updated_data BY group number DESCENDING.
*  ENDMETHOD.
*
*  METHOD search_itab.
*    DATA(temp_data) = initial_data.
*    SORT temp_data BY group number DESCENDING.
*    LOOP AT temp_data INTO DATA(ls_data) WHERE number = 6.
*      result_index = sy-tabix.
*    ENDLOOP.
*
**    READ TABLE temp_data INTO DATA(ls_data) WITH KEY number = 6.
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*
*  DATA(lo_basic) = NEW zcl_itab_basics( ).
*
**  DATA(temp_data) = lo_basic->fill_itab( ).
*
*  cl_demo_output=>display( lo_basic->sort_itab( initial_data = lo_basic->fill_itab( ) ) ).
**  BREAK-POINT.
**  WRITE lo_basic->search_itab( initial_data = lo_basic->fill_itab( ) ).

**********************************************************************

*CLASS zcl_itab_combination DEFINITION.
*
*  PUBLIC SECTION.
*
*    TYPES: BEGIN OF alphatab_type,
*             cola TYPE string,
*             colb TYPE string,
*             colc TYPE string,
*           END OF alphatab_type.
*    TYPES alphas TYPE STANDARD TABLE OF alphatab_type WITH EMPTY KEY.
*
*    TYPES: BEGIN OF numtab_type,
*             col1 TYPE string,
*             col2 TYPE string,
*             col3 TYPE string,
*           END OF numtab_type.
*    TYPES nums TYPE STANDARD TABLE OF numtab_type WITH EMPTY KEY.
*
*    TYPES: BEGIN OF combined_data_type,
*             colx TYPE string,
*             coly TYPE string,
*             colz TYPE string,
*           END OF combined_data_type.
*    TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.
*
*    METHODS fill_alphas
*      RETURNING
*        VALUE(alphas) TYPE alphas.
*
*    METHODS fill_nums
*      RETURNING
*        VALUE(nums) TYPE nums.
*
*    METHODS perform_combination
*      IMPORTING
*        alphas               TYPE alphas
*        nums                 TYPE nums
*      RETURNING
*        VALUE(combined_data) TYPE combined_data.
*
*  PROTECTED SECTION.
*  PRIVATE SECTION.
*
*
*ENDCLASS.
*
*CLASS zcl_itab_combination IMPLEMENTATION.
*
*  METHOD fill_alphas.
*    alphas = VALUE #( ( cola = 'A' colb = 'B' colc = 'C' )
*                ( cola = 'D' colb = 'E' colc = 'F' )
*                ( cola = 'G' colb = 'H' colc = 'I' ) ).
*  ENDMETHOD.
*
*  METHOD fill_nums.
*    nums   = VALUE #( ( col1 = '1' col2 = '2' col3 = '3' )
*                    ( col1 = '4' col2 = '5' col3 = '6' )
*                    ( col1 = '7' col2 = '8' col3 = '9' ) ).
*  ENDMETHOD.
*
*  METHOD perform_combination.
*    TRY.
*        combined_data = VALUE #( FOR ls_alphas IN alphas
*                               ( colx = ls_alphas-cola && nums[ sy-tabix ]-col1
*                                 coly = ls_alphas-colb && nums[ sy-tabix ]-col2
*                                 colz = ls_alphas-colc && nums[ sy-tabix ]-col3 ) ).
*      CATCH cx_sy_itab_line_not_found.
*        MESSAGE 'Error occured' TYPE 'I' DISPLAY LIKE 'E'.
*    ENDTRY.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*  DATA(gr_itab_combination) = NEW zcl_itab_combination( ).
*
*  cl_demo_output=>display( gr_itab_combination->perform_combination(
*                             alphas = gr_itab_combination->fill_alphas( )
*                             nums   = gr_itab_combination->fill_nums( )
*                           ) ).

**********************************************************************
*CLASS zcl_itab_aggregation DEFINITION.
*
*  PUBLIC SECTION.
*    TYPES group TYPE c LENGTH 1.
*    TYPES: BEGIN OF initial_numbers_type,
*             group  TYPE group,
*             number TYPE i,
*           END OF initial_numbers_type,
*           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.
*
*    TYPES: BEGIN OF aggregated_data_type,
*             group   TYPE group,
*             count   TYPE i,
*             sum     TYPE i,
*             min     TYPE i,
*             max     TYPE i,
*             average TYPE f,
*           END OF aggregated_data_type,
*           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.
*
*    METHODS fill_itab
*      RETURNING
*        VALUE(initial_numbers) TYPE initial_numbers.
*
*    METHODS perform_aggregation
*      IMPORTING
*        initial_numbers        TYPE initial_numbers
*      RETURNING
*        VALUE(aggregated_data) TYPE aggregated_data.
*  PROTECTED SECTION.
*  PRIVATE SECTION.
*
*ENDCLASS.
*
*CLASS zcl_itab_aggregation IMPLEMENTATION.
*
*  METHOD fill_itab.
*    initial_numbers = VALUE #( ( group = 'A' number = 10  )
*                               ( group = 'B' number = 5   )
*                               ( group = 'A' number = 6   )
*                               ( group = 'C' number = 22  )
*                               ( group = 'A' number = 13  )
*                               ( group = 'C' number = 500 ) ).
*  ENDMETHOD.
*
*  METHOD perform_aggregation.
**    SELECT group,
**           COUNT(*),
**           SUM( number ) AS avarage,
**           MIN( number ),
**           MAX( number ),
**           AVG( number )
**    FROM @initial_numbers AS init_nums
**     GROUP BY group
**     INTO TABLE @aggregated_data.
*
*    LOOP AT initial_numbers INTO DATA(ls_nums)
*      GROUP BY ( group = ls_nums-group ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_nums>).
*      TRY.
*          aggregated_data = VALUE #( BASE aggregated_data
*                                    ( group = <lfs_nums>-group
*                                      count = REDUCE i( INIT c = 0 FOR line_c IN GROUP <lfs_nums>
*                                                        NEXT c += 1 )
*                                      sum   = REDUCE i( INIT s = 0 FOR line_s IN GROUP <lfs_nums>
*                                                        NEXT s += line_s-number )
*                                      min   = REDUCE i( INIT n = 0 FOR line_n IN GROUP <lfs_nums>
*                                                        NEXT n = COND #( WHEN n = 0 THEN line_n-number
*                                                                         WHEN n < line_n-number THEN n
*                                                                         ELSE line_n-number ) )
*                                      max   = REDUCE i( INIT x = 0 FOR line_x IN GROUP <lfs_nums>
*                                                        NEXT x = COND #( WHEN x > line_x-number THEN x
*                                                                         ELSE line_x-number ) )
*                                       ) ).
*        CATCH cx_sy_itab_line_not_found.
*          MESSAGE 'CX_SY_ITAB_LINE_NOT_FOUND' TYPE 'E'.
*      ENDTRY.
*      LOOP AT aggregated_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
*        <lfs_data>-average = <lfs_data>-sum / <lfs_data>-count.
*      ENDLOOP.
*    ENDLOOP.
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*  DATA(gr_itab_aggregation) = NEW zcl_itab_aggregation( ).
*
*  cl_demo_output=>display( gr_itab_aggregation->perform_aggregation( initial_numbers = gr_itab_aggregation->fill_itab( ) ) ).

CLASS zcl_itab_nesting DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF artists_type,
             artist_id   TYPE string,
             artist_name TYPE string,
           END OF artists_type.
    TYPES artists TYPE STANDARD TABLE OF artists_type WITH KEY artist_id.
    TYPES: BEGIN OF albums_type,
             artist_id  TYPE string,
             album_id   TYPE string,
             album_name TYPE string,
           END OF albums_type.
    TYPES albums TYPE STANDARD TABLE OF albums_type WITH KEY artist_id album_id.
    TYPES: BEGIN OF songs_type,
             artist_id TYPE string,
             album_id  TYPE string,
             song_id   TYPE string,
             song_name TYPE string,
           END OF songs_type.
    TYPES songs TYPE STANDARD TABLE OF songs_type WITH KEY artist_id album_id song_id.


    TYPES: BEGIN OF song_nested_type,
             song_id   TYPE string,
             song_name TYPE string,
           END OF song_nested_type.
    TYPES: BEGIN OF album_song_nested_type,
             album_id   TYPE string,
             album_name TYPE string,
             songs      TYPE STANDARD TABLE OF song_nested_type WITH KEY song_id,
           END OF album_song_nested_type.
    TYPES: BEGIN OF artist_album_nested_type,
             artist_id   TYPE string,
             artist_name TYPE string,
             albums      TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id,
           END OF artist_album_nested_type.
    TYPES nested_data TYPE STANDARD TABLE OF artist_album_nested_type WITH KEY artist_id.

    METHODS fill_artists
      RETURNING
        VALUE(artists) TYPE artists.
    METHODS fill_albums
      RETURNING
        VALUE(albums) TYPE albums.
    METHODS fill_songs
      RETURNING
        VALUE(songs) TYPE songs.

    METHODS perform_nesting
      IMPORTING
        artists            TYPE artists
        albums             TYPE albums
        songs              TYPE songs
      RETURNING
        VALUE(nested_data) TYPE nested_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_itab_nesting IMPLEMENTATION.

  METHOD fill_artists.
    artists = VALUE #( ( artist_id = '1' artist_name = 'Godsmack' )
                       ( artist_id = '2' artist_name = 'Shinedown' ) ).
  ENDMETHOD.
  METHOD fill_albums.
    albums = VALUE #( ( artist_id = '1' album_id = '1' album_name = 'Faceless' )
                      ( artist_id = '1' album_id = '2' album_name = 'When Lengends Rise' )
                      ( artist_id = '2' album_id = '1' album_name = 'The Sound of Madness' )
                      ( artist_id = '2' album_id = '2' album_name = 'Planet Zero' ) ).
  ENDMETHOD.
  METHOD fill_songs.
    songs = VALUE #( ( artist_id = '1' album_id = '1' song_id = '1' song_name = 'Straight Out Of Line' )
                     ( artist_id = '1' album_id = '1' song_id = '2' song_name = 'Changes' )
                     ( artist_id = '1' album_id = '2' song_id = '1' song_name = 'Bullet Proof' )
                     ( artist_id = '1' album_id = '2' song_id = '2' song_name = 'Under Your Scars' )
                     ( artist_id = '2' album_id = '1' song_id = '1' song_name = 'Second Chance' )
                     ( artist_id = '2' album_id = '1' song_id = '2' song_name = 'Breaking Inside' )
                     ( artist_id = '2' album_id = '2' song_id = '1' song_name = 'Dysfunctional You' )
                     ( artist_id = '2' album_id = '2' song_id = '2' song_name = 'Daylight' ) ).
  ENDMETHOD.

  METHOD perform_nesting.
    TRY.
        nested_data = VALUE #( FOR ls_artists IN artists
                               ( artist_id = ls_artists-artist_id
                                 artist_name = ls_artists-artist_name
                                 albums = VALUE #( FOR ls_albums IN albums WHERE ( artist_id = ls_artists-artist_id )
                                                   ( album_id = ls_albums-album_id
                                                     album_name = ls_albums-album_name
                                                     songs = VALUE #( FOR ls_songs IN songs WHERE ( artist_id = ls_artists-artist_id AND
                                                                                                    album_id =  ls_albums-album_id )
                                                                      ( song_id = ls_songs-song_id
                                                                        song_name = ls_songs-song_name ) ) ) ) ) ).
      CATCH cx_sy_itab_line_not_found.
        MESSAGE 'CX_SY_ITAB_LINE_NOT_FOUND' TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(gr_itab_nesting) = NEW zcl_itab_nesting( ).
  DATA gt_alv TYPE gr_itab_nesting->nested_data.
  gt_alv = gr_itab_nesting->perform_nesting(
             artists = gr_itab_nesting->fill_artists( )
             albums  = gr_itab_nesting->fill_albums( )
             songs   = gr_itab_nesting->fill_songs( )
           ).
*  cl_demo_output=>display( gr_itab_nesting->perform_nesting(
*                             artists = gr_itab_nesting->fill_artists( )
*                             albums  = gr_itab_nesting->fill_albums( )
*                             songs   = gr_itab_nesting->fill_songs( )
*                           ) ).
  BREAK-POINT.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table   = DATA(gr_table)
        CHANGING
          t_table        = gt_alv ).
    CATCH cx_salv_msg.
  ENDTRY.
  gr_table->get_display_settings( )->set_striped_pattern( abap_true ).
  gr_table->get_columns( )->set_optimize( abap_true ).
  gr_table->display( ).
