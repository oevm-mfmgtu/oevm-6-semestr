.include "lcd_constants.s"	/* Добавляем константы из файла */
.global _start
.text				/*Определяем секцию кода*/


_start:
movia r2,lcd		/* Адрес LCD в регистр r2 */
movi r3,clear  		/*Команду очистки lcd в r3*/
stbio r3,0(r2) 		/*Очищаем экран lcd*/

movi r3,set1
stbio r3,0(r2)  		/*Устанавливаем курсор в начало первой строки на LCD*/

movia r4,String1 	/*В регистр r4 записываем адрес первой строки в ОП*/
cikl:
    	ldb r5,0(r4)  		/*Считываем символ из строки (ОП) и помещаем его в r5*/
    	beq r5,zero,met		/*Если считанный символ равен 0, выход из цикла*/
    	stbio r5,1(r2)  		/*Пересылаем из r5 в регистр данных lcd*/
    	addi r4,r4,1    		/*Инкрементируем адрес символа в строке*/
    	br cikl			/* Повторяем для остальных символов */

met:
    	movi r3,set2
    	stbio r3,0(r2)  		/*Устанавливаем курсор в начало второй строки на LCD*/

movia r4,String2    	/*Выводим вторую строку на LCD*/
cikl2:
    	ldb r5,0(r4)
    	beq r5,zero,1f	
    	stbio r5,1(r2)
    	addi r4,r4,1
    	br cikl2

1:
    	movi r3,off
    	stbio r3,0(r2)  		/*Выключаем курсор*/


    	movi r3,right
    	stbio r3,0(r2)  		/*Сдвигаем строки вправо */


    	br .-4			/* Повторяем сдвиг строк */


 2: 
movi r3,left
    	stbio r3,0(r2)  		/*Сдвигаем строки влево */
    	br 2b+4		 /* Повторяем сдвиг строк */

.data       			/*Определяем секцию данных*/
String1:
.asciz "Familiya                           konec"
String2:
.asciz "Imya"
.end
