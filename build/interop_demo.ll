; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca double, align 8
  %angle.slot = alloca double, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca double, align 8
  %s.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca double, align 8
  %num.slot = alloca double, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca double, align 8
  %root.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca double, align 8
  %dyn_calc.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  ; print(%t1:str)
  ; %t2:str = const_str 1
  ; print(%t2:str)
  ; %t3:str = const_str 0
  ; print(%t3:str)
  store double 1.570796e+00, ptr %t4.slot, align 8
  %r1 = load double, ptr %t4.slot, align 8
  store double %r1, ptr %angle.slot, align 8
  ; %t5:str = const_str 2
  ; %t6:str = const_str 3
  ; %t7:f64 = py_call_f64 %t5, %t6
  ; %t8:i64 = f64_to_i64 %t7
  %r2 = load i64, ptr %t8.slot, align 8
  store i64 %r2, ptr %s.slot, align 8
  ; %t9:str = const_str 4
  ; print(%t9:str, s:i64)
  store double 1.440000e+02, ptr %t10.slot, align 8
  %r3 = load double, ptr %t10.slot, align 8
  store double %r3, ptr %num.slot, align 8
  ; %t11:str = const_str 2
  ; %t12:str = const_str 5
  ; %t13:f64 = py_call_f64 %t11, %t12
  ; %t14:i64 = f64_to_i64 %t13
  %r4 = load i64, ptr %t14.slot, align 8
  store i64 %r4, ptr %root.slot, align 8
  ; %t15:str = const_str 6
  ; print(%t15:str, root:i64)
  ; %t16:str = const_str 7
  ; %t17:f64 = py_eval_f64 %t16
  ; %t18:i64 = f64_to_i64 %t17
  %r5 = load i64, ptr %t18.slot, align 8
  store i64 %r5, ptr %dyn_calc.slot, align 8
  ; %t19:str = const_str 8
  ; print(%t19:str, dyn_calc:i64)
  ; %t20:str = const_str 0
  ; print(%t20:str)
  ; %t21:str = const_str 9
  ; print(%t21:str)
  ; %t22:str = const_str 0
  ; print(%t22:str)
  store i64 0, ptr %t23.slot, align 8
  %r6 = load i64, ptr %t23.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}
