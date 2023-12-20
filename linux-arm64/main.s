.section .data

str: .asciz "hello from the cpu!\n"
strlen: .word 21

.section .text

.global _start

exit:
	mov x8, #93
	mov x0, #0x0
	mov x16, #0x0
	svc #0x0

_start:
	b exit
