.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_7.binarySearch@int[]@int@int
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
		sub	$104,	%rsp

		# low = 0;
		movq	$0,	-64(%rbp)

		# high = size - 1;
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t1 = low <= high;
L7:
		movq	-64(%rbp),	%rdx
		movq	-72(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jge	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-80(%rbp)

		# if_false ##t1 goto 35;
		movq	-80(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L35

		# ##t2 = low + high;
		movq	-64(%rbp),	%rdx
		add	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# mid = ##t2 / 2;
		movq	-88(%rbp),	%rax
		cqto
		movq	$2,	%rbx
		idiv	%rbx
		movq	%rax,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t3 = mid;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t4 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t5 = *(##t4 + 8);
		movq	-112(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t3 = ##t3 * 8;
		movq	-104(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t3 = ##t3 + 16;
		movq	-104(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t4 = ##t4 + ##t3;
		movq	-112(%rbp),	%rdx
		add	-104(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t4 = *(##t4);
		movq	-112(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t6 = ##t4 == x;
		movq	-112(%rbp),	%rdx
		movq	24(%rbp),	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-128(%rbp)

		# if_false ##t6 goto 22;
		movq	-128(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L22

		# return mid;
		movq	-96(%rbp),	%rax
		add	$104,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# goto 34;
		jmp	L34

		# ##t7 = mid;
L22:
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t8 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t9 = *(##t8 + 8);
		movq	-144(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t7 = ##t7 * 8;
		movq	-136(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t7 = ##t7 + 16;
		movq	-136(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t8 = ##t8 + ##t7;
		movq	-144(%rbp),	%rdx
		add	-136(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t8 = *(##t8);
		movq	-144(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t10 = ##t8 < x;
		movq	-144(%rbp),	%rdx
		movq	24(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-160(%rbp)

		# if_false ##t10 goto 33;
		movq	-160(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L33

		# low = mid + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-64(%rbp)

		# goto 34;
		jmp	L34

		# high = mid - 1;
L33:
		movq	-96(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-72(%rbp)

		# goto 7;
L34:
		jmp	L7

		# return -1;
L35:
		movq	$-1,	%rax
		add	$104,	%rsp
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
		add	$104,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_7.main@String[]
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
		sub	$104,	%rsp

		# ##t11 = 5;
		movq	$5,	-64(%rbp)

		# ##t12 = 56;
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

		# ##t13 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t12 = ##t13;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t12) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t13 = ##t13 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t13) = ##t11;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# arr = ##t12;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# i = 0;
		movq	$0,	-96(%rbp)

		# ##t14 = i < 5;
L50:
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

		# if_false ##t14 goto 62;
		movq	-104(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L62

		# ##t15 = i;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t16 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t17 = *(##t16 + 8);
		movq	-120(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t15 = ##t15 * 8;
		movq	-112(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t15 = ##t15 + 16;
		movq	-112(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t16 = ##t16 + ##t15;
		movq	-120(%rbp),	%rdx
		add	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t18 = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-136(%rbp)

		# *(##t16) = ##t18;
		movq	-136(%rbp),	%rax
		movq	-120(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# i = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# goto 50;
		jmp	L50

		# push_param arr;
L62:
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-88(%rbp)

		# push_param 3;
		pushq	$3

		# push_param 5;
		pushq	$5

		# call_func test_7.binarySearch@int[]@int@int;
		call	func1
		add	$24,	%rsp

		# ##t19 = return_value;
		mov	%rax,	-144(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# result = ##t19;
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

		# push_param arr;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-88(%rbp)

		# push_param -20;
		pushq	$-20

		# push_param 5;
		pushq	$5

		# call_func test_7.binarySearch@int[]@int@int;
		call	func1
		add	$24,	%rsp

		# ##t20 = return_value;
		mov	%rax,	-160(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# result = ##t20;
		movq	-160(%rbp),	%rdx
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

		# begin_func test_7##Default
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
