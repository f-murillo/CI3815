# Programa que pide al usuario ingresar 15 enteros, los almacena en un vector y luego buasca un n�mero dado en dicho vector, 
# y devuelve su posici�n. Si el n�mero a buscar tiene duplicados, devuelve la posici�n del �ltimo duplicado.
# El programa asume que los valores ingresados son v�lidos
.data
	vector: .space 60 # Reserva espacio para 15 enteros (4 bytes cada uno)
	mensaje_input: .asciiz "Introduce un numero: "
	mensaje_buscar: .asciiz "Introduce el numero a buscar: "
	mensaje_encontrado: .asciiz "Numero encontrado en la posicion: "
	mensaje_no_encontrado: .asciiz "Numero no encontrado. "
	mensaje_iteraciones: .asciiz "Numero de iteraciones: "
	t_encontrado: .word 0
	salto: .asciiz "\n"
.text
	main:
    		# Leer los 15 n�meros del vector
    		li $t0, 0 # Contador para el bucle
    		li $t1, 15 # Total de elementos
    		lw $t7, t_encontrado  # Tiempo en que fue encontrado el n�mero
    		la $t2, vector # Direcci�n base del vector

		bucle_lectura:
    			li $v0, 4 # syscall para imprimir string
    			la $a0, mensaje_input
    			syscall

    			li $v0, 5 # syscall para leer un entero
    			syscall

    			sw $v0, 0($t2) # Guarda el entero le�do en el vector
    			addiu $t2, $t2, 4 # Avanza al siguiente espacio en el vector
    			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_lectura # Repite hasta tener 15 n�meros

    		# Imprimir mensaje para ingresar n�mero a buscar
    		li $v0, 4
    		la $a0, mensaje_buscar
    		syscall
		# Leer n�mero a buscar
    		li $v0, 5
    		syscall
    		move $t3, $v0 # Guarda el n�mero a buscar en $t3

    		# Buscar el n�mero en el vector
    		li $t0, 0 # Reinicia el contador
    		la $t2, vector # Reinicia la direcci�n base del vector
    		li $t4, -1 # Inicializa la posici�n del �ltimo encontrado como -1
    		li $t5, 0 # Contador de iteraciones

		bucle_busqueda:
    			lw $t6, 0($t2) # Cargar el valor actual del vector
    			addiu $t5, $t5, 1 # Incrementar el contador de iteraciones
    			beq $t6, $t3, encontrado # Si se encuentra el n�mero, salta a encontrado
    			addiu $t2, $t2, 4 # Avanza al siguiente entero en el vector
   			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_busqueda # Repite hasta el final del vector

    			beq $t4, -1, no_encontrado   # Si la posici�n sigue siendo -1, el n�mero no se encuentra
    
    			j fin_bucle  # Salir del bucle

		no_encontrado:
			# Imprimir mensaje de que no se encontr� el n�mero, y saltar al fin del programa
    			li $v0, 4
    			la $a0, mensaje_no_encontrado
    			syscall
    
    			j fin_programa

		encontrado:
    			move $t4, $t0 # Actualiza la posici�n del �ltimo encontrado
			move $t7, $t5 # Establecer como tiempo de encontrado la iteracion actual
    			# Contin�a buscando en caso de duplicados
    			addiu $t2, $t2, 4
    			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_busqueda

		fin_bucle:
   			 # Imprimir mensaje de n�mero encontrado
    			li $v0, 4
    			la $a0, mensaje_encontrado
    			syscall

    			# Imprimir posicion
    			li $v0, 1
    			move $a0, $t4
    			syscall

    			# Imprimir la posici�n del �ltimo n�mero encontrado
    			li $v0, 4
    			la $a0, salto
    			syscall

    			# Imprimir mensaje de n�mero de iteraciones
    			li $v0, 4
    			la $a0, mensaje_iteraciones
    			syscall
    			
			# Imprimir n�mero de iteraciones
    			li $v0, 1
    			move $a0, $t7
    			syscall

		fin_programa:
    			# Salir del programa
    			li $v0, 10
    			syscall
