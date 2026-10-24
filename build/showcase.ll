; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local ptr @classify_quadrant(i64 %p.arg) #0 {
entry:
  %p.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca ptr, align 8
  store i64 %p.arg, ptr %p.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = p[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_gt_i64 %t2, %t3
  store i64 1, ptr %t5.slot, align 8
  ; %t6:bool = cmp_eq_i64 %t4, %t5
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %match_case_0_2, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = p[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_gt_i64 %t8, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_3, label %fall_4
fall_4:
  ; %t11:str = const_str 0
  %r5 = load ptr, ptr %t11.slot, align 8
  ret ptr %r5
ret_cont_5:
  br label %if_end_3
dead_r6:
  br label %if_end_3
if_end_3:
  ; %t12:str = const_str 1
  %r7 = load ptr, ptr %t12.slot, align 8
  ret ptr %r7
ret_cont_7:
  br label %match_end_1
dead_r8:
  br label %match_case_0_2
match_case_0_2:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:bool = cmp_eq_i64 %t4, %t13
  %r9 = load i64, ptr %t14.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %match_case_1_4, label %fall_10
fall_10:
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = p[%t15]
  store i64 0, ptr %t17.slot, align 8
  ; %t18:bool = cmp_gt_i64 %t16, %t17
  %r11 = load i64, ptr %t18.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_5, label %fall_12
fall_12:
  ; %t19:str = const_str 2
  %r13 = load ptr, ptr %t19.slot, align 8
  ret ptr %r13
ret_cont_13:
  br label %if_end_5
dead_r14:
  br label %if_end_5
if_end_5:
  ; %t20:str = const_str 3
  %r15 = load ptr, ptr %t20.slot, align 8
  ret ptr %r15
ret_cont_15:
  br label %match_end_1
dead_r16:
  br label %match_case_1_4
match_case_1_4:
  br label %match_end_1
match_end_1:
  ; %t21:str = const_str 4
  %r17 = load ptr, ptr %t21.slot, align 8
  ret ptr %r17
ret_cont_17:
  ret ptr 0
}

define dso_local i64 @tail_sum(i64 %n.arg, i64 %acc.arg) #0 {
entry:
  %n.slot = alloca i64, align 8
  %acc.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %tco_10_0.slot = alloca i64, align 8
  %tco_10_1.slot = alloca i64, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  store i64 %acc.arg, ptr %acc.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 n, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_6, label %fall_2
fall_2:
  %r3 = load i64, ptr %acc.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_6
dead_r4:
  br label %if_end_6
if_end_6:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 n, %t3
  ; %t5:i64 = add_i64 acc, n
  %r5 = load i64, ptr %t4.slot, align 8
  store i64 %r5, ptr %tco_10_0.slot, align 8
  %r6 = load i64, ptr %t5.slot, align 8
  store i64 %r6, ptr %tco_10_1.slot, align 8
  %r7 = load i64, ptr %tco_10_0.slot, align 8
  store i64 %r7, ptr %n.slot, align 8
  %r8 = load i64, ptr %tco_10_1.slot, align 8
  store i64 %r8, ptr %acc.slot, align 8
  br label %__tco_entry
dead_r9:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %pt.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %quad.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca ptr, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t_sum.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 5
  ; print(%t1:str)
  ; %t2:str = const_str 6
  ; print(%t2:str)
  ; %t3:str = const_str 7
  ; print(%t3:str)
  ; %t4:str = const_str 5
  ; print(%t4:str)
  store i64 2, ptr %t6.slot, align 8
  store i64 0, ptr %t7.slot, align 8
  ; %t5:Point = alloc_array(%t6, init=%t7)
  store i64 12, ptr %t8.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t5[%t9] = %t8  ; i64
  store i64 5, ptr %t10.slot, align 8
  ; %t11:i64 = neg_i64 %t10
  store i64 1, ptr %t12.slot, align 8
  ; %t5[%t12] = %t11  ; i64
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %pt.slot, align 8
  ; %t13:str = call classify_quadrant(pt)
  %r2 = load ptr, ptr %t13.slot, align 8
  store ptr %r2, ptr %quad.slot, align 8
  ; %t14:str = const_str 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:i64 = pt[%t15]
  ; %t17:str = const_str 9
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = pt[%t18]
  ; %t20:str = const_str 10
  ; print(%t14:str, %t16:i64, %t17:str, %t19:i64, %t20:str, quad:str)
  store i64 100000, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t23:i64 = call tail_sum(%t21, %t22)
  %r3 = load i64, ptr %t23.slot, align 8
  store i64 %r3, ptr %t_sum.slot, align 8
  ; %t24:str = const_str 11
  ; print(%t24:str, t_sum:i64)
  store i64 0, ptr %t25.slot, align 8
  %r4 = load i64, ptr %t25.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}
