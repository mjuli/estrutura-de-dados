# Fila

.data
p1: 	.asciiz "Digite: \n1 - Enfileirar\n2 - Desenfileirar\n3 - Tamanho\n4 - Vazia\n5 - Cabeça\n6 - End\n"
p2:	.asciiz "\nOperação concluida com sucesso!\n"
p3:	.asciiz "Fim\n"
p4:	.asciiz "Erro! Tente de novo.\n"
p5:	.asciiz "Digite um numero: \n"
p6:	.asciiz "Erro. Fila vazia!\n"

.text
main:	lui $7, 0x1002 #registrador q vai ser usado para retornar os dados(sp1)
	lui $8, 0x1002 #registrador q vai ser usado para salvar os dados(sp2)
	
	addi $9, $0, 0 #$9 -> contador
	addi $10, $0, 1 #$10 -> enfileirar
	addi $11, $0, 2 #$11 -> desenfileirar
	addi $12, $0, 3 #$12 -> tamanho
	addi $13, $0, 4 #$13 -> vazio
	addi $14, $0, 5 #$12 -> cabeca
	addi $15, $0, 6 #$13 -> end
	
	
teste:	lui $4, 0x1001 #print p1 - para escolher
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 5 #recebe numero
	syscall
	
	#Redireciona
	beq $2, $10, enfileirar #se $numero = 1 -> enfileirar
	beq $2, $11, desenfileirar #se $numero = 2 -> desenfileirar
	beq $2, $12, tamanho #se $numero = 3 -> tamanho
	beq $2, $13, vazia #se $numero = 4 -> vazia
	beq $2, $14, cabeca #se $numero = 5 -> cabeca
	beq $2, $15, end #se $numero = 6 -> end
	
	#Se o usuario digitar outra coisa. Msg de ERRO:
erro:	lui $4, 0x1001 #print p4 -> erro
	addi $4, $4, 0x7b
	addi $2, $0, 4
	syscall
	
	j teste #volta para o começo

erro2:	lui $4, 0x1001 #print p6 -> erro, fila vazia!
	addi $4, $4, 0xa5
	addi $2, $0, 4
	syscall
	
	j teste #volta para o começo	
	
enfileirar:	
	lui $4, 0x1001 #print p5 -> digite um numero
	addi $4, $4, 0x91
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 5 #recebe numero
	syscall
	
	sw $2, 0($8) #salva o numero na memoria
	addi $8, $8, 4 #incrementa o valor do $8
	addi $9, $9, 1 #incremento do contador
	
	#Imprime msg de sucesso
	j sucesso
	
desenfileirar:	
	beq $9, $0, erro2 #se o contador estiver zerado = msg erro
	
	#senao:
	lw $4, 0($7) #passa o primeiro numero para o $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall
	
	sw $0, 0($7) #salva zero na memoria
	addi $7, $7, 4 #pula para a proxima casa
	subi $9, $9, 1 #decremento do contador
	
	#Imprime msg de sucesso
	j sucesso
	
tamanho:	
	add $4, $0, $9 #salva numero do contador no $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall
	
	#Imprime msg de sucesso
	j sucesso
	
vazia:
	beq $9, $0, true #se a fila esta vazia
	#senao, imprime 1(a fila não está vazia)
false:
	addi $4, $0, 1 #salva numero do contador no $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall	
	
	j sucesso
	
true:	#imprime 0(a fila esta vazia)
	add $4, $0, $0 #salva numero do contador no $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall	
	
	j sucesso

cabeca:
	beq $9, $0, erro2 #se o contador estiver zerado = msg erro
	
	#senao:
	lw $4, 0($7) #passa o primeiro numero para o $4
	addi $2, $0, 1 #imprime o numero que esta no $4
	syscall
	
	#Imprime msg de sucesso
	j sucesso
	
sucesso:
	lui $4, 0x1001 #print p2 -> sucesso
	addi $4, $4, 0x54
	addi $2, $0, 4
	syscall
	
	j teste #volta para teste
	
end:	
	lui $4, 0x1001 #print p3 -> end
	addi $4, $4, 0x76
	addi $2, $0, 4
	syscall
	
	addi $2, $0, 10 #Finaliza
	syscall
