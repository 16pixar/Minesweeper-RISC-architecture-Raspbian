//MJ: Modos de juego.
//Author: Randall Corella, Johan Vargas, Aarón Piñar 
.data


.text

/*****Nombre***************************************
 * juego_facil
 *****Descripción**********************************
 * Se crea la matriz en función a la dificultad seleccionada
 * Se crea 2 matrices una para vizualisar y otra que llevara los procesos de editación más adelante 
 * se calcula de la siguiente manera:
 *     Facil = 9x9-->81
 *     10 minas 
 *****Retorno**************************************
 * r10: Almacena Matriz del printeo 
 * r9: Almacena Matriz original
 *****Entradas*************************************
 *  
 * 
 *****Errores**************************************
 * ##: NA
 **************************************************/
juego_facil:
  PUSH {R1-R8,LR}
  //Creamos la matriz 2 que va a ser la principal.
  MOV r1, #0
  MOV r2, #81
  BL fM01_crear_matriz
  //Colocamos las bombas.
  MOV   R1,   #10
  MOV   R2,   #9
  MOV   R3,   #9
  MOV   R5,   #9
  BL    f01_colocar_bombas
  //Colocamos los numeros.
  MOV     R9,   #81  //Valor de la casilla
  BL    f04_colocar_numeros
  //
  MOV r9, r4 //r9 > matriz original.
  //Printeamos la matriz.
  MOV r1, #81  //Valor de la casilla
  MOV r2, #9/*
  BL fM02_printar_matriz
  //salto de linea.
  LDR r0, =salto
  BL fLU02_imprimir_mensaje
  //Creamos la matriz de printeo.
  */
  MOV r1, #0
  MOV r2, #81  //Valor de la casilla
  BL fM01_crear_matriz
  MOV r10, r4 //r10 > matriz de printeo.



  POP {R1-R8,PC}


/*****Nombre***************************************
 * juego_medio
 *****Descripción**********************************
 * Se crea la matriz en función a la dificultad seleccionada
 * se crea 2 matrices una para vizualisar y otra que llevara por debajo los procesos de editación más adelante 
 * se calcula de la siguiente manera:
 *  Medio = 16x16-->256
 *  40 minas
 *****Retorno**************************************
 * 10: Almacena Matriz del printeo 
 * r9: Almacena Matriz original
 *****Entradas*************************************
 * 
 * 
 *****Errores**************************************
 * ##: NA
 **************************************************/
juego_medio:
  PUSH {LR}
  //Creamos la matriz 2 que va a ser la principal.
  MOV r1, #0
  MOV r2, #256
  BL fM01_crear_matriz

  //Colocamos las bombas.
  MOV   R1,   #40
  MOV   R2,   #16
  MOV   R3,   #16
  MOV   R5,   #16
  BL    f01_colocar_bombas
  //Colocamos los numeros.
  MOV     R9,   #256  //Valor de la casilla
  BL    f04_colocar_numeros

  MOV r9, r4 //r9 > matriz original.
  //Printamos la matriz.
  //creamos la primera matriz que sera la de printeo..
  MOV r1, #0
  MOV r2, #256  //Valor de la casilla
  BL fM01_crear_matriz
  MOV r10, r4 //r10 > matriz de printeo.

  POP {PC}

/*****Nombre***************************************
 * juego_dificil
 *****Descripción**********************************
 * Se crea la matriz en función a la dificultad seleccionada
 * se crea 2 matrices una para vizualisar y otra que llevara los procesos de editación más adelante 
 * se calcula de la siguiente manera:
 *   dificil = 16x30-->480
 *   99 minas
 *****Retorno**************************************
 * r10: Almacena Matriz del printeo 
 * r9: Almacena Matriz original
 *****Entradas*************************************
 * 
 * 
 *****Errores**************************************
 * ##: NA
 **************************************************/
juego_dificil:
  PUSH {LR}
  //Creamos la segunda.
  MOV r1, #0
  MOV r2, #480
  BL fM01_crear_matriz
  //Colocamos las bombas.
  MOV   R1,   #99
  MOV   R2,   #16
  MOV   R3,   #30
  MOV   R5,   #30
  BL    f01_colocar_bombas
  //Colocamos los numeros.
  MOV     R9,   #480  //Valor de la casilla
  BL    f04_colocar_numeros

  MOV r9, r4 //r9 > matriz original. //esta bien
  //
  /*
  MOV r1, #480
  MOV r2, #30
  BL fM02_printar_matriz
  //
  LDR r0, =salto
  BL fLU02_imprimir_mensaje
  */
  //Creamos la primera matriz.
  MOV r1, #0
  MOV r2, #480  //Valor de la casilla
  BL fM01_crear_matriz
  MOV r10, r4 //r10 > matriz de printeo.
  POP {PC}

/*****Nombre***************************************
 * juego_personalizada
 *****Descripción**********************************
 * Se crea la matriz en función a los datos recopilados atravez de los inputs
 * Fila * columnas = tamanno de la matriz 
 * 
 *****Retorno**************************************
 * r10: Almacena Matriz del printeo 
 * r9: Almacena Matriz original
 *****Entradas*************************************
 * R2:  
 * R8:
 *****Errores**************************************
 * ##: NA
 **************************************************/
juego_personalizada:
  PUSH {R0-R8, LR}
  //Creamos la segunda.
  MOV r1, #0
  MOV r2, R0
  MOV R8, R0
  BL fM01_crear_matriz
  //=========================================================================================
  MOV   R2,   R4
  //Colocamos las bombas.
  LDR   R4,   =cantBombas
  BL    convertir_entero_varios_digitos

  MOV   R1,   R0      // se mueve la cantidad de bombas en r1
  MOV   R4,   R2
  //=================== COLOCAR FILAS ======================================================
  LDR   R2,   =fil
  LDRB  R2,   [R2, #0]
  //=================== COLOCAR COLUMNA ====================================================
  LDR   R3,   =column
  LDRB  R3,   [R3, #0]
  MOV   R5,   R3
  //SUB R5, R2
  //=================== COLOCAMOS BOMBAS ===================================================
  MUL R9, R2, R3
  BL    f01_colocar_bombas
  //Colocamos los numeros.
  //

  MOV     R9,   R8
  BL    f04_colocar_numeros

  MOV r9, r4 //r9 > matriz original. //esta bien

  //Creamos la primera matriz.
  MOV r1, #0
  MOV r2, R8
  BL fM01_crear_matriz
  MOV r10, r4 //r10 > matriz de printeo.
  POP {R0-R8, PC}
