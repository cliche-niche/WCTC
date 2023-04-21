.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_4.fib@int
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
		sub	$96,	%rsp

		# ##t1 = n + 1;
		movq	24(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t2 = ##t1 * 8;
		movq	-64(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t2 = ##t2 + 16;
		movq	-72(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-72(%rbp)

		# push_param ##t2;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-72(%rbp)

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t3 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t2 = ##t3;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t2) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t3 = ##t3 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t3) = ##t1;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# memo = ##t2;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# i = 0;
		movq	$0,	-96(%rbp)

		# ##t4 = i <= n;
L17:
		movq	-96(%rbp),	%rdx
		movq	24(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jge	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-104(%rbp)

		# if_false ##t4 goto 28;
		movq	-104(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L28

		# ##t5 = i;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t6 = memo;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t7 = *(##t6 + 8);
		movq	-120(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t5 = ##t5 * 8;
		movq	-112(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t5 = ##t5 + 16;
		movq	-112(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t6 = ##t6 + ##t5;
		movq	-120(%rbp),	%rdx
		add	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# *(##t6) = 0;
		movq	$0,	%rax
		movq	-120(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# i = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# goto 17;
		jmp	L17

		# ##t8 = n;
L28:
		movq	24(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t9 = memo;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# push_param ##t8;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-136(%rbp)

		# push_param ##t9;
		pushq	-144(%rbp)

		# push_param this;
		pushq	16(%rbp)

		# call_func test_4.fibHelper@int@int[];
		call	func2
		add	$24,	%rsp

		# ##t10 = return_value;
		mov	%rax,	-152(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# return ##t10;
		movq	-152(%rbp),	%rax
		add	$96,	%rsp
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
		add	$96,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_4.fibHelper@int@int[]
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
		sub	$208,	%rsp

		# ##t11 = this;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t12 = *(##t11);
		movq	-64(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t13 = ##t12 + 1;
		movq	-72(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t11) = ##t13;
		movq	-80(%rbp),	%rax
		movq	-64(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t14 = n == 0;
		movq	32(%rbp),	%rdx
		movq	$0,	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-88(%rbp)

		# ##t15 = n == 1;
		movq	32(%rbp),	%rdx
		movq	$1,	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-96(%rbp)

		# ##t16 = ##t14 || ##t15;
		movq	-88(%rbp),	%rdx
		cmp	$0,	%rdx
		jne	1f
		movq	-96(%rbp),	%rdx
		cmp	$0,	%rdx
		jne	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
2:
		movq	%rdx,	-104(%rbp)

		# if_false ##t16 goto 52;
		movq	-104(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L52

		# return n;
		movq	32(%rbp),	%rax
		add	$208,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# ##t17 = n;
L52:
		movq	32(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t18 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t19 = *(##t18 + 8);
		movq	-120(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t17 = ##t17 * 8;
		movq	-112(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t17 = ##t17 + 16;
		movq	-112(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t18 = ##t18 + ##t17;
		movq	-120(%rbp),	%rdx
		add	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t18 = *(##t18);
		movq	-120(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t20 = ##t18 != 0;
		movq	-120(%rbp),	%rdx
		movq	$0,	%rcx
		cmp	%rdx,	%rcx
		jne	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-136(%rbp)

		# if_false ##t20 goto 69;
		movq	-136(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L69

		# ##t21 = n;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t22 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t23 = *(##t22 + 8);
		movq	-152(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t21 = ##t21 * 8;
		movq	-144(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t21 = ##t21 + 16;
		movq	-144(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t22 = ##t22 + ##t21;
		movq	-152(%rbp),	%rdx
		add	-144(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t22 = *(##t22);
		movq	-152(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-152(%rbp)

		# return ##t22;
		movq	-152(%rbp),	%rax
		add	$208,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# ##t24 = n;
L69:
		movq	32(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t25 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t26 = *(##t25 + 8);
		movq	-176(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t24 = ##t24 * 8;
		movq	-168(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t24 = ##t24 + 16;
		movq	-168(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t25 = ##t25 + ##t24;
		movq	-176(%rbp),	%rdx
		add	-168(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t27 = n - 1;
		movq	32(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t28 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# push_param ##t27;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-192(%rbp)

		# push_param ##t28;
		pushq	-200(%rbp)

		# push_param this;
		pushq	16(%rbp)

		# call_func test_4.fibHelper@int@int[];
		call	func2
		add	$24,	%rsp

		# ##t29 = return_value;
		mov	%rax,	-208(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t30 = n - 2;
		movq	32(%rbp),	%rdx
		sub	$2,	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t31 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# push_param ##t30;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-216(%rbp)

		# push_param ##t31;
		pushq	-224(%rbp)

		# push_param this;
		pushq	16(%rbp)

		# call_func test_4.fibHelper@int@int[];
		call	func2
		add	$24,	%rsp

		# ##t32 = return_value;
		mov	%rax,	-232(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t33 = ##t29 + ##t32;
		movq	-208(%rbp),	%rdx
		add	-232(%rbp),	%rdx
		movq	%rdx,	-240(%rbp)

		# *(##t25) = ##t33;
		movq	-240(%rbp),	%rax
		movq	-176(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t34 = n;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t35 = memo;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t36 = *(##t35 + 8);
		movq	-256(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t34 = ##t34 * 8;
		movq	-248(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t34 = ##t34 + 16;
		movq	-248(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t35 = ##t35 + ##t34;
		movq	-256(%rbp),	%rdx
		add	-248(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t35 = *(##t35);
		movq	-256(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-256(%rbp)

		# return ##t35;
		movq	-256(%rbp),	%rax
		add	$208,	%rsp
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
		add	$208,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_4.main@String[]
main:
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
		sub	$48,	%rsp

		# push_param 8;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$8

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t37 = return_value;
		mov	%rax,	-64(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# push_param ##t37;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-64(%rbp)

		# call_func test_4##Default;
		call	func4
		add	$8,	%rsp

		# obj = ##t37;
		movq	-64(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# n = 10;
		movq	$10,	-80(%rbp)

		# push_param 10;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$10

		# push_param obj;
		pushq	-72(%rbp)

		# call_func test_4.fib@int;
		call	func1
		add	$16,	%rsp

		# ##t38 = return_value;
		mov	%rax,	-88(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# result = ##t38;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# push_param result;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-96(%rbp)

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

		# ##t39 = obj;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t39 = *(obj);
		movq	-72(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-104(%rbp)

		# push_param ##t39;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-104(%rbp)

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

		# begin_func test_4##Default
func4:
		pushq	%rbp
		movq	%rsp,	%rbp
		pushq	%rbx
		pushq	%rdi
		pushq	%rsi
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15

		# *(this + 0) = 0;
		movq	$0,	%rax
		movq	16(%rbp),	%rdx
		movq	%rax,	0(%rdx)

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
