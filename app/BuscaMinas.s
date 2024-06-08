@******** Datos Administrativos ********************
@**
@** Nombre del archivo: BuscaMinas.s.
@** Autores:
@** Johan Vargas Quesada	 2020124293.
@** Randall Corella Castillo 2020087763.
@** Aaron Piñar Mora         2019063903.
@**
@******** Descripcion ******************************
@**
@** Es un busca minas donde puede elejir un modo de
@** juego, ya sea facil, medio, dificil o personalizado.
@** En base a ello se desplegara un tablero de juego
@** en donde el usuario debera ingresar posiciones 
@** donde decidira si coloca una banderilla o quiere 
@** seleccionar, el juego termina cuando el espacio
@** seleccionado sea una bomba o cuando los espacios que
@** no tengan bombas sean descubiertos.
@**
@******** Version **********************************
@**
@** 1.0 | 27/3/2022 | Johan Vargas, Aaron Piñar, Randall Corella
@**
@******** Code *************************************

.include	"validaciones.s"
.include 	"Bombas.s"
.include 	"MJ.s"
.include 	"LMM.s"

@Seccion Data 
.data



@ Menus
menuIni:	.asciz "\n***************************\n*\tBusca Minas\t  *\n*\t\t\t  *\n*\t\t\t  *\n*\t  1-Jugar\t  *\n*\t  2-Salir\t  *\n*\t\t\t  *\n*************************** \n\n"
menuDif:	.asciz "\n***********************************\n*\tElija la dificultad\t  *\n*\t\t\t\t  *\n*\t\t\t\t  *\n*\t  1-Facil\t\t  *\n*\t  2-Medio\t\t  *\n*\t  3-Dificil\t\t  *\n*\t  4-Personalizado\t  *\n*\t  5-Volver\t\t  *\n*\t\t\t\t  *\n*********************************** \n\n"

casilla: .asciz "⬜"
descubierto: .asciz "\033[0;32;40m⭕\033[0m"
rojo:	.asciz "\033[0;31;40m"
end_rojo: .asciz "\033[0m"

@mensajes de error
msgError:	.ascii	"\nLa opcion incorrecta\n"

@ Pedir opciones
opcion:		.ascii "\nElija una opcion: "
columna:	.ascii "\nColumna: "
fila:		.ascii "\nFila: "
bom:		.ascii "\nCantidad de bombas: "
fin: 	.asciz "\nPerdio"
gano: 	.asciz "\nFELICIDADES\n"
column: .skip 1
fil: .skip 1
clear:    .asciz "\033c"
@ Guarda los input
cantBombas: .ascii ""
input1:	.asciz " "

@Seccion de codigo 
.text
.global _start

_start:							@ Menu de inicio de juego
	MOV		R0,		#0 			@ Se mueve un 0 a R0 para hacer un reset en el registro
	PRINT clear 3
menuPrin:
	MOV		R0,		#0
	PRINT	menuIni 132
	PRINT	opcion 19
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		largo

	CMP  	R0,		#1 			@ Valida que el input sea de largo 1
	BEQ  	validarInput 
	PRINT clear 3		
	PRINT   msgError  22
	B  		menuPrin

validarInput:
	LDR 	R4,		=input1
	BL		convertir_entero
	CMP 	R0,		#1
	BEQ		elegirOpcionDif
	CMP		R0,		#2
	BGT		msg_error01
	B  		endgame

msg_error01:
	PRINT clear 3
	PRINT   msgError  23
	B  		menuPrin

elegirOpcionDif:				@ Print de elejir Opcion
	PRINT clear 3
	PRINT	menuDif 222
	PRINT	opcion 19
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		largo

	CMP  	R0,		#1 			@ Valida que el input sea de largo 1
	BEQ  	validarInputDif 	
	PRINT   msgError  20
	B  		elegirOpcionDif

validarInputDif:
	LDR 	R0,		=input1
	BL		convertir_entero
	CMP 	R0,		#5
	BGT		msg_error02
	CMP		R0,		#1
	BEQ		facil
	CMP		R0,		#2
	BEQ		medio
	CMP		R0,		#3
	BEQ		dificil
	CMP		R0,		#4
	BEQ		personalizada
	CMP		R0,		#5
	BEQ		menuPrin
	B  		elegirOpcionDif

msg_error02:
	PRINT   msgError  20
	B  		elegirOpcionDif

facil:
	B  		f01_juego_facil_interfaz

medio:
	B  		f02_juego_medio_interfaz

dificil:
	B  		f03_juego_dificil_interfaz

/*****Nombre***************************************
 * f01_juego_facil_interfaz
 *****Descripción**********************************
 *  interfaz para juego facil 
 *****Retorno**************************************
 * r0: crea juego con juego_facil
 *****Errores**************************************
 * ##: NA
 **************************************************/

f01_juego_facil_interfaz:
	//este es el valor fijo a multiplicar.
	BL juego_facil //modos de juego./*

fPR01_while:
	PRINT clear 3
	//enviamos la matriz de printeo a r4 para consultar los espacios no descubiertos
	MOV R4, R10
	MOV R0, #81
	BL f07_contar_ceros //Contamos los espacios no descubiertos. En R0 esta el resultado.
	CMP R0, #10
	BEQ end_juego //Finalizamos si ya no hay casillas por liberar a excepcion de las bombas.
	MOV R10, R4

	PRINT salto
	PRINT salto
	//Printamos la matriz.
	MOV R4, #0
	MOV R4, R10
  	MOV R1, #81
  	MOV R2, #9
  	BL fM02_printar_matriz
  	PRINT salto
  	PRINT salto
//===================================================================

	PRINT	fila 7
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R1,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R1,		#10
	BGE		fPR01_while
	CMP		R1,		#0
	BLE		fPR01_while

	//========================================================================
	PRINT	columna 10
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R2,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R2,		#10
	BGE		fPR01_while
	CMP		R2,		#0
	BLE		fPR01_while
	// final
	SUB		R1,		#1
	SUB		R2,		#1
	MOV		R8,		R2
	// PARA SABER SI EL VALOR ES MAYOR A 9
	

	//movemos la matriz de busqueda a r4.
	MOV R4, R9
	MOV R3, #9

	MUl R5, R1, R3 //multiplicamos por col la fila.
	MOV R7, r5
	ADD R5, R2 //sumamos la col.

	MOV R6, R5 //guardamos la posicion a revelar.

	//hacemos el LDRB
	LDRB R1, [R4, R5] //Guardamos en r1 el valor de la casilla que el usuario eligio.
	//====================================================================
	CMP R1, #6
	BEQ end_juego_perdio //si es una bomba, terminamos el juego.
	//========================================================================================

	
	//===========================================================================================Good====================================================


	//Hacemos el proceso recursivo.
	//R1 esta la pos que hay que liberar.
	MOV R2, #81
	MOV R3, #9
	//
	MOV R4, R9
	MOV R5, R10
	BL fM03_revelar_casillas
	MOV		R4,		R9
	MOV		R5,		R10
	//==================================================================================

	B  fPR01_while

//============================================= end facil ==============================================================

/*****Nombre***************************************
 * f02_juego_medio_interfaz
 *****Descripción**********************************
 *  interfaz para juego medio
 *****Retorno**************************************
 * r0: crea juego con juego_medio
 *****Errores**************************************
 * ##: NA
 **************************************************/

f02_juego_medio_interfaz:
	//este es el valor fijo a multiplicar.
	BL juego_medio //modos de juego./*

fPR02_while:
	PRINT clear 3
	//enviamos la matriz de printeo a r4 para consultar los espacios no descubiertos
	MOV R4, R10
	MOV R0, #256
	BL f07_contar_ceros //Contamos los espacios no descubiertos. En R0 esta el resultado.
	CMP R0, #40
	BEQ end_juego //Finalizamos si ya no hay casillas por liberar a excepcion de las bombas.
	MOV R10, R4

	PRINT salto
	PRINT salto
	//Printamos la matriz.
	MOV R4, #0
	MOV R4, R10
  	MOV R1, #256
  	MOV R2, #16
  	BL fM02_printar_matriz
  	PRINT salto
  	PRINT salto
//===================================================================

	PRINT	fila 7
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R1,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R1,		#17
	BGE		fPR02_while
	CMP		R1,		#0
	BLE		fPR02_while

	//========================================================================
	PRINT	columna 10
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R2,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R2,		#17
	BGE		fPR02_while
	CMP		R2,		#0
	BLE		fPR02_while
	// final
	SUB		R1,		#1
	SUB		R2,		#1
	MOV		R8,		R2
	// PARA SABER SI EL VALOR ES MAYOR A 9
	

	//movemos la matriz de busqueda a r4.
	MOV R4, R9
	MOV R3, #16

	MUl R5, R1, R3 //multiplicamos por col la fila.
	MOV R7, r5
	ADD R5, R2 //sumamos la col.

	MOV R6, R5 //guardamos la posicion a revelar.

	//hacemos el LDRB
	LDRB R1, [R4, R5] //Guardamos en r1 el valor de la casilla que el usuario eligio.
	//====================================================================
	CMP R1, #6
	BEQ end_juego_perdio //si es una bomba, terminamos el juego.
	//========================================================================================

	
	//===========================================================================================Good====================================================


	//Hacemos el proceso recursivo.
	//R1 esta la pos que hay que liberar.
	MOV R2, #256
	MOV R3, #16
	//
	MOV R4, R9
	MOV R5, R10
	BL fM03_revelar_casillas
	MOV		R4,		R9
	MOV		R5,		R10
	//==================================================================================

	B  fPR02_while

//============================================= end medio ==============================================================

/*****Nombre***************************************
 * f03_juego_dificil_interfaz
 *****Descripción**********************************
 *  interfaz para juego dificil
 *****Retorno**************************************
 * r0: crea juego con juego_dificil
 *****Errores**************************************
 * ##: NA
 **************************************************/

f03_juego_dificil_interfaz:
	//este es el valor fijo a multiplicar.
	BL juego_dificil //modos de juego./*

fPR03_while:
	PRINT clear 3
	//enviamos la matriz de printeo a r4 para consultar los espacios no descubiertos
	MOV R4, R10
	MOV R0, #480
	BL f07_contar_ceros //Contamos los espacios no descubiertos. En R0 esta el resultado.
	CMP R0, #99
	BEQ end_juego //Finalizamos si ya no hay casillas por liberar a excepcion de las bombas.
	MOV R10, R4

	PRINT salto
	PRINT salto
	//Printamos la matriz.
	MOV R4, #0
	MOV R4, R10
  	MOV R1, #480
  	MOV R2, #30
  	BL fM02_printar_matriz
  	PRINT salto
  	PRINT salto
//===================================================================

	PRINT	fila 7
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R1,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R1,		#17
	BGE		fPR03_while
	CMP		R1,		#0
	BLE		fPR03_while

	//========================================================================
	PRINT	columna 10
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R2,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R2,		#31
	BGE		fPR03_while
	CMP		R2,		#0
	BLE		fPR03_while
	// final
	SUB		R1,		#1
	SUB		R2,		#1
	MOV		R8,		R2
	// PARA SABER SI EL VALOR ES MAYOR A 9
	

	//movemos la matriz de busqueda a r4.
	MOV R4, R9
	MOV R3, #30

	MUl R5, R1, R3 //multiplicamos por col la fila.
	MOV R7, r5
	ADD R5, R2 //sumamos la col.

	MOV R6, R5 //guardamos la posicion a revelar.

	//hacemos el LDRB
	LDRB R1, [R4, R5] //Guardamos en r1 el valor de la casilla que el usuario eligio.
	//====================================================================
	CMP R1, #6
	BEQ end_juego_perdio //si es una bomba, terminamos el juego.
	//========================================================================================

	//===========================================================================================Good====================================================
	//Hacemos el proceso recursivo.
	//R1 esta la pos que hay que liberar.
	MOV R2, #480
	MOV R3, #30
	//
	MOV R4, R9
	MOV R5, R10
	BL fM03_revelar_casillas
	MOV		R4,		R9
	MOV		R5,		R10
	//==================================================================================

	B  fPR03_while


end_juego_perdio:
	PRINT fin 7
	PRINT salto
	MOV		R7,		#1
	SVC		#0

end_juego:
	PRINT   gano 13
	MOV		R7,		#1
	SVC		#0
//=================================================================================================================


/*****Nombre***************************************
 * personalizada
 *****Descripción**********************************
 * crea una matriz personalizada para jugar 
 *****Retorno**************************************
 * r0: matriz perzonalizada
 *****Entradas*************************************
 * r0: Fila y columana 
 *****Errores**************************************
 * ##: Varios dependientes de los valores ingresados
 **************************************************/

personalizada:
	PRINT	fila 7
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R1,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R1,		#101
	BGE		personalizada
	CMP		R1,		#0
	BLE		personalizada

	LDR     R0,     =fil
	STRB	R1, 	[R0]

	//========================================================================
	PRINT	columna 10
	INPUT   input1 100
	BL		convertir_entero_varios_digitos
	MOV		R2,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	CMP		R2,		#101
	BGE		personalizada
	CMP		R2,		#0
	BLE		personalizada
	LDR     R0,     =column
	STRB	R2, 	[R0]

	//========================================================================
	PRINT	bom 21
	INPUT   cantBombas 100
	BL		convertir_entero_varios_digitos

	MOV		R5,		R0
	MUL		R0,		R1,  	R2
	MOV		R6,     R0
	MOV		R1,		#4
	BL      fLU04_dividir
	CMP		R0,		R5
	BlT		personalizada
	MOV		R0,		R6

f04_juego_personalizado_interfaz:
	//este es el valor fijo a multiplicar.
	BL juego_personalizada //modos de juego./*

	MOV R6, R0
//======================================================================================

fPR04_while:
	//enviamos la matriz de printeo a r4 para consultar los espacios no descubiertos
	LDR  	R4,   =cantBombas
	BL		convertir_entero_varios_digitos
	MOV     R1,     R0
	//====================================================================================
	MOV		R4,     R9
	//=================== COLOCAR FILAS ======================================================
  	LDR   R2,   =fil
  	LDRB  R2,   [R2, #0]
  	//=================== COLOCAR COLUMNA ====================================================
  	LDR   R3,   =column
  	LDRB  R3,   [R3, #0]
  	MUL	  R0,	R3,	R2
  	MOV R4, R10
	BL f07_contar_ceros //Contamos los espacios no descubiertos. En R0 esta el resultado.
	CMP R0, R1
	BEQ end_juego //Finalizamos si ya no hay casillas por liberar a excepcion de las bombas.
	MOV R10, R4
	//=================== COLOCAR FILAS ======================================================
  	LDR   R2,   =fil
  	LDRB  R2,   [R2, #0]
  	//=================== COLOCAR COLUMNA ====================================================
  	LDR   R3,   =column
  	LDRB  R3,   [R3, #0]
  	MUL	  R0,	R3,	R2

	//PRINT salto
	//PRINT salto
	//Printamos la matriz.
	MOV   R4, #0
	MOV   R4, R10
  	MOV   R1, R0
  	LDR   R2,   =column
  	LDRB  R2,   [R2, #0]
  	BL fM02_printar_matriz
  	PRINT salto
  	PRINT salto
  
	//===================================================================

	PRINT	fila 7
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R1,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	//Sacamos la fila.
	LDR   R2,   =fil
  	LDRB  R2,   [R2, #0]
  	ADD   R2, #1
  	//
	CMP		R1,		R2
	BGE		fPR04_while
	CMP		R1,		#0
	BLE		fPR04_while

	//========================================================================
	PRINT	columna 10
	INPUT   input1 100
	LDR 	R4,		=input1
	BL		convertir_entero_varios_digitos
	MOV		R2,		R0
	// PARA SABER SI EL VALOR ES MAYOR A 9
	//sacamos columna
	LDR   R3,   =column
  	LDRB  R3,   [R3, #0]
  	ADD   R3, #1
  	//
	CMP		R2,		r3
	BGE		fPR04_while
	CMP		R2,		#0
	BLE		fPR04_while
	// final
	SUB		R1,		#1
	SUB		R2,		#1
	MOV		R8,		R2
	// PARA SABER SI EL VALOR ES MAYOR A 9
	
	SUB R3, #1
	MUl R5, R1, R3 //multiplicamos por col la fila.
	MOV R7, r5
	ADD R5, R2 //sumamos la col.

	MOV R6, R5 //guardamos la posicion a revelar.

	//hacemos el LDRB
	MOV R4, R9
	LDRB R1, [R4, R5] //Guardamos en r1 el valor de la casilla que el usuario eligio.
	//====================================================================
	CMP R1, #6
	BEQ end_juego_perdio //si es una bomba, terminamos el juego.
	//========================================================================================

	//===========================================================================================Good====================================================

	//Hacemos el proceso recursivo.
	//R1 esta la pos que hay que liberar.
	//FIl
	LDR   R4,   =fil
  	LDRB  R4,   [R4, #0]
  	//COl
  	LDR   R3,   =column
  	LDRB  R3,   [R3, #0]
  	//
  	MUL R2, R3, R4
	//
	MOV R4, R9
	MOV R5, R10
	BL fM03_revelar_casillas
	MOV		R4,		R9
	MOV		R5,		R10
	//==================================================================================

	B  fPR04_while

//============================================= end facil ==============================================================
//============================================= medio ====================================

endgame:

	MOV 	R7, 	#1 			@ EXIT
	SVC 	#0


