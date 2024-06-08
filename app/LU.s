//LU: Libreria utilidad.
//Autor: Randall Corella Castillo.
//Segmento de datos.

.data

randomfile: .asciz  "/dev/urandom"
espace: .asciz " "
salto: .asciz "\n"

caracter: .skip 1 //Para printear caracter 

.bss	//segmento de datos inicializados 
randombyte: .skip   1 //Para almacenar el numero random 


//Segmento de codigo.
.text
/*****Nombre***************************************
 * fLU01_contar_caracteres
 *****Descripción**********************************
 * Contar caracteres
 * En caso de ser ascii, reste 2 al final.
 * En caso de ser asciz el retorno es el correcto.
 *****Retorno**************************************
 * r0: cantidad de caracteres.
 *****Entradas*************************************
 * r5: Recibe un puntero en memoria con una cadena de bytes.
 * r4: contador  
 *****Errores**************************************
 * ##: NA 
 **************************************************/

fLU01_contar_caracteres:
	PUSH {r4, r5, lr}
	MOV r4, #0 // r4: contador.
//
fLU01_while:
	LDRB r5, [r0,r4] //Posicion actual de la cadena.
	CMP r5, #0 //Comparamos con caracter nulo.
	BEQ fLU01_while_end
	ADD r4, #1 //Agregamos al contador.
	BAL fLU01_while

fLU01_while_end:
	MOV r0, r4
	POP {r4, r5, pc} //lr a pc para volver a donde se llamo esta funcion.


/*****Nombre***************************************
 * fLU02_imprimir_mensaje
 *****Descripción**********************************
 * Printar mensajes. Funciona principalmente con "asciz".
 *****Retorno**************************************
 * r0:Direccion del mensaje que se quiere imprimir en salida estandar.
 *****Entradas*************************************
 * r0: fLU01_contar_caracteres // cantidad de datos a imprimir
 *****Errores**************************************
 * ##:
 **************************************************/

fLU02_imprimir_mensaje:
	PUSH {r4, r7, lr}
	MOV r4, r0 //Guardamos en un registro seguro.
	BL fLU01_contar_caracteres //Calcular la cantidad de datos a salir.
	//
	MOV r2, r0 //Cantidad de caracteres a imprimir
	MOV r1, r4 //Devolvemos el puntero a r1 para imprimir.
	MOV r0, #1 //Salida estandar.
	//
	MOV r7, #4 //call system write.
	SVC #0 //int.

	POP {r4, r7, pc} // lr a pc para volver donde se llamo.

/*****Nombre***************************************
 * fLU03_imprimir_caracter
 *****Descripción**********************************
 * Imprime los caracteres enviados 
 *****Retorno**************************************
 * r0: es leido por call sys 4
 *****Entradas*************************************
 * r0:Recibira el valor del caracter que se quiere imprimir. 
 *****Errores**************************************
 * ##: NA 
 **************************************************/

//------------------------------------------------
// ->r0: Recibira el valor del caracter que se quiere imprimir.
fLU03_imprimir_caracter:
	PUSH {r1 - r7, lr}
	LDR r1, =caracter //Guardamos la direccion de memoria
	STRB r0, [r1, #0] //Insertamos el caracter en la direccion de memoria.

	MOV r0, #1 //Salida estandar.
	MOV r2, #1 //Solo un caracter.
	MOV r7, #4 //Call system write.
	SVC #0 //int.

	POP {r1 - r7, pc} //lr a pc para volver a donde se llamo.

/*****Nombre***************************************
 * fLU04_dividir
 *****Descripción**********************************
 * divide los dos registros entrantes
 *****Retorno**************************************
 * r0: cociente resultado de la division o el residuo entre r0/r1.
 *****Entradas*************************************
 * r0: dividendo.
 * r1: divisor
 *****Errores**************************************
 * ##: NA 
 **************************************************/

fLU04_dividir:
	PUSH {r4 - r6, lr}
	MOV r4, #0 // Contador.
	MOV r5, #0 //Acumulador.

fLU04_while: //ciclo division.
	MOV r6, r0 //Guardar el dividendo.
	SUB r6, r5 // Resta para comparar.
	CMP r6, r1 //Comparamos si es menor al divisor.
	BLT fLU04_end //Finaliza el proceso.
	ADD r4, #1 //Añade 1 mas al contador.
	ADD r5, r1 //Agregamos al acumulador el divisor.
	BAl fLU04_while

fLU04_end: //Finaliza la division.
	MOV r0, r4
	POP {r4 - r6, pc}

/*****Nombre***************************************
 * fLU05_generate
 *****Descripción**********************************
 * Genera un numero random
 *****Retorno**************************************
 * r0: retorna un numero random 
 *****Entradas*************************************
 * r0: 
 * r1: 
 *****Errores**************************************
 * ##:
 **************************************************/


fLU05_generate:
    push    { r1-r7, lr }
    ldr r0, =randomfile
    mov r1, #0
    mov r7, #5
    svc #0
    mov r4, r0
   
    mov r0, r4
    ldr r1, =randombyte
    mov r2, #1
    mov r7, #3
    svc #0
    mov r0, r4
    mov r7, #6
    svc #0
    ldr r0, =randombyte
    ldrb    r0, [r0]
    pop { r1-r7, pc }


/*****Nombre***************************************
 * fLU06_modulo
 *****Descripción**********************************
 * Modulo 
 *****Retorno**************************************
 * r0: cociente resultado de la division
 *****Entradas*************************************
 * r0: dividendo.
 * r1: divisor
 *****Errores**************************************
 * ##: NA 
 **************************************************/

fLU06_modulo:
	PUSH {r4 - r6, lr}
	MOV r4, #0 // Contador.
	MOV r5, #0 //Acumulador.

fLU06_while: //ciclo division.
	MOV r6, r0 //Guardar el dividendo.
	SUB r6, r5 // Resta para comparar.
	CMP r6, r1 //Comparamos si es menor al divisor.
	BLT fLU06_end //Finaliza el proceso.
	ADD r4, #1 //Añade 1 mas al contador.
	ADD r5, r1 //Agregamos al acumulador el divisor.
	BAl fLU06_while

fLU06_end: //Finaliza la division.
	MOV r0, r6
	POP {r4 - r6, pc}


/*****Nombre***************************************
 * PRINT
 *****Descripción**********************************
 * Printar mensaje con la etiqueta
 *****Retorno**************************************
 * r0:  Printa mensaje con la etiqueta
 *****Entradas*************************************
 * r2: size 
 * r1: etiqueta
 *****Errores**************************************
 * ##: NA 
 **************************************************/

.macro PRINT msg, size=1
	PUSH {R0, R1, R2}
  	MOV R0, #1
  	LDR R1, =\msg
  	MOV R2, #\size
  	MOV R7, #4
  	SVC #0
	POP {R0, R1, R2}

.endm
/*****Nombre***************************************
 * INPUT
 *****Descripción**********************************
 * Pedir datos con la etiqueta
 *****Retorno**************************************
 * r0: Pide datos en base a la etiqueta           
 *****Entradas*************************************
 * r2: Size 
 * r1: etiqueta 
 *****Errores**************************************
 * ##:
 **************************************************/


.macro INPUT text, size=1
	PUSH {R0, R1, R2}
  MOV r0, #0
  LDR r1, =\text
  MOV r2, #\size

  MOV r7, #3
  SVC #0
  POP {R0, R1, R2}
.endm



