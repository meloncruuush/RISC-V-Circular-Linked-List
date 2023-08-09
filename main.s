# ricordati di fixare tutti i TODO!!!
# controlla coerenza nomi funzioni etc
# per relazione, parlare della formattazione del codice

.data
# listInput: .string "ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~     ADD(9) ~SSX~SORT~PRINT~DEL(b)~DEL(B) ~PRI~SDX~REV~PRINT"
# listInput: .string "ADD(1) ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~PRINT~SORT(a)~PRINT~DEL(bb)~DEL(B) ~PRINT~REV~SDX~PRINT"
# listInput: .string "ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~     ADD(9) ~PRINT~SORT~PRINT~DEL(b)~DEL(B) ~PRI~REV~PRINT"
listInput: .string "ADD(1)~ADD(A)~ADD(*)~ADD(a)~ADD(2)~PRINT~DEL(*)~PRINT"

lfsr:      .word 612178        # Seme del generatore di indirizzi, ? un numero a caso

newline:   .string "\n"
space:     .string " "
squareL:   .string "[ "
squareR:   .string "]"


.text

lw s0 lfsr        # Seme del generatore di indirizzi
li s1 0           # Puntatore alla testa
li s2 0           # Indirizzo della coda
li s3 0           # Contatore numero elementi della lista
la s4 listInput   

add a1 s4 zero    # Mette il primo carattere in a1



PARSING:
    check_initial_spaces:
        lb t1 0(a1)             # carattere ora in t1
        li t2 32                # 32 ? 'spazio' in ASCII
        bne t1 t2 check_add     # se non ? uno spazio, jump
        addi a1 a1 1            # carattere successivo
        j check_initial_spaces

    check_add:
        lb t1 0(a1)
        li t2 65
        bne t1 t2 check_print            # controllo se ? A, altrimenti provo P per PRINT
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se ? D, se non lo ?, formattazione errata, passo a prossima istruzione
    
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
        bne t1 t2 check_del              # controllo se ? P, se non lo ?, formattazione errata, passo a prossima istruzione
        
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
        bne t1 t2 check_rev               # controllo se ? D, se non lo ?, formattazione errata, passo a prossima istruzione
        
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
        blt a2 t2 check_next_instruction  # if < 32, TODO, ma non ? 47 < x < 58 ? 
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
        bne t1 t2 check_s                           # controllo se ? R, se non lo ?, formattazione errata, passo a prossima istruzione
        
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
        bne t1 t2 check_next_instruction  # controllo se ? S, se non lo ?, formattazione errata, passo a prossima istruzione
        
        addi a1 a1 1
        
        lb t1 0(a1)
        li t2 79
        beq t1 t2 check_sort              # controllo se ? O di sort
        
        lb t1 0(a1)
        li t2 86
        beq t1 t2 check_sdx               # controllo se ? V di svx
        
        lb t1 0(a1)
        li t2 83
        beq t1 t2 check_ssx               # controllo se ? S di ssx
        
        j check_next_instruction

    check_sort:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # controllo se ? R, se non lo ?, formattazione errata, passo a prossima istruzione        
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se ? T
        
        jal x1, check_spaces
        
        j SORT

    check_sdx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se ? X, se non lo ?, formattazione errata, passo a prossima istruzione
 
        jal x1, check_spaces
        
        j SDX   

    check_ssx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se ? X, se non lo ?, formattazione errata, passo a prossima istruzione
 
        jal x1, check_spaces
        
        j SSX   

    check_spaces:          
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces
            jalr x0, x1, 0

    check_next_instruction:
            lb t1 0(a1)                 # ciclo che continua finch? non trova ~ e prosegue il parsing, o null e chiude il programma
            
            li t2 0                     # null                        
            beq t1 t2 exit
            
            li t2 126                   # tilda
            beq t1 t2 next_instruction
            
            addi a1 a1 1
            
            j check_next_instruction
            
    next_instruction:
        addi a1, a1, 1
        j PARSING


        
# OPERAZIONI    

ADD:
    jal address_generator        # genero l'indirizzo in cui salvare il nodo. Indirizzo in a3
    
    bne s1 zero not_first_ADD    
    
    add s1 a3 zero               # Aggiorno il puntatore alla testa
    add s2 a3 zero               # Aggiorno il puntatore alla coda
    lw t0 1(a3)
    sb a2 0(a3)                  # Salvo DATA
    sw t0 1(a3)                  # Salvo PAHEAD (che punta su se stesso)
    
    addi s3 s3 1                 # Incrementa il puntatore di 1
    j check_next_instruction
    
    not_first_ADD:
        sb a2 0(a3)              # Salvo DATA
        sw s1 1(a3)              # Salvo PAHEAD
        sw a3 1(s2)              # Aggiorno PAHEAD del nodo precedente
        add s2 a3 zero           # aggiorno il puntatore alla coda

        addi s3 s3 1                 # Incrementa il puntatore di 1
        j check_next_instruction


PRINT:
    add t1 s1 zero               # t1 = testa
    beq t1 zero check_next_instruction
    
    la a0 squareL                # Stampa "["
    li a7 4
    ecall
    
    PRINT_loop:
        beq t1 s2 new_line       # Controllo quando arrivo all'ultimo elemento
        
        lb a0 0(t1)              # Stampa DATA
        li a7 11        
        ecall
        la a0 space              # Stampa una spazio
        li a7 4
        ecall
        
        lw t1 1(t1)              # Prossimo nodo
        j PRINT_loop
        new_line:
            lb a0 0(t1)          # Stampa l'ultimo elemento
            li a7 11        
            ecall
            la a0 squareR        # Stampa "]"
            li a7 4
            ecall
            la a0 newline
            li a7 4
            ecall
            j check_next_instruction


DEL: 
    add t0 s1 zero                  # Nodo attuale
    beq t0 zero check_next_instruction
    add t1 s2 zero                  # nodo precedente
    addi t4 zero 0                    # Contatore ciclo
    DEL_loop:
        lb t2 0(t0)                 # carico il valore del nodo
        beq a2 t2 delete_element
        lw t0 1(t0)                 # passo al nodo successivo
        lw t1 1(t1)                 # aggiorno anche il precedente        
        addi t4 t4 1                # incremento il contatore
        beq t4 s3 check_next_instruction
        j DEL_loop

    delete_element:
        lw t3 1(t0)                 # PAHEAD
        #beq t0 t4 del_first_element # Se PBACK punta a null, allora sto esaminando il primo elemento
        #beq t0 t5 del_last_element  # Se PAHEAD punta a null, allora sto esaminando l'ultimo elemento
        sw t3 1(t1)                 # Carico il PAHEAD attuale nel PAHEAD del nodo precedente
        sb zero 0(t0)               # Azzero il dato
        sw zero 1(t0)               # Azzero PAHEAD
        addi s3 s3 -1               # Decremento il contatore globale
        addi t4 t4 1                # Incremento il contatore del ciclo
        j check_next_instruction    # Passo all'istruzione successiva

    del_first_element:
        beq t0 t5 del_only_element
        sw t0 0(t5)

        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s1 t5 zero
        j check_next_instruction

    del_only_element:
        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s1 zero zero
        j check_next_instruction

    del_last_element:
        sw t0 5(t4)
        sw zero 0(t1)
        sb zero 4(t1)
        sw zero 5(t1)
        add s2 t4 zero
        j check_next_instruction



REV:
    li t0 0xffffffff
    beq s1 zero check_next_instruction
    add t1 s1 zero
    REV_loop:
        lw t4 0(t1)
        lw t5 5(t1)
        add t3 t5 zero 
        sw t4 5(t1)
        sw t5 0(t1)
        beq t1 t0 head_rear_swap
        add t1 t3 zero
        j REV_loop
        
    head_rear_swap:
        add t2 s2 zero
        add s2 s1 zero
        add s1 t2 zero
        j check_next_instruction


# TODO: controllare che i parametri di ordinamento combacino: A > a > 1 > *
# TODO: ? crescente? La procedura deve essere ricorsiva
SORT:
    beq s1 zero check_next_instruction
    add t1 s1 zero
    li t0 0

    SORT_loop:
        lb a4 4(t1)
        lw t3 5(t1)
        lb a5 4(t3)
        li t5 0xffffffff
        beq t3 t5 check_swapped
        jal swap_check
        bne a2 zero swap_element
        add t1 t3 zero
        j SORT_loop

    swap_element:
        sb a4 4(t3)
        sb a5 4(t1)
        li t0 1
        add t1 t3 zero
        j SORT_loop
    check_swapped:
        beq t0 zero check_next_instruction
        j SORT



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
    
    # controllo se la memoria ? libera
    
    #lw t1 0(t0)                   
    #bne t1 zero address_generator # byte 0-3 (PBACK)
    #lb t1 4(t0)
    #bne t1 zero address_generator # byte 4 (DATA)        # vecchio codice per linked list
    #lw t1 4(t0)
    #bne t1 zero address_generator # byte 5-8 (PAHEAD)
    #jr ra
    
    lb t1 0(t0)    # byte 0 (DATA)
    bne t1 zero address_generator
    lw t1 1(t0)    # byte 1-4 (PAHEAD)
    bne t1 zero address_generator
    jr ra



swap_check:
    check_first:
        li t2 65
        blt a4 t2 check_number_first
        li t2 90
        bgt a4 t2 check_minuscola_first
        li t4 4
        j check_second

    check_minuscola_first:
        li t2 97
        blt a4 t2 set_special_char_first
        li t2 122
        bgt a4 t2 set_special_char_first
        li t4 3
        j check_second

    check_number_first:
        li t2 48
        blt a4 t2 set_special_char_first
        li t2 57
        bgt a4 t2 set_special_char_first
         li t4 2
        j check_second
    set_special_char_first:
        li t4 1

    check_second:
        li t2 65
        blt a5 t2 check_number_second
        li t2 90
        bgt a5 t2 check_minuscola_second
        li t6 4
        j check_priority
    check_minuscola_second:
        li t2 97
        blt a5 t2 set_special_char_second
        li t2 122
        bgt a5 t2 set_special_char_second
        li t6 3
        j check_priority
    check_number_second:
        li t2 48
        blt a5 t2 set_special_char_second
        li t2 57
        bgt a5 t2 set_special_char_second
        li t6 2
        j check_priority
    set_special_char_second:
        li t6 1
    check_priority:
        li a2 0
        bgt t4 t6 set_swapper
        beq t4 t6 check_elements
        jr ra

    check_elements:
        bgt a4 a5 set_swapper
        jr ra
    set_swapper:
        li a2 1
        jr ra



exit:
    li a7, 10
    ecall
    