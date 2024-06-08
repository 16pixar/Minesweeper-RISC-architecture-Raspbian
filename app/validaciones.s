//Validaciones para el Menu
//Author: Johan Vargas, Randall Corella, Aarón Piñar 


//Segmento de datos

.text

/*****Nombre***************************************
 * largo
 *****Descripción**********************************
 * Saca el largo del input entrante 
 *****Retorno**************************************
 * R8: Largo del Input
 *****Entradas*************************************	
 * r4: puntero de direccion de memoria 
 *****Errores**************************************
 * ##: NA
 **************************************************/
largo:							@ Cuenta cuantos elementos se ingresaron en el input
	PUSH	{ R8- R9, lr }
	MOV		R8,		#0
largoInput:

	LDRB	R9,		[ R4, R8 ]	@ Carga en R9 el byte de R4 en la posicion que de R8
	CMP		R9,		#0xa 		@ Compara cuando R9 sea igual a \n
	BEQ		largoInputEnd 		@ Si se cumple lo dirigue a validarLen
	ADD		R8,		#1 			@ Cada vez que se cargue un byte de R8 se va a sumar 1 al contador de bytes donde se guarda la posicion
	B  		largoInput 			@ Repite el proceso

largoInputEnd:
	MOV 	R0,		R8          @Se mueve el valor obtenido a R0 para luego acceder a el 
	POP		{ R8 - R9, pc }     @->R8:Indica el largo del input


/*****Nombre***************************************
 * convertir_entero
 *****Descripción**********************************
 * CONVERTIR UN NUMERO INGRESADO DE UN INPUT A ENTERO
 *****Retorno**************************************
 * R6: El numero ingresado a entero 
 *****Entradas*************************************
 * r4: puntero de direccion de memoria 
 *****Errores**************************************
 * ##: NA
 **************************************************/
convertir_entero:
	PUSH	{ R8 - R9, LR }
	//MOV		R8,		#0
	LDRB	R9,		[ R4, #0 ]	@Carga en R9 el byte de R4 en la posicion 0
	SUB		R9,	    #48			@Se le resta 48
	MOV		R0,		R9			
	POP		{ R8 - R9, PC }

convertir_entero_varios_digitos:
	PUSH	{ R5 - R8, LR }
	MOV		R8,		#0
	MOV  	R6,		#0
	MOV		R7,		#10

convertir_while:
	LDRB	R5,		[ R4, R8 ] @Carga en r5 el byte de R4 en la posicon de 8
	CMP		R5,		#0xa	   @Se compara
	BEQ		convertir_end	   @Si es igual se termina el ciclo
	SUB		R5,	    #48		   @Se le resta 48 a R6
	MUL		R6,		R7         @Se multiplica R6 con r
	ADD     R6,		R5         
	ADD  	R8,		#1	       @Se le suma uno 
	B   	convertir_while	   @Repite el ciclo 

convertir_end:				   @Funcion para finalizar el ciclo 
	MOV		R0,		R6
	POP		{ R5 - R8, PC }
