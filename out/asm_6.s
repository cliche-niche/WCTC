.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_6.sum@int[]@int
func1:
		pushq	%rbp
		movq	%rsp,	%rbp
		pushq	%rbx
		pushq	%rdi
		pushq	%rsi
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15
		sub	$64,	%rsp

		# result = 0;
		movq	$0,	-64(%rbp)

		# i = 0;
		movq	$0,	-72(%rbp)

		# ##t1 = i < size;
L6:
		movq	-72(%rbp),	%rdx
		movq	16(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-80(%rbp)

		# if_false ##t1 goto 21;
		movq	-80(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L21

		# ##t2 = i;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t3 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t4 = *(##t3 + 8);
		movq	-96(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t2 = ##t2 * 8;
		movq	-88(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t2 = ##t2 + 16;
		movq	-88(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t3 = ##t3 + ##t2;
		movq	-96(%rbp),	%rdx
		add	-88(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t3 = *(##t3);
		movq	-96(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t5 = ##t3;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t6 = result;
		movq	-64(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t6 = ##t6 + ##t5;
		movq	-120(%rbp),	%rdx
		add	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# result = ##t6;
		movq	-120(%rbp),	%rdx
		movq	%rdx,	-64(%rbp)

		# i = i + 1;
		movq	-72(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-72(%rbp)

		# goto 6;
		jmp	L6

		# return result;
L21:
		movq	-64(%rbp),	%rax
		add	$64,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# end_func
		add	$64,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_6.main@String[]
main:
func2:
		pushq	%rbp
		movq	%rsp,	%rbp
		pushq	%rbx
		pushq	%rdi
		pushq	%rsi
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15
		sub	$96,	%rsp

		# ##t7 = 5;
		movq	$5,	-64(%rbp)

		# ##t8 = 56;
		movq	$56,	-72(%rbp)

		# push_param 56;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$56

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t9 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t8 = ##t9;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t8) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t9 = ##t9 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t9) = ##t7;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# arr = ##t8;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# i = 0;
		movq	$0,	-96(%rbp)

		# ##t10 = i < 5;
L36:
		movq	-96(%rbp),	%rdx
		movq	$5,	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-104(%rbp)

		# if_false ##t10 goto 48;
		movq	-104(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L48

		# ##t11 = i;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t12 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t13 = *(##t12 + 8);
		movq	-120(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t11 = ##t11 * 8;
		movq	-112(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t11 = ##t11 + 16;
		movq	-112(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t12 = ##t12 + ##t11;
		movq	-120(%rbp),	%rdx
		add	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t14 = i * i;
		movq	-96(%rbp),	%rdx
		imul	-96(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# *(##t12) = ##t14;
		movq	-136(%rbp),	%rax
		movq	-120(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# i = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# goto 36;
		jmp	L36

		# push_param arr;
L48:
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-88(%rbp)

		# push_param 5;
		pushq	$5

		# call_func test_6.sum@int[]@int;
		call	func1
		add	$16,	%rsp

		# ##t15 = return_value;
		mov	%rax,	-144(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# result = ##t15;
		movq	-144(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# push_param result;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-152(%rbp)

		# call_func print;
		call	print
		add	$8,	%rsp

		# return_value;
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# end_func
		movq	$60,	%rax
		xor	%rdi,	%rdi
		syscall

		# begin_func test_6##Default
func3:
		pushq	%rbp
		movq	%rsp,	%rbp
		pushq	%rbx
		pushq	%rdi
		pushq	%rsi
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15

		# end_func
		add	$0,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret
print:
    pushq	%rbp
    mov	%rsp,	%rbp
    pushq	%rbx
    pushq	%rdi
    pushq	%rsi
    pushq	%r12
    pushq	%r13
    pushq	%r14
    pushq	%r15

    testq $15, %rsp
    jz is_print_aligned

    pushq $0                 # align to 16 bytes

    lea  integer_format(%rip), %rdi
    movq  16(%rbp), %rsi      
    xor %rax, %rax          
    call printf

    add $8, %rsp
    jmp print_done

is_print_aligned:

    lea  integer_format(%rip), %rdi
    movq  16(%rbp), %rsi          
    xor %rax, %rax         
    call printf
    
print_done: 

    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rsi
    popq %rdi
    popq %rbx
    popq %rbp

    ret
allocmem:
    pushq	%rbp
    mov	%rsp,	%rbp
    pushq	%rbx
    pushq	%rdi
    pushq	%rsi
    pushq	%r12
    pushq	%r13
    pushq	%r14
    pushq	%r15

    testq $15, %rsp
    jz is_mem_aligned

    pushq $0                 # align to 16 bytes
    
    movq 16(%rbp), %rdi
    call malloc

    add $8, %rsp             # remove padding

    jmp mem_done

is_mem_aligned:

    movq 16(%rbp), %rdi
    call malloc
   
mem_done: 

    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rsi
    popq %rdi
    popq %rbx
    popq %rbp

    ret
