# Programa que multiplica dos números enteros ingresados por el usuario usando el algoritmo de sumas sucesivas
# El programa asume que los valores ingresados son válidos
.data
	mensaje_numero1: .asciiz "Ingresa el primer número: "
	mensaje_numero2: .asciiz "Ingresa el segundo número: "
	mensaje_resultado: .asciiz "El resultado de la multiplicación es: "

.text
	main:
		# Imprimir mensaje para ingresar el primer número
		li $v0, 4                  
    		la $a0, mensaje_numero1
    		syscall

		# Leer el primer número 
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mover el número a $t0.
    		
    		# Imprimir mensaje para ingresar el segundo número
    		li $v0, 4                  
    		la $a0, mensaje_numero2
    		syscall

		# Leer el segundo número
    		li $v0, 5                  
    		syscall
    		move $t1, $v0              # Mover el número a $t1.

    		li $t2, 0                  # Inicializar la suma a 0
    		
    		bltz $t0, suma_sucesiva_neg1	# Si el primer número es negativo
    		bltz $t1, suma_sucesiva_neg2	# Si el primero no es negativo pero el segundo si lo es
    		
    		# Si el primer número es negativo
    		suma_sucesiva_neg1:
    			bltz $t1, pre_suma_sucesiva_pos   # Si ambos números son negativos, ir a subrutina que los transforma a positivos
    			
    			# Efectuar multiplicación por sumas sucesivas (con primer número negativo)
    			beqz $t1, fin      # Si el segundo número es cero, termina el bucle
    			add $t2, $t2, $t0  # Sumar el primer número 
    			sub $t1, $t1, 1    # RDecrementar el segundo número
    			j suma_sucesiva_neg1
    				
    		suma_sucesiva_neg2:
    			# Si se llegó a esta subrutina, solo el segundo número es negativo
    			# Efectuar multiplicación por sumas sucesivas (con segundo número negativo)
    			beqz $t0, fin  	    # Si el primer número es cero, termina el bucle
    			add $t2, $t2, $t1  # Sumar el segundo número 
    			sub $t0, $t0, 1    # Decrementar el primer número
    			j suma_sucesiva_neg2	
    			
    		pre_suma_sucesiva_pos:
    			# Si se llegó a esta subrutina, ambos números son negativos
    			# Multiplicar ambos números por -1, y saltar a la multiplicación por sumas sucesivas positiva
    			mul $t0, $t0, -1
    			mul $t1, $t1, -1
    			j suma_sucesiva_pos
    				
    		suma_sucesiva_pos:
    			# Si se llegó a esta subrutina, ambos números son positivos
    			beqz $t0, fin 	    # Si el primer número es cero, termina el bucle
    			add $t2, $t2, $t1  # Sumar el segundo número
    			subi $t0, $t0, 1   # Decrementar el primer número
    			j suma_sucesiva_pos    
    	
    		fin:
    			# Imprime mensaje del resultado
    			li $v0, 4                  
    			la $a0, mensaje_resultado
    			syscall
    			# Imprimir resultado
    			li $v0, 1                  
    			move $a0, $t2              
    			syscall
    			
		# Finalizar el programa
    		li $v0, 10                 
    		syscall    			
	
