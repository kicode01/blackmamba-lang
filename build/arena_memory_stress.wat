(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $compute_local_step (export "compute_local_step") (param $iter_id i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $t_t7 i64)
    (local $t_t8 f64)
    (local $t_t9 i64)
    (local $t_t10 f64)
    (local $t_t11 i64)
    (local $p i64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 i64)
    (local $t_t18 f64)
    (local $t_t19 i64)
    (local $t_t20 f64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $t_arena_sp_compute_local_step i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_compute_local_step:i64 = arena_save None
    ;; %t2:i64 = const_i64 4
    ;; %t3:i64 = const_i64 0
    ;; %t1:Particle = alloc_array(%t2, init=%t3)
    ;; %t4:f64 = const_f64 1.5
    ;; %t5:i64 = const_i64 0
    ;; %t1[%t5] = %t4  ; f64
    ;; %t6:f64 = const_f64 2.5
    ;; %t7:i64 = const_i64 1
    ;; %t1[%t7] = %t6  ; f64
    ;; %t8:f64 = const_f64 3.5
    ;; %t9:i64 = const_i64 2
    ;; %t1[%t9] = %t8  ; f64
    ;; %t10:f64 = const_f64 4.5
    ;; %t11:i64 = const_i64 3
    ;; %t1[%t11] = %t10  ; f64
    ;; p:Particle = mov %t1
    ;; %t12:i64 = const_i64 0
    ;; %t13:f64 = p[%t12]
    ;; %t14:i64 = const_i64 2
    ;; %t15:f64 = p[%t14]
    ;; %t16:f64 = mul_f64 %t13, %t15
    ;; %t17:i64 = const_i64 1
    ;; %t18:f64 = p[%t17]
    ;; %t19:i64 = const_i64 3
    ;; %t20:f64 = p[%t19]
    ;; %t21:f64 = mul_f64 %t18, %t20
    ;; %t22:f64 = add_f64 %t16, %t21
    ;; arena_restore %arena_sp_compute_local_step
    ;; ret %t22
    (f64.const 0.0)
  )
  (func $stress_test (export "stress_test") (param $iterations i64) (result f64)
    (local $t_t1 f64)
    (local $total f64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $i i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; total:f64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_1:
    ;; %t4:bool = cmp_le_i64 i, iterations
    ;; jz %t4, .for_end_3
    ;; %t5:f64 = call compute_local_step(i)
    ;; %t6:f64 = add_f64 total, %t5
    ;; total:f64 = mov %t6
    ;; .for_step_2:
    ;; %t7:i64 = add_i64 i, %t3
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_1
    ;; .for_end_3:
    ;; ret total
    (f64.const 0.0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $n i64)
    (local $t_t6 f64)
    (local $res f64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
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
    ;; %t5:i64 = const_i64 1000000
    ;; n:i64 = mov %t5
    ;; %t6:f64 = call stress_test(n)
    ;; res:f64 = mov %t6
    ;; %t7:str = const_str 3
    ;; print(%t7:str, n:i64)
    ;; %t8:str = const_str 4
    ;; print(%t8:str, res:f64)
    ;; %t9:str = const_str 5
    ;; print(%t9:str)
    ;; %t10:str = const_str 6
    ;; print(%t10:str)
    ;; %t11:str = const_str 0
    ;; print(%t11:str)
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    (i64.const 0)
  )
)