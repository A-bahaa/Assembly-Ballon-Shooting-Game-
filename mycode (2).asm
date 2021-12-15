



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


.CODE

   MAIN PROC
    
    
    
         
           

        MOV AX,@DATA                                                                      ; load in AX the address of the data segment
        MOV DS,AX
        
        mov ax, 0B800h
        mov es,ax 
        
                                                                                 ; move AX address to segment register(DS)
        LEA DX,start_message                                                              ; Load the effective address of the string in dx using LEA command                           
        MOV AH,09H                                                                        ; Print the message by calling the interrupt with 9H in AH
        INT 21H                                                                           ; the interrupt command
        
        input:
            
            MOV AH,01h                                                                    ;INT 21h / AH=1 - read character from standard input, result is stored in AL.
                                                                                          ;if there is no character in the keyboard buffer, the function waits until any key is pressed.
            INT 21h
            CMP AL,13d                                                                    ;check if the "ENTER" button is pressed (13d is the ascii code for carriage return (enter) 
            JNE input                                                                     ;if another button is pressed go to the input again the code will never proceed unless you hit "ENTER"
            
            
                                                                                          ; clearing the screen to go to start the game
            mov ah,0                                                                      
            mov al,2
            int 10h
            jmp main_loop
         
            
        
        main_loop:
        
        
        
        
             
             
             
             mov cl, 16d                  ;draw player 
             mov ch, 1111b                ;controls the color
            
             mov bx,player_pos 
             mov es:[bx], cx
             
             
             
             cmp loon_pos1, 0d                   ;check missed loon1
             jle fire_loon1
             
             
             
             cmp loon_pos2, 0d                   ;check missed loon2
             jle fire_loon2
             
        
        
        
            jmp render_loon1
             
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
                
                jmp render_loon2
                
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
                
                jmp main_loop
                
                
                
                
            fire_loon1:
                mov loon_pos1 , 3896d     ; relocating loon1
                jmp render_loon1
            
                
            fire_loon2:
                mov loon_pos2 , 3860d     ; relocating loon2
                jmp render_loon2    
                
            
        
        
            
                                                                                
        
                  
        
        
        

   MAIN ENDP

END MAIN
