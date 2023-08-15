.data
# listInput: .string "ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~     ADD(9) ~SSX~SORT~PRINT~DEL(b)~DEL(B) ~PRI~SDX~REV~PRINT"
# listInput: .string "ADD(1) ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~PRINT~SORT(a)~PRINT~DEL(bb)~DEL(B) ~PRINT~REV~SDX~PRINT"

# Test ADD
# listInput: .string "ADD(a)~PRINT~ADD(b)~PRINT~ADD(c)~PRINT~ADD(d)~~ADD(e)~~ADD(f)~~ADD(g)~~ADD(h)~~ADD(i)~~ADD(j)~PRINT~ADD(k)~PRINT"
# Test DEL
# listInput: .string "ADD(a)~PRINT~DEL(a)~PRINT~ADD(a)~ADD(b)~ADD(a)~PRINT~DEL(a)~DEL(b)~DEL(c)~PRINT~ADD(a)~ADD(b)~ADD(b)~ADD(c)~PRINT~DEL(b)~PRINT "
# Test REV
# listInput: .string "REV~PRINT~ADD(a)~PRINT~REV~ADD(c)~ADD(x)~ADD(b)~ADD(h)~PRINT~REV~PRINT~DEL(c)~PRINT~REV~PRINT"
# Test SSX
# listInput: .string "SSX~PRINT~ADD(a)~PRINT~SSX~ADD(c)~ADD(x)~ADD(b)~ADD(h)~PRINT~SSX~PRINT~DEL(c)~PRINT~SSX~PRINT"
# Test SDX
 listInput: .string "SDX~PRINT~ADD(a)~PRINT~SDX~ADD(c)~ADD(x)~ADD(b)~ADD(h)~PRINT~SDX~PRINT~DEL(c)~PRINT~SDX~PRINT"
# Test SORT
# listInput: .string "SORT~PRINT~ADD(a)~PRINT~SORT~ADD(C)~ADD(.)~ADD(b)~ADD(1)~PRINT~SORT~PRINT~ADD(b)~ADD(b)~ADD(b)~PRINT~SORT~PRINT"
# Test formattazione errata
# listInput: .string "ADD(a)~PRIT~add(b)~PRINT~AD D(c)~PRINT~ADD(d)~rev~ADD(f)~SOLT~ADD(h)~SdX~ADD(j)~PRINT~ADD(k)~PRINT"


lfsr:      .word 612178    # Seme del generatore di indirizzi, è un numero casuale

newline:   .string "\n"
space:     .string " "
squareL:   .string "[ "
squareR:   .string "]"

.text

lw s0 lfsr        # Seme del generatore di indirizzi
li s1 0           # Puntatore alla testa
li s3 0           # Contatore numero elementi della lista
la s4 listInput   

add a1 s4 zero    # Carico il primo carattere in a1

PARSING:
    check_initial_spaces:
        lb t1 0(a1)             # Carattere ora in t1
        li t2 32                # 32 è 'spazio' in ASCII
        bne t1 t2 check_add     # se non è uno spazio, jump
        addi a1 a1 1            # carattere successivo
        j check_initial_spaces  # ripeti

    check_add:
        lb t1 0(a1)
        li t2 65
        bne t1 t2 check_print            # controllo se è A, altrimenti passo
                                         # al controllo di P per PRINT
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se è D. Se non lo è, la formattazione è errata, 
                                         # passo alla prossima istruzione
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # D
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # parentesiL
        
        addi a1 a1 1
        lb a2 0(a1)                      # salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # parantesiR
        
        jal check_spaces
        jal ADD
        j check_next_instruction

    check_print:
        lb t1 0(a1)
        li t2 80
        bne t1 t2 check_del              # controllo se è A, altrimenti passo
                                         # al controllo di D per DEL
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
        
        jal check_spaces
        jal PRINT
        j check_next_instruction

    check_del:
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_rev               # controllo se è D, altrimenti passo
                                          # al controllo di R per REV
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
        lb a2 0(a1)                       # salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction  # if < 32, TODO, ma non è 47 < x < 58 è 
        li t2 125
        bgt a2 t2 check_next_instruction  # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction  # parentesiR
        
        jal check_spaces
        jal DEL
        j check_next_instruction

    check_rev:
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_s                           # controllo se è R, altrimenti passo
                                                    # al controllo di S per le istruzioni S
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction            # E
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 86
        bne t1 t2 check_next_instruction            # R
     
        jal check_spaces
        jal REV
        j check_next_instruction

    check_s:
        lb t1 0(a1)
        li t2 83
        bne t1 t2 check_next_instruction  # controllo se è S, se non lo è, 
                                          # formattazione errata, passo alla prossima istruzione
        addi a1 a1 1
        lb t1 0(a1)
        li t2 79
        beq t1 t2 check_sort              # controllo se è O di SORT
        
        lb t1 0(a1)
        li t2 68
        beq t1 t2 check_sdx               # controllo se è D di SDX
        
        lb t1 0(a1)
        li t2 83
        beq t1 t2 check_ssx               # controllo se è S di SSX
        
        j check_next_instruction          # formattazione errata

    check_sort:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction  # controllo se è R, se non lo è, 
                                          # formattazione errata, passo alla prossima istruzione
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction  # controllo se è T
        
        jal check_spaces
        jal SORT
        j check_next_instruction

    check_sdx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction  # controllo se è X, se non lo è, 
                                          # formattazione errata, passo alla prossima istruzione
 
        jal check_spaces
        jal SDX   
        j check_next_instruction

    check_ssx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction  # controllo se è X, se non lo è, 
                                          # formattazione errata, passo alla prossima istruzione
 
        jal check_spaces
        jal SSX   
        j check_next_instruction

    check_spaces:          
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces
            jr ra

    check_next_instruction:             # ciclo che continua finchè non trova ~ e prosegue il parsing, 
            lb t1 0(a1)                 # o null e chiude il programma
            li t2 0                                             
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
    addi sp, sp -4               # creo spazio nella stack
    sw ra 4(sp)                  # metto il ra nella stack, visto che devo fare un'altra jal
    jal address_generator        # genero l'indirizzo in cui salvare il nodo. Indirizzo in a3
    lw ra 4(sp)                  # al ritorno, riprendo ra dallo stack 
    addi sp sp 4                 # restore dello stack
    
    bne s1 zero not_first_ADD    
    add s1 a3 zero               # Aggiorno il puntatore alla testa
    sb a2 0(a3)                  # Salvo DATA
    sw s1 1(a3)                  # Salvo PAHEAD (che punta su se stesso)
    addi s3 s3 1                 # Incrementa il contatore di 1
    jr ra
    
    not_first_ADD:
        sb a2 0(a3)              # Salvo DATA
        sw s1 1(a3)              # Salvo PAHEAD (ultimo nodo punta sempre alla testa)       
        
        addi sp, sp -4           # creo spazio nella stack
        sw ra 4(sp)              # metto il ra nella stack, visto che devo fare un'altra jal
        jal get_last_node
        lw ra 4(sp)              # al ritorno, riprendo ra dallo stack 
        addi sp sp 4             # restore dello stack
        
        add t2 a0 zero           # Nodo precedente
        sw a3 1(t2)              # Aggiorno PAHEAD del nodo precedente
        addi s3 s3 1             # Incrementa il contatore di 1
        jr ra

PRINT:
    la a0 squareL                # Stampa "["
    li a7 4
    ecall
    add t1 s1 zero               # t1 = testa
    beq t1 zero end_print    
    addi t0 zero 0               # Inizializzo il contatore
    PRINT_loop:
        beq t0 s3 end_print       # Controllo quando arrivo all'ultimo elemento
        lb a0 0(t1)              # Stampa DATA
        li a7 11        
        ecall
        la a0 space              # Stampa SPACE
        li a7 4
        ecall
        lw t1 1(t1)              # Prossimo nodo
        addi t0 t0 1
        j PRINT_loop
        end_print:
            la a0 squareR        # Stampa "]"
            li a7 4
            ecall
            la a0 newline
            li a7 4
            ecall
            jr ra

DEL: 
    addi sp, sp -4                  # creo spazio nella stack
    sw ra 4(sp)                     # metto il ra nella stack, visto che devo fare un'altra jal
    jal get_last_node
    lw ra 4(sp)                     # al ritorno, riprendo ra dallo stack 
    addi sp sp 4                    # restore dello stack
    add t1 a0 zero                  # Nodo precedente
    add t0 s1 zero                  # Nodo attuale
    beq t0 zero end_del             
    addi t4 zero 0                  # Contatore ciclo (i = 0)
    addi t5 s3 0                    # t5 = list.size
    DEL_loop:
        lb t2 0(t0)                 # carico il valore del nodo
        beq a2 t2 delete_element
        lw t0 1(t0)                 # passo al nodo successivo
        lw t1 1(t1)                 # aggiorno anche il precedente        
        addi t4 t4 1                # incremento il contatore
        bge t4 t5 end_del           
        j DEL_loop

    delete_element:
        lw t3 1(t0)                 # PAHEAD
        beq t0 s1 del_first_element 
        sw t3 1(t1)                 # Carico il PAHEAD attuale nel PAHEAD del nodo precedente
        sb zero 0(t0)               # Azzero DATA
        sw zero 1(t0)               # Azzero PAHEAD
        lw t0 1(t1)                 
        addi s3 s3 -1               # Decremento il contatore globale
        addi t4 t4 1                # Incremento il contatore del ciclo
        j DEL_loop                  

    del_first_element:
        beq t0 t3 del_only_element    
        sw t3 1(t1)                 # Salvo PAHEAD nel precedente
        sb zero 0(t0)               # Azzero DATA
        sw zero 1(t0)               # Azzero PAHEAD
        lw t0 1(t1)
        add s1 t3 zero              # Aggiorno testa global (la nuova testa è il successivo)
        addi s3 s3 -1               # Decremento il contatore globale
        addi t4 t4 1                # Incremento il contatore del ciclo
        j DEL_loop

    del_only_element:
        sb zero 0(t0)               # Azzero DATA
        sw zero 1(t0)               # Azzero PAHEAD
        add s1 zero zero            # Azzero S1, non ci sono piè elementi nella lista
        addi s3 s3 -1               # Decremento il contatore globale
        j end_del
        
    end_del:
        jr ra

REV:    
    add t0 s1 zero                  # NodoL
    beq t0 zero end_rev
    addi t1 zero 0                  # IndexL
    addi t4 s3 -1                   # IndexR
    REV_cycle:
        bge t1 t4 end_rev           # if indiceL >= indice
        add t3 s1 zero              # Inizializzo NodoR
        addi t6 zero 0 
        get_nodeR:                  # Scorre la lista fino ad arrivare alla coda  
            lw t3 1(t3)             
            addi t6 t6 1            
            bne t6 t4 get_nodeR
               
        lb t2 0(t0)                 #
        lb t5 0(t3)                 # Swap dei valori
        sb t5 0(t0)                 #
        sb t2 0(t3)                 #
        
        lw t0 1(t0)     # NodoL.next
        addi t1 t1 1    # IndexL++
        addi t4 t4 -1   # IndexR-- 
        j REV_cycle
    
    end_rev:
        jr ra

SORT:
    beq s1 zero end_sort
    add t1 s1 zero                  # puntatore alla testa
    li t0 0                         # flag = 0 (0=nessuno scambio fatto nel ciclo, 1=scambio fatto nel ciclo)
    SORT_loop:
        lb a4 0(t1)                 # primo elemento da confrontare
        lw t3 1(t1)                 # puntatore al successivo
        lb a5 0(t3)                 # secondo elemento da confrontare
        beq t3 s1 check_swapped     # se il successivo è la testa, siamo all'ultimo elemento
        
        addi sp, sp -4                  # creo spazio nella stack
        sw ra 4(sp)                     # metto il ra nella stack, visto che devo fare un'altra jal
        jal swap_check 
        lw ra 4(sp)                     # al ritorno, riprendo ra dallo stack 
        addi sp sp 4                    # restore dello stack
        
        bne a2 zero swap_element
        add t1 t3 zero
        j SORT_loop
    swap_element:
        sb a4 0(t3)
        sb a5 0(t1)
        li t0 1
        add t1 t3 zero              # passa al nodo successivo
        j SORT_loop
    check_swapped:
        beq t0 zero end_sort        # se non sono stati effettuati scambi, concludi
        j SORT
    end_sort:    
        jr ra

SVX:
    addi sp, sp -4                  # creo spazio nella stack
    sw ra 4(sp)                     # metto il ra nella stack, visto che devo fare un'altra jal
    jal get_last_node
    lw ra 4(sp)                     # al ritorno, riprendo ra dallo stack 
    addi sp sp 4                    # restore dello stack
    
    add t6 a0 zero                  # Nodo precedente
    add t0 s1 zero                  # testa
    beq t0 zero end_sdx
    add t3 t6 zero                  # coda
    lb t2 0(t3)                     # val_prec
    addi t4 zero 0                  # contatore
    SDX_loop:
        lb t1 0(t0)                 # valore attuale
        sb t2 0(t0)                 # carico valore precedente nel nodo
        add t2 t1 zero              # aggiorno il valore precedente, che ora è il valore attuale
        lw t0 1(t0)                 # prossimo nodo
        addi t4 t4 1                # incremento il contatore
        bne t4 s3 SDX_loop 
    end_sddx:
        jr ra    
        
SDX:
    addi sp, sp -4                  # creo spazio nella stack
    sw ra 4(sp)                     # metto il ra nella stack, visto che devo fare un'altra jal
    jal get_last_node
    lw ra 4(sp)                     # al ritorno, riprendo ra dallo stack 
    addi sp sp 4                    # restore dello stack    
    
    add t0 s1 zero                  # testa
    add t1 a0 zero                  # coda
    beq t0 zero end_sdx             # lista vuota
    addi t2 zero 1
    beq s3 t2 end_sdx               # lista con un solo elemento
      
    add s1 t1 zero                  # ora la testa è l'ultimo nodo
    end_sdx:
        jr ra        
        
SSX:
    add t0 s1 zero                  
    beq t0 zero end_ssx             # lista vuota
    addi t1 zero 1
    beq s3 t1 end_ssx               # lista con un solo elemento
    lw t2 1(t0)                     # carico il secondo nodo 
    add s1 t2 zero                  # ora la testa è il secondo nodo
    end_ssx:
        jr ra

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
    # controllo se la memoria è libera:
    lb t1 0(t0)                    # byte 0 (DATA)
    bne t1 zero address_generator
    lw t1 1(t0)                    # byte 1-4 (PAHEAD)
    bne t1 zero address_generator
    jr ra

get_last_node:
    add t0 s1 zero                         # testa
    addi t1 zero 1                          
    beq s3 t1 get_last_node_go_back        # se c'è un solo elemento, il primo elemento è anche la coda
    addi t1 zero 1                          
    get_last_node_loop:
        lw t0 1(t0)                        
        addi t1 t1 1                       
        blt t1, s3, get_last_node_loop     
    get_last_node_go_back:
        add a0 t0 zero                     # coda in a0, return
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