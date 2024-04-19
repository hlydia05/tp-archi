
data segment
  
    msg1 db 10,13,'$'
    
    
    data ends
code segment
    
    
    assume: cs:code
    
    start: 
    
      mov cx,256
      xor si,si
      
    
      affichageTab:
       
     
        xor ax,ax
        mov ds,ax 
      
       mov ax,word ptr[si] 
       mov bx,10
    
       call affiche_adresse
       add si,2  
       
        mov dx,offset msg1
        call affiche_msg
       
       xor ax,ax  
       mov ds,ax 
    
         mov ax,word ptr[si] 
         mov bx,10
         call affiche_adresse
        
         add si,2  
      
                
        mov dx,offset msg1
        call affiche_msg
    
    
          loop affichageTab  
          
          
          mov ah,4ch
          int 21h
          
          
          affiche_msg proc 
            mov ax,data
            mov ds,ax
            
          
            mov ah,09h
            int 21h
          
            
            
            
            ret 
          affiche_msg endp  
          
                           
                           
                           
                           
                           
            
          
                 
         
 affiche_adresse proc  
    
    
    push dx
    push cx
    xor cx,cx
            
        remplir:
           xor dx,dx
           div bx
           push dx
           inc cx
           test ax,ax
           
           jnz remplir
           
       vider:
         pop dx
         add dl,'0' ; convertir en code ascii
         mov ah,02
         int 21h
         
         loop vider    
            
              
          pop cx
          pop dx
            
            
            ret 
affiche_adresse endp
          
          
          
          
          
          
    
    
    code ends
    end start




