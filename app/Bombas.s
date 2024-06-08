//Author: Johan Vargas

//Segmento de codigo 
.text
//Segmento de codigo 
/*****Nombre***************************************
 * f01_colocar_bombas
 *****Descripción**********************************
 * Insertar bombas
 *****Retorno**************************************
 * r0: coloca las bombas en direccion de memoria, matriz 
 *****Entradas*************************************
 * R1:	cantidad de bombas.
 * R2: fila de la matriz
 * r3: columna de la matriz
 * R4: puntero con la matriz.
 * R5: Contendra el valor maximo
 * R9: tamaño maximo.
 *****Errores**************************************
 * ##: NA
 **************************************************/


f01_colocar_bombas:
	PUSH	{R1-R3, R5-R9, LR }
	MUL 	R9,		R2,	R3		// genera el tamano maximo de la matriz
	
f01_while:

	BL		f02_contar_bombas
	CMP     R0,		 R1			// se hace una comparacion de cantidad de bombas con el contador de bombas colocadas
	BEQ		f01_end

	BL		f03_limitar_random
	MOV		R6,		R0          // FILA generada alazar
	BL		f03_limitar_random
	MOV		R7,		R0          // columna generada alazar

	MUL 	R8,		R6,		R3	// MULTIPLICAMOS LA FILA Y LA COLUMNA random
	ADD  	R8,		R7
	CMP		R8,		R9			// compara la posicion randon con el tamano maximo de la matriz
	BGE		f01_while

//-------------------------------------------------------------------------------------------------	
	/*
	LDRB	R6,		[R4, R8]	// extrae el valor de la posicion random
	CMP 	R6, #6
	BEQ 	f01_while*/
	MOV		R6,		#6 			// movemos el valor de la bomba a r6
	STR 	R6,		[R4, R8]	// guardamos en la posicion random el valor de la bomba

	B		f01_while

f01_end:
	POP		{R1-R3, R5-R9, PC }

/*****Nombre***************************************
 * f02_contar_bombas
 *****Descripción**********************************
 * Contar bombas en la lista
 *****Retorno**************************************
 * r5: cantidad Bombas 
 *****Entradas*************************************
 * r5: Cantidad de bombas 
 * r6: Posicion 
 *****Errores**************************************
 * ##: NA
 **************************************************/

f02_contar_bombas:
	PUSH	{ R1-R9, LR }
	MOV		R5,		#0 			// CNT BOMBAS
	MOV		R6,		#0 			// POS

f02_while:
	CMP		R6,		R9			// Domparamos la posicion tamano de la matriz
	BEQ		f02_end
	LDRB    R8,		[R4, R6]	// Extrae el valor de la posicion actual en la lista
	CMP		R8,		#6          // Se compara el valor extraido con el valor de la bomba
	ADDEQ	R5,		#1          // En caso de ser iguales, se incrementa el valor del contador de bombas 
	ADD		R6,		#1          // De lo contrario solo se suma 1 a la posicion
	B       f02_while              

f02_end:
	MOV		R0,		R5
	POP		{ R1 - R9, PC }

/*****Nombre***************************************
 * f03_limitar_random
 *****Descripción**********************************
 * limitar el numero ramdom
 *****Retorno**************************************
 * r0: Saca el modulo del numero ran generado  
 *****Entradas*************************************
 * r5: cantidad de filas 
 *****Errores**************************************
 * ##: NA 
 **************************************************/

f03_limitar_random:
	PUSH	{ R1, R5, LR }
	BL      fLU05_generate		// hace la llamanda a la funcion random
	MOV		R1,		R5			// se mueve la cantidad de filas a r1
	BL  	fLU06_modulo		// le saca el modulo al numero ramdon para asi limitarlo
	POP		{ R1, R5, PC }

/*****Nombre***************************************
 * f04_colocar_numeros:
 *****Descripción**********************************
 * coloca los numeros al rededor de la bomba
 *****Retorno**************************************
 * r9: matriz con bombas colocadas 
 *****Entradas*************************************
 * r3: columna 
 * R4: puntero con la matriz. 
 * R9: CANTIDAD DE TOTAL DE ALMACENAMIENTO
 *****Errores**************************************
 * ##: NA
 **************************************************/

f04_colocar_numeros:
	PUSH	{ R5-R9, LR }
	MOV		R6,		#0 			// POS
	MOV		R5,		#0 			// POS

f04_while:
	CMP		R6,		R9			// Comparamos la posicion tamano de la matriz
	BEQ		f04_end

	CMP		R5,		R3
	MOVEQ	R5,		#0

	LDRB    R8,		[R4, R6]	// Extrae el valor de la posicion actual en la lista
	CMP		R8,		#6          // Se compara el valor extraido con el valor de la bomba
	BEQ		f04_while02
	//-----------------------------------------------------------------------------------------------------
	ADD		R6,		#1          // De lo contrario solo se suma 1 a la posicion
	ADD  	R5,		#1
	B       f04_while              

f04_while02:
	MOV  	R7,		R5
	MOV		R8,		R6
	//
	BL		f06_fila
	//
	SUB 	R8, 	R3
	BL 		f06_fila
	//
	ADD 	R8,     R3
	ADD 	R8,     R3
	BL 		f06_fila
	//
	ADD		R6,		#1
	ADD  	R5,		#1
	B  		f04_while

f04_end:
	POP		{ R5 - R9, PC }


/*****Nombre***************************************
 * f05_colocar_num
 *****Descripción**********************************
 * coloca un numero
 *****Retorno**************************************
 * r0: Coloca un numero en la matriz 
 *****Entradas*************************************
 * R2: fila
 * r3: columna
 * R4: puntero con la matriz.
 * R7: columna aleatoria
 *****Errores**************************************
 * ##: NA
 **************************************************/

f05_colocar_num:
	PUSH	{ LR }

	LDRB	R1,		[R4, R8]   @Se carga en r1 el byte de r4 en la posiciond e r8   
	CMP		R1,		#6         @Se compara con 6
	BEQ		f05_end            @Si es igual termina el ciclo 
	ADD 	R1,		#1         @suma 1
	STRB 	R1,		[R4, R8]   

f05_end:
	POP		{ PC }

f06_fila:
	PUSH	{ R5-R9, LR }
	MOV		R5,		R7
	MOV		R9,		R8
	// Valida centro
	BL		f05_colocar_num

	// valida derecha
	ADD  	R7,		#1
	CMP		R7,		R3
	BLT		f06_fila_izquierda
	//
	MOV		R7,		R5
	MOV		R8,		R9

	// valida izquierda
	CMP		R7,		#0
	BEQ		f06_end
	B f06_fila_derecha

f06_fila_izquierda:
	ADD  	R8,		#1
	BL 		f05_colocar_num
	//
	MOV		R7,		R5
	MOV		R8,		R9
	// valida izquierda
	CMP		R7,		#0
	BEQ		f06_end
	B f06_fila_derecha


f06_fila_derecha:
	SUB  	R8,		#1
	BL 		f05_colocar_num

f06_end:
	POP		{ R5-R9, PC }

/*****Nombre***************************************
 * f07_contar_ceros
 *****Descripción**********************************
 * Contar ceros en la lista
 *****Retorno**************************************
 * r0: cantidad de ceros 
 *****Entradas*************************************
 * r5: cantidad 0
 * r6: posicion
 *****Errores**************************************
 * ##: na
 **************************************************/

f07_contar_ceros:
	PUSH	{ R1-R9, LR }
	MOV		R5,		#0 			// CNT ceros
	MOV		R6,		#0 			// POS

f07_while:
	CMP		R6,		R0			// Comparamos la posicion tamano de la matriz
	BEQ		f07_end
	LDRB    R8,		[R4, R6]	// Extrae el valor de la posicion actual en la lista
	CMP		R8,		#0          // Se compara el valor extraido con el valor de la bomba
	ADDEQ	R5,		#1          // En caso de ser iguales, se incrementa el valor del contador de bombas 
	ADD		R6,		#1          // De lo contrario solo se suma 1 a la posicion
	B       f07_while              

f07_end:
	MOV		R0,		R5
	POP		{ R1 - R9, PC }
	
