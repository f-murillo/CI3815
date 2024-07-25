# Programa que cuenta la cantidad de n�meros positivos y negativos de una lista dada por el usuario
# El programa asume que los valores ingresados por el usuario son v�lidos
.data
	mensaje_elementos: .asciiz "Ingrese el n�mero de elementos: "
	mensaje_numero: .asciiz "Ingrese un n�mero: "
	mensaje_positivos: .asciiz "Cantidad de n�meros positivos: "
	mensaje_negativos: .asciiz "Cantidad de n�meros negativos: "
	salto: .ascii "\n"

.text
	main:
		# Imprimir mensaje para ingresar n�mero de elementos
    		li $v0, 4                  
    		la $a0, mensaje_elementos
    		syscall

		# Leer el n�mero de elementos
    		li $v0, 5                  
    		syscall
    		move $t0, $v0              # Mover el n�mero de elementos a $t0

    		li $t1, 0                  # Inicializar el contador de positivos en 0
    		li $t2, 0                  # Inicializar el contador de negativos en 0

		 # Bucle para leer y clasificar los n�meros
		bucle:                        
    			beqz $t0, fin              # Si $t0 es 0, termina el bucle
    			
    			# Imprimir mensaje para ingresar n�mero
    			li $v0, 4                  
    			la $a0, mensaje_numero
    			syscall

			# Leer el n�mero ingresado
    			li $v0, 5                  
    			syscall
    			
    			bgtz $v0, inc_pos          # Si el n�mero es positivo, incrementa contador positivo
    			bltz $v0, inc_neg          # Si el n�mero es negativo, incrementa contador negativo

    			j continue                 # Salta a continuar si el n�mero es cero

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
    			# Imprimir cantidad de n�meros positivos
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
    
    			# Imprimir cantidad de n�meros negativos
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
