; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @str_contains(ptr %haystack.arg, ptr %needle.arg) #0 {
entry:
  %haystack.slot = alloca ptr, align 8
  %needle.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %h_len.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %n_len.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %limit.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %arena_sp_str_contains.slot = alloca i64, align 8
  store ptr %haystack.arg, ptr %haystack.slot, align 8
  store ptr %needle.arg, ptr %needle.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_str_contains:i64 = arena_save None
  ; %t1:i64 = str_len(haystack)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %h_len.slot, align 8
  ; %t2:i64 = str_len(needle)
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %n_len.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 n_len, %t3
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_1, label %fall_4
fall_4:
  store i64 1, ptr %t5.slot, align 8
  ; arena_restore %arena_sp_str_contains
  %r5 = load i64, ptr %t5.slot, align 8
  ret i64 %r5
ret_cont_5:
  br label %if_end_1
dead_r6:
  br label %if_end_1
if_end_1:
  ; %t6:bool = cmp_gt_i64 n_len, h_len
  %r7 = load i64, ptr %t6.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_2, label %fall_8
fall_8:
  store i64 0, ptr %t7.slot, align 8
  ; arena_restore %arena_sp_str_contains
  %r9 = load i64, ptr %t7.slot, align 8
  ret i64 %r9
ret_cont_9:
  br label %if_end_2
dead_r10:
  br label %if_end_2
if_end_2:
  ; %t8:i64 = sub_i64 h_len, n_len
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  store i64 %r11, ptr %limit.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  %r12 = load i64, ptr %t11.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_3
for_cond_3:
  ; %t13:bool = cmp_lt_i64 i, limit
  %r13 = load i64, ptr %t13.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_5, label %fall_14
fall_14:
  ; %t14:i64 = add_i64 i, n_len
  ; %t15:str = str_slice(haystack[i:%t14])
  ; %t16:bool = str_cmp_eq %t15, needle
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_6, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; arena_restore %arena_sp_str_contains
  %r17 = load i64, ptr %t17.slot, align 8
  ret i64 %r17
ret_cont_17:
  br label %if_end_6
dead_r18:
  br label %if_end_6
if_end_6:
  br label %for_step_4
for_step_4:
  ; %t18:i64 = add_i64 i, %t12
  %r19 = load i64, ptr %t18.slot, align 8
  store i64 %r19, ptr %i.slot, align 8
  br label %for_cond_3
dead_r20:
  br label %for_end_5
for_end_5:
  store i64 0, ptr %t19.slot, align 8
  ; arena_restore %arena_sp_str_contains
  %r21 = load i64, ptr %t19.slot, align 8
  ret i64 %r21
ret_cont_21:
  ret i64 0
}

define dso_local double @abs_f64(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_f64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_7, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t3.slot, align 8
  ; %t4:f64 = sub_f64 %t3, x
  %r3 = load double, ptr %t4.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_7
dead_r4:
  br label %if_end_7
if_end_7:
  %r5 = load double, ptr %x.slot, align 8
  ret double %r5
ret_cont_5:
  ret double 0.0
}

define dso_local i64 @test_runner_new(i64 %verbose.arg) #0 {
entry:
  %verbose.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  store i64 %verbose.arg, ptr %verbose.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 8, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:TestRunner = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t1[%t5] = %t4  ; i64
  store i64 0, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  ; %t1[%t7] = %t6  ; i64
  store i64 0, ptr %t8.slot, align 8
  store i64 2, ptr %t9.slot, align 8
  ; %t1[%t9] = %t8  ; i64
  ; %t10:str = const_str 0
  store i64 3, ptr %t11.slot, align 8
  ; %t1[%t11] = %t10  ; str
  ; %t12:str = const_str 0
  store i64 4, ptr %t13.slot, align 8
  ; %t1[%t13] = %t12  ; str
  store i64 0, ptr %t14.slot, align 8
  store i64 5, ptr %t15.slot, align 8
  ; %t1[%t15] = %t14  ; i64
  ; %t16:i64 = clock_ns None
  store i64 6, ptr %t17.slot, align 8
  ; %t1[%t17] = %t16  ; i64
  store i64 7, ptr %t18.slot, align 8
  ; %t1[%t18] = verbose  ; bool
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @test_suite(i64 %runner.arg, ptr %name.arg) #0 {
entry:
  %runner.slot = alloca i64, align 8
  %name.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  store i64 %runner.arg, ptr %runner.slot, align 8
  store ptr %name.arg, ptr %name.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3, ptr %t1.slot, align 8
  ; runner[%t1] = name  ; str
  store i64 5, ptr %t2.slot, align 8
  ; %t3:i64 = runner[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = add_i64 %t3, %t4
  store i64 5, ptr %t6.slot, align 8
  ; runner[%t6] = %t5  ; i64
  store i64 7, ptr %t7.slot, align 8
  ; %t8:bool = runner[%t7]
  %r1 = load i64, ptr %t8.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_8, label %fall_2
fall_2:
  ; %t9:str = const_str 1
  ; print(%t9:str)
  ; %t10:str = const_str 2
  ; %t11:str = str_concat(%t10, name)
  ; %t12:str = const_str 3
  ; %t13:str = str_concat(%t11, %t12)
  ; print(%t13:str)
  br label %if_end_8
dead_r3:
  br label %if_end_8
if_end_8:
  store i64 0, ptr %t14.slot, align 8
  %r4 = load i64, ptr %t14.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}

define dso_local i64 @test_case(i64 %runner.arg, ptr %name.arg) #0 {
entry:
  %runner.slot = alloca i64, align 8
  %name.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  store i64 %runner.arg, ptr %runner.slot, align 8
  store ptr %name.arg, ptr %name.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 4, ptr %t1.slot, align 8
  ; runner[%t1] = name  ; str
  store i64 7, ptr %t2.slot, align 8
  ; %t3:bool = runner[%t2]
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_9, label %fall_2
fall_2:
  ; %t4:str = const_str 4
  ; %t5:str = str_concat(%t4, name)
  ; %t6:str = const_str 5
  ; %t7:str = str_concat(%t5, %t6)
  ; print(%t7:str)
  br label %if_end_9
dead_r3:
  br label %if_end_9
if_end_9:
  store i64 0, ptr %t8.slot, align 8
  %r4 = load i64, ptr %t8.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}

define dso_local i64 @assert_true(i64 %r.arg, i64 %cond.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %cond.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %cond.arg, ptr %cond.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  %r1 = load i64, ptr %cond.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_11, label %fall_2
fall_2:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = r[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = add_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; r[%t10] = %t9  ; i64
  store i64 7, ptr %t11.slot, align 8
  ; %t12:bool = r[%t11]
  %r3 = load i64, ptr %t12.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_12, label %fall_4
fall_4:
  ; %t13:str = const_str 6
  ; %t14:str = str_concat(%t13, msg)
  ; print(%t14:str)
  br label %if_end_12
dead_r5:
  br label %if_end_12
if_end_12:
  store i64 1, ptr %t15.slot, align 8
  %r6 = load i64, ptr %t15.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_10
dead_r7:
  br label %if_next_11
if_next_11:
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = r[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = add_i64 %t17, %t18
  store i64 2, ptr %t20.slot, align 8
  ; r[%t20] = %t19  ; i64
  ; %t21:str = const_str 7
  store i64 3, ptr %t22.slot, align 8
  ; %t23:str = r[%t22]
  ; %t24:str = str_concat(%t21, %t23)
  ; %t25:str = const_str 8
  ; %t26:str = str_concat(%t24, %t25)
  store i64 4, ptr %t27.slot, align 8
  ; %t28:str = r[%t27]
  ; %t29:str = str_concat(%t26, %t28)
  ; %t30:str = const_str 9
  ; %t31:str = str_concat(%t29, %t30)
  ; %t32:str = str_concat(%t31, msg)
  ; print(%t32:str)
  ; %t33:str = const_str 10
  ; print(%t33:str)
  store i64 0, ptr %t34.slot, align 8
  %r8 = load i64, ptr %t34.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_10
if_end_10:
  store i64 0, ptr %t35.slot, align 8
  %r9 = load i64, ptr %t35.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_false(i64 %r.arg, i64 %cond.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %cond.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %cond.arg, ptr %cond.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  store i64 0, ptr %t7.slot, align 8
  ; %t6:bool = cmp_eq_i64 cond, %t7
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_14, label %fall_2
fall_2:
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = r[%t8]
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = add_i64 %t9, %t10
  store i64 1, ptr %t12.slot, align 8
  ; r[%t12] = %t11  ; i64
  store i64 7, ptr %t13.slot, align 8
  ; %t14:bool = r[%t13]
  %r3 = load i64, ptr %t14.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_15, label %fall_4
fall_4:
  ; %t15:str = const_str 6
  ; %t16:str = str_concat(%t15, msg)
  ; print(%t16:str)
  br label %if_end_15
dead_r5:
  br label %if_end_15
if_end_15:
  store i64 1, ptr %t17.slot, align 8
  %r6 = load i64, ptr %t17.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_13
dead_r7:
  br label %if_next_14
if_next_14:
  store i64 2, ptr %t18.slot, align 8
  ; %t19:i64 = r[%t18]
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 %t19, %t20
  store i64 2, ptr %t22.slot, align 8
  ; r[%t22] = %t21  ; i64
  ; %t23:str = const_str 7
  store i64 3, ptr %t24.slot, align 8
  ; %t25:str = r[%t24]
  ; %t26:str = str_concat(%t23, %t25)
  ; %t27:str = const_str 8
  ; %t28:str = str_concat(%t26, %t27)
  store i64 4, ptr %t29.slot, align 8
  ; %t30:str = r[%t29]
  ; %t31:str = str_concat(%t28, %t30)
  ; %t32:str = const_str 9
  ; %t33:str = str_concat(%t31, %t32)
  ; %t34:str = str_concat(%t33, msg)
  ; print(%t34:str)
  ; %t35:str = const_str 11
  ; print(%t35:str)
  store i64 0, ptr %t36.slot, align 8
  %r8 = load i64, ptr %t36.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_13
if_end_13:
  store i64 0, ptr %t37.slot, align 8
  %r9 = load i64, ptr %t37.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_eq_i64(i64 %r.arg, i64 %actual.arg, i64 %expected.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %actual.slot = alloca i64, align 8
  %expected.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %actual.arg, ptr %actual.slot, align 8
  store i64 %expected.arg, ptr %expected.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_eq_i64 actual, expected
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_17, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_18, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_18
dead_r5:
  br label %if_end_18
if_end_18:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_16
dead_r7:
  br label %if_next_17
if_next_17:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 12
  ; %t35:str = str_from_i64 expected
  ; %t36:str = str_concat(%t34, %t35)
  ; %t37:str = const_str 13
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = str_from_i64 actual
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_16
if_end_16:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_ne_i64(i64 %r.arg, i64 %actual.arg, i64 %unexpected.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %actual.slot = alloca i64, align 8
  %unexpected.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %actual.arg, ptr %actual.slot, align 8
  store i64 %unexpected.arg, ptr %unexpected.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_ne_i64 actual, unexpected
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_20, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_21, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_21
dead_r5:
  br label %if_end_21
if_end_21:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_19
dead_r7:
  br label %if_next_20
if_next_20:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 14
  ; %t35:str = str_from_i64 actual
  ; %t36:str = str_concat(%t34, %t35)
  ; print(%t36:str)
  store i64 0, ptr %t37.slot, align 8
  %r8 = load i64, ptr %t37.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_19
if_end_19:
  store i64 0, ptr %t38.slot, align 8
  %r9 = load i64, ptr %t38.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_lt_i64(i64 %r.arg, i64 %a.arg, i64 %b.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %a.arg, ptr %a.slot, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_lt_i64 a, b
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_23, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_24, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_24
dead_r5:
  br label %if_end_24
if_end_24:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_22
dead_r7:
  br label %if_next_23
if_next_23:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 15
  ; %t35:str = str_from_i64 a
  ; %t36:str = str_concat(%t34, %t35)
  ; %t37:str = const_str 16
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = str_from_i64 b
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_22
if_end_22:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_le_i64(i64 %r.arg, i64 %a.arg, i64 %b.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %a.arg, ptr %a.slot, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_le_i64 a, b
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_26, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_27, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_27
dead_r5:
  br label %if_end_27
if_end_27:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_25
dead_r7:
  br label %if_next_26
if_next_26:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 15
  ; %t35:str = str_from_i64 a
  ; %t36:str = str_concat(%t34, %t35)
  ; %t37:str = const_str 17
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = str_from_i64 b
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_25
if_end_25:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_gt_i64(i64 %r.arg, i64 %a.arg, i64 %b.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %a.arg, ptr %a.slot, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_gt_i64 a, b
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_29, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_30, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_30
dead_r5:
  br label %if_end_30
if_end_30:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_28
dead_r7:
  br label %if_next_29
if_next_29:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 15
  ; %t35:str = str_from_i64 a
  ; %t36:str = str_concat(%t34, %t35)
  ; %t37:str = const_str 8
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = str_from_i64 b
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_28
if_end_28:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_ge_i64(i64 %r.arg, i64 %a.arg, i64 %b.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store i64 %a.arg, ptr %a.slot, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = cmp_ge_i64 a, b
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_32, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_33, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_33
dead_r5:
  br label %if_end_33
if_end_33:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_31
dead_r7:
  br label %if_next_32
if_next_32:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 15
  ; %t35:str = str_from_i64 a
  ; %t36:str = str_concat(%t34, %t35)
  ; %t37:str = const_str 18
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = str_from_i64 b
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_31
if_end_31:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_eq_f64(i64 %r.arg, double %actual.arg, double %expected.arg, double %eps.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %actual.slot = alloca double, align 8
  %expected.slot = alloca double, align 8
  %eps.slot = alloca double, align 8
  %msg.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %diff.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca ptr, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca ptr, align 8
  %t48.slot = alloca ptr, align 8
  %t49.slot = alloca ptr, align 8
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca ptr, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store double %actual.arg, ptr %actual.slot, align 8
  store double %expected.arg, ptr %expected.slot, align 8
  store double %eps.arg, ptr %eps.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:f64 = sub_f64 actual, expected
  ; %t7:f64 = call abs_f64(%t6)
  %r1 = load double, ptr %t7.slot, align 8
  store double %r1, ptr %diff.slot, align 8
  ; %t8:bool = cmp_le_f64 diff, eps
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_next_35, label %fall_3
fall_3:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = r[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = add_i64 %t10, %t11
  store i64 1, ptr %t13.slot, align 8
  ; r[%t13] = %t12  ; i64
  store i64 7, ptr %t14.slot, align 8
  ; %t15:bool = r[%t14]
  %r4 = load i64, ptr %t15.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_36, label %fall_5
fall_5:
  ; %t16:str = const_str 6
  ; %t17:str = str_concat(%t16, msg)
  ; print(%t17:str)
  br label %if_end_36
dead_r6:
  br label %if_end_36
if_end_36:
  store i64 1, ptr %t18.slot, align 8
  %r7 = load i64, ptr %t18.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_34
dead_r8:
  br label %if_next_35
if_next_35:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = r[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t22:i64 = add_i64 %t20, %t21
  store i64 2, ptr %t23.slot, align 8
  ; r[%t23] = %t22  ; i64
  ; %t24:str = const_str 7
  store i64 3, ptr %t25.slot, align 8
  ; %t26:str = r[%t25]
  ; %t27:str = str_concat(%t24, %t26)
  ; %t28:str = const_str 8
  ; %t29:str = str_concat(%t27, %t28)
  store i64 4, ptr %t30.slot, align 8
  ; %t31:str = r[%t30]
  ; %t32:str = str_concat(%t29, %t31)
  ; %t33:str = const_str 9
  ; %t34:str = str_concat(%t32, %t33)
  ; %t35:str = str_concat(%t34, msg)
  ; print(%t35:str)
  ; %t36:str = const_str 12
  ; %t37:str = str_from_f64 expected
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = const_str 13
  ; %t40:str = str_concat(%t38, %t39)
  ; %t41:str = str_from_f64 actual
  ; %t42:str = str_concat(%t40, %t41)
  ; %t43:str = const_str 19
  ; %t44:str = str_concat(%t42, %t43)
  ; %t45:str = str_from_f64 diff
  ; %t46:str = str_concat(%t44, %t45)
  ; %t47:str = const_str 20
  ; %t48:str = str_concat(%t46, %t47)
  ; %t49:str = str_from_f64 eps
  ; %t50:str = str_concat(%t48, %t49)
  ; %t51:str = const_str 21
  ; %t52:str = str_concat(%t50, %t51)
  ; print(%t52:str)
  store i64 0, ptr %t53.slot, align 8
  %r9 = load i64, ptr %t53.slot, align 8
  ret i64 %r9
ret_cont_9:
  br label %if_end_34
if_end_34:
  store i64 0, ptr %t54.slot, align 8
  %r10 = load i64, ptr %t54.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @assert_eq_str(i64 %r.arg, ptr %actual.arg, ptr %expected.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %actual.slot = alloca ptr, align 8
  %expected.slot = alloca ptr, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store ptr %actual.arg, ptr %actual.slot, align 8
  store ptr %expected.arg, ptr %expected.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = str_cmp_eq actual, expected
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_38, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_39, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_39
dead_r5:
  br label %if_end_39
if_end_39:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_37
dead_r7:
  br label %if_next_38
if_next_38:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 22
  ; %t35:str = str_concat(%t34, expected)
  ; %t36:str = const_str 23
  ; %t37:str = str_concat(%t35, %t36)
  ; %t38:str = str_concat(%t37, actual)
  ; %t39:str = const_str 24
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_37
if_end_37:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_ne_str(i64 %r.arg, ptr %actual.arg, ptr %unexpected.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %actual.slot = alloca ptr, align 8
  %unexpected.slot = alloca ptr, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store ptr %actual.arg, ptr %actual.slot, align 8
  store ptr %unexpected.arg, ptr %unexpected.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = str_cmp_ne actual, unexpected
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_41, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_42, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_42
dead_r5:
  br label %if_end_42
if_end_42:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_40
dead_r7:
  br label %if_next_41
if_next_41:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 25
  ; %t35:str = str_concat(%t34, actual)
  ; %t36:str = const_str 24
  ; %t37:str = str_concat(%t35, %t36)
  ; print(%t37:str)
  store i64 0, ptr %t38.slot, align 8
  %r8 = load i64, ptr %t38.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_40
if_end_40:
  store i64 0, ptr %t39.slot, align 8
  %r9 = load i64, ptr %t39.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @assert_str_contains(i64 %r.arg, ptr %haystack.arg, ptr %needle.arg, ptr %msg.arg) #0 {
entry:
  %r.slot = alloca i64, align 8
  %haystack.slot = alloca ptr, align 8
  %needle.slot = alloca ptr, align 8
  %msg.slot = alloca ptr, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  store i64 %r.arg, ptr %r.slot, align 8
  store ptr %haystack.arg, ptr %haystack.slot, align 8
  store ptr %needle.arg, ptr %needle.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = r[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 0, ptr %t5.slot, align 8
  ; r[%t5] = %t4  ; i64
  ; %t6:bool = call str_contains(haystack, needle)
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_next_44, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = r[%t7]
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 %t8, %t9
  store i64 1, ptr %t11.slot, align 8
  ; r[%t11] = %t10  ; i64
  store i64 7, ptr %t12.slot, align 8
  ; %t13:bool = r[%t12]
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_45, label %fall_4
fall_4:
  ; %t14:str = const_str 6
  ; %t15:str = str_concat(%t14, msg)
  ; print(%t15:str)
  br label %if_end_45
dead_r5:
  br label %if_end_45
if_end_45:
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t16.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_43
dead_r7:
  br label %if_next_44
if_next_44:
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = r[%t17]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = add_i64 %t18, %t19
  store i64 2, ptr %t21.slot, align 8
  ; r[%t21] = %t20  ; i64
  ; %t22:str = const_str 7
  store i64 3, ptr %t23.slot, align 8
  ; %t24:str = r[%t23]
  ; %t25:str = str_concat(%t22, %t24)
  ; %t26:str = const_str 8
  ; %t27:str = str_concat(%t25, %t26)
  store i64 4, ptr %t28.slot, align 8
  ; %t29:str = r[%t28]
  ; %t30:str = str_concat(%t27, %t29)
  ; %t31:str = const_str 9
  ; %t32:str = str_concat(%t30, %t31)
  ; %t33:str = str_concat(%t32, msg)
  ; print(%t33:str)
  ; %t34:str = const_str 26
  ; %t35:str = str_concat(%t34, needle)
  ; %t36:str = const_str 27
  ; %t37:str = str_concat(%t35, %t36)
  ; %t38:str = str_concat(%t37, haystack)
  ; %t39:str = const_str 24
  ; %t40:str = str_concat(%t38, %t39)
  ; print(%t40:str)
  store i64 0, ptr %t41.slot, align 8
  %r8 = load i64, ptr %t41.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_43
if_end_43:
  store i64 0, ptr %t42.slot, align 8
  %r9 = load i64, ptr %t42.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @test_summary(i64 %runner.arg) #0 {
entry:
  %runner.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %elapsed_ns.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %elapsed_ms.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %arena_sp_test_summary.slot = alloca i64, align 8
  store i64 %runner.arg, ptr %runner.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_test_summary:i64 = arena_save None
  ; %t1:i64 = clock_ns None
  store i64 6, ptr %t2.slot, align 8
  ; %t3:i64 = runner[%t2]
  ; %t4:i64 = sub_i64 %t1, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  store i64 %r1, ptr %elapsed_ns.slot, align 8
  store i64 1000000, ptr %t5.slot, align 8
  ; %t6:i64 = div_i64 elapsed_ns, %t5
  %r2 = load i64, ptr %t6.slot, align 8
  store i64 %r2, ptr %elapsed_ms.slot, align 8
  ; %t7:str = const_str 1
  ; print(%t7:str)
  ; %t8:str = const_str 28
  ; print(%t8:str)
  ; %t9:str = const_str 29
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = runner[%t10]
  ; %t12:str = str_from_i64 %t11
  ; %t13:str = str_concat(%t9, %t12)
  ; %t14:str = const_str 30
  ; %t15:str = str_concat(%t13, %t14)
  store i64 0, ptr %t16.slot, align 8
  ; %t17:i64 = runner[%t16]
  ; %t18:str = str_from_i64 %t17
  ; %t19:str = str_concat(%t15, %t18)
  ; %t20:str = const_str 31
  ; %t21:str = str_concat(%t19, %t20)
  ; %t22:str = str_from_i64 elapsed_ms
  ; %t23:str = str_concat(%t21, %t22)
  ; %t24:str = const_str 32
  ; %t25:str = str_concat(%t23, %t24)
  store i64 5, ptr %t26.slot, align 8
  ; %t27:i64 = runner[%t26]
  ; %t28:str = str_from_i64 %t27
  ; %t29:str = str_concat(%t25, %t28)
  ; %t30:str = const_str 33
  ; %t31:str = str_concat(%t29, %t30)
  ; print(%t31:str)
  store i64 2, ptr %t32.slot, align 8
  ; %t33:i64 = runner[%t32]
  store i64 0, ptr %t34.slot, align 8
  ; %t35:bool = cmp_eq_i64 %t33, %t34
  %r3 = load i64, ptr %t35.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_next_47, label %fall_4
fall_4:
  ; %t36:str = const_str 34
  ; print(%t36:str)
  store i64 0, ptr %t37.slot, align 8
  ; arena_restore %arena_sp_test_summary
  %r5 = load i64, ptr %t37.slot, align 8
  ret i64 %r5
ret_cont_5:
  br label %if_end_46
dead_r6:
  br label %if_next_47
if_next_47:
  ; %t38:str = const_str 35
  store i64 2, ptr %t39.slot, align 8
  ; %t40:i64 = runner[%t39]
  ; %t41:str = str_from_i64 %t40
  ; %t42:str = str_concat(%t38, %t41)
  ; %t43:str = const_str 36
  ; %t44:str = str_concat(%t42, %t43)
  ; print(%t44:str)
  store i64 1, ptr %t45.slot, align 8
  ; arena_restore %arena_sp_test_summary
  %r7 = load i64, ptr %t45.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_46
if_end_46:
  store i64 0, ptr %t46.slot, align 8
  ; arena_restore %arena_sp_test_summary
  %r8 = load i64, ptr %t46.slot, align 8
  ret i64 %r8
ret_cont_8:
  ret i64 0
}

define dso_local i64 @benchmark_create(ptr %name.arg, i64 %iterations.arg, i64 %total_ns.arg) #0 {
entry:
  %name.slot = alloca ptr, align 8
  %iterations.slot = alloca i64, align 8
  %total_ns.slot = alloca i64, align 8
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
  %t11.slot = alloca double, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %ns_op.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %ops_sec.slot = alloca double, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca double, align 8
  %t24.slot = alloca double, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  store ptr %name.arg, ptr %name.slot, align 8
  store i64 %iterations.arg, ptr %iterations.slot, align 8
  store i64 %total_ns.arg, ptr %total_ns.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 iterations, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_48, label %fall_2
fall_2:
  store i64 5, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t3:BenchmarkResult = alloc_array(%t4, init=%t5)
  store i64 0, ptr %t6.slot, align 8
  ; %t3[%t6] = name  ; str
  store i64 0, ptr %t7.slot, align 8
  store i64 1, ptr %t8.slot, align 8
  ; %t3[%t8] = %t7  ; i64
  store i64 0, ptr %t9.slot, align 8
  store i64 2, ptr %t10.slot, align 8
  ; %t3[%t10] = %t9  ; i64
  store double 0.000000e+00, ptr %t11.slot, align 8
  store i64 3, ptr %t12.slot, align 8
  ; %t3[%t12] = %t11  ; f64
  store double 0.000000e+00, ptr %t13.slot, align 8
  store i64 4, ptr %t14.slot, align 8
  ; %t3[%t14] = %t13  ; f64
  %r3 = load i64, ptr %t3.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_48
dead_r4:
  br label %if_end_48
if_end_48:
  ; %t15:f64 = i64_to_f64 total_ns
  ; %t16:f64 = i64_to_f64 iterations
  ; %t17:f64 = div_f64 %t15, %t16
  %r5 = load double, ptr %t17.slot, align 8
  store double %r5, ptr %ns_op.slot, align 8
  store double 0.000000e+00, ptr %t18.slot, align 8
  %r6 = load double, ptr %t18.slot, align 8
  store double %r6, ptr %ops_sec.slot, align 8
  store i64 0, ptr %t19.slot, align 8
  ; %t20:bool = cmp_gt_i64 total_ns, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_49, label %fall_8
fall_8:
  ; %t21:f64 = i64_to_f64 iterations
  store double 1.000000e+09, ptr %t22.slot, align 8
  ; %t23:f64 = mul_f64 %t21, %t22
  ; %t24:f64 = i64_to_f64 total_ns
  ; %t25:f64 = div_f64 %t23, %t24
  %r9 = load double, ptr %t25.slot, align 8
  store double %r9, ptr %ops_sec.slot, align 8
  br label %if_end_49
dead_r10:
  br label %if_end_49
if_end_49:
  store i64 5, ptr %t27.slot, align 8
  store i64 0, ptr %t28.slot, align 8
  ; %t26:BenchmarkResult = alloc_array(%t27, init=%t28)
  store i64 0, ptr %t29.slot, align 8
  ; %t26[%t29] = name  ; str
  store i64 1, ptr %t30.slot, align 8
  ; %t26[%t30] = iterations  ; i64
  store i64 2, ptr %t31.slot, align 8
  ; %t26[%t31] = total_ns  ; i64
  store i64 3, ptr %t32.slot, align 8
  ; %t26[%t32] = ns_op  ; f64
  store i64 4, ptr %t33.slot, align 8
  ; %t26[%t33] = ops_sec  ; f64
  %r11 = load i64, ptr %t26.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @benchmark_print(i64 %b.arg) #0 {
entry:
  %b.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca ptr, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca double, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca double, align 8
  %t35.slot = alloca double, align 8
  %mops.slot = alloca double, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca i64, align 8
  %arena_sp_benchmark_print.slot = alloca i64, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_benchmark_print:i64 = arena_save None
  ; %t1:str = const_str 37
  store i64 0, ptr %t2.slot, align 8
  ; %t3:str = b[%t2]
  ; %t4:str = str_concat(%t1, %t3)
  ; print(%t4:str)
  ; %t5:str = const_str 38
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = b[%t6]
  ; %t8:str = str_from_i64 %t7
  ; %t9:str = str_concat(%t5, %t8)
  ; print(%t9:str)
  ; %t10:str = const_str 39
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = b[%t11]
  store i64 1000000, ptr %t13.slot, align 8
  ; %t14:i64 = div_i64 %t12, %t13
  ; %t15:str = str_from_i64 %t14
  ; %t16:str = str_concat(%t10, %t15)
  ; %t17:str = const_str 40
  ; %t18:str = str_concat(%t16, %t17)
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = b[%t19]
  ; %t21:str = str_from_i64 %t20
  ; %t22:str = str_concat(%t18, %t21)
  ; %t23:str = const_str 41
  ; %t24:str = str_concat(%t22, %t23)
  ; print(%t24:str)
  ; %t25:str = const_str 42
  store i64 3, ptr %t26.slot, align 8
  ; %t27:f64 = b[%t26]
  ; %t28:str = str_from_f64 %t27
  ; %t29:str = str_concat(%t25, %t28)
  ; %t30:str = const_str 43
  ; %t31:str = str_concat(%t29, %t30)
  ; print(%t31:str)
  store i64 4, ptr %t32.slot, align 8
  ; %t33:f64 = b[%t32]
  store double 1.000000e+06, ptr %t34.slot, align 8
  ; %t35:f64 = div_f64 %t33, %t34
  %r1 = load double, ptr %t35.slot, align 8
  store double %r1, ptr %mops.slot, align 8
  ; %t36:str = const_str 44
  ; %t37:str = str_from_f64 mops
  ; %t38:str = str_concat(%t36, %t37)
  ; %t39:str = const_str 45
  ; %t40:str = str_concat(%t38, %t39)
  store i64 4, ptr %t41.slot, align 8
  ; %t42:f64 = b[%t41]
  ; %t43:str = str_from_f64 %t42
  ; %t44:str = str_concat(%t40, %t43)
  ; %t45:str = const_str 46
  ; %t46:str = str_concat(%t44, %t45)
  ; print(%t46:str)
  store i64 0, ptr %t47.slot, align 8
  ; arena_restore %arena_sp_benchmark_print
  %r2 = load i64, ptr %t47.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @array_copy_i64(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_50
for_cond_50:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_52, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:i64 = src[%t5]
  ; dst[%t4] = %t6  ; i64
  br label %for_step_51
for_step_51:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_50
dead_r5:
  br label %for_end_52
for_end_52:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_copy_f64(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_53
for_cond_53:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_55, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:f64 = src[%t5]
  ; dst[%t4] = %t6  ; f64
  br label %for_step_54
for_step_54:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_53
dead_r5:
  br label %for_end_55
for_end_55:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_copy_str(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_56
for_cond_56:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_58, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:str = src[%t5]
  ; dst[%t4] = %t6  ; i64
  br label %for_step_57
for_step_57:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_56
dead_r5:
  br label %for_end_58
for_end_58:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_i64(ptr %arr.arg, i64 %start.arg, i64 %count.arg, i64 %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_59
for_cond_59:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_61, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; i64
  br label %for_step_60
for_step_60:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_59
dead_r5:
  br label %for_end_61
for_end_61:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_f64(ptr %arr.arg, i64 %start.arg, i64 %count.arg, double %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_62
for_cond_62:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_64, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; f64
  br label %for_step_63
for_step_63:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_62
dead_r5:
  br label %for_end_64
for_end_64:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_str(ptr %arr.arg, i64 %start.arg, i64 %count.arg, ptr %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_65
for_cond_65:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_67, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; i64
  br label %for_step_66
for_step_66:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_65
dead_r5:
  br label %for_end_67
for_end_67:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @int_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_68, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_68
dead_r5:
  br label %if_end_68
if_end_68:
  store i64 0, ptr %t5.slot, align 8
  ; %t4:Array[i64] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:IntVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[i64]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @int_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_69, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_69
dead_r4:
  br label %if_end_69
if_end_69:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_70, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_70
dead_r9:
  br label %if_end_70
if_end_70:
  store i64 0, ptr %t12.slot, align 8
  ; %t11:Array[i64] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_i64(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[i64]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @int_vec_push(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_71, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_72, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_72
dead_r7:
  br label %if_end_72
if_end_72:
  store i64 0, ptr %t14.slot, align 8
  ; %t13:Array[i64] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_i64(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[i64]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_71
dead_r9:
  br label %if_end_71
if_end_71:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; i64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_73, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_73
dead_r4:
  br label %if_end_73
if_end_73:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[i64] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:i64 = %t12[%t14]
  %r5 = load i64, ptr %t15.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_74, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_74
dead_r5:
  br label %if_end_74
if_end_74:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_75, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_75
dead_r9:
  br label %if_end_75
if_end_75:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_set(i64 %v.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_76, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_76
dead_r5:
  br label %if_end_76
if_end_76:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_77, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_77
dead_r9:
  br label %if_end_77
if_end_77:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t14[real_idx] = val  ; i64
  %r10 = load i64, ptr %val.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_insert(i64 %v.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_78, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_78
dead_r5:
  br label %if_end_78
if_end_78:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_79, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_79
dead_r9:
  br label %if_end_79
if_end_79:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_80, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call int_vec_reserve(v, %t22)
  br label %if_end_80
dead_r12:
  br label %if_end_80
if_end_80:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_81
while_cond_81:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_82, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[i64] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[i64] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:i64 = %t30[%t32]
  ; %t28[i] = %t33  ; i64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_81
dead_r17:
  br label %while_end_82
while_end_82:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[i64] = v[%t36]
  ; %t37[real_idx] = val  ; i64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @int_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_83, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_83
dead_r5:
  br label %if_end_83
if_end_83:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_84, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_84
dead_r9:
  br label %if_end_84
if_end_84:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  store i64 %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_85
for_cond_85:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_87, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[i64] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:i64 = %t25[%t27]
  ; %t23[i] = %t28  ; i64
  br label %for_step_86
for_step_86:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_85
dead_r16:
  br label %for_end_87
for_end_87:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load i64, ptr %val.slot, align 8
  ret i64 %r17
ret_cont_17:
  ret i64 0
}

define dso_local i64 @int_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_88, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_88
dead_r5:
  br label %if_end_88
if_end_88:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_89, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_89
dead_r9:
  br label %if_end_89
if_end_89:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  store i64 %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_90, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[i64] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = v[%t23]
  ; %t25:i64 = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; i64
  br label %if_end_90
dead_r14:
  br label %if_end_90
if_end_90:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load i64, ptr %val.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @int_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_91, label %fall_3
fall_3:
  ; %t9:i64 = call int_vec_reserve(dst, needed)
  br label %if_end_91
dead_r4:
  br label %if_end_91
if_end_91:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_i64(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_92, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_92
dead_r5:
  br label %if_end_92
if_end_92:
  store i64 0, ptr %t7.slot, align 8
  ; %t6:Array[i64] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[i64] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_i64(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:IntVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[i64]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @int_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_93, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_94, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_94
dead_r8:
  br label %if_end_94
if_end_94:
  br label %if_end_93
dead_r9:
  br label %if_end_93
if_end_93:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_95, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_95
dead_r14:
  br label %if_end_95
if_end_95:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_96, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_96
dead_r18:
  br label %if_end_96
if_end_96:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_97, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:IntVector = call int_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_97
dead_r22:
  br label %if_end_97
if_end_97:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:IntVector = call int_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[i64] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_i64(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @int_vec_contains(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_98
for_cond_98:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_100, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  ; %t8:i64 = %t7[i]
  ; %t9:bool = cmp_eq_i64 %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_101, label %fall_5
fall_5:
  store i64 1, ptr %t10.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_101
dead_r7:
  br label %if_end_101
if_end_101:
  br label %for_step_99
for_step_99:
  ; %t11:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t11.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_98
dead_r9:
  br label %for_end_100
for_end_100:
  store i64 0, ptr %t12.slot, align 8
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_index_of(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_102
for_cond_102:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_104, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  ; %t8:i64 = %t7[i]
  ; %t9:bool = cmp_eq_i64 %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_105, label %fall_5
fall_5:
  %r6 = load i64, ptr %i.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_105
dead_r7:
  br label %if_end_105
if_end_105:
  br label %for_step_103
for_step_103:
  ; %t10:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t10.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_102
dead_r9:
  br label %for_end_104
for_end_104:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = neg_i64 %t11
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %tmp.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_106
while_cond_106:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_107, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  ; %t9:i64 = %t8[i]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[i64] = v[%t12]
  ; %t14:i64 = %t13[j]
  ; %t11[i] = %t14  ; i64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t16[j] = tmp  ; i64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_106
dead_r8:
  br label %while_end_107
while_end_107:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @_int_qsort(ptr %arr.arg, i64 %low.arg, i64 %high.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %pivot.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %tmp.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_lt_i64 low, high
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_108, label %fall_2
fall_2:
  ; %t2:i64 = arr[high]
  %r3 = load i64, ptr %t2.slot, align 8
  store i64 %r3, ptr %pivot.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 low, %t3
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  store i64 1, ptr %t5.slot, align 8
  %r5 = load i64, ptr %low.slot, align 8
  store i64 %r5, ptr %j.slot, align 8
  br label %for_cond_109
for_cond_109:
  ; %t6:bool = cmp_lt_i64 j, high
  %r6 = load i64, ptr %t6.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %for_end_111, label %fall_7
fall_7:
  ; %t7:i64 = arr[j]
  ; %t8:bool = cmp_le_i64 %t7, pivot
  %r8 = load i64, ptr %t8.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_112, label %fall_9
fall_9:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 i, %t9
  %r10 = load i64, ptr %t10.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  ; %t11:i64 = arr[i]
  %r11 = load i64, ptr %t11.slot, align 8
  store i64 %r11, ptr %tmp.slot, align 8
  ; %t12:i64 = arr[j]
  ; arr[i] = %t12  ; i64
  ; arr[j] = tmp  ; i64
  br label %if_end_112
dead_r12:
  br label %if_end_112
if_end_112:
  br label %for_step_110
for_step_110:
  ; %t13:i64 = add_i64 j, %t5
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %j.slot, align 8
  br label %for_cond_109
dead_r14:
  br label %for_end_111
for_end_111:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = add_i64 i, %t14
  ; %t16:i64 = arr[%t15]
  %r15 = load i64, ptr %t16.slot, align 8
  store i64 %r15, ptr %tmp.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  ; %t19:i64 = arr[high]
  ; arr[%t18] = %t19  ; i64
  ; arr[high] = tmp  ; i64
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 i, %t20
  %r16 = load i64, ptr %t21.slot, align 8
  store i64 %r16, ptr %p.slot, align 8
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = sub_i64 p, %t22
  ; %t24:i64 = call _int_qsort(arr, low, %t23)
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = add_i64 p, %t25
  ; %t27:i64 = call _int_qsort(arr, %t26, high)
  br label %if_end_108
dead_r17:
  br label %if_end_108
if_end_108:
  store i64 0, ptr %t28.slot, align 8
  %r18 = load i64, ptr %t28.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @int_vec_sort(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_113, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_113
dead_r4:
  br label %if_end_113
if_end_113:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = v[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = sub_i64 %t10, %t11
  ; %t13:i64 = call _int_qsort(%t7, %t8, %t12)
  store i64 0, ptr %t14.slot, align 8
  %r5 = load i64, ptr %t14.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_binary_search(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %low.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %mid.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %mid_val.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %low.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %high.slot, align 8
  br label %while_cond_114
while_cond_114:
  ; %t6:bool = cmp_le_i64 low, high
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_115, label %fall_4
fall_4:
  ; %t7:i64 = add_i64 low, high
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = div_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %mid.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = v[%t10]
  ; %t12:i64 = %t11[mid]
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %mid_val.slot, align 8
  ; %t13:bool = cmp_eq_i64 mid_val, val
  %r7 = load i64, ptr %t13.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_116, label %fall_8
fall_8:
  %r9 = load i64, ptr %mid.slot, align 8
  ret i64 %r9
ret_cont_9:
  br label %if_end_116
dead_r10:
  br label %if_end_116
if_end_116:
  ; %t14:bool = cmp_lt_i64 mid_val, val
  %r11 = load i64, ptr %t14.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_next_118, label %fall_12
fall_12:
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = add_i64 mid, %t15
  %r13 = load i64, ptr %t16.slot, align 8
  store i64 %r13, ptr %low.slot, align 8
  br label %if_end_117
dead_r14:
  br label %if_next_118
if_next_118:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = sub_i64 mid, %t17
  %r15 = load i64, ptr %t18.slot, align 8
  store i64 %r15, ptr %high.slot, align 8
  br label %if_end_117
if_end_117:
  br label %while_cond_114
dead_r16:
  br label %while_end_115
while_end_115:
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = neg_i64 %t19
  %r17 = load i64, ptr %t20.slot, align 8
  ret i64 %r17
ret_cont_17:
  ret i64 0
}

define dso_local i64 @int_vec_min(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %m.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_119, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_119
dead_r4:
  br label %if_end_119
if_end_119:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_120
for_cond_120:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_122, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t17:i64 = %t16[i]
  %r9 = load i64, ptr %t17.slot, align 8
  store i64 %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_lt_i64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_123, label %fall_11
fall_11:
  %r12 = load i64, ptr %val.slot, align 8
  store i64 %r12, ptr %m.slot, align 8
  br label %if_end_123
dead_r13:
  br label %if_end_123
if_end_123:
  br label %for_step_121
for_step_121:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_120
dead_r15:
  br label %for_end_122
for_end_122:
  %r16 = load i64, ptr %m.slot, align 8
  ret i64 %r16
ret_cont_16:
  ret i64 0
}

define dso_local i64 @int_vec_max(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %m.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_124, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_124
dead_r4:
  br label %if_end_124
if_end_124:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_125
for_cond_125:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_127, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t17:i64 = %t16[i]
  %r9 = load i64, ptr %t17.slot, align 8
  store i64 %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_gt_i64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_128, label %fall_11
fall_11:
  %r12 = load i64, ptr %val.slot, align 8
  store i64 %r12, ptr %m.slot, align 8
  br label %if_end_128
dead_r13:
  br label %if_end_128
if_end_128:
  br label %for_step_126
for_step_126:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_125
dead_r15:
  br label %for_end_127
for_end_127:
  %r16 = load i64, ptr %m.slot, align 8
  ret i64 %r16
ret_cont_16:
  ret i64 0
}

define dso_local i64 @int_vec_sum(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  store i64 1, ptr %t5.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_129
for_cond_129:
  ; %t6:bool = cmp_lt_i64 i, %t4
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_131, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  ; %t9:i64 = %t8[i]
  ; %t10:i64 = add_i64 s, %t9
  %r5 = load i64, ptr %t10.slot, align 8
  store i64 %r5, ptr %s.slot, align 8
  br label %for_step_130
for_step_130:
  ; %t11:i64 = add_i64 i, %t5
  %r6 = load i64, ptr %t11.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_129
dead_r7:
  br label %for_end_131
for_end_131:
  %r8 = load i64, ptr %s.slot, align 8
  ret i64 %r8
ret_cont_8:
  ret i64 0
}

define dso_local ptr @int_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_132, label %fall_2
fall_2:
  ; %t5:str = const_str 47
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_132
dead_r4:
  br label %if_end_132
if_end_132:
  ; %t6:str = const_str 48
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:i64 = %t8[%t9]
  ; %t11:str = str_from_i64 %t10
  ; %t12:str = str_concat(%t6, %t11)
  %r5 = load ptr, ptr %t12.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t13.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t13.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_133
for_cond_133:
  ; %t17:bool = cmp_lt_i64 i, %t15
  %r7 = load i64, ptr %t17.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_135, label %fall_8
fall_8:
  ; %t18:str = const_str 49
  ; %t19:str = str_concat(res, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; %t21:Array[i64] = v[%t20]
  ; %t22:i64 = %t21[i]
  ; %t23:str = str_from_i64 %t22
  ; %t24:str = str_concat(%t19, %t23)
  %r9 = load ptr, ptr %t24.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_134
for_step_134:
  ; %t25:i64 = add_i64 i, %t16
  %r10 = load i64, ptr %t25.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_133
dead_r11:
  br label %for_end_135
for_end_135:
  ; %t26:str = const_str 50
  ; %t27:str = str_concat(res, %t26)
  %r12 = load ptr, ptr %t27.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @float_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca double, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_136, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_136
dead_r5:
  br label %if_end_136
if_end_136:
  store double 0.000000e+00, ptr %t5.slot, align 8
  ; %t4:Array[f64] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:FloatVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[f64]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @float_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca double, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_137, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_137
dead_r4:
  br label %if_end_137
if_end_137:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_138, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_138
dead_r9:
  br label %if_end_138
if_end_138:
  store double 0.000000e+00, ptr %t12.slot, align 8
  ; %t11:Array[f64] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_f64(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[f64]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @float_vec_push(i64 %v.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca double, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_139, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_140, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_140
dead_r7:
  br label %if_end_140
if_end_140:
  store double 0.000000e+00, ptr %t14.slot, align 8
  ; %t13:Array[f64] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_f64(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[f64]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_139
dead_r9:
  br label %if_end_139
if_end_139:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; f64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local double @float_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_141, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_141
dead_r4:
  br label %if_end_141
if_end_141:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[f64] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:f64 = %t12[%t14]
  %r5 = load double, ptr %t15.slot, align 8
  ret double %r5
ret_cont_5:
  ret double 0.0
}

define dso_local double @float_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_142, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_142
dead_r5:
  br label %if_end_142
if_end_142:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_143, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_143
dead_r9:
  br label %if_end_143
if_end_143:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  ret double %r10
ret_cont_10:
  ret double 0.0
}

define dso_local i64 @float_vec_set(i64 %v.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_144, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_144
dead_r5:
  br label %if_end_144
if_end_144:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_145, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_145
dead_r9:
  br label %if_end_145
if_end_145:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t14[real_idx] = val  ; f64
  store i64 0, ptr %t15.slot, align 8
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @float_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_insert(i64 %v.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_146, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_146
dead_r5:
  br label %if_end_146
if_end_146:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_147, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_147
dead_r9:
  br label %if_end_147
if_end_147:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_148, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call float_vec_reserve(v, %t22)
  br label %if_end_148
dead_r12:
  br label %if_end_148
if_end_148:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_149
while_cond_149:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_150, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[f64] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[f64] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:f64 = %t30[%t32]
  ; %t28[i] = %t33  ; f64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_149
dead_r17:
  br label %while_end_150
while_end_150:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[f64] = v[%t36]
  ; %t37[real_idx] = val  ; f64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local double @float_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_151, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_151
dead_r5:
  br label %if_end_151
if_end_151:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_152, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_152
dead_r9:
  br label %if_end_152
if_end_152:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  store double %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_153
for_cond_153:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_155, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[f64] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:f64 = %t25[%t27]
  ; %t23[i] = %t28  ; f64
  br label %for_step_154
for_step_154:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_153
dead_r16:
  br label %for_end_155
for_end_155:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load double, ptr %val.slot, align 8
  ret double %r17
ret_cont_17:
  ret double 0.0
}

define dso_local double @float_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_156, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_156
dead_r5:
  br label %if_end_156
if_end_156:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_157, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_157
dead_r9:
  br label %if_end_157
if_end_157:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  store double %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_158, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[f64] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = v[%t23]
  ; %t25:f64 = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; f64
  br label %if_end_158
dead_r14:
  br label %if_end_158
if_end_158:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load double, ptr %val.slot, align 8
  ret double %r15
ret_cont_15:
  ret double 0.0
}

define dso_local i64 @float_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_159, label %fall_3
fall_3:
  ; %t9:i64 = call float_vec_reserve(dst, needed)
  br label %if_end_159
dead_r4:
  br label %if_end_159
if_end_159:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[f64] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_f64(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @float_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca double, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_160, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_160
dead_r5:
  br label %if_end_160
if_end_160:
  store double 0.000000e+00, ptr %t7.slot, align 8
  ; %t6:Array[f64] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[f64] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_f64(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:FloatVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[f64]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @float_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_161, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_162, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_162
dead_r8:
  br label %if_end_162
if_end_162:
  br label %if_end_161
dead_r9:
  br label %if_end_161
if_end_161:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_163, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_163
dead_r14:
  br label %if_end_163
if_end_163:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_164, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_164
dead_r18:
  br label %if_end_164
if_end_164:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_165, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:FloatVector = call float_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_165
dead_r22:
  br label %if_end_165
if_end_165:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:FloatVector = call float_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[f64] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_f64(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @float_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca double, align 8
  %tmp.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_166
while_cond_166:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_167, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  ; %t9:f64 = %t8[i]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[f64] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[f64] = v[%t12]
  ; %t14:f64 = %t13[j]
  ; %t11[i] = %t14  ; f64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t16[j] = tmp  ; f64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_166
dead_r8:
  br label %while_end_167
while_end_167:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @_float_qsort(ptr %arr.arg, i64 %low.arg, i64 %high.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %pivot.slot = alloca double, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %tmp.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_lt_i64 low, high
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_168, label %fall_2
fall_2:
  ; %t2:f64 = arr[high]
  %r3 = load double, ptr %t2.slot, align 8
  store double %r3, ptr %pivot.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 low, %t3
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  store i64 1, ptr %t5.slot, align 8
  %r5 = load i64, ptr %low.slot, align 8
  store i64 %r5, ptr %j.slot, align 8
  br label %for_cond_169
for_cond_169:
  ; %t6:bool = cmp_lt_i64 j, high
  %r6 = load i64, ptr %t6.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %for_end_171, label %fall_7
fall_7:
  ; %t7:f64 = arr[j]
  ; %t8:bool = cmp_le_f64 %t7, pivot
  %r8 = load i64, ptr %t8.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_172, label %fall_9
fall_9:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 i, %t9
  %r10 = load i64, ptr %t10.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  ; %t11:f64 = arr[i]
  %r11 = load double, ptr %t11.slot, align 8
  store double %r11, ptr %tmp.slot, align 8
  ; %t12:f64 = arr[j]
  ; arr[i] = %t12  ; f64
  ; arr[j] = tmp  ; f64
  br label %if_end_172
dead_r12:
  br label %if_end_172
if_end_172:
  br label %for_step_170
for_step_170:
  ; %t13:i64 = add_i64 j, %t5
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %j.slot, align 8
  br label %for_cond_169
dead_r14:
  br label %for_end_171
for_end_171:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = add_i64 i, %t14
  ; %t16:f64 = arr[%t15]
  %r15 = load double, ptr %t16.slot, align 8
  store double %r15, ptr %tmp.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  ; %t19:f64 = arr[high]
  ; arr[%t18] = %t19  ; f64
  ; arr[high] = tmp  ; f64
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 i, %t20
  %r16 = load i64, ptr %t21.slot, align 8
  store i64 %r16, ptr %p.slot, align 8
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = sub_i64 p, %t22
  ; %t24:i64 = call _float_qsort(arr, low, %t23)
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = add_i64 p, %t25
  ; %t27:i64 = call _float_qsort(arr, %t26, high)
  br label %if_end_168
dead_r17:
  br label %if_end_168
if_end_168:
  store i64 0, ptr %t28.slot, align 8
  %r18 = load i64, ptr %t28.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @float_vec_sort(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_173, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_173
dead_r4:
  br label %if_end_173
if_end_173:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = v[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = sub_i64 %t10, %t11
  ; %t13:i64 = call _float_qsort(%t7, %t8, %t12)
  store i64 0, ptr %t14.slot, align 8
  %r5 = load i64, ptr %t14.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local double @float_vec_min(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %m.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_174, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_174
dead_r4:
  br label %if_end_174
if_end_174:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:f64 = %t7[%t8]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_175
for_cond_175:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_177, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t17:f64 = %t16[i]
  %r9 = load double, ptr %t17.slot, align 8
  store double %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_lt_f64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_178, label %fall_11
fall_11:
  %r12 = load double, ptr %val.slot, align 8
  store double %r12, ptr %m.slot, align 8
  br label %if_end_178
dead_r13:
  br label %if_end_178
if_end_178:
  br label %for_step_176
for_step_176:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_175
dead_r15:
  br label %for_end_177
for_end_177:
  %r16 = load double, ptr %m.slot, align 8
  ret double %r16
ret_cont_16:
  ret double 0.0
}

define dso_local double @float_vec_max(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %m.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_179, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_179
dead_r4:
  br label %if_end_179
if_end_179:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:f64 = %t7[%t8]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_180
for_cond_180:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_182, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t17:f64 = %t16[i]
  %r9 = load double, ptr %t17.slot, align 8
  store double %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_gt_f64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_183, label %fall_11
fall_11:
  %r12 = load double, ptr %val.slot, align 8
  store double %r12, ptr %m.slot, align 8
  br label %if_end_183
dead_r13:
  br label %if_end_183
if_end_183:
  br label %for_step_181
for_step_181:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_180
dead_r15:
  br label %for_end_182
for_end_182:
  %r16 = load double, ptr %m.slot, align 8
  ret double %r16
ret_cont_16:
  ret double 0.0
}

define dso_local double @float_vec_sum(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %s.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  store i64 1, ptr %t5.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_184
for_cond_184:
  ; %t6:bool = cmp_lt_i64 i, %t4
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_186, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  ; %t9:f64 = %t8[i]
  ; %t10:f64 = add_f64 s, %t9
  %r5 = load double, ptr %t10.slot, align 8
  store double %r5, ptr %s.slot, align 8
  br label %for_step_185
for_step_185:
  ; %t11:i64 = add_i64 i, %t5
  %r6 = load i64, ptr %t11.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_184
dead_r7:
  br label %for_end_186
for_end_186:
  %r8 = load double, ptr %s.slot, align 8
  ret double %r8
ret_cont_8:
  ret double 0.0
}

define dso_local double @float_vec_mean(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_187, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_187
dead_r4:
  br label %if_end_187
if_end_187:
  ; %t6:f64 = call float_vec_sum(v)
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = v[%t7]
  ; %t9:f64 = i64_to_f64 %t8
  ; %t10:f64 = div_f64 %t6, %t9
  %r5 = load double, ptr %t10.slot, align 8
  ret double %r5
ret_cont_5:
  ret double 0.0
}

define dso_local ptr @float_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_188, label %fall_2
fall_2:
  ; %t5:str = const_str 47
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_188
dead_r4:
  br label %if_end_188
if_end_188:
  ; %t6:str = const_str 48
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:f64 = %t8[%t9]
  ; %t11:str = str_from_f64 %t10
  ; %t12:str = str_concat(%t6, %t11)
  %r5 = load ptr, ptr %t12.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t13.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t13.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_189
for_cond_189:
  ; %t17:bool = cmp_lt_i64 i, %t15
  %r7 = load i64, ptr %t17.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_191, label %fall_8
fall_8:
  ; %t18:str = const_str 49
  ; %t19:str = str_concat(res, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; %t21:Array[f64] = v[%t20]
  ; %t22:f64 = %t21[i]
  ; %t23:str = str_from_f64 %t22
  ; %t24:str = str_concat(%t19, %t23)
  %r9 = load ptr, ptr %t24.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_190
for_step_190:
  ; %t25:i64 = add_i64 i, %t16
  %r10 = load i64, ptr %t25.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_189
dead_r11:
  br label %for_end_191
for_end_191:
  ; %t26:str = const_str 50
  ; %t27:str = str_concat(res, %t26)
  %r12 = load ptr, ptr %t27.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @str_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_192, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_192
dead_r5:
  br label %if_end_192
if_end_192:
  ; %t5:str = const_str 1
  ; %t4:Array[str] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:StrVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[str]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @str_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_193, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_193
dead_r4:
  br label %if_end_193
if_end_193:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_194, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_194
dead_r9:
  br label %if_end_194
if_end_194:
  ; %t12:str = const_str 1
  ; %t11:Array[str] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_str(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[str]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @str_vec_push(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_195, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_196, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_196
dead_r7:
  br label %if_end_196
if_end_196:
  ; %t14:str = const_str 1
  ; %t13:Array[str] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[str] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_str(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[str]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_195
dead_r9:
  br label %if_end_195
if_end_195:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; i64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local ptr @str_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_197, label %fall_2
fall_2:
  ; %t5:str = const_str 1
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_197
dead_r4:
  br label %if_end_197
if_end_197:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[str] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:str = %t12[%t14]
  %r5 = load ptr, ptr %t15.slot, align 8
  ret ptr %r5
ret_cont_5:
  ret ptr 0
}

define dso_local ptr @str_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_198, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_198
dead_r5:
  br label %if_end_198
if_end_198:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_199, label %fall_7
fall_7:
  ; %t12:str = const_str 1
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_199
dead_r9:
  br label %if_end_199
if_end_199:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  ret ptr %r10
ret_cont_10:
  ret ptr 0
}

define dso_local i64 @str_vec_set(i64 %v.arg, i64 %idx.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_200, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_200
dead_r5:
  br label %if_end_200
if_end_200:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_201, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_201
dead_r9:
  br label %if_end_201
if_end_201:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t14[real_idx] = val  ; i64
  store i64 0, ptr %t15.slot, align 8
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @str_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_insert(i64 %v.arg, i64 %idx.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_202, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_202
dead_r5:
  br label %if_end_202
if_end_202:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_203, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_203
dead_r9:
  br label %if_end_203
if_end_203:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_204, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call str_vec_reserve(v, %t22)
  br label %if_end_204
dead_r12:
  br label %if_end_204
if_end_204:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_205
while_cond_205:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_206, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[str] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[str] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:str = %t30[%t32]
  ; %t28[i] = %t33  ; i64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_205
dead_r17:
  br label %while_end_206
while_end_206:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[str] = v[%t36]
  ; %t37[real_idx] = val  ; i64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local ptr @str_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %val.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_207, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_207
dead_r5:
  br label %if_end_207
if_end_207:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_208, label %fall_7
fall_7:
  ; %t12:str = const_str 1
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_208
dead_r9:
  br label %if_end_208
if_end_208:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  store ptr %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_209
for_cond_209:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_211, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[str] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:str = %t25[%t27]
  ; %t23[i] = %t28  ; i64
  br label %for_step_210
for_step_210:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_209
dead_r16:
  br label %for_end_211
for_end_211:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load ptr, ptr %val.slot, align 8
  ret ptr %r17
ret_cont_17:
  ret ptr 0
}

define dso_local ptr @str_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
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
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %val.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_212, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_212
dead_r5:
  br label %if_end_212
if_end_212:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_213, label %fall_7
fall_7:
  ; %t12:str = const_str 1
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_213
dead_r9:
  br label %if_end_213
if_end_213:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  store ptr %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_214, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[str] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[str] = v[%t23]
  ; %t25:str = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; i64
  br label %if_end_214
dead_r14:
  br label %if_end_214
if_end_214:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load ptr, ptr %val.slot, align 8
  ret ptr %r15
ret_cont_15:
  ret ptr 0
}

define dso_local i64 @str_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_215, label %fall_3
fall_3:
  ; %t9:i64 = call str_vec_reserve(dst, needed)
  br label %if_end_215
dead_r4:
  br label %if_end_215
if_end_215:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_str(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @str_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_216, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_216
dead_r5:
  br label %if_end_216
if_end_216:
  ; %t7:str = const_str 1
  ; %t6:Array[str] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[str] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_str(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:StrVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[str]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @str_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_217, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_218, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_218
dead_r8:
  br label %if_end_218
if_end_218:
  br label %if_end_217
dead_r9:
  br label %if_end_217
if_end_217:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_219, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_219
dead_r14:
  br label %if_end_219
if_end_219:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_220, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_220
dead_r18:
  br label %if_end_220
if_end_220:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_221, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:StrVector = call str_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_221
dead_r22:
  br label %if_end_221
if_end_221:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:StrVector = call str_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[str] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_str(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @str_vec_contains(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_222
for_cond_222:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_224, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[str] = v[%t6]
  ; %t8:str = %t7[i]
  ; %t9:bool = str_cmp_eq %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_225, label %fall_5
fall_5:
  store i64 1, ptr %t10.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_225
dead_r7:
  br label %if_end_225
if_end_225:
  br label %for_step_223
for_step_223:
  ; %t11:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t11.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_222
dead_r9:
  br label %for_end_224
for_end_224:
  store i64 0, ptr %t12.slot, align 8
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @str_vec_index_of(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_226
for_cond_226:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_228, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[str] = v[%t6]
  ; %t8:str = %t7[i]
  ; %t9:bool = str_cmp_eq %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_229, label %fall_5
fall_5:
  %r6 = load i64, ptr %i.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_229
dead_r7:
  br label %if_end_229
if_end_229:
  br label %for_step_227
for_step_227:
  ; %t10:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t10.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_226
dead_r9:
  br label %for_end_228
for_end_228:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = neg_i64 %t11
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local ptr @str_vec_join(i64 %v.arg, ptr %sep.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %sep.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %sep.arg, ptr %sep.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_230, label %fall_2
fall_2:
  ; %t5:str = const_str 1
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_230
dead_r4:
  br label %if_end_230
if_end_230:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:bool = cmp_eq_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_231, label %fall_6
fall_6:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:str = %t11[%t12]
  %r7 = load ptr, ptr %t13.slot, align 8
  ret ptr %r7
ret_cont_7:
  br label %if_end_231
dead_r8:
  br label %if_end_231
if_end_231:
  store i64 0, ptr %t14.slot, align 8
  ; %t15:Array[str] = v[%t14]
  store i64 0, ptr %t16.slot, align 8
  ; %t17:str = %t15[%t16]
  %r9 = load ptr, ptr %t17.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  store i64 1, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  %r10 = load i64, ptr %t18.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_232
for_cond_232:
  ; %t22:bool = cmp_lt_i64 i, %t20
  %r11 = load i64, ptr %t22.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %for_end_234, label %fall_12
fall_12:
  ; %t23:str = str_concat(res, sep)
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  ; %t26:str = %t25[i]
  ; %t27:str = str_concat(%t23, %t26)
  %r13 = load ptr, ptr %t27.slot, align 8
  store ptr %r13, ptr %res.slot, align 8
  br label %for_step_233
for_step_233:
  ; %t28:i64 = add_i64 i, %t21
  %r14 = load i64, ptr %t28.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_232
dead_r15:
  br label %for_end_234
for_end_234:
  %r16 = load ptr, ptr %res.slot, align 8
  ret ptr %r16
ret_cont_16:
  ret ptr 0
}

define dso_local i64 @str_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %tmp.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_235
while_cond_235:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_236, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[str] = v[%t7]
  ; %t9:str = %t8[i]
  %r5 = load ptr, ptr %t9.slot, align 8
  store ptr %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[str] = v[%t12]
  ; %t14:str = %t13[j]
  ; %t11[i] = %t14  ; i64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[str] = v[%t15]
  ; %t16[j] = tmp  ; i64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_235
dead_r8:
  br label %while_end_236
while_end_236:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local ptr @str_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_237, label %fall_2
fall_2:
  ; %t5:str = const_str 47
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_237
dead_r4:
  br label %if_end_237
if_end_237:
  ; %t6:str = const_str 51
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[str] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:str = %t8[%t9]
  ; %t11:str = str_concat(%t6, %t10)
  ; %t12:str = const_str 24
  ; %t13:str = str_concat(%t11, %t12)
  %r5 = load ptr, ptr %t13.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = v[%t15]
  store i64 1, ptr %t17.slot, align 8
  %r6 = load i64, ptr %t14.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_238
for_cond_238:
  ; %t18:bool = cmp_lt_i64 i, %t16
  %r7 = load i64, ptr %t18.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_240, label %fall_8
fall_8:
  ; %t19:str = const_str 52
  ; %t20:str = str_concat(res, %t19)
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[str] = v[%t21]
  ; %t23:str = %t22[i]
  ; %t24:str = str_concat(%t20, %t23)
  ; %t25:str = const_str 24
  ; %t26:str = str_concat(%t24, %t25)
  %r9 = load ptr, ptr %t26.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_239
for_step_239:
  ; %t27:i64 = add_i64 i, %t17
  %r10 = load i64, ptr %t27.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_238
dead_r11:
  br label %for_end_240
for_end_240:
  ; %t28:str = const_str 50
  ; %t29:str = str_concat(res, %t28)
  %r12 = load ptr, ptr %t29.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @int_slice_new(ptr %arr.arg, i64 %offset.arg, i64 %length.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %offset.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %offset.arg, ptr %offset.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:IntSlice = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  ; %t1[%t4] = arr  ; Array[i64]
  store i64 1, ptr %t5.slot, align 8
  ; %t1[%t5] = offset  ; i64
  store i64 2, ptr %t6.slot, align 8
  ; %t1[%t6] = length  ; i64
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_slice_from_vec(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_241, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_242, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_242
dead_r8:
  br label %if_end_242
if_end_242:
  br label %if_end_241
dead_r9:
  br label %if_end_241
if_end_241:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_243, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_243
dead_r14:
  br label %if_end_243
if_end_243:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_244, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_244
dead_r18:
  br label %if_end_244
if_end_244:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_245, label %fall_20
fall_20:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:IntSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = v[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[i64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = s  ; i64
  store i64 0, ptr %t27.slot, align 8
  store i64 2, ptr %t28.slot, align 8
  ; %t20[%t28] = %t27  ; i64
  %r21 = load i64, ptr %t20.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_245
dead_r22:
  br label %if_end_245
if_end_245:
  store i64 3, ptr %t30.slot, align 8
  store i64 0, ptr %t31.slot, align 8
  ; %t29:IntSlice = alloc_array(%t30, init=%t31)
  store i64 0, ptr %t32.slot, align 8
  ; %t33:Array[i64] = v[%t32]
  store i64 0, ptr %t34.slot, align 8
  ; %t29[%t34] = %t33  ; Array[i64]
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = s  ; i64
  ; %t36:i64 = sub_i64 e, s
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; i64
  %r23 = load i64, ptr %t29.slot, align 8
  ret i64 %r23
ret_cont_23:
  ret i64 0
}

define dso_local i64 @int_slice_get(i64 %s.arg, i64 %idx.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  ; %t6:i64 = %t5[real_idx]
  %r2 = load i64, ptr %t6.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @int_slice_set(i64 %s.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  ; %t5[real_idx] = val  ; i64
  %r2 = load i64, ptr %val.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @int_slice_subslice(i64 %s.arg, i64 %start.arg, i64 %length.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %new_offset.slot = alloca i64, align 8
  %new_len.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, start
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %new_offset.slot, align 8
  %r2 = load i64, ptr %length.slot, align 8
  store i64 %r2, ptr %new_len.slot, align 8
  ; %t4:i64 = add_i64 new_offset, new_len
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = s[%t5]
  store i64 2, ptr %t7.slot, align 8
  ; %t8:i64 = s[%t7]
  ; %t9:i64 = add_i64 %t6, %t8
  ; %t10:bool = cmp_gt_i64 %t4, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_246, label %fall_4
fall_4:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  store i64 2, ptr %t13.slot, align 8
  ; %t14:i64 = s[%t13]
  ; %t15:i64 = add_i64 %t12, %t14
  ; %t16:i64 = sub_i64 %t15, new_offset
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %new_len.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t18:bool = cmp_lt_i64 new_len, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_247, label %fall_7
fall_7:
  store i64 0, ptr %t19.slot, align 8
  %r8 = load i64, ptr %t19.slot, align 8
  store i64 %r8, ptr %new_len.slot, align 8
  br label %if_end_247
dead_r9:
  br label %if_end_247
if_end_247:
  br label %if_end_246
dead_r10:
  br label %if_end_246
if_end_246:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:IntSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = s[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[i64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = new_offset  ; i64
  store i64 2, ptr %t27.slot, align 8
  ; %t20[%t27] = new_len  ; i64
  %r11 = load i64, ptr %t20.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @int_slice_to_vec(i64 %s.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:IntVector = call int_vec_new(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = s[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[i64] = res[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  ; %t13:i64 = call array_copy_i64(%t5, %t7, %t9, %t10, %t12)
  store i64 2, ptr %t14.slot, align 8
  ; %t15:i64 = s[%t14]
  store i64 1, ptr %t16.slot, align 8
  ; res[%t16] = %t15  ; i64
  %r2 = load i64, ptr %res.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @float_slice_new(ptr %arr.arg, i64 %offset.arg, i64 %length.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %offset.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %offset.arg, ptr %offset.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:FloatSlice = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  ; %t1[%t4] = arr  ; Array[f64]
  store i64 1, ptr %t5.slot, align 8
  ; %t1[%t5] = offset  ; i64
  store i64 2, ptr %t6.slot, align 8
  ; %t1[%t6] = length  ; i64
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_slice_from_vec(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_248, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_249, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_249
dead_r8:
  br label %if_end_249
if_end_249:
  br label %if_end_248
dead_r9:
  br label %if_end_248
if_end_248:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_250, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_250
dead_r14:
  br label %if_end_250
if_end_250:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_251, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_251
dead_r18:
  br label %if_end_251
if_end_251:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_252, label %fall_20
fall_20:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:FloatSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = v[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[f64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = s  ; i64
  store i64 0, ptr %t27.slot, align 8
  store i64 2, ptr %t28.slot, align 8
  ; %t20[%t28] = %t27  ; i64
  %r21 = load i64, ptr %t20.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_252
dead_r22:
  br label %if_end_252
if_end_252:
  store i64 3, ptr %t30.slot, align 8
  store i64 0, ptr %t31.slot, align 8
  ; %t29:FloatSlice = alloc_array(%t30, init=%t31)
  store i64 0, ptr %t32.slot, align 8
  ; %t33:Array[f64] = v[%t32]
  store i64 0, ptr %t34.slot, align 8
  ; %t29[%t34] = %t33  ; Array[f64]
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = s  ; i64
  ; %t36:i64 = sub_i64 e, s
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; i64
  %r23 = load i64, ptr %t29.slot, align 8
  ret i64 %r23
ret_cont_23:
  ret i64 0
}

define dso_local double @float_slice_get(i64 %s.arg, i64 %idx.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca double, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  ; %t6:f64 = %t5[real_idx]
  %r2 = load double, ptr %t6.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local i64 @float_slice_set(i64 %s.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  ; %t5[real_idx] = val  ; f64
  store i64 0, ptr %t6.slot, align 8
  %r2 = load i64, ptr %t6.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @float_slice_subslice(i64 %s.arg, i64 %start.arg, i64 %length.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %new_offset.slot = alloca i64, align 8
  %new_len.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, start
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %new_offset.slot, align 8
  %r2 = load i64, ptr %length.slot, align 8
  store i64 %r2, ptr %new_len.slot, align 8
  ; %t4:i64 = add_i64 new_offset, new_len
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = s[%t5]
  store i64 2, ptr %t7.slot, align 8
  ; %t8:i64 = s[%t7]
  ; %t9:i64 = add_i64 %t6, %t8
  ; %t10:bool = cmp_gt_i64 %t4, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_253, label %fall_4
fall_4:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  store i64 2, ptr %t13.slot, align 8
  ; %t14:i64 = s[%t13]
  ; %t15:i64 = add_i64 %t12, %t14
  ; %t16:i64 = sub_i64 %t15, new_offset
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %new_len.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t18:bool = cmp_lt_i64 new_len, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_254, label %fall_7
fall_7:
  store i64 0, ptr %t19.slot, align 8
  %r8 = load i64, ptr %t19.slot, align 8
  store i64 %r8, ptr %new_len.slot, align 8
  br label %if_end_254
dead_r9:
  br label %if_end_254
if_end_254:
  br label %if_end_253
dead_r10:
  br label %if_end_253
if_end_253:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:FloatSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = s[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[f64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = new_offset  ; i64
  store i64 2, ptr %t27.slot, align 8
  ; %t20[%t27] = new_len  ; i64
  %r11 = load i64, ptr %t20.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @float_slice_to_vec(i64 %s.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:FloatVector = call float_vec_new(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = s[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[f64] = res[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  ; %t13:i64 = call array_copy_f64(%t5, %t7, %t9, %t10, %t12)
  store i64 2, ptr %t14.slot, align 8
  ; %t15:i64 = s[%t14]
  store i64 1, ptr %t16.slot, align 8
  ; res[%t16] = %t15  ; i64
  %r2 = load i64, ptr %res.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %runner.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca double, align 8
  %t40.slot = alloca double, align 8
  %t41.slot = alloca double, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca double, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca double, align 8
  %t47.slot = alloca double, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca ptr, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca double, align 8
  %t52.slot = alloca double, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca ptr, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca ptr, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca ptr, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %t62.slot = alloca ptr, align 8
  %t63.slot = alloca ptr, align 8
  %t64.slot = alloca ptr, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca ptr, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca ptr, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca ptr, align 8
  %t75.slot = alloca ptr, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca ptr, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca ptr, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca ptr, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %v.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca ptr, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca ptr, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca ptr, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  %t112.slot = alloca ptr, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca i64, align 8
  %t115.slot = alloca i64, align 8
  %bs_idx.slot = alloca i64, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca ptr, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca ptr, align 8
  %t120.slot = alloca ptr, align 8
  %t121.slot = alloca ptr, align 8
  %t122.slot = alloca ptr, align 8
  %t123.slot = alloca i64, align 8
  %b1_iters.slot = alloca i64, align 8
  %t124.slot = alloca i64, align 8
  %b1_start.slot = alloca i64, align 8
  %t125.slot = alloca i64, align 8
  %b1_acc.slot = alloca i64, align 8
  %t126.slot = alloca i64, align 8
  %t127.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca i64, align 8
  %t132.slot = alloca i64, align 8
  %t133.slot = alloca i64, align 8
  %t134.slot = alloca i64, align 8
  %b1_elapsed.slot = alloca i64, align 8
  %t135.slot = alloca ptr, align 8
  %t136.slot = alloca i64, align 8
  %b1.slot = alloca i64, align 8
  %t137.slot = alloca i64, align 8
  %t138.slot = alloca i64, align 8
  %b2_iters.slot = alloca i64, align 8
  %t139.slot = alloca i64, align 8
  %b2_vec.slot = alloca i64, align 8
  %t140.slot = alloca i64, align 8
  %b2_start.slot = alloca i64, align 8
  %t141.slot = alloca i64, align 8
  %t142.slot = alloca i64, align 8
  %t143.slot = alloca i64, align 8
  %t144.slot = alloca i64, align 8
  %t145.slot = alloca i64, align 8
  %t146.slot = alloca i64, align 8
  %t147.slot = alloca i64, align 8
  %t148.slot = alloca i64, align 8
  %t149.slot = alloca i64, align 8
  %t150.slot = alloca i64, align 8
  %t151.slot = alloca i64, align 8
  %t152.slot = alloca i64, align 8
  %b2_elapsed.slot = alloca i64, align 8
  %t153.slot = alloca ptr, align 8
  %t154.slot = alloca i64, align 8
  %t155.slot = alloca i64, align 8
  %t156.slot = alloca i64, align 8
  %b2.slot = alloca i64, align 8
  %t157.slot = alloca i64, align 8
  %t158.slot = alloca i64, align 8
  %b3_iters.slot = alloca i64, align 8
  %t159.slot = alloca ptr, align 8
  %b3_src.slot = alloca ptr, align 8
  %t160.slot = alloca i64, align 8
  %b3_start.slot = alloca i64, align 8
  %t161.slot = alloca i64, align 8
  %b3_matches.slot = alloca i64, align 8
  %t162.slot = alloca i64, align 8
  %t163.slot = alloca i64, align 8
  %t164.slot = alloca i64, align 8
  %t165.slot = alloca i64, align 8
  %t166.slot = alloca i64, align 8
  %t167.slot = alloca ptr, align 8
  %sub.slot = alloca ptr, align 8
  %t168.slot = alloca ptr, align 8
  %t169.slot = alloca i64, align 8
  %t170.slot = alloca i64, align 8
  %t171.slot = alloca i64, align 8
  %t172.slot = alloca i64, align 8
  %t173.slot = alloca i64, align 8
  %t174.slot = alloca i64, align 8
  %b3_elapsed.slot = alloca i64, align 8
  %t175.slot = alloca ptr, align 8
  %t176.slot = alloca i64, align 8
  %b3.slot = alloca i64, align 8
  %t177.slot = alloca i64, align 8
  %t178.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 53
  ; print(%t1:str)
  ; %t2:str = const_str 54
  ; print(%t2:str)
  ; %t3:str = const_str 53
  ; print(%t3:str)
  store i64 1, ptr %t4.slot, align 8
  ; %t5:TestRunner = call test_runner_new(%t4)
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %runner.slot, align 8
  ; %t6:str = const_str 55
  ; %t7:i64 = call test_suite(runner, %t6)
  ; %t8:str = const_str 56
  ; %t9:i64 = call test_case(runner, %t8)
  store i64 1048576, ptr %t12.slot, align 8
  store i64 1048576, ptr %t13.slot, align 8
  ; %t14:str = const_str 57
  ; %t15:bool = call assert_eq_i64(runner, %t12, %t13, %t14)
  store i64 42, ptr %t16.slot, align 8
  store i64 43, ptr %t17.slot, align 8
  ; %t18:str = const_str 58
  ; %t19:bool = call assert_ne_i64(runner, %t16, %t17, %t18)
  store i64 10, ptr %t20.slot, align 8
  ; %t21:i64 = neg_i64 %t20
  store i64 0, ptr %t22.slot, align 8
  ; %t23:str = const_str 59
  ; %t24:bool = call assert_lt_i64(runner, %t21, %t22, %t23)
  store i64 100, ptr %t25.slot, align 8
  store i64 100, ptr %t26.slot, align 8
  ; %t27:str = const_str 60
  ; %t28:bool = call assert_le_i64(runner, %t25, %t26, %t27)
  store i64 100, ptr %t29.slot, align 8
  store i64 99, ptr %t30.slot, align 8
  ; %t31:str = const_str 61
  ; %t32:bool = call assert_gt_i64(runner, %t29, %t30, %t31)
  store i64 50, ptr %t33.slot, align 8
  store i64 50, ptr %t34.slot, align 8
  ; %t35:str = const_str 62
  ; %t36:bool = call assert_ge_i64(runner, %t33, %t34, %t35)
  ; %t37:str = const_str 63
  ; %t38:i64 = call test_case(runner, %t37)
  store double 3.000000e-01, ptr %t41.slot, align 8
  store double 3.000000e-01, ptr %t42.slot, align 8
  store double 1.000000e-06, ptr %t43.slot, align 8
  ; %t44:str = const_str 64
  ; %t45:bool = call assert_eq_f64(runner, %t41, %t42, %t43, %t44)
  store i64 1, ptr %t48.slot, align 8
  ; %t49:str = const_str 65
  ; %t50:bool = call assert_true(runner, %t48, %t49)
  store i64 0, ptr %t53.slot, align 8
  ; %t54:str = const_str 66
  ; %t55:bool = call assert_false(runner, %t53, %t54)
  ; %t56:str = const_str 67
  ; %t57:i64 = call test_suite(runner, %t56)
  ; %t58:str = const_str 68
  ; %t59:i64 = call test_case(runner, %t58)
  ; %t60:str = const_str 69
  ; %t61:str = const_str 70
  ; %t62:str = str_concat(%t60, %t61)
  ; %t63:str = const_str 71
  ; %t64:str = const_str 72
  ; %t65:bool = call assert_eq_str(runner, %t62, %t63, %t64)
  ; %t66:str = const_str 73
  ; %t67:str = const_str 74
  ; %t68:str = const_str 75
  ; %t69:bool = call assert_ne_str(runner, %t66, %t67, %t68)
  ; %t70:str = const_str 76
  ; %t71:str = const_str 77
  ; %t72:str = const_str 78
  ; %t73:bool = call assert_str_contains(runner, %t70, %t71, %t72)
  ; %t74:str = const_str 79
  ; %t75:str = const_str 80
  ; %t76:bool = call str_contains(%t74, %t75)
  ; %t77:str = const_str 81
  ; %t78:bool = call assert_false(runner, %t76, %t77)
  ; %t79:str = const_str 82
  ; %t80:i64 = call test_suite(runner, %t79)
  ; %t81:str = const_str 83
  ; %t82:i64 = call test_case(runner, %t81)
  store i64 2, ptr %t83.slot, align 8
  ; %t84:IntVector = call int_vec_new(%t83)
  %r2 = load i64, ptr %t84.slot, align 8
  store i64 %r2, ptr %v.slot, align 8
  store i64 40, ptr %t85.slot, align 8
  ; %t86:i64 = call int_vec_push(v, %t85)
  store i64 10, ptr %t87.slot, align 8
  ; %t88:i64 = call int_vec_push(v, %t87)
  store i64 30, ptr %t89.slot, align 8
  ; %t90:i64 = call int_vec_push(v, %t89)
  store i64 20, ptr %t91.slot, align 8
  ; %t92:i64 = call int_vec_push(v, %t91)
  ; %t93:i64 = call int_vec_len(v)
  store i64 4, ptr %t94.slot, align 8
  ; %t95:str = const_str 84
  ; %t96:bool = call assert_eq_i64(runner, %t93, %t94, %t95)
  store i64 1, ptr %t97.slot, align 8
  ; %t98:i64 = neg_i64 %t97
  ; %t99:i64 = call int_vec_get(v, %t98)
  store i64 20, ptr %t100.slot, align 8
  ; %t101:str = const_str 85
  ; %t102:bool = call assert_eq_i64(runner, %t99, %t100, %t101)
  ; %t103:i64 = call int_vec_sort(v)
  store i64 0, ptr %t104.slot, align 8
  ; %t105:i64 = call int_vec_get(v, %t104)
  store i64 10, ptr %t106.slot, align 8
  ; %t107:str = const_str 86
  ; %t108:bool = call assert_eq_i64(runner, %t105, %t106, %t107)
  store i64 3, ptr %t109.slot, align 8
  ; %t110:i64 = call int_vec_get(v, %t109)
  store i64 40, ptr %t111.slot, align 8
  ; %t112:str = const_str 87
  ; %t113:bool = call assert_eq_i64(runner, %t110, %t111, %t112)
  store i64 30, ptr %t114.slot, align 8
  ; %t115:i64 = call int_vec_binary_search(v, %t114)
  %r3 = load i64, ptr %t115.slot, align 8
  store i64 %r3, ptr %bs_idx.slot, align 8
  store i64 2, ptr %t116.slot, align 8
  ; %t117:str = const_str 88
  ; %t118:bool = call assert_eq_i64(runner, bs_idx, %t116, %t117)
  ; %t119:str = const_str 1
  ; print(%t119:str)
  ; %t120:str = const_str 53
  ; print(%t120:str)
  ; %t121:str = const_str 89
  ; print(%t121:str)
  ; %t122:str = const_str 53
  ; print(%t122:str)
  store i64 1000000, ptr %t123.slot, align 8
  %r4 = load i64, ptr %t123.slot, align 8
  store i64 %r4, ptr %b1_iters.slot, align 8
  ; %t124:i64 = clock_ns None
  %r5 = load i64, ptr %t124.slot, align 8
  store i64 %r5, ptr %b1_start.slot, align 8
  store i64 0, ptr %t125.slot, align 8
  %r6 = load i64, ptr %t125.slot, align 8
  store i64 %r6, ptr %b1_acc.slot, align 8
  store i64 0, ptr %t126.slot, align 8
  store i64 1, ptr %t127.slot, align 8
  %r7 = load i64, ptr %t126.slot, align 8
  store i64 %r7, ptr %i.slot, align 8
  br label %for_cond_255
for_cond_255:
  ; %t128:bool = cmp_lt_i64 i, b1_iters
  %r8 = load i64, ptr %t128.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %for_end_257, label %fall_9
fall_9:
  ; %t129:i64 = add_i64 b1_acc, i
  store i64 1431655765, ptr %t130.slot, align 8
  ; %t131:i64 = xor_i64 %t129, %t130
  %r10 = load i64, ptr %t131.slot, align 8
  store i64 %r10, ptr %b1_acc.slot, align 8
  br label %for_step_256
for_step_256:
  ; %t132:i64 = add_i64 i, %t127
  %r11 = load i64, ptr %t132.slot, align 8
  store i64 %r11, ptr %i.slot, align 8
  br label %for_cond_255
dead_r12:
  br label %for_end_257
for_end_257:
  ; %t133:i64 = clock_ns None
  ; %t134:i64 = sub_i64 %t133, b1_start
  %r13 = load i64, ptr %t134.slot, align 8
  store i64 %r13, ptr %b1_elapsed.slot, align 8
  ; %t135:str = const_str 90
  ; %t136:BenchmarkResult = call benchmark_create(%t135, b1_iters, b1_elapsed)
  %r14 = load i64, ptr %t136.slot, align 8
  store i64 %r14, ptr %b1.slot, align 8
  ; %t137:i64 = call benchmark_print(b1)
  store i64 100000, ptr %t138.slot, align 8
  %r15 = load i64, ptr %t138.slot, align 8
  store i64 %r15, ptr %b2_iters.slot, align 8
  ; %t139:IntVector = call int_vec_new(b2_iters)
  %r16 = load i64, ptr %t139.slot, align 8
  store i64 %r16, ptr %b2_vec.slot, align 8
  ; %t140:i64 = clock_ns None
  %r17 = load i64, ptr %t140.slot, align 8
  store i64 %r17, ptr %b2_start.slot, align 8
  store i64 0, ptr %t141.slot, align 8
  store i64 1, ptr %t142.slot, align 8
  %r18 = load i64, ptr %t141.slot, align 8
  store i64 %r18, ptr %i.slot, align 8
  br label %for_cond_258
for_cond_258:
  ; %t143:bool = cmp_lt_i64 i, b2_iters
  %r19 = load i64, ptr %t143.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %for_end_260, label %fall_20
fall_20:
  ; %t144:i64 = call int_vec_push(b2_vec, i)
  br label %for_step_259
for_step_259:
  ; %t145:i64 = add_i64 i, %t142
  %r21 = load i64, ptr %t145.slot, align 8
  store i64 %r21, ptr %i.slot, align 8
  br label %for_cond_258
dead_r22:
  br label %for_end_260
for_end_260:
  store i64 0, ptr %t146.slot, align 8
  store i64 1, ptr %t147.slot, align 8
  %r23 = load i64, ptr %t146.slot, align 8
  store i64 %r23, ptr %i.slot, align 8
  br label %for_cond_261
for_cond_261:
  ; %t148:bool = cmp_lt_i64 i, b2_iters
  %r24 = load i64, ptr %t148.slot, align 8
  %r25 = icmp eq i64 %r24, 0
  br i1 %r25, label %for_end_263, label %fall_25
fall_25:
  ; %t149:i64 = call int_vec_pop(b2_vec)
  br label %for_step_262
for_step_262:
  ; %t150:i64 = add_i64 i, %t147
  %r26 = load i64, ptr %t150.slot, align 8
  store i64 %r26, ptr %i.slot, align 8
  br label %for_cond_261
dead_r27:
  br label %for_end_263
for_end_263:
  ; %t151:i64 = clock_ns None
  ; %t152:i64 = sub_i64 %t151, b2_start
  %r28 = load i64, ptr %t152.slot, align 8
  store i64 %r28, ptr %b2_elapsed.slot, align 8
  ; %t153:str = const_str 91
  store i64 2, ptr %t154.slot, align 8
  ; %t155:i64 = mul_i64 b2_iters, %t154
  ; %t156:BenchmarkResult = call benchmark_create(%t153, %t155, b2_elapsed)
  %r29 = load i64, ptr %t156.slot, align 8
  store i64 %r29, ptr %b2.slot, align 8
  ; %t157:i64 = call benchmark_print(b2)
  store i64 50000, ptr %t158.slot, align 8
  %r30 = load i64, ptr %t158.slot, align 8
  store i64 %r30, ptr %b3_iters.slot, align 8
  ; %t159:str = const_str 92
  %r31 = load ptr, ptr %t159.slot, align 8
  store ptr %r31, ptr %b3_src.slot, align 8
  ; %t160:i64 = clock_ns None
  %r32 = load i64, ptr %t160.slot, align 8
  store i64 %r32, ptr %b3_start.slot, align 8
  store i64 0, ptr %t161.slot, align 8
  %r33 = load i64, ptr %t161.slot, align 8
  store i64 %r33, ptr %b3_matches.slot, align 8
  store i64 0, ptr %t162.slot, align 8
  store i64 1, ptr %t163.slot, align 8
  %r34 = load i64, ptr %t162.slot, align 8
  store i64 %r34, ptr %i.slot, align 8
  br label %for_cond_264
for_cond_264:
  ; %t164:bool = cmp_lt_i64 i, b3_iters
  %r35 = load i64, ptr %t164.slot, align 8
  %r36 = icmp eq i64 %r35, 0
  br i1 %r36, label %for_end_266, label %fall_36
fall_36:
  store i64 6, ptr %t165.slot, align 8
  store i64 11, ptr %t166.slot, align 8
  ; %t167:str = str_slice(b3_src[%t165:%t166])
  %r37 = load ptr, ptr %t167.slot, align 8
  store ptr %r37, ptr %sub.slot, align 8
  ; %t168:str = const_str 93
  ; %t169:bool = str_cmp_eq sub, %t168
  %r38 = load i64, ptr %t169.slot, align 8
  %r39 = icmp eq i64 %r38, 0
  br i1 %r39, label %if_end_267, label %fall_39
fall_39:
  store i64 1, ptr %t170.slot, align 8
  ; %t171:i64 = add_i64 b3_matches, %t170
  %r40 = load i64, ptr %t171.slot, align 8
  store i64 %r40, ptr %b3_matches.slot, align 8
  br label %if_end_267
dead_r41:
  br label %if_end_267
if_end_267:
  br label %for_step_265
for_step_265:
  ; %t172:i64 = add_i64 i, %t163
  %r42 = load i64, ptr %t172.slot, align 8
  store i64 %r42, ptr %i.slot, align 8
  br label %for_cond_264
dead_r43:
  br label %for_end_266
for_end_266:
  ; %t173:i64 = clock_ns None
  ; %t174:i64 = sub_i64 %t173, b3_start
  %r44 = load i64, ptr %t174.slot, align 8
  store i64 %r44, ptr %b3_elapsed.slot, align 8
  ; %t175:str = const_str 94
  ; %t176:BenchmarkResult = call benchmark_create(%t175, b3_iters, b3_elapsed)
  %r45 = load i64, ptr %t176.slot, align 8
  store i64 %r45, ptr %b3.slot, align 8
  ; %t177:i64 = call benchmark_print(b3)
  ; %t178:i64 = call test_summary(runner)
  ; arena_restore %arena_sp_main
  %r46 = load i64, ptr %t178.slot, align 8
  ret i64 %r46
ret_cont_46:
  ret i64 0
}
