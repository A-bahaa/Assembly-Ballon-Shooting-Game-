
.MODEL LARGE  
.STACK 100H

.DATA

   
   
   
   ; Why each line of the message on the form '  ' , 0ah,0dh . i.e what is the use of 0ah,0dh ? 
   
   ; here is the answer from Quora .. 0ah is for line feed (moves to next output line) & 0dh is for carriage return.
   ; Carriage return has ASCII value 13 or 0XD & Linefeed has value 10 or 0XA.
   ; Carriage return means to return to the beginning of the current line without advancing downward. 
   ; so they're for formatting purposes 


    
   
   
   
   
   
          
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
   dw "              *  Take Care You only get 9 misses then you're out  *",0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *          >>>>Press Enter to start<<<<             *',0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *****************************************************',0AH,0DH,'$'   ;the dollar indicating the end of the message
   
   
   loon_pos1 dw 3896d
   loon_pos2 dw 3860d
   
   player_pos dw 1760d
    
   arrow_pos dw 0d 
   arrow_limit dw 60d   
   arrow_status dw 0d
   
   direction dw 0d 


.CODE

   MAIN PROC
    
    
    
         
           

        MOV AX,@DATA                                                                      ; load in AX the address of the data segment
        MOV DS,AX
        
        mov ax, 0B800h                                                                    ; move 0B800h into ax
                                                                                          ; 0B800h is the address of VGA card for text mode
        mov es,ax                                                                         ; move AX into es, so es hold the address of VGA card  
                                                                                          ; VGA text buffer is used in VGA compatible text mode.
                                                                                          ; Each character in screen is represented by two bytes or by 16 bits.
                                                                                          ; ES: segment in the memory which is auxiliary data segment in the memory
                                                                                          ; ES is the default destination for string operations 
                                                                                           
                                                                                          
        LEA DX,start_message                                                              ; Load the effective address of the string in dx using LEA command                           
        MOV AH,09H                                                                        ; Print the message by calling the interrupt with 9H in AH
        INT 21H                                                                           ; the interrupt command
        
        input:
            
            MOV AH,0h                                                                     ;int 16h is a bios interrupt used to provide keyboard services.
            INT 16h                                                                       ;int 16h / ah=00h -> get keystroke (read key press).
                                                                                          ;if there is no character in the keyboard buffer, the function waits until any key is pressed.
            
            CMP AL,13d                                                                    ;check if the "ENTER" button is pressed (13d is the ascii code for carriage return (enter) 
            JNE input                                                                     ;if another button is pressed go to the input again the code will never proceed unless you hit "ENTER"
            
            
                                                                                          ;clearing the screen to go to start the game
            mov ah,0                                                                      ;set display mode function (video mode)
            mov al,2                                                                      ;mode 2 = text 80 x 25 16 grey
            int 10h                                                                       ;video service bios interrupt
                    
             
                    
                    
            main_loop:
            
            
               
                 mov cl, 16d                         ;draw player 
                 mov ch, 1111b                       ;controls the color
                
                 mov bx,player_pos 
                 mov es:[bx], cx 
        
                 mov ah,01h                          ;int 16 / ah=01 -> check for keystroke (Get the State of the keyboard buffer)
                 int 16h               
                                       
                 jne key_pressed                     ;jmp if zero flag == 0
                
                 cmp direction,10d                   ;check if the direction variable change to 10d (up)
                 je player_up                        
                                                       
                 cmp direction,4d                   ;check if the direction variable change to 4d (down)
                 je player_down                     
                 
                 cmp arrow_status,1                 ;check any arrow to rander
                 je render_arrow
 
                 cmp loon_pos1, 0d                   ;check missed loon1
                 jle fire_loon1
             
                 cmp loon_pos2, 0d                   ;check missed loon2
                 jle fire_loon2
                 
                  
                
              
             
            render_loon1:
            
            
                mov cl, ' '                    ;hide old loon
                ;mov ch, 1111b
        
                mov bx,loon_pos1 
                mov es:[bx], cx
                
                sub loon_pos1,160d              ;and draw new one in new position
                
                mov cl, 49d
                mov ch, 1101b
        
                mov bx,loon_pos1 
                mov es:[bx], cx
                
                
                jne render_loon2  
                
                
              
              
              
             render_loon2:
            
            
                mov cl, ' '                    ;hide old loon
                ;mov ch, 1111b
        
                mov bx,loon_pos2 
                mov es:[bx], cx
                
                sub loon_pos2,320d              ;and draw new one in new position
                
                mov cl, 53d
                mov ch, 1101b
        
                mov bx,loon_pos2 
                mov es:[bx], cx
                
                jne main_loop
              
              
              
                    
            
            
            render_arrow: 
            
            
                mov cl, ' ' 
                mov ch, 1111b
                mov bx, arrow_pos
                mov es:[bx], cx
    
                add arrow_pos,4d               ;draw new position
                mov cl, 26d                    ;draw the arrow
                mov ch, 1011b
                
                mov bx,arrow_pos
                mov es:[bx], cx
                
                mov dx,arrow_limit             ;check if the arrow reach the end position. 
                cmp arrow_pos, dx
                jge hide_arrow
                
                
                jmp render_loon1                   
                   
           
            
            
                    
                    
            fire_loon1: 
            
            
                mov loon_pos1 , 3896d     ; relocating loon1
                jmp render_loon1
                                  
             
                                  
            fire_loon2: 
            
            
                mov loon_pos2 , 3860d     ; relocating loon2
                jmp render_loon2                         
                                  
                                  
                                  
            fire_arrow:
           
           
                mov dx, player_pos        ;update the arrow position with the player position
                mov arrow_pos, dx
                add arrow_limit, dx       ;calculate the end position of the arrow.
                mov arrow_status, 1d      ;update the arrow status
                jmp render_arrow
             
           
             
            
            
            player_up:   
            
            
            
                mov cl, ' '
                mov ch, 1111b
                
                mov bx,player_pos
                mov es:[bx], cx
                
                sub player_pos, 160d                  ;set new postion of player
                mov direction, 0                      ;reset direction variable
                
                jmp main_loop  
                
              
              
                
                
            player_down: 
            
            
            
                mov cl, ' '
                mov ch, 1111b
                
                mov bx,player_pos
                mov es:[bx], cx
                
                add player_pos, 160d                  ;set new postion of player
                mov direction, 0                      ;reset direction variable
                
                jmp main_loop 
                
                
                
            
            key_pressed: 
            
            
               
                mov ah,0h                             ;get keystroke (Read key press)
                int 16h
                
                cmp ah,48h                            ;go upKey if up button is pressed
                je upKey
                
                
                cmp ah,50h                            ;go downKey if down button is pressed
                je downKey
                
                
                cmp ah,39h
                je spaceKey                           ;go spaceKey if space button is pressed
                
                                                                                     
                jmp main_loop
                
                
                
                
            upkey: 
                   
                   
                mov direction, 10d                   ;update direction variable with 10d if the key is up
                jmp main_loop                        
                     
                     
            downkey: 
                    
                    
                mov direction, 4d                    ;update direction variable with 4d if the key is up
                jmp main_loop 
                      
                      
            spaceKey:
                     
                                                     
                cmp arrow_status, 0                  ;check if there is arrow in the screen
                je fire_arrow                        
                jmp main_loop                        
               
           
           
                      
                               
            hide_arrow:
                 
                 
                mov arrow_status, 0                  ;reset arrow status
                mov arrow_limit, 60d                 ;reset arrow limit
                mov cl, ' '                          ;hide the arrow
                mov ch, 1111b 
                mov bx,arrow_pos
                mov es:[bx], cx 
                jmp main_loop 
                


   MAIN ENDP

END MAIN
