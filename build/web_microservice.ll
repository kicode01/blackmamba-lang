; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @check_rate_limit(i64 %client_id.arg, i64 %current_tokens.arg, i64 %max_capacity.arg) #0 {
entry:
  %client_id.slot = alloca i64, align 8
  %current_tokens.slot = alloca i64, align 8
  %max_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %client_id.arg, ptr %client_id.slot, align 8
  store i64 %current_tokens.arg, ptr %current_tokens.slot, align 8
  store i64 %max_capacity.arg, ptr %max_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 current_tokens, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_1, label %fall_2
fall_2:
  store i64 429, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  store i64 200, ptr %t4.slot, align 8
  %r5 = load i64, ptr %t4.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @handle_route(i64 %req.arg) #0 {
entry:
  %req.slot = alloca i64, align 8
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
  store i64 %req.arg, ptr %req.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = req[%t1]
  store i64 101, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %match_case_0_3, label %fall_2
fall_2:
  store i64 3, ptr %t6.slot, align 8
  store i64 0, ptr %t7.slot, align 8
  ; %t5:HttpResponse = alloc_array(%t6, init=%t7)
  store i64 200, ptr %t8.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t5[%t9] = %t8  ; i64
  store i64 18, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t5[%t11] = %t10  ; i64
  store i64 1, ptr %t12.slot, align 8
  store i64 2, ptr %t13.slot, align 8
  ; %t5[%t13] = %t12  ; i64
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %match_end_2
dead_r4:
  br label %match_case_0_3
match_case_0_3:
  store i64 102, ptr %t14.slot, align 8
  ; %t15:bool = cmp_eq_i64 %t2, %t14
  %r5 = load i64, ptr %t15.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %match_case_1_4, label %fall_6
fall_6:
  store i64 3, ptr %t16.slot, align 8
  ; %t17:i64 = req[%t16]
  store i64 0, ptr %t18.slot, align 8
  ; %t19:bool = cmp_eq_i64 %t17, %t18
  %r7 = load i64, ptr %t19.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_5, label %fall_8
fall_8:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:HttpResponse = alloc_array(%t21, init=%t22)
  store i64 401, ptr %t23.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t20[%t24] = %t23  ; i64
  store i64 26, ptr %t25.slot, align 8
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = %t25  ; i64
  store i64 2, ptr %t27.slot, align 8
  store i64 2, ptr %t28.slot, align 8
  ; %t20[%t28] = %t27  ; i64
  %r9 = load i64, ptr %t20.slot, align 8
  ret i64 %r9
ret_cont_9:
  br label %if_end_5
dead_r10:
  br label %if_end_5
if_end_5:
  store i64 3, ptr %t30.slot, align 8
  store i64 0, ptr %t31.slot, align 8
  ; %t29:HttpResponse = alloc_array(%t30, init=%t31)
  store i64 200, ptr %t32.slot, align 8
  store i64 0, ptr %t33.slot, align 8
  ; %t29[%t33] = %t32  ; i64
  store i64 1024, ptr %t34.slot, align 8
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = %t34  ; i64
  store i64 8, ptr %t36.slot, align 8
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; i64
  %r11 = load i64, ptr %t29.slot, align 8
  ret i64 %r11
ret_cont_11:
  br label %match_end_2
dead_r12:
  br label %match_case_1_4
match_case_1_4:
  store i64 103, ptr %t38.slot, align 8
  ; %t39:bool = cmp_eq_i64 %t2, %t38
  %r13 = load i64, ptr %t39.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %match_case_2_6, label %fall_14
fall_14:
  store i64 3, ptr %t41.slot, align 8
  store i64 0, ptr %t42.slot, align 8
  ; %t40:HttpResponse = alloc_array(%t41, init=%t42)
  store i64 201, ptr %t43.slot, align 8
  store i64 0, ptr %t44.slot, align 8
  ; %t40[%t44] = %t43  ; i64
  store i64 512, ptr %t45.slot, align 8
  store i64 1, ptr %t46.slot, align 8
  ; %t40[%t46] = %t45  ; i64
  store i64 12, ptr %t47.slot, align 8
  store i64 2, ptr %t48.slot, align 8
  ; %t40[%t48] = %t47  ; i64
  %r15 = load i64, ptr %t40.slot, align 8
  ret i64 %r15
ret_cont_15:
  br label %match_end_2
dead_r16:
  br label %match_case_2_6
match_case_2_6:
  store i64 3, ptr %t50.slot, align 8
  store i64 0, ptr %t51.slot, align 8
  ; %t49:HttpResponse = alloc_array(%t50, init=%t51)
  store i64 404, ptr %t52.slot, align 8
  store i64 0, ptr %t53.slot, align 8
  ; %t49[%t53] = %t52  ; i64
  store i64 22, ptr %t54.slot, align 8
  store i64 1, ptr %t55.slot, align 8
  ; %t49[%t55] = %t54  ; i64
  store i64 1, ptr %t56.slot, align 8
  store i64 2, ptr %t57.slot, align 8
  ; %t49[%t57] = %t56  ; i64
  %r17 = load i64, ptr %t49.slot, align 8
  ret i64 %r17
ret_cont_17:
  br label %match_end_2
dead_r18:
  br label %match_case_3_7
match_case_3_7:
  br label %match_end_2
match_end_2:
  store i64 0, ptr %t58.slot, align 8
  %r19 = load i64, ptr %t58.slot, align 8
  ret i64 %r19
ret_cont_19:
  ret i64 0
}

define dso_local i64 @benchmark_edge_throughput(i64 %requests_to_serve.arg) #0 {
entry:
  %requests_to_serve.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %ok_count.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %token_pool.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %route.slot = alloca i64, align 8
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
  %req.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  store i64 %requests_to_serve.arg, ptr %requests_to_serve.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %ok_count.slot, align 8
  store i64 1000000, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %token_pool.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  store i64 1, ptr %t4.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %i.slot, align 8
  br label %for_cond_8
for_cond_8:
  ; %t5:bool = cmp_le_i64 i, requests_to_serve
  %r4 = load i64, ptr %t5.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %for_end_10, label %fall_5
fall_5:
  store i64 101, ptr %t6.slot, align 8
  store i64 4, ptr %t7.slot, align 8
  ; %t8:i64 = mod_i64 i, %t7
  ; %t9:i64 = add_i64 %t6, %t8
  %r6 = load i64, ptr %t9.slot, align 8
  store i64 %r6, ptr %route.slot, align 8
  store i64 4, ptr %t11.slot, align 8
  store i64 0, ptr %t12.slot, align 8
  ; %t10:HttpRequest = alloc_array(%t11, init=%t12)
  store i64 1, ptr %t13.slot, align 8
  store i64 0, ptr %t14.slot, align 8
  ; %t10[%t14] = %t13  ; i64
  store i64 1, ptr %t15.slot, align 8
  ; %t10[%t15] = route  ; i64
  store i64 64, ptr %t16.slot, align 8
  store i64 2, ptr %t17.slot, align 8
  ; %t10[%t17] = %t16  ; i64
  store i64 2, ptr %t18.slot, align 8
  ; %t19:i64 = mod_i64 i, %t18
  store i64 3, ptr %t20.slot, align 8
  ; %t10[%t20] = %t19  ; i64
  %r7 = load i64, ptr %t10.slot, align 8
  store i64 %r7, ptr %req.slot, align 8
  ; %t21:HttpResponse = call handle_route(req)
  %r8 = load i64, ptr %t21.slot, align 8
  store i64 %r8, ptr %res.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t23:i64 = res[%t22]
  store i64 200, ptr %t24.slot, align 8
  ; %t25:bool = cmp_eq_i64 %t23, %t24
  %r9 = load i64, ptr %t25.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_11, label %fall_10
fall_10:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 ok_count, %t26
  %r11 = load i64, ptr %t27.slot, align 8
  store i64 %r11, ptr %ok_count.slot, align 8
  br label %if_end_11
dead_r12:
  br label %if_end_11
if_end_11:
  br label %for_step_9
for_step_9:
  ; %t28:i64 = add_i64 i, %t4
  %r13 = load i64, ptr %t28.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %for_cond_8
dead_r14:
  br label %for_end_10
for_end_10:
  %r15 = load i64, ptr %ok_count.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %successful.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
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
  ; %t5:str = const_str 3
  ; print(%t5:str)
  ; %t6:str = const_str 4
  ; print(%t6:str)
  ; %t7:str = const_str 5
  ; print(%t7:str)
  ; %t8:str = const_str 6
  ; print(%t8:str)
  store i64 1000000, ptr %t9.slot, align 8
  %r1 = load i64, ptr %t9.slot, align 8
  store i64 %r1, ptr %n.slot, align 8
  ; %t10:i64 = call benchmark_edge_throughput(n)
  %r2 = load i64, ptr %t10.slot, align 8
  store i64 %r2, ptr %successful.slot, align 8
  ; %t11:str = const_str 7
  ; print(%t11:str, n:i64)
  ; %t12:str = const_str 8
  ; print(%t12:str, successful:i64)
  ; %t13:str = const_str 9
  ; print(%t13:str)
  ; %t14:str = const_str 0
  ; print(%t14:str)
  store i64 0, ptr %t15.slot, align 8
  %r3 = load i64, ptr %t15.slot, align 8
  ret i64 %r3
ret_cont_3:
  ret i64 0
}
