# Programa que realiza la suma de los primeros k números, con k un número ingresado por el usuario
# El programa asume que el k ingresado es válido
.data
	mensaje_numero: .asciiz "Ingresa un número k: "
	mensaje_resultado: .asciiz "La suma de los primeros k números es "
	
.text
	main:
		# Imprime mensaje para ingresar k
    		li $v0, 4                  
    		la $a0, mensaje_numero
    		syscall

		 # Leer k
    		li $v0, 5                 
    		syscall
    		move $t0, $v0              # Mover el valor de k a $t0

    		addi $t1, $t0, 1           # Calcular k+1 y almacenarlo en $t1
    		mul $t2, $t0, $t1          # Multiplicar k * (k+1) y almacenarlo en $t2

    		li $t3, 2                  # Cargar el divisor (2) en $t3
    		div $t2, $t3               # Divide $t2 (k * (k+1)) entre $t3 (2)
    		mflo $t4                   # Mueve el resultado (cociente) a $t4

		# Imprime mensaje del resultado
    		li $v0, 4                  
    		la $a0, mensaje_resultado
    		syscall
    		# Resultado
    		li $v0, 1                  
    		move $a0, $t4
    		syscall

		# Finalizar el programa
    		li $v0, 10                
    		syscall	
