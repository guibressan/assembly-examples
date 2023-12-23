.intel_syntax noprefix # instead of default at&t syntax, use intel syntax

.section .data
	str: .asciz "Hello from the cpu!\n"
	strlen: .long 21

.section .text

.global _start

_start:
	push rbp			# Store value of old base pointer
	mov rbp, rsp	# Move stack pointer to new base pointer value
	sub rsp, 0x4	# "allocate" 4 bytes in the stack

	mov esi, 0x5	# Set the second argument
	mov edi, 0x3	# Set the first argument
	push offset ret_addr	# Push the return address in the stack (we don't do 
												# this manually), call does it for us.
												# ret_addr will be stored at rbp-0x8 (64 bits)
	jmp add				# Jump to the add function
ret_addr:				# add function will pop the ret_addr from the stack
	mov [rbp-0x4], eax	# Store return value in the stack
	lea rdi, str		# Load print buf argument
	mov esi, strlen	# Load the print count argument
	call print			# Jump to print and push program counter to the stack
	mov edi, [rbp-0x4]	# Passing the add result to function exit 
									# (can be any register, but edi/rdi is used for the first
									# argument by convention).
	jmp exit				# Just jump, exit will not return so we don't need to push
									# the return address to the stack

exit:
	push rbp		
	mov rbp, rsp
	sub rsp, 0x4

	mov [rbp-0x4], edi	# Storing the argument in the stack
											# (32  bits == 4 bytes == sizeof(int) on x86-64)		
	mov rax, 0x3c				# EXIT syscall (linux x86-64)
	mov edi, [rbp-0x4]	#	loading the exit status argument from the stack 
	syscall							# Sending signal to kernel

add:
	push rbp
	mov rbp, rsp
	sub rsp, 0x8

	mov [rbp-0x4], edi	# store first arg in the stack
	mov [rbp-0x8], esi	# store second arg in the stack
	mov edx, [rbp-0x4]	# load first argument on edx
	mov eax, [rbp-0x8]	# load second argument on eax
	add eax, edx				# eax becomes eax + edx

	mov rsp, rbp	# "Free" the stack
	pop rbp			# Restore rbp
	pop rbx			# Load return address
	jmp rbx			# Jump to the return address
							# Obs: this jmp instruction is what turns possible
							# exploiting stack overflows, overwriting the stack
							# and setting another return address

print:
	push rbp
	mov rbp, rsp
	sub rsp, 0xc

	mov [rbp-0x8], rdi	# store buf addr
	mov [rbp-0xc], esi	# store count
	mov rax, 1					# sys_write
	mov rdi, 1					# fd stdout
	mov rsi, [rbp-0x8]	# buf
	mov edx, [rbp-0xc]	# count (32 bits)
	syscall

	mov rsp, rbp
	pop rbp
	ret


