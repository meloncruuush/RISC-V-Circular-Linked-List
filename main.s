# ricordati di fixare tutti i TODO!!!
# controlla coerenza nomi funzioni etc
# per relazione, parlare della formattazione del codice

.data
listInput: .string "ADD(3)~ADD(5)~ADD(~)~ADD(1)~ADD(1)~ADD(})~PRINT~ADD(3)~ADD(5)~ADD(~)~ADD(1)~ADD(1)~ADD(})~PRINT"
lfsr:      .word 612178        # seme iniziale, ho scritto un numero a caso

newline:   .string "\n"
space:     .string " "
squareL:   .string "[ "
squareR:   .string "]"


.text

lw s0 lfsr        # Che è?
li s1 0           # Indirizzo della testa
li s2 0           # Indirizzo della coda
la s4 listInput   

add a1 s4 zero    # Mette il primo carattere in a1

main:
    j DECODING



DECODING:
    check_initial_spaces:
        lb t1 0(a1)             # carattere ora in t1
        li t2 32                # 32 è 'spazio' in ASCII
        bne t1 t2 check_add     # se non è uno spazio, jump
        addi a1 a1 1            # carattere successivo
        j check_initial_spaces



    check_add:
        lb t1 0(a1)
        li t2 65
        bne t1 t2 check_print            # controllo se è A, altrimenti provo P per PRINT
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se è D, se non lo è, formattazione errata, passo a prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # D
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # parentesiL
        
        addi a1 a1 1
        lb a2 0(a1)                      # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # parantesiR
        
        jal x1, check_spaces
        
        j ADD



    check_print:
        lb t1 0(a1)
        li t2 80
        bne t1 t2 check_del              # controllo se è P, se non lo è, formattazione errata, passo a prossima istruzione
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # R
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 73
        bne t1 t2 check_next_instruction # I

        addi a1 a1 1
        lb t1 0(a1)
        li t2 78
        bne t1 t2 check_next_instruction # N
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # T
        
        jal x1, check_spaces
        
        j PRINT



    check_del:
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_rev               # controllo se è D, se non lo è, formattazione errata, passo a prossima istruzione
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction  # E
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 76
        bne t1 t2 check_next_instruction  # L
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction  # parantesiL
        
        addi a1 a1 1
        lb a2 0(a1)                       # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction  # if < 32, TODO, ma non è 47 < x < 58 ? 
        li t2 125
        bgt a2 t2 check_next_instruction  # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # parentesiR
        
        jal x1, check_spaces
        
        j DEL



    check_rev:
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_s                           # controllo se è R, se non lo è, formattazione errata, passo a prossima istruzione
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction            # E
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 86
        bne t1 t2 check_next_instruction            # R
     
        jal x1, check_spaces
        
        j REV



    check_s:
        lb t1 0(a1)
        li t2 83
        bne t1 t2 check_next_instruction  # controllo se è S, se non lo è, formattazione errata, passo a prossima istruzione
        
        addi a1 a1 1
        
        lb t1 0(a1)
        li t2 79
        beq t1 t2 check_sort              # controllo se è O di sort
        
        lb t1 0(a1)
        li t2 86
        beq t1 t2 check_sdx               # controllo se è V di svx
        
        lb t1 0(a1)
        li t2 83
        beq t1 t2 check_ssx               # controllo se è S di ssx
        
        j check_next_instruction
        
        
        

    check_sort:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # controllo se è R, se non lo è, formattazione errata, passo a prossima istruzione        
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se è T
        
        jal x1, check_spaces
        
        j SORT



    check_sdx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se è X, se non lo è, formattazione errata, passo a prossima istruzione
 
        jal x1, check_spaces
        
        j SDX   



    check_ssx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se è X, se non lo è, formattazione errata, passo a prossima istruzione
 
        jal x1, check_spaces
        
        j SSX   



    check_spaces:          
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces
            jalr x0, x1, 0



    check_next_instruction:
            lb t1 0(a1)                 # ciclo che continua finchè non trova ~ e prosegue il decoding, o null e chiude il programma
            
            li t2 0                     # null                        
            beq t1 t2 exit
            
            li t2 126                   # tilda
            beq t1 t2 next_instruction
            
            addi a1 a1 1
            
            j check_next_instruction
            
    next_instruction:
        addi a1, a1, 1
        j DECODING


        
# OPERAZIONI    
ADD:
    jal address_generator        # genero l'indirizzo in cui salvare il nodo. Indirizzo in a3
    
    bne s1 zero not_first_ADD    
    
    add s1 a3 zero               # credo che in a3 ci sia l'indirizzo del nodo testa, lo metto in s1
    li t0 0xffffffff             # carico la dimensione della linked list in t1 
    sw t0 0(a3)                  # puntatore precedente
    sw t0 5(a3)                  # puntatore successivo
    sb a2 4(a3)                  # contenuto del nodo
    
    add s2 a3 zero               # aggiorno il nodo coda   
    
    j check_next_instruction
    
    not_first_ADD:
        li t0 0xffffffff         # carico dimensione della lista
        sb a2 4(a3)              # salvo il dato nel nodo
        sw t0 5(a3)              # puntatore al successivo
        sw a3 5(s2)              # aggiorno il puntatore al successivo del nodo precedente
        sw s2 0(a3)              # puntatore al precedente  
        
        add s2 a3 zero           # aggiorno variabile che tiene la coda
        
        j check_next_instruction



PRINT:
    li t0 0xffffffff
    add t1 s1 zero
    beq t1 zero check_next_instruction
    
    la a0 squareL # print the square parenthesis
    li a7 4
    ecall
    PRINT_loop:
        beq t0 t1 new_line
        
        lb a0 4(t1)     # print the element
        li a7 11        
        ecall
        
        la a0 space     # print the comma
        li a7 4
        ecall
        
        lw t1 5(t1)
        j PRINT_loop
        new_line:
            la a0 squareR    # print the square parenthesis
            li a7 4
            ecall
            
            la a0 newline
            li a7 4
            ecall
            j check_next_instruction



DEL:

    li t0 0xffffffff
    add t1 s1 zero
    beq t1 zero DECODING
    DEL_loop:
        lb t2 4(t1)
        beq a2 t2 delete_element
        lw t1 5(t1)
        beq t1 t0 DECODING
        j DEL_loop

    delete_element:
        lw t4 0(t1)
        lw t5 5(t1)
        beq t0 t4 del_first_element
        beq t0 t5 del_last_element
        sw t5 5(t4)
        sw t4 0(t5)
        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        j DECODING

    del_first_element:
        beq t0 t5 del_only_element
        sw t0 0(t5)

        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s1 t5 zero
        j DECODING 

    del_only_element:
        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s1 zero zero
        j DECODING

    del_last_element:
        sw t0 5(t4)
        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s2 t4 zero
        j DECODING
    j check_next_instruction



REV:
    j check_next_instruction



SORT:
    j check_next_instruction



SDX:
    j check_next_instruction



SSX:
    j check_next_instruction



address_generator:
    srli t1 s0 2    # lfsr >> 2
    srli t2 s0 3    # lfsr >> 3
    srli t3 s0 5    # lfsr >> 5

    xor t0 t0 t1
    xor t0 t0 t2
    xor t0 t0 t3    

    srli t1 s0 1
    slli t0 t0 15
    
    or t1 t1 t0 
 
    li t4 0x0000ffff
    and t1 t1 t4
    
    li t4 0x00010000
    or a3 t1 t4
    
    add s0 a3 zero
    add t0 a3 zero
    
    lw t1 0(t0)                   # controllo se la memoria è libera
    bne t1 zero address_generator # byte 0-3 (PBACK)
    lb t1 4(t0)
    bne t1 zero address_generator # byte 4 (DATA)
    lw t1 4(t0)
    bne t1 zero address_generator # byte 5-8 (PAHEAD)
    jr ra



exit:
    li a7, 10
    ecall
    