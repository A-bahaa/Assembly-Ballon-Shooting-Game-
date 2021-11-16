.MODEL SMALL  
.STACK 100H

.DATA       
   space  dw '                                                                     ',0AH,0DH,'$'
   msg  dw '              *****************************************************',0AH,0DH,'$'    
   msg1 dw '              *       ((    Balloon Shooting Game      ))         *',0ah,0dh,'$'
   msg2 dw '              *                                                   *',0AH,0DH,'$'  
   msg3 dw '              *      --------------------------------------       *',0ah,0dh,'$'            
   msg4 dw '              *        Use up and down key to move player         *',0ah,0dh,'$'
   msg5 dw '              *           and space button to shoot               *',0ah,0dh,'$'
   msg6 dw '              *          >>>>Press Enter to start<<<<             *',0ah,0dh,'$' 


.CODE

    MAIN PROC 
           

        MOV AX,@DATA

        MOV DS,AX                           
        mov ah,9 
        mov dx,offset space 
        int 21h
        mov ah,9  
        mov dx,offset space  
        int 21h
        mov ah,9  
        mov dx,offset space  
        int 21h  
        mov ah,9  
        mov dx,offset space  
        int 21h
        mov ah,9  
        mov dx,offset space  
        int 21h
        mov ah,9  
        mov dx,offset msg  
        int 21h
        mov ah,9  
        mov dx,offset msg2  
        int 21h 
        mov ah,9  
        mov dx,offset msg2  
        int 21h  
        mov ah,9  
        mov dx,offset msg1  
        int 21h
        mov ah,9  
        mov dx,offset msg2 
        int 21h  
        mov ah,9  
        mov dx,offset msg2 
        int 21h       
        mov ah,9  
        mov dx,offset msg3 
        int 21h
        mov ah,9  
        mov dx,offset msg4 
        int 21h
        mov ah,9  
        mov dx,offset msg5 
        int 21h
        mov ah,9  
        mov dx,offset msg3 
        int 21h
        mov ah,9  
        mov dx,offset msg2 
        int 21h
        mov ah,9  
        mov dx,offset msg2 
        int 21h
        mov ah,9   
        mov dx,offset msg6 
        int 21h
        mov ah,9  
        mov dx,offset msg2 
        int 21h   
        mov ah,9  
        mov dx,offset msg2 
        int 21h
        mov ah,9  
        mov dx,offset msg 
        int 21h

  MAIN ENDP

END MAIN