.MODEL SMALL  
.STACK 100H

.DATA       
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
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *          >>>>Press Enter to start<<<<             *',0ah,0dh,
   dw '              *                                                   *',0AH,0DH,
   dw '              *                                                   *',0AH,0DH,
   dw '              *****************************************************',0AH,0DH,'$' 


.CODE

    MAIN PROC 
           

        MOV AX,@DATA

        MOV DS,AX                           
        mov ah,9 
        mov dx,offset start_message
        int 21h
       

  MAIN ENDP

END MAIN
