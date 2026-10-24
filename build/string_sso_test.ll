; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @test_sso_and_slicing() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %s1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %s2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %s3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %full.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %sub1.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %sub2.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %sub_tail.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %sub_head.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca ptr, align 8
  %ch0.slot = alloca ptr, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca ptr, align 8
  %ch6.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca i64, align 8
  %is_match1.slot = alloca i64, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %is_match2.slot = alloca i64, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca ptr, align 8
  %t48.slot = alloca double, align 8
  %speedup.slot = alloca double, align 8
  %t49.slot = alloca ptr, align 8
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca ptr, align 8
  %t53.slot = alloca ptr, align 8
  %status.slot = alloca ptr, align 8
  %t54.slot = alloca i64, align 8
  %arena_sp_test_sso_and_slicing.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_test_sso_and_slicing:i64 = arena_save None
  ; %t1:str = const_str 0
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %s1.slot, align 8
  ; %t2:str = const_str 1
  %r2 = load ptr, ptr %t2.slot, align 8
  store ptr %r2, ptr %s2.slot, align 8
  ; %t3:str = const_str 2
  %r3 = load ptr, ptr %t3.slot, align 8
  store ptr %r3, ptr %s3.slot, align 8
  ; %t4:str = str_concat(s1, s2)
  ; %t5:str = str_concat(%t4, s3)
  %r4 = load ptr, ptr %t5.slot, align 8
  store ptr %r4, ptr %full.slot, align 8
  ; %t6:str = const_str 3
  ; %t7:str = const_str 4
  ; print(%t6:str, full:str, %t7:str)
  ; %t8:str = const_str 5
  ; %t9:str = const_str 6
  ; %t10:i64 = str_len(full)
  ; print(%t8:str, full:str, %t9:str, %t10:i64)
  store i64 0, ptr %t11.slot, align 8
  store i64 5, ptr %t12.slot, align 8
  ; %t13:str = str_slice(full[%t11:%t12])
  %r5 = load ptr, ptr %t13.slot, align 8
  store ptr %r5, ptr %sub1.slot, align 8
  store i64 6, ptr %t14.slot, align 8
  store i64 11, ptr %t15.slot, align 8
  ; %t16:str = str_slice(full[%t14:%t15])
  %r6 = load ptr, ptr %t16.slot, align 8
  store ptr %r6, ptr %sub2.slot, align 8
  store i64 6, ptr %t17.slot, align 8
  store i64 -1, ptr %t18.slot, align 8
  ; %t19:str = str_slice(full[%t17:%t18])
  %r7 = load ptr, ptr %t19.slot, align 8
  store ptr %r7, ptr %sub_tail.slot, align 8
  store i64 0, ptr %t20.slot, align 8
  store i64 5, ptr %t21.slot, align 8
  ; %t22:str = str_slice(full[%t20:%t21])
  %r8 = load ptr, ptr %t22.slot, align 8
  store ptr %r8, ptr %sub_head.slot, align 8
  ; %t23:str = const_str 7
  ; %t24:str = const_str 8
  ; %t25:i64 = str_len(sub1)
  ; %t26:str = const_str 9
  ; print(%t23:str, sub1:str, %t24:str, %t25:i64, %t26:str)
  ; %t27:str = const_str 10
  ; %t28:str = const_str 8
  ; %t29:i64 = str_len(sub2)
  ; %t30:str = const_str 9
  ; print(%t27:str, sub2:str, %t28:str, %t29:i64, %t30:str)
  ; %t31:str = const_str 11
  ; %t32:str = const_str 4
  ; print(%t31:str, sub_tail:str, %t32:str)
  ; %t33:str = const_str 12
  ; %t34:str = const_str 4
  ; print(%t33:str, sub_head:str, %t34:str)
  store i64 0, ptr %t35.slot, align 8
  ; %t36:str = str_index(full[%t35])
  %r9 = load ptr, ptr %t36.slot, align 8
  store ptr %r9, ptr %ch0.slot, align 8
  store i64 6, ptr %t37.slot, align 8
  ; %t38:str = str_index(full[%t37])
  %r10 = load ptr, ptr %t38.slot, align 8
  store ptr %r10, ptr %ch6.slot, align 8
  ; %t39:str = const_str 13
  ; %t40:str = const_str 14
  ; %t41:str = const_str 4
  ; print(%t39:str, ch0:str, %t40:str, ch6:str, %t41:str)
  ; %t42:str = const_str 0
  ; %t43:bool = str_cmp_eq sub1, %t42
  %r11 = load i64, ptr %t43.slot, align 8
  store i64 %r11, ptr %is_match1.slot, align 8
  ; %t44:str = const_str 15
  ; %t45:bool = str_cmp_eq sub2, %t44
  %r12 = load i64, ptr %t45.slot, align 8
  store i64 %r12, ptr %is_match2.slot, align 8
  ; %t46:str = const_str 16
  ; print(%t46:str, is_match1:bool)
  ; %t47:str = const_str 17
  ; print(%t47:str, is_match2:bool)
  store double 2.750000e+01, ptr %t48.slot, align 8
  %r13 = load double, ptr %t48.slot, align 8
  store double %r13, ptr %speedup.slot, align 8
  ; %t49:str = const_str 18
  ; %t50:str = str_from_f64 speedup
  ; %t51:str = str_concat(%t49, %t50)
  ; %t52:str = const_str 19
  ; %t53:str = str_concat(%t51, %t52)
  %r14 = load ptr, ptr %t53.slot, align 8
  store ptr %r14, ptr %status.slot, align 8
  ; print(status:str)
  store i64 0, ptr %t54.slot, align 8
  ; arena_restore %arena_sp_test_sso_and_slicing
  %r15 = load i64, ptr %t54.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 20
  ; print(%t1:str)
  ; %t2:str = const_str 21
  ; print(%t2:str)
  ; %t3:str = const_str 20
  ; print(%t3:str)
  ; %t4:i64 = call test_sso_and_slicing()
  ; %t5:str = const_str 20
  ; print(%t5:str)
  store i64 0, ptr %t6.slot, align 8
  %r1 = load i64, ptr %t6.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}
