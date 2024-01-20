
section .data
    	
    Image: db 130, 40, 60, 80, 150, 10, 40, 15, 180 ;matrice de 3x3
    buffer: times 100 db 0  ;matrice in care vom salva rezultatul
    
    n: db 3                 ;numar linii
    m: db 3                 ;numar coloane
    type: db 1              ;tipul de operatie
    prag: db 127            ;pragul setat
 

section .text
    global _start

_start:

    mov ebx, 0
    mov bh, [type]  ;salvez tipul dorit de prelucrare 
    mov bl, [prag]  ;salvez pragul setat
   
    mov ecx, 0
    mov cl, [n]     ;salvez numarul de randuri
    
    mov edx, 0
    mov dl, [m]     ;salvez numarul de coloane 
    
    ;calculez numarul de elemente al matricei
    mov eax, 0
    mov al, cl
    mul dl
    mov edx, eax
    
    mov cl, 1       ;initializare contor pentru afisarea pe randuri
    
    mov esi, 0      ;initializare index pentru matricea introdusa
    mov edi, 0      ;initializare index pentru matricea rezultata
    
    
loop_functie:
  
    ;functia switch:

    cmp bh,0                ;daca type=0 => conversie imagine alb negru
    je conversie_alb_negru
    
    cmp bh,1                ;daca type=1 => conversie in negru daca elementul < prag
    je conversie_negru 
    
    cmp bh,2                ;daca type=2 => conversie in alb daca elementul > prag
    je conversie_alb

conversie_alb_negru:

    mov al, byte [Image+esi]    ;al = *(Image+esi), unde esi=0,1,2,..
    cmp bl,al                   ;compar valoarea cu pragul setat
    ja set_negru                ;conversie in negru daca elementul < prag
    jb set_alb                  ;conversie in alb daca elementul > prag
    jmp next                    ;trecem la urmatorul daca elementul = prag
    
conversie_negru:

    mov al, byte [Image+esi]    ;al = *(Image+esi), unde esi=0,1,2,..
    cmp bl,al                   ;compar valoarea cu pragul setat
    ja set_negru                ;conversie in negru daca elementul < prag
    jmp next                    ;trecem la urmatorul daca elementul >= prag
    
conversie_alb:

    mov al, byte [Image+esi]    ;al = *(Image+esi), unde esi=0,1,2,..
    cmp bl,al                   ;compar valoarea cu pragul setat
    jb set_alb                  ;conversie in alb daca elementul > prag
    jmp next                    ;trecem la urmatorul daca elementul <= prag
        
set_negru:

    mov [buffer+edi], byte '0'     ;transform in negru (0) si salvez valoarea in noua matrice
    mov [buffer+edi+1], byte ' '   
    
;AFISARE - set de instructiuni valabil doar pentru type = 0 (conversie alb-negru):  
    cmp cl, [m]                    ;compar contorul cu numarul de coloane
    jne next                       ;daca nu sunt egale trecem la urmatorul element
    mov [buffer+edi+2], byte 0xa   ;daca este egal cu numarul de coloane trecem pe urmatorul rand    
    mov cl, 0                      ;resetez contorul    
    inc edi                        ;incrementez indexul noii matrici     
;sfarsit set de instructiuni
    
    jmp next                       ;trec la urmatorul element              
    
set_alb:

    mov [buffer+edi], byte '1'     ;conversie in alb (255 sau 1) si salvez valoarea in noua matrice
    mov [buffer+edi+1], byte ' '

    ;AFISARE - set de instructiuni valabil doar pentru type = 0 (conversie alb-negru):    
    cmp cl, [m]                     ;compar contorul cu numarul de coloane
    jne next                        ;daca nu sunt egale trecem la urmatorul element
    mov [buffer+edi+2], byte 0xa    ;daca este egal cu numarul de coloane trecem pe urmatorul rand  
    mov cl, 0                       ;resetez contorul 
    inc edi                         ;incrementez indexul noii matrici
    ;sfarsit set de instructiuni
    
    jmp next                        ;trec la urmatorul element  

next:
    
    inc cl          ;incrementez contorul pentru numarul de coloane
    add edi, 2      ;incrementez cu 2 indexul noii matrici
    inc esi         ;incrementez indexul matricei date
    
    cmp edx, esi    ;compar indexul elementului curent cu numarul elementelor din matrice
    ja loop_functie ;daca indexul elemtului curent < numarul elementelor din matrice continuam parcurgerea 


;AFISARE - set de instructiuni valabil doar pentru type = 0 (conversie alb-negru):
    mov eax, 4     
    mov ebx, 1      
    mov ecx, buffer 
    mov edx, 100
    int 0x80 

;iesim din program
    mov eax, 1      ; system call number (sys_exit)
    xor ebx, ebx    ; exit code
    int 0x80        ; call kernel
