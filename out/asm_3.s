.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_3.main@String[]
main:
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
		sub	$136,	%rsp

		# n = 100;
		movq	$100,	-64(%rbp)

		# count = 1;
		movq	$1,	-72(%rbp)

		# num = 3;
		movq	$3,	-80(%rbp)

		# ##t1 = count < n;
L6:
		movq	-72(%rbp),	%rdx
		movq	-64(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-88(%rbp)

		# if_false ##t1 goto 32;
		movq	-88(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L32

		# isPrime = true;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# i = 3;
		movq	$3,	-104(%rbp)

		# ##t2 = i <= num;
L10:
		movq	-104(%rbp),	%rdx
		movq	-80(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jge	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-112(%rbp)

		# if_false ##t2 goto 26;
		movq	-112(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L26

		# ##t3 = i * i;
		movq	-104(%rbp),	%rdx
		imul	-104(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t4 = ##t3 > num;
		movq	-120(%rbp),	%rdx
		movq	-80(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jl	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-128(%rbp)

		# if_false ##t4 goto 16;
		movq	-128(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L16

		# goto 26;
		jmp	L26

		# ##t5 = num / i;
L16:
		movq	-80(%rbp),	%rax
		cqto
		movq	-104(%rbp),	%rbx
		idiv	%rbx
		movq	%rax,	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t6 = ##t5 * i;
		movq	-136(%rbp),	%rdx
		imul	-104(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t7 = ##t6 == num;
		movq	-144(%rbp),	%rdx
		movq	-80(%rbp),	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-152(%rbp)

		# if_false ##t7 goto 22;
		movq	-152(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L22

		# isPrime = false;
		movq	-160(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# goto 26;
		jmp	L26

		# ##t8 = i;
L22:
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t8 = ##t8 + 2;
		movq	-168(%rbp),	%rdx
		add	$2,	%rdx
		movq	%rdx,	-168(%rbp)

		# i = ##t8;
		movq	-168(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# goto 10;
		jmp	L10

		# if_false isPrime goto 28;
L26:
		movq	-176(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L28

		# count = count + 1;
		movq	-72(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t9 = num;
L28:
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t9 = ##t9 + 2;
		movq	-184(%rbp),	%rdx
		add	$2,	%rdx
		movq	%rdx,	-184(%rbp)

		# num = ##t9;
		movq	-184(%rbp),	%rdx
		movq	%rdx,	-80(%rbp)

		# goto 6;
		jmp	L6

		# prime_num = num - 2;
L32:
		movq	-80(%rbp),	%rdx
		sub	$2,	%rdx
		movq	%rdx,	-192(%rbp)

		# push_param prime_num;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-192(%rbp)

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

		# begin_func test_3##Default
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
