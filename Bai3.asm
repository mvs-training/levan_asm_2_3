.model small 
.data  
     
     buff dw 256 dup(?)  
     table db '0123456789abcdef'
     

.stack 
    dw   128  dup(0)


.code 
start:

    ; add your code here        
MOV AX,@DATA
MOV DS,AX 
mov es, ax
xor ax, ax
    
mov cx, 01h    ; cylinder 0, sector 1
mov dx, 00801h ; DH = 0 (head), drive = 80h (0th hard disk)
mov bx, offset buff ; segment offset of the buffer

mov ax, 0201h ; AH = 02 (disk read), AL = 01 (number of sectors to read)
int 13h
 
lea si,buff
mov cx,128
Print:
lodsb ;
mov dl,al  
push cx
mov cl,4  
shr al,cl 

lea bx,table
xlat
mov ah,0eh
int 10h  

mov al,dl
and al,0fh
xlat   
mov ah,0eh
int 10h
pop cx
loop Print
mov ax, 4c00h
int 21h  

ends

end start
