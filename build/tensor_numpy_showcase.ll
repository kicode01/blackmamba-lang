; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local double @exp(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca double, align 8
  %t24.slot = alloca double, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca double, align 8
  %t27.slot = alloca double, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca double, align 8
  %t30.slot = alloca double, align 8
  %t31.slot = alloca double, align 8
  %t32.slot = alloca double, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca double, align 8
  %term.slot = alloca double, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %_.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca double, align 8
  %t40.slot = alloca i64, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  ; %t2:bool = cmp_eq_f64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_1, label %fall_2
fall_2:
  store double 1.000000e+00, ptr %t3.slot, align 8
  %r3 = load double, ptr %t3.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  store double 5.000000e+01, ptr %t4.slot, align 8
  ; %t5:f64 = neg_f64 %t4
  ; %t6:bool = cmp_lt_f64 x, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_2, label %fall_6
fall_6:
  store double 0.000000e+00, ptr %t7.slot, align 8
  %r7 = load double, ptr %t7.slot, align 8
  ret double %r7
ret_cont_7:
  br label %if_end_2
dead_r8:
  br label %if_end_2
if_end_2:
  store double 7.000000e+02, ptr %t8.slot, align 8
  ; %t9:bool = cmp_gt_f64 x, %t8
  %r9 = load i64, ptr %t9.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_3, label %fall_10
fall_10:
  store double 1.000000e+300, ptr %t10.slot, align 8
  %r11 = load double, ptr %t10.slot, align 8
  ret double %r11
ret_cont_11:
  br label %if_end_3
dead_r12:
  br label %if_end_3
if_end_3:
  store double 2.560000e+02, ptr %t11.slot, align 8
  ; %t12:f64 = div_f64 x, %t11
  %r13 = load double, ptr %t12.slot, align 8
  store double %r13, ptr %val.slot, align 8
  store double 1.000000e+00, ptr %t13.slot, align 8
  store double 1.000000e+00, ptr %t14.slot, align 8
  store double 5.000000e-01, ptr %t15.slot, align 8
  store double 1.666667e-01, ptr %t18.slot, align 8
  store double 4.166667e-02, ptr %t21.slot, align 8
  store double 8.333333e-03, ptr %t24.slot, align 8
  ; %t25:f64 = mul_f64 val, %t24
  ; %t26:f64 = add_f64 %t21, %t25
  ; %t27:f64 = mul_f64 val, %t26
  ; %t28:f64 = add_f64 %t18, %t27
  ; %t29:f64 = mul_f64 val, %t28
  ; %t30:f64 = add_f64 %t15, %t29
  ; %t31:f64 = mul_f64 val, %t30
  ; %t32:f64 = add_f64 %t14, %t31
  ; %t33:f64 = mul_f64 val, %t32
  ; %t34:f64 = add_f64 %t13, %t33
  %r14 = load double, ptr %t34.slot, align 8
  store double %r14, ptr %term.slot, align 8
  store i64 0, ptr %t35.slot, align 8
  store i64 8, ptr %t36.slot, align 8
  store i64 1, ptr %t37.slot, align 8
  %r15 = load i64, ptr %t35.slot, align 8
  store i64 %r15, ptr %_.slot, align 8
  br label %for_cond_4
for_cond_4:
  ; %t38:bool = cmp_lt_i64 _, %t36
  %r16 = load i64, ptr %t38.slot, align 8
  %r17 = icmp eq i64 %r16, 0
  br i1 %r17, label %for_end_6, label %fall_17
fall_17:
  ; %t39:f64 = mul_f64 term, term
  %r18 = load double, ptr %t39.slot, align 8
  store double %r18, ptr %term.slot, align 8
  br label %for_step_5
for_step_5:
  ; %t40:i64 = add_i64 _, %t37
  %r19 = load i64, ptr %t40.slot, align 8
  store i64 %r19, ptr %_.slot, align 8
  br label %for_cond_4
dead_r20:
  br label %for_end_6
for_end_6:
  %r21 = load double, ptr %term.slot, align 8
  ret double %r21
ret_cont_21:
  ret double 0.0
}

define dso_local i64 @tensor_fill(ptr %arr.arg, i64 %n.arg, double %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %n.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_7
for_cond_7:
  ; %t3:bool = cmp_lt_i64 i, n
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_9, label %fall_3
fall_3:
  ; arr[i] = val  ; f64
  br label %for_step_8
for_step_8:
  ; %t4:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_7
dead_r5:
  br label %for_end_9
for_end_9:
  %r6 = load i64, ptr %n.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @tensor_saxpy(ptr %x.arg, ptr %y.arg, ptr %out.arg, double %a.arg, i64 %n.arg) #0 {
entry:
  %x.slot = alloca ptr, align 8
  %y.slot = alloca ptr, align 8
  %out.slot = alloca ptr, align 8
  %a.slot = alloca double, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  store ptr %x.arg, ptr %x.slot, align 8
  store ptr %y.arg, ptr %y.slot, align 8
  store ptr %out.arg, ptr %out.slot, align 8
  store double %a.arg, ptr %a.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_10
for_cond_10:
  ; %t3:bool = cmp_lt_i64 i, n
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_12, label %fall_3
fall_3:
  ; %t4:f64 = x[i]
  ; %t5:f64 = mul_f64 a, %t4
  ; %t6:f64 = y[i]
  ; %t7:f64 = add_f64 %t5, %t6
  ; out[i] = %t7  ; f64
  br label %for_step_11
for_step_11:
  ; %t8:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t8.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_10
dead_r5:
  br label %for_end_12
for_end_12:
  %r6 = load i64, ptr %n.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local double @tensor_dot(ptr %a.arg, ptr %b.arg, i64 %n.arg) #0 {
entry:
  %a.slot = alloca ptr, align 8
  %b.slot = alloca ptr, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %acc.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca i64, align 8
  store ptr %a.arg, ptr %a.slot, align 8
  store ptr %b.arg, ptr %b.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %acc.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_13
for_cond_13:
  ; %t4:bool = cmp_lt_i64 i, n
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_15, label %fall_4
fall_4:
  ; %t5:f64 = a[i]
  ; %t6:f64 = b[i]
  ; %t7:f64 = mul_f64 %t5, %t6
  ; %t8:f64 = add_f64 acc, %t7
  %r5 = load double, ptr %t8.slot, align 8
  store double %r5, ptr %acc.slot, align 8
  br label %for_step_14
for_step_14:
  ; %t9:i64 = add_i64 i, %t3
  %r6 = load i64, ptr %t9.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_13
dead_r7:
  br label %for_end_15
for_end_15:
  %r8 = load double, ptr %acc.slot, align 8
  ret double %r8
ret_cont_8:
  ret double 0.0
}

define dso_local double @tensor_norm(ptr %arr.arg, i64 %n.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %d.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call tensor_dot(arr, arr, n)
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %d.slot, align 8
  ; %t2:f64 = sqrt_f64 d
  %r2 = load double, ptr %t2.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local i64 @tensor_relu(ptr %x.arg, ptr %out.arg, i64 %n.arg) #0 {
entry:
  %x.slot = alloca ptr, align 8
  %out.slot = alloca ptr, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %v.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  store ptr %x.arg, ptr %x.slot, align 8
  store ptr %out.arg, ptr %out.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_16
for_cond_16:
  ; %t3:bool = cmp_lt_i64 i, n
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_18, label %fall_3
fall_3:
  ; %t4:f64 = x[i]
  %r4 = load double, ptr %t4.slot, align 8
  store double %r4, ptr %v.slot, align 8
  store double 0.000000e+00, ptr %t5.slot, align 8
  ; %t6:bool = cmp_gt_f64 v, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_next_20, label %fall_6
fall_6:
  ; out[i] = v  ; f64
  br label %if_end_19
dead_r7:
  br label %if_next_20
if_next_20:
  store double 0.000000e+00, ptr %t7.slot, align 8
  ; out[i] = %t7  ; f64
  br label %if_end_19
if_end_19:
  br label %for_step_17
for_step_17:
  ; %t8:i64 = add_i64 i, %t2
  %r8 = load i64, ptr %t8.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_16
dead_r9:
  br label %for_end_18
for_end_18:
  %r10 = load i64, ptr %n.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @tensor_sigmoid(ptr %x.arg, ptr %out.arg, i64 %n.arg) #0 {
entry:
  %x.slot = alloca ptr, align 8
  %out.slot = alloca ptr, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %v.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca i64, align 8
  store ptr %x.arg, ptr %x.slot, align 8
  store ptr %out.arg, ptr %out.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_21
for_cond_21:
  ; %t3:bool = cmp_lt_i64 i, n
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_23, label %fall_3
fall_3:
  ; %t4:f64 = x[i]
  %r4 = load double, ptr %t4.slot, align 8
  store double %r4, ptr %v.slot, align 8
  store double 4.000000e+01, ptr %t5.slot, align 8
  ; %t6:bool = cmp_ge_f64 v, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_next_25, label %fall_6
fall_6:
  store double 1.000000e+00, ptr %t7.slot, align 8
  ; out[i] = %t7  ; f64
  br label %if_end_24
dead_r7:
  br label %if_next_25
if_next_25:
  store double 4.000000e+01, ptr %t8.slot, align 8
  ; %t9:f64 = neg_f64 %t8
  ; %t10:bool = cmp_le_f64 v, %t9
  %r8 = load i64, ptr %t10.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_elif_26, label %fall_9
fall_9:
  store double 0.000000e+00, ptr %t11.slot, align 8
  ; out[i] = %t11  ; f64
  br label %if_end_24
dead_r10:
  br label %if_elif_26
if_elif_26:
  store double 1.000000e+00, ptr %t12.slot, align 8
  store double 1.000000e+00, ptr %t13.slot, align 8
  store double 0.000000e+00, ptr %t14.slot, align 8
  ; %t15:f64 = sub_f64 %t14, v
  ; %t16:f64 = call exp(%t15)
  ; %t17:f64 = add_f64 %t13, %t16
  ; %t18:f64 = div_f64 %t12, %t17
  ; out[i] = %t18  ; f64
  br label %if_end_24
if_end_24:
  br label %for_step_22
for_step_22:
  ; %t19:i64 = add_i64 i, %t2
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %i.slot, align 8
  br label %for_cond_21
dead_r12:
  br label %for_end_23
for_end_23:
  %r13 = load i64, ptr %n.slot, align 8
  ret i64 %r13
ret_cont_13:
  ret i64 0
}

define dso_local i64 @tensor_matmul(ptr %A.arg, ptr %B.arg, ptr %C.arg, i64 %M.arg, i64 %K.arg, i64 %N.arg) #0 {
entry:
  %A.slot = alloca ptr, align 8
  %B.slot = alloca ptr, align 8
  %C.slot = alloca ptr, align 8
  %M.slot = alloca i64, align 8
  %K.slot = alloca i64, align 8
  %N.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %row_a.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %row_c.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %acc.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %k.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  store ptr %A.arg, ptr %A.slot, align 8
  store ptr %B.arg, ptr %B.slot, align 8
  store ptr %C.arg, ptr %C.slot, align 8
  store i64 %M.arg, ptr %M.slot, align 8
  store i64 %K.arg, ptr %K.slot, align 8
  store i64 %N.arg, ptr %N.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_27
for_cond_27:
  ; %t3:bool = cmp_lt_i64 i, M
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_29, label %fall_3
fall_3:
  ; %t4:i64 = mul_i64 i, K
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %row_a.slot, align 8
  ; %t5:i64 = mul_i64 i, N
  %r5 = load i64, ptr %t5.slot, align 8
  store i64 %r5, ptr %row_c.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  %r6 = load i64, ptr %t6.slot, align 8
  store i64 %r6, ptr %j.slot, align 8
  br label %for_cond_30
for_cond_30:
  ; %t8:bool = cmp_lt_i64 j, N
  %r7 = load i64, ptr %t8.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_32, label %fall_8
fall_8:
  store double 0.000000e+00, ptr %t9.slot, align 8
  %r9 = load double, ptr %t9.slot, align 8
  store double %r9, ptr %acc.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  %r10 = load i64, ptr %t10.slot, align 8
  store i64 %r10, ptr %k.slot, align 8
  br label %for_cond_33
for_cond_33:
  ; %t12:bool = cmp_lt_i64 k, K
  %r11 = load i64, ptr %t12.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %for_end_35, label %fall_12
fall_12:
  ; %t13:i64 = add_i64 row_a, k
  ; %t14:f64 = A[%t13]
  ; %t15:i64 = mul_i64 k, N
  ; %t16:i64 = add_i64 %t15, j
  ; %t17:f64 = B[%t16]
  ; %t18:f64 = mul_f64 %t14, %t17
  ; %t19:f64 = add_f64 acc, %t18
  %r13 = load double, ptr %t19.slot, align 8
  store double %r13, ptr %acc.slot, align 8
  br label %for_step_34
for_step_34:
  ; %t20:i64 = add_i64 k, %t11
  %r14 = load i64, ptr %t20.slot, align 8
  store i64 %r14, ptr %k.slot, align 8
  br label %for_cond_33
dead_r15:
  br label %for_end_35
for_end_35:
  ; %t21:i64 = add_i64 row_c, j
  ; C[%t21] = acc  ; f64
  br label %for_step_31
for_step_31:
  ; %t22:i64 = add_i64 j, %t7
  %r16 = load i64, ptr %t22.slot, align 8
  store i64 %r16, ptr %j.slot, align 8
  br label %for_cond_30
dead_r17:
  br label %for_end_32
for_end_32:
  br label %for_step_28
for_step_28:
  ; %t23:i64 = add_i64 i, %t2
  %r18 = load i64, ptr %t23.slot, align 8
  store i64 %r18, ptr %i.slot, align 8
  br label %for_cond_27
dead_r19:
  br label %for_end_29
for_end_29:
  ; %t24:i64 = mul_i64 M, N
  %r20 = load i64, ptr %t24.slot, align 8
  ret i64 %r20
ret_cont_20:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca double, align 8
  %x.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca double, align 8
  %y.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca double, align 8
  %out.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca double, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca double, align 8
  %dot_val.slot = alloca double, align 8
  %t26.slot = alloca double, align 8
  %norm_val.slot = alloca double, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca double, align 8
  %t32.slot = alloca double, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca double, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca double, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca double, align 8
  %t39.slot = alloca i64, align 8
  %A.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca double, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca double, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca double, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca double, align 8
  %t50.slot = alloca i64, align 8
  %B.slot = alloca ptr, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca double, align 8
  %t54.slot = alloca double, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca double, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca double, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca double, align 8
  %t61.slot = alloca i64, align 8
  %C.slot = alloca ptr, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca double, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca double, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca double, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca double, align 8
  %t75.slot = alloca ptr, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca double, align 8
  %t78.slot = alloca double, align 8
  %t79.slot = alloca double, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca double, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca double, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca double, align 8
  %t86.slot = alloca i64, align 8
  %acts_in.slot = alloca ptr, align 8
  %t87.slot = alloca ptr, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca double, align 8
  %relu_out.slot = alloca ptr, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca ptr, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca double, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca double, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca double, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca double, align 8
  %t101.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 0
  ; print(%t1:str)
  store i64 5, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %n.slot, align 8
  store double 1.000000e+00, ptr %t4.slot, align 8
  ; %t3:Array[f64] = alloc_array(n, init=%t4)
  %r2 = load ptr, ptr %t3.slot, align 8
  store ptr %r2, ptr %x.slot, align 8
  store double 2.000000e+00, ptr %t6.slot, align 8
  ; %t5:Array[f64] = alloc_array(n, init=%t6)
  %r3 = load ptr, ptr %t5.slot, align 8
  store ptr %r3, ptr %y.slot, align 8
  store double 0.000000e+00, ptr %t8.slot, align 8
  ; %t7:Array[f64] = alloc_array(n, init=%t8)
  %r4 = load ptr, ptr %t7.slot, align 8
  store ptr %r4, ptr %out.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %i.slot, align 8
  br label %for_cond_36
for_cond_36:
  ; %t11:bool = cmp_lt_i64 i, n
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %for_end_38, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = add_i64 i, %t12
  ; %t14:f64 = i64_to_f64 %t13
  ; x[i] = %t14  ; f64
  store double 1.000000e+01, ptr %t15.slot, align 8
  ; y[i] = %t15  ; f64
  br label %for_step_37
for_step_37:
  ; %t16:i64 = add_i64 i, %t10
  %r8 = load i64, ptr %t16.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_36
dead_r9:
  br label %for_end_38
for_end_38:
  store double 3.000000e+00, ptr %t17.slot, align 8
  ; %t18:i64 = call tensor_saxpy(x, y, out, %t17, n)
  ; %t19:str = const_str 1
  ; print(%t19:str)
  store i64 0, ptr %t20.slot, align 8
  store i64 1, ptr %t21.slot, align 8
  %r10 = load i64, ptr %t20.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_39
for_cond_39:
  ; %t22:bool = cmp_lt_i64 i, n
  %r11 = load i64, ptr %t22.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %for_end_41, label %fall_12
fall_12:
  ; %t23:f64 = out[i]
  ; print(%t23:f64)
  br label %for_step_40
for_step_40:
  ; %t24:i64 = add_i64 i, %t21
  %r13 = load i64, ptr %t24.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %for_cond_39
dead_r14:
  br label %for_end_41
for_end_41:
  ; %t25:f64 = call tensor_dot(out, out, n)
  %r15 = load double, ptr %t25.slot, align 8
  store double %r15, ptr %dot_val.slot, align 8
  ; %t26:f64 = call tensor_norm(out, n)
  %r16 = load double, ptr %t26.slot, align 8
  store double %r16, ptr %norm_val.slot, align 8
  ; %t27:str = const_str 2
  ; print(%t27:str)
  ; print(dot_val:f64)
  ; %t28:str = const_str 3
  ; print(%t28:str)
  ; print(norm_val:f64)
  store i64 4, ptr %t30.slot, align 8
  store double 0.000000e+00, ptr %t31.slot, align 8
  ; %t29:Array[f64] = alloc_array(%t30, init=%t31)
  store double 1.000000e+00, ptr %t32.slot, align 8
  store i64 0, ptr %t33.slot, align 8
  ; %t29[%t33] = %t32  ; f64
  store double 2.000000e+00, ptr %t34.slot, align 8
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = %t34  ; f64
  store double 3.000000e+00, ptr %t36.slot, align 8
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; f64
  store double 4.000000e+00, ptr %t38.slot, align 8
  store i64 3, ptr %t39.slot, align 8
  ; %t29[%t39] = %t38  ; f64
  %r17 = load ptr, ptr %t29.slot, align 8
  store ptr %r17, ptr %A.slot, align 8
  store i64 4, ptr %t41.slot, align 8
  store double 0.000000e+00, ptr %t42.slot, align 8
  ; %t40:Array[f64] = alloc_array(%t41, init=%t42)
  store double 5.000000e+00, ptr %t43.slot, align 8
  store i64 0, ptr %t44.slot, align 8
  ; %t40[%t44] = %t43  ; f64
  store double 6.000000e+00, ptr %t45.slot, align 8
  store i64 1, ptr %t46.slot, align 8
  ; %t40[%t46] = %t45  ; f64
  store double 7.000000e+00, ptr %t47.slot, align 8
  store i64 2, ptr %t48.slot, align 8
  ; %t40[%t48] = %t47  ; f64
  store double 8.000000e+00, ptr %t49.slot, align 8
  store i64 3, ptr %t50.slot, align 8
  ; %t40[%t50] = %t49  ; f64
  %r18 = load ptr, ptr %t40.slot, align 8
  store ptr %r18, ptr %B.slot, align 8
  store i64 4, ptr %t52.slot, align 8
  store double 0.000000e+00, ptr %t53.slot, align 8
  ; %t51:Array[f64] = alloc_array(%t52, init=%t53)
  store double 0.000000e+00, ptr %t54.slot, align 8
  store i64 0, ptr %t55.slot, align 8
  ; %t51[%t55] = %t54  ; f64
  store double 0.000000e+00, ptr %t56.slot, align 8
  store i64 1, ptr %t57.slot, align 8
  ; %t51[%t57] = %t56  ; f64
  store double 0.000000e+00, ptr %t58.slot, align 8
  store i64 2, ptr %t59.slot, align 8
  ; %t51[%t59] = %t58  ; f64
  store double 0.000000e+00, ptr %t60.slot, align 8
  store i64 3, ptr %t61.slot, align 8
  ; %t51[%t61] = %t60  ; f64
  %r19 = load ptr, ptr %t51.slot, align 8
  store ptr %r19, ptr %C.slot, align 8
  store i64 2, ptr %t62.slot, align 8
  store i64 2, ptr %t63.slot, align 8
  store i64 2, ptr %t64.slot, align 8
  ; %t65:i64 = call tensor_matmul(A, B, C, %t62, %t63, %t64)
  ; %t66:str = const_str 4
  ; print(%t66:str)
  store i64 0, ptr %t67.slot, align 8
  ; %t68:f64 = C[%t67]
  ; print(%t68:f64)
  store i64 1, ptr %t69.slot, align 8
  ; %t70:f64 = C[%t69]
  ; print(%t70:f64)
  store i64 2, ptr %t71.slot, align 8
  ; %t72:f64 = C[%t71]
  ; print(%t72:f64)
  store i64 3, ptr %t73.slot, align 8
  ; %t74:f64 = C[%t73]
  ; print(%t74:f64)
  store i64 4, ptr %t76.slot, align 8
  store double 0.000000e+00, ptr %t77.slot, align 8
  ; %t75:Array[f64] = alloc_array(%t76, init=%t77)
  store double 2.000000e+00, ptr %t78.slot, align 8
  ; %t79:f64 = neg_f64 %t78
  store i64 0, ptr %t80.slot, align 8
  ; %t75[%t80] = %t79  ; f64
  store double 0.000000e+00, ptr %t81.slot, align 8
  store i64 1, ptr %t82.slot, align 8
  ; %t75[%t82] = %t81  ; f64
  store double 1.500000e+00, ptr %t83.slot, align 8
  store i64 2, ptr %t84.slot, align 8
  ; %t75[%t84] = %t83  ; f64
  store double 4.000000e+00, ptr %t85.slot, align 8
  store i64 3, ptr %t86.slot, align 8
  ; %t75[%t86] = %t85  ; f64
  %r20 = load ptr, ptr %t75.slot, align 8
  store ptr %r20, ptr %acts_in.slot, align 8
  store i64 4, ptr %t88.slot, align 8
  store double 0.000000e+00, ptr %t89.slot, align 8
  ; %t87:Array[f64] = alloc_array(%t88, init=%t89)
  %r21 = load ptr, ptr %t87.slot, align 8
  store ptr %r21, ptr %relu_out.slot, align 8
  store i64 4, ptr %t90.slot, align 8
  ; %t91:i64 = call tensor_relu(acts_in, relu_out, %t90)
  ; %t92:str = const_str 5
  ; print(%t92:str)
  store i64 0, ptr %t93.slot, align 8
  ; %t94:f64 = relu_out[%t93]
  ; print(%t94:f64)
  store i64 1, ptr %t95.slot, align 8
  ; %t96:f64 = relu_out[%t95]
  ; print(%t96:f64)
  store i64 2, ptr %t97.slot, align 8
  ; %t98:f64 = relu_out[%t97]
  ; print(%t98:f64)
  store i64 3, ptr %t99.slot, align 8
  ; %t100:f64 = relu_out[%t99]
  ; print(%t100:f64)
  store i64 0, ptr %t101.slot, align 8
  ; arena_restore %arena_sp_main
  %r22 = load i64, ptr %t101.slot, align 8
  ret i64 %r22
ret_cont_22:
  ret i64 0
}

define dso_local i64 @__bmb_main__() #0 {
entry:
  %t1.slot = alloca double, align 8
  %PI.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %TAU.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %E.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 3.141593e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %PI.slot, align 8
  store double 6.283185e+00, ptr %t2.slot, align 8
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %TAU.slot, align 8
  store double 2.718282e+00, ptr %t3.slot, align 8
  %r3 = load double, ptr %t3.slot, align 8
  store double %r3, ptr %E.slot, align 8
  ; %t4:void = call main()
  store i64 0, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}
