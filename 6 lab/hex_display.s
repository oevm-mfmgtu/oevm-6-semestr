.include "adress_map.s"

    .text

    .global hex_display
hex_display:
/* Сохранение регистров */
	stw r11, (sp)
	stw r10, -4(sp)
	stw r3, -8(sp)
	stw r2, -12(sp)
	/* Адрес текущего индикатора */
	movia r10, HEXL_ADDR
DISPLAY_LOOP:
	/* Получаем цифру, с помощью маски */
	andi r3, r2, 0xF
	/* Получаем значение для отображения цифры на индикаторе */
	movia r11, DECODE_TABLE
	add r11, r11, r3
	ldb r3, (r11)
	/* Отображаем цифру */
	stbio r3, (r10)
	/* Выходим, если все цифры отображены */
	movia r11, HEXH_ADDR + 3
	beq r10, r11, DISPLAY_DONE
	/* Сдвигаем слово вправо на 1 цифру */
	srli r2, r2, 0x4
	/* Получаем адрес следующего индикатора */
	movia r11, HEXL_ADDR + 3
	beq r10, r11, NEXT_REG_ADDR
	/* Индикатор в текущем регистре */
	addi r10, r10, 0x1
	br DISPLAY_LOOP
NEXT_REG_ADDR:
	/* Индикатор в следующем регистре */
	movia r10, HEXH_ADDR
	br DISPLAY_LOOP
DISPLAY_DONE:
	/* Восставновление регистров */
	ldw r11, (sp)
	ldw r10, -4(sp)
	ldw r3, -8(sp)
	ldw r2, -12(sp)
	ret

    
    /* Таблица декодирования для 7-сегментных индикаторов. Каждый бит управляет 1 сегментом индикатора */
    
DECODE_TABLE:
    .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111 
    .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111
    .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100 
    .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001            
.end
