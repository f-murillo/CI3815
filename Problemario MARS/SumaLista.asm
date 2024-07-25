# Programa que suma los elementos de una lista dada por el usuario
# El programa asume que los elementos ingresados son v�lidos
.data
	mensaje_elementos: .asciiz "Ingrese el n�mero de elementos a sumar: "
	mensaje_numero: .asciiz "Ingrese un n�mero: "
	
.text
	main:
		# Imprimr mensaje para ingresar n�mero de elementos
    		li $v0, 4                  
    		la $a0, mensaje_elementos
    		syscall

		# Lee el n�mero de elementos
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mueve el n�mero de elementos a $t0

    		li $t1, 0                  # Inicializa la suma total a 0

		# Bucle para leer y sumar los n�meros
		suma:                    
    			beqz $t0, fin        	    # Si $t0 es 0, termina el bucle.
    			li $v0, 4                  # Imprimir el mensaje para ingresar n�mero.
    			la $a0, mensaje_numero
    			syscall

    			li $v0, 5                  # Leer el n�mero ingresado.
    			syscall
    			add $t1, $t1, $v0          # Sumar el n�mero ingresado a $t1

    			subi $t0, $t0, 1           # Decrementar en uno el contador
    			
    			j suma                     # Volver al inicio del bucle

		fin:
			# Imprimir resultado
    			li $v0, 1                  
    			move $a0, $t1              
    			syscall

		# Finalizar el programa
    		li $v0, 10                 
    		syscall
