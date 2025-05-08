# нужно настроить стек
# передавать символ через регистр r7 
.text
.include "lcd_constants.s" 	/* Добавляем константы из файла */
.equ create_c,0b01000000         	/*переключить память на CGRAM и задать адрес*/
.equ com_bf,0b100000000           /*переключить память на DDRAM и задать адрес*/
		 /* это вторые байты кодов букв русского алфавита */                     
.equ a,0x90  		/*А */                     
.equ b,0x91  		/*Б */                  
.equ v,0x92  		/*В */                                     
.equ g,0x93  		/*Г */                                      
.equ d,0x94  		/*Д */                                     
.equ e,0x95  		/*Е */                                    
.equ yo,0x81 		/*Ё */                                     
.equ jz,0x96 		/*Ж */                                                         
.equ z,0x97  		/*З */                                                         
.equ i,0x98   		/*И */                                                        
.equ iy,0x99  		/*Й */                                                         
.equ k,0x9a    		/*К */                                                       
.equ l,0x9b    		/*Л */                                                       
.equ m,0x9c    		/*М */                                                       
.equ n,0x9d    		/*Н */                                                       
.equ o,0x9e    		/*О */                                                       
.equ p,0x9f    		/*П */                                                      
.equ r,0xa0    		/*Р */                                                      
.equ s,0xa1    		/*С */                                                       
.equ t,0xa2    		/*Т */                                                      
.equ u,0xa3    		/*У */                                                    
.equ f,0xa4    		/*Ф */                                                    
.equ h,0xa5    		/*Х */                                                   
.equ c,0xa6    		/*Ц */                                                    
.equ ch,0xa7   		/*Ч */                                     
.equ sh,0xa8		/*Ш */                                                       
.equ chsh,0xa9  		/*Щ */                                     
.equ hard_s,0xaa		/*Ъ */                                     
.equ hard_i,0xab		/*Ы */                                     
.equ soft_s,0xac 		/*Ь */                                     
.equ ye,0xad		/*Э */                                     
.equ yu,0xae		/*Ю */                                     
.equ ya,0xaf		/*Я */                                     
.equ max_new_sym, 0x8	/* Макс. кол-во новых символов */
.global print
print:

    subi sp, sp, 20
    stw r8,0(sp) 		/*r8 в стек */

    stw r5,4(sp) 		/*r5 в стек */

    stw r9,8(sp) 		/*r9 в стек */

    stw r2,12(sp) 		/*r2 в стек */
	

    stw r3,16(sp) 		/*r3 в стек */

    movia r8, 0xd0	/* 0хd0 первый байт кода символа*/
    beq r7, r8, the_end	/* если в r7 первый байт кода символа */
    movia r2,lcd            	/*Адрес команды lcd в r2 */
    movia r3,lcd+1            /*Адрес данных в lcd в r3 */

    ldbio r8,0(r2)		/* читаем регистр команд lcd */                        
    and r5, r5, zero	/* обнуляем r5 */
    andi r5, r8, 0b111	/* выделяем младшие три разряда */

    movia   r9, a		/* в r9 записываем второй байт кода буквы а*/
    beq     r7, r9, it_a	/* если в r7 код буквы а */
    movia   r9, b
    beq     r7, r9, it_b
    movia   r9, v
    beq     r7, r9, it_v
    movia   r9, g
    beq     r7, r9, it_g
    movia   r9, d
    beq     r7, r9, it_d
    movia   r9, e
    beq     r7, r9, it_e
    movia   r9, yo
    beq     r7, r9, it_yo
    movia   r9, jz
    beq     r7, r9, it_jz
    movia   r9, z
    beq     r7, r9, it_z
    movia   r9, i
    beq     r7, r9, it_i
    movia  r9, iy
    beq     r7, r9, it_iy
    movia   r9, k
    beq     r7, r9, it_k
    movia   r9, l
    beq     r7, r9, it_l
    movia   r9, m
    beq     r7, r9, it_m
    movia   r9, n
    beq     r7, r9, it_n
    movia   r9, o
    beq     r7, r9, it_o
    movia   r9, p
    beq     r7, r9, it_p
    movia   r9, r
    beq     r7, r9, it_r
    movia   r9, s
    beq     r7, r9, it_s
    movia   r9, t
    beq     r7, r9, it_t
    movia   r9, u
    beq     r7, r9, it_u
    movia   r9, f
    beq     r7, r9, it_f
    movia   r9, h
    beq     r7, r9, it_h
    movia   r9, c
    beq     r7, r9, it_c
    movia   r9, ch
    beq     r7, r9, it_ch
    movia   r9, sh
    beq     r7, r9, it_sh
    movia   r9, chsh
    beq     r7, r9, it_chsh
    movia   r9, hard_s
    beq     r7, r9, it_hard_s
    movia   r9, hard_i
    beq     r7, r9, it_hard_i
    movia   r9, soft_s
    beq     r7, r9, it_soft_s
    movia   r9, ye
    beq     r7, r9, it_ye
    movia   r9, yu
    beq     r7, r9, it_yu
    movia   r9, ya
    beq     r7, r9, it_ya
    br another_s

    it_a:  

    movia r5, str			/* если а, то используем латинскую букву */
    ldb r5,0(r5)
    br printing

    it_b: 				/* если Б, то */  
     slli r9, r12, 0x3		/* сдвигаем r5 на 3 разряда влево */
    ori r9, r9, 0b01000000	/* устанавливаем 6 разряд r9 */
        stbio r9, 0(r2)		/* отправляем в регистр команд */

        movia r9, 0b00011111	/* выполняется запись байтов с изображением Б */
        stbio r9, 0( r3)
        movia r9, 0b00010000
        stbio r9, 0( r3)
        movia r9, 0b00010000
        stbio r9, 0( r3)
        movia r9, 0b00011110
        stbio r9, 0(r3)
        movia r9, 0b00010001
        stbio r9, 0(r3)
        movia r9, 0b00010001
        stbio r9, 0(r3)
        movia r9, 0b00011110
        stbio r9, 0(r3)
        movia r9, 0b00000000
        stbio r9, 0(r3)
    br print_new

    it_v:				/* если В, то используется латинская буква */

    movia r5, str
    ldb r5,1(r5)
    br printing

    it_g:				/* если Г, то */

        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)

        movia r9, 0b00011111	/* выполняется запись байтов с изображением Г */
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00010000
        stbio r9, 0(r3)
        movia r9, 0b00000000
        stbio r9, 0(r3)
        br print_new

    it_d:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)

        movia r9, 0b00001111 #1 /* выполняется запись байтов с изображением Д */
        stbio r9, 0(r3)
        movia r9, 0b00000101 #2
        stbio r9, 0(r3)
        movia r9, 0b00000101 #3
        stbio r9, 0(r3)
        movia r9, 0b00001001 #4
        stbio r9, 0(r3)
        movia r9, 0b00010001 #5
        stbio r9, 0(r3)
        movia r9, 0b00011111 #6
        stbio r9, 0(r3)
        movia r9, 0b00010001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8 
        stbio r9, 0(r3)
        
        br print_new

    it_e:    
    it_yo:     

    movia r5, str
    ldb r5,2(r5)
    br printing

    it_jz:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)     

        movia r9, 0b00010101 #1 /* выполняется запись байтов с изображением Ж */
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010101 #3
        stbio r9, 0(r3)
        movia r9, 0b00001110 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00010101 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_z:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)

        movia r9, 0b00011110 #1 /* выполняется запись байтов с изображением З */
        stbio r9, 0(r3)
        movia r9, 0b00000001 #2
        stbio r9, 0(r3)
        movia r9, 0b00000001 #3
        stbio r9, 0(r3)
        movia r9, 0b00000110 #4
        stbio r9, 0(r3)
        movia r9, 0b00000001 #5
        stbio r9, 0(r3)
        movia r9, 0b00000001 #6
        stbio r9, 0(r3)
        movia r9, 0b00011110 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_i:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                  

        movia r9, 0b00010001 #1 /* выполняется запись байтов с изображением И */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010011 #3
        stbio r9, 0(r3)
        movia r9, 0b00010101 #4
        stbio r9, 0(r3)
        movia r9, 0b00011001 #5
        stbio r9, 0(r3)
        movia r9, 0b00010001 #6
        stbio r9, 0(r3)
        movia r9, 0b00010001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_iy:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
            

        movia r9, 0b00000100 #1 /* выполняется запись байтов с изображением Й */
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00010011 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00011001 #6
        stbio r9, 0(r3)
        movia r9, 0b00010001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_k:   
        
        movia r5, str	/* если К, то используем латинскую букву */
        ldb r5,3(r5)
        br printing    

    it_l:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                  

        movia r9, 0b00001111 #1 /* выполняется запись байтов с изображением Л */
        stbio r9, 0(r3)
        movia r9, 0b00000101 #2
        stbio r9, 0(r3)
        movia r9, 0b00000101 #3
        stbio r9, 0(r3)
        movia r9, 0b00000101 #4
        stbio r9, 0(r3)
        movia r9, 0b00000101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00001001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_m:			/* если М, то используем латинскую букву */   

        movia r5, str
        ldb r5,4(r5)
        br printing          

    it_n:       
  
        movia r5, str	/* если Н, то используем латинскую букву */
        ldb r5,5(r5)
        br printing  

    it_o:      

        movia r5, str	/* если О, то используем латинскую букву */
        ldb r5,6(r5)
        br printing

    it_p:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
            

        movia r9, 0b00011111 #1 /* выполняется запись байтов с изображением П */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00010001 #4
        stbio r9, 0(r3)
        movia r9, 0b00010001 #5
        stbio r9, 0(r3)
        movia r9, 0b00010001 #6
        stbio r9, 0(r3)
        movia r9, 0b00010001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new
     
    it_r: 			/* если Р, то используем латинскую букву */ 
    
        movia r5, str
        ldb r5,7(r5)
        br printing        

    it_s:			/* если С, то используем латинскую букву */ 			       
         movia r5, str
        ldb r5,8(r5)
        br printing        

    it_t: 			/* если Т, то используем латинскую букву */          
         movia r5, str
        ldb r5,9(r5)
        br printing
    it_u:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                   

        movia r9, 0b00010001 #1	/* У */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00001010 #4
        stbio r9, 0(r3)
        movia r9, 0b00000100 #5
        stbio r9, 0(r3)
        movia r9, 0b00001000 #6
        stbio r9, 0(r3)
        movia r9, 0b00010000 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new
    it_f: 
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                

        movia r9, 0b00001110 #1 
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010101 #3
        stbio r9, 0(r3)
        movia r9, 0b00010101 #4
        stbio r9, 0(r3)
        movia r9, 0b00001110 #5
        stbio r9, 0(r3)
        movia r9, 0b00000100 #6
        stbio r9, 0(r3)
        movia r9, 0b00000100 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_h:       
        movia r5, str	/* если Х, то используем латинскую букву */
        ldb r5,0xa(r5)
        br printing 

    it_c: 
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                  
        movia r9, 0b00010001 #1
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00010001 #4
        stbio r9, 0(r3)
        movia r9, 0b00010001 #5
        stbio r9, 0(r3)
        movia r9, 0b00010001 #6
        stbio r9, 0(r3)
        movia r9, 0b00011111 #7
        stbio r9, 0(r3)
        movia r9, 0b00000001 #8
        stbio r9, 0(r3)
        
        br print_new
    it_ch:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
           

        movia r9, 0b00010001 #1
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00001111 #4
        stbio r9, 0(r3)
        movia r9, 0b00000001 #5
        stbio r9, 0(r3)
        movia r9, 0b00000001 #6
        stbio r9, 0(r3)
        movia r9, 0b00000001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new
    it_sh:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
                   
        movia r9, 0b00010101 #1
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010101 #3
        stbio r9, 0(r3)
        movia r9, 0b00010101 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00011111 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new
    it_chsh:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
           
        movia r9, 0b00010101 #1
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010101 #3
        stbio r9, 0(r3)
        movia r9, 0b00010101 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00011111 #7
        stbio r9, 0(r3)
        movia r9, 0b00000001 #8
        stbio r9, 0(r3)
        
        br print_new

    it_hard_s:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
           

        movia r9, 0b00011000 #1	/* Ъ */
        stbio r9, 0(r3)
        movia r9, 0b00001000 #2
        stbio r9, 0(r3)
        movia r9, 0b00001000 #3
        stbio r9, 0(r3)
        movia r9, 0b00001110 #4
        stbio r9, 0(r3)
        movia r9, 0b00001001 #5
        stbio r9, 0(r3)
        movia r9, 0b00001001 #6
        stbio r9, 0(r3)
        movia r9, 0b00001110 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_hard_i: 
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
         
        movia r9, 0b00010001 #1	/* Ы */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00011001 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00011001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_soft_s:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
           
        movia r9, 0b00001000 #1	/* Ь */
        stbio r9, 0(r3)
        movia r9, 0b00001000 #2
        stbio r9, 0(r3)
        movia r9, 0b00001000 #3
        stbio r9, 0(r3)
        movia r9, 0b00001110 #4
        stbio r9, 0(r3)
        movia r9, 0b00001001 #5
        stbio r9, 0(r3)
        movia r9, 0b00001001 #6
        stbio r9, 0(r3)
        movia r9, 0b00001110 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_ye:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
         

        movia r9, 0b00001110 #1	/* Э */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00000101 #3
        stbio r9, 0(r3)
        movia r9, 0b00001011 #4
        stbio r9, 0(r3)
        movia r9, 0b00000001 #5
        stbio r9, 0(r3)
        movia r9, 0b00010001 #6
        stbio r9, 0(r3)
        movia r9, 0b00001110 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new

    it_yu:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
         
        movia r9, 0b00010010 #1	/* Ю */
        stbio r9, 0(r3)
        movia r9, 0b00010101 #2
        stbio r9, 0(r3)
        movia r9, 0b00010101 #3
        stbio r9, 0(r3)
        movia r9, 0b00011101 #4
        stbio r9, 0(r3)
        movia r9, 0b00010101 #5
        stbio r9, 0(r3)
        movia r9, 0b00010101 #6
        stbio r9, 0(r3)
        movia r9, 0b00010010 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0(r3)
        
        br print_new
    it_ya:
        slli r9, r12, 0x3 
        ori r9, r9, 0b01000000
        stbio r9, 0(r2)
         
        movia r9, 0b00001111 #1	/* Я */
        stbio r9, 0(r3)
        movia r9, 0b00010001 #2
        stbio r9, 0(r3)
        movia r9, 0b00010001 #3
        stbio r9, 0(r3)
        movia r9, 0b00001111 #4
        stbio r9, 0(r3)
        movia r9, 0b00000101 #5
        stbio r9, 0(r3)
        movia r9, 0b00001001 #6
        stbio r9, 0(r3)
        movia r9, 0b00010001 #7
        stbio r9, 0(r3)
        movia r9, 0b00000000 #8
        stbio r9, 0( r3)
        
        br print_new

    another_s:

        mov     r5, r7
	br printing

print_new:
        mov  r5, r12
        addi r12, r12, 1		/* Увеличение кол-ва новых символов */
        movi r13, max_new_sym
        bne  r12, r13, printing	/* Сравнение с макс. кол-вом символов */
        movi r12, 0

    printing:

        movia r9, set1
        or   r9, r9, r8
        stbio r9, 0(r2)     

        stbio r5, 0(r3)
 
the_end:
        ldw r3,0(sp)

        ldw r2,4(sp)

        ldw r9,8(sp)

        ldw r5,12(sp)

        ldw r8,16(sp)

        addi sp,sp,20

        ret
    .data 	/* сегмент данных */                              
    str:	/* начиная с этой метки размещается строка символов */
    .asciz "ABEKMHOPCTX    "
    .end
