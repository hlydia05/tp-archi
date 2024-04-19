DATA SEGMENT
    
msg DB 'depassement de capacite' , 0DH , 0AH


DATA ENDS

Extra SEGMENT
    
Tab DB 82 DUP(?)    

COUNT DB ?

Extra ENDS


Entre_Tab EQU 52h 

Sort_Tab EQU 53h

STATUS EQU 54h

RRDY EQU 00000010:

TRDY EQU 00000001B

Code SEGMENT: 
    
ASSUME CS: Code , DS: data , ES: extra

MOV AX , data
MOV DS , AX
MOV AX , extra
MOV ES , AX



MOV DI , offset Tab   ; DI= @ de debut de tab


MOV COUNT, DI ;COUNT=DI

MOV CX, 81 ;CX=81

CLD ; mettre DF a 0

NEXT_IN: IN AL, STATUS ; lire l etat du port d entree

TEST AL, RRDY ; RRDY = 00000010B

JZ NEXT_IN ; si egal a 0 alors attendre ( port plein )

IN AL, entre_TAb ; saisir la donnee envoyee par le peripherique

OR AL, 0

JPE NO_ERROR ; si PF=1 
                   
                   
JMP NEAR PRT ERROR 

NO_ERROR: 

AND AL, 7FH:7FH=01111111B    

STOSB

CMP AL,ODH ; comparer AL avec 0DH

LOOPNE NEXT_IN ; Loop si AL n est pas egal a 0Dh

JNE OVERFLOW ; jump vers la boucle overflow si ZF = 0.

MOV AL, 0AH ; mettre la Valeur 0AH dans le registre AL

STOSB

SUB DI, COUNT ; DI=DI-COUNT

MOV COUNT, DI ; COUNT=DI
.
.
.

OVERFLOW : MOV SI, offset msg ; SI=0000h

MOV CX, 17 ; mettre cx a 17

NEXT_OUT : IN AL, STATUS ; lire le port d etat

TEST AL, TRDY ;TRDY = 00000001B

JZ NEXT_OUT ;SI ZF=1

LODSB

OUT sort_Tab, AL ; ecriture de la donnee dans le port de sortie

LOOP NEXT_OUT 