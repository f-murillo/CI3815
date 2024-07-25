# Programa que multiplica dos n�meros enteros ingresados por el usuario usando el algoritmo de sumas sucesivas
# El programa asume que los valores ingresados son v�lidos
.data
	mensaje_numero1: .asciiz "Ingresa el primer n�mero: "
	mensaje_numero2: .asciiz "Ingresa el segundo n�mero: "
	mensaje_resultado: .asciiz "El resultado de la multiplicaci�n es: "

.text
	main:
		# Imprimir mensaje para ingresar el primer n�mero
		li $v0, 4                  
    		la $a0, mensaje_numero1
    		syscall

		# Leer el primer n�mero 
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mover el n�mero a $t0.
    		
    		# Imprimir mensaje para ingresar el segundo n�mero
    		li $v0, 4                  
    		la $a0, mensaje_numero2
    		syscall

		# Leer el segundo n�mero
    		li $v0, 5                  
    		syscall
    		move $t1, $v0              # Mover el n�mero a $t1.

    		li $t2, 0                  # Inicializar la suma a 0
    		
    		bltz $t0, suma_sucesiva_neg1	# Si el primer n�mero es negativo
    		bltz $t1, suma_sucesiva_neg2	# Si el primero no es negativo pero el segundo si lo es
    		
    		# Si el primer n�mero es negativo
    		suma_sucesiva_neg1:
    			bltz $t1, pre_suma_sucesiva_pos   # Si ambos n�meros son negativos, ir a subrutina que los transforma a positivos
    			
    			# Efectuar multiplicaci�n por sumas sucesivas (con primer n�mero negativo)
    			beqz $t1, fin      # Si el segundo n�mero es cero, termina el bucle
    			add $t2, $t2, $t0  # Sumar el primer n�mero 
    			sub $t1, $t1, 1    # RDecrementar el segundo n�mero
    			j suma_sucesiva_neg1
    				
    		suma_sucesiva_neg2:
    			# Si se lleg� a esta subrutina, solo el segundo n�mero es negativo
    			# Efectuar multiplicaci�n por sumas sucesivas (con segundo n�mero negativo)
    			beqz $t0, fin  	    # Si el primer n�mero es cero, termina el bucle
    			add $t2, $t2, $t1  # Sumar el segundo n�mero 
    			sub $t0, $t0, 1    # Decrementar el primer n�mero
    			j suma_sucesiva_neg2	
    			
    		pre_suma_sucesiva_pos:
    			# Si se lleg� a esta subrutina, ambos n�meros son negativos
    			# Multiplicar ambos n�meros por -1, y saltar a la multiplicaci�n por sumas sucesivas positiva
    			mul $t0, $t0, -1
    			mul $t1, $t1, -1
    			j suma_sucesiva_pos
    				
    		suma_sucesiva_pos:
    			# Si se lleg� a esta subrutina, ambos n�meros son positivos
    			beqz $t0, fin 	    # Si el primer n�mero es cero, termina el bucle
    			add $t2, $t2, $t1  # Sumar el segundo n�mero
    			subi $t0, $t0, 1   # Decrementar el primer n�mero
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
	
