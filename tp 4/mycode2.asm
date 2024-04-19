
data segment
    A dw AEF1h
    B dw A322h
    res dw 0
data ends

code segment
    
    assume cs:code, ds:data
    
    debut: 
    mov ax,data
    mov ds, ax
    
    xor dx,dx
    mov ax,a
    mov bx,b
    add ax,bx
    adc dx,0 
    
    mov bx,ax
    
    mov cx,16
    
    affiche:
    mov ah,2
    mov dx,'0'
    test bx 8000h
    jz zero
    mov dx,'1'
    
    zero:
    int 21h
    shl bx,1
    loop affiche 
    
    fin:
    mov ah,4CH
    int 21h
    
    code ends
end debut
    
    




