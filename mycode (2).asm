
.model large                                ;supports multiple code and multiple data segments.   
.stack 100h   ;a segment directive which defines 100h words as program STACK.
              ;Windows programs are loaded at much higher addresses.
              ;100h doesn't tell the assembler where to store the data, 
              ;it tells the assembler what address it will be loaded at, so it can emit correct absolute addresses.                                                               
.data


same_p1 db 0d ;If the same player1 is playing and it's not a new one
same_p2 db 0d ;If the same player2 is playing and it's not a new one

player_pos dw 1760d                         ;position of player

arrow_pos dw 0d                             ;position of arrow
arrow_status db 0d                          ;0 = arrow ready to go else not 
arrow_limit dw  22d                         ;150d

loon_pos dw 3860d              
         
direction db 0d                             ;direction of player 
                                            ;up=8, down=2

high_score dw ' ',0ah,0dh,                  ;Highscore variables
dw ' ',0ah,0dh, 
dw '                                  High Scores: ',0ah,0dh,  ; 0ah,0dh,: to make a new line and make the cursor starts from the first of the line
                                                               ;so it's for moveing to next output line return to the beginning of the current line 
                                                               ;without advancing downward. 
dw ' ',0ah,0dh,
dw ' ',0ah,0dh,
dw  '                            Name:      |      Score: $'       ,0ah,0dh,    ; ( $ ) means the end of the string 
                                                                                ; so it serves to terminate the sting like null does in C.
name_list dw    '                                                                                                                                                                $',0ah,0dh,   ;0ah,0dh, for highscore list displaying  

     
state_buf db 'aaaaaaaassssssssssssssssssssss$',0ah,0dh,          ;score veriable    


hits dw 0d
miss dw 0d

highScore dw 0d

new_highScore1 dw 0d
new_highScore2 dw 0d

newn_highScore1 dw 0d
newn_highScore2 dw 0d
     

game_over_str dw '  ',0ah,0dh
 
dw ' ',0ah,0dh 
dw    '          --------------------------------------------------------      ',0ah,0dh
dw    '          ########################################################      ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                                Game Over',0ah,0dh
dw '                        Press Enter to start again',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                        For 1st player press ( 1 ) ',0ah,0dh
dw '                        For 2nd player press ( 2 ) ',0ah,0dh
dw '                     For retry wit current player press ( enter ) $',0ah,0dh  

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



msg         db 0ah, 0dh, " UserName: $"  ;10 is the ASCII control code for line feed while 13 is the code for carriage return. 
                                       ;The line feed control code moves the cursor to the next line, 
                                       ;while the carriage return code moves the cursor to the start of line. 
                                       ;Together the two control codes move the cursor to the start of the next line.
                                         
arr1 dw 2 dup(?)                       ;for storing player 1's name as 2 chars and ? means you can store any random value
arr2 dw 2 dup(?)                       ;for storing player 2's name as 2 chars and ? means you can store any random value

player db 0d                           ;to see if it's the first time to play or not

.code
main proc  



   


    
mov ax,@data
                                                                                      
     
    MOV AX,@DATA                                                                      ;@DATA is a variable that holds the value of the 
                                                                                      ;location in memory where the data segment lives.
                                                                         
    MOV DS,AX                                                                         ; load in AX the address of the data segment
    
    
    
    mov ax, 0B800h                                                                    ; move 0B800h into ax
                                                                                      ; 0B800h is the address of VGA card for text mode
    mov es,ax                                                                         ; move AX into es, so es hold the address of VGA card  
                                                                                      ; VGA text buffer is used in VGA compatible text mode.
                                                                                      ; Each character in screen is represented by two bytes or by 16 bits.
                                                                                      ; ES: segment in the memory which is auxiliary data segment in the memory
                                                                                      ; ES is the default destination for string operations 
   start:
    
     lea dx,  start_message                                                            ; Load the effective address of the string in dx using LEA command
     MOV AH,09H                                                                        ; Print the message by calling the interrupt with 9H in AH
     INT 21H                                                                           ; the interrupt command
        
        
        
    input:
    
        mov ah,1                                                                      ; wait for input      
        int 21h
        cmp al,49d                                                                    ;For 1st player
        je display_name1
        cmp al,13d                                                                    ; cmpare if the input equal to asci of enter for game starting
                                                                                      ; and retry using current player
        je continue
        cmp al,50d                                                                    ;For 2nd player
        call clear_screen  
        je   display_name2
        cmp player,1
        je  game_over                                                                    
        jne start 
  continue:
      
        
        mov ah,0                                                                          ;clearing the screen to go to start the game
        mov al,3                                                                          ;set display mode function (video mode)
        int 10h                                                                           ;mode 2 = text 80 x 25 16 grey
                                                                                      ;video service bios interrupt
   
     cmp  player, 0                                                                    ;first time to play
     je   display_name1
     cmp  player, 1
     je   show_name1
     jne  show_name2                                                                   ;New player
     
       
    

                                                                   
main_loop:                                 
                                           
        mov ah,01h                                                                    ;int 16 / ah=01 -> check for keystroke (Get the State of the keyboard buffer)                                                                       
        int 16h  
                                 
                                 
                                   
        jne key_pressed                                                               ;jmp if zero flag == 0 
        
 
        cmp miss , 8                                                                  ; check number of misses and zf == 1                                                               
        jge game_over                                                                 ; if zf == 1 then close the program
        
        
        
        mov dx,arrow_pos   
        
        
                                                                  
        cmp dx, loon_pos                                                              ;checking collitions
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
            
            inc hits
            cmp player, 1
            
            je  p1shoot
            jne p2shoot
            
                                                                             
 
            
                          
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
            
            
            cmp hits, 2                                                                ;compare for speed levels
            je loon_2x
            cmp hits, 3
            je loon_2x                                                                  ;double speed
            jg loon_3x                                                                  ;triple speed
            
                
            sub loon_pos,160d                                                        ;and draw new one in new position
            
            mov cl, 15d
            mov ch, 0010b
        
            mov bx,loon_pos 
            mov es:[bx], cx
            
            cmp arrow_status,1d                                                       ;check any arrow to rander
            je render_arrow
            jne inside_loop2
            
            
             
            
        loon_2x: sub loon_pos,320d                                                         ;draw a faster new loon in new position if hits are grater or equal to 4 hits 
            
            mov cl, 15d
            mov ch, 0010b
        
            mov bx,loon_pos 
            mov es:[bx], cx
            
            cmp arrow_status,1d                                                       ;check any arrow to rander
            je render_arrow
            jne inside_loop2      
        
            
         loon_3x: sub loon_pos,640d                                                         ;draw a faster new loon in new position if hits are grater or equal to 4 hits 
            
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
 
    
    player_up: 
                                                                           ;hide player old position
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
    
    key_pressed:
                                                                          ;input hanaling section
        mov ah,0
        int 16h
    
        cmp ah,48h                                                                    ;go upKey if up button is pressed
        je upKey
        cmp ah, 50h
        je downKey
        
        cmp ah,39h                                                                    ;go spaceKey if up button is pressed
        je spaceKey
        
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         cmp ah,4Bh                            ;go leftKey (this is for debuging)     miss++
         je leftKey
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         cmp ah,4Dh                            ;go rightKey (this is for debuging)    hit++
         je rightKey
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         
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
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                              
     leftKey:                                  ;we use it for debuging 
    ;jmp game_over
    inc miss
            
    lea bx,state_buf
    call show_score 
    lea dx,state_buf
    mov ah,09h
    int 21h
    
    mov ah,2
    mov dl, 0dh
    int 21h
jmp main_loop                             
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                              
     rightKey:                                  ;we use it for debuging 
    ;jmp game_over
    
    jmp hit
            
    lea bx,state_buf
    call show_score 
    lea dx,state_buf
    mov ah,09h
    int 21h
    
    mov ah,2
    mov dl, 0dh
    int 21h
jmp main_loop                             
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                               
    fire_arrow:
                                                                           ;set arrow postion in player position
        mov dx, player_pos                                                            ;so arrow fire from player postion
        mov arrow_pos, dx
        
        mov dx,player_pos                                                             ;when fire an arrow it also set limit
        mov arrow_limit, dx                                                           ;of arrow. where it should be hide
        add arrow_limit, 22d  
        
        mov arrow_status, 1d 
                                                                 ;set arrow status.It prevents multiple 
        jmp main_loop                                                              
                
    
    miss_loon: 
    
        add miss,1                                                                    ;update score
                         
        call show_score                                                               ;display score
        lea dx,state_buf
        mov ah,09h                                                                    ;Instantly update the hit value
        int 21h                                                                       ;interrupt to update
        
                                                                                      ;new lin: write the char on the screen & dl is the char to input(dx = hit = dl + dh)e
        mov ah,2                                                                      ;carriage return and moves the cursor back like if i will do- printf("stackoverflow\rnine") ninekoverflow
        mov dl, 0dh                                                                   ;so it overwrites on hit score (0 -> 1 => 1-> 2 etc. )
        int 21h  
        
        jmp fire_loon               
    
    
        
    fire_loon:
                                                                            ;fire new balloon
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

        call clear_screen
        mov newn_highscore1, 0                                                      ;Reset the last new score
        mov newn_highscore2, 0
        
        mov ah, 0h                                                                  ; halts the program while waiting for input
        mov ah, 9h
        mov dx, offset high_score
        int 21h
        
        call score_list
        mov ah,0h
        mov ah,09h
        mov dx, offset name_list
        
        int 21h
        
        
        mov ah,09h                                                                    ;enabling writing on the screen
        mov dx, offset game_over_str                                                  ;print game over screen 
        int 21h 
        
        mov cl, ' '                                                                   ;Hide all
        mov bx, arrow_pos
        mov bx, player_pos
        
        mov hits, 0                                                                   ;Reset all
        mov miss, 0
      
        
        mov player_pos, 1760d
        
        mov arrow_pos, 0d
        mov arrow_status, 0d
        mov arrow_limit, 22d    
        
        mov loon_pos, 3860d       
         
        mov direction, 0d
        
        
        
        jmp input                                                                     ;press Enter to play again
        
        
        
        
    update_highScore1:                                                             ;updating highscore during the game
            
        mov new_highscore1, ax
        mov cx, ax
        mov highScore, cx
            
            
        call show_score                                                           ;display score 
        lea dx,state_buf
        mov ah,09h
        int 21h
            
        mov ah,2                                                                  ;new line
        mov dl, 0dh
        int 21h    
     
        jmp fire_loon    
            
     update_highScore2:                                                           ;updating highscore during the game
      
        mov new_highscore2, ax    
        mov cx, ax
        mov highScore, cx
            
            
        call show_score                                                           ;display score 
        lea dx,state_buf
        mov ah,09h
        int 21h
            
        mov ah,2                                                                  ;new line
        mov dl, 0dh
        int 21h    
     
        jmp fire_loon    
                       
 
      
   show_name1:
       call clear_screen
       mov ax, @data                                                                     
       mov ds, ax
       lea dx, msg                                                                  ;user name message
       mov ah, 09h                                                                       
       int 21h
       
       mov si, offset arr1                                                          ;for player1 name output && ( si ) is source index that point to arr1
       mov cx, 2                                                                    ;for looping to print the name from the array
         
    loop2nd:
    
       mov dl, [si]
       mov ah, 02h                                                                  ;for printing the first index then others 
                                                                                    ;by incrementing si and looping with cx
       int 21h
          
       mov ah, 02   
       mov dl, 0                                                                    ;make dl empty to be ready to read the next char 
       int 21h
       
       inc si
       loop loop2nd                                                                 ;loop cx=2 times

       mov ah, 2
       mov dl, 0ah                                           ;A=10 make the cursor move to the next line
       int 21h
       mov dl, 0dh                                           ;D=13 make the cursor start from the first of the line ((Like defining the MSGG in the code segment)) 
       int 21h    
   
     
   
   
                    
       call show_score                                                                   ;display score
       lea dx,state_buf
       mov ah,09h
       int 21h

       mov ah,2                                                                          ; print new line
       mov dl,0dh
       int 21h   
       mov player,1                                                                      ;to distinguish player2
      jmp main_loop
       
    show_name2:
      
      mov ax, @data                                                                     ;display name (put before the show score proc as it's not repeated and there is no need for a new line)
       mov ds, ax
       lea dx, msg
       mov ah, 09h                                                                       ;output
       int 21h
       
       mov si, offset arr2
       mov cx, 3 
         
    loop22nd:
    
       mov dl, [si]
       mov ah, 02h
       int 21h
          
       mov ah, 02   
       mov dl, 0 
       int 21h
       
       inc si
       loop loop22nd

       mov ah, 2
       mov dl, 0ah                                           ;A=10 make the cursor move to the next line
       int 21h
       mov dl, 0dh                                           ;D=13 make the cursor start from the first of the line ((Like defining the MSG in the code segment)) 
       int 21h    
   
               
       call show_score                                                                   ;display score
       lea dx,state_buf
       mov ah,09h
       int 21h

       mov ah,2                                                                          ; print new line
       mov dl,0dh
       int 21h 
       mov player, 2                                                                     ;to distinguish player2
        jmp main_loop 
        
        
        
   p1shoot:                                                                 ;player1 is currently playing and made a shoot successfully
   
      
       inc newn_highScore1
       mov dx, new_highScore1
       mov cx, newn_highScore1
       cmp cx, dx
       jg update_new1 
                                                                            ;update score
            
       mov bx, highScore
       mov ax, new_highScore1 
            
            
       cmp ax, bx  
            
       jg update_highScore1 
       
       call show_score                                                           ;display score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                                                                  ;new line
            mov dl, 0dh                                                               
                                                                                         
           
            int 21h    
            
            
                   
            jmp fire_loon                                                             ;new loon pops up 
       
   p2shoot:                                                                  ;player2 is currently playing and made a shoot successfully
      
       inc newn_highScore2
       mov dx, new_highScore2
       mov cx, newn_highScore2
       cmp cx, dx
       jg update_new2                                                                   ;update score
            
       mov bx, highScore
       mov ax, new_highScore2 
            
            
       cmp ax, bx  
            
       jg update_highScore2    
       
       call show_score                                                           ;display score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                                                                  ;new line
            mov dl, 0dh                                                               
                                                                                         
           
            int 21h    
            
            
                   
            jmp fire_loon                                                             ;new loon pops up 
                          
                          
     update_new1:                                                                    ;for updating highscore during the game
         mov dx, cx 
         mov new_highscore1, dx                                                      ;to insure saving the gameover highscore
         mov bx, highScore
         mov ax, dx 
            
            
       cmp ax, bx  
            
       jg update_highScore1 
       
       call show_score                                                           ;display score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                                                                  ;new line
            mov dl, 0dh                                                               
                                                                                         
           
            int 21h    
            
            
                   
            jmp fire_loon                                                             ;new loon pops up 
         
     update_new2:                                                                     ;for updating highscore during the game
       mov dx, cx
       mov bx, highScore
       mov ax, dx 
            
            
       cmp ax, bx  
       mov new_highscore2, ax                                                       ;to insure saving the gameover highscore
       jg update_highScore2    
       
       call show_score                                                           ;display score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                                                                  ;new line
            mov dl, 0dh                                                               
                                                                                         
           
            int 21h    
            
            
                   
            jmp fire_loon                                                             ;new loon pops up                                             
                       








main endp


proc show_score                                                 ;game board while shooting
    
    lea bx,state_buf
    
    mov cx, highScore
   
    add cx,48d                                                        ;add 48 so that it
                                                                      ;represents the ASCII
                                                                      ;value of digits
    mov [bx],    9d
    mov [bx+1],  9d
    mov [bx+2],  9d
    
    mov [bx+3],  'H'
    mov [bx+4],  'i'                                        
    mov [bx+5],  'g'
    mov [bx+6],  'h'
    mov [bx+7],  ' '
    mov [bx+8],  'S'
    mov [bx+9],  'c'
    mov [bx+10], 'o'
    mov [bx+11], 'r'
    mov [bx+12], 'e'
    mov [bx+13], ':'
    mov [bx+14], cx  
    
    mov dx, hits
   
    add dx,48d 
    
    mov [bx+15], 9d
    mov [bx+16], 'H'
    mov [bx+17], 'i'                                        
    mov [bx+18], 't'
    mov [bx+19], 's'
    mov [bx+20], ':'
    mov [bx+21], dx
    
    mov dx, miss
    add dx,48d                                                             ;add 48 so that it
                                                                           ;represents the ASCII
                                                                           ;value of digits
    mov [bx+22], ' '
    mov [bx+23], 'M'
    mov [bx+24], 'i'
    mov [bx+25], 's'
    mov [bx+26], 's'
    mov [bx+27], ':'
    mov [bx+28], dx  

ret    
show_score endp 


clear_screen proc near
    
        mov ah,0                                                                     ;clearing the screen to go to start the game
        mov al,3                                                                      ;set display mode function (video mode)
        int 10h                                                                       ;mode 2 = text 80 x 25 16 grey                                                                                    ;video service bios interrupt        
ret
clear_screen endp 


proc display_name1
    
     cmp same_p1, 0                                                                    ;if first time to play
     jne show_name1
     
     mov player, 1                                                                     ;to distinguish player2
     
     mov ax, @data                                                                     ;display name (put before the show score proc as 
                                                                                       ;it's not repeated and there is no need for a new line)
     mov ds, ax
     lea dx, msg
     mov ah, 09h                                                                       ;output user name string
     int 21h
   

        
     mov cx, 2
     mov si, offset arr1
     
   loop1:
     mov ah,01h
     int 21h
       
     mov [si], al
     inc si
     loop loop1
      
     call clear_screen
     mov ax, @data                                                                     ;display name (put before the show score proc as
                                                                                       ;it's not repeated and there is no need for a new line)
     mov ds, ax
     lea dx, msg
     mov ah, 09h                                                                       ;output user name string
     int 21h
       
     mov si, offset arr1
     mov cx, 2 
         
   loop2:
     mov dl, [si]
     mov ah, 02h
     int 21h
          
     mov ah, 02   
     mov dl, 0 
     int 21h
       
     inc si
     loop loop2

     mov ah, 2
     mov dl, 0ah                                           ;A=10 make the cursor move to the next line
     int 21h
     mov dl, 0dh                                           ;D=13 make the cursor start from the first of the line ((Like defining the MSGG in the code segment)) 
     int 21h    
   
             
    call show_score                                                                   ;display score
    lea dx,state_buf
    mov ah,09h
    int 21h

    mov ah,2                                                                          ; print new line
    mov dl,0dh
    int 21h
    inc same_p1
    jmp main_loop 
    
ret
display_name1 endp


proc display_name2
     
     
     cmp same_p2, 0                                                                    ;if first time to play
     jne show_name2
     
     mov player, 2
     mov ax, @data                                                                     ;display name (put before the show score proc as 
                                                                                       ;it's not repeated and there is no need for a new line)
     mov ds, ax
     lea dx, msg
     mov ah, 09h                                                                       ;output
     int 21h
   

        
     mov cx, 2
     mov si, offset arr2                                                               ;for player1 name input && ( si ) is source index that point to arr1
     
   loop12:
     mov ah,01h                                                                        ;wait for an input
     int 21h
       
     mov [si], al                                                                      ;save the input char in first index of array
     inc si                                                                            ;then increment si to save in 2nd index
     loop loop12
      
     call clear_screen
     mov ax, @data                                                                     ;display name (put before the show score proc as 
                                                                                       ;it's not repeated and there is no need for a new line)
     mov ds, ax
     lea dx, msg
     mov ah, 09h                                                                       ;output
     int 21h
       
     mov si, offset arr2
     mov cx, 2 
         
   loop22:
     mov dl, [si]
     mov ah, 02h
     int 21h
          
     mov ah, 02   
     mov dl, 0 
     int 21h
       
     inc si
     loop loop22

     mov ah, 2
     mov dl, 0ah                                           ;A=10 make the cursor move to the next line
     int 21h
     mov dl, 0dh                                           ;D=13 make the cursor start from the first of the line 
                                                           ;((Like defining the MSG in the code segment)) 
     int 21h    
   
             
    call show_score                                                                   ;display score
    lea dx,state_buf
    mov ah,09h
    int 21h

    mov ah,2                                                                          ; print new line
    mov dl,0dh
    int 21h
    inc same_p2
    jmp main_loop 
    
ret
display_name2 endp


proc score_list 
    
 
    lea bx,name_list
            
    mov cx, new_highScore1
    mov ax, new_highScore2
    
    cmp cx, ax                                                                    
    jg best_1                                                                          ;player1 is better than player2
                                                                                       ;if not so continue as player2 is better.
    
    mov  dx, arr2
    add ax,48d
                                 
    mov [bx],  10d
    mov [bx+57], dx     
    mov [bx+77], ax
    
    mov  dx, arr1
       
    add cx,48d
    
    mov [bx+137],  10d
    mov [bx+138], dx
    mov [bx+158], cx     
    
    

ret
score_list endp

proc best_1
   
    mov  dx, arr1
    add cx,48d
                                 
    mov [bx],  10d
    mov [bx+57], dx     
    mov [bx+77], cx
    
    
    
    mov  dx, arr2
       
    add ax,48d
    
    mov [bx+137],  10d
    mov [bx+138], dx
    mov [bx+158], ax
ret
best_1 endp

end main 
