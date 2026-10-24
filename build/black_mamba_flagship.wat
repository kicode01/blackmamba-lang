(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $Vec3__norm_sq (export "Vec3__norm_sq") (param $self i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 f64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $t_t11 f64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:f64 = self[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:f64 = self[%t3]
    ;; %t5:f64 = mul_f64 %t2, %t4
    ;; %t6:i64 = const_i64 1
    ;; %t7:f64 = self[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:f64 = self[%t8]
    ;; %t10:f64 = mul_f64 %t7, %t9
    ;; %t11:f64 = add_f64 %t5, %t10
    ;; %t12:i64 = const_i64 2
    ;; %t13:f64 = self[%t12]
    ;; %t14:i64 = const_i64 2
    ;; %t15:f64 = self[%t14]
    ;; %t16:f64 = mul_f64 %t13, %t15
    ;; %t17:f64 = add_f64 %t11, %t16
    ;; ret %t17
    (f64.const 0.0)
  )
  (func $distance_3d (export "distance_3d") (param $v1 i64) (param $v2 i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 f64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $dx f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $dy f64)
    (local $t_t11 i64)
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $dz f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $t_t18 f64)
    (local $t_t19 f64)
    (local $t_t20 f64)
    (local $t_t21 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:f64 = v1[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:f64 = v2[%t3]
    ;; %t5:f64 = sub_f64 %t2, %t4
    ;; dx:f64 = mov %t5
    ;; %t6:i64 = const_i64 1
    ;; %t7:f64 = v1[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:f64 = v2[%t8]
    ;; %t10:f64 = sub_f64 %t7, %t9
    ;; dy:f64 = mov %t10
    ;; %t11:i64 = const_i64 2
    ;; %t12:f64 = v1[%t11]
    ;; %t13:i64 = const_i64 2
    ;; %t14:f64 = v2[%t13]
    ;; %t15:f64 = sub_f64 %t12, %t14
    ;; dz:f64 = mov %t15
    ;; %t16:f64 = mul_f64 dx, dx
    ;; %t17:f64 = mul_f64 dy, dy
    ;; %t18:f64 = add_f64 %t16, %t17
    ;; %t19:f64 = mul_f64 dz, dz
    ;; %t20:f64 = add_f64 %t18, %t19
    ;; %t21:f64 = sqrt_f64 %t20
    ;; ret %t21
    (f64.const 0.0)
  )
  (func $is_prime (export "is_prime") (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $d i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:bool = cmp_le_i64 n, %t1
    ;; jz %t2, .if_end_1
    ;; %t3:bool = const_i64 0
    ;; ret %t3
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t4:i64 = const_i64 2
    ;; d:i64 = mov %t4
    ;; .while_cond_2:
    ;; %t5:i64 = mul_i64 d, d
    ;; %t6:bool = cmp_le_i64 %t5, n
    ;; jz %t6, .while_end_3
    ;; %t7:i64 = mod_i64 n, d
    ;; %t8:i64 = const_i64 0
    ;; %t9:bool = cmp_eq_i64 %t7, %t8
    ;; jz %t9, .if_end_4
    ;; %t10:bool = const_i64 0
    ;; ret %t10
    ;; jmp .if_end_4
    ;; .if_end_4:
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = add_i64 d, %t11
    ;; d:i64 = mov %t12
    ;; jmp .while_cond_2
    ;; .while_end_3:
    ;; %t13:bool = const_i64 1
    ;; ret %t13
    (i64.const 0)
  )
  (func $count_primes_in_range (export "count_primes_in_range") (param $low i64) (param $high i64) (result i64)
    (local $t_t1 i64)
    (local $count i64)
    (local $t_t2 i64)
    (local $n i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; count:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; n:i64 = mov low
    ;; .for_cond_5:
    ;; %t3:bool = cmp_le_i64 n, high
    ;; jz %t3, .for_end_7
    ;; %t4:bool = call is_prime(n)
    ;; jz %t4, .if_end_8
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = add_i64 count, %t5
    ;; count:i64 = mov %t6
    ;; jmp .if_end_8
    ;; .if_end_8:
    ;; .for_step_6:
    ;; %t7:i64 = add_i64 n, %t2
    ;; n:i64 = mov %t7
    ;; jmp .for_cond_5
    ;; .for_end_7:
    ;; ret count
    (i64.const 0)
  )
  (func $step_double (export "step_double") (param $x i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = mul_i64 x, %t1
    ;; ret %t2
    (i64.const 0)
  )
  (func $step_add_const (export "step_add_const") (param $x i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 42
    ;; %t2:i64 = add_i64 x, %t1
    ;; ret %t2
    (i64.const 0)
  )
  (func $step_square (export "step_square") (param $x i64) (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = mul_i64 x, x
    ;; ret %t1
    (i64.const 0)
  )
  (func $evaluate_status_code (export "evaluate_status_code") (param $code i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 200
    ;; %t2:bool = cmp_eq_i64 code, %t1
    ;; jz %t2, .match_case_0_10
    ;; %t3:str = const_str 0
    ;; ret %t3
    ;; jmp .match_end_9
    ;; .match_case_0_10:
    ;; %t4:i64 = const_i64 201
    ;; %t5:bool = cmp_eq_i64 code, %t4
    ;; jz %t5, .match_case_1_11
    ;; %t6:str = const_str 1
    ;; ret %t6
    ;; jmp .match_end_9
    ;; .match_case_1_11:
    ;; %t7:i64 = const_i64 404
    ;; %t8:bool = cmp_eq_i64 code, %t7
    ;; jz %t8, .match_case_2_12
    ;; %t9:str = const_str 2
    ;; ret %t9
    ;; jmp .match_end_9
    ;; .match_case_2_12:
    ;; %t10:str = const_str 3
    ;; ret %t10
    ;; jmp .match_end_9
    ;; .match_case_3_13:
    ;; .match_end_9:
    ;; %t11:str = const_i64 0
    ;; ret %t11
    (i64.const 0)
  )
  (func $tail_accumulator (export "tail_accumulator") (param $n i64) (param $acc i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_tco_10_0 i64)
    (local $t_tco_10_1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 n, %t1
    ;; jz %t2, .if_end_14
    ;; ret acc
    ;; jmp .if_end_14
    ;; .if_end_14:
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 n, %t3
    ;; %t5:i64 = add_i64 acc, n
    ;; %tco_10_0:i64 = mov %t4
    ;; %tco_10_1:i64 = mov %t5
    ;; n:i64 = mov %tco_10_0
    ;; acc:i64 = mov %tco_10_1
    ;; jmp __tco_entry
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 i64)
    (local $p1 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 f64)
    (local $t_t17 i64)
    (local $t_t18 f64)
    (local $t_t19 i64)
    (local $t_t20 f64)
    (local $t_t21 i64)
    (local $p2 i64)
    (local $t_t22 f64)
    (local $dist f64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $prime_limit i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $primes_found i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $pipe_val i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $status i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $tco_sum i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 4
    ;; print(%t1:str)
    ;; %t2:str = const_str 5
    ;; print(%t2:str)
    ;; %t3:str = const_str 4
    ;; print(%t3:str)
    ;; %t5:i64 = const_i64 3
    ;; %t6:i64 = const_i64 0
    ;; %t4:Vec3 = alloc_array(%t5, init=%t6)
    ;; %t7:f64 = const_f64 0.0
    ;; %t8:i64 = const_i64 0
    ;; %t4[%t8] = %t7  ; f64
    ;; %t9:f64 = const_f64 3.0
    ;; %t10:i64 = const_i64 1
    ;; %t4[%t10] = %t9  ; f64
    ;; %t11:f64 = const_f64 4.0
    ;; %t12:i64 = const_i64 2
    ;; %t4[%t12] = %t11  ; f64
    ;; p1:Vec3 = mov %t4
    ;; %t14:i64 = const_i64 3
    ;; %t15:i64 = const_i64 0
    ;; %t13:Vec3 = alloc_array(%t14, init=%t15)
    ;; %t16:f64 = const_f64 3.0
    ;; %t17:i64 = const_i64 0
    ;; %t13[%t17] = %t16  ; f64
    ;; %t18:f64 = const_f64 7.0
    ;; %t19:i64 = const_i64 1
    ;; %t13[%t19] = %t18  ; f64
    ;; %t20:f64 = const_f64 4.0
    ;; %t21:i64 = const_i64 2
    ;; %t13[%t21] = %t20  ; f64
    ;; p2:Vec3 = mov %t13
    ;; %t22:f64 = call distance_3d(p1, p2)
    ;; dist:f64 = mov %t22
    ;; %t23:str = const_str 6
    ;; print(%t23:str, dist:f64)
    ;; %t24:i64 = const_i64 10000
    ;; prime_limit:i64 = mov %t24
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = call count_primes_in_range(%t25, prime_limit)
    ;; primes_found:i64 = mov %t26
    ;; %t27:str = const_str 7
    ;; %t28:str = const_str 8
    ;; print(%t27:str, prime_limit:i64, %t28:str, primes_found:i64)
    ;; %t29:i64 = const_i64 7
    ;; %t30:i64 = call step_double(%t29)
    ;; %t31:i64 = call step_add_const(%t30)
    ;; %t32:i64 = call step_square(%t31)
    ;; pipe_val:i64 = mov %t32
    ;; %t33:str = const_str 9
    ;; print(%t33:str, pipe_val:i64)
    ;; %t34:i64 = const_i64 200
    ;; %t35:str = call evaluate_status_code(%t34)
    ;; status:str = mov %t35
    ;; %t36:str = const_str 10
    ;; print(%t36:str, status:str)
    ;; %t37:i64 = const_i64 1000000
    ;; %t38:i64 = const_i64 0
    ;; %t39:i64 = call tail_accumulator(%t37, %t38)
    ;; tco_sum:i64 = mov %t39
    ;; %t40:str = const_str 11
    ;; print(%t40:str, tco_sum:i64)
    ;; %t41:str = const_str 4
    ;; print(%t41:str)
    ;; %t42:str = const_str 12
    ;; print(%t42:str)
    ;; %t43:str = const_str 4
    ;; print(%t43:str)
    ;; %t44:i64 = const_i64 0
    ;; ret %t44
    (i64.const 0)
  )
)