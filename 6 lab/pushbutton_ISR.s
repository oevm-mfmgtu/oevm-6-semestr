.include "key_codes.s"              
.extern KEY_PRESSED                 
.extern PATTERN
                        
/**** Обработчик прерываний от кнопок ****/
.global PUSHBUTTON_ISR
PUSHBUTTON_ISR:
    subi    sp, sp, 20      /* Сохраняем регистры в стеке*/
    stw     ra, 0(sp)
    stw     r10, 4(sp)
    stw     r11, 8(sp)
    stw     r12, 12(sp)
    stw     r13, 16(sp)

    movia       r10, 0x10000050         
    ldwio       r11, 0xC(r10)   /* Считываем значение из edge-capture регистра*/
    stwio       r0,  0xC(r10)   /* Сбрасываем прерывание */                  

    movia       r10, KEY_PRESSED            
    CHECK_KEY1:
        andi    r13, r11, 0b0010    /* Если была нажата кнопка key1 */
        beq     r13, zero, CHECK_KEY2
        movi    r12, KEY1
        stw     r12, 0(r10)         
        br      END_PUSHBUTTON_ISR

    CHECK_KEY2:
        andi    r13, r11, 0b0100    /* Если была нажата кнопка key2*/
        beq     r13, zero, DO_KEY3
        movi    r12, KEY2
        stw     r12, 0(r10)                 
        br      END_PUSHBUTTON_ISR

    DO_KEY3:
        movia   r13, 0x10000040     
        ldwio   r11, 0(r13) /* Считываем значение с переключателей */
        movia   r13, PATTERN            
        stw     r11, 0(r13)     /* Сохраняем измененный текст */

    END_PUSHBUTTON_ISR:
        ldw     ra,  0(sp)          /* Восстанавливаем регистры из стека */
        ldw     r10, 4(sp)
        ldw     r11, 8(sp)
        ldw     r12, 12(sp)
        ldw     r13, 16(sp)
        addi    sp,  sp, 20
    ret
.end
