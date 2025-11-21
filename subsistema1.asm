# DESAFIO 1

.data
cant: .asciz "Ingrese la cantidad de IDs (5-20): "
ingreso_id: .asciz "Ingrese ID: "
msg_id: .asciz "ID: "
msg_pasos: .asciz "Pasos: "
msg_rango: .asciz "Rango: "
lider: .asciz "LIDER"
operador: .asciz "OPERADOR"
informante: .asciz "INFORMANTE"
peon: .asciz  "PEON"
salto: .asciz "\n"
msg_error: .asciz "Error, elegir un número válido"

.align 2

ids: .space 80

.text
.globl main


main:

   	la   a0, cant
    	li   a7, 4
    	ecall

    	li   a7, 5
    	ecall
    
    	li t3, 5
	blt a0, t3, error
 
	li t3, 21
	bge a0, t3, error
    
    	mv   s0, a0
    
    	li s3, 0

loop:

    	bge  s3, s0, fin_programa

    	la   a0, ingreso_id
    	li   a7, 4
    	ecall

    	li   a7, 5
    	ecall
    	
    	li t3, 10
	blt a0, t3, error
 
	li t3, 1001
	bge a0, t3, error

    	mv   s1, a0
    
    	jal ra, collatz
    	mv s2, a0
    
    	la   a0, msg_id
    	li   a7, 4
    	ecall

    	mv   a0, s1
    	li   a7, 1
    	ecall
    
    	la   a0, salto
    	li   a7, 4
    	ecall

    	la   a0, msg_pasos
    	li   a7, 4
    	ecall

    	mv   a0, s2
    	li   a7, 1
    	ecall
    
    	la   a0, salto
    	li   a7, 4
    	ecall
    
    	mv t2,s2
    
    	li t0, 100
    	bge t2,t0, es_l
    
    	li t0, 50
   	bge t2,t0, es_o
    
    	li t0, 20
    	bge t2,t0, es_i
    	j es_p

fin_programa:
    	li   a7, 10
    	ecall


collatz:
    	addi sp, sp, -8
    	sw   ra, 4(sp)
    	sw   s0, 0(sp)

    	mv   s0, a0

    	li   t0, 1
    	beq  s0, t0, collatz_base

    	andi t1, s0, 1
    	bne  t1, zero, collatz_impar

collatz_par:

    	srai a0, s0, 1
    	j    collatz_recursivo

collatz_impar:
    	slli t2, s0, 1
    	add  t2, t2, s0
    	addi a0, t2, 1

collatz_recursivo:
    	jal  ra, collatz
    	addi a0, a0, 1
    	j    collatz_end

collatz_base:
    	li   a0, 0

collatz_end:
    	lw   s0, 0(sp)
    	lw   ra, 4(sp)
    	addi sp, sp, 8
    	jr   ra

es_l:
	la   a0, msg_rango
    	li   a7, 4
    	ecall
    	la   a0, lider
    	li   a7, 4
    	ecall
    	j continue
    
es_i:
	la   a0, msg_rango
    	li   a7, 4
    	ecall
    	la   a0, informante
    	li   a7, 4
    	ecall
    	j continue

es_o:
	la   a0, msg_rango
    	li   a7, 4
    	ecall
	la   a0, operador
	li   a7, 4
	ecall
	j continue

es_p:
	la   a0, msg_rango
    	li   a7, 4
    	ecall
    	la   a0, peon
    	li   a7, 4
    	ecall
    
continue:
    	la   a0, salto
    	li   a7, 4
    	ecall

    	la   a0, salto
    	li   a7, 4
    	ecall


    	addi s3, s3, 1
    	j    loop
    	
error:
	la   a0, msg_error      
   	li   a7, 4             
    	ecall
    	
    	la   a0, salto
	li   a7, 4
	ecall
	
    	j main
