.data
listInput: .string "ADD~DEL~PRINT"


.text

main:
    j DECODING:
    
DECODING:
    check_initial_spaces:
        lb t1 0(a1)
        li t2 32
        bne t1 t2 CHECK_ADD
        addi a1 a1 1
        j check_initial_spaces