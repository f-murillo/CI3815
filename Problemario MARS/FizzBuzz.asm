# Programa que resuelve el reto fizzbuzz para los primeros n n�meros, donde el n�mero n es ingresado por el usuario
# El programa asume que el valor ingresado por el usuario es v�lido
.data
	mensaje_numero: .asciiz "Ingresa un n�mero: "
	fizz: .asciiz "fizz\n"
	buzz: .asciiz "buzz\n"
	fizzbuzz: .asciiz "fizzbuzz\n"
	salto: .asciiz "\n"

.text
	main:
    		# Imprimir mensaje para ingresar n�mero
    		li $v0, 4                  
    		la $a0, mensaje_numero
    		syscall

    		# Leer el n�mero
    		li $v0, 5       
    		syscall
    		move $t0, $v0   
	
    		li $t1, 1 # Inicializar iterador en 1

		# Bucle que resuelve el reto fizzbuzz
		bucle:
    			ble $t1, $t0, check # Mientras que iterador <= n, chequea
    			j fin

		check:
    			# Verificar si el n�mero es divisible entre 3 y 5
    			# Divisi�n entre 3
    			li $t2, 3
    			div $t1, $t2
    			mfhi $t4     # Residuo de la divisi�n
    
   			# Divisi�n entre 5
    			li $t3, 5
    			div $t1, $t3
    			mfhi $t5    # Rediduo de la divisi�n
    
   	 		beqz $t4, check_fizzbuzz  # Si el residuo de la divisi�n entre 3 es 0, es divisible entre 3. Ir a check_fizzbuzz a ver si 
   	 		                          # tambi�n es divisible entre 5
   	 		                         
    			beqz $t5, imprimir_buzz  # Si la condici�n anterior no se cumple, el n�mero no es divisible entre 3; pero si el residuo
    			 	                 # de la divisi�n entre 5 es 0, es divisible entre 5. Imprimir buzz
    			 	                 
    			j imprimir_numero    # Si no si cumplen las condiciones anteriores, entones el n�mero no es divisible entre 3 ni 5. 
    					     # Imprimir el n�mero

		# Verificar si el n�mero es divisible entre 3 y 5
		# Recordar que solo se accede a esta subrutina si el n�mero es divisible entre 3
		check_fizzbuzz:
    			beqz $t5, imprimir_fizzbuzz # Si el residuo de divisi�n entre 5 es 0, es divisible entre 5. Como tambi�n es divisible
    						     # entre 3, imprime fizzbuzz
    						
    			j imprimir_fizz # Si la condici�n anterior no se cumple, solo es divisible entre 3; imprimir fizz

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

		# Imprimir el n�mero
		imprimir_numero:
    			li $v0, 1
    			move $a0, $t1
    			syscall
    			
    			# Imprimir salto de l�nea
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
