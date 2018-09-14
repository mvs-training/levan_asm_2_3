.model small
.stack   100h
.data
    filename db "*.*",0   
    handle dw ?
    buff dw 512 dup(?) 
    xaunhap db 128 dup(?)   
    input_len db 0
    buff_len db 0
    DTA db 50 dup(?)
    OEMSG      DB   'Cannot open BUFF.ASM.$'
    number_find db 0  
    RFMSG  DB 'Cannot read BUFF.ASM.$'  
    banghauto db 64 dup(?) 
    k db 0 
    i db 0 ; j la chi so cu string
    j db 0; i la chi so de so khop
    msg db 'Tim thay!',13,10,'$' 
    msg0 db 'Nhap vao String: ','$'
    msg1 db 'So lan tim thay: ',13,10,'$'
    xuongdong db 13,10,'$'
    count dw 0
;INCLUDE findstring.inc
;INCLUDE KMP.INC   
.code
Main Proc
    mov ax,@data
    mov ds,ax
    mov es,ax    
    
    ; Nhap chuoi tu ban phim  
   ; NhapChuoi xaunhap,input_len  
     lea dx, msg0
    mov ah,9
    int 21h  
     call NhapChuoi 
     
    ;thiet lap vung DTA
    mov dx, offset DTA
    mov ah,1ah
    int 21h
    ;Doc file dau tien tim thay
    mov ah,4eh
    mov dx,offset filename
    mov cx,00h
    int 21h 
    jc thoatra 
      
    NextFile:   
    mov number_find,0 ;Khoi tao so lan tim thay = 0
   ; mov ah,4fh
    ;int 21h
    ;jc thoatra
     mov dx,offset [DTA+30]
    mov si,dx
    mov byte ptr [si+14],'$'
     
    mov ah,9      
    int 21h  
    ; display in man hinh
    lea dx, xuongdong
    mov ah,9
    int 21h
    HandleFile:
    
    ;Open File
    mov dx,offset [DTA+30] 
    mov byte ptr [DTA+30+13],0 ; Dua 0 vao cuoi ten file  
    mov ah,3dh  ; open file with handle funcltion
    mov al,0    ; read access
    int 21h 
    jc openerr 
    jnc opensucs
    OPENERR:
     LEA  DX,OEMSG       ;set up pointer to error message
     MOV  AH,9           ;display string function
     INT  21H            ;DOS call
    STC                 ;set error flag 
     opensucs:
    mov handle,ax ; save file handle
    
    
     
    ;ReadFileFromDisk <buff,handle,buff_len> 
     call ReadFileFromDisk
    ;KMP_Algorithm  xaunhap,buff,input_len,buff_len,number_find
      call KMP_Algorithm 
      mov ah,4fh
    int 21h
    jc thoatra
      jmp NextFile
      
                    ;set error flag
 thoatra:     
 
 
mov ax, 4c00h
int 21h  

MAIN Endp


NhapChuoi Proc
    lea di, xaunhap
    mov ah,01h 
    nhapvao:
    int 21h 
    cmp al,13
    jne nhaptiep 
    je retu
    nhaptiep:
    stosb
    inc input_len  
    jmp nhapvao 
    retu: 
    lea dx, xuongdong
    mov ah,9
    int 21h
    ret
NhapChuoi endp 

ReadFileFromDisk Proc
   ReadFile:
    mov ah,3fh       ;read from file function
    mov bx,handle    ;load file handle
    lea dx,buff      ;pointer to data buff
    
    add dx ,word ptr count
    mov cx,1         ;read one byte one time
    int 21h
    jc readerr
    cmp ax,0         ;if 0 byte read
    jz EOFF ;end of file
    lea di,buff
    add di, word ptr count      
    inc buff_len  
    mov dl,byte ptr ds:[di]
    cmp dl,1ah
    jz EOFF
    mov ah,2  ; display character 
    int 21h   
    inc count
    jmp  ReadFile
    
    readerr:
    lea dx,RFMSG
    mov ah,9
    int 21h
    stc
    EOFF:
    ret
    
ReadFileFromDisk Endp      

KMP_Algorithm proc
    
    Bang_Hau_To:
     xor ax,ax
    
    lea bp,banghauto; di tro vao bang hau to
    lea bx,xaunhap
     
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
    
    So_Khop:
    lea bx,buff
    lea bp,xaunhap 
    
    mov j,0
    mov i,0  
    Lap1:
    mov ah,j
    add ah,input_len
    cmp ah,buff_len
    jg thoat
    Lap2:
    mov ah,i 
    cmp ah,input_len
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
    cmp ah,input_len
    ;jnz capnhat
    jz TBao  
    CMP_0:  
    cmp ah,0
    jz tang_j
    jnz capnhat
    Tbao: 
    inc number_find
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
    lea dx, msg1
    mov ah,9
    int 21h
    mov dl,number_find
    add dl,30h
    mov ah,2
    int 21h 
    lea dx, xuongdong
    mov ah,9
    int 21h
    ret

KMP_Algorithm endp