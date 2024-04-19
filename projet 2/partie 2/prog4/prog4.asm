data        SEGMENT
    
    msg db 10,13," deroutement fait avec succes",10,10,13,"$"
   msg1 db 10,10,"je suis dans la tache 1",10,13,"$"
   msg2 db "je suis dans la tache 2",10,13,"$"
   msg3 db "je suis dans la tache 3",10,13,"$"

   nbt db 1   ; la variable pour connaitre quel tache on execute
   compt_tc dw 91  ;compteur une seule tache (18,2 *5)   
    ancien_ip dw ?
    ancien_cs dw ?
    time db 4  ;compteur pour que le programme se termine au bout de 1 minute
    min dw 60
    ;nbr dw ?
    ;nbr2 dw ?
          
data        ENDS

;**************************************************************************************************************************
      
Pile SEGMENT STACK      ;on choisis l emplacement de la pile qu 'on veut utiliser durent nos manipulation

    DW 128 DUP(?)
    TOS LABEL WORD
    
Pile ENDS
   
;************************************************************************************************************************** 


MonCode        segment 
    
    assume cs:MonCode, ds: data, ss:Pile   

 
    
afficher   proc    

         mov bx,data
         mov ds,bx
         mov ah,09h
         int 21h
         ret 
         
afficher endp
    
 



;*******************************************************************************************************



reinit      proc     ; proc pour reinitialiser le compteur pour les 5 secondes
                       ; car pour 1s on a 18 donc 18,2*5=91
         mov compt_tc,91
         ;mov compt_tc,nbr
         inc nbt  ; on incremente le numero de tache pour l' affichage de la tache suivante
         ret
         
reinit endp


;*******************************************************************************************************


save       proc near  ; une procedure qui sauvgarde l'ip et cs du programme

         mov ah,35h
         mov al,4h
         int 21H 
         mov ancien_ip,bx
         mov ancien_cs,es
         ret
    
save ENDP



;*******************************************************************************************************

affiche_tc1    proc                   ; Traitement de la tache 1

             
        
         mov dx,offset msg1
         call afficher        
         call reinit         
                 
     
         ret
         
affiche_tc1 endp


;*******************************************************************************************************



affiche_tc2    proc              ; Traitement de la tache 2
         
         mov dx,offset msg2    
         call afficher            
         call reinit         
         ret
affiche_tc2 endp


;*******************************************************************************************************


affiche_tc3    proc             ; Traitement de la tache 3
         
         mov dx,offset msg3
         call afficher
         call reinit
          
         mov nbt,1  ; on reinitialise a 1 pour refaire le traitement des taches depuis le debut 
         dec time     
         
         ret
         
affiche_tc3 endp




;*******************************************************************************************************


new     proc        ;procedure qui appelle les taches consecutivment 
        
         dec compt_tc
         jnz new_end   
         cmp nbt,1    ; a chaque fois on compare pour savoir quel call faut  faire
         jne tc_2        ;si le compteur n'est egale pas a 1 alors on saute a tc_2 pour le comparer avec 2 ainsi de suite   
         call affiche_tc1
         jmp new_end 
tc_2:    cmp nbt,2   
         jne tc_3
         call affiche_tc2
         jmp new_end 
tc_3:    call affiche_tc3



new_end:     iret

new  endp

;*******************************************************************************************************


deroutement   proc  ;dans cette procedure on fait le deroutement de la routine
   
    
         mov ah,25h        ;ah=25h qui represente l 'instalation du nouveau vecteur
         mov al,1ch     ; al=1Ch on affecte le numero de la routine qu'on veut derouter 
         mov dx,offset new    ;charger l'offset et code seg du deroutement
         mov bx,seg new
         mov ds,bx 
         int 21h
         mov dx,offset msg    ; affichage du deroutement fait
         call afficher
         ret 
deroutement endp;;


;*******************************************************************************************************

put_back   PROC NEAR     ;procedure pour remettre les ip et cs de l'ancien programme     
 
         mov ah,25h
         mov al,4H
         push ds          ;empilement de ds car il va chancger pour ne pas  perdre l'ancien valeure
         mov ds,ancien_cs
         mov dx,ancien_ip
         int 21H
         pop ds 
          
         ret
         
put_back ENDP



;*******************************************************************************************************

  
start:   mov ax, data    ; chargement du data segmement
         mov ds, ax
         mov ax, Pile        ; chargement de la pile
         mov ss, ax
         
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
                    
                    
                   ;mov ax,60
                   ;div nbr
                   ;mov nbr2,ax
                   ;mov ax,nbr
                   ;mul 18
                   ;mov nbr,ax
                   ;mov compt,ax
                    
                   
         mov sp, offset TOS
         call deroutement      ;on appel le prcedure de deroutement 
         call put_back      
         mov time,4
         ;mov time,nbr2
infini:  cmp time ,0
         jne  infini  ;  une boucle infinie pour qu'il refait le traitement a l`infinie
                           
         mov ax,4c00h   ; rendre la main au system
         int 21h


MonCode ends       ; fin de code segment 
end start   
