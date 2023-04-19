	.file	"test.c"
# GNU C17 (Ubuntu 9.4.0-1ubuntu1~20.04.1) version 9.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 9.4.0, GMP version 6.2.0, MPFR version 4.0.2, MPC version 1.1.0, isl version isl-0.22.1-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -imultiarch x86_64-linux-gnu ../tests/test.c
# -mtune=generic -march=x86-64 -auxbase-strip test.s -Og -w -fverbose-asm
# -fasynchronous-unwind-tables -fstack-protector-strong -Wformat
# -Wformat-security -fstack-clash-protection -fcf-protection
# options enabled:  -fPIC -fPIE -faggressive-loop-optimizations
# -fassume-phsa -fasynchronous-unwind-tables -fauto-inc-dec
# -fcombine-stack-adjustments -fcommon -fcompare-elim -fcprop-registers
# -fdefer-pop -fdelete-null-pointer-checks -fdwarf2-cfi-asm
# -fearly-inlining -feliminate-unused-debug-types -fforward-propagate
# -ffp-int-builtin-inexact -ffunction-cse -fgcse-lm -fgnu-runtime
# -fgnu-unique -fguess-branch-probability -fident -finline -finline-atomics
# -fipa-profile -fipa-pure-const -fipa-reference
# -fipa-reference-addressable -fipa-stack-alignment -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots -fivopts
# -fkeep-static-consts -fleading-underscore -flifetime-dse
# -flto-odr-type-merging -fmath-errno -fmerge-constants
# -fmerge-debug-strings -fomit-frame-pointer -fpeephole -fplt
# -fprefetch-loop-arrays -freg-struct-return -freorder-blocks
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-fusion -fsemantic-interposition
# -fshow-column -fshrink-wrap -fshrink-wrap-separate -fsigned-zeros
# -fsplit-ivs-in-unroller -fsplit-wide-types -fssa-backprop
# -fstack-clash-protection -fstack-protector-strong -fstdarg-opt
# -fstrict-volatile-bitfields -fsync-libcalls -ftoplevel-reorder
# -ftrapping-math -ftree-builtin-call-dce -ftree-ccp -ftree-ch
# -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim -ftree-dce
# -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre
# -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
# -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop
# -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slsr -ftree-ter
# -funit-at-a-time -funwind-tables -fverbose-asm -fzero-initialized-in-bss
# -m128bit-long-double -m64 -m80387 -malign-stringops
# -mavx256-split-unaligned-load -mavx256-split-unaligned-store
# -mfancy-math-387 -mfp-ret-in-387 -mfxsr -mglibc -mieee-fp
# -mlong-double-80 -mmmx -mno-sse4 -mpush-args -mred-zone -msse -msse2
# -mstv -mtls-direct-seg-refs -mvzeroupper

	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d %d %d"
.LC1:
	.string	"Here ya are mayait %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64	
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp	#,
	.cfi_def_cfa_offset 48
# ../tests/test.c:4: int main() {
	movl	$40, %ebx	#, tmp86
	movq	%fs:(%rbx), %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp93
	movq	%rax, 24(%rsp)	# tmp93, D.3158
	xorl	%eax, %eax	# tmp93
# ../tests/test.c:8:     scanf("%d %d %d", &a, &b, &c);
	leaq	20(%rsp), %rcx	#, tmp87
	leaq	16(%rsp), %rdx	#, tmp88
	leaq	12(%rsp), %rsi	#, tmp89
	leaq	.LC0(%rip), %rdi	#,
	call	__isoc99_scanf@PLT	#
# ../tests/test.c:10:     b = b * c;
	movl	16(%rsp), %ecx	# b, b
	imull	20(%rsp), %ecx	# c, _3
# ../tests/test.c:10:     b = b * c;
	mov	    %ecx, 16(%rsp)	# _3, b
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:107:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC1(%rip), %rsi	#,
	movl	$1, %edi	#,
	movl	$0, %eax	#,
	call	__printf_chk@PLT	#
# ../tests/test.c:25: }
	movq	24(%rsp), %rax	# D.3158, tmp94
	xorq	%fs:(%rbx), %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp94
	jne	.L4	#,
	movl	$0, %eax	#,
	addq	$32, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
.L4:
	.cfi_restore_state
	call	__stack_chk_fail@PLT	#
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
