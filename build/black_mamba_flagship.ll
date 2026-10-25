; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local double @Vec3__norm_sq(i64 %self.arg) #0 {
entry:
  %self.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  store i64 %self.arg, ptr %self.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:f64 = self[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:f64 = self[%t3]
  ; %t5:f64 = mul_f64 %t2, %t4
  store i64 1, ptr %t6.slot, align 8
  ; %t7:f64 = self[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:f64 = self[%t8]
  ; %t10:f64 = mul_f64 %t7, %t9
  ; %t11:f64 = add_f64 %t5, %t10
  store i64 2, ptr %t12.slot, align 8
  ; %t13:f64 = self[%t12]
  store i64 2, ptr %t14.slot, align 8
  ; %t15:f64 = self[%t14]
  ; %t16:f64 = mul_f64 %t13, %t15
  ; %t17:f64 = add_f64 %t11, %t16
  %r1 = load double, ptr %t17.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @distance_3d(i64 %v1.arg, i64 %v2.arg) #0 {
entry:
  %v1.slot = alloca i64, align 8
  %v2.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %dx.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %dy.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %dz.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca double, align 8
  store i64 %v1.arg, ptr %v1.slot, align 8
  store i64 %v2.arg, ptr %v2.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:f64 = v1[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:f64 = v2[%t3]
  ; %t5:f64 = sub_f64 %t2, %t4
  %r1 = load double, ptr %t5.slot, align 8
  store double %r1, ptr %dx.slot, align 8
  store i64 1, ptr %t6.slot, align 8
  ; %t7:f64 = v1[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:f64 = v2[%t8]
  ; %t10:f64 = sub_f64 %t7, %t9
  %r2 = load double, ptr %t10.slot, align 8
  store double %r2, ptr %dy.slot, align 8
  store i64 2, ptr %t11.slot, align 8
  ; %t12:f64 = v1[%t11]
  store i64 2, ptr %t13.slot, align 8
  ; %t14:f64 = v2[%t13]
  ; %t15:f64 = sub_f64 %t12, %t14
  %r3 = load double, ptr %t15.slot, align 8
  store double %r3, ptr %dz.slot, align 8
  ; %t16:f64 = mul_f64 dx, dx
  ; %t17:f64 = mul_f64 dy, dy
  ; %t18:f64 = add_f64 %t16, %t17
  ; %t19:f64 = mul_f64 dz, dz
  ; %t20:f64 = add_f64 %t18, %t19
  ; %t21:f64 = sqrt_f64 %t20
  %r4 = load double, ptr %t21.slot, align 8
  ret double %r4
ret_cont_4:
  ret double 0.0
}

define dso_local i64 @is_prime(i64 %n.arg) #0 {
entry:
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %d.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
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
  store i64 0, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  store i64 2, ptr %t4.slot, align 8
  %r5 = load i64, ptr %t4.slot, align 8
  store i64 %r5, ptr %d.slot, align 8
  br label %while_cond_2
while_cond_2:
  ; %t5:i64 = mul_i64 d, d
  ; %t6:bool = cmp_le_i64 %t5, n
  %r6 = load i64, ptr %t6.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %while_end_3, label %fall_7
fall_7:
  ; %t7:i64 = mod_i64 n, d
  store i64 0, ptr %t8.slot, align 8
  ; %t9:bool = cmp_eq_i64 %t7, %t8
  %r8 = load i64, ptr %t9.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_4, label %fall_9
fall_9:
  store i64 0, ptr %t10.slot, align 8
  %r10 = load i64, ptr %t10.slot, align 8
  ret i64 %r10
ret_cont_10:
  br label %if_end_4
dead_r11:
  br label %if_end_4
if_end_4:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = add_i64 d, %t11
  %r12 = load i64, ptr %t12.slot, align 8
  store i64 %r12, ptr %d.slot, align 8
  br label %while_cond_2
dead_r13:
  br label %while_end_3
while_end_3:
  store i64 1, ptr %t13.slot, align 8
  %r14 = load i64, ptr %t13.slot, align 8
  ret i64 %r14
ret_cont_14:
  ret i64 0
}

define dso_local i64 @count_primes_in_range(i64 %low.arg, i64 %high.arg) #0 {
entry:
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %count.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r2 = load i64, ptr %low.slot, align 8
  store i64 %r2, ptr %n.slot, align 8
  br label %for_cond_5
for_cond_5:
  ; %t3:bool = cmp_le_i64 n, high
  %r3 = load i64, ptr %t3.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_7, label %fall_4
fall_4:
  ; %t4:bool = call is_prime(n)
  %r5 = load i64, ptr %t4.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_8, label %fall_6
fall_6:
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = add_i64 count, %t5
  %r7 = load i64, ptr %t6.slot, align 8
  store i64 %r7, ptr %count.slot, align 8
  br label %if_end_8
dead_r8:
  br label %if_end_8
if_end_8:
  br label %for_step_6
for_step_6:
  ; %t7:i64 = add_i64 n, %t2
  %r9 = load i64, ptr %t7.slot, align 8
  store i64 %r9, ptr %n.slot, align 8
  br label %for_cond_5
dead_r10:
  br label %for_end_7
for_end_7:
  %r11 = load i64, ptr %count.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @step_double(i64 %x.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = mul_i64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @step_add_const(i64 %x.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 42, ptr %t1.slot, align 8
  ; %t2:i64 = add_i64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @step_square(i64 %x.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  store i64 %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = mul_i64 x, x
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local ptr @evaluate_status_code(i64 %code.arg) #0 {
entry:
  %code.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  store i64 %code.arg, ptr %code.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 200, ptr %t1.slot, align 8
  ; %t2:bool = cmp_eq_i64 code, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %match_case_0_10, label %fall_2
fall_2:
  ; %t3:str = const_str 0
  %r3 = load ptr, ptr %t3.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %match_end_9
dead_r4:
  br label %match_case_0_10
match_case_0_10:
  store i64 201, ptr %t4.slot, align 8
  ; %t5:bool = cmp_eq_i64 code, %t4
  %r5 = load i64, ptr %t5.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %match_case_1_11, label %fall_6
fall_6:
  ; %t6:str = const_str 1
  %r7 = load ptr, ptr %t6.slot, align 8
  ret ptr %r7
ret_cont_7:
  br label %match_end_9
dead_r8:
  br label %match_case_1_11
match_case_1_11:
  store i64 404, ptr %t7.slot, align 8
  ; %t8:bool = cmp_eq_i64 code, %t7
  %r9 = load i64, ptr %t8.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %match_case_2_12, label %fall_10
fall_10:
  ; %t9:str = const_str 2
  %r11 = load ptr, ptr %t9.slot, align 8
  ret ptr %r11
ret_cont_11:
  br label %match_end_9
dead_r12:
  br label %match_case_2_12
match_case_2_12:
  ; %t10:str = const_str 3
  %r13 = load ptr, ptr %t10.slot, align 8
  ret ptr %r13
ret_cont_13:
  br label %match_end_9
dead_r14:
  br label %match_case_3_13
match_case_3_13:
  br label %match_end_9
match_end_9:
  store i64 0, ptr %t11.slot, align 8
  %r15 = load ptr, ptr %t11.slot, align 8
  ret ptr %r15
ret_cont_15:
  ret ptr 0
}

define dso_local i64 @tail_accumulator(i64 %n.arg, i64 %acc.arg) #0 {
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
  br i1 %r2, label %if_end_14, label %fall_2
fall_2:
  %r3 = load i64, ptr %acc.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_14
dead_r4:
  br label %if_end_14
if_end_14:
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
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca i64, align 8
  %p1.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca i64, align 8
  %p2.slot = alloca i64, align 8
  %t22.slot = alloca double, align 8
  %dist.slot = alloca double, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %prime_limit.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %primes_found.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %pipe_val.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca ptr, align 8
  %status.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %tco_sum.slot = alloca i64, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 4
  ; print(%t1:str)
  ; %t2:str = const_str 5
  ; print(%t2:str)
  ; %t3:str = const_str 4
  ; print(%t3:str)
  store i64 3, ptr %t5.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t4:Vec3 = alloc_array(%t5, init=%t6)
  store double 0.000000e+00, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t4[%t8] = %t7  ; f64
  store double 3.000000e+00, ptr %t9.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  ; %t4[%t10] = %t9  ; f64
  store double 4.000000e+00, ptr %t11.slot, align 8
  store i64 2, ptr %t12.slot, align 8
  ; %t4[%t12] = %t11  ; f64
  %r1 = load i64, ptr %t4.slot, align 8
  store i64 %r1, ptr %p1.slot, align 8
  store i64 3, ptr %t14.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t13:Vec3 = alloc_array(%t14, init=%t15)
  store double 3.000000e+00, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t13[%t17] = %t16  ; f64
  store double 7.000000e+00, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t13[%t19] = %t18  ; f64
  store double 4.000000e+00, ptr %t20.slot, align 8
  store i64 2, ptr %t21.slot, align 8
  ; %t13[%t21] = %t20  ; f64
  %r2 = load i64, ptr %t13.slot, align 8
  store i64 %r2, ptr %p2.slot, align 8
  ; %t22:f64 = call distance_3d(p1, p2)
  %r3 = load double, ptr %t22.slot, align 8
  store double %r3, ptr %dist.slot, align 8
  ; %t23:str = const_str 6
  ; print(%t23:str, dist:f64)
  store i64 10000, ptr %t24.slot, align 8
  %r4 = load i64, ptr %t24.slot, align 8
  store i64 %r4, ptr %prime_limit.slot, align 8
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = call count_primes_in_range(%t25, prime_limit)
  %r5 = load i64, ptr %t26.slot, align 8
  store i64 %r5, ptr %primes_found.slot, align 8
  ; %t27:str = const_str 7
  ; %t28:str = const_str 8
  ; print(%t27:str, prime_limit:i64, %t28:str, primes_found:i64)
  store i64 7, ptr %t29.slot, align 8
  ; %t30:i64 = call step_double(%t29)
  ; %t31:i64 = call step_add_const(%t30)
  ; %t32:i64 = call step_square(%t31)
  %r6 = load i64, ptr %t32.slot, align 8
  store i64 %r6, ptr %pipe_val.slot, align 8
  ; %t33:str = const_str 9
  ; print(%t33:str, pipe_val:i64)
  store i64 200, ptr %t34.slot, align 8
  ; %t35:str = call evaluate_status_code(%t34)
  %r7 = load ptr, ptr %t35.slot, align 8
  store ptr %r7, ptr %status.slot, align 8
  ; %t36:str = const_str 10
  ; print(%t36:str, status:str)
  store i64 1000000, ptr %t37.slot, align 8
  store i64 0, ptr %t38.slot, align 8
  ; %t39:i64 = call tail_accumulator(%t37, %t38)
  %r8 = load i64, ptr %t39.slot, align 8
  store i64 %r8, ptr %tco_sum.slot, align 8
  ; %t40:str = const_str 11
  ; print(%t40:str, tco_sum:i64)
  ; %t41:str = const_str 4
  ; print(%t41:str)
  ; %t42:str = const_str 12
  ; print(%t42:str)
  ; %t43:str = const_str 4
  ; print(%t43:str)
  store i64 0, ptr %t44.slot, align 8
  ; arena_restore %arena_sp_main
  %r9 = load i64, ptr %t44.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}
