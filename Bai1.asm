.model small  
.stack 100h
.data      
DTA db 50 dup(?)  
tenfile db "*.*",0
.code

Main:
mov ax,@data
mov ds,ax
mov es,ax

; dua cau truc thu muc vao vung DTA bang ngat int 21h,1Ah  
; sau lenh ngat nay DOS se xem DTA la vung chua du lieu cua chuong trinh
; thay cho vung DTA mac dinh trong PSP
mov dx, offset DTA ; DS:DX tro den vung nho DTA
mov ah,1Ah
int 21h

;tim file dau tien phu hop voi ham int 21h,4Eh
;sau lenh nay DTA se tro den cau truc file dau tien tim dc
;hoac  AX se chua ma loi neu CF  = 1

mov ah,4eh
mov dx, offset tenfile
mov cx,0fh      ;cx se luu thuoc tinh file can tim
int 21h       

; neu CF = 1 thi thoat ra

jc thoat

; neu ok thi hien ten file va tiep tuc
Lap:   
; Dung ngat 21h,9h de hien thi len man hinh ten file o dia chi DTA+30
; nho dua ky tu ket thuc vao cuoi chuoi
mov dx,offset [DTA+30]
mov si,dx
mov byte ptr [si+14],'$'
mov ah,9      
int 21h  
;Ham 21h,4Fh hien thi tiep file phu hop ma DS:DX da tro toi o ngat 4Eh
            
mov ah,4fh
int 21h

jc thoat
jmp Lap



thoat:

end Main