.section .data

str: .asciz "hello from the cpu!\n"
strlen: .word 21

.section .text

.global _start

exit:
	mov x8, #93			// linux exit syscall
	// mov x0, #0x0 // status argument
	svc #0x0				// supervisor call (throw exception to EL1)		
	ret

print_msg:
	mov x8,	#64				// write syscall
	mov x0,	#0x0			// STDOUT_FD
	ldr x1,	=str			// buffer
	mov w2, [strlen]	// buflen
	svc #0x0					// supervisor call
	ret								// branch to the address at x30

_start:
	stp x29, x30, [sp, #-16]!
	bl print_msg
	mov x0, #0x0
	b exit
	ldp x29, x30, [sp], #16
