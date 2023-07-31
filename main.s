# ricordati di fixare tutti i TODO!!!
# controlla coerenza nomi funzioni etc
# per relazione, parlare della formattazione del codice

.data
listInput: .string "ADD(3)~PRINT~SSX"
lfsr: .word 372198

newline: .string "\n"

.text

lw s0 lfsr        # Non so cosa siano le 
li s1 0           # prime tre variabili
li s2 0           #
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
        bne t1 t2 check_print            # controllo se è A, altrimenti passo alla prossima, PRINT
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se è D, se no, è formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se è D, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # controllo se è parantesiL, altrimenti formattata male
        
        addi a1 a1 1
        lb a2 0(a1)                      # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32, TODO, ma non è 47 < x < 58 ? 
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # controllo se è parantesiR, altrimenti formattata male
        
        check_spaces_after_ADD:          # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_ADD
        
        j ADD



    check_print:
        lb t1 0(a1)
        li t2 80
        bne t1 t2 check_del              # controllo se è P, altrimenti passo alla prossima, MISSING??? TODO
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # controllo se è R, se no, è formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 73
        bne t1 t2 check_next_instruction # controllo se è I, //        

        addi a1 a1 1
        lb t1 0(a1)
        li t2 78
        bne t1 t2 check_next_instruction # controllo se è N, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se è T, //
        
        check_spaces_after_PRINT:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_PRINT
        
        j PRINT



    check_del:
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_rev              # controllo se è D, altrimenti passo alla prossima, MISSING
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction  # controllo se è E, se no, è formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 76
        bne t1 t2 check_next_instruction  # controllo se è L, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # controllo se è parantesiL, altrimenti formattata male
        
        addi a1 a1 1
        lb a2 0(a1)                      # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32, TODO, ma non è 47 < x < 58 ? 
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # controllo se è parantesiL, altrimenti formattata male
        
        check_spaces_after_DEL:          # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_DEL
        
        j DEL



    check_rev:
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_s            # controllo se è R
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction            # controllo se è E, se no, è formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 86
        bne t1 t2 check_next_instruction            # controllo se è R, //        
     
        check_spaces_after_REV:                     # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_REV
        
        j REV



    check_s:
        lb t1 0(a1)
        li t2 83
        bne t1 t2 check_next_instruction  # controllo se è S, altrimenti passo alla prossima, rev
        
        addi a1 a1 1
        
        lb t1 0(a1)
        li t2 79
        beq t1 t2 check_sort              # controllo se è O di sort, se no, prossima
        
        lb t1 0(a1)
        li t2 86
        beq t1 t2 check_sdx               # controllo se è V di svx, se no, prossima
        
        lb t1 0(a1)
        li t2 83
        beq t1 t2 check_ssx               # controllo se è S di ssx, se no, avanti
        
        j check_next_instruction
        
        
        

    check_sort:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # controllo se è R        
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se è T, //
        
        check_spaces_after_SORT:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_SORT
        
        j SORT



    check_sdx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se è X, se no, è formattata male, prossima istruzione
 
        check_spaces_after_sdx:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_sdx
        
        j SDX   



    check_ssx:
        addi a1 a1 1
        lb t1 0(a1)
        li t2 88
        bne t1 t2 check_next_instruction # controllo se è X, se no, è formattata male, prossima istruzione
 
        check_spaces_after_ssx:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_ssx
        
        j SSX   



    check_next_instruction:
            lb t1 0(a1)     # ciclo che continua finchè non trova ~ e proseguie il decoding, o null e chiude il programma
            
            li t2 0         # null                        
            beq t1 t2 exit
            
            li t2 126       # tilda
            beq t1 t2 next_instruction
            
            addi a1 a1 1
            
            j check_next_instruction
            
    next_instruction:
        addi a1, a1, 1
        j DECODING


        
# OPERAZIONI    
ADD:
    j check_next_instruction



PRINT:
    j check_next_instruction



DEL:
    j check_next_instruction



REV:
    j check_next_instruction



SORT:
    j check_next_instruction



SDX:
    j check_next_instruction



SSX:
    j check_next_instruction



exit:
    li a7, 1    # ecall with a7 = 1 means print
    ecall
    