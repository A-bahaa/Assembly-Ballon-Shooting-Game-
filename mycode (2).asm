                               
.model large                                ;supports multiple code and multiple data segments.
.data

player_pos dw 1760d                         ;position of player

arrow_pos dw 0d                             ;position of arrow
arrow_status db 0d                          ;0 = arrow ready to go else not 
arrow_limit dw  22d                         ;150d

loon_pos dw 3860d              
         
                                            ;direction of player 
                                            ;up=8, down=2
direction db 0d

state_buf db 'aaaaaaaassssssssss$'          ;score veriable
hit_num db 0d
hits dw 0d
miss dw 0d 

game_over_str dw '  ',0ah,0dh
 
dw ' ',0ah,0dh 
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                                Game Over',0ah,0dh
dw '                        Press Enter to start again$',0ah,0dh   

  start_message dw '                                                                     ',0AH,0DH,
   dw '                                                                     ',0AH,0DH,
   dw '                                                                     ',0AH,0DH,
   dw '                                                                     ',0AH,0DH,
   dw '              *****************************************************',0AH,0DH, 
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *       ((    Balloon Shooting Game      ))         *',0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *      --------------------------------------       *',0ah,0dh,
   dw '              *        Use up and down key to move player         *',0ah,0dh,
   dw '              *           and space button to shoot               *',0ah,0dh,
   dw '              *      --------------------------------------       *',0ah,0dh,
   dw "              *  Take Care You only get 8 misses then you're out  *",0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *          >>>>Press Enter to start<<<<             *',0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *****************************************************',0AH,0DH,'$'   ;the dollar indicating the end of the message  



.code
main proc
mov ax,@data

    MOV AX,@DATA                                                                      ; load in AX the address of the data segment
    MOV DS,AX
    
    mov ax, 0B800h                                                                    ; move 0B800h into ax
                                                                                      ; 0B800h is the address of VGA card for text mode
    mov es,ax                                                                         ; move AX into es, so es hold the address of VGA card  
                                                                                      ; VGA text buffer is used in VGA compatible text mode.
                                                                                      ; Each character in screen is represented by two bytes or by 16 bits.
                                                                                      ; ES: segment in the memory which is auxiliary data segment in the memory
                                                                                      ; ES is the default destination for string operations 
    
    lea dx,  start_message                                                            ; Load the effective address of the string in dx using LEA command
    MOV AH,09H                                                                        ; Print the message by calling the interrupt with 9H in AH
    INT 21H                                                                           ; the interrupt command
        
        
        
    input:
        mov ah,1                                                                      ; wait for input      
        int 21h
        cmp al,13d                                                                    ; cmpare if the input equal to asci of enter
        jne input 
        
    mov ah,0                                                                          ;clearing the screen to go to start the game
    mov al,3                                                                          ;set display mode function (video mode)
    int 10h                                                                           ;mode 2 = text 80 x 25 16 grey
                                                                                      ;video service bios interrupt
        
                     
    call show_score                                                                   ;display score
    lea dx,state_buf
    mov ah,09h
    int 21h

    mov ah,2                                                                          ; print new line
    mov dl,0dh
    int 21h
        


                                                                   
main_loop:                                 
                                           
        mov ah,01h                                                                    ;int 16 / ah=01 -> check for keystroke (Get the State of the keyboard buffer)                                                                       
        int 16h  
                                 
                                 
                                   
        jne key_pressed                                                               ;jmp if zero flag == 0 
        
 
        cmp miss , 8                                                                  ; check number of misses and zf == 1 
        jge game_over                                                                      ; if zf == 1 then close the program
        
        
        
        mov dx,arrow_pos                                                              ;checking collitions
        cmp dx, loon_pos
        je hit                                                                        ;inc hits if the position of arrow is equal to balloon position 
         
         
                                                                                      ;check if the direction variable change to 10d (up)
        cmp direction,10d                                                             ;update player position
        je player_up  
        
        cmp direction,4d                                                              ;check if the direction variable change to 4d (down)
        je player_down
        
        mov dx,arrow_limit                                                            ;hide arrow if arrow reach its limit 
        cmp arrow_pos, dx
        jge hide_arrow
        
        cmp loon_pos, 0d                                                              ;check missed loon
        jle miss_loon
        jne render_loon                  
        
        
        
    
        hit:                               
            mov ah,2                                                                  ;play sound if hit
            mov dx, 7d
            int 21h 
            
            inc hits                                                                  ;update score
            
                          
            call show_score                                                           ;display score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                                                                  ;new line
            mov dl, 0dh
            int 21h    
            
            jmp fire_loon                                                             ;new loon pops up  
            
    
        render_loon:    
            mov cl, ' '                                                               ;hide old loon
            mov ch, 1111b
        
            mov bx,loon_pos 
            mov es:[bx], cx
                
            sub loon_pos,160d                                                         ;and draw new one in new position
            mov cl, 15d
            mov ch, 0010b
        
            mov bx,loon_pos 
            mov es:[bx], cx
            
            cmp arrow_status,1d                                                       ;check any arrow to rander
            je render_arrow
            jne inside_loop2 
        
        render_arrow:                                                   
        
            mov cl, ' '                                                               ;hide old position
            mov ch, 1111b
        
            mov bx,arrow_pos               
            mov es:[bx], cx
                
            add arrow_pos,4d                                                          ;draw new position
            mov cl, 26d
            mov ch, 1001b
        
            mov bx,arrow_pos 
            mov es:[bx], cx
        
        inside_loop2:
            
            mov cl, 125d                                                              ;draw player 
            mov ch, 1100b
            mov bx,player_pos 
            mov es:[bx], cx
            
             
                       
    jmp main_loop                                                                     ;end main loop
 
    
    player_up:                                                                        ;hide player old position
        mov cl, ' '
        mov ch, 1111b
            
        mov bx,player_pos 
        mov es:[bx], cx
        
        sub player_pos, 160d                                                          ;set new postion of player
        mov direction, 0    
    
        jmp main_loop           
        
                                                             
        
    player_down:
        mov cl, ' '                          
        mov ch, 1111b                                                                 ;hide old one and set new postion
                                              
        mov bx,player_pos 
        mov es:[bx], cx
        
        add player_pos,160d                                                           
        mov direction, 0
        
        jmp main_loop
    
    key_pressed:                                                                      ;input hanaling section
        mov ah,0
        int 16h
    
        cmp ah,48h                                                                    ;go upKey if up button is pressed
        je upKey
        cmp ah, 50h
        je downKey
        
        cmp ah,39h                                                                    ;go spaceKey if up button is pressed
        je spaceKey
        
        jmp main_loop
                              
                              
                              
        
    upKey:                                                                            ;set player direction to up
        mov direction, 10d
        jmp main_loop     
        
        
    
    downKey:
        mov direction, 4d                                                             ;set player direction to down
        jmp main_loop     
        
        
        
    spaceKey:                                                                         ;shoot a arrow
        cmp arrow_status,0
        je  fire_arrow
        jmp main_loop
                                  
                                  
                                  
    fire_arrow:                                                                       ;set arrow postion in player position
        mov dx, player_pos                                                            ;so arrow fire from player postion
        mov arrow_pos, dx
        
        mov dx,player_pos                                                             ;when fire an arrow it also set limit
        mov arrow_limit, dx                                                           ;of arrow. where it should be hide
        add arrow_limit, 22d  
        
        mov arrow_status, 1d                                                          ;set arrow status.It prevents multiple 
        jmp main_loop                                                              
        
        
         
    
    miss_loon:
        add miss,1                                                                    ;update score
                         
        call show_score                                                               ;display score
        lea dx,state_buf
        mov ah,09h
        int 21h
                                                                                      ;new line
        mov ah,2                            
        mov dl, 0dh
        int 21h
    jmp fire_loon               
    
    
        
    fire_loon:                                                                        ;fire new balloon
        mov loon_pos, 3860d                                                          
        jmp render_loon
        
    hide_arrow:
        mov arrow_status, 0                                                           ;hide arrow
        
        mov cl, ' '
        mov ch, 1111b
        
        mov bx,arrow_pos 
        mov es:[bx], cx
        
        cmp loon_pos, 0d 
        jle miss_loon
        jne render_loon 
        
        jmp main_loop
                      
    
    game_over:
        mov ah,09h
        mov dx, offset game_over_str
        int 21h                  

main endp


proc show_score
    lea bx,state_buf
    
    mov dx, hits
    add dx,48d  
    
    mov [bx], 9d
    mov [bx+1], 9d
    mov [bx+2], 9d
    mov [bx+3], 9d
    mov [bx+4], 'H'
    mov [bx+5], 'i'                                        
    mov [bx+6], 't'
    mov [bx+7], 's'
    mov [bx+8], ':'
    mov [bx+9], dx
    
    mov dx, miss
    add dx,48d
    mov [bx+10], ' '
    mov [bx+11], 'M'
    mov [bx+12], 'i'
    mov [bx+13], 's'
    mov [bx+14], 's'
    mov [bx+15], ':'
    mov [bx+16], dx
ret    

end main
