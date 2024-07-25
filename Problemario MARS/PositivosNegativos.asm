# Programa que cuenta la cantidad de números positivos y negativos de una lista dada por el usuario
# El programa asume que los valores ingresados por el usuario son válidos
.data
	mensaje_elementos: .asciiz "Ingrese el número de elementos: "
	mensaje_numero: .asciiz "Ingrese un número: "
	mensaje_positivos: .asciiz "Cantidad de números positivos: "
	mensaje_negativos: .asciiz "Cantidad de números negativos: "
	salto: .ascii "\n"

.text
	main:
		# Imprimir mensaje para ingresar número de elementos
    		li $v0, 4                  
    		la $a0, mensaje_elementos
    		syscall

		# Leer el número de elementos
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mover el número de elementos a $t0

    		li $t1, 0                  # Inicializar el contador de positivos en 0
    		li $t2, 0                  # Inicializar el contador de negativos en 0

		 # Bucle para leer y clasificar los números
		bucle:                        
    			beqz $t0, fin              # Si $t0 es 0, termina el bucle
    			
    			# Imprimir mensaje para ingresar número
    			li $v0, 4                  
    			la $a0, mensaje_numero
    			syscall

			# Leer el número ingresado
    			li $v0, 5                  
    			syscall
    			
    			bgtz $v0, inc_pos          # Si el número es positivo, incrementa contador positivo
    			bltz $v0, inc_neg          # Si el número es negativo, incrementa contador negativo

    			j continue                 # Salta a continuar si el número es cero

		inc_pos:
    			addi $t1, $t1, 1           # Incrementa el contador de positivos
    			j continue                 # Salta a continue

		inc_neg:
    			addi $t2, $t2, 1           # Incrementa el contador de negativos
    			j continue                 # Salta a continue

		continue:
    			subi $t0, $t0, 1           # Decrementar en uno el contador del bucle
    			j bucle                    # Volver al inicio del bucle

		fin:
    			# Imprimir cantidad de números positivos
    			li $v0, 4                  
    			la $a0, mensaje_positivos
    			syscall
    			# Resultado
    			li $v0, 1                  
   			move $a0, $t1              
    			syscall
    
    			# Imprimir salto de linea
    			li $v0, 4                  
    			la $a0, salto
    			syscall
    
    			# Imprimir cantidad de números negativos
    			li $v0, 4                  
    			la $a0, mensaje_negativos
    			syscall
    			# Resultado
    			li $v0, 1                  
    			move $a0, $t2              
    			syscall

    		# Finalizar el programa
    		li $v0, 10                 
    		syscall
