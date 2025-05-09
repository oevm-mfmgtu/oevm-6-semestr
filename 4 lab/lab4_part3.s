
.text                   		/* объявляем сегмент кода */
.equ A_start, 0x8000000 	/* начальный адрес фрагмента ОП */
.equ A_end, 0x81FFFFF   	/* конечный адрес фрагмента ОП */
.equ step, 0x1          		/* шаг для изменения числа - заполнителя */
.equ number, 0x0        	/* число - заполнитель */
.equ red, 0x10000000    	/* адрес красных светодиодов */
.equ green, 0x10000010  	/* адрес зеленых светодиодов */
.equ on, 0x3FFFF        	/* набор для зажигания светодиодов */

.global _start

_start:
        movia r5, number    	/* в r5 число для записи в ОП */
        movia r6, A_start   	/* в r6 начальный адрес фрагмента ОП*/
        movia r8, A_end     	/* в r8 конечный адрес фрагмента ОП */
    
        movia r3, red       	/* адрес красных светодиодов в r3 */
        movia r4, green     	/* адрес зеленых светодиодов в r4 */
        movia r2, on        	/* набор для зажигания в r2 */

        stwio r0, (r3)     	 	/* гасим красные светодиоды */
        stwio r0, (r4)      	/* гасим зеленые светодиоды */

p:  
        stw r5, (r6)        		/* число из r5 в ОП */
        ldw r7, (r6)        		/* число из ОП в r7 */
    
        bne r5, r7, ledr		/*если не совпали-зажигаем красные светодиоды*/
                               
    
        addi r5, r5, step		/* увеличиваем число-заполнитель на step */
        addi r6, r6, 4      	/* адресуем следующее слово в ОП */
    
        bgt r6, r8, ledg    	/* если проверили все адреса, зажигаем зеленые светодиоды */
        br p                		/* переходим на следующее обращение к ОП */

ledr:                   		/* зажигаем красные светодиоды */
        stwio r2, (r3)           
        br stop
ledg:                   		/* зажигаем зеленые светодиоды */
        stwio r2, (r4)  

stop:   br stop         		/* завершаем программу */
.end
