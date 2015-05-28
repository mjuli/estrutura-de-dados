# Notacao infixa para pos-fixa

.data
#p1: 	.asciiz "\n"
#p2	.asciiz "b"
#p3:	.asciiz "\n"

.text
main:	lui $7, 0x1002 #registrador q vai ser usado para salvar os dados da pilha

	addi $9, $0, 0 #$9 -> contador
	addi $10, $0, 40 #$10 -> (
	addi $11, $0, 41 #$11 -> )
	addi $12, $0, 42 #$12 -> *
	addi $13, $0, 43 #$13 -> + 
	addi $14, $0, 45 #$14 -> -
	addi $15, $0, 47 #$15 -> /
	addi $16, $0, 94 #$16 -> ^
	addi $21, $0, 10 #$21 -> \n
	
	# $17 -> recebe o caracter
	# $19 -> salva o end da string - operacao
	# $20 -> variavel
	# $22 -> salva prioridade do ultimo operador
	
ler:	lui $4, 0x1001 #endereço para salvar a operação
	addi $5, $0, 21 #tamanho maximo da string: 20 (n-1)
	addi $2, $0, 8 #recebe a operaçao(string) e salva na memoria
	syscall
	
	add $19, $0, $4 #recebe o end da operaçao 
	
	
separa:	lb $17, 0($19) #passa o caracter para o $17	
	beq $17, $21, terminar
	beq $17, $10, abre
	beq $17, $11, fecha
	beq $17, $12, vezes_div
	beq $17, $13, mais_menos
	beq $17, $14, mais_menos
	beq $17, $15, vezes_div
	beq $17, $16, potencia
	
	add $4, $0, $17 #se nao for operador ou (), é operando e fica salvo no $4
	addi $2, $0, 11 #imprime o caracter q esta salvo no $4
	syscall	
	
pulo:	addi $19, $19, 1 #incrementa o endereço na memoria
	j separa

fecha:	
	addi $22, $0, 49 # $20 = 1 (prioridade minima)
	subi $7, $7, 1 #volta uma casa da pilha (casa do num)
	lb $20, 0($7) #passa o num para o $20
	
	beq $20, $22, limpar #se prioridade = 1, entao => "("
	
	# senao entao desempilha
	sb $0, 0($7) #salva zero na memoria (casa do num)
	subi $7, $7, 1 #volta uma casa da pilha (casa do operador)
	lb $4, 0($7) #passa o operador para o $4
	addi $2, $0, 11 #imprime o operador que esta no $4
	syscall
	
	sb $0, 0($7) #salva zero na memoria
	subi $9, $9, 1 #decremento do contador
	
	j fecha
	
limpar:
	sb $0, 0($7) #salva zero na memoria (casa do num)
	subi $7, $7, 1 #volta uma casa da pilha (casa do operador)
	sb $0, 0($7) #salva zero na memoria
	
	subi $9, $9, 1 #decremento do contador
	j pulo

abre:	sb $17, 0($7) #salva "(" na memoria
	addi $7, $7, 1 #incrementa o valor do $7
	
	addi $22, $0, 49 # $20 = 1
	sb $22, 0($7) #salva 1 na memoria
	addi $7, $7, 1 #incrementa o valor 1 no $7
	
	addi $9, $9, 1 #incremento do contador
	
	#volta para a separação
	j pulo

comparar:
	subi $7, $7, 1 #volta uma casa da pilha (casa do num)
	lb $20, 0($7) #passa o num para o $20
	blt $20, $22, empilha #se o ultimo operador da pilha tiver prioridade menor q o operador atual = > empilhar atual
	
	#se o ultimo operador da pilha tiver prioridade igual ou maior, entao desempilhar o ultimo
	
	sb $0, 0($7) #salva zero na memoria
	
	subi $7, $7, 1 #volta uma casa da pilha (casa do operador)
	lb $4, 0($7) #passa o operador para o $4
	addi $2, $0, 11 #imprime o operador que esta no $4
	syscall
	
	sb $0, 0($7) #salva zero na memoria
	subi $9, $9, 1 #decremento do contador
	
	j comparar
	
empilha:
	addi $7, $7, 1 #vai para a proxima casa
	sb $17, 0($7) #salva operador na memoria
	
	addi $7, $7, 1 #incrementa o valor do $7
	sb $22, 0($7) #salva prioridade na memoria
	
	addi $7, $7, 1 #incrementa o valor 1 no $7	
	addi $9, $9, 1 #incremento do contador
	
	#volta para a separação
	j pulo
	
	
mais_menos:
	addi $22, $0, 50 # $22 = 2 (prioridade)
	bne $9, $0, comparar # se o contador for diferente de zero (ou seja, a pilha tem operador)
	
	#se a pilha estiver vazia
	sb $17, 0($7) #salva "+" ou "-" na memoria
	addi $7, $7, 1 #incrementa o valor do $7
	
	sb $22, 0($7) #salva 2 na memoria
	addi $7, $7, 1 #incrementa o valor 1 no $7
	
	addi $9, $9, 1 #incremento do contador
	
	#volta para a separação
	j pulo

vezes_div:
	addi $22, $0, 51 # $22 = 3 (prioridade)
	bne $9, $0, comparar # se o contador for diferente de zero (ou seja, a pilha tem operador)
	
	sb $17, 0($7) #salva "*" ou "/" na memoria
	addi $7, $7, 1 #incrementa o valor do $7
	
	sb $22, 0($7) #salva 3 na memoria
	addi $7, $7, 1 #incrementa o valor 1 no $7
	
	addi $9, $9, 1 #incremento do contador
	
	#volta para a separação
	j pulo
	
potencia:
	addi $22, $0, 52 # $22 = 4 (prioridade)
	bne $9, $0, comparar # se o contador for diferente de zero (ou seja, a pilha tem operador)
	
	sb $17, 0($7) #salva "*" ou "/" na memoria
	addi $7, $7, 1 #incrementa o valor do $7
	
	sb $22, 0($7) #salva 4 na memoria
	addi $7, $7, 1 #incrementa o valor 1 no $7
	
	addi $9, $9, 1 #incremento do contador
	
	#volta para a separação
	j pulo
	
terminar: #imprime os ultimos operadores
	beq $9, $0, end
	
	subi $7, $7, 1 # volta uma casa na memoria (vai para a casa do num)
	sb $0, 0($7) #salva zero na memoria
	
	subi $7, $7, 1 # volta uma casa na memoria (vai para a casa do operador)	
	lb $4, 0($7) #passa o operador para o $4
	addi $2, $0, 11 #imprime o operador que esta no $4
	syscall
	
	sb $0, 0($7) #salva zero na memoria
	subi $9, $9, 1 #decremento do contador
		
	j terminar #repete tudo


end:	addi $2, $0, 10 #Finaliza
	syscall
	
	
