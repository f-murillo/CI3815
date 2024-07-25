# Programa que convierte un número decimal positivo a binario usando 4 bytes (32 bits)
# El programa asume que el valor ingresado por el usuario es válido
.data
	mensaje_numero: .asciiz "Ingrese un número entero: "
	mensaje_binario: .asciiz "La representación en base 2 es: "
	salto: .asciiz "\n"
	representacion_binaria: .space 32  # Reserva espacio para 32 bits.

.text
	main:
    		li $v0, 4                  # Imprime mensaje para ingresar el número.
    		la $a0, mensaje_numero
    		syscall

    		li $v0, 5                  # Leer el número entero.
    		syscall
    		move $t0, $v0              # Mover el número a $t0.

    		# Inicializa un arreglo con 32 ceros.
    		la $a1, representacion_binaria
    		li $t3, 32                 # Contador para inicializar el arreglo.
    		
    		# Inicializar el arreglo de ceros	
		inicializar_array:
    			subi $t3, $t3, 1
    			sb $zero, 0($a1)
    			addiu $a1, $a1, 1
    			bnez $t3, inicializar_array

    		# Restablece $a1 al inicio del arreglo.
    		la $a1, representacion_binaria + 31

    		# Bucle para convertir el número a binario.
		convertir:
    			beqz $t0, imprime_binario    # Si el número es 0, salta a imprimir la representación binaria.
    			li $t1, 2                  # Establece el divisor (2).
    			div $t0, $t1               # Divide el número entre 2.
    			mfhi $t2                   # Mueve el residuo (0 o 1) a $t2.

    			# Almacena el bit en el arreglo.
    			sb $t2, 0($a1)             # Almacena el bit en el arreglo.
    			subi $a1, $a1, 1         # Mueve el puntero al siguiente espacio en el arreglo.

    			mflo $t0                   # Mueve el cociente de vuelta a $t0 para la próxima iteración.
    			j convertir            # Continúa el bucle.

		imprime_binario:
			# Imprime mensaje para la representación binaria.
    			li $v0, 4                  
    			la $a0, mensaje_binario
    			syscall

    			# Imprimir la representación binaria de 32 bits.
    			la $a1, representacion_binaria
    			li $t3, 32                 # Contador para imprimir el arreglo
    		
    		# Imprimir el arreglo	
		imprimir:
    			lb $a0, 0($a1)             # Cargar el bit del arreglo
    			addiu $a0, $a0, 48         # Convertit el bit a su representación ASCII
    			li $v0, 11                 # Imprimir el bit
    			syscall

    			addiu $a1, $a1, 1          # Mover el puntero al siguiente bit en el arreglo
    			subi $t3, $t3, 1
    			bnez $t3, imprimir      # Continuar el bucle si aún quedan bits por imprimir

			# Imprimir salto de linea
    			li $v0, 4                  
    			la $a0, salto
    			syscall
    		
		# Finalizar el programa
    		li $v0, 10                 
    		syscall