; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local double @deg_to_rad(double %deg.arg) #0 {
entry:
  %deg.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  store double %deg.arg, ptr %deg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.745329e-02, ptr %t3.slot, align 8
  ; %t4:f64 = mul_f64 deg, %t3
  %r1 = load double, ptr %t4.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @rad_to_deg(double %rad.arg) #0 {
entry:
  %rad.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  store double %rad.arg, ptr %rad.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 5.729578e+01, ptr %t3.slot, align 8
  ; %t4:f64 = mul_f64 rad, %t3
  %r1 = load double, ptr %t4.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @degrees(double %rad.arg) #0 {
entry:
  %rad.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  store double %rad.arg, ptr %rad.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call rad_to_deg(rad)
  %r1 = load double, ptr %t1.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @radians(double %deg.arg) #0 {
entry:
  %deg.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  store double %deg.arg, ptr %deg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call deg_to_rad(deg)
  %r1 = load double, ptr %t1.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @clamp(double %val.arg, double %low.arg, double %high.arg) #0 {
entry:
  %val.slot = alloca double, align 8
  %low.slot = alloca double, align 8
  %high.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store double %val.arg, ptr %val.slot, align 8
  store double %low.arg, ptr %low.slot, align 8
  store double %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_lt_f64 val, low
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_1, label %fall_2
fall_2:
  %r3 = load double, ptr %low.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  ; %t2:bool = cmp_gt_f64 val, high
  %r5 = load i64, ptr %t2.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_2, label %fall_6
fall_6:
  %r7 = load double, ptr %high.slot, align 8
  ret double %r7
ret_cont_7:
  br label %if_end_2
dead_r8:
  br label %if_end_2
if_end_2:
  %r9 = load double, ptr %val.slot, align 8
  ret double %r9
ret_cont_9:
  ret double 0.0
}

define dso_local double @lerp(double %a.arg, double %b.arg, double %t.arg) #0 {
entry:
  %a.slot = alloca double, align 8
  %b.slot = alloca double, align 8
  %t.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  store double %a.arg, ptr %a.slot, align 8
  store double %b.arg, ptr %b.slot, align 8
  store double %t.arg, ptr %t.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = sub_f64 b, a
  ; %t2:f64 = mul_f64 %t1, t
  ; %t3:f64 = add_f64 a, %t2
  %r1 = load double, ptr %t3.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @hypot(double %x.arg, double %y.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %y.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  store double %y.arg, ptr %y.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = mul_f64 x, x
  ; %t2:f64 = mul_f64 y, y
  ; %t3:f64 = add_f64 %t1, %t2
  ; %t4:f64 = sqrt_f64 %t3
  %r1 = load double, ptr %t4.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @sign(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  ; %t2:bool = cmp_gt_f64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_3, label %fall_2
fall_2:
  store double 1.000000e+00, ptr %t3.slot, align 8
  %r3 = load double, ptr %t3.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_3
dead_r4:
  br label %if_end_3
if_end_3:
  store double 0.000000e+00, ptr %t4.slot, align 8
  ; %t5:bool = cmp_lt_f64 x, %t4
  %r5 = load i64, ptr %t5.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_4, label %fall_6
fall_6:
  store double 1.000000e+00, ptr %t6.slot, align 8
  ; %t7:f64 = neg_f64 %t6
  %r7 = load double, ptr %t7.slot, align 8
  ret double %r7
ret_cont_7:
  br label %if_end_4
dead_r8:
  br label %if_end_4
if_end_4:
  store double 0.000000e+00, ptr %t8.slot, align 8
  %r9 = load double, ptr %t8.slot, align 8
  ret double %r9
ret_cont_9:
  ret double 0.0
}

define dso_local double @floor(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %fi.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = f64_to_i64 x
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  ; %t2:f64 = i64_to_f64 i
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %fi.slot, align 8
  store double 0.000000e+00, ptr %t3.slot, align 8
  ; %t4:bool = cmp_lt_f64 x, %t3
  ; %t5:bool = cmp_ne_f64 x, fi
  ; %t6:bool = and_i64 %t4, %t5
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_5, label %fall_4
fall_4:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = sub_i64 i, %t7
  ; %t9:f64 = i64_to_f64 %t8
  %r5 = load double, ptr %t9.slot, align 8
  ret double %r5
ret_cont_5:
  br label %if_end_5
dead_r6:
  br label %if_end_5
if_end_5:
  %r7 = load double, ptr %fi.slot, align 8
  ret double %r7
ret_cont_7:
  ret double 0.0
}

define dso_local double @ceil(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %fi.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = f64_to_i64 x
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  ; %t2:f64 = i64_to_f64 i
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %fi.slot, align 8
  store double 0.000000e+00, ptr %t3.slot, align 8
  ; %t4:bool = cmp_gt_f64 x, %t3
  ; %t5:bool = cmp_ne_f64 x, fi
  ; %t6:bool = and_i64 %t4, %t5
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_6, label %fall_4
fall_4:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = add_i64 i, %t7
  ; %t9:f64 = i64_to_f64 %t8
  %r5 = load double, ptr %t9.slot, align 8
  ret double %r5
ret_cont_5:
  br label %if_end_6
dead_r6:
  br label %if_end_6
if_end_6:
  %r7 = load double, ptr %fi.slot, align 8
  ret double %r7
ret_cont_7:
  ret double 0.0
}

define dso_local double @trunc(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = f64_to_i64 x
  ; %t2:f64 = i64_to_f64 %t1
  %r1 = load double, ptr %t2.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @sin(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %tau.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %pi.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %k.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %r.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %r2.slot = alloca double, align 8
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
  %t35.slot = alloca double, align 8
  %t36.slot = alloca double, align 8
  %t37.slot = alloca double, align 8
  %t38.slot = alloca double, align 8
  %t39.slot = alloca double, align 8
  %t40.slot = alloca double, align 8
  %t41.slot = alloca double, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca double, align 8
  %t44.slot = alloca double, align 8
  %t45.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 6.283185e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %tau.slot, align 8
  store double 3.141593e+00, ptr %t2.slot, align 8
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %pi.slot, align 8
  ; %t3:f64 = div_f64 x, tau
  ; %t4:i64 = f64_to_i64 %t3
  %r3 = load i64, ptr %t4.slot, align 8
  store i64 %r3, ptr %k.slot, align 8
  ; %t5:f64 = i64_to_f64 k
  ; %t6:f64 = mul_f64 %t5, tau
  ; %t7:f64 = sub_f64 x, %t6
  %r4 = load double, ptr %t7.slot, align 8
  store double %r4, ptr %r.slot, align 8
  ; %t8:bool = cmp_gt_f64 r, pi
  %r5 = load i64, ptr %t8.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_next_8, label %fall_6
fall_6:
  ; %t9:f64 = sub_f64 r, tau
  %r7 = load double, ptr %t9.slot, align 8
  store double %r7, ptr %r.slot, align 8
  br label %if_end_7
dead_r8:
  br label %if_next_8
if_next_8:
  ; %t10:f64 = neg_f64 pi
  ; %t11:bool = cmp_lt_f64 r, %t10
  %r9 = load i64, ptr %t11.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_7, label %fall_10
fall_10:
  ; %t12:f64 = add_f64 r, tau
  %r11 = load double, ptr %t12.slot, align 8
  store double %r11, ptr %r.slot, align 8
  br label %if_end_7
dead_r12:
  br label %if_end_7
if_end_7:
  ; %t13:f64 = mul_f64 r, r
  %r13 = load double, ptr %t13.slot, align 8
  store double %r13, ptr %r2.slot, align 8
  store double 1.000000e+00, ptr %t14.slot, align 8
  store double 1.666667e-01, ptr %t17.slot, align 8
  store double 8.333333e-03, ptr %t20.slot, align 8
  store double 1.984127e-04, ptr %t23.slot, align 8
  store double 2.755732e-06, ptr %t26.slot, align 8
  store double 2.505211e-08, ptr %t29.slot, align 8
  store double 1.605904e-10, ptr %t32.slot, align 8
  ; %t33:f64 = mul_f64 r2, %t32
  ; %t34:f64 = sub_f64 %t29, %t33
  ; %t35:f64 = mul_f64 r2, %t34
  ; %t36:f64 = sub_f64 %t26, %t35
  ; %t37:f64 = mul_f64 r2, %t36
  ; %t38:f64 = sub_f64 %t23, %t37
  ; %t39:f64 = mul_f64 r2, %t38
  ; %t40:f64 = sub_f64 %t20, %t39
  ; %t41:f64 = mul_f64 r2, %t40
  ; %t42:f64 = sub_f64 %t17, %t41
  ; %t43:f64 = mul_f64 r2, %t42
  ; %t44:f64 = sub_f64 %t14, %t43
  ; %t45:f64 = mul_f64 r, %t44
  %r14 = load double, ptr %t45.slot, align 8
  ret double %r14
ret_cont_14:
  ret double 0.0
}

define dso_local double @cos(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %half_pi.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.570796e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %half_pi.slot, align 8
  ; %t2:f64 = add_f64 x, half_pi
  ; %t3:f64 = call sin(%t2)
  %r2 = load double, ptr %t3.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local double @tan(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %c.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call cos(x)
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %c.slot, align 8
  ; %t2:f64 = abs_f64 c
  store double 1.000000e-15, ptr %t3.slot, align 8
  ; %t4:bool = cmp_lt_f64 %t2, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_9, label %fall_3
fall_3:
  store double 1.000000e+15, ptr %t5.slot, align 8
  %r4 = load double, ptr %t5.slot, align 8
  ret double %r4
ret_cont_4:
  br label %if_end_9
dead_r5:
  br label %if_end_9
if_end_9:
  ; %t6:f64 = call sin(x)
  ; %t7:f64 = div_f64 %t6, c
  %r6 = load double, ptr %t7.slot, align 8
  ret double %r6
ret_cont_6:
  ret double 0.0
}

define dso_local double @atan(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %half_pi.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %sign_val.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %invert.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca double, align 8
  %v2.slot = alloca double, align 8
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
  %res.slot = alloca double, align 8
  %t32.slot = alloca double, align 8
  %t33.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.570796e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %half_pi.slot, align 8
  store double 1.000000e+00, ptr %t2.slot, align 8
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %sign_val.slot, align 8
  %r3 = load double, ptr %x.slot, align 8
  store double %r3, ptr %val.slot, align 8
  store double 0.000000e+00, ptr %t3.slot, align 8
  ; %t4:bool = cmp_lt_f64 val, %t3
  %r4 = load i64, ptr %t4.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_10, label %fall_5
fall_5:
  store double 1.000000e+00, ptr %t5.slot, align 8
  ; %t6:f64 = neg_f64 %t5
  %r6 = load double, ptr %t6.slot, align 8
  store double %r6, ptr %sign_val.slot, align 8
  ; %t7:f64 = neg_f64 val
  %r7 = load double, ptr %t7.slot, align 8
  store double %r7, ptr %val.slot, align 8
  br label %if_end_10
dead_r8:
  br label %if_end_10
if_end_10:
  store i64 0, ptr %t8.slot, align 8
  %r9 = load i64, ptr %t8.slot, align 8
  store i64 %r9, ptr %invert.slot, align 8
  store double 1.000000e+00, ptr %t9.slot, align 8
  ; %t10:bool = cmp_gt_f64 val, %t9
  %r10 = load i64, ptr %t10.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_11, label %fall_11
fall_11:
  store double 1.000000e+00, ptr %t11.slot, align 8
  ; %t12:f64 = div_f64 %t11, val
  %r12 = load double, ptr %t12.slot, align 8
  store double %r12, ptr %val.slot, align 8
  store i64 1, ptr %t13.slot, align 8
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %invert.slot, align 8
  br label %if_end_11
dead_r14:
  br label %if_end_11
if_end_11:
  ; %t14:f64 = mul_f64 val, val
  %r15 = load double, ptr %t14.slot, align 8
  store double %r15, ptr %v2.slot, align 8
  store double 1.000000e+00, ptr %t15.slot, align 8
  store double 3.333315e-01, ptr %t16.slot, align 8
  store double 1.999355e-01, ptr %t17.slot, align 8
  store double 1.420890e-01, ptr %t18.slot, align 8
  store double 1.065626e-01, ptr %t19.slot, align 8
  store double 7.528964e-02, ptr %t20.slot, align 8
  ; %t21:f64 = mul_f64 v2, %t20
  ; %t22:f64 = sub_f64 %t19, %t21
  ; %t23:f64 = mul_f64 v2, %t22
  ; %t24:f64 = sub_f64 %t18, %t23
  ; %t25:f64 = mul_f64 v2, %t24
  ; %t26:f64 = sub_f64 %t17, %t25
  ; %t27:f64 = mul_f64 v2, %t26
  ; %t28:f64 = sub_f64 %t16, %t27
  ; %t29:f64 = mul_f64 v2, %t28
  ; %t30:f64 = sub_f64 %t15, %t29
  ; %t31:f64 = mul_f64 val, %t30
  %r16 = load double, ptr %t31.slot, align 8
  store double %r16, ptr %res.slot, align 8
  %r17 = load i64, ptr %invert.slot, align 8
  %r18 = icmp eq i64 %r17, 0
  br i1 %r18, label %if_end_12, label %fall_18
fall_18:
  ; %t32:f64 = sub_f64 half_pi, res
  %r19 = load double, ptr %t32.slot, align 8
  store double %r19, ptr %res.slot, align 8
  br label %if_end_12
dead_r20:
  br label %if_end_12
if_end_12:
  ; %t33:f64 = mul_f64 sign_val, res
  %r21 = load double, ptr %t33.slot, align 8
  ret double %r21
ret_cont_21:
  ret double 0.0
}

define dso_local double @atan2(double %y.arg, double %x.arg) #0 {
entry:
  %y.slot = alloca double, align 8
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %pi.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %half_pi.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  store double %y.arg, ptr %y.slot, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 3.141593e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %pi.slot, align 8
  store double 1.570796e+00, ptr %t2.slot, align 8
  %r2 = load double, ptr %t2.slot, align 8
  store double %r2, ptr %half_pi.slot, align 8
  store double 0.000000e+00, ptr %t3.slot, align 8
  ; %t4:bool = cmp_gt_f64 x, %t3
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_13, label %fall_4
fall_4:
  ; %t5:f64 = div_f64 y, x
  ; %t6:f64 = call atan(%t5)
  %r5 = load double, ptr %t6.slot, align 8
  ret double %r5
ret_cont_5:
  br label %if_end_13
dead_r6:
  br label %if_end_13
if_end_13:
  store double 0.000000e+00, ptr %t7.slot, align 8
  ; %t8:bool = cmp_lt_f64 x, %t7
  %r7 = load i64, ptr %t8.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_14, label %fall_8
fall_8:
  store double 0.000000e+00, ptr %t9.slot, align 8
  ; %t10:bool = cmp_ge_f64 y, %t9
  %r9 = load i64, ptr %t10.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_next_16, label %fall_10
fall_10:
  ; %t11:f64 = div_f64 y, x
  ; %t12:f64 = call atan(%t11)
  ; %t13:f64 = add_f64 %t12, pi
  %r11 = load double, ptr %t13.slot, align 8
  ret double %r11
ret_cont_11:
  br label %if_end_15
dead_r12:
  br label %if_next_16
if_next_16:
  ; %t14:f64 = div_f64 y, x
  ; %t15:f64 = call atan(%t14)
  ; %t16:f64 = sub_f64 %t15, pi
  %r13 = load double, ptr %t16.slot, align 8
  ret double %r13
ret_cont_13:
  br label %if_end_15
if_end_15:
  br label %if_end_14
dead_r14:
  br label %if_end_14
if_end_14:
  store double 0.000000e+00, ptr %t17.slot, align 8
  ; %t18:bool = cmp_gt_f64 y, %t17
  %r15 = load i64, ptr %t18.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_17, label %fall_16
fall_16:
  %r17 = load double, ptr %half_pi.slot, align 8
  ret double %r17
ret_cont_17:
  br label %if_end_17
dead_r18:
  br label %if_end_17
if_end_17:
  store double 0.000000e+00, ptr %t19.slot, align 8
  ; %t20:bool = cmp_lt_f64 y, %t19
  %r19 = load i64, ptr %t20.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_18, label %fall_20
fall_20:
  ; %t21:f64 = neg_f64 half_pi
  %r21 = load double, ptr %t21.slot, align 8
  ret double %r21
ret_cont_21:
  br label %if_end_18
dead_r22:
  br label %if_end_18
if_end_18:
  store double 0.000000e+00, ptr %t22.slot, align 8
  %r23 = load double, ptr %t22.slot, align 8
  ret double %r23
ret_cont_23:
  ret double 0.0
}

define dso_local double @asin(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %c.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %denom.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %half_pi.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.000000e+00, ptr %t1.slot, align 8
  ; %t2:f64 = neg_f64 %t1
  store double 1.000000e+00, ptr %t3.slot, align 8
  ; %t4:f64 = call clamp(x, %t2, %t3)
  %r1 = load double, ptr %t4.slot, align 8
  store double %r1, ptr %c.slot, align 8
  store double 1.000000e+00, ptr %t5.slot, align 8
  ; %t6:f64 = mul_f64 c, c
  ; %t7:f64 = sub_f64 %t5, %t6
  ; %t8:f64 = sqrt_f64 %t7
  %r2 = load double, ptr %t8.slot, align 8
  store double %r2, ptr %denom.slot, align 8
  store double 0.000000e+00, ptr %t9.slot, align 8
  ; %t10:bool = cmp_eq_f64 denom, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_19, label %fall_4
fall_4:
  store double 1.570796e+00, ptr %t11.slot, align 8
  %r5 = load double, ptr %t11.slot, align 8
  store double %r5, ptr %half_pi.slot, align 8
  store double 0.000000e+00, ptr %t13.slot, align 8
  ; %t14:bool = cmp_gt_f64 c, %t13
  %r6 = load i64, ptr %t14.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %tern_else_20, label %fall_7
fall_7:
  %r8 = load double, ptr %half_pi.slot, align 8
  store double %r8, ptr %t12.slot, align 8
  br label %tern_end_21
dead_r9:
  br label %tern_else_20
tern_else_20:
  ; %t15:f64 = neg_f64 half_pi
  %r10 = load double, ptr %t15.slot, align 8
  store double %r10, ptr %t12.slot, align 8
  br label %tern_end_21
tern_end_21:
  %r11 = load double, ptr %t12.slot, align 8
  ret double %r11
ret_cont_11:
  br label %if_end_19
dead_r12:
  br label %if_end_19
if_end_19:
  ; %t16:f64 = div_f64 c, denom
  ; %t17:f64 = call atan(%t16)
  %r13 = load double, ptr %t17.slot, align 8
  ret double %r13
ret_cont_13:
  ret double 0.0
}

define dso_local double @acos(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %half_pi.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.570796e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %half_pi.slot, align 8
  ; %t2:f64 = call asin(x)
  ; %t3:f64 = sub_f64 half_pi, %t2
  %r2 = load double, ptr %t3.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

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
  br i1 %r2, label %if_end_22, label %fall_2
fall_2:
  store double 1.000000e+00, ptr %t3.slot, align 8
  %r3 = load double, ptr %t3.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_22
dead_r4:
  br label %if_end_22
if_end_22:
  store double 5.000000e+01, ptr %t4.slot, align 8
  ; %t5:f64 = neg_f64 %t4
  ; %t6:bool = cmp_lt_f64 x, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_23, label %fall_6
fall_6:
  store double 0.000000e+00, ptr %t7.slot, align 8
  %r7 = load double, ptr %t7.slot, align 8
  ret double %r7
ret_cont_7:
  br label %if_end_23
dead_r8:
  br label %if_end_23
if_end_23:
  store double 7.000000e+02, ptr %t8.slot, align 8
  ; %t9:bool = cmp_gt_f64 x, %t8
  %r9 = load i64, ptr %t9.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_24, label %fall_10
fall_10:
  store double 1.000000e+300, ptr %t10.slot, align 8
  %r11 = load double, ptr %t10.slot, align 8
  ret double %r11
ret_cont_11:
  br label %if_end_24
dead_r12:
  br label %if_end_24
if_end_24:
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
  br label %for_cond_25
for_cond_25:
  ; %t38:bool = cmp_lt_i64 _, %t36
  %r16 = load i64, ptr %t38.slot, align 8
  %r17 = icmp eq i64 %r16, 0
  br i1 %r17, label %for_end_27, label %fall_17
fall_17:
  ; %t39:f64 = mul_f64 term, term
  %r18 = load double, ptr %t39.slot, align 8
  store double %r18, ptr %term.slot, align 8
  br label %for_step_26
for_step_26:
  ; %t40:i64 = add_i64 _, %t37
  %r19 = load i64, ptr %t40.slot, align 8
  store i64 %r19, ptr %_.slot, align 8
  br label %for_cond_25
dead_r20:
  br label %for_end_27
for_end_27:
  %r21 = load double, ptr %term.slot, align 8
  ret double %r21
ret_cont_21:
  ret double 0.0
}

define dso_local double @log(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %ln2.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %k.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca double, align 8
  %z.slot = alloca double, align 8
  %t24.slot = alloca double, align 8
  %z2.slot = alloca double, align 8
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
  %t35.slot = alloca double, align 8
  %t36.slot = alloca double, align 8
  %t37.slot = alloca double, align 8
  %t38.slot = alloca double, align 8
  %t39.slot = alloca double, align 8
  %t40.slot = alloca double, align 8
  %t41.slot = alloca double, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca double, align 8
  %t44.slot = alloca double, align 8
  %t45.slot = alloca double, align 8
  %t46.slot = alloca double, align 8
  %t47.slot = alloca double, align 8
  %t48.slot = alloca double, align 8
  %res.slot = alloca double, align 8
  %t49.slot = alloca double, align 8
  %t50.slot = alloca double, align 8
  %t51.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_f64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_28, label %fall_2
fall_2:
  store double 1.000000e+300, ptr %t3.slot, align 8
  ; %t4:f64 = neg_f64 %t3
  %r3 = load double, ptr %t4.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_28
dead_r4:
  br label %if_end_28
if_end_28:
  store double 6.931472e-01, ptr %t5.slot, align 8
  %r5 = load double, ptr %t5.slot, align 8
  store double %r5, ptr %ln2.slot, align 8
  %r6 = load double, ptr %x.slot, align 8
  store double %r6, ptr %val.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  %r7 = load i64, ptr %t6.slot, align 8
  store i64 %r7, ptr %k.slot, align 8
  br label %while_cond_29
while_cond_29:
  store double 1.500000e+00, ptr %t7.slot, align 8
  ; %t8:bool = cmp_gt_f64 val, %t7
  %r8 = load i64, ptr %t8.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %while_end_30, label %fall_9
fall_9:
  store double 5.000000e-01, ptr %t9.slot, align 8
  ; %t10:f64 = mul_f64 val, %t9
  %r10 = load double, ptr %t10.slot, align 8
  store double %r10, ptr %val.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = add_i64 k, %t11
  %r11 = load i64, ptr %t12.slot, align 8
  store i64 %r11, ptr %k.slot, align 8
  br label %while_cond_29
dead_r12:
  br label %while_end_30
while_end_30:
  br label %while_cond_31
while_cond_31:
  store double 7.500000e-01, ptr %t13.slot, align 8
  ; %t14:bool = cmp_lt_f64 val, %t13
  %r13 = load i64, ptr %t14.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %while_end_32, label %fall_14
fall_14:
  store double 2.000000e+00, ptr %t15.slot, align 8
  ; %t16:f64 = mul_f64 val, %t15
  %r15 = load double, ptr %t16.slot, align 8
  store double %r15, ptr %val.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = sub_i64 k, %t17
  %r16 = load i64, ptr %t18.slot, align 8
  store i64 %r16, ptr %k.slot, align 8
  br label %while_cond_31
dead_r17:
  br label %while_end_32
while_end_32:
  store double 1.000000e+00, ptr %t19.slot, align 8
  ; %t20:f64 = sub_f64 val, %t19
  store double 1.000000e+00, ptr %t21.slot, align 8
  ; %t22:f64 = add_f64 val, %t21
  ; %t23:f64 = div_f64 %t20, %t22
  %r18 = load double, ptr %t23.slot, align 8
  store double %r18, ptr %z.slot, align 8
  ; %t24:f64 = mul_f64 z, z
  %r19 = load double, ptr %t24.slot, align 8
  store double %r19, ptr %z2.slot, align 8
  store double 2.000000e+00, ptr %t25.slot, align 8
  ; %t26:f64 = mul_f64 %t25, z
  store double 1.000000e+00, ptr %t27.slot, align 8
  store double 3.333333e-01, ptr %t30.slot, align 8
  store double 2.000000e-01, ptr %t33.slot, align 8
  store double 1.428571e-01, ptr %t36.slot, align 8
  store double 1.111111e-01, ptr %t39.slot, align 8
  ; %t40:f64 = mul_f64 z2, %t39
  ; %t41:f64 = add_f64 %t36, %t40
  ; %t42:f64 = mul_f64 z2, %t41
  ; %t43:f64 = add_f64 %t33, %t42
  ; %t44:f64 = mul_f64 z2, %t43
  ; %t45:f64 = add_f64 %t30, %t44
  ; %t46:f64 = mul_f64 z2, %t45
  ; %t47:f64 = add_f64 %t27, %t46
  ; %t48:f64 = mul_f64 %t26, %t47
  %r20 = load double, ptr %t48.slot, align 8
  store double %r20, ptr %res.slot, align 8
  ; %t49:f64 = i64_to_f64 k
  ; %t50:f64 = mul_f64 %t49, ln2
  ; %t51:f64 = add_f64 res, %t50
  %r21 = load double, ptr %t51.slot, align 8
  ret double %r21
ret_cont_21:
  ret double 0.0
}

define dso_local double @log10(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call log(x)
  store double 2.302585e+00, ptr %t2.slot, align 8
  ; %t3:f64 = div_f64 %t1, %t2
  %r1 = load double, ptr %t3.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @log2(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call log(x)
  store double 6.931472e-01, ptr %t2.slot, align 8
  ; %t3:f64 = div_f64 %t1, %t2
  %r1 = load double, ptr %t3.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local double @sinh(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %ex.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call exp(x)
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %ex.slot, align 8
  store double 1.000000e+00, ptr %t2.slot, align 8
  ; %t3:f64 = div_f64 %t2, ex
  ; %t4:f64 = sub_f64 ex, %t3
  store double 5.000000e-01, ptr %t5.slot, align 8
  ; %t6:f64 = mul_f64 %t4, %t5
  %r2 = load double, ptr %t6.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local double @cosh(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %ex.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call exp(x)
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %ex.slot, align 8
  store double 1.000000e+00, ptr %t2.slot, align 8
  ; %t3:f64 = div_f64 %t2, ex
  ; %t4:f64 = add_f64 ex, %t3
  store double 5.000000e-01, ptr %t5.slot, align 8
  ; %t6:f64 = mul_f64 %t4, %t5
  %r2 = load double, ptr %t6.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local double @tanh(double %x.arg) #0 {
entry:
  %x.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %ex.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %emx.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  store double %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = call exp(x)
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %ex.slot, align 8
  store double 1.000000e+00, ptr %t2.slot, align 8
  ; %t3:f64 = div_f64 %t2, ex
  %r2 = load double, ptr %t3.slot, align 8
  store double %r2, ptr %emx.slot, align 8
  ; %t4:f64 = sub_f64 ex, emx
  ; %t5:f64 = add_f64 ex, emx
  ; %t6:f64 = div_f64 %t4, %t5
  %r3 = load double, ptr %t6.slot, align 8
  ret double %r3
ret_cont_3:
  ret double 0.0
}

define dso_local i64 @gcd(i64 %a.arg, i64 %b.arg) #0 {
entry:
  %a.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %x.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %y.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store i64 %a.arg, ptr %a.slot, align 8
  store i64 %b.arg, ptr %b.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = abs_i64 a
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %x.slot, align 8
  ; %t2:i64 = abs_i64 b
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %y.slot, align 8
  br label %while_cond_33
while_cond_33:
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_ne_i64 y, %t3
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_34, label %fall_4
fall_4:
  %r5 = load i64, ptr %y.slot, align 8
  store i64 %r5, ptr %t.slot, align 8
  ; %t5:i64 = mod_i64 x, y
  %r6 = load i64, ptr %t5.slot, align 8
  store i64 %r6, ptr %y.slot, align 8
  %r7 = load i64, ptr %t.slot, align 8
  store i64 %r7, ptr %x.slot, align 8
  br label %while_cond_33
dead_r8:
  br label %while_end_34
while_end_34:
  %r9 = load i64, ptr %x.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @factorial(i64 %n.arg) #0 {
entry:
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
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
  br i1 %r2, label %if_end_35, label %fall_2
fall_2:
  store i64 1, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_35
dead_r4:
  br label %if_end_35
if_end_35:
  store i64 1, ptr %t4.slot, align 8
  %r5 = load i64, ptr %t4.slot, align 8
  store i64 %r5, ptr %res.slot, align 8
  store i64 2, ptr %t5.slot, align 8
  store i64 1, ptr %t6.slot, align 8
  %r6 = load i64, ptr %t5.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_36
for_cond_36:
  ; %t7:bool = cmp_le_i64 i, n
  %r7 = load i64, ptr %t7.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_38, label %fall_8
fall_8:
  ; %t8:i64 = mul_i64 res, i
  %r9 = load i64, ptr %t8.slot, align 8
  store i64 %r9, ptr %res.slot, align 8
  br label %for_step_37
for_step_37:
  ; %t9:i64 = add_i64 i, %t6
  %r10 = load i64, ptr %t9.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_36
dead_r11:
  br label %for_end_38
for_end_38:
  %r12 = load i64, ptr %res.slot, align 8
  ret i64 %r12
ret_cont_12:
  ret i64 0
}

define dso_local double @clock_sec() #0 {
entry:
  %t1.slot = alloca i64, align 8
  %ns.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = clock_ns None
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %ns.slot, align 8
  ; %t2:f64 = i64_to_f64 ns
  store double 1.000000e+09, ptr %t3.slot, align 8
  ; %t4:f64 = div_f64 %t2, %t3
  %r2 = load double, ptr %t4.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local i64 @sleep_ns(i64 %ns.arg) #0 {
entry:
  %ns.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store i64 %ns.arg, ptr %ns.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = clock_ns None
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %start.slot, align 8
  br label %while_cond_39
while_cond_39:
  ; %t2:i64 = clock_ns None
  ; %t3:i64 = sub_i64 %t2, start
  ; %t4:bool = cmp_lt_i64 %t3, ns
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %while_end_40, label %fall_3
fall_3:
  br label %while_cond_39
dead_r4:
  br label %while_end_40
while_end_40:
  store i64 0, ptr %t5.slot, align 8
  %r5 = load i64, ptr %t5.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @sleep_ms(i64 %ms.arg) #0 {
entry:
  %ms.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %target_ns.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %ms.arg, ptr %ms.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1000000, ptr %t1.slot, align 8
  ; %t2:i64 = mul_i64 ms, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %target_ns.slot, align 8
  ; %t3:i64 = clock_ns None
  %r2 = load i64, ptr %t3.slot, align 8
  store i64 %r2, ptr %start.slot, align 8
  br label %while_cond_41
while_cond_41:
  ; %t4:i64 = clock_ns None
  ; %t5:i64 = sub_i64 %t4, start
  ; %t6:bool = cmp_lt_i64 %t5, target_ns
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_42, label %fall_4
fall_4:
  br label %while_cond_41
dead_r5:
  br label %while_end_42
while_end_42:
  store i64 0, ptr %t7.slot, align 8
  %r6 = load i64, ptr %t7.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @_splitmix64(i64 %x.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %z.slot = alloca i64, align 8
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
  store i64 %x.arg, ptr %x.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 11400714819323198485, ptr %t1.slot, align 8
  ; %t2:i64 = add_i64 x, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %z.slot, align 8
  store i64 30, ptr %t3.slot, align 8
  ; %t4:i64 = shr_i64 z, %t3
  ; %t5:i64 = xor_i64 z, %t4
  store i64 5700355208116473369, ptr %t6.slot, align 8
  ; %t7:i64 = mul_i64 %t5, %t6
  %r2 = load i64, ptr %t7.slot, align 8
  store i64 %r2, ptr %z.slot, align 8
  store i64 27, ptr %t8.slot, align 8
  ; %t9:i64 = shr_i64 z, %t8
  ; %t10:i64 = xor_i64 z, %t9
  store i64 2685821657736338717, ptr %t11.slot, align 8
  ; %t12:i64 = mul_i64 %t10, %t11
  %r3 = load i64, ptr %t12.slot, align 8
  store i64 %r3, ptr %z.slot, align 8
  store i64 31, ptr %t13.slot, align 8
  ; %t14:i64 = shr_i64 z, %t13
  ; %t15:i64 = xor_i64 z, %t14
  %r4 = load i64, ptr %t15.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}

define dso_local i64 @rng_new(i64 %seed_val.arg) #0 {
entry:
  %seed_val.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %s0.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %s1.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %s2.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %s3.slot = alloca i64, align 8
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
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  store i64 %seed_val.arg, ptr %seed_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %seed_val.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_eq_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_43, label %fall_3
fall_3:
  ; %t3:i64 = clock_ns None
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  br label %if_end_43
dead_r5:
  br label %if_end_43
if_end_43:
  ; %t4:i64 = call _splitmix64(s)
  %r6 = load i64, ptr %t4.slot, align 8
  store i64 %r6, ptr %s0.slot, align 8
  ; %t5:i64 = call _splitmix64(s0)
  %r7 = load i64, ptr %t5.slot, align 8
  store i64 %r7, ptr %s1.slot, align 8
  ; %t6:i64 = call _splitmix64(s1)
  %r8 = load i64, ptr %t6.slot, align 8
  store i64 %r8, ptr %s2.slot, align 8
  ; %t7:i64 = call _splitmix64(s2)
  %r9 = load i64, ptr %t7.slot, align 8
  store i64 %r9, ptr %s3.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:bool = cmp_eq_i64 s0, %t8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_eq_i64 s1, %t10
  ; %t12:bool = and_i64 %t9, %t11
  store i64 0, ptr %t13.slot, align 8
  ; %t14:bool = cmp_eq_i64 s2, %t13
  ; %t15:bool = and_i64 %t12, %t14
  store i64 0, ptr %t16.slot, align 8
  ; %t17:bool = cmp_eq_i64 s3, %t16
  ; %t18:bool = and_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_44, label %fall_11
fall_11:
  store i64 123456789, ptr %t19.slot, align 8
  %r12 = load i64, ptr %t19.slot, align 8
  store i64 %r12, ptr %s0.slot, align 8
  store i64 987654321, ptr %t20.slot, align 8
  %r13 = load i64, ptr %t20.slot, align 8
  store i64 %r13, ptr %s1.slot, align 8
  store i64 456789123, ptr %t21.slot, align 8
  %r14 = load i64, ptr %t21.slot, align 8
  store i64 %r14, ptr %s2.slot, align 8
  store i64 321654987, ptr %t22.slot, align 8
  %r15 = load i64, ptr %t22.slot, align 8
  store i64 %r15, ptr %s3.slot, align 8
  br label %if_end_44
dead_r16:
  br label %if_end_44
if_end_44:
  store i64 4, ptr %t24.slot, align 8
  store i64 0, ptr %t25.slot, align 8
  ; %t23:Xoshiro256 = alloc_array(%t24, init=%t25)
  store i64 0, ptr %t26.slot, align 8
  ; %t23[%t26] = s0  ; i64
  store i64 1, ptr %t27.slot, align 8
  ; %t23[%t27] = s1  ; i64
  store i64 2, ptr %t28.slot, align 8
  ; %t23[%t28] = s2  ; i64
  store i64 3, ptr %t29.slot, align 8
  ; %t23[%t29] = s3  ; i64
  %r17 = load i64, ptr %t23.slot, align 8
  ret i64 %r17
ret_cont_17:
  ret i64 0
}

define dso_local i64 @rng_next(i64 %rng.arg) #0 {
entry:
  %rng.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %sum_val.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %rot23.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %result.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  store i64 %rng.arg, ptr %rng.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = rng[%t1]
  store i64 3, ptr %t3.slot, align 8
  ; %t4:i64 = rng[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %sum_val.slot, align 8
  store i64 23, ptr %t6.slot, align 8
  ; %t7:i64 = shl_i64 sum_val, %t6
  store i64 41, ptr %t8.slot, align 8
  ; %t9:i64 = shr_i64 sum_val, %t8
  store i64 8388607, ptr %t10.slot, align 8
  ; %t11:i64 = and_i64 %t9, %t10
  ; %t12:i64 = or_i64 %t7, %t11
  %r2 = load i64, ptr %t12.slot, align 8
  store i64 %r2, ptr %rot23.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:i64 = rng[%t13]
  ; %t15:i64 = add_i64 rot23, %t14
  %r3 = load i64, ptr %t15.slot, align 8
  store i64 %r3, ptr %result.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = rng[%t16]
  store i64 17, ptr %t18.slot, align 8
  ; %t19:i64 = shl_i64 %t17, %t18
  %r4 = load i64, ptr %t19.slot, align 8
  store i64 %r4, ptr %t.slot, align 8
  store i64 2, ptr %t20.slot, align 8
  ; %t21:i64 = rng[%t20]
  store i64 0, ptr %t22.slot, align 8
  ; %t23:i64 = rng[%t22]
  ; %t24:i64 = xor_i64 %t21, %t23
  store i64 2, ptr %t25.slot, align 8
  ; rng[%t25] = %t24  ; i64
  store i64 3, ptr %t26.slot, align 8
  ; %t27:i64 = rng[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = rng[%t28]
  ; %t30:i64 = xor_i64 %t27, %t29
  store i64 3, ptr %t31.slot, align 8
  ; rng[%t31] = %t30  ; i64
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = rng[%t32]
  store i64 2, ptr %t34.slot, align 8
  ; %t35:i64 = rng[%t34]
  ; %t36:i64 = xor_i64 %t33, %t35
  store i64 1, ptr %t37.slot, align 8
  ; rng[%t37] = %t36  ; i64
  store i64 0, ptr %t38.slot, align 8
  ; %t39:i64 = rng[%t38]
  store i64 3, ptr %t40.slot, align 8
  ; %t41:i64 = rng[%t40]
  ; %t42:i64 = xor_i64 %t39, %t41
  store i64 0, ptr %t43.slot, align 8
  ; rng[%t43] = %t42  ; i64
  store i64 2, ptr %t44.slot, align 8
  ; %t45:i64 = rng[%t44]
  ; %t46:i64 = xor_i64 %t45, t
  store i64 2, ptr %t47.slot, align 8
  ; rng[%t47] = %t46  ; i64
  store i64 3, ptr %t48.slot, align 8
  ; %t49:i64 = rng[%t48]
  store i64 45, ptr %t50.slot, align 8
  ; %t51:i64 = shl_i64 %t49, %t50
  store i64 3, ptr %t52.slot, align 8
  ; %t53:i64 = rng[%t52]
  store i64 19, ptr %t54.slot, align 8
  ; %t55:i64 = shr_i64 %t53, %t54
  store i64 35184372088831, ptr %t56.slot, align 8
  ; %t57:i64 = and_i64 %t55, %t56
  ; %t58:i64 = or_i64 %t51, %t57
  store i64 3, ptr %t59.slot, align 8
  ; rng[%t59] = %t58  ; i64
  store i64 0, ptr %t60.slot, align 8
  ; %t61:bool = cmp_lt_i64 result, %t60
  %r5 = load i64, ptr %t61.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_45, label %fall_6
fall_6:
  ; %t62:i64 = neg_i64 result
  %r7 = load i64, ptr %t62.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_45
dead_r8:
  br label %if_end_45
if_end_45:
  %r9 = load i64, ptr %result.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local double @rng_random_f64(i64 %rng.arg) #0 {
entry:
  %rng.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %u.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %bits53.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  store i64 %rng.arg, ptr %rng.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call rng_next(rng)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %u.slot, align 8
  store i64 9007199254740991, ptr %t2.slot, align 8
  ; %t3:i64 = and_i64 u, %t2
  %r2 = load i64, ptr %t3.slot, align 8
  store i64 %r2, ptr %bits53.slot, align 8
  ; %t4:f64 = i64_to_f64 bits53
  store double 9.007199e+15, ptr %t5.slot, align 8
  ; %t6:f64 = div_f64 %t4, %t5
  %r3 = load double, ptr %t6.slot, align 8
  ret double %r3
ret_cont_3:
  ret double 0.0
}

define dso_local i64 @rng_randint(i64 %rng.arg, i64 %low.arg, i64 %high.arg) #0 {
entry:
  %rng.slot = alloca i64, align 8
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %span.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %rng.arg, ptr %rng.slot, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_ge_i64 low, high
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_46, label %fall_2
fall_2:
  %r3 = load i64, ptr %low.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_46
dead_r4:
  br label %if_end_46
if_end_46:
  ; %t2:i64 = sub_i64 high, low
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  %r5 = load i64, ptr %t4.slot, align 8
  store i64 %r5, ptr %span.slot, align 8
  ; %t5:i64 = call rng_next(rng)
  ; %t6:i64 = mod_i64 %t5, span
  ; %t7:i64 = add_i64 low, %t6
  %r6 = load i64, ptr %t7.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local double @rng_uniform(i64 %rng.arg, double %low.arg, double %high.arg) #0 {
entry:
  %rng.slot = alloca i64, align 8
  %low.slot = alloca double, align 8
  %high.slot = alloca double, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  store i64 %rng.arg, ptr %rng.slot, align 8
  store double %low.arg, ptr %low.slot, align 8
  store double %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:f64 = sub_f64 high, low
  ; %t2:f64 = call rng_random_f64(rng)
  ; %t3:f64 = mul_f64 %t1, %t2
  ; %t4:f64 = add_f64 low, %t3
  %r1 = load double, ptr %t4.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local i64 @rng_choice(i64 %rng.arg, ptr %arr.arg, i64 %count.arg) #0 {
entry:
  %rng.slot = alloca i64, align 8
  %arr.slot = alloca ptr, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  store i64 %rng.arg, ptr %rng.slot, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 count, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_47, label %fall_2
fall_2:
  store i64 0, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_47
dead_r4:
  br label %if_end_47
if_end_47:
  store i64 0, ptr %t4.slot, align 8
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = sub_i64 count, %t5
  ; %t7:i64 = call rng_randint(rng, %t4, %t6)
  %r5 = load i64, ptr %t7.slot, align 8
  store i64 %r5, ptr %idx.slot, align 8
  ; %t8:i64 = arr[idx]
  %r6 = load i64, ptr %t8.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @test_math() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %angle_90.slot = alloca double, align 8
  %t11.slot = alloca double, align 8
  %sin_90.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %cos_90.slot = alloca double, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %angle_45.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %sin_45.slot = alloca double, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %h.slot = alloca double, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca double, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca double, align 8
  %at2.slot = alloca double, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca double, align 8
  %t30.slot = alloca double, align 8
  %f_val.slot = alloca double, align 8
  %t31.slot = alloca double, align 8
  %t32.slot = alloca double, align 8
  %c_val.slot = alloca double, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca double, align 8
  %t35.slot = alloca double, align 8
  %t36.slot = alloca double, align 8
  %l_val.slot = alloca double, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  ; print(%t1:str)
  ; %t2:str = const_str 1
  store double 3.141593e+00, ptr %t3.slot, align 8
  ; print(%t2:str, %t3:f64)
  ; %t4:str = const_str 2
  store double 6.283185e+00, ptr %t5.slot, align 8
  ; print(%t4:str, %t5:f64)
  ; %t6:str = const_str 3
  store double 2.718282e+00, ptr %t7.slot, align 8
  ; print(%t6:str, %t7:f64)
  store double 1.570796e+00, ptr %t10.slot, align 8
  %r1 = load double, ptr %t10.slot, align 8
  store double %r1, ptr %angle_90.slot, align 8
  ; %t11:f64 = call sin(angle_90)
  %r2 = load double, ptr %t11.slot, align 8
  store double %r2, ptr %sin_90.slot, align 8
  ; %t12:f64 = call cos(angle_90)
  %r3 = load double, ptr %t12.slot, align 8
  store double %r3, ptr %cos_90.slot, align 8
  ; %t13:str = const_str 4
  ; print(%t13:str, sin_90:f64)
  ; %t14:str = const_str 5
  ; print(%t14:str, cos_90:f64)
  store double 7.853982e-01, ptr %t17.slot, align 8
  %r4 = load double, ptr %t17.slot, align 8
  store double %r4, ptr %angle_45.slot, align 8
  ; %t18:f64 = call sin(angle_45)
  %r5 = load double, ptr %t18.slot, align 8
  store double %r5, ptr %sin_45.slot, align 8
  ; %t19:str = const_str 6
  ; print(%t19:str, sin_45:f64)
  store double 3.000000e+00, ptr %t20.slot, align 8
  store double 4.000000e+00, ptr %t21.slot, align 8
  ; %t22:f64 = call hypot(%t20, %t21)
  %r6 = load double, ptr %t22.slot, align 8
  store double %r6, ptr %h.slot, align 8
  ; %t23:str = const_str 7
  ; print(%t23:str, h:f64)
  store double 4.000000e+00, ptr %t24.slot, align 8
  store double 3.000000e+00, ptr %t25.slot, align 8
  ; %t26:f64 = call atan2(%t24, %t25)
  %r7 = load double, ptr %t26.slot, align 8
  store double %r7, ptr %at2.slot, align 8
  ; %t27:str = const_str 8
  ; %t28:f64 = call rad_to_deg(at2)
  ; print(%t27:str, %t28:f64)
  store double 3.700000e+00, ptr %t29.slot, align 8
  ; %t30:f64 = call floor(%t29)
  %r8 = load double, ptr %t30.slot, align 8
  store double %r8, ptr %f_val.slot, align 8
  store double 3.200000e+00, ptr %t31.slot, align 8
  ; %t32:f64 = call ceil(%t31)
  %r9 = load double, ptr %t32.slot, align 8
  store double %r9, ptr %c_val.slot, align 8
  store double 1.000000e+01, ptr %t33.slot, align 8
  store double 2.000000e+01, ptr %t34.slot, align 8
  store double 7.500000e-01, ptr %t35.slot, align 8
  ; %t36:f64 = call lerp(%t33, %t34, %t35)
  %r10 = load double, ptr %t36.slot, align 8
  store double %r10, ptr %l_val.slot, align 8
  ; %t37:str = const_str 9
  ; %t38:str = const_str 10
  ; %t39:str = const_str 11
  ; print(%t37:str, f_val:f64, %t38:str, c_val:f64, %t39:str, l_val:f64)
  store i64 0, ptr %t40.slot, align 8
  %r11 = load i64, ptr %t40.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @test_time() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t0.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %elapsed_ns.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %elapsed_ms.slot = alloca double, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 12
  ; print(%t1:str)
  ; %t2:i64 = clock_ns None
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %t0.slot, align 8
  store i64 500000, ptr %t3.slot, align 8
  ; %t4:void = call sleep_ns(%t3)
  ; %t5:i64 = clock_ns None
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %t1.slot, align 8
  ; %t6:i64 = sub_i64 t1, t0
  %r3 = load i64, ptr %t6.slot, align 8
  store i64 %r3, ptr %elapsed_ns.slot, align 8
  ; %t7:f64 = i64_to_f64 elapsed_ns
  store double 1.000000e+06, ptr %t8.slot, align 8
  ; %t9:f64 = div_f64 %t7, %t8
  %r4 = load double, ptr %t9.slot, align 8
  store double %r4, ptr %elapsed_ms.slot, align 8
  ; %t10:str = const_str 13
  ; %t11:str = const_str 14
  ; %t12:str = const_str 15
  ; print(%t10:str, elapsed_ns:i64, %t11:str, elapsed_ms:f64, %t12:str)
  store i64 0, ptr %t13.slot, align 8
  %r5 = load i64, ptr %t13.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @test_random() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %rng.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %rf.slot = alloca double, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %die.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 16
  ; print(%t1:str)
  store i64 1337, ptr %t2.slot, align 8
  ; %t3:Xoshiro256 = call rng_new(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %rng.slot, align 8
  ; %t4:str = const_str 17
  ; print(%t4:str)
  store i64 1, ptr %t5.slot, align 8
  store i64 5, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_48
for_cond_48:
  ; %t8:bool = cmp_le_i64 i, %t6
  %r3 = load i64, ptr %t8.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_50, label %fall_4
fall_4:
  ; %t9:f64 = call rng_random_f64(rng)
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %rf.slot, align 8
  ; %t10:str = const_str 18
  ; %t11:str = const_str 19
  ; print(%t10:str, i:i64, %t11:str, rf:f64)
  br label %for_step_49
for_step_49:
  ; %t12:i64 = add_i64 i, %t7
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_48
dead_r7:
  br label %for_end_50
for_end_50:
  ; %t13:str = const_str 20
  ; print(%t13:str)
  store i64 1, ptr %t14.slot, align 8
  store i64 5, ptr %t15.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  %r8 = load i64, ptr %t14.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_51
for_cond_51:
  ; %t17:bool = cmp_le_i64 i, %t15
  %r9 = load i64, ptr %t17.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %for_end_53, label %fall_10
fall_10:
  store i64 1, ptr %t18.slot, align 8
  store i64 6, ptr %t19.slot, align 8
  ; %t20:i64 = call rng_randint(rng, %t18, %t19)
  %r11 = load i64, ptr %t20.slot, align 8
  store i64 %r11, ptr %die.slot, align 8
  ; %t21:str = const_str 21
  ; %t22:str = const_str 19
  ; print(%t21:str, i:i64, %t22:str, die:i64)
  br label %for_step_52
for_step_52:
  ; %t23:i64 = add_i64 i, %t16
  %r12 = load i64, ptr %t23.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_51
dead_r13:
  br label %for_end_53
for_end_53:
  store i64 0, ptr %t24.slot, align 8
  %r14 = load i64, ptr %t24.slot, align 8
  ret i64 %r14
ret_cont_14:
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
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 22
  ; print(%t1:str)
  ; %t2:str = const_str 23
  ; print(%t2:str)
  ; %t3:str = const_str 22
  ; print(%t3:str)
  ; %t4:i64 = call test_math()
  ; %t5:i64 = call test_time()
  ; %t6:i64 = call test_random()
  ; %t7:str = const_str 22
  ; print(%t7:str)
  ; %t8:str = const_str 24
  ; print(%t8:str)
  ; %t9:str = const_str 22
  ; print(%t9:str)
  store i64 0, ptr %t10.slot, align 8
  %r1 = load i64, ptr %t10.slot, align 8
  ret i64 %r1
ret_cont_1:
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
  ; %t4:i64 = call main()
  store i64 0, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}
