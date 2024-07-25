#Imrpime numero entero dado o almacenado en un registro
.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

#Imprime string almacenado en memoria
.macro print_label (%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro

#Imprime string dado
.macro print_str (%str)
	.data
		String: .asciiz %str
	.text
		li $v0, 4
		la $a0, String
		syscall
.end_macro

#Lee numero entero del usuario
.macro read_int
	li $v0, 5
	syscall
.end_macro

#Lee string del usuario; necesita un direccion de memoria y que se ingrese la longitud del string
.macro read_string (%add, %len)
	li $v0, 8
	la $a0, %add
	li $a1, %len
	syscall
.end_macro

#Cierre del programa
.macro terminate
	li $v0,10
	syscall
.end_macro

#Consigue longitud de label y lo almacena en $s7
.macro len_label(%str)
	la $t0, %str
	lb $t1, ($t0)
	loop:	beqz $t1, end
		addi $s7, $s7, 1
		addi $t0, $t0, 1
		lb   $t1, ($t0)
		j    loop
	end:
.end_macro

#Consigue la potencia dada la base y el exponente en registros; retorna en $s6
.macro pow(%bas, %ex)
	li   $s6, 1
	beq  %ex, 0, end	#manejar exponente cero
	add  $s6, $zero, %bas
	subi %ex, %ex, 1	#manejar "problema de postes"
	loop:	blez %ex, end
		mul  $s6, $s6, %bas
		subi %ex, %ex, 1
		j    loop
	end:
.end_macro

#Discriminador de notas musicales correctas; devuelve valor booleano en $s0
.macro music_note (%note)
	.data
		.align 2
		sil: .asciiz "-1\n"
		notas: .asciiz "ABCDEFG-1"
		shr: .asciiz "#b"
		oct: .asciiz "1234567"
	.text
		main:	
			lw $t0, %note
			lw $t1, sil
			bne $t0, $t1, program
			li $s1, 1
			li $s2, 1
			j  end
		program:
			li $t2, 0
			la $t0, %note	#cargar nota a discriminar
			lb $t1, ($t0)
			count:	#bucle para contar el largo del string (nota)
				beqz $t1, end_count	
				add  $t2, $t2, 1
				add  $t0, $t0,1
				lb   $t1, ($t0)
				j    count
			end_count:
				sub  $t0, $t0, $t2	#reiniciar el string de la nota
				sub  $t2, $t2, 1	#manejar "error de postes"
			comp_notas:	#comparar notas
				la   $t3, notas		#cargar string de notas posibles
				lb   $t4, ($t3)
				lb   $t1, ($t0)		#volver a cargar la nota dada
				loop_1:	beqz $t4, end
					beq  $t1, $t4, comp_spec	#comparacion exitosa, saltar al verificador
					add  $t3, $t3, 1
					lb   $t4, ($t3)
					j    loop_1
			comp_spec:	#comparar # y bemol
				li   $s1, 1	#primer verificador
				sub  $t2, $t2, 1
				beqz $t2, certified	#se recorrio la nota entera, saltar a verificador
				add  $t0, $t0, 1
				lb   $t1, ($t0)
				la   $t3, shr		#cargar # y bemol
				lb   $t4, ($t3) 
				loop_2:	beqz $t4, comp_octa_prev	#manejar posibilidad de no tener # o bemol
					beq  $t1, $t4, comp_octa	#comparacion exitosa, saltar al verificador
					add  $t3, $t3, 1
					lb   $t4, ($t3)
					j    loop_2
			comp_octa_prev:	#comparar octavas sin # o bemol
				add  $t2, $t2, 1
				sub  $t0, $t0, 1
			comp_octa:	#comparar octavas
				sub  $t2, $t2, 1
				beqz $t2, certified	#se recorrio la nota entera, saltar a verificador
				add  $t0, $t0, 1
				lb   $t1, ($t0)
				la   $t3, oct		#cargar string de octavas
				lb   $t4, ($t3)
				loop_3:	beqz $t4, end
					beqz $t2, end
					beq  $t1, $t4, certified	#comparacion exitosa, saltar al verificador
					add  $t3, $t3, 1
					lb   $t4, ($t3)
					j    loop_3
			certified:
				li   $s2, 1	#segundo verificador
			end:
				and  $s0, $s1, $s2	#si se pasaron todas las comparaciones, retornar true
.end_macro

#Restablece los valores de los registros utilizados en music_note		
.macro restablecer
	li $s0, 0
	li $s1, 0
	li $s2, 0
.end_macro

#Concatena strings dada una posicion deseada en multiplos de 8. Hace overflow con mas de 4 digitos
.macro concat (%str1, %str2, %pos)
	sllv %str2, %str2, %pos		#como los strings se leen de derecha a izquierda en assembly, desplazamos el 2do digito
	add  %str1, %str1, %str2
.end_macro

#Cambia un string almacenado en memoria por un int, dada la longitud deseada; retorna en $s5; soporta maximo 9 digitos
.macro str_to_int(%str, %len)
	.data
		.align  2
		salto:	.asciiz "\n"
	.text
	main:	
		lw   $t5, salto #cargar guardia contra saltos
		li   $t6, 10	#cargamos la base 10
		la   $t0, %str
		add  $s7, $zero, %len	#cargamos en $s7 longitud de string
		subi $s7, $s7, 1	#ajustamos "problema de postes"
		pow  (10, $s7)		#calculamos la potencia de 10 inicial (izquierda a derecha)
		la   $t0, %str	#volvemos a cargar el string
		li   $t2, '0'	#cargamos el caracter zero
		lb   $t1, ($t0)
		loop:	beqz $t1, end	#condicion de parada, no queda nada por leer
			beq  $t1, $t5, end	#condicion de parada si se encuentra un salto
			subu $t3, $t1, $t2	#obtenemos el valor real decimal
			addi $t0, $t0, 1	
			lb   $t1, ($t0)
			mul  $t4, $t3, $s6	
			add  $s5, $s5, $t4
			div  $s6, $t6
			mflo $s6
			j    loop
		end:
.end_macro

#elimina los saltos de pagina de un string almacenado en memoria
.macro no_next_line (%str)
	la  $t0, %str
	lb  $t1, ($t0)
	beq $t1, 0x0000000a, delete
	loop:	beqz $t1, end
		addi $t0, $t0, 1
		lb   $t1, ($t0)
		bne  $t1, 0x0000000a, loop
	delete:
		andi $t1, 0
		sb   $t1, ($t0)
	end:
.end_macro
		
