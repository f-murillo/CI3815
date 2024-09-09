# Funcion que calcula el factorial de un numero (menor o igual a 12) de manera iterativa
# El límite es 12 porque es el último número para el cual su factorial es menor a (2^31)-1, por lo que números más grandes darán resultados erróneos
# El programa asume que la entrada es válida (un entero positivo)
.data
	msg_numero: .asciiz "Ingresa un número entre 0 y 12: "
	msg_resultado1: .asciiz "El factorial de "
	msg_resultado2: .asciiz " es: "
	
.text 
	main:
		# Imprimir mensaje para ingresar el número
		li $v0, 4                  
    		la $a0, msg_numero
    		syscall
    		
    		# Leer el número 
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mover el número a $t0
    		
    		move $t2, $t0		    # Guardar número original para imprimirlo al final
    		
		li $t1 1		   # Inicializar respuesta en 1
	
		factIt:
			blt $t0, 1, fin   # Si $t0 es menor a 1, saltar a fin
			mul $t1, $t1, $t0 # Multiplicar $t1 con $t0
			subi $t0, $t0, 1  # Decrementar en 1 a $t0 
			j factIt
		fin: 
			# Imprimir primera parte de mensaje de resultado
			li $v0, 4
			la $a0, msg_resultado1
			syscall
			
			#Imprimir número original
			li $v0, 1
			move $a0, $t2
			syscall
			
			# Imprimir segunda parte de mensaje de resultado
			li $v0, 4
			la $a0, msg_resultado2
			syscall
			
			# Imprimir resultado
    			li $v0, 1                  
    			move $a0, $t1              
    			syscall	
    		
    		# Finalizar el programa
    		li $v0, 10                 
    		syscall 
