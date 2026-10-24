; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local double @compute_local_step(i64 %iter_id.arg) #0 {
entry:
  %iter_id.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %arena_sp_compute_local_step.slot = alloca i64, align 8
  store i64 %iter_id.arg, ptr %iter_id.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_compute_local_step:i64 = arena_save None
  store i64 4, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:Particle = alloc_array(%t2, init=%t3)
  store double 1.500000e+00, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t1[%t5] = %t4  ; f64
  store double 2.500000e+00, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  ; %t1[%t7] = %t6  ; f64
  store double 3.500000e+00, ptr %t8.slot, align 8
  store i64 2, ptr %t9.slot, align 8
  ; %t1[%t9] = %t8  ; f64
  store double 4.500000e+00, ptr %t10.slot, align 8
  store i64 3, ptr %t11.slot, align 8
  ; %t1[%t11] = %t10  ; f64
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %p.slot, align 8
  store i64 0, ptr %t12.slot, align 8
  ; %t13:f64 = p[%t12]
  store i64 2, ptr %t14.slot, align 8
  ; %t15:f64 = p[%t14]
  ; %t16:f64 = mul_f64 %t13, %t15
  store i64 1, ptr %t17.slot, align 8
  ; %t18:f64 = p[%t17]
  store i64 3, ptr %t19.slot, align 8
  ; %t20:f64 = p[%t19]
  ; %t21:f64 = mul_f64 %t18, %t20
  ; %t22:f64 = add_f64 %t16, %t21
  ; arena_restore %arena_sp_compute_local_step
  %r2 = load double, ptr %t22.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local double @stress_test(i64 %iterations.arg) #0 {
entry:
  %iterations.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %total.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  store i64 %iterations.arg, ptr %iterations.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %total.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_1
for_cond_1:
  ; %t4:bool = cmp_le_i64 i, iterations
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_3, label %fall_4
fall_4:
  ; %t5:f64 = call compute_local_step(i)
  ; %t6:f64 = add_f64 total, %t5
  %r5 = load double, ptr %t6.slot, align 8
  store double %r5, ptr %total.slot, align 8
  br label %for_step_2
for_step_2:
  ; %t7:i64 = add_i64 i, %t3
  %r6 = load i64, ptr %t7.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_1
dead_r7:
  br label %for_end_3
for_end_3:
  %r8 = load double, ptr %total.slot, align 8
  ret double %r8
ret_cont_8:
  ret double 0.0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %res.slot = alloca double, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  ; print(%t1:str)
  ; %t2:str = const_str 1
  ; print(%t2:str)
  ; %t3:str = const_str 0
  ; print(%t3:str)
  ; %t4:str = const_str 2
  ; print(%t4:str)
  store i64 1000000, ptr %t5.slot, align 8
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %n.slot, align 8
  ; %t6:f64 = call stress_test(n)
  %r2 = load double, ptr %t6.slot, align 8
  store double %r2, ptr %res.slot, align 8
  ; %t7:str = const_str 3
  ; print(%t7:str, n:i64)
  ; %t8:str = const_str 4
  ; print(%t8:str, res:f64)
  ; %t9:str = const_str 5
  ; print(%t9:str)
  ; %t10:str = const_str 6
  ; print(%t10:str)
  ; %t11:str = const_str 0
  ; print(%t11:str)
  store i64 0, ptr %t12.slot, align 8
  %r3 = load i64, ptr %t12.slot, align 8
  ret i64 %r3
ret_cont_3:
  ret i64 0
}
