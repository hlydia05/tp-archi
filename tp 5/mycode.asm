Data segment
    chaine DB 'hello world',10,13,'$' 
    msg DB 'bonjour','$'
    data ends
code segment
    assume ds:data, cs:code  
    
    
    start: mov ax,data
    mov ds,ax
    
    ;lea dx,chaine
    mov dx, offset chaine
    call print
    ;mov ah,09h
    ;int 21h 
    
    ; dx,msg
    mov dx, offset msg
    call print
    ;mov ah,09h
    ;int 21h       
    
    
    fin: mov ah,4ch
    int 21h  
    
    print proc  
        mov ah, 09h
        int 21h   
        ret
        print endp
    
    code ends   

end start
    
    