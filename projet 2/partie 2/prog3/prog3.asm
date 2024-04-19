data        segment
    
    msg db 10,13," deroutement fait avec succes",10,10,13,"$"
   msg1 db 10,"je suis dans la tache 1",10,13,"$"
   msg2 db "je suis dans la tache 2",10,13,"$"
   msg3 db "je suis dans la tache 3",10,13,"$"
  
   nbt db 1   ; pour connaitre quel tache on affiche
   compt_tc dw 37  ;compteur une seule tache (18,2 *2)   
   
     
          
data        ends

;********************************************************************************************************
      
      
Pile segment stack       

    dw 128 dup(?)
    tos label word
    
    
Pile ends
   
;********************************************************************************************************

   
Code        segment
    
    assume cs:Code, ds: data, ss:Pile   
 
    
afficher   proc    ;

         mov bx,data
         mov ds,bx
         mov ah,09h
         int 21h
         ret 
         
afficher endp
    
 



;*******************************************************************************************************



reinit   proc     ;procedure qui permet de  reinitialiser le compteur pour les 2 secondes
                       ; car pour 1s on a 18 donc 18,2*2=36.4=37

         mov compt_tc,37
         inc nbt      ; on incremente le numero de tache pour la tache suivante
         ret
         
reinit endp


;*******************************************************************************************************


affiche_tc1    proc        ; Traitement de la tache1

                          
        
         mov dx,offset msg1
         call afficher          ;On fait l'appel a la procedure qui affiche chaque fois une tache
         call reinit            ; On fait l'appel a la procedure qui reinitialise le compteur et au meme temps incrementer le numero de la tache pour afficher la suivante
                 
     
         ret
         
affiche_tc1 endp


;*******************************************************************************************************



affiche_tc2    proc              ; Traitement de la tache2
         
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
         mov nbt,1
         ret
         
affiche_tc3 endp



;*******************************************************************************************************


new     proc        ;procedure qui appelle les taches consecutivement 
        
         dec compt_tc
         jnz new_end   
         cmp nbt,1    ; a chaque fois on compare pour savoir quel call faut  faire
         jne tc_2        ;si le compteur n'est egale pas a 1 alors on saute a tc_2 pour le comparer avec 2 ainsi de suite ...  
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


deroutement   proc  ;la procedure qui fait le deroutement de la routine
   
    
         mov ah,25h        ;ah=25h qui represente la fonction qui permet l'instalation du nouveau vecteur
         mov al,1ch     ; al=1Ch on affecte le numero de la routine qu'on veut derouter 
         mov dx,offset new    ;charger l'offset et code seg de la nouvelle routine
         mov bx,seg new
         mov ds,bx 
         int 21h
         mov dx,offset msg    ; affichage du  message deroutement fait
         call afficher
         ret 
         
deroutement endp;


;*******************************************************************************************************

  
start:   mov ax, data    ; chargement du data segment
         mov ds, ax
         mov ax, Pile        ; chargement de la pile
         mov ss, ax
         mov sp, offset TOS
         call deroutement     ; on appel la procedure qui fait le  deroutement 

infini:  jmp infini    ;  une boucle vide pour qu'il refait le traitement a l`infinie
                             
         mov ax,4c00h   ; rendre la main au system d'exploitation
         int 21h


Code ends      
end start 

  