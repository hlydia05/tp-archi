data segment
    
    chaine db 250,?,250 dup(?)
    chaineMirroir db 250 dup(?),'$'
   tailleCh db 3 dup(0)
    taille db 0
    msg1 db 13,10,'Entrez la taille du texte, qui doit etre entre 1 et 250 caracteres: ','$'
    msg2 db 13,10,'Entrez votre texte',13,10,'$'
    msg4 db 13,10,'chaine avec mots mirroir:',13,10,'$'
    
data ends
    
    
    stack segment
        
        
         ss dw 128 dup(?)
        
        stack ends       
           
           
           
code segment 
    assume cs:code, ds:data, ss:stack

    
    
    
    main: 
        mov ax,data
        mov ds,ax     
                   
        mov ax,stack
        mov ss,ax        
                   
        
        ;entre la taille du msg
        
rept:     mov dx, offset msg1
        call affichage
        
        call SaisieTaille

        cmp taille, 1
        jl rept
           
        cmp taille, 250
        ja rept
        
        mov al,taille
        mov chaine,al
        
        mov dx, offset msg2 
        call affichage
        
        mov dx, offset chaine
        call SaisieChaine
    
        
        
mov ah,4ch
int 21h

affichage proc
    mov ah,09h
    int 21h 
       
    ret
affichage endp

SaisieChaine proc 
    mov ah,0Ah
    int 21h
    
    Xor bx,bx
    Mov bl,chaine+1   
    Mov chaine[bx+2],'$'
    
   
    mov dx,offset chaine+2
    call affichage
    
    ret
   
SaisieChaine endp


SaisieTaille proc  
    mov cx, 3 
    mov si, offset tailleCh
saisie: 
    mov dx,offset tailleCh
    mov ah,0Ah            
    
    mov ah, 01h
    int 21h 
    cmp al,13  ;OK test
    je  calcul_taille
    mov [si], al
    inc si
    loop saisie
    
calcul_taille:  
    mov cx,3
    mov bh, 1
    dec si
convert:          
    mov al, bh
    mov bl, [si]
    and bl, 0Fh 
    mul bl
    add taille, al
    mov al, bh
    mov bh, 10
    mul bh 
    mov bh, al
     
    cmp si, offset tailleCh
    je exit
    dec si
    loop convert
exit:    
    
    ret
    SaisieTaille endp      

code ends
    end main
