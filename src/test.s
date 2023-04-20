[H[2J[3J		.global
			_start
		.text
_start:
Example..main.String[]:
		pushq	%rbp
		lea	8(%rsp),	%rbp
		pushq	%rbx
		pushq	%rdi
		pushq	%rsi
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15
		sub	$24,	%rsp
		mov	$2,	-72(%rbp)
		mov	$3,	-80(%rbp)
L.5:
		mov	-72(%rbp),	%rdx
		mov	$35,	%rcx
		cmp	%rdx,	%rcx
		jl	1f
		mov	$0,	%rdx
		jmp	2f
1:
		mov	$1,	%rdx
		jmp	2f
2:
		mov	%rdx,	-88(%rbp)
		cmp	$0,	%rdx
		je	L.10
		mov	-72(%rbp),	%rdx
		add	$1,	%rdx
		mov	%rdx,	-72(%rbp)
		mov	-72(%rbp),	%rdx
		imul	-80(%rbp),	%rdx
		mov	%rdx,	-80(%rbp)
		jmp	L.5
L.10:
		mov	$60,	%rax
		xor	%rdi,	rdi
		syscall
