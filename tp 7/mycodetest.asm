data segment 
    
    msg db "interruption installee avec succes",10,13,'$'  
    Vect equ 98h
    
data ends

code segment 
    
    assume cs: code, ds:data
    
    
    start: 
    
    mov ax,data
    mov ds,ax
    
    
    call installinterrup98  
    
    int 98H 
    
    
    mov ah,4ch
    int 21h  
    
    
    installinterrup98 proc
        
        push ds
        push bx
        push ax
        push cx
        
        xor ax,ax
        mov ds,ax
        mov bx,Vect
        mov cl,02h
        shl bx,cl
        mov word ptr[bx],offset interrup98
        mov word ptr[bx+2],cs
        
        pop cx
        pop ax
        pop bx
        pop ds
        
        ret 
        
        installinterrup98 endP  
    
     
      interrup98:
      
          push ax
          push dx
          mov dx,offset msg
          mov ah,09h
          int 21h
          pop dx
          pop ax
          ret
    
code ends

end start




