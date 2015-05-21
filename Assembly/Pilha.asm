# Pilha

.data
p1: 	.asciiz "Digite: \n1 - Push\n2 - Pop\n3 - Size\n4 - End\n"
p2:	.asciiz "\nOperação concluida com sucesso!\n"
p3:	.asciiz "Fim\n"
p4:	.asciiz "Size: "
p5:	.asciiz "Erro! Tente de novo.\n"
p6:	.asciiz "Digite um numero: \n"

.text
main:	lui $7, 0x1002 #registrador q vai ser usado para salvar os dados

	addi $9, $0, 0 #$9 -> contador
	addi $10, $0, 1 #$10 -> push
	addi $11, $0, 2 #$11 -> pop
	addi $12, $0, 3 #$12 -> size
	addi $13, $0, 4 #$13 -> end
	
	#$9 -> contador; $10 -> push; $11 -> pop; $12 -> size; $13 -> end
	
teste:	lui $4, 0x1001 #print p1 - para escolher
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 5 #recebe numero
	syscall
	
	#Redireciona
	beq $2, $10, push #se $numero = 1 -> push
	beq $2, $11, pop #se $numero = 2 -> pop
	beq $2, $12, size #se $numero = 3 -> size
	beq $2, $13, end #se $numero = 4 -> end
	
	#Se o usuario digitar outra coisa. Msg de ERRO:
erro:	lui $4, 0x1001 #print p5 -> erro
	addi $4, $4, 0x5a
	addi $2, $0, 4
	syscall
	
	j teste #volta para o começo
	
	
push:	lui $4, 0x1001 #print p6 -> digite
	addi $4, $4, 0x70
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 5 #recebe numero
	syscall
	
	sw $2, 0($7) #salva o numero na memoria
	addi $7, $7, 4 #incrementa o valor do $7
	addi $9, $9, 1 #incremento do contador
	
	#Imprime msg de sucesso
	j sucesso
	
	
pop:	beq $9, $0, erro #se o contador estiver zerado = msg erro
	
	#senao:
	sub $7, $7, $13 # volta uma casa na memoria
	lw $4, 0($7) #passa o ultimo numero para o $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall
	
	sw $0, 0($7) #salva zero na memoria
	sub $9, $9, $10 #decremento do contador
	
	#Imprime msg de sucesso
	j sucesso
	
	
size:	lui $4, 0x1001 #print p4 -> size
	addi $4, $4, 0x53
	addi $2, $0, 4
	syscall
	
	add $4, $0, $9 #salva numero do contador no $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall
	
	#Imprime msg de sucesso
	j sucesso
		
		
sucesso:lui $4, 0x1001 #print p5 -> erro
	addi $4, $4, 0x2c
	addi $2, $0, 4
	syscall
	
	j teste #volta para teste
	
	
end:	lui $4, 0x1001 #print p3 -> end
	addi $4, $4, 0x4e
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 10 #Finaliza
	syscall
