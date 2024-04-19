
data segment 
    
      message db " la routine est installee avec succes ",10,13,'$'
      numVect equ 60h
    
data ends


code segment  
    
    assume cs:code, ds:data, ss:stack
    
    
    
    
start:
      
    mov ax,data
    mov ds,ax 
    
    call installroutine60H  
    
    int 60H 
    
    
    mov ah,4ch
    int 21h  
    
    ;declaration
    installroutine60H proc
        
        push ds
        push bx
        push ax
        push cx
        ;passer du ds=0000h
        xor ax,ax
        mov ds,ax
        mov bx,numVect
        mov cl,02h
        shl bx,cl
        mov word ptr[bx],offset routine60H
        mov word ptr[bx+2],cs
        
        pop cx
        pop ax
        pop bx
        pop ds
        
        ret 
        
        installroutine60H endP  
    
     
      routine60H:
      
          push ax
          push dx
          mov dx,offset message
          mov ah,09h
          int 21h
          pop dx
          pop ax
          iret
                         
                           
    
code ends
end start



