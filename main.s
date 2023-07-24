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
        li t2 32                # 32 è 'spazio' in ASCII
        bne t1 t2 check_add     # se non è uno spazio, jump
        addi a1 a1 1            # carattere successivo
        j check_initial_spaces
        
    check_add:
        lb t1 0(a1)
        li t2 65
        bne t1 t2 CHECK_PRINT            # controllo se è A, altrimenti passo alla prossima, PRINT
        
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
        bne t1 t2 check_next_instruction # controllo se è parantesiL, altrimenti formattata male
        
            
        CHECK_PRINT:
            j main
            
        check_next_instruction:
            j main