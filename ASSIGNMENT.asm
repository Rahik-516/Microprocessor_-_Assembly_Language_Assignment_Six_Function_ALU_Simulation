.MODEL SMALL
.STACK 100H
.DATA  
 FIRST_OP_STR DW "Enter 1st operand: $"
 SECOND_OP_STR DW "Enter 2nd operand: $"
 OPR_STR DW "Select the operation: $"
 RES_STR DW "Result: $"
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, FIRST_OP_STR
    INT 21H
    
    
    CALL BINARY_INPUT
    PUSH BX 
    
    MOV AH, 9
    LEA DX, SECOND_OP_STR
    INT 21H
    
    
    CALL BINARY_INPUT
    PUSH BX
   
    
    MOV AH, 9
    LEA DX, OPR_STR
    INT 21H
    
    CALL BINARY_INPUT
    
    MOV CL, BL 
    
    POP BX
    POP AX 
    
    CALL OPERATION 
    
    MOV AH, 9
    LEA DX, RES_STR
    INT 21H
    
    CMP CL , 100b
    JE PRINT_DOUBLE_RES
    JNE PRINT_SINGLE_RES
    
    PRINT_DOUBLE_RES:
    CALL BINARY_OUTPUT
    MOV BH, BL
    
    CALL NEWLINE
    
    MOV AH, 9
    LEA DX, RES_STR
    INT 21H

    
        
    CALL BINARY_OUTPUT
    JMP EXIT
    
    PRINT_SINGLE_RES:
    CALL BINARY_OUTPUT
    
    
      
    
    
  
    
    
    
    EXIT:
    MOV AH, 4CH
    INT 21H
    MAIN ENDP


NEWLINE PROC
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    RET
    NEWLINE ENDP 

BINARY_INPUT PROC
    XOR BH, BH
    XOR BL, BL           
    MOV CX, 8           

    READ_LOOP:
        MOV AH, 1
        INT 21H          

        CMP AL, 13       
        JE END_LOOP

        SHL BL, 1        

        CMP AL, '1'
        JE SET_ONE
        CMP AL, '0'
        JE CONTINUE
        JMP READ_LOOP    

    SET_ONE:
        OR BL, 1         

    CONTINUE:
        LOOP READ_LOOP   
    END_LOOP:
        CALL NEWLINE
        RET
BINARY_INPUT ENDP 

OPERATION PROC
    CMP CL, 0b
    JE ADD_LABEL
    CMP CL, 1b
    JE SUB_LABEL
    CMP CL, 10b
    JE AND_LABEL
    CMP CL, 11b
    JE OR_LABEL
    CMP CL, 100b
    JE NOT_LABEL
    CMP CL, 101b
    JE XOR_LABEL
    
    ADD_LABEL:
    ADD AL, BL
    MOV BH, AL
    JMP E_
    
    SUB_LABEL:
    SUB AL, BL
    MOV BH, AL
    JMP E_
    
    AND_LABEL:
    AND AL, BL
    MOV BH, AL
    JMP E_
    
    OR_LABEL:
    OR AL, BL
    MOV BH, AL
    JMP E_
    
    NOT_LABEL:
    NOT AL
    MOV BH, AL 
    NOT BL
    JMP E_
    
    XOR_LABEL:
    XOR AL, BL
    MOV BH, AL 
          
    E_:
    RET
    OPERATION ENDP


BINARY_OUTPUT PROC
    MOV CX, 8           

    PRINT:
        SHL BH, 1        
        JC ONE
        JNC ZERO

    ONE:
        MOV AH, 2
        MOV DL, '1'
        INT 21H
        JMP LOOP_LABEL

    ZERO:
        MOV AH, 2
        MOV DL, '0'
        INT 21H

    LOOP_LABEL:
        LOOP PRINT
        RET 
BINARY_OUTPUT ENDP 


END MAIN