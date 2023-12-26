.section .text

.global add

add:
	sub sp, sp, #0x10 
	stp w0, w1, [sp]	
	add w0, w0, w1		
	add sp, sp, #0x10
	ret								
