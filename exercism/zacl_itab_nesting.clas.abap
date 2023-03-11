*&---------------------------------------------------------------------*
*return an internal table with records which combine the values of each
*internal table in a structured way, nesting the SONGS internal table
*into the ALBUMS internal table and of course nesting the ALBUMS
*internal table into the ARTISTS internal table.
*&---------------------------------------------------------------------*
CLASS zacl_itab_nesting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

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



CLASS zacl_itab_nesting IMPLEMENTATION.
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
      CATCH cx_sy_itab_line_not_found INTO DATA(exc).
        MESSAGE exc->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
