; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @fib(i64 %n.arg) #0 {
entry:
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 n, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_1, label %fall_2
fall_2:
  %r3 = load i64, ptr %n.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 n, %t3
  ; %t5:i64 = call fib(%t4)
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = sub_i64 n, %t6
  ; %t8:i64 = call fib(%t7)
  ; %t9:i64 = add_i64 %t5, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @fib_iterative(i64 %n.arg) #0 {
entry:
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 n, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_2, label %fall_2
fall_2:
  %r3 = load i64, ptr %n.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_2
dead_r4:
  br label %if_end_2
if_end_2:
  store i64 0, ptr %t3.slot, align 8
  %r5 = load i64, ptr %t3.slot, align 8
  store i64 %r5, ptr %a.slot, align 8
  store i64 1, ptr %t4.slot, align 8
  %r6 = load i64, ptr %t4.slot, align 8
  store i64 %r6, ptr %b.slot, align 8
  store i64 2, ptr %t5.slot, align 8
  store i64 1, ptr %t6.slot, align 8
  %r7 = load i64, ptr %t5.slot, align 8
  store i64 %r7, ptr %i.slot, align 8
  br label %for_cond_3
for_cond_3:
  ; %t7:bool = cmp_le_i64 i, n
  %r8 = load i64, ptr %t7.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %for_end_5, label %fall_9
fall_9:
  ; %t8:i64 = add_i64 a, b
  %r10 = load i64, ptr %t8.slot, align 8
  store i64 %r10, ptr %c.slot, align 8
  %r11 = load i64, ptr %b.slot, align 8
  store i64 %r11, ptr %a.slot, align 8
  %r12 = load i64, ptr %c.slot, align 8
  store i64 %r12, ptr %b.slot, align 8
  br label %for_step_4
for_step_4:
  ; %t9:i64 = add_i64 i, %t6
  %r13 = load i64, ptr %t9.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %for_cond_3
dead_r14:
  br label %for_end_5
for_end_5:
  %r15 = load i64, ptr %b.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  ; print(%t1:str)
  ; %t2:str = const_str 1
  store i64 20, ptr %t3.slot, align 8
  ; %t4:i64 = call fib(%t3)
  ; print(%t2:str, %t4:i64)
  ; %t5:str = const_str 2
  store i64 30, ptr %t6.slot, align 8
  ; %t7:i64 = call fib(%t6)
  ; print(%t5:str, %t7:i64)
  ; %t8:str = const_str 3
  store i64 50, ptr %t9.slot, align 8
  ; %t10:i64 = call fib_iterative(%t9)
  ; print(%t8:str, %t10:i64)
  store i64 0, ptr %t11.slot, align 8
  %r1 = load i64, ptr %t11.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}
