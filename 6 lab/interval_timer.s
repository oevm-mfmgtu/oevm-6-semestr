.include "key_codes.s"              
.extern PATTERN                     
.extern KEY_PRESSED
    
/**** Процедура обработки прерываний от таймера ****/
.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:                 
    subi    sp,  sp, 40 /* Сохраняем регистры в стеке */
    stw     ra, 0(sp)
    stw     r4, 4(sp)
    stw     r5, 8(sp)
    stw     r6, 12(sp)
    stw     r8, 16(sp)
    stw     r10, 20(sp)
    stw     r20, 24(sp)
    stw     r21, 28(sp)
    stw     r22, 32(sp)
    stw     r23, 36(sp)

    movia       r10, 0x10002000     
    sthio       r0,  0(r10)             

    movia       r20, 0x10000020     /*адрес регистра HEX3_HEX0 */
    movia       r21, 0x10000030     /*адрес регистра HEX7_HEX4*/
    addi        r5, r0, 1               
    movia       r22, PATTERN             
    movia       r23, KEY_PRESSED        

    ldw     r6, 0(r22)      /* загружаем текст для вывода на 7-сегментные индикаторы */
    stwio       r6, 0(r20)  /* выводим на HEX3 ... HEX0 */
    stwio       r6, 0(r21) /* выводим на HEX7 ... HEX4 */

    ldw     r4, 0(r23)      /* Проверяем, какая кнопка была нажата */
    movi        r8, KEY1    
    beq     r4, r8, LEFT    /* Если была нажата key1, то сдвигаем текст вправо */
    rol     r6, r6, r5      /* иначе, сдвигаем влево */
    br      END_INTERVAL_TIMER_ISR
    LEFT:
    ror     r6, r6, r5      /* сдвигаем текст вправо*/

    END_INTERVAL_TIMER_ISR:
    stw     r6, 0(r22)  /* выводим текст на 7-сегментные индикаторы */

    ldw     ra, 0(sp)       /* Восстанавливаем регистры из стека */
    ldw     r4, 4(sp)
    ldw     r5, 8(sp)
    ldw     r6, 12(sp)
    ldw     r8, 16(sp)
    ldw     r10, 20(sp)
    ldw     r20, 24(sp)
    ldw     r21, 28(sp)
    ldw     r22, 32(sp)
    ldw     r23, 36(sp) 
    addi    sp,  sp, 40             
    ret
.end
