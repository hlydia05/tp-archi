data segment 
    
    msg1 db 10,10,"deroutement fait avec succes",10,10,13,"$"
    msg2 db " je suis passe par 1CH" ,10,13,"$"
    compt db 18  ; 18 represent le nombre des requetes durant une seconde (18.2 r/s)
    
data ends
    
;********************************************************************************************************   
   
pile  segment stack                   ; declaration de notre pile 
    
    dw 128 dup (?)
    tos label word 
   
   
pile ends 

;********************************************************************************************************


code segment 
    assume cs:code ,ds:data,ss:pile    
    
    
  afficher proc near 
  
         mov bx,data    
         mov ds,bx
         mov ah,09h   ;numero de la fonction  qui fait l affichage d'une chaine de caracteres sur l ecran 
         int 21h      ;numero de l'interuption qui contient la fonction qui fait l affichage 
         ret
  
  afficher endp
  
  
;********************************************************************************************************    
 
 deroutement proc near             ;la procedure de deroutement
 

 mov dx,offset new   ;charger l offset et code seg du deroutement afin d'utiliser la nouvelle routine
 mov ax,seg new       ;on place l'adresse de la nouvelle routine d`interruption
 mov ds,ax               
 mov ax, 251Ch       ;al= 1ch l'interruption qu on veut derouter  et
 int 21h                 ;ah=25h qui represent la fonction qui fait  l'instalation  Du nouveau vecteur d interuption
                 
 mov dx,offset msg1   ;affichage  du message deroutement fait avec succes 
 call afficher
     
                              
 ret
 
 deroutement endp
 
;******************************************************************************************************** 
vint_sec proc          
          
                 
                 mov cx ,0ffffh
boucle_externe : mov si,01cfh     ; on boucle 01cfh fois pour obtenir 20 messages en 20 sec 
boucle_interne : dec si
                 jnz boucle_interne   
                 loop boucle_externe
                 ret
  vint_sec endp
   
;******************************************************************************************************** 
   new  proc                    ; nouvelle routine de l'interruption 1Ch
  
        dec compt           ;decrementation du compteur pour afficher msg2 chaque 1 seconde 
        jnz fin
        mov dx, offset msg2  ;affichage du message je suis passe par 1ch
        call afficher
        mov compt ,18 ;reinitialisation du compteur pour refaire indefiniment l'affichage 
   fin: iret
   
  new endp
  
 ;********************************************************************************************************
                             
 start: mov ax,data      ; programme principal
          mov ds,ax  
          mov ax,pile
          mov ss,ax
          lea sp, tos
          
          
          call near ptr deroutement    ;appel au deroutement 
         
         
          boucle : call near ptr vint_sec    ; appel a la methode qui affiche 20 fois je suis passe par 1Ch
                   jmp boucle        ;boucle infinie
                  
         
         mov ax,4C00h
         int 21h        
code ends
end start
