.intel_syntax noprefix

.section .note.GNU-stack,"",@progbits

.section .text

.global add

add:
	push rbp
	mov rbp, rsp
	sub rsp, 0x8
	mov [rbp-0x4], edi
	mov [rbp-0x8], esi
	mov edx, [rbp-0x4]
	mov eax, [rbp-0x8]
	add eax, edx			
	mov rsp, rbp
	pop rbp			
	ret
