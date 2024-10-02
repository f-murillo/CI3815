# Programa que resuelve el reto fizzbuzz para los primeros n números, donde el número n es ingresado por el usuario
# El programa asume que el valor ingresado por el usuario es válido
# Esta versión es más eficiente en tiempo de ejecución que la versión 1, pero hace más uso de memoria
.data
	mensaje_numero: .asciiz "Ingresa un número: "
	fizz: .asciiz "fizz\n"
	buzz: .asciiz "buzz\n"
	fizzbuzz: .asciiz "fizzbuzz\n"
	salto: .asciiz "\n"

.text
	main:
    		# Imprimir mensaje para ingresar número
    		li $v0, 4                  
    		la $a0, mensaje_numero
    		syscall

    		# Leer el número
    		li $v0, 5       
    		syscall
    		move $t0, $v0   
	
    		li $t1, 1 # Inicializar iterador en 1

		# Bucle que resuelve el reto fizzbuzz
		bucle:
    			ble $t1, $t0, check # Mientras que iterador <= n, chequea
    			j fin

		check:
    			# Verificar si el número es divisible entre 3, 5 y 15
    			# División entre 3
    			li $t2, 3
    			div $t1, $t2
    			mfhi $t4     # Residuo de la división
    
   			# División entre 5
    			li $t3, 5
    			div $t1, $t3
    			mfhi $t5    # Rediduo de la división
    			
    			# División entre 15
    			li $t6, 15
    			div $t1, $t6
    			mfhi $t7    # Rediduo de la división
    			
    			beqz $t7, imprimir_fizzbuzz # Recordar que si c es divisible por a y por b, entonces c es divisible por a*b
   	 		beqz $t4, imprimir_fizz  # Si el residuo de la división entre 3 es 0
   	 		                         
    			beqz $t5, imprimir_buzz  # Si la condición anterior no se cumple, pero si el residuo de la división entre 5 es 0,
						 # es divisible entre 5. Imprimir buzz
    			 	                 
    			j imprimir_numero    # Si no si cumplen las condiciones anteriores, entones el número no es divisible entre 3, 5 ni 15. 
    					     # Imprimir el número

		# Imprimir fizz
		imprimir_fizz:
    			li $v0, 4
    			la $a0, fizz
    			syscall
    			j continue

		# Imprimir buzz
		imprimir_buzz:
    			li $v0, 4
    			la $a0, buzz
    			syscall
    			j continue

		# Imprimir fizzbuzz
		imprimir_fizzbuzz:
    			li $v0, 4
    			la $a0, fizzbuzz
    			syscall
    			j continue

		# Imprimir el número
		imprimir_numero:
    			li $v0, 1
    			move $a0, $t1
    			syscall
    			
    			# Imprimir salto de línea
    			li $v0, 4
    			la $a0, salto
    			syscall
    			j continue

		continue:
    			addi $t1, $t1, 1 # Incrementar iterador
    			j bucle 	  # Volver al bucle

		fin:
    			# Finalizar el programa
    			li $v0, 10                 
    			syscall
