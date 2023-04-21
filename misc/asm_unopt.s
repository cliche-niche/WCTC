# Made from tac_unopt.txt using WCTC

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
		sub	$136,	%rsp

		# ##t45 = low < high;
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

		# ##t44 = ##t45;
		movq	-64(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# if_false ##t44 goto 43;
		movq	-72(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L43

		# ##t64 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t68 = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t72 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# push_param ##t64;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-80(%rbp)

		# push_param ##t68;
		pushq	-88(%rbp)

		# push_param ##t72;
		pushq	-96(%rbp)

		# call_func QuickSort.partition@int[]@int@int;
		call	func2
		add	$24,	%rsp

		# ##t59 = return_value;
		mov	%rax,	-104(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t58 = ##t59;
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t57 = ##t58;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# pi = ##t57;
		movq	-120(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t81 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t85 = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t90 = pi - 1;
		movq	-128(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t89 = ##t90;
		movq	-152(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# push_param ##t81;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-136(%rbp)

		# push_param ##t85;
		pushq	-144(%rbp)

		# push_param ##t89;
		pushq	-160(%rbp)

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

		# ##t99 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t104 = pi + 1;
		movq	-128(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t103 = ##t104;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t109 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# push_param ##t99;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-168(%rbp)

		# push_param ##t103;
		pushq	-184(%rbp)

		# push_param ##t109;
		pushq	-192(%rbp)

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
L43:
		add	$136,	%rsp
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
		sub	$504,	%rsp

		# ##t156 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t153 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t155 = *(##t153 + 8);
		movq	-72(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t156 = ##t156 * 8;
		movq	-64(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t156 = ##t156 + 16;
		movq	-64(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-64(%rbp)

		# ##t153 = ##t153 + ##t156;
		movq	-72(%rbp),	%rdx
		add	-64(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t153 = *(##t153);
		movq	-72(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t152 = ##t153;
		movq	-72(%rbp),	%rdx
		movq	%rdx,	-88(%rbp)

		# ##t151 = ##t152;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# pivot = ##t151;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# ##t170 = low - 1;
		movq	24(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t169 = ##t170;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t167 = ##t169;
		movq	-120(%rbp),	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t166 = ##t167;
		movq	-128(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t165 = ##t166;
		movq	-136(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# i = ##t165;
		movq	-144(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t185 = low;
		movq	24(%rbp),	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t184 = ##t185;
		movq	-160(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# j = ##t184;
		movq	-168(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# ##t188 = j < high;
L67:
		movq	-176(%rbp),	%rdx
		movq	16(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-184(%rbp)

		# ##t187 = ##t188;
		movq	-184(%rbp),	%rdx
		movq	%rdx,	-192(%rbp)

		# if_false ##t187 goto 120;
		movq	-192(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L120

		# ##t206 = j;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t203 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t205 = *(##t203 + 8);
		movq	-208(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-216(%rbp)

		# ##t206 = ##t206 * 8;
		movq	-200(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t206 = ##t206 + 16;
		movq	-200(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t203 = ##t203 + ##t206;
		movq	-208(%rbp),	%rdx
		add	-200(%rbp),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t203 = *(##t203);
		movq	-208(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t202 = ##t203 < pivot;
		movq	-208(%rbp),	%rdx
		movq	-104(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-224(%rbp)

		# ##t201 = ##t202;
		movq	-224(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# if_false ##t201 goto 116;
		movq	-232(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L116

		# ##t214 = i;
		movq	-152(%rbp),	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t216 = ##t214 + 1;
		movq	-240(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-248(%rbp)

		# i = ##t216;
		movq	-248(%rbp),	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t228 = i;
		movq	-152(%rbp),	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t225 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t227 = *(##t225 + 8);
		movq	-264(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t228 = ##t228 * 8;
		movq	-256(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t228 = ##t228 + 16;
		movq	-256(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t225 = ##t225 + ##t228;
		movq	-264(%rbp),	%rdx
		add	-256(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t225 = *(##t225);
		movq	-264(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t224 = ##t225;
		movq	-264(%rbp),	%rdx
		movq	%rdx,	-280(%rbp)

		# ##t223 = ##t224;
		movq	-280(%rbp),	%rdx
		movq	%rdx,	-288(%rbp)

		# temp = ##t223;
		movq	-288(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t237 = i;
		movq	-152(%rbp),	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t234 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-312(%rbp)

		# ##t236 = *(##t234 + 8);
		movq	-312(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-320(%rbp)

		# ##t237 = ##t237 * 8;
		movq	-304(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t237 = ##t237 + 16;
		movq	-304(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t234 = ##t234 + ##t237;
		movq	-312(%rbp),	%rdx
		add	-304(%rbp),	%rdx
		movq	%rdx,	-312(%rbp)

		# ##t244 = j;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t241 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t243 = *(##t241 + 8);
		movq	-336(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-344(%rbp)

		# ##t244 = ##t244 * 8;
		movq	-328(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t244 = ##t244 + 16;
		movq	-328(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t241 = ##t241 + ##t244;
		movq	-336(%rbp),	%rdx
		add	-328(%rbp),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t241 = *(##t241);
		movq	-336(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t240 = ##t241;
		movq	-336(%rbp),	%rdx
		movq	%rdx,	-352(%rbp)

		# *(##t234) = ##t240;
		movq	-352(%rbp),	%rax
		movq	-312(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t252 = j;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-360(%rbp)

		# ##t249 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-368(%rbp)

		# ##t251 = *(##t249 + 8);
		movq	-368(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-376(%rbp)

		# ##t252 = ##t252 * 8;
		movq	-360(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-360(%rbp)

		# ##t252 = ##t252 + 16;
		movq	-360(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-360(%rbp)

		# ##t249 = ##t249 + ##t252;
		movq	-368(%rbp),	%rdx
		add	-360(%rbp),	%rdx
		movq	%rdx,	-368(%rbp)

		# ##t255 = temp;
		movq	-296(%rbp),	%rdx
		movq	%rdx,	-384(%rbp)

		# *(##t249) = ##t255;
		movq	-384(%rbp),	%rax
		movq	-368(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t192 = j;
L116:
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-392(%rbp)

		# ##t194 = ##t192 + 1;
		movq	-392(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-400(%rbp)

		# j = ##t194;
		movq	-400(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# goto 67;
		jmp	L67

		# ##t271 = i + 1;
L120:
		movq	-152(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-408(%rbp)

		# ##t270 = ##t271;
		movq	-408(%rbp),	%rdx
		movq	%rdx,	-416(%rbp)

		# ##t267 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-424(%rbp)

		# ##t269 = *(##t267 + 8);
		movq	-424(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-432(%rbp)

		# ##t270 = ##t270 * 8;
		movq	-416(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-416(%rbp)

		# ##t270 = ##t270 + 16;
		movq	-416(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-416(%rbp)

		# ##t267 = ##t267 + ##t270;
		movq	-424(%rbp),	%rdx
		add	-416(%rbp),	%rdx
		movq	%rdx,	-424(%rbp)

		# ##t267 = *(##t267);
		movq	-424(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-424(%rbp)

		# ##t266 = ##t267;
		movq	-424(%rbp),	%rdx
		movq	%rdx,	-440(%rbp)

		# ##t265 = ##t266;
		movq	-440(%rbp),	%rdx
		movq	%rdx,	-448(%rbp)

		# temp = ##t265;
		movq	-448(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t282 = i + 1;
		movq	-152(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-456(%rbp)

		# ##t281 = ##t282;
		movq	-456(%rbp),	%rdx
		movq	%rdx,	-464(%rbp)

		# ##t278 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-472(%rbp)

		# ##t280 = *(##t278 + 8);
		movq	-472(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-480(%rbp)

		# ##t281 = ##t281 * 8;
		movq	-464(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-464(%rbp)

		# ##t281 = ##t281 + 16;
		movq	-464(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-464(%rbp)

		# ##t278 = ##t278 + ##t281;
		movq	-472(%rbp),	%rdx
		add	-464(%rbp),	%rdx
		movq	%rdx,	-472(%rbp)

		# ##t290 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-488(%rbp)

		# ##t287 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-496(%rbp)

		# ##t289 = *(##t287 + 8);
		movq	-496(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-504(%rbp)

		# ##t290 = ##t290 * 8;
		movq	-488(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-488(%rbp)

		# ##t290 = ##t290 + 16;
		movq	-488(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-488(%rbp)

		# ##t287 = ##t287 + ##t290;
		movq	-496(%rbp),	%rdx
		add	-488(%rbp),	%rdx
		movq	%rdx,	-496(%rbp)

		# ##t287 = *(##t287);
		movq	-496(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-496(%rbp)

		# ##t286 = ##t287;
		movq	-496(%rbp),	%rdx
		movq	%rdx,	-512(%rbp)

		# *(##t278) = ##t286;
		movq	-512(%rbp),	%rax
		movq	-472(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t299 = high;
		movq	16(%rbp),	%rdx
		movq	%rdx,	-520(%rbp)

		# ##t296 = arr;
		movq	32(%rbp),	%rdx
		movq	%rdx,	-528(%rbp)

		# ##t298 = *(##t296 + 8);
		movq	-528(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-536(%rbp)

		# ##t299 = ##t299 * 8;
		movq	-520(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-520(%rbp)

		# ##t299 = ##t299 + 16;
		movq	-520(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-520(%rbp)

		# ##t296 = ##t296 + ##t299;
		movq	-528(%rbp),	%rdx
		add	-520(%rbp),	%rdx
		movq	%rdx,	-528(%rbp)

		# ##t302 = temp;
		movq	-296(%rbp),	%rdx
		movq	%rdx,	-544(%rbp)

		# *(##t296) = ##t302;
		movq	-544(%rbp),	%rax
		movq	-528(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t307 = i + 1;
		movq	-152(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-552(%rbp)

		# ##t306 = ##t307;
		movq	-552(%rbp),	%rdx
		movq	%rdx,	-560(%rbp)

		# return ##t306;
		movq	-560(%rbp),	%rax
		add	$504,	%rsp
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
		add	$504,	%rsp
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
		sub	$432,	%rsp

		# ##t348 = 5;
		movq	$5,	-64(%rbp)

		# ##t346 = ##t348;
		movq	-64(%rbp),	%rdx
		movq	%rdx,	-72(%rbp)

		# ##t343 = ##t346 * 8;
		movq	-72(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-80(%rbp)

		# ##t343 = ##t343 + 16;
		movq	-80(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-80(%rbp)

		# push_param ##t343;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-80(%rbp)

		# call_func allocmem;
		call	allocmem
		add	$8,	%rsp

		# ##t344 = return_value;
		mov	%rax,	-88(%rbp)
		popq	%r11
		popq	%r10
		popq	%r9
		popq	%r8
		popq	%rdx
		popq	%rcx
		popq	%rax

		# ##t343 = ##t344;
		movq	-88(%rbp),	%rdx
		movq	%rdx,	-80(%rbp)

		# *(##t343) = 1;
		movq	$1,	%rax
		movq	-80(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t344 = ##t344 + 8;
		movq	-88(%rbp),	%rdx
		add	$8,	%rdx
		movq	%rdx,	-88(%rbp)

		# *(##t344) = ##t346;
		movq	-72(%rbp),	%rax
		movq	-88(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t342 = ##t343;
		movq	-80(%rbp),	%rdx
		movq	%rdx,	-96(%rbp)

		# ##t341 = ##t342;
		movq	-96(%rbp),	%rdx
		movq	%rdx,	-104(%rbp)

		# arr = ##t341;
		movq	-104(%rbp),	%rdx
		movq	%rdx,	-112(%rbp)

		# ##t365 = 5 * 23;
		movq	$5,	%rdx
		imul	$23,	%rdx
		movq	%rdx,	-120(%rbp)

		# ##t364 = ##t365 - 21;
		movq	-120(%rbp),	%rdx
		sub	$21,	%rdx
		movq	%rdx,	-128(%rbp)

		# ##t363 = ##t364;
		movq	-128(%rbp),	%rdx
		movq	%rdx,	-136(%rbp)

		# ##t361 = ##t363;
		movq	-136(%rbp),	%rdx
		movq	%rdx,	-144(%rbp)

		# ##t360 = ##t361 / 5;
		movq	-144(%rbp),	%rax
		cqto
		movq	$5,	%rbx
		idiv	%rbx
		movq	%rax,	%rdx
		movq	%rdx,	-152(%rbp)

		# ##t359 = ##t360 - 13;
		movq	-152(%rbp),	%rdx
		sub	$13,	%rdx
		movq	%rdx,	-160(%rbp)

		# ##t358 = ##t359;
		movq	-160(%rbp),	%rdx
		movq	%rdx,	-168(%rbp)

		# ##t357 = ##t358;
		movq	-168(%rbp),	%rdx
		movq	%rdx,	-176(%rbp)

		# a = ##t357;
		movq	-176(%rbp),	%rdx
		movq	%rdx,	-184(%rbp)

		# ##t378 = 0;
		movq	$0,	-192(%rbp)

		# ##t375 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t377 = *(##t375 + 8);
		movq	-200(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-208(%rbp)

		# ##t378 = ##t378 * 8;
		movq	-192(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t378 = ##t378 + 16;
		movq	-192(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-192(%rbp)

		# ##t375 = ##t375 + ##t378;
		movq	-200(%rbp),	%rdx
		add	-192(%rbp),	%rdx
		movq	%rdx,	-200(%rbp)

		# ##t381 = a;
		movq	-184(%rbp),	%rdx
		movq	%rdx,	-216(%rbp)

		# *(##t375) = ##t381;
		movq	-216(%rbp),	%rax
		movq	-200(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t389 = 1;
		movq	$1,	-224(%rbp)

		# ##t386 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t388 = *(##t386 + 8);
		movq	-232(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-240(%rbp)

		# ##t389 = ##t389 * 8;
		movq	-224(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t389 = ##t389 + 16;
		movq	-224(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-224(%rbp)

		# ##t386 = ##t386 + ##t389;
		movq	-232(%rbp),	%rdx
		add	-224(%rbp),	%rdx
		movq	%rdx,	-232(%rbp)

		# ##t392 = 1;
		movq	$1,	-248(%rbp)

		# *(##t386) = ##t392;
		movq	-248(%rbp),	%rax
		movq	-232(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t400 = 2;
		movq	$2,	-256(%rbp)

		# ##t397 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t399 = *(##t397 + 8);
		movq	-264(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-272(%rbp)

		# ##t400 = ##t400 * 8;
		movq	-256(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t400 = ##t400 + 16;
		movq	-256(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-256(%rbp)

		# ##t397 = ##t397 + ##t400;
		movq	-264(%rbp),	%rdx
		add	-256(%rbp),	%rdx
		movq	%rdx,	-264(%rbp)

		# ##t403 = 4;
		movq	$4,	-280(%rbp)

		# *(##t397) = ##t403;
		movq	-280(%rbp),	%rax
		movq	-264(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t411 = 3;
		movq	$3,	-288(%rbp)

		# ##t408 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t410 = *(##t408 + 8);
		movq	-296(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-304(%rbp)

		# ##t411 = ##t411 * 8;
		movq	-288(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t411 = ##t411 + 16;
		movq	-288(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-288(%rbp)

		# ##t408 = ##t408 + ##t411;
		movq	-296(%rbp),	%rdx
		add	-288(%rbp),	%rdx
		movq	%rdx,	-296(%rbp)

		# ##t414 = 2;
		movq	$2,	-312(%rbp)

		# *(##t408) = ##t414;
		movq	-312(%rbp),	%rax
		movq	-296(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t422 = 4;
		movq	$4,	-320(%rbp)

		# ##t419 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t421 = *(##t419 + 8);
		movq	-328(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-336(%rbp)

		# ##t422 = ##t422 * 8;
		movq	-320(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-320(%rbp)

		# ##t422 = ##t422 + 16;
		movq	-320(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-320(%rbp)

		# ##t419 = ##t419 + ##t422;
		movq	-328(%rbp),	%rdx
		add	-320(%rbp),	%rdx
		movq	%rdx,	-328(%rbp)

		# ##t425 = 8;
		movq	$8,	-344(%rbp)

		# *(##t419) = ##t425;
		movq	-344(%rbp),	%rax
		movq	-328(%rbp),	%rdx
		movq	%rax,	(%rdx)

		# ##t434 = 5;
		movq	$5,	-352(%rbp)

		# ##t433 = ##t434;
		movq	-352(%rbp),	%rdx
		movq	%rdx,	-360(%rbp)

		# n = ##t433;
		movq	-360(%rbp),	%rdx
		movq	%rdx,	-368(%rbp)

		# ##t442 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-376(%rbp)

		# ##t446 = 0;
		movq	$0,	-384(%rbp)

		# ##t451 = n - 1;
		movq	-368(%rbp),	%rdx
		sub	$1,	%rdx
		movq	%rdx,	-392(%rbp)

		# ##t450 = ##t451;
		movq	-392(%rbp),	%rdx
		movq	%rdx,	-400(%rbp)

		# push_param ##t442;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-376(%rbp)

		# push_param ##t446;
		pushq	-384(%rbp)

		# push_param ##t450;
		pushq	-400(%rbp)

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

		# ##t465 = 0;
		movq	$0,	-408(%rbp)

		# ##t464 = ##t465;
		movq	-408(%rbp),	%rdx
		movq	%rdx,	-416(%rbp)

		# i = ##t464;
		movq	-416(%rbp),	%rdx
		movq	%rdx,	-424(%rbp)

		# ##t468 = i < n;
L241:
		movq	-424(%rbp),	%rdx
		movq	-368(%rbp),	%rcx
		cmp	%rdx,	%rcx
		jg	1f
		movq	$0,	%rdx
		jmp	2f
1:
		movq	$1,	%rdx
		jmp	2f
2:
		movq	%rdx,	-432(%rbp)

		# ##t467 = ##t468;
		movq	-432(%rbp),	%rdx
		movq	%rdx,	-440(%rbp)

		# if_false ##t467 goto 259;
		movq	-440(%rbp),	%rdx
		cmp	$0,	%rdx
		je	L259

		# ##t486 = i;
		movq	-424(%rbp),	%rdx
		movq	%rdx,	-448(%rbp)

		# ##t483 = arr;
		movq	-112(%rbp),	%rdx
		movq	%rdx,	-456(%rbp)

		# ##t485 = *(##t483 + 8);
		movq	-456(%rbp),	%rdx
		movq	8(%rdx),	%rdx
		movq	%rdx,	-464(%rbp)

		# ##t486 = ##t486 * 8;
		movq	-448(%rbp),	%rdx
		imul	$8,	%rdx
		movq	%rdx,	-448(%rbp)

		# ##t486 = ##t486 + 16;
		movq	-448(%rbp),	%rdx
		add	$16,	%rdx
		movq	%rdx,	-448(%rbp)

		# ##t483 = ##t483 + ##t486;
		movq	-456(%rbp),	%rdx
		add	-448(%rbp),	%rdx
		movq	%rdx,	-456(%rbp)

		# ##t483 = *(##t483);
		movq	-456(%rbp),	%rdx
		movq	(%rdx),	%rdx
		movq	%rdx,	-456(%rbp)

		# ##t482 = ##t483;
		movq	-456(%rbp),	%rdx
		movq	%rdx,	-472(%rbp)

		# push_param ##t482;
		pushq	%rax
		pushq	%rcx
		pushq	%rdx
		pushq	%r8
		pushq	%r9
		pushq	%r10
		pushq	%r11
		pushq	-472(%rbp)

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

		# ##t472 = i;
		movq	-424(%rbp),	%rdx
		movq	%rdx,	-480(%rbp)

		# ##t474 = ##t472 + 1;
		movq	-480(%rbp),	%rdx
		add	$1,	%rdx
		movq	%rdx,	-488(%rbp)

		# i = ##t474;
		movq	-488(%rbp),	%rdx
		movq	%rdx,	-424(%rbp)

		# goto 241;
		jmp	L241

		# end_func
L259:
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
