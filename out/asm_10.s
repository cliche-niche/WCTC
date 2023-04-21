.data
		integer_format:	.asciz,	"%ld\n"
.global	main
.text

		# begin_func QuickSort.quickSort@int[]@int@int
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

		# ##t1 = low < high;
		movq	24(%rbp),	%rdx
		movq	16(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-64(%rbp)

		# if_false ##t1 goto 38;
		movq	-64(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L38

		# ##t2 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t3 = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t4 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# push_param ##t2;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-72(%rbp)

		# push_param ##t3;
		pushq	-80(%rbp)

		# push_param ##t4;
		pushq	-88(%rbp)

		# call_func QuickSort.partition@int[]@int@int;
		call	func2
		add	$24,	%rsp

		# ##t5 = return_value;
		mov	%rax,	-96(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# pi = ##t5;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t6 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t7 = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t8 = pi - 1;
		movq	-104(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-128(%rbp)

		# push_param ##t6;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-112(%rbp)

		# push_param ##t7;
		pushq	-120(%rbp)

		# push_param ##t8;
		pushq	-128(%rbp)

		# call_func QuickSort.quickSort@int[]@int@int;
		call	func1
		add	$24,	%rsp

		# return_value;
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t9 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t10 = pi + 1;
		movq	-104(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t11 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# push_param ##t9;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-136(%rbp)

		# push_param ##t10;
		pushq	-144(%rbp)

		# push_param ##t11;
		pushq	-152(%rbp)

		# call_func QuickSort.quickSort@int[]@int@int;
		call	func1
		add	$24,	%rsp

		# return_value;
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# end_func
L38:
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

		# begin_func QuickSort.partition@int[]@int@int
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
		sub	$296,	%rsp

		# ##t12 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t13 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t14 = *(##t13 + 8);
		movq	-72(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t12 = ##t12 * 8;
		movq	-64(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t12 = ##t12 + 16;
		movq	-64(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t13 = ##t13 + ##t12;
		movq	-72(%rbp),	%rdx
		add	-64(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t13 = *(##t13);
		movq	-72(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-72(%rbp)

		# pivot = ##t13;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# i = low - 1;
		movq	24(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# j = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t15 = j < high;
L53:
		movq	-104(%rbp),	%rdx
		movq	16(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-112(%rbp)

		# if_false ##t15 goto 96;
		movq	-112(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L96

		# ##t16 = j;
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t17 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t18 = *(##t17 + 8);
		movq	-128(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t16 = ##t16 * 8;
		movq	-120(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t16 = ##t16 + 16;
		movq	-120(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t17 = ##t17 + ##t16;
		movq	-128(%rbp),	%rdx
		add	-120(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t17 = *(##t17);
		movq	-128(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t19 = ##t17 < pivot;
		movq	-128(%rbp),	%rdx
		movq	-88(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-144(%rbp)

		# if_false ##t19 goto 94;
		movq	-144(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L94

		# i = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t20 = i;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t21 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t22 = *(##t21 + 8);
		movq	-160(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t20 = ##t20 * 8;
		movq	-152(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t20 = ##t20 + 16;
		movq	-152(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t21 = ##t21 + ##t20;
		movq	-160(%rbp),	%rdx
		add	-152(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t21 = *(##t21);
		movq	-160(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-160(%rbp)

		# temp = ##t21;
		movq	-160(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t23 = i;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t24 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t25 = *(##t24 + 8);
		movq	-192(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t23 = ##t23 * 8;
		movq	-184(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t23 = ##t23 + 16;
		movq	-184(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t24 = ##t24 + ##t23;
		movq	-192(%rbp),	%rdx
		add	-184(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t26 = j;
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t27 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t28 = *(##t27 + 8);
		movq	-216(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t26 = ##t26 * 8;
		movq	-208(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t26 = ##t26 + 16;
		movq	-208(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t27 = ##t27 + ##t26;
		movq	-216(%rbp),	%rdx
		add	-208(%rbp),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t27 = *(##t27);
		movq	-216(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-216(%rbp)

		# *(##t24) = ##t27;
		movq	-216(%rbp),	%rax
		movq	-192(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t29 = j;
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t30 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t31 = *(##t30 + 8);
		movq	-240(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t29 = ##t29 * 8;
		movq	-232(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t29 = ##t29 + 16;
		movq	-232(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t30 = ##t30 + ##t29;
		movq	-240(%rbp),	%rdx
		add	-232(%rbp),	%rdx
		movq	%rdx,	-240(%rbp)

		# *(##t30) = temp;
		movq	-176(%rbp),	%rax
		movq	-240(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# j = j + 1;
L94:
		movq	-104(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-104(%rbp)

		# goto 53;
		jmp	L53

		# ##t32 = i + 1;
L96:
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t33 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t34 = *(##t33 + 8);
		movq	-264(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t32 = ##t32 * 8;
		movq	-256(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t32 = ##t32 + 16;
		movq	-256(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t33 = ##t33 + ##t32;
		movq	-264(%rbp),	%rdx
		add	-256(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t33 = *(##t33);
		movq	-264(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-264(%rbp)

		# temp = ##t33;
		movq	-264(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t35 = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t36 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t37 = *(##t36 + 8);
		movq	-288(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t35 = ##t35 * 8;
		movq	-280(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t35 = ##t35 + 16;
		movq	-280(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t36 = ##t36 + ##t35;
		movq	-288(%rbp),	%rdx
		add	-280(%rbp),	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t38 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t39 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-312(%rbp)

		# ##t40 = *(##t39 + 8);
		movq	-312(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-320(%rbp)

		# ##t38 = ##t38 * 8;
		movq	-304(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t38 = ##t38 + 16;
		movq	-304(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t39 = ##t39 + ##t38;
		movq	-312(%rbp),	%rdx
		add	-304(%rbp),	%rdx
		movq	%rdx,	-312(%rbp)

		# ##t39 = *(##t39);
		movq	-312(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-312(%rbp)

		# *(##t36) = ##t39;
		movq	-312(%rbp),	%rax
		movq	-288(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t41 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t42 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t43 = *(##t42 + 8);
		movq	-336(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-344(%rbp)

		# ##t41 = ##t41 * 8;
		movq	-328(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t41 = ##t41 + 16;
		movq	-328(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t42 = ##t42 + ##t41;
		movq	-336(%rbp),	%rdx
		add	-328(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# *(##t42) = temp;
		movq	-176(%rbp),	%rax
		movq	-336(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t44 = i + 1;
		movq	-96(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-352(%rbp)

		# return ##t44;
		movq	-352(%rbp),	%rax
		add	$296,	%rsp
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
		add	$296,	%rsp
		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
		popq	%rsi
		popq	%rdi
		popq	%rbx
		popq	%rbp
		ret

		# begin_func QuickSort.main@String[]
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
		sub	$208,	%rsp

		# ##t45 = 5;
		movq	$5,	-64(%rbp)

		# ##t46 = 56;
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

		# ##t47 = return_value;
		mov	%rax,	-80(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t46 = ##t47;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# *(##t46) = 1;
		movq	$1,	%rax
		movq	-72(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t47 = ##t47 + 8;
		movq	-80(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t47) = ##t45;
		movq	-64(%rbp),	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# arr = ##t46;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# a = 5;
		movq	$5,	-96(%rbp)

		# ##t48 = 0;
		movq	$0,	-104(%rbp)

		# ##t49 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t50 = *(##t49 + 8);
		movq	-112(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t48 = ##t48 * 8;
		movq	-104(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t48 = ##t48 + 16;
		movq	-104(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t49 = ##t49 + ##t48;
		movq	-112(%rbp),	%rdx
		add	-104(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# *(##t49) = a;
		movq	-96(%rbp),	%rax
		movq	-112(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t51 = 1;
		movq	$1,	-128(%rbp)

		# ##t52 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t53 = *(##t52 + 8);
		movq	-136(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t51 = ##t51 * 8;
		movq	-128(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t51 = ##t51 + 16;
		movq	-128(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t52 = ##t52 + ##t51;
		movq	-136(%rbp),	%rdx
		add	-128(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# *(##t52) = 1;
		movq	$1,	%rax
		movq	-136(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t54 = 2;
		movq	$2,	-152(%rbp)

		# ##t55 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t56 = *(##t55 + 8);
		movq	-160(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t54 = ##t54 * 8;
		movq	-152(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t54 = ##t54 + 16;
		movq	-152(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t55 = ##t55 + ##t54;
		movq	-160(%rbp),	%rdx
		add	-152(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# *(##t55) = 4;
		movq	$4,	%rax
		movq	-160(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t57 = 3;
		movq	$3,	-176(%rbp)

		# ##t58 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t59 = *(##t58 + 8);
		movq	-184(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t57 = ##t57 * 8;
		movq	-176(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t57 = ##t57 + 16;
		movq	-176(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t58 = ##t58 + ##t57;
		movq	-184(%rbp),	%rdx
		add	-176(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# *(##t58) = 2;
		movq	$2,	%rax
		movq	-184(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t60 = 4;
		movq	$4,	-200(%rbp)

		# ##t61 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t62 = *(##t61 + 8);
		movq	-208(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t60 = ##t60 * 8;
		movq	-200(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t60 = ##t60 + 16;
		movq	-200(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t61 = ##t61 + ##t60;
		movq	-208(%rbp),	%rdx
		add	-200(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# *(##t61) = 8;
		movq	$8,	%rax
		movq	-208(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# n = 5;
		movq	$5,	-224(%rbp)

		# push_param arr;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-88(%rbp)

		# push_param 0;
		pushq	$0

		# push_param 4;
		pushq	$4

		# call_func QuickSort.quickSort@int[]@int@int;
		call	func1
		add	$24,	%rsp

		# return_value;
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# i = 0;
		movq	$0,	-232(%rbp)

		# ##t63 = i < n;
L185:
		movq	-232(%rbp),	%rdx
		movq	-224(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-240(%rbp)

		# if_false ##t63 goto 199;
		movq	-240(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L199

		# ##t64 = i;
		movq	-232(%rbp),	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t65 = arr;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t66 = *(##t65 + 8);
		movq	-256(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t64 = ##t64 * 8;
		movq	-248(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t64 = ##t64 + 16;
		movq	-248(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-248(%rbp)

		# ##t65 = ##t65 + ##t64;
		movq	-256(%rbp),	%rdx
		add	-248(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t65 = *(##t65);
		movq	-256(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-256(%rbp)

		# push_param ##t65;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-256(%rbp)

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
		movq	-232(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-232(%rbp)

		# goto 185;
		jmp	L185

		# end_func
L199:
		movq	$60,	%rax
		xor	%rdi,	%rdi
		syscall

		# begin_func QuickSort##Default
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
