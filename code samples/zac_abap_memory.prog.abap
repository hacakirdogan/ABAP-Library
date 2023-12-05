*&---------------------------------------------------------------------*
*& temporary storage of data from different programs or processes
*&---------------------------------------------------------------------*
REPORT  zac_abap_memory.

DATA lv_text TYPE text100.
lv_text = 'abap memory'.
EXPORT lv_text FROM lv_text TO MEMORY ID 'MEM1'.
SUBMIT zac_prog AND RETURN.
WRITE lv_text.

*EXPORT lv_tcode FROM sy-tcode TO MEMORY ID 'MEM1'.
*
*DATA lv_tcode TYPE sy-tcode.
*IMPORT lv_tcode FROM MEMORY ID 'MEM1'.

**********************************************************************

*REPORT  zac_prog.
*
*DATA lv_text TYPE text100.
*IMPORT lv_text TO lv_text FROM MEMORY ID 'MEM1'.
*FREE MEMORY ID 'MEM1'.
*WRITE lv_text.
