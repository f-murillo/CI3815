.include "melodies.asm"
.include "macros.asm"
.data
	M: .asciiz "M"
	msg_mel: .asciiz "Espacio disponible: "
	msg_error_dur: .asciiz "Duracion invalida\n"
	msg_max_note: .asciiz "Numero maximo de notas alcanzado\n"
	# Arreglo de 8 posiciones
	heads_array: .word 0:8  # Arreglo de 8 palabras inicializadas a 0 (NULL)
	# Estructura para un nodo de la lista enlazada
	node: .space 17 # 12 para el string, 4 para el puntero, y 1 para el entero
	.word 0   # El puntero al siguiente nodo
	head: .word 0   # La cabeza de la lista enlazada inicialmente apunta a NULL
	buffer: .space 13  # Buffer para leer strings ingresados por el usuario
	msg_add: .asciiz "Ingrese 1 para agregar una melodia, 2 para ver melodia, 3 para reproducir melodia o 4 para salir: "
	msg_err_mel: .asciiz "Opcion de espacio no valida\n"
	msg_err_esp_oc: .asciiz "El espacio seleccionado ya esta ocupado\n"
	msg_err_rep: .asciiz "Opcion de melodia a reproducir no valida\n"
	msg_val: .asciiz "Ingrese una nota (o un 0 para terminar): "
	msg_dur: .asciiz "Ingrese la duracion para la nota (en fusas):"
	msg_err: .asciiz "Opcion no valida\n"
	msg_alloc_err: .asciiz "Error con la asignacion de memoria"
	msg_mel_disp: .asciiz "Melodias disponibles (ingresa solo el numero): "
	msg_mel_listas_vacias: .asciiz "No hay ninguna melodia para reproducir\n"
	msg_esp_oc: .asciiz "Todos los espacios estan ocupados\n"
	msg_err_vacia: .asciiz "El espacio seleccionado no contiene melodia\n"
	msg_err_note: .asciiz "La nota ingresada no es valida, recuerde usar notacion acustica cientifica\n"
	salto: .asciiz "\n"
	espacio: .asciiz " "
	.align 2
	str_int: .space 2
		 .asciiz ""

.text
############################################ METODO PRINCIPAL #######################################################################
	main:	
	
		#Cargar melodias del melodies.asm
		cargar_melodias:
				li $s0, 8
				li $s1, 16
				li $s2, 1	#iterador
				la $a3, M1
				
			conseguir_head:
    				la $t4, heads_array  # Cargar base del arreglo de cabezas de listas
    				li $t0, 0  # indice del arreglo (de 0 a 7)
    				# Ciclo para verificar melodias disponibles
    				busca_espacio:
        				beq $t0, 8, fin_busca_espacio  # Si hemos recorrido todas las posiciones, salimos del bucle
        				# Calcular la direccion de la cabeza de la lista actual
        				sll $t5, $t0, 2  # Multiplicar el indice por 4 (el tamano de la palabra)
        				add $t5, $t5, $t4  # Sumar la direccion base del arreglo
        				lw $t3, 0($t5)  # Carga el valor de la cabeza de la lista
        				beqz $t3, continue_busca_espacio  # Si el valor de la cabeza es cero, se encontro un espacio disponible
        				j siguiente  # Pasar a la siguiente posicion

    					# Pasar a la siguiente posicion. Incrementa el indice y vuelve al ciclo disponibles
    					siguiente:
        					addi $t0, $t0, 1
        					j busca_espacio

    				# Fin del ciclo para verificar espacio disponible
    				fin_busca_espacio:
        				print_label(msg_esp_oc)
        				j menu

				# Continuar con la ejecucion del programa
				continue_busca_espacio:
    					# Calcular la direccion de la cabeza de la lista correspondiente
    					li $t2, 4  # Cada entrada del arreglo es de 4 bytes
    					mul $t5, $t0, $t2  # Multiplicar el indice por 4 para obtener el desplazamiento
    					la $t3, heads_array  # Cargar la direccion base del arreglo
    					add $t3, $t3, $t5  # Sumar el desplazamiento para obtener la direccion exacta
    					lw $t4, 0($t3)
    					li $t7, 0 # Contador de notas
    					# Guardar la direccion de la cabeza en un registro para usarlo en agrega_melodia
    					move $a2, $t3			

			recuperador:	#codigo dedicado a recuperar las notas y fusas a agregar a la lista enlazada
				lb $t1, ($a3)	#cargamos 1 byte a la vez
				loop_r1: 
					beqz $t1, end_recuperador	#si el espacio esta vacio, salimos
					move $t2, $t1	#recuperamos el 1er caracter
					addi $a3, $a3, 1
					lb $t1, ($a3)
					beq $t1, 0x00000020, end_r1	#si es un espacio en blanco, el siguiente caracter es el inicio de las fusas
					move $t3, $t1	#recuperamos el 2do caracter de existir
					concat ($t2, $t3, $s0)	#concatenamos ambos caracteres en un solo registro
					addi $a3, $a3, 1
					lb $t1, ($a3)
					beq $t1, 0x00000020, end_r1	#si es un espacio en blanco, el siguiente caracter es el inicio de las fusas
					move $t4, $t1	#recuperamos el 2do caracter de existir
					concat ($t2, $t4, $s1)	#concatenamos ambos caracteres en un solo registro
					addi $a3, $a3, 1
				end_r1:	#en este punto recuperamos la nota que hay en $t2 dentro del buffer
					sw $t2, buffer
					addi $a3, $a3, 1	#nos saltamos el espacio en blanco
				loop_r2:
					lb $t1, ($a3)	#recuperamos el 1er digito
					move $t2, $t1
					addi $a3, $a3, 1
					lb $t1, ($a3)
					beq $t1, 0x0000000a, end_r2	#si es un salto de linea, el siguiente caracter es una nota
					move $t3, $t1	#recuperamos el 2do digito de existir
					concat ($t2, $t3, $s0)	#concatenamos ambos digitos en un solo registro
				end_r2:	
					sw $t2, str_int	
					len_label (str_int)
					str_to_int (str_int, $s7) #convertimos el string en int
					#en este punto recuperamos la fusa que hay en $s5 en $a1
					move $a1, $s5
					li $s5, 0	#reiniciamos el registro $s5 para las siguientes fusas

    			jal agrega_nota  # Saltar a agrega_melodia
					addi $a3, $a3, 1	#saltamos el salto de pagina
					lb $t1, ($a3)
					j loop_r1
			end_recuperador:
				add $s2, $s2, 1
				la $a3, M2
				beq $s2, 2, conseguir_head
				la $a3, M3
				beq $s2, 3, conseguir_head
				la $a3, M4
				beq $s2, 4, conseguir_head
				la $a3, M5
				beq $s2, 5, conseguir_head
				la $a3, M6
				beq $s2, 6, conseguir_head
				la $a3, M7
				beq $s2, 7, conseguir_head
				la $a3, M8
				beq $s2, 8, conseguir_head
				
        	# Mostrar menu
        	menu:
        		print_label (msg_add)

        	# Leer la opcion del usuario
        	read_int
        	move $t0, $v0 # Guardar la opcion en $t0
		la $t8, ($t0) # Flag que indicara si se quiere ver una melodia, o reproducirla
        	# Decidir accion basada en la opcion
        	beq $t0, 1, selecciona_espacio
        	beq $t0, 2, melodias
        	beq $t0, 3, melodias 
        	beq $t0, 4, exit     
        	j error              

		# Manejador del error de selección de opcion
        	error:
            		print_label (msg_err)
            		j menu

		# Salir del programa
    		exit:
        		terminate

############################################ METODOS ##########################################################################
	# Seleccionar el espacio para agregar la melodia
	selecciona_espacio:
    		la $t4, heads_array  # Cargar base del arreglo de cabezas de listas
    		li $t0, 0  # ï¿½ndice del arreglo (de 0 a 7)
    		# Ciclo para verificar melodias disponibles
    		espacios_disponibles:
        		beq $t0, 8, fin_espacios_disponibles  # Si hemos recorrido todas las posiciones, salimos del bucle
        		# Calcular la direccion de la cabeza de la lista actual
        		sll $t1, $t0, 2  # Multiplicar el indice por 4 (el tamano de la palabra)
        		add $t1, $t1, $t4  # Sumar la direccion base del arreglo
        		lw $t3, 0($t1)  # Carga el valor de la cabeza de la lista
        		beqz $t3, espacio_disponible_encontrado  # Si el valor de la cabeza es cero, se encontro un espacio disponible
        		j siguiente_posicion  # Pasar a la siguiente posicion

    			# Espacio disponible encontrado
    			espacio_disponible_encontrado:
        			print_label(msg_mel) # Imprime mensaje de espacio encontrado
        			print_label(M) # Imprime M
        			addi $t1, $t0, 1 # Incrementa en 1 el indice
        			print_int($t1) # Imprime el indice 
        			
        			j continue_espacio # Salta a continuar el programa

    			# Pasar a la siguiente posiciï¿½n. Incrementa el indice y vuelve al ciclo disponibles
    			siguiente_posicion:
        			addi $t0, $t0, 1
        			j espacios_disponibles

    		# Fin del ciclo para verificar espacio disponible
    		fin_espacios_disponibles:
        		print_label(msg_esp_oc)
        		j menu

		# Continuar con la ejecucion del programa
		continue_espacio:
    			# Imprimir salto de linea
    			print_label(salto)
    			subi $t1, $t1, 1
    			# Calcular la direccion de la cabeza de la lista correspondiente
    			li $t2, 4  # Cada entrada del arreglo es de 4 bytes
    			mul $t1, $t0, $t2  # Multiplicar el indice por 4 para obtener el desplazamiento
    			la $t3, heads_array  # Cargar la direccion base del arreglo
    			add $t3, $t3, $t1  # Sumar el desplazamiento para obtener la direccion exacta
    			lw $t4, 0($t3)
    			li $t7, 0 # Contador de notas
    			# Guardar la direccion de la cabeza en un registro para usarlo en agrega_melodia
    			move $a2, $t3

    			jal agrega_melodia  # Saltar a agrega_melodia


		# Subrutina que pide el valor del nodo al usuario y luego lo agrega a la lista
		agrega_melodia:
			beq $t7, 30, max_notas # Si se llego a 30, se alcanzo el limite de notas por melodias
    			print_label (msg_val)

    			# Leer el string del nodo
    			read_string (buffer,13)
    			no_next_line (buffer)

    			# Verificar si se ingreso un 0 para salir
    			lb $t1, buffer
    			li $t2, '0'
    			beq $t1, $t2, menu
    			
    			#Verificar si la nota ingresada es correcta
    			music_note (buffer)
    			beqz $s0, nota_invalida
    			restablecer

    			# Asegurarse de que el ultimo byte del buffer sea nulo
    			sb $zero, 12($a0) # Establecer el byte nulo al final del string

    			# Pedir al usuario que ingrese el valor entero para el nodo
    			print_label (msg_dur)
    			read_int
    			# Si la duracion ingresada es menor o igual a cero, o mayor a 99, error
			blez $v0, error_duracion 
			bge $v0, 100, error_duracion
    			# Saltar a la subrutina agrega_nota
    			move $a1, $v0   # Mover el entero leido a $a1 para usarlo en agrega_nota
			addi $t7, $t7, 1
    			jal agrega_nota    
    			j agrega_melodia
    			
    			# Manejar error de duraciï¿½n ingresada menor o igual a cero
    			error_duracion:
    				print_label (msg_error_dur)
    				j agrega_melodia
    			
    			#Manejar error de nota no valida
    			nota_invalida:
    				print_label (msg_err_note)
    				j agrega_melodia
    			max_notas:
    				print_label (msg_max_note)
    				j menu	

		# Agregar la nota a la melodï¿½a
		agrega_nota:
    			# Reservar memoria para el nuevo nodo (16 bytes para el string y puntero + 4 bytes para el entero, que es la duracion)
    			li $v0, 9       
    			li $a0, 20      # El tamano total del nodo ahora es de 20 bytes 
    			syscall         
    			move $t0, $v0   # Cargar direccion del nuevo nodo a $t0

    			# Verificar si la asignacion de memoria fue exitosa
    			beqz $t0, alloc_error

    			# Copiar el string del buffer al nuevo nodo (12 bytes)
    			la $t1, buffer      
    			la $t2, ($t0)      
    			li $t3, 12 
    			  
    			# Ciclo que se encarga de la copia	       
			copy_loop:
    				lb $t4, 0($t1)      
    				sb $t4, 0($t2)      
    				addiu $t1, $t1, 1   
    				addiu $t2, $t2, 1   
    				sub $t3, $t3, 1     
    				bnez $t3, copy_loop 

    			# Inicializar el puntero al siguiente nodo con NULL (en posicion +16 bytes)
    			sw $zero, 16($t0)

    			# Guardar el valor entero en el nuevo nodo (en posicion +16 bytes)
    			sw $a1, 16($t0)     

    			# Verificar si la lista esta vacia
    			lw $t1, 0($a2)       # Cargar cabeza de la lista
    			beqz $t1, update_head # Si esta vacia, actualizar la cabeza

    			# Encontrar el ultimo nodo de la lista
			find_last:
    				lw $t3, 12($t1)      # Cargar el puntero al siguiente nodo
   				beqz $t3, agregar    # Si es NULL, hemos encontrado el ï¿½ltimo nodo
    				move $t1, $t3        # Mover al siguiente nodo
    				j find_last

    			# Agregar el nuevo nodo al final de la lista
			agregar:
    				sw $t0, 12($t1)      # Establecer el siguiente del ultimo nodo al nuevo nodo
    				jr $ra

    			# Actualizar la cabeza de la lista
			update_head:
    				sw $t0, 0($a2)       
    				jr $ra
    				
		# Manejar el error de asignacion de memoria
		alloc_error:
			print_label (msg_alloc_err)
			j exit
			
		# Mostrar melodias disponibles 	
		melodias: 
    			# Imprimir mensaje de melodias disponibles
    			print_label (msg_mel_disp)	
        		la $t4, heads_array  # Cargar base del arreglo de cabezas de listas
        		li $t5, 1 # Indicador de que todas las listas estan vacias (inicialmente en 1, true)
    			li $t0, 0  # indice del arreglo (de 0 a 7)
    			# Ciclo para verificar melodias disponibles
			ver_disponibles:
    				beq $t0, 8, fin_melodias  # Si hemos recorrido todas las posiciones, salimos del bucle

    				# Calcular la direccion de la cabeza de la lista actual
    				sll $t1, $t0, 2  # Multiplicar el indice por 4 (el tamano de la palabra)
    				add $t1, $t1, $t4  # Sumar la direccion base del arreglo

    				lw $t3, 0($t1)  # Carga el valor de la cabeza de la lista

    				bnez $t3, imprime_posicion # Si el valor de la cabeza no es cero (la lista no esta vacia), imprimir la posicion
    				
    				j next_posicion # Pasar a la siguiente posicion
    				
			# Imprimir posicion disponible
			imprime_posicion:
    				# Imprime la posicion de la melodia disponible para reproducir
    				print_label(M)
    				addi $t1, $t0, 1
    				print_int ($t1)
    				# Imprimir espacio
    				print_label (espacio)
        			li $t5, 0  # Establecer $t5 en 0, es decir, existe al menos una lista no vacia
        			
			# Pasar a la siguiente posicion. Incrementa el indice y vuelve al ciclo disponibles
			next_posicion:
    				addi $t0, $t0, 1
    				j ver_disponibles  

			# Fin del ciclo para verificar melodias disponibles
			fin_melodias:
				beqz $t5, continue_ver # Si $t5 es 0, hay al menos una lista no vacia. Continuar con el programa
				# Si $t5 no es cero, todas las listas estan vacias. Imprimir mensaje de error y volver al menu
				print_label (msg_mel_listas_vacias)
        			j menu
        		continue_ver:
				# Imprimir salto de linea
				print_label (salto)

    				# Leer el indice ingresado por el usuario
    				read_int
    				move $t3, $v0  # Guardar el indice en $t1
    				subi $t1, $t3, 1

    				# Verificar que el indice sea valido (0-7)
    				bltz $t1, error_ver  # Si es menor que 0, error
    				li $t2, 7          # Cargar el numero 7 en $t2 para la comparacion
    				bgt $t1, $t2, error_ver  # Si $t1 es mayor que $t2 (7), error

    				# Calcular la direccion de la cabeza de la lista correspondiente
    				li $t2, 4       # Cada entrada del arreglo es de 4 bytes
    				mul $t1, $t1, $t2  # Multiplicar el indice por 4 para obtener el desplazamiento
    				la $t3, heads_array  # Cargar la direccion base del arreglo
    				add $t3, $t3, $t1   # Sumar el desplazamiento para obtener la direccion exacta

    				# Guardar la direccion de la cabeza en un registro para su uso posterior
    				move $a2, $t3  
				beq $t8, 2, ver_melodia # Si $t8 es 2, el usuario quiere ver la melodia
				beq $t8, 3, reproduce_melodia  # Si $t8 es 3, el usuario quiere reproducir la melodia
    				
    			# Manejar error de seleccion de la melodia
			error_ver:
				# Imprimir mensaje de error y volver a la selecciï¿½n de la melodï¿½a
    				print_label (msg_err_rep)
    				j melodias
    			
    			# Ver la melodia		
    			ver_melodia:
    				lw $t4, 0($a2)         # Cargar direccion de la cabeza de la lista desde $a2
    				beqz $t4, error_vacia  # Si el valor de $t4 es 0, la melodia esta vacia
    				imp:
        				beqz $t4, fin_imp # Si el nodo es NULL, terminar
        				la $a0, 0($t4)      # Cargar la direccion del string del nodo
        				li $v0, 4           # Servicio para imprimir strings
        				syscall
        				print_label (espacio)
        				
        				lw $s0, 16($t4)     # Cargar el valor entero del nodo (fusas)
        				print_int ($s0)
        				
        				print_label (salto)
        				# Mover al siguiente nodo
        				lw $t4, 12($t4)     # Cargar el puntero al siguiente nodo
        				j imp
        
        		 	# Terminar la reproduccion, volviendo al menu principal
    			 	fin_imp:
        				j menu


			# Reproducir la melodia
			reproduce_melodia:
    				lw $t4, 0($a2)         # Cargar direccion de la cabeza de la lista desde $a2
    				beqz $t4, error_vacia  # Si el valor de $t4 es 0, la melodia esta vacia
    				reproduccion:
        				beqz $t4, fin_reproduccion # Si el nodo es NULL, terminar
        				la $a0, 0($t4)      # Cargar la direccion del string del nodo
        				li $v0, 4           # Servicio para imprimir strings
        				syscall
        			
        				print_label (salto)             

        				# Convertir el valor entero del nodo (fusas) a milisegundos
        				lw $a0, 16($t4)     # Cargar el valor entero del nodo (fusas)
        				li $t5, 31          # Cargar el valor de conversion (31.25 aproximado a 31)
        				mul $a0, $a0, $t5   # Multiplicar fusas por 31 para obtener milisegundos

        				# Usar el valor convertido como tiempo de espera
        				li $v0, 32          # Servicio para dormir (sleep)
        				syscall             

        				# Mover al siguiente nodo
        				lw $t4, 12($t4)     # Cargar el puntero al siguiente nodo
        				j reproduccion
        
        		 	# Terminar la reproduccion, volviendo al menu principal
    			 	fin_reproduccion:
        				j menu
		
			# Manejador del error de melodia vacia
			error_vacia:
				# Imprimir mensaje de error y volver a la seleccion de la melodia
    				print_label (msg_err_vacia)
    				j melodias
