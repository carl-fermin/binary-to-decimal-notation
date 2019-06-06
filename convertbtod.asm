; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "enter byte value:$"
    outputresultstr db "the equivalent decimal is:$"
    input db 8 dup (?),'$'
    ot db 3 dup (?),'$'
    result db 8 dup (?),'$'
    res db 00000001b
    digt db 30h
    pkey1 db "256...$"
    newline equ 0Ah
    carriage_return equ 0Dh
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ;enter the binary input  /ones and zeros
    mov cx,8
    lea di,input
    enter:
    mov ah,1     
    int 21h
    sub al,30h
    mov [di],al   
    inc di
    loop enter
    
        
    lea di,input+7
    lea si,result+7
    mov cx,8
         
    l:    
     mov al,[di]     
     mov bl,res     
     mul bl   
     mov [si],al
     shl res,1          
     dec si
     dec di     
    loop l
        
         
    lea si,result+7 
    mov al,0
    mov cx,8 
    add1:
      mov bl,[si]
      adc al,bl
    
      dec si
    loop add1 
       
       
    ;if the value is 256 go to 'label:' line and display it right away
    cmp al,11111111b
    je label   
 
    ;actual conversion from hexadecimal value to ascii decimal 
    mov bl,00h 
    lea di,ot+2
    j:
     cmp bl,al
     je ext
      
      cmp digt,'9'
      jg incd
      mov dl,digt
      mov [di],dl
      jmp here
      
       incd:
      
       mov digt,30h
       mov [di],30h
       
       cmp [di-1],'8'
      
       jg ass0
       
       
       mov dl,[di-1]
       add dl,01h
       or dl,30h
       
       mov [di-1],dl
       
       
       jmp here
       ass0:
         
         
         mov [di-1],30h

         mov dl,[di-2]
         add dl,01h
         or dl,30h
         mov [di-2],dl
       
       
      here:
      inc digt
     
      inc bl
    loop j
     ext:  
      
    
    
    
    ;display 
    
    ;nextline
    mov dl,newline     
    mov ah,2
    int 21h
    
    ;carriage_return
    mov dl,carriage_return     
    mov ah,2
    int 21h
    
    
    lea dx,outputresultstr
    mov ah,9
    int 21h
    
    
    
    ;actual display of resulting converted decimal
    lea si,ot
    mov cx,3
    n:
    
   
    mov dl,[si]     
    mov ah,2
    int 21h 
    inc si
    loop n  
    jmp exithere:
    
    
    ;display 256
    label: 
    
    lea dx ,pkey1
    mov ah,9
    int 21h
    
    
     exithere:          
    ; wait for any key....    
    mov ah, 1
    int 21h

    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
