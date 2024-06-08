//LMM: Libreria manipulacion matriz.
//autor: Randall Corella Castillo.
//Segmento de datos.
.include  "LU.s" @Importacion
//Segmento de codigo.
.text

/*****Nombre***************************************
 * fM01_crear_matriz
 *****Descripción**********************************
 * Crear Matriz, recibe un valor entero y lo almacena en la matriz.
 *****Retorno**************************************
 * r4: retorna el puntero que señala al primer elemento de la secuencia se bytes.
 *****Entradas*************************************
 * r2: la cantidad de datos que deseamos guardar
 * r1: el dato a ingresar.
 *****Errores**************************************
 * ##: NA 
 **************************************************/

fM01_crear_matriz:
  PUSH {R1-R3, R5-R7, lr}
  //Obtenemos la posicion actual del final del segmento de datos.
  MOV   r0, #0 //Aqui se ingresa el valor 0 para obtener la direccion del final de la memoria.
  MOV   r7, #45 //System call BRK.
  SVC   #0      //Interrupcion del sistema.
  //Guardamos la posicion de la secuencia de bytes.
  MOV   r4, r0 //Movemos a r4 el puntero que señala la posicion inicial de la matriz.
  MOV   r3, #0 //Inicializamos el contador.

//Funcion de iteracion para crear la matriz.
fM01_while01:
  CMP r2, r3 //comparamos el contador con la cantidad de datos a ingresar.
  BEQ fM01_while01_end //Saltamos al final.

  MOV   r0, #0 //Aqui se ingresa el valor 0 para obtener la direccion del final de la memoria.
  MOV   r7, #45 //System call BRK.
  SVC #0 //Interrupcion.

  ADD r0, #1 //Agregamos 1 a la direccion de memoria actual para pedir mas espacios en memoria.
  MOV r7, #45 // Systema call BRK.
  SVC #0 //Interrupcion y incrementa la memoria del segmento de datos.

  //
  STRB  r1, [r4, r3] //Insertamos en r4 posicion r5, el dato ingresado.
  ADD   r3, #1 //Agregamos 1 al contador de datos.
  B fM01_while01 //Llamada iterativa.

//Funcion de finalizacion de creacion de la matriz.
fM01_while01_end:
  //Importante r0 recibe el puntero que señala a la secuencia de bytes que creamos para alamcenar los valores de la matriz.
  //Este puntero debe estar obligatoriamente en un registro.
  //MOV r0, r4
  //Pruebas de funcionalidad.
  //
  POP {R1-R3, R5-R7, pc}

/*****Nombre***************************************
 * fM02_printar_matriz
 *****Descripción**********************************
 * Printar matriz,  Se encarga de printar la matriz
 *****Retorno**************************************
 * r0: 
 *****Entradas*************************************
 * r1: Recibe la cantidad de datos que debemos printar 
 * r2: Recibe el tamaño de la fila.
 * r4: recibe el puntero que vamos a recorrer. 
 *****Errores**************************************
 * ##:
 **************************************************/
fM02_printar_matriz:
  PUSH {r5 - r7, lr} 
  MOV r3, #0
  MOV r5, #0
  MOV r6, #1
  BL printar_numero
  //ADD R3, #1
  MOV R5, R2
//Iteracion para printar la matriz.
fM02_while02:
  CMP r1, r3
  BEQ fM02_while_end

  BL printar_vertical

  CMP r5, r2
  BEQ fM02_imprimir_salto
  //
  LDRB r0,  [r4,r3]
  CMP R0, #0
  BEQ printar_casilla
  CMP R0, #9
  BEQ Printar_descubierto
  ADD r0, #48
  //LDR  r8, =rojo
  //STRB R0, [R8, #12]
  PRINT rojo 11
  BL fLU03_imprimir_caracter
  PRINT end_rojo 5

  ADD r3, #1
  ADD r5, #1
  PRINT espace
  B fM02_while02

Printar_descubierto:
  PRINT descubierto 17
  ADD r3, #1
  ADD r5, #1
  B fM02_while02
//Finaliza el programa.
printar_casilla:
  PRINT casilla 3
  ADD r3, #1
  ADD r5, #1
  B fM02_while02

//======================
printar_vertical:
  PUSH {LR}
  CMP r5, r2
  BNE end_printar_vertical

  MOV R0, #0xa
  BL fLU03_imprimir_caracter
  ADD R3, #1
  CMP R6, #10
  MOVEQ R6, #0
  //
  SUB R3, #1
  MOV R0, R6
  ADD R0, #48
  BL fLU03_imprimir_caracter
  PRINT espace
  PRINT espace

  ADD R6, #1
  MOV r5, #0

end_printar_vertical:

  POP {PC}

printar_numero:
  PUSH {LR}
  PRINT espace
  PRINT espace
  PRINT espace
  MOV R3, #1
printar_numero_while:
  CMP R5, R2
  BEQ end_printar

  CMP R3, #10
  MOVEQ R3, #0

  MOV R0, R3
  ADD R0, #48
  BL fLU03_imprimir_caracter
  ADD R3, #1
  ADD R5, #1
  PRINT espace
  B printar_numero_while

end_printar:
  MOV R3, #0
  MOV R5, #0
  PRINT salto
  //PRINT salto
  POP {PC}
//===========================
fM02_while_end:
  POP {r5 - r7, pc}

/*****Nombre***************************************
 * fM02_imprimir_salto
 *****Descripción**********************************
 * Imprime el salto de linea
 *****Retorno**************************************
 * r0: salto de linea
 *****Entradas*************************************
 * r0: 
 *****Errores**************************************
 * ##: NA
 **************************************************/

fM02_imprimir_salto:
  PUSH {r0}
  MOV r0, #10
  BL fLU03_imprimir_caracter
  MOV r5, #0
  POP {r0}
  B fM02_while02

/*****Nombre***************************************
 * fM03_revelar_casillas
 *****Descripción**********************************
 * revela las casillas alrededor de la que se envio
 *****Retorno**************************************
 * r0: Casillas reveladas
 *****Entradas*************************************
 * R3: columna
 * R4: La matriz de busqueda
 * R5: La matriz de printeo.
 * R6: La posicion que indico el usuario.
 * R2: cantidad maxima
 *****Errores**************************************
 * ##: NA
 **************************************************/
fM03_revelar_casillas:
  PUSH {R6, R8 ,lr}
  //============================Good
  LDRB R1, [R4, R6]
  //Comparamos la casilla que eligio.
  CMP R1, #6
  BEQ fM03_end
  //verificamos lo que hay en la matriz en esa posicion
  LDRB R0, [R5, R6]
  CMP R0, #0 //CMP para saber si ya esta revelada.
  BGT fM03_end
  MOV R0, R1 //guardamos el valor de la casilla.
  CMP R1, #0
  MOVEQ R0, #9
  STRB R0, [R5, R6]
  CMP R1, #0 //CMP con 0 para saber si hacer la recursion.
  BEQ fM03_while_revelar
  B fM03_end
  //=========================================================
  //Si no es un 0, solo la revelamos a ella.
fM03_revelar_casilla:

  STRB R1, [R5, R6]
  BGE fM03_end


fM03_while_revelar:
  //Derecha===
  BL fM03_revelar_m_d
  //Izquierda===
  BL fM03_revelar_m_i
  //Abajo medio===
  BL fM03_revelar_up_m
  //Abajo derecha===
  BL fM03_revelar_up_d
  //Abajo izquierda===
  BL fM03_revelar_up_i
  
  //Arriba medio
  BL fM03_revelar_down_m
  //Arriba derecha
  BL fM03_revelar_down_m_d
  //Arriba izquierda
  BL fM03_revelar_down_m_i

  B fM03_end

//medio derecha=========================
fM03_revelar_m_d:
  PUSH {R6, R8, lr}
  ADD R6, #1
  CMP R6, R2
  BGE fM03_revelar_m_d_end
  ADD R8, #1
  CMP R8, R3
  BGE fM03_revelar_m_d_end
  BL fM03_revelar_casillas
fM03_revelar_m_d_end:
  POP {R6, R8, pc}

//medio izquierda=========================
fM03_revelar_m_i:
  PUSH {R6, R8, lr}
  SUB R6, #1
  CMP R6, R7
  BLT fM03_revelar_m_i_end
  SUB R8, #1
  CMP R8, #-1
  BLE fM03_revelar_m_i_end
  //
  BL fM03_revelar_casillas//
fM03_revelar_m_i_end:
  POP {R6, R8, pc}

//Abajo en el medio==================================
fM03_revelar_up_m:
  PUSH {R6,lr}
  ADD R6, R3
  CMP R6, R2
  BGE fM03_revelar_up_m_end
  BL fM03_revelar_casillas
fM03_revelar_up_m_end:
  POP {R6,pc}

//Abajo a la derecha================================
fM03_revelar_up_d:
  PUSH {R6, R8, lr}
  ADD R6, R3
  ADD R6, #1
  CMP R6, R2//Comparamos la fila maxima.
  BGE fM03_revelar_up_d_end //
  //
  ADD R8, #1
  CMP R8, R3
  BGE fM03_revelar_up_d_end
  BL fM03_revelar_casillas
fM03_revelar_up_d_end:
  POP {R6, R8, pc}

//Abajo a la izquierda===================================
fM03_revelar_up_i:
  PUSH {R6, R8, lr}
  ADD R6, R3
  SUB R6, #1
  CMP R6, R2//Comparamos la fila maxima.
  BGE fM03_revelar_up_d_end //
  //
  SUB R8, #1
  CMP R8, #-1
  BLE fM03_revelar_up_i_end
  BL fM03_revelar_casillas

fM03_revelar_up_i_end:
  POP {R6, R8, pc}

//Arriba medio===================================================================================================
fM03_revelar_down_m:
  PUSH {R6-R8, lr}
  SUB R7, R3
  SUB R6, R3
  CMP R6, #-1
  BLE fM03_revelar_down_m_end
  //
  BL fM03_revelar_casillas
//  
fM03_revelar_down_m_end:
  POP {R6-R8, pc} 

//Arriba derecha======================================
fM03_revelar_down_m_d:
  PUSH {R6-R8, lr}
  SUB R6, R3
  CMP R6, #0
  BLT fM03_revelar_down_m_d_end
  SUB R7, R3
  ADD R6, #1
  ADD R8, #1
  CMP R8, R3
  BGE fM03_revelar_down_m_d_end
  BL fM03_revelar_casillas
fM03_revelar_down_m_d_end:
  POP {R6-R8, pc} 

//Arriba Izquierda======================================
fM03_revelar_down_m_i:
  PUSH {R6-R8, lr}
  SUB R6, R3
  CMP R6, #0
  BLE fM03_revelar_down_m_i_end
  SUB R7, R3
  SUB R6, #1
  SUB R8, #1
  CMP R8, #-1
  BLE fM03_revelar_down_m_i_end
  BL fM03_revelar_casillas
fM03_revelar_down_m_i_end:
  POP {R6-R8, pc} 

//=============================================
fM03_end:
  POP {R6, R8, pc}



