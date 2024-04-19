data segment 
    msg1 db 10,10,"deroutement fait avec succes",10,10,13,"$"
    msg2 db " je suis passe par 1ch ",10,13,"$"
    msg3 db " entrez un entier entre 1 et 9 ",10,13,"$"
    compt dw 18  ; 18 represent le nombre de requetes durant une seconde (18.2 r/s)
    ;compt dw ?
    compt2 db 1 
    ;nbr dw ?
data ends

;********************************************************************************************************  
pile  segment stack     ;la declaration de la pile 
    dw 128 dup (?)
   tos label word 
pile ends 
;********************************************************************************************************  
code segment 
    assume cs:code ,ds:data,ss:pile    ;la promesse du cpu 

    
    
  afficher proc near 
  
         mov bx,data    
         mov ds,bx
         mov ah,09h   ;numero de la fonction  qui fait l affichage d'une chaine de caracteres sur l ecran 
         int 21h      ;numero de l'interuption qui contient la fonction qui fait l affichage 
         ret
  
  afficher endp
  
  
;********************************************************************************************************   
 
   
 deroutement proc near             
 

 mov dx,offset new   ;charger l offset et code seg du deroutement afin d'utiliser la nouvelle routine
 mov ax,seg new       ;on place l'adresse de la nouvelle routine d`interruption
 mov ds,ax               
 mov ax, 251Ch  ;   al= 1ch l'interruption qu on veut derouter  et
 int 21h                 ;ah=25h qui represent la fonction qui fait  l'instalation  Du nouveau vecteur d interuption
 mov dx,offset  msg1   ;affichage  du message deroutement fait avec succes
 call afficher                 
 
     
                              
 ret
 
 deroutement endp

 
;********************************************************************************************************   
 vint_sec proc near                 ;quantum logiciel  
                 

                 mov cx ,0ffffh
boucle_externe : mov si,012ch     ; on boucle 012ch fois pour obtenir 13 messages 
                 ;mov si,1cfh 20 messages en 20 secondes
boucle_interne : dec si
                 jnz boucle_interne    
                 loop boucle_externe
                 ret
                 
                 
   vint_sec endp
;********************************************************************************************************
  
  new  proc 
  
        dec compt  ;la nouvelle routine de l'interruption 1Ch
        jnz fin
        mov dx, offset msg2  ;affichage du message je suis passe par 1ch
        call afficher
        ;mov ax,nbr
        mov ax ,18 ; la reinitialisation du compteur pour refaire l'affichage indefiniment chaque 1 seconde
        mov compt,ax
   fin: iret
   
   
  new endp
    
 ;********************************************************************************************************
                         ;Programme principal    
                   
  
   start: mov ax,data      ;chargement de data segment 
          mov ds,ax 
          
          mov ax,pile
          mov ss,ax
          
          ;saisie: mov dx, offset msg3
                  ;mov ah,08h
                  ; int 21h
                  
          ;condition: cmp ax,0
                     ;jng saisie
                    ; cmp ax,9
                    ; jnle saisie
                    ; jmp store
                     
                    ;store: sub al,48
                    ;mov nbr,ax
                    ; mov compt,nbr
          
          mov sp, offset tos
          call near ptr deroutement ;appel au deroutement 
            
         
          call near ptr vint_sec  ; appel a la methode qui affiche 13 fois je suis passe par 1ch

                  
         mov ax,4C00h
         int 21h        
code ends                       
end start
    
