#DESAFIO 2

.data
    buffer_clave: .space 17  
    
    # Mensajes 
    msg_input:      .string "Ingrese clave (16 caracteres): "
    msg_aceptada:   .string "CLAVE ACEPTADA\n"
    msg_rechazada:  .string "CLAVE RECHAZADA\n"
    msg_falla:      .string "Capa fallida: "
    newline:        .string "\n"
    
    #mensajes x capa 
    msg_analisis:   .string " (ANALISIS DE COMPOSICION)\n"
    msg_paridad:    .string " (PARIDAD POSICIONAL)\n"  
    msg_hash:       .string " (CODIGO HASH DE VERIFICACION)\n"

.text
.globl main

main:
    # pedir clave (con mensaje para no perderse)
    li a7, 4
    la a0, msg_input
    ecall
    
    # leer clave(lee max 16 caracteres + uno nulo) 
    li a7, 8
    la a0, buffer_clave
    li a1, 17       
    ecall
    # guarda direccion en s0
    la s0, buffer_clave


# ---> LLAMADO DE CAPAS
    # -> LLAMAR CAPA 1 (Análisis de Composición)
    jal ra, validar_capa_1
    beq a0, zero, fallo_capa_1 

    # -> LLAMAR CAPA 2 (Validación de Paridad) 
    jal ra, validar_capa_2   
    beq a0, zero, fallo_capa_2

    # -> LLAMAR CAPA 3 (Hash) 
    jal ra, validar_capa_3   
    beq a0, zero, fallo_capa_3
    #salto de linea
    li a7, 4
    la a0, newline
    ecall

    # Fin (clave aceptada)
    li a7, 4
    la a0, msg_aceptada
    ecall
    j fin_programa

# ---> ERRORES DE LAS CAPAS + respectivos mensajes
fallo_capa_1:
    #salto de linea
    li a7, 4
    la a0, newline
    ecall

    li a7, 4
    la a0, msg_rechazada
    ecall

    li a7, 4
    la a0, msg_falla
    ecall

    li a7, 1
    li a0, 1
    ecall

    li a7, 4
    la a0, msg_analisis
    ecall

    li a7, 10
    ecall
    
fallo_capa_2:
    #salto de linea
    li a7, 4
    la a0, newline
    ecall
    
    li a7, 4
    la a0, msg_rechazada
    ecall
    
    li a7, 4
    la a0, msg_falla
    ecall
    
    li a7, 1
    li a0, 2                
    ecall
    
    li a7, 4
    la a0, msg_paridad
    ecall
    
    li a7, 10              
    ecall   
    
fallo_capa_3:
    li a7, 4
    la a0, newline
    ecall

    li a7, 4
    la a0, msg_rechazada
    ecall

    li a7, 4
    la a0, msg_falla
    ecall

    li a7, 1
    li a0, 3        
    ecall

    li a7, 4
    la a0, msg_hash
    ecall

    li a7, 10
    ecall

# ---> FUNCIONES

# CAPA 1: Análisis de Composición
validar_capa_1:
    li t0, 0    # contador mayusculas
    li t1, 0    # contador minusculas
    li t2, 0    # contador digitos
    li t3, 0    # contador especiales
    li t4, 0    # i = 0
    li t5, 16   # limite loop

capa1_loop:
    beq t4, t5, capa1_fin  #si i == 16 se termina
    add t6, s0, t4     
    lb a1, 0(t6)           
    
    #digitos (48-57) 
    li t6, 48
    blt a1, t6, capa1_mayus
    li t6, 58
    bge a1, t6, capa1_mayus
    addi t2, t2, 1      
    jal zero, capa1_siguiente

capa1_mayus:
    #mayus (65-90) 
    li t6, 65
    blt a1, t6, capa1_minus
    li t6, 91
    bge a1, t6, capa1_minus
    addi t0, t0, 1     
    jal zero, capa1_siguiente

capa1_minus:
    #minus (97-122) 
    li t6, 97
    blt a1, t6, capa1_especiales
    li t6, 123
    bge a1, t6, capa1_especiales
    addi t1, t1, 1    
    jal zero, capa1_siguiente

capa1_especiales:
    #especiales (uno por uno)
    li t6, 33   
    beq a1, t6, capa1_found_especiales
    li t6, 64   
    beq a1, t6, capa1_found_especiales
    li t6, 35   
    beq a1, t6, capa1_found_especiales
    li t6, 36   
    beq a1, t6, capa1_found_especiales
    li t6, 37   
    beq a1, t6, capa1_found_especiales
    li t6, 38   
    beq a1, t6, capa1_found_especiales
    li t6, 42   
    beq a1, t6, capa1_found_especiales
    li t6, 43   
    beq a1, t6, capa1_found_especiales
    jal zero, capa1_siguiente

capa1_found_especiales:
    addi t3, t3, 1

capa1_siguiente:  
    addi t4, t4, 1  #i++
    jal zero, capa1_loop

capa1_fin:
    li t6, 4   
    # verificar que todos sean exactamente 4
    bne t0, t6, capa1_fail
    bne t1, t6, capa1_fail
    bne t2, t6, capa1_fail
    bne t3, t6, capa1_fail
    li a0, 1   
    jalr zero, ra, 0

capa1_fail:
    li a0, 0   
    jalr zero, ra, 0
    
    
#CAPA 2: Validaci´on de Paridad Posicional
validar_capa_2:
    li t0, 0    # bloques_validos = 0
    li t1, 0    # bloque = 0
    li t2, 4    # limite bloques

capa2_bloque_loop:
    beq t1, t2, capa2_fin
    
    # calcular offset = bloque * 4 (t3 = t1 * 4)
    slli t3, t1, 2      
    li t4, 0    # suma_bloque = 0
    li t5, 0    # k = 0 (indice interno)
    li t6, 4    # limite interno

capa2_char_loop:
    beq t5, t6, capa2_check_paridad
    add a1, s0, t3     # base + offset bloque
    add a1, a1, t5     # + k
    lb a2, 0(a1)       # carga caracter
    add t4, t4, a2     # suma ascii
    addi t5, t5, 1     # k++
    jal zero, capa2_char_loop

capa2_check_paridad:
    andi a3, t4, 1     #revisa ultimo bit (impar?)
    beq a3, zero, capa2_next_bloque # si es 0 (par), salta
    addi t0, t0, 1     # si es impar, cuenta bloque valido

capa2_next_bloque:    
    addi t1, t1, 1
    jal zero, capa2_bloque_loop

capa2_fin:
    li t6, 3
    bge t0, t6, capa2_pass  #3 bloques validos al menos
    
    li a0, 0
    jalr zero, ra, 0

capa2_pass:
    li a0, 1
    jalr zero, ra, 0


#CAPA 3: C´odigo Hash de Verificaci´on

validar_capa_3:
    li t0, 0    # hash = 0
    li t1, 0    # i = 0
    li t2, 16   # limite

capa3_loop:
    beq t1, t2, capa3_check
    
    add t3, s0, t1
    lb t3, 0(t3)        # t3 = char ASCII
    
    # hash * 31 
    slli t4, t0, 5
    sub t4, t4, t0
    
    add t0, t4, t3     # hash = hash_nuevo + ascii
    
    # hash % 65536 
    slli t0, t0, 16
    srli t0, t0, 16
    
    addi t1, t1, 1
    jal zero, capa3_loop

capa3_check:
    li t5, 10000        
    # t6 = 1 si 10000 < hash, si t6 es 1, pasa la prueba!!!
    slt t6, t5, t0     
    bne t6, zero, capa3_pass
    
    li a0, 0
    jalr zero, ra, 0

capa3_pass:
    li a0, 1
    jalr zero, ra, 0    

fin_programa:
    li a7, 10
    ecall