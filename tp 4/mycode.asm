
data SEGMENT
    A db 130
    B db 150
    res dw 0
    ;resC dw 0000000100000000b
data Ends    
              
    
code SEGMENT        
    
    Assume: CS:code , DS:data 
    
    Main:
    MOV AX, data
    MOV DS, AX
    
    MOV ax,A
    xor bx,bx
    add ax,bx
    
     
    MOV ah, 0
    
    mov res,ax
     
    mov cx,16
    
    affiche: mov ah,2
    mov dx,0
    test bx,8000h
    
    
    
    fin:    
    MOV AH,4CH
    int 21H
code Ends 
    End Main




