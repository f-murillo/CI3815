# Programa que pide al usuario ingresar 15 enteros, los almacena en un vector y luego buasca un número dado en dicho vector, 
# y devuelve su posición. Si el número a buscar tiene duplicados, devuelve la posición del último duplicado.
# El programa asume que los valores ingresados son válidos (15 enteros)
.data 
	vector: .space 60 # Reservar espacio para los 15 enteros (4 bytes cada uno)
	mensaje_input: .asciiz "Introduce un numero: "
	mensaje_buscar: .asciiz "Introduce el numero a buscar: "
	mensaje_encontrado: .asciiz "Numero encontrado en la posicion: "
	mensaje_no_encontrado: .asciiz "Numero no encontrado. "
	mensaje_iteraciones: .asciiz "Numero de iteraciones: "
	t_encontrado: .word 0
	salto: .asciiz "\n"
.text
	main:
    		# Leer los 15 números del vector
    		li $t0, 0 # Contador para el bucle
    		li $t1, 15 # Total de elementos
    		lw $t7, t_encontrado  # Tiempo en que fue encontrado el número
    		la $t2, vector # Dirección base del vector

		bucle_lectura:
    			li $v0, 4 # syscall para imprimir string
    			la $a0, mensaje_input
    			syscall

    			li $v0, 5 # syscall para leer un entero
    			syscall

    			sw $v0, 0($t2) # Guarda el entero leído en el vector
    			addiu $t2, $t2, 4 # Avanza al siguiente espacio en el vector
    			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_lectura # Repite hasta tener 15 números

    		# Imprimir mensaje para ingresar número a buscar
    		li $v0, 4
    		la $a0, mensaje_buscar
    		syscall
		# Leer número a buscar
    		li $v0, 5
    		syscall
    		move $t3, $v0 # Guarda el número a buscar en $t3

    		# Buscar el número en el vector
    		li $t0, 0 # Reinicia el contador
    		la $t2, vector # Reinicia la dirección base del vector
    		li $t4, -1 # Inicializa la posición del último encontrado como -1
    		li $t5, 0 # Contador de iteraciones

		bucle_busqueda:
    			lw $t6, 0($t2) # Cargar el valor actual del vector
    			addiu $t5, $t5, 1 # Incrementar el contador de iteraciones
    			beq $t6, $t3, encontrado # Si se encuentra el número, salta a encontrado
    			addiu $t2, $t2, 4 # Avanza al siguiente entero en el vector
   			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_busqueda # Repite hasta el final del vector

    			beq $t4, -1, no_encontrado   # Si la posición sigue siendo -1, el número no se encuentra
    
    			j fin_bucle  # Salir del bucle

		no_encontrado:
			# Imprimir mensaje de que no se encontró el número, y saltar al fin del programa
    			li $v0, 4
    			la $a0, mensaje_no_encontrado
    			syscall
    
    			j fin_programa

		encontrado:
    			move $t4, $t0 # Actualiza la posición del último encontrado
			move $t7, $t5 # Establecer como tiempo de encontrado la iteracion actual
    			# Continúa buscando en caso de duplicados
    			addiu $t2, $t2, 4
    			addiu $t0, $t0, 1
    			blt $t0, $t1, bucle_busqueda

		fin_bucle:
   			 # Imprimir mensaje de número encontrado
    			li $v0, 4
    			la $a0, mensaje_encontrado
    			syscall

    			# Imprimir posicion
    			li $v0, 1
    			move $a0, $t4
    			syscall

    			# Imprimir la posición del último número encontrado
    			li $v0, 4
    			la $a0, salto
    			syscall

    			# Imprimir mensaje de número de iteraciones
    			li $v0, 4
    			la $a0, mensaje_iteraciones
    			syscall
    			
			# Imprimir número de iteraciones
    			li $v0, 1
    			move $a0, $t7
    			syscall

		fin_programa:
    			# Salir del programa
    			li $v0, 10
    			syscall
