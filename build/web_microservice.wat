(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $check_rate_limit (export "check_rate_limit") (param $client_id i64) (param $current_tokens i64) (param $max_capacity i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 current_tokens, %t1
    ;; jz %t2, .if_end_1
    ;; %t3:i64 = const_i64 429
    ;; ret %t3
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t4:i64 = const_i64 200
    ;; ret %t4
    (i64.const 0)
  )
  (func $handle_route (export "handle_route") (param $req i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $t_t46 i64)
    (local $t_t47 i64)
    (local $t_t48 i64)
    (local $t_t49 i64)
    (local $t_t50 i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $t_t53 i64)
    (local $t_t54 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = req[%t1]
    ;; %t3:i64 = const_i64 101
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; jz %t4, .match_case_0_3
    ;; %t6:i64 = const_i64 3
    ;; %t7:i64 = const_i64 0
    ;; %t5:HttpResponse = alloc_array(%t6, init=%t7)
    ;; %t8:i64 = const_i64 200
    ;; %t9:i64 = const_i64 0
    ;; %t5[%t9] = %t8  ; i64
    ;; %t10:i64 = const_i64 18
    ;; %t11:i64 = const_i64 1
    ;; %t5[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = const_i64 2
    ;; %t5[%t13] = %t12  ; i64
    ;; ret %t5
    ;; jmp .match_end_2
    ;; .match_case_0_3:
    ;; %t14:i64 = const_i64 102
    ;; %t15:bool = cmp_eq_i64 %t2, %t14
    ;; jz %t15, .match_case_1_4
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = req[%t16]
    ;; %t18:i64 = const_i64 0
    ;; %t19:bool = cmp_eq_i64 %t17, %t18
    ;; jz %t19, .if_end_5
    ;; %t21:i64 = const_i64 3
    ;; %t22:i64 = const_i64 0
    ;; %t20:HttpResponse = alloc_array(%t21, init=%t22)
    ;; %t23:i64 = const_i64 401
    ;; %t24:i64 = const_i64 0
    ;; %t20[%t24] = %t23  ; i64
    ;; %t25:i64 = const_i64 26
    ;; %t26:i64 = const_i64 1
    ;; %t20[%t26] = %t25  ; i64
    ;; %t27:i64 = const_i64 2
    ;; %t28:i64 = const_i64 2
    ;; %t20[%t28] = %t27  ; i64
    ;; ret %t20
    ;; jmp .if_end_5
    ;; .if_end_5:
    ;; %t30:i64 = const_i64 3
    ;; %t31:i64 = const_i64 0
    ;; %t29:HttpResponse = alloc_array(%t30, init=%t31)
    ;; %t32:i64 = const_i64 200
    ;; %t33:i64 = const_i64 0
    ;; %t29[%t33] = %t32  ; i64
    ;; %t34:i64 = const_i64 1024
    ;; %t35:i64 = const_i64 1
    ;; %t29[%t35] = %t34  ; i64
    ;; %t36:i64 = const_i64 8
    ;; %t37:i64 = const_i64 2
    ;; %t29[%t37] = %t36  ; i64
    ;; ret %t29
    ;; jmp .match_end_2
    ;; .match_case_1_4:
    ;; %t38:i64 = const_i64 103
    ;; %t39:bool = cmp_eq_i64 %t2, %t38
    ;; jz %t39, .match_case_2_6
    ;; %t41:i64 = const_i64 3
    ;; %t42:i64 = const_i64 0
    ;; %t40:HttpResponse = alloc_array(%t41, init=%t42)
    ;; %t43:i64 = const_i64 201
    ;; %t44:i64 = const_i64 0
    ;; %t40[%t44] = %t43  ; i64
    ;; %t45:i64 = const_i64 512
    ;; %t46:i64 = const_i64 1
    ;; %t40[%t46] = %t45  ; i64
    ;; %t47:i64 = const_i64 12
    ;; %t48:i64 = const_i64 2
    ;; %t40[%t48] = %t47  ; i64
    ;; ret %t40
    ;; jmp .match_end_2
    ;; .match_case_2_6:
    ;; %t50:i64 = const_i64 3
    ;; %t51:i64 = const_i64 0
    ;; %t49:HttpResponse = alloc_array(%t50, init=%t51)
    ;; %t52:i64 = const_i64 404
    ;; %t53:i64 = const_i64 0
    ;; %t49[%t53] = %t52  ; i64
    ;; %t54:i64 = const_i64 22
    ;; %t55:i64 = const_i64 1
    ;; %t49[%t55] = %t54  ; i64
    ;; %t56:i64 = const_i64 1
    ;; %t57:i64 = const_i64 2
    ;; %t49[%t57] = %t56  ; i64
    ;; ret %t49
    ;; jmp .match_end_2
    ;; .match_case_3_7:
    ;; .match_end_2:
    ;; %t58:HttpResponse = const_i64 0
    ;; ret %t58
    (i64.const 0)
  )
  (func $benchmark_edge_throughput (export "benchmark_edge_throughput") (param $requests_to_serve i64) (result i64)
    (local $t_t1 i64)
    (local $ok_count i64)
    (local $t_t2 i64)
    (local $token_pool i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $route i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $req i64)
    (local $t_t21 i64)
    (local $res i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; ok_count:i64 = mov %t1
    ;; %t2:i64 = const_i64 1000000
    ;; token_pool:i64 = mov %t2
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = const_i64 1
    ;; i:i64 = mov %t3
    ;; .for_cond_8:
    ;; %t5:bool = cmp_le_i64 i, requests_to_serve
    ;; jz %t5, .for_end_10
    ;; %t6:i64 = const_i64 101
    ;; %t7:i64 = const_i64 4
    ;; %t8:i64 = mod_i64 i, %t7
    ;; %t9:i64 = add_i64 %t6, %t8
    ;; route:i64 = mov %t9
    ;; %t11:i64 = const_i64 4
    ;; %t12:i64 = const_i64 0
    ;; %t10:HttpRequest = alloc_array(%t11, init=%t12)
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = const_i64 0
    ;; %t10[%t14] = %t13  ; i64
    ;; %t15:i64 = const_i64 1
    ;; %t10[%t15] = route  ; i64
    ;; %t16:i64 = const_i64 64
    ;; %t17:i64 = const_i64 2
    ;; %t10[%t17] = %t16  ; i64
    ;; %t18:i64 = const_i64 2
    ;; %t19:i64 = mod_i64 i, %t18
    ;; %t20:i64 = const_i64 3
    ;; %t10[%t20] = %t19  ; i64
    ;; req:HttpRequest = mov %t10
    ;; %t21:HttpResponse = call handle_route(req)
    ;; res:HttpResponse = mov %t21
    ;; %t22:i64 = const_i64 0
    ;; %t23:i64 = res[%t22]
    ;; %t24:i64 = const_i64 200
    ;; %t25:bool = cmp_eq_i64 %t23, %t24
    ;; jz %t25, .if_end_11
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 ok_count, %t26
    ;; ok_count:i64 = mov %t27
    ;; jmp .if_end_11
    ;; .if_end_11:
    ;; .for_step_9:
    ;; %t28:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t28
    ;; jmp .for_cond_8
    ;; .for_end_10:
    ;; ret ok_count
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $n i64)
    (local $t_t10 i64)
    (local $successful i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:str = const_str 1
    ;; print(%t2:str)
    ;; %t3:str = const_str 0
    ;; print(%t3:str)
    ;; %t4:str = const_str 2
    ;; print(%t4:str)
    ;; %t5:str = const_str 3
    ;; print(%t5:str)
    ;; %t6:str = const_str 4
    ;; print(%t6:str)
    ;; %t7:str = const_str 5
    ;; print(%t7:str)
    ;; %t8:str = const_str 6
    ;; print(%t8:str)
    ;; %t9:i64 = const_i64 1000000
    ;; n:i64 = mov %t9
    ;; %t10:i64 = call benchmark_edge_throughput(n)
    ;; successful:i64 = mov %t10
    ;; %t11:str = const_str 7
    ;; print(%t11:str, n:i64)
    ;; %t12:str = const_str 8
    ;; print(%t12:str, successful:i64)
    ;; %t13:str = const_str 9
    ;; print(%t13:str)
    ;; %t14:str = const_str 0
    ;; print(%t14:str)
    ;; %t15:i64 = const_i64 0
    ;; ret %t15
    (i64.const 0)
  )
)