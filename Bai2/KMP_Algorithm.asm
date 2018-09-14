.model small
.data
   banghauto db 64 dup(?) 
   xaumau db "abcdabd"   
   string db "PAabcdabdRTICIPabcdabdATEINPARabcdabdACHUTE"
   k db 0 
   i db 0 ; j la chi so cu string
   j db 0; i la chi so de so khop
   m db 7    ; m la chieu dai xau mau
   n db 45   ; n la chieu dai string
   msg db 'Tim thay','$'

.stack 
    dw   128  dup(0)


.code
Main Proc 

mov ax,@data
mov ds,ax
mov es,ax

call Bang_Hau_To
call So_Khop
mov ax, 4c00h
int 21h  

Main  endp

Bang_Hau_To Proc  
    xor ax,ax
    
    lea bp,banghauto; di tro vao bang hau to
    lea bx,xaumau
     
    mov ds:[bp],0
    mov al,1; ax luu chi so cua string  
    xor cx,cx
    mov cx,6
    Lap: 
    Lap_2:
    cmp k,0
    jle tieptuc 
    mov  si,word ptr k
    
    add si,bx 
    
    xor ah,ah
    mov di,ax
    add di,bx
    cmpsb
    jz tieptuc
    mov ah,k
    mov  ah,ds:[bp+ah]
    mov k,ah  
    jmp Lap_2
    tieptuc:
    mov si,word ptr k
    add si,bx
     
    xor ah,ah
    mov di,ax
    add di,bx 
    cmpsb
    jz tang_k 
    jnz dien_bang
    tang_k: inc k
    jmp dien_bang
    dien_bang:
    mov dl,k
    mov di,ax
    mov ds:[bp+di],dl
    inc al 
    
    loop Lap 
    
    ret
Bang_Hau_To Endp 

So_Khop Proc 
    lea bx,string
    lea bp,xaumau 
    
    mov j,0
    mov i,0  
    Lap1:
    mov ah,j
    add ah,m
    cmp ah,n
    jg thoat
    Lap2:
    mov ah,i 
    cmp ah,m
    jge tiep
    xor ah,ah
    mov al,i
    mov si,ax  
    add si,bp
    mov al,j
    add al,i
    mov di,ax
    add di,bx
    cmpsb 
    jnz tiep
    inc i 
    jmp Lap2
    tiep:
    mov ah,i
   ; cmp ah,0
    ;jz tang_j
    cmp ah,m
    ;jnz capnhat
    jz TBao  
    CMP_0:  
    cmp ah,0
    jz tang_j
    jnz capnhat
    Tbao:
    mov ah,09h
    lea dx,msg
    int 21h
    jmp CMP_0
    capnhat:
    mov ah,j
    mov al,i     ;luu i vao al
    add ah,al   ; luu i+j vao ah
    dec al         ;i-1
    push bx        ; cat bx
    lea bx,banghauto    ; dua bang hau to
    mov dl,al
    xor dh,dh
    mov si,dx
    sub ah,ds:[bx+si]   ;
    mov j,ah        ; j = j+i -a[k-1] 
    mov dl,al
    xor dh,dh
    mov si,dx
    mov ah,ds:[bx+si]      ;
    mov i,ah
    pop bx
    jmp Lap1
    tang_j:
    inc j
    jmp Lap1
    
    
    thoat:
    ret
So_Khop Endp
