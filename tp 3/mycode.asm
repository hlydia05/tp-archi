
Don Segment 
    
    A DB 13h
    B DB 15h
    
Don ends

Code Segment
    
    assume CS:Code, DS:Don
    
Main:
    
    mov ax,don
    mov ds,ax
    
    mov al,A
    add al,B
             
    
    ;affichage du resultat bit par bit
    mov cx,8
    affiche:
    test bl,80h
    jz zero
    mov dl,31h
    mov ah,02h
    int 21h
    jmp 
    
    zero:
    mov dl,30h
    mov ah,12h
        
    
    
    
Fin : MOV AH, 4CH 
      int 21H      
      
Code ENDS ; 
END main



