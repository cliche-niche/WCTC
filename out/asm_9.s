.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func test_9.bubbleSort@int[]@int
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
		sub	$224,	%rsp

		# n = size;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-64(%rbp)

		# i = 0;
		movq	$0,	-72(%rbp)

		# ##t1 = n - 1;
L6:
		movq	-64(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t2 = i < ##t1;
		movq	-72(%rbp),	%rdx
		movq	-80(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-88(%rbp)

		# if_false ##t2 goto 63;
		movq	-88(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L63

		# j = 0;
		movq	$0,	-96(%rbp)

		# ##t3 = n - i;
L10:
		movq	-64(%rbp),	%rdx
		sub	-72(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t4 = ##t3 - 1;
		movq	-104(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t5 = j < ##t4;
		movq	-96(%rbp),	%rdx
		movq	-112(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-120(%rbp)

		# if_false ##t5 goto 61;
		movq	-120(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L61

		# ##t6 = j;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t7 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t8 = *(##t7 + 8);
		movq	-136(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t6 = ##t6 * 8;
		movq	-128(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t6 = ##t6 + 16;
		movq	-128(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t7 = ##t7 + ##t6;
		movq	-136(%rbp),	%rdx
		add	-128(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t7 = *(##t7);
		movq	-136(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t9 = j + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t10 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t11 = *(##t10 + 8);
		movq	-160(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t9 = ##t9 * 8;
		movq	-152(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t9 = ##t9 + 16;
		movq	-152(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t10 = ##t10 + ##t9;
		movq	-160(%rbp),	%rdx
		add	-152(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t10 = *(##t10);
		movq	-160(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t12 = ##t7 > ##t10;
		movq	-136(%rbp),	%rdx
		movq	-160(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jl	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-176(%rbp)

		# if_false ##t12 goto 59;
		movq	-176(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L59

		# ##t13 = j;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t14 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t15 = *(##t14 + 8);
		movq	-192(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t13 = ##t13 * 8;
		movq	-184(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t13 = ##t13 + 16;
		movq	-184(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t14 = ##t14 + ##t13;
		movq	-192(%rbp),	%rdx
		add	-184(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t14 = *(##t14);
		movq	-192(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-192(%rbp)

		# temp = ##t14;
		movq	-192(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t16 = j;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t17 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t18 = *(##t17 + 8);
		movq	-224(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t16 = ##t16 * 8;
		movq	-216(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t16 = ##t16 + 16;
		movq	-216(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t17 = ##t17 + ##t16;
		movq	-224(%rbp),	%rdx
		add	-216(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t19 = j + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t20 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t21 = *(##t20 + 8);
		movq	-248(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t19 = ##t19 * 8;
		movq	-240(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t19 = ##t19 + 16;
		movq	-240(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t20 = ##t20 + ##t19;
		movq	-248(%rbp),	%rdx
		add	-240(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t20 = *(##t20);
		movq	-248(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-248(%rbp)

		# *(##t17) = ##t20;
		movq	-248(%rbp),	%rax
		movq	-224(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t22 = j + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t23 = arr;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t24 = *(##t23 + 8);
		movq	-272(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t22 = ##t22 * 8;
		movq	-264(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t22 = ##t22 + 16;
		movq	-264(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t23 = ##t23 + ##t22;
		movq	-272(%rbp),	%rdx
		add	-264(%rbp),	%rdx
		movq	%rdx,	-272(%rbp)

		# *(##t23) = temp;
		movq	-208(%rbp),	%rax
		movq	-272(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# j = j + 1;
L59:
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# goto 10;
		jmp	L10

		# i = i + 1;
L61:
		movq	-72(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-72(%rbp)

		# goto 6;
		jmp	L6

		# return;
L63:
		add	$224,	%rsp
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
		add	$224,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func test_9.main@String[]
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
		sub	$288,	%rsp

		# ##t25 = 9;
		movq	$9,	-64(%rbp)

		# ##t26 = 88;
		movq	$88,	-72(%rbp)

		# push_param 88;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	$88

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t27 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t26 = ##t27;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t26) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t27 = ##t27 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t27) = ##t25;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# arr = ##t26;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t28 = 0;
		movq	$0,	-96(%rbp)

		# ##t29 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t30 = *(##t29 + 8);
		movq	-104(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t28 = ##t28 * 8;
		movq	-96(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t28 = ##t28 + 16;
		movq	-96(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t29 = ##t29 + ##t28;
		movq	-104(%rbp),	%rdx
		add	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# *(##t29) = 5;
		movq	$5,	%rax
		movq	-104(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t31 = 1;
		movq	$1,	-120(%rbp)

		# ##t32 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t33 = *(##t32 + 8);
		movq	-128(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t31 = ##t31 * 8;
		movq	-120(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t31 = ##t31 + 16;
		movq	-120(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t32 = ##t32 + ##t31;
		movq	-128(%rbp),	%rdx
		add	-120(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# *(##t32) = 1;
		movq	$1,	%rax
		movq	-128(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t34 = 2;
		movq	$2,	-144(%rbp)

		# ##t35 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t36 = *(##t35 + 8);
		movq	-152(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t34 = ##t34 * 8;
		movq	-144(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t34 = ##t34 + 16;
		movq	-144(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t35 = ##t35 + ##t34;
		movq	-152(%rbp),	%rdx
		add	-144(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# *(##t35) = 4;
		movq	$4,	%rax
		movq	-152(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t37 = 3;
		movq	$3,	-168(%rbp)

		# ##t38 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t39 = *(##t38 + 8);
		movq	-176(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t37 = ##t37 * 8;
		movq	-168(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t37 = ##t37 + 16;
		movq	-168(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t38 = ##t38 + ##t37;
		movq	-176(%rbp),	%rdx
		add	-168(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# *(##t38) = 2;
		movq	$2,	%rax
		movq	-176(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t40 = 4;
		movq	$4,	-192(%rbp)

		# ##t41 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t42 = *(##t41 + 8);
		movq	-200(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t40 = ##t40 * 8;
		movq	-192(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t40 = ##t40 + 16;
		movq	-192(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t41 = ##t41 + ##t40;
		movq	-200(%rbp),	%rdx
		add	-192(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# *(##t41) = 8;
		movq	$8,	%rax
		movq	-200(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t43 = 5;
		movq	$5,	-216(%rbp)

		# ##t44 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t45 = *(##t44 + 8);
		movq	-224(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t43 = ##t43 * 8;
		movq	-216(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t43 = ##t43 + 16;
		movq	-216(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t44 = ##t44 + ##t43;
		movq	-224(%rbp),	%rdx
		add	-216(%rbp),	%rdx
		movq	%rdx,	-224(%rbp)

		# *(##t44) = 20;
		movq	$20,	%rax
		movq	-224(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t46 = 6;
		movq	$6,	-240(%rbp)

		# ##t47 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t48 = *(##t47 + 8);
		movq	-248(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t46 = ##t46 * 8;
		movq	-240(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t46 = ##t46 + 16;
		movq	-240(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t47 = ##t47 + ##t46;
		movq	-248(%rbp),	%rdx
		add	-240(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# *(##t47) = -2;
		movq	$-2,	%rax
		movq	-248(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t49 = 7;
		movq	$7,	-264(%rbp)

		# ##t50 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t51 = *(##t50 + 8);
		movq	-272(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t49 = ##t49 * 8;
		movq	-264(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t49 = ##t49 + 16;
		movq	-264(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t50 = ##t50 + ##t49;
		movq	-272(%rbp),	%rdx
		add	-264(%rbp),	%rdx
		movq	%rdx,	-272(%rbp)

		# *(##t50) = 102;
		movq	$102,	%rax
		movq	-272(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t52 = 8;
		movq	$8,	-288(%rbp)

		# ##t53 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t54 = *(##t53 + 8);
		movq	-296(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t52 = ##t52 * 8;
		movq	-288(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t52 = ##t52 + 16;
		movq	-288(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t53 = ##t53 + ##t52;
		movq	-296(%rbp),	%rdx
		add	-288(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# *(##t53) = 78;
		movq	$78,	%rax
		movq	-296(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# push_param arr;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-88(%rbp)

		# push_param 9;
		pushq	$9

		# call_func test_9.bubbleSort@int[]@int;
		call	func1
		add	$16,	%rsp

		# return_value;
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# i = 0;
		movq	$0,	-312(%rbp)

		# ##t55 = i < 9;
L147:
		movq	-312(%rbp),	%rdx
		movq	$9,	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-320(%rbp)

		# if_false ##t55 goto 161;
		movq	-320(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L161

		# ##t56 = i;
		movq	-312(%rbp),	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t57 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t58 = *(##t57 + 8);
		movq	-336(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-344(%rbp)

		# ##t56 = ##t56 * 8;
		movq	-328(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t56 = ##t56 + 16;
		movq	-328(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t57 = ##t57 + ##t56;
		movq	-336(%rbp),	%rdx
		add	-328(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t57 = *(##t57);
		movq	-336(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-336(%rbp)

		# push_param ##t57;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-336(%rbp)

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

		# i = i + 1;
		movq	-312(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-312(%rbp)

		# goto 147;
		jmp	L147

		# end_func
L161:
		movq	$60,	%rax
		xor	%rdi,	%rdi
		syscall

		# begin_func test_9##Default
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
