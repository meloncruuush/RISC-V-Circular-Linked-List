# ricordati di fixare tutti i TODO!!!
# controlla coerenza nomi funzioni etc
# per relazione, parlare della formattazione del codice

.data
listInput: .string "ADD(1)~ADD(a)~ADD()~ADD(B)~ADD~ADD(9)~PRINT~SORT(a)~PRINT~DEL(bb)~DEL(B)~ PRINT~REV~PRINT"
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
        li t2 32                # 32 � 'spazio' in ASCII
        bne t1 t2 check_add     # se non � uno spazio, jump
        addi a1 a1 1            # carattere successivo
        j check_initial_spaces



    check_add:
        lb t1 0(a1)
        li t2 65
        bne t1 t2 check_print            # controllo se � A, altrimenti passo alla prossima, PRINT
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se � D, se no, � formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_next_instruction # controllo se � D, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # controllo se � parantesiL, altrimenti formattata male
        
        addi a1 a1 1
        lb a2 0(a1)                      # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32, TODO, ma non � 47 < x < 58 ? 
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # controllo se � parantesiR, altrimenti formattata male
        
        check_spaces_after_ADD:          # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_ADD
        
        lb t1 0(a1)
        li t2 126                         # ASCII tilda
        beq t1 t2 ADD                     # decoding completo, valore salvato, procediamo con ADD
        
        lb t1 0(a1)                       # perch� carico di nuovo? posso togliere? TODO
        li t2 0                           # ASCII null, fine stringa input
        bne t1 t2 check_next_instruction  # se non � null, prossima istruzione
        j ADD                             # perch�?



    check_print:
        lb t1 0(a1)
        li t2 50
        bne t1 t2 check_del              # controllo se � P, altrimenti passo alla prossima, MISSING??? TODO
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 52
        bne t1 t2 check_next_instruction # controllo se � R, se no, � formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 49
        bne t1 t2 check_next_instruction # controllo se � I, //        

        addi a1 a1 1
        lb t1 0(a1)
        li t2 78
        bne t1 t2 check_next_instruction # controllo se � N, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se � T, //
        
        check_spaces_after_PRINT:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_PRINT
        
        lb t1 0(a1)
        li t2 126                         # ASCII tilda
        beq t1 t2 PRINT                   # decoding completo, valore salvato, procediamo con PRINT
        
        lb t1 0(a1)                       # perch� carico di nuovo? posso togliere? TODO
        li t2 0                           # ASCII null, fine stringa input
        bne t1 t2 check_next_instruction  # se non � null, prossima istruzione
        j PRINT                           # perch�?



    check_del:
        lb t1 0(a1)
        li t2 68
        bne t1 t2 check_SORT              # controllo se � D, altrimenti passo alla prossima, MISSING
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction  # controllo se � E, se no, � formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 76
        bne t1 t2 check_next_instruction  # controllo se � L, //
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 40
        bne t1 t2 check_next_instruction # controllo se � parantesiL, altrimenti formattata male
        
        addi a1 a1 1
        lb a2 0(a1)                      # questa volta salvo il carattere in a2
        li t2 32
        blt a2 t2 check_next_instruction # if < 32, TODO, ma non � 47 < x < 58 ? 
        li t2 125
        bgt a2 t2 check_next_instruction # if > 125
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 41
        bne t1 t2 check_next_instruction # controllo se � parantesiL, altrimenti formattata male
        
        check_spaces_after_DEL:          # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_DEL
        
        lb t1 0(a1)
        li t2 126                         # ASCII tilda
        beq t1 t2 ADD                     # decoding completo, valore salvato, procediamo con DEL
        
        lb t1 0(a1)                       # perch� carico di nuovo? posso togliere? TODO
        li t2 0                           # ASCII null, fine stringa input
        bne t1 t2 check_next_instruction  # se non � null, prossima istruzione
        j DEL                             # perch�?



    check_sort:
        lb t1 0(a1)
        li t2 83
        bne t1 t2 check_rev              # controllo se � S, altrimenti passo alla prossima, rev
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 79
        bne t1 t2 check_next_instruction # controllo se � O, se no, � formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction # controllo se � R, //        
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 84
        bne t1 t2 check_next_instruction # controllo se � T, //
        
        check_spaces_after_SORT:        # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_SORT
        
        lb t1 0(a1)
        li t2 126                         # ASCII tilda
        beq t1 t2 SORT                    # decoding completo, valore salvato, procediamo con SORT
        
        lb t1 0(a1)                       # perch� carico di nuovo? posso togliere? TODO
        li t2 0                           # ASCII null, fine stringa input
        bne t1 t2 check_next_instruction  # se non � null, prossima istruzione
        j SORT                            # perch�?



    check_rev:
        lb t1 0(a1)
        li t2 82
        bne t1 t2 check_next_instruction            # controllo se � R
        
        addi a1 a1 1
        lb t1 0(a1)
        li t2 69
        bne t1 t2 check_next_instruction            # controllo se � E, se no, � formattata male, prossima istruzione
    
        addi a1 a1 1
        lb t1 0(a1)
        li t2 86
        bne t1 t2 check_next_instruction            # controllo se � R, //        
     
        check_spaces_after_REV:                     # ciclo, come riusarlo anche per le altre? TODO
            addi a1 a1 1
            lb t1 0(a1)
            li t2 32
            beq t1 t2 check_spaces_after_REV
        
        lb t1 0(a1)
        li t2 126                         # ASCII tilda
        beq t1 t2 REV                     # decoding completo, valore salvato, procediamo con REV
        
        lb t1 0(a1)                       # perch� carico di nuovo? posso togliere? TODO
        li t2 0                           # ASCII null, fine stringa input
        bne t1 t2 check_next_instruction  # se non � null, prossima istruzione
        j REV                             # perch�?



    check_next_instruction:
            j main






        
# OPERAZIONI    
ADD:
    j main



PRINT:
    j main



DEL:
    j main



SORT:
    j main



REV:
    j main