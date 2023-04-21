.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_1.max@int@int
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
		sub	$16,	%rsp

		# ##t1 = a > b;
		movq	24(%rbp),	%rdx
		movq	16(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jl	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-64(%rbp)

		# if_false ##t1 goto 8;
		movq	-64(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L8

		# ##t2 = a;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# goto 9;
		jmp	L9

		# ##t2 = b;
L8:
		movq	16(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# return ##t2;
L9:
		movq	-72(%rbp),	%rax
		add	$16,	%rsp
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
		add	$16,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_1.knapSack@int@int[]@int[]@int
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
		sub	$248,	%rsp

		# ##t3 = n == 0;
		movq	16(%rbp),	%rdx
		movq	$0,	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-64(%rbp)

		# ##t4 = W == 0;
		movq	40(%rbp),	%rdx
		movq	$0,	%rcx
		cmp	%rdx,	%rcx
		je	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-72(%rbp)

		# ##t5 = ##t3 || ##t4;
		movq	-64(%rbp),	%rdx
		cmp	$0,	%rdx
		jne	1f
		movq	-72(%rbp),	%rdx
		cmp	$0,	%rdx
		jne	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
2:
		movq	%rdx,	-80(%rbp)

		# if_false ##t5 goto 21;
		movq	-80(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L21

		# return 0;
		movq	$0,	%rax
		add	$248,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# ##t6 = n - 1;
L21:
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t7 = wt;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t8 = *(##t7 + 8);
		movq	-96(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t6 = ##t6 * 8;
		movq	-88(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t6 = ##t6 + 16;
		movq	-88(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t7 = ##t7 + ##t6;
		movq	-96(%rbp),	%rdx
		add	-88(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t7 = *(##t7);
		movq	-96(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t9 = ##t7 > W;
		movq	-96(%rbp),	%rdx
		movq	40(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jl	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-112(%rbp)

		# if_false ##t9 goto 44;
		movq	-112(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L44

		# ##t10 = W;
		movq	40(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t11 = wt;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t12 = val;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t13 = n - 1;
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-144(%rbp)

		# push_param ##t10;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-120(%rbp)

		# push_param ##t11;
		pushq	-128(%rbp)

		# push_param ##t12;
		pushq	-136(%rbp)

		# push_param ##t13;
		pushq	-144(%rbp)

		# call_func test_1.knapSack@int@int[]@int[]@int;
		call	func2
		add	$32,	%rsp

		# ##t14 = return_value;
		mov	%rax,	-152(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# return ##t14;
		movq	-152(%rbp),	%rax
		add	$248,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# goto 91;
		jmp	L91

		# ##t15 = n - 1;
L44:
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t16 = val;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t17 = *(##t16 + 8);
		movq	-168(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t15 = ##t15 * 8;
		movq	-160(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t15 = ##t15 + 16;
		movq	-160(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t16 = ##t16 + ##t15;
		movq	-168(%rbp),	%rdx
		add	-160(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t16 = *(##t16);
		movq	-168(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t18 = n - 1;
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t19 = wt;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t20 = *(##t19 + 8);
		movq	-192(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t18 = ##t18 * 8;
		movq	-184(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t18 = ##t18 + 16;
		movq	-184(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t19 = ##t19 + ##t18;
		movq	-192(%rbp),	%rdx
		add	-184(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t19 = *(##t19);
		movq	-192(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t21 = W - ##t19;
		movq	40(%rbp),	%rdx
		sub	-192(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t22 = wt;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t23 = val;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t24 = n - 1;
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-232(%rbp)

		# push_param ##t21;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-208(%rbp)

		# push_param ##t22;
		pushq	-216(%rbp)

		# push_param ##t23;
		pushq	-224(%rbp)

		# push_param ##t24;
		pushq	-232(%rbp)

		# call_func test_1.knapSack@int@int[]@int[]@int;
		call	func2
		add	$32,	%rsp

		# ##t25 = return_value;
		mov	%rax,	-240(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t26 = ##t16 + ##t25;
		movq	-168(%rbp),	%rdx
		add	-240(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t27 = W;
		movq	40(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t28 = wt;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t29 = val;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t30 = n - 1;
		movq	16(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-280(%rbp)

		# push_param ##t27;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-256(%rbp)

		# push_param ##t28;
		pushq	-264(%rbp)

		# push_param ##t29;
		pushq	-272(%rbp)

		# push_param ##t30;
		pushq	-280(%rbp)

		# call_func test_1.knapSack@int@int[]@int[]@int;
		call	func2
		add	$32,	%rsp

		# ##t31 = return_value;
		mov	%rax,	-288(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t32 = ##t31;
		movq	-288(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# push_param ##t26;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-248(%rbp)

		# push_param ##t32;
		pushq	-296(%rbp)

		# call_func test_1.max@int@int;
		call	func1
		add	$16,	%rsp

		# ##t33 = return_value;
		mov	%rax,	-304(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# return ##t33;
		movq	-304(%rbp),	%rax
		add	$248,	%rsp
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
L91:
		add	$248,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_1.main@String[]
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
		sub	$248,	%rsp

		# ##t34 = 3;
		movq	$3,	-64(%rbp)

		# ##t35 = 40;
		movq	$40,	-72(%rbp)

		# push_param 40;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$40

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t36 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t35 = ##t36;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t35) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t36 = ##t36 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t36) = ##t34;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# val = ##t35;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t37 = 0;
		movq	$0,	-96(%rbp)

		# ##t38 = val;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t39 = *(##t38 + 8);
		movq	-104(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t37 = ##t37 * 8;
		movq	-96(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t37 = ##t37 + 16;
		movq	-96(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t38 = ##t38 + ##t37;
		movq	-104(%rbp),	%rdx
		add	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# *(##t38) = 60;
		movq	$60,	%rax
		movq	-104(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t40 = 1;
		movq	$1,	-120(%rbp)

		# ##t41 = val;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t42 = *(##t41 + 8);
		movq	-128(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t40 = ##t40 * 8;
		movq	-120(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t40 = ##t40 + 16;
		movq	-120(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t41 = ##t41 + ##t40;
		movq	-128(%rbp),	%rdx
		add	-120(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# *(##t41) = 100;
		movq	$100,	%rax
		movq	-128(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t43 = 2;
		movq	$2,	-144(%rbp)

		# ##t44 = val;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t45 = *(##t44 + 8);
		movq	-152(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t43 = ##t43 * 8;
		movq	-144(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t43 = ##t43 + 16;
		movq	-144(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t44 = ##t44 + ##t43;
		movq	-152(%rbp),	%rdx
		add	-144(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# *(##t44) = 120;
		movq	$120,	%rax
		movq	-152(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t46 = 3;
		movq	$3,	-168(%rbp)

		# ##t47 = 40;
		movq	$40,	-176(%rbp)

		# push_param 40;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$40

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t48 = return_value;
		mov	%rax,	-184(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t47 = ##t48;
		movq	-184(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# *(##t47) = 1;
		movq	$1,	%rax
		movq	-176(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t48 = ##t48 + 8;
		movq	-184(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-184(%rbp)

		# *(##t48) = ##t46;
		movq	-168(%rbp),	%rax
		movq	-184(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# wt = ##t47;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t49 = 0;
		movq	$0,	-200(%rbp)

		# ##t50 = wt;
		movq	-192(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t51 = *(##t50 + 8);
		movq	-208(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t49 = ##t49 * 8;
		movq	-200(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t49 = ##t49 + 16;
		movq	-200(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t50 = ##t50 + ##t49;
		movq	-208(%rbp),	%rdx
		add	-200(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# *(##t50) = 10;
		movq	$10,	%rax
		movq	-208(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t52 = 1;
		movq	$1,	-224(%rbp)

		# ##t53 = wt;
		movq	-192(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t54 = *(##t53 + 8);
		movq	-232(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t52 = ##t52 * 8;
		movq	-224(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t52 = ##t52 + 16;
		movq	-224(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t53 = ##t53 + ##t52;
		movq	-232(%rbp),	%rdx
		add	-224(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# *(##t53) = 20;
		movq	$20,	%rax
		movq	-232(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t55 = 2;
		movq	$2,	-248(%rbp)

		# ##t56 = wt;
		movq	-192(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t57 = *(##t56 + 8);
		movq	-256(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t55 = ##t55 * 8;
		movq	-248(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t55 = ##t55 + 16;
		movq	-248(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t56 = ##t56 + ##t55;
		movq	-256(%rbp),	%rdx
		add	-248(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# *(##t56) = 30;
		movq	$30,	%rax
		movq	-256(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# W = 50;
		movq	$50,	-272(%rbp)

		# n = 3;
		movq	$3,	-280(%rbp)

		# ##t58 = wt;
		movq	-192(%rbp),	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t59 = val;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# push_param 50;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$50

		# push_param ##t58;
		pushq	-288(%rbp)

		# push_param ##t59;
		pushq	-296(%rbp)

		# push_param 3;
		pushq	$3

		# call_func test_1.knapSack@int@int[]@int[]@int;
		call	func2
		add	$32,	%rsp

		# ##t60 = return_value;
		mov	%rax,	-304(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# push_param ##t60;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-304(%rbp)

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

		# begin_func test_1##Default
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
