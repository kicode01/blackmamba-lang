(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $str_contains (export "str_contains") (param $haystack i64) (param $needle i64) (result i64)
    (local $t_t1 i64)
    (local $h_len i64)
    (local $t_t2 i64)
    (local $n_len i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $limit i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $i i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_arena_sp_str_contains i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_str_contains:i64 = arena_save None
    ;; %t1:i64 = str_len(haystack)
    ;; h_len:i64 = mov %t1
    ;; %t2:i64 = str_len(needle)
    ;; n_len:i64 = mov %t2
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 n_len, %t3
    ;; jz %t4, .if_end_1
    ;; %t5:bool = const_i64 1
    ;; arena_restore %arena_sp_str_contains
    ;; ret %t5
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t6:bool = cmp_gt_i64 n_len, h_len
    ;; jz %t6, .if_end_2
    ;; %t7:bool = const_i64 0
    ;; arena_restore %arena_sp_str_contains
    ;; ret %t7
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; %t8:i64 = sub_i64 h_len, n_len
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; limit:i64 = mov %t10
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = const_i64 1
    ;; i:i64 = mov %t11
    ;; .for_cond_3:
    ;; %t13:bool = cmp_lt_i64 i, limit
    ;; jz %t13, .for_end_5
    ;; %t14:i64 = add_i64 i, n_len
    ;; %t15:str = str_slice(haystack[i:%t14])
    ;; %t16:bool = str_cmp_eq %t15, needle
    ;; jz %t16, .if_end_6
    ;; %t17:bool = const_i64 1
    ;; arena_restore %arena_sp_str_contains
    ;; ret %t17
    ;; jmp .if_end_6
    ;; .if_end_6:
    ;; .for_step_4:
    ;; %t18:i64 = add_i64 i, %t12
    ;; i:i64 = mov %t18
    ;; jmp .for_cond_3
    ;; .for_end_5:
    ;; %t19:bool = const_i64 0
    ;; arena_restore %arena_sp_str_contains
    ;; ret %t19
    (i64.const 0)
  )
  (func $abs_f64 (export "abs_f64") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; %t2:bool = cmp_lt_f64 x, %t1
    ;; jz %t2, .if_end_7
    ;; %t3:f64 = const_f64 0.0
    ;; %t4:f64 = sub_f64 %t3, x
    ;; ret %t4
    ;; jmp .if_end_7
    ;; .if_end_7:
    ;; ret x
    (f64.const 0.0)
  )
  (func $test_runner_new (export "test_runner_new") (param $verbose i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t2:i64 = const_i64 8
    ;; %t3:i64 = const_i64 0
    ;; %t1:TestRunner = alloc_array(%t2, init=%t3)
    ;; %t4:i64 = const_i64 0
    ;; %t5:i64 = const_i64 0
    ;; %t1[%t5] = %t4  ; i64
    ;; %t6:i64 = const_i64 0
    ;; %t7:i64 = const_i64 1
    ;; %t1[%t7] = %t6  ; i64
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = const_i64 2
    ;; %t1[%t9] = %t8  ; i64
    ;; %t10:str = const_str 0
    ;; %t11:i64 = const_i64 3
    ;; %t1[%t11] = %t10  ; str
    ;; %t12:str = const_str 0
    ;; %t13:i64 = const_i64 4
    ;; %t1[%t13] = %t12  ; str
    ;; %t14:i64 = const_i64 0
    ;; %t15:i64 = const_i64 5
    ;; %t1[%t15] = %t14  ; i64
    ;; %t16:i64 = clock_ns None
    ;; %t17:i64 = const_i64 6
    ;; %t1[%t17] = %t16  ; i64
    ;; %t18:i64 = const_i64 7
    ;; %t1[%t18] = verbose  ; bool
    ;; ret %t1
    (i64.const 0)
  )
  (func $test_suite (export "test_suite") (param $runner i64) (param $name i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 3
    ;; runner[%t1] = name  ; str
    ;; %t2:i64 = const_i64 5
    ;; %t3:i64 = runner[%t2]
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = add_i64 %t3, %t4
    ;; %t6:i64 = const_i64 5
    ;; runner[%t6] = %t5  ; i64
    ;; %t7:i64 = const_i64 7
    ;; %t8:bool = runner[%t7]
    ;; jz %t8, .if_end_8
    ;; %t9:str = const_str 1
    ;; print(%t9:str)
    ;; %t10:str = const_str 2
    ;; %t11:str = str_concat(%t10, name)
    ;; %t12:str = const_str 3
    ;; %t13:str = str_concat(%t11, %t12)
    ;; print(%t13:str)
    ;; jmp .if_end_8
    ;; .if_end_8:
    ;; %t14:i64 = const_i64 0
    ;; ret %t14
    (i64.const 0)
  )
  (func $test_case (export "test_case") (param $runner i64) (param $name i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 4
    ;; runner[%t1] = name  ; str
    ;; %t2:i64 = const_i64 7
    ;; %t3:bool = runner[%t2]
    ;; jz %t3, .if_end_9
    ;; %t4:str = const_str 4
    ;; %t5:str = str_concat(%t4, name)
    ;; %t6:str = const_str 5
    ;; %t7:str = str_concat(%t5, %t6)
    ;; print(%t7:str)
    ;; jmp .if_end_9
    ;; .if_end_9:
    ;; %t8:i64 = const_i64 0
    ;; ret %t8
    (i64.const 0)
  )
  (func $assert_true (export "assert_true") (param $r i64) (param $cond i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; jz cond, .if_next_11
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = r[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = add_i64 %t7, %t8
    ;; %t10:i64 = const_i64 1
    ;; r[%t10] = %t9  ; i64
    ;; %t11:i64 = const_i64 7
    ;; %t12:bool = r[%t11]
    ;; jz %t12, .if_end_12
    ;; %t13:str = const_str 6
    ;; %t14:str = str_concat(%t13, msg)
    ;; print(%t14:str)
    ;; jmp .if_end_12
    ;; .if_end_12:
    ;; %t15:bool = const_i64 1
    ;; ret %t15
    ;; jmp .if_end_10
    ;; .if_next_11:
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = r[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = add_i64 %t17, %t18
    ;; %t20:i64 = const_i64 2
    ;; r[%t20] = %t19  ; i64
    ;; %t21:str = const_str 7
    ;; %t22:i64 = const_i64 3
    ;; %t23:str = r[%t22]
    ;; %t24:str = str_concat(%t21, %t23)
    ;; %t25:str = const_str 8
    ;; %t26:str = str_concat(%t24, %t25)
    ;; %t27:i64 = const_i64 4
    ;; %t28:str = r[%t27]
    ;; %t29:str = str_concat(%t26, %t28)
    ;; %t30:str = const_str 9
    ;; %t31:str = str_concat(%t29, %t30)
    ;; %t32:str = str_concat(%t31, msg)
    ;; print(%t32:str)
    ;; %t33:str = const_str 10
    ;; print(%t33:str)
    ;; %t34:bool = const_i64 0
    ;; ret %t34
    ;; .if_end_10:
    ;; %t35:bool = const_i64 0
    ;; ret %t35
    (i64.const 0)
  )
  (func $assert_false (export "assert_false") (param $r i64) (param $cond i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t7:i64 = const_i64 0
    ;; %t6:bool = cmp_eq_i64 cond, %t7
    ;; jz %t6, .if_next_14
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = r[%t8]
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = add_i64 %t9, %t10
    ;; %t12:i64 = const_i64 1
    ;; r[%t12] = %t11  ; i64
    ;; %t13:i64 = const_i64 7
    ;; %t14:bool = r[%t13]
    ;; jz %t14, .if_end_15
    ;; %t15:str = const_str 6
    ;; %t16:str = str_concat(%t15, msg)
    ;; print(%t16:str)
    ;; jmp .if_end_15
    ;; .if_end_15:
    ;; %t17:bool = const_i64 1
    ;; ret %t17
    ;; jmp .if_end_13
    ;; .if_next_14:
    ;; %t18:i64 = const_i64 2
    ;; %t19:i64 = r[%t18]
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = add_i64 %t19, %t20
    ;; %t22:i64 = const_i64 2
    ;; r[%t22] = %t21  ; i64
    ;; %t23:str = const_str 7
    ;; %t24:i64 = const_i64 3
    ;; %t25:str = r[%t24]
    ;; %t26:str = str_concat(%t23, %t25)
    ;; %t27:str = const_str 8
    ;; %t28:str = str_concat(%t26, %t27)
    ;; %t29:i64 = const_i64 4
    ;; %t30:str = r[%t29]
    ;; %t31:str = str_concat(%t28, %t30)
    ;; %t32:str = const_str 9
    ;; %t33:str = str_concat(%t31, %t32)
    ;; %t34:str = str_concat(%t33, msg)
    ;; print(%t34:str)
    ;; %t35:str = const_str 11
    ;; print(%t35:str)
    ;; %t36:bool = const_i64 0
    ;; ret %t36
    ;; .if_end_13:
    ;; %t37:bool = const_i64 0
    ;; ret %t37
    (i64.const 0)
  )
  (func $assert_eq_i64 (export "assert_eq_i64") (param $r i64) (param $actual i64) (param $expected i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_eq_i64 actual, expected
    ;; jz %t6, .if_next_17
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_18
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_18
    ;; .if_end_18:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_16
    ;; .if_next_17:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 12
    ;; %t35:str = str_from_i64 expected
    ;; %t36:str = str_concat(%t34, %t35)
    ;; %t37:str = const_str 13
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = str_from_i64 actual
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_16:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_ne_i64 (export "assert_ne_i64") (param $r i64) (param $actual i64) (param $unexpected i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_ne_i64 actual, unexpected
    ;; jz %t6, .if_next_20
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_21
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_21
    ;; .if_end_21:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_19
    ;; .if_next_20:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 14
    ;; %t35:str = str_from_i64 actual
    ;; %t36:str = str_concat(%t34, %t35)
    ;; print(%t36:str)
    ;; %t37:bool = const_i64 0
    ;; ret %t37
    ;; .if_end_19:
    ;; %t38:bool = const_i64 0
    ;; ret %t38
    (i64.const 0)
  )
  (func $assert_lt_i64 (export "assert_lt_i64") (param $r i64) (param $a i64) (param $b i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_lt_i64 a, b
    ;; jz %t6, .if_next_23
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_24
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_24
    ;; .if_end_24:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_22
    ;; .if_next_23:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 15
    ;; %t35:str = str_from_i64 a
    ;; %t36:str = str_concat(%t34, %t35)
    ;; %t37:str = const_str 16
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = str_from_i64 b
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_22:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_le_i64 (export "assert_le_i64") (param $r i64) (param $a i64) (param $b i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_le_i64 a, b
    ;; jz %t6, .if_next_26
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_27
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_27
    ;; .if_end_27:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_25
    ;; .if_next_26:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 15
    ;; %t35:str = str_from_i64 a
    ;; %t36:str = str_concat(%t34, %t35)
    ;; %t37:str = const_str 17
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = str_from_i64 b
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_25:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_gt_i64 (export "assert_gt_i64") (param $r i64) (param $a i64) (param $b i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_gt_i64 a, b
    ;; jz %t6, .if_next_29
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_30
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_30
    ;; .if_end_30:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_28
    ;; .if_next_29:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 15
    ;; %t35:str = str_from_i64 a
    ;; %t36:str = str_concat(%t34, %t35)
    ;; %t37:str = const_str 8
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = str_from_i64 b
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_28:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_ge_i64 (export "assert_ge_i64") (param $r i64) (param $a i64) (param $b i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = cmp_ge_i64 a, b
    ;; jz %t6, .if_next_32
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_33
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_33
    ;; .if_end_33:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_31
    ;; .if_next_32:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 15
    ;; %t35:str = str_from_i64 a
    ;; %t36:str = str_concat(%t34, %t35)
    ;; %t37:str = const_str 18
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = str_from_i64 b
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_31:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_eq_f64 (export "assert_eq_f64") (param $r i64) (param $actual f64) (param $expected f64) (param $eps f64) (param $msg i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $diff f64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:f64 = sub_f64 actual, expected
    ;; %t7:f64 = call abs_f64(%t6)
    ;; diff:f64 = mov %t7
    ;; %t8:bool = cmp_le_f64 diff, eps
    ;; jz %t8, .if_next_35
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = r[%t9]
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = add_i64 %t10, %t11
    ;; %t13:i64 = const_i64 1
    ;; r[%t13] = %t12  ; i64
    ;; %t14:i64 = const_i64 7
    ;; %t15:bool = r[%t14]
    ;; jz %t15, .if_end_36
    ;; %t16:str = const_str 6
    ;; %t17:str = str_concat(%t16, msg)
    ;; print(%t17:str)
    ;; jmp .if_end_36
    ;; .if_end_36:
    ;; %t18:bool = const_i64 1
    ;; ret %t18
    ;; jmp .if_end_34
    ;; .if_next_35:
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = r[%t19]
    ;; %t21:i64 = const_i64 1
    ;; %t22:i64 = add_i64 %t20, %t21
    ;; %t23:i64 = const_i64 2
    ;; r[%t23] = %t22  ; i64
    ;; %t24:str = const_str 7
    ;; %t25:i64 = const_i64 3
    ;; %t26:str = r[%t25]
    ;; %t27:str = str_concat(%t24, %t26)
    ;; %t28:str = const_str 8
    ;; %t29:str = str_concat(%t27, %t28)
    ;; %t30:i64 = const_i64 4
    ;; %t31:str = r[%t30]
    ;; %t32:str = str_concat(%t29, %t31)
    ;; %t33:str = const_str 9
    ;; %t34:str = str_concat(%t32, %t33)
    ;; %t35:str = str_concat(%t34, msg)
    ;; print(%t35:str)
    ;; %t36:str = const_str 12
    ;; %t37:str = str_from_f64 expected
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = const_str 13
    ;; %t40:str = str_concat(%t38, %t39)
    ;; %t41:str = str_from_f64 actual
    ;; %t42:str = str_concat(%t40, %t41)
    ;; %t43:str = const_str 19
    ;; %t44:str = str_concat(%t42, %t43)
    ;; %t45:str = str_from_f64 diff
    ;; %t46:str = str_concat(%t44, %t45)
    ;; %t47:str = const_str 20
    ;; %t48:str = str_concat(%t46, %t47)
    ;; %t49:str = str_from_f64 eps
    ;; %t50:str = str_concat(%t48, %t49)
    ;; %t51:str = const_str 21
    ;; %t52:str = str_concat(%t50, %t51)
    ;; print(%t52:str)
    ;; %t53:bool = const_i64 0
    ;; ret %t53
    ;; .if_end_34:
    ;; %t54:bool = const_i64 0
    ;; ret %t54
    (i64.const 0)
  )
  (func $assert_eq_str (export "assert_eq_str") (param $r i64) (param $actual i64) (param $expected i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = str_cmp_eq actual, expected
    ;; jz %t6, .if_next_38
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_39
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_39
    ;; .if_end_39:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_37
    ;; .if_next_38:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 22
    ;; %t35:str = str_concat(%t34, expected)
    ;; %t36:str = const_str 23
    ;; %t37:str = str_concat(%t35, %t36)
    ;; %t38:str = str_concat(%t37, actual)
    ;; %t39:str = const_str 24
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_37:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $assert_ne_str (export "assert_ne_str") (param $r i64) (param $actual i64) (param $unexpected i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = str_cmp_ne actual, unexpected
    ;; jz %t6, .if_next_41
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_42
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_42
    ;; .if_end_42:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_40
    ;; .if_next_41:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 25
    ;; %t35:str = str_concat(%t34, actual)
    ;; %t36:str = const_str 24
    ;; %t37:str = str_concat(%t35, %t36)
    ;; print(%t37:str)
    ;; %t38:bool = const_i64 0
    ;; ret %t38
    ;; .if_end_40:
    ;; %t39:bool = const_i64 0
    ;; ret %t39
    (i64.const 0)
  )
  (func $assert_str_contains (export "assert_str_contains") (param $r i64) (param $haystack i64) (param $needle i64) (param $msg i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = r[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 0
    ;; r[%t5] = %t4  ; i64
    ;; %t6:bool = call str_contains(haystack, needle)
    ;; jz %t6, .if_next_44
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = r[%t7]
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 %t8, %t9
    ;; %t11:i64 = const_i64 1
    ;; r[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 7
    ;; %t13:bool = r[%t12]
    ;; jz %t13, .if_end_45
    ;; %t14:str = const_str 6
    ;; %t15:str = str_concat(%t14, msg)
    ;; print(%t15:str)
    ;; jmp .if_end_45
    ;; .if_end_45:
    ;; %t16:bool = const_i64 1
    ;; ret %t16
    ;; jmp .if_end_43
    ;; .if_next_44:
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = r[%t17]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = add_i64 %t18, %t19
    ;; %t21:i64 = const_i64 2
    ;; r[%t21] = %t20  ; i64
    ;; %t22:str = const_str 7
    ;; %t23:i64 = const_i64 3
    ;; %t24:str = r[%t23]
    ;; %t25:str = str_concat(%t22, %t24)
    ;; %t26:str = const_str 8
    ;; %t27:str = str_concat(%t25, %t26)
    ;; %t28:i64 = const_i64 4
    ;; %t29:str = r[%t28]
    ;; %t30:str = str_concat(%t27, %t29)
    ;; %t31:str = const_str 9
    ;; %t32:str = str_concat(%t30, %t31)
    ;; %t33:str = str_concat(%t32, msg)
    ;; print(%t33:str)
    ;; %t34:str = const_str 26
    ;; %t35:str = str_concat(%t34, needle)
    ;; %t36:str = const_str 27
    ;; %t37:str = str_concat(%t35, %t36)
    ;; %t38:str = str_concat(%t37, haystack)
    ;; %t39:str = const_str 24
    ;; %t40:str = str_concat(%t38, %t39)
    ;; print(%t40:str)
    ;; %t41:bool = const_i64 0
    ;; ret %t41
    ;; .if_end_43:
    ;; %t42:bool = const_i64 0
    ;; ret %t42
    (i64.const 0)
  )
  (func $test_summary (export "test_summary") (param $runner i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $elapsed_ns i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $elapsed_ms i64)
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
    (local $t_arena_sp_test_summary i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_test_summary:i64 = arena_save None
    ;; %t1:i64 = clock_ns None
    ;; %t2:i64 = const_i64 6
    ;; %t3:i64 = runner[%t2]
    ;; %t4:i64 = sub_i64 %t1, %t3
    ;; elapsed_ns:i64 = mov %t4
    ;; %t5:i64 = const_i64 1000000
    ;; %t6:i64 = div_i64 elapsed_ns, %t5
    ;; elapsed_ms:i64 = mov %t6
    ;; %t7:str = const_str 1
    ;; print(%t7:str)
    ;; %t8:str = const_str 28
    ;; print(%t8:str)
    ;; %t9:str = const_str 29
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = runner[%t10]
    ;; %t12:str = str_from_i64 %t11
    ;; %t13:str = str_concat(%t9, %t12)
    ;; %t14:str = const_str 30
    ;; %t15:str = str_concat(%t13, %t14)
    ;; %t16:i64 = const_i64 0
    ;; %t17:i64 = runner[%t16]
    ;; %t18:str = str_from_i64 %t17
    ;; %t19:str = str_concat(%t15, %t18)
    ;; %t20:str = const_str 31
    ;; %t21:str = str_concat(%t19, %t20)
    ;; %t22:str = str_from_i64 elapsed_ms
    ;; %t23:str = str_concat(%t21, %t22)
    ;; %t24:str = const_str 32
    ;; %t25:str = str_concat(%t23, %t24)
    ;; %t26:i64 = const_i64 5
    ;; %t27:i64 = runner[%t26]
    ;; %t28:str = str_from_i64 %t27
    ;; %t29:str = str_concat(%t25, %t28)
    ;; %t30:str = const_str 33
    ;; %t31:str = str_concat(%t29, %t30)
    ;; print(%t31:str)
    ;; %t32:i64 = const_i64 2
    ;; %t33:i64 = runner[%t32]
    ;; %t34:i64 = const_i64 0
    ;; %t35:bool = cmp_eq_i64 %t33, %t34
    ;; jz %t35, .if_next_47
    ;; %t36:str = const_str 34
    ;; print(%t36:str)
    ;; %t37:i64 = const_i64 0
    ;; arena_restore %arena_sp_test_summary
    ;; ret %t37
    ;; jmp .if_end_46
    ;; .if_next_47:
    ;; %t38:str = const_str 35
    ;; %t39:i64 = const_i64 2
    ;; %t40:i64 = runner[%t39]
    ;; %t41:str = str_from_i64 %t40
    ;; %t42:str = str_concat(%t38, %t41)
    ;; %t43:str = const_str 36
    ;; %t44:str = str_concat(%t42, %t43)
    ;; print(%t44:str)
    ;; %t45:i64 = const_i64 1
    ;; arena_restore %arena_sp_test_summary
    ;; ret %t45
    ;; .if_end_46:
    ;; %t46:i64 = const_i64 0
    ;; arena_restore %arena_sp_test_summary
    ;; ret %t46
    (i64.const 0)
  )
  (func $benchmark_create (export "benchmark_create") (param $name i64) (param $iterations i64) (param $total_ns i64) (result i64)
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
    (local $t_t11 f64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $ns_op f64)
    (local $t_t18 f64)
    (local $ops_sec f64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $t_t23 f64)
    (local $t_t24 f64)
    (local $t_t25 f64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 iterations, %t1
    ;; jz %t2, .if_end_48
    ;; %t4:i64 = const_i64 5
    ;; %t5:i64 = const_i64 0
    ;; %t3:BenchmarkResult = alloc_array(%t4, init=%t5)
    ;; %t6:i64 = const_i64 0
    ;; %t3[%t6] = name  ; str
    ;; %t7:i64 = const_i64 0
    ;; %t8:i64 = const_i64 1
    ;; %t3[%t8] = %t7  ; i64
    ;; %t9:i64 = const_i64 0
    ;; %t10:i64 = const_i64 2
    ;; %t3[%t10] = %t9  ; i64
    ;; %t11:f64 = const_f64 0.0
    ;; %t12:i64 = const_i64 3
    ;; %t3[%t12] = %t11  ; f64
    ;; %t13:f64 = const_f64 0.0
    ;; %t14:i64 = const_i64 4
    ;; %t3[%t14] = %t13  ; f64
    ;; ret %t3
    ;; jmp .if_end_48
    ;; .if_end_48:
    ;; %t15:f64 = i64_to_f64 total_ns
    ;; %t16:f64 = i64_to_f64 iterations
    ;; %t17:f64 = div_f64 %t15, %t16
    ;; ns_op:f64 = mov %t17
    ;; %t18:f64 = const_f64 0.0
    ;; ops_sec:f64 = mov %t18
    ;; %t19:i64 = const_i64 0
    ;; %t20:bool = cmp_gt_i64 total_ns, %t19
    ;; jz %t20, .if_end_49
    ;; %t21:f64 = i64_to_f64 iterations
    ;; %t22:f64 = const_f64 1000000000.0
    ;; %t23:f64 = mul_f64 %t21, %t22
    ;; %t24:f64 = i64_to_f64 total_ns
    ;; %t25:f64 = div_f64 %t23, %t24
    ;; ops_sec:f64 = mov %t25
    ;; jmp .if_end_49
    ;; .if_end_49:
    ;; %t27:i64 = const_i64 5
    ;; %t28:i64 = const_i64 0
    ;; %t26:BenchmarkResult = alloc_array(%t27, init=%t28)
    ;; %t29:i64 = const_i64 0
    ;; %t26[%t29] = name  ; str
    ;; %t30:i64 = const_i64 1
    ;; %t26[%t30] = iterations  ; i64
    ;; %t31:i64 = const_i64 2
    ;; %t26[%t31] = total_ns  ; i64
    ;; %t32:i64 = const_i64 3
    ;; %t26[%t32] = ns_op  ; f64
    ;; %t33:i64 = const_i64 4
    ;; %t26[%t33] = ops_sec  ; f64
    ;; ret %t26
    (i64.const 0)
  )
  (func $benchmark_print (export "benchmark_print") (param $b i64) (result i64)
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
    (local $t_t27 f64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 f64)
    (local $t_t34 f64)
    (local $t_t35 f64)
    (local $mops f64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 f64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $t_t46 i64)
    (local $t_t47 i64)
    (local $t_arena_sp_benchmark_print i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_benchmark_print:i64 = arena_save None
    ;; %t1:str = const_str 37
    ;; %t2:i64 = const_i64 0
    ;; %t3:str = b[%t2]
    ;; %t4:str = str_concat(%t1, %t3)
    ;; print(%t4:str)
    ;; %t5:str = const_str 38
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = b[%t6]
    ;; %t8:str = str_from_i64 %t7
    ;; %t9:str = str_concat(%t5, %t8)
    ;; print(%t9:str)
    ;; %t10:str = const_str 39
    ;; %t11:i64 = const_i64 2
    ;; %t12:i64 = b[%t11]
    ;; %t13:i64 = const_i64 1000000
    ;; %t14:i64 = div_i64 %t12, %t13
    ;; %t15:str = str_from_i64 %t14
    ;; %t16:str = str_concat(%t10, %t15)
    ;; %t17:str = const_str 40
    ;; %t18:str = str_concat(%t16, %t17)
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = b[%t19]
    ;; %t21:str = str_from_i64 %t20
    ;; %t22:str = str_concat(%t18, %t21)
    ;; %t23:str = const_str 41
    ;; %t24:str = str_concat(%t22, %t23)
    ;; print(%t24:str)
    ;; %t25:str = const_str 42
    ;; %t26:i64 = const_i64 3
    ;; %t27:f64 = b[%t26]
    ;; %t28:str = str_from_f64 %t27
    ;; %t29:str = str_concat(%t25, %t28)
    ;; %t30:str = const_str 43
    ;; %t31:str = str_concat(%t29, %t30)
    ;; print(%t31:str)
    ;; %t32:i64 = const_i64 4
    ;; %t33:f64 = b[%t32]
    ;; %t34:f64 = const_f64 1000000.0
    ;; %t35:f64 = div_f64 %t33, %t34
    ;; mops:f64 = mov %t35
    ;; %t36:str = const_str 44
    ;; %t37:str = str_from_f64 mops
    ;; %t38:str = str_concat(%t36, %t37)
    ;; %t39:str = const_str 45
    ;; %t40:str = str_concat(%t38, %t39)
    ;; %t41:i64 = const_i64 4
    ;; %t42:f64 = b[%t41]
    ;; %t43:str = str_from_f64 %t42
    ;; %t44:str = str_concat(%t40, %t43)
    ;; %t45:str = const_str 46
    ;; %t46:str = str_concat(%t44, %t45)
    ;; print(%t46:str)
    ;; %t47:i64 = const_i64 0
    ;; arena_restore %arena_sp_benchmark_print
    ;; ret %t47
    (i64.const 0)
  )
  (func $array_copy_i64 (export "array_copy_i64") (param $src i64) (param $src_idx i64) (param $dst i64) (param $dst_idx i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_50:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_52
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:i64 = src[%t5]
    ;; dst[%t4] = %t6  ; i64
    ;; .for_step_51:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_50
    ;; .for_end_52:
    ;; ret count
    (i64.const 0)
  )
  (func $array_copy_f64 (export "array_copy_f64") (param $src i64) (param $src_idx i64) (param $dst i64) (param $dst_idx i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_53:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_55
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:f64 = src[%t5]
    ;; dst[%t4] = %t6  ; f64
    ;; .for_step_54:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_53
    ;; .for_end_55:
    ;; ret count
    (i64.const 0)
  )
  (func $array_copy_str (export "array_copy_str") (param $src i64) (param $src_idx i64) (param $dst i64) (param $dst_idx i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_56:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_58
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:str = src[%t5]
    ;; dst[%t4] = %t6  ; i64
    ;; .for_step_57:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_56
    ;; .for_end_58:
    ;; ret count
    (i64.const 0)
  )
  (func $array_fill_i64 (export "array_fill_i64") (param $arr i64) (param $start i64) (param $count i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_59:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_61
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; i64
    ;; .for_step_60:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_59
    ;; .for_end_61:
    ;; ret count
    (i64.const 0)
  )
  (func $array_fill_f64 (export "array_fill_f64") (param $arr i64) (param $start i64) (param $count i64) (param $val f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_62:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_64
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; f64
    ;; .for_step_63:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_62
    ;; .for_end_64:
    ;; ret count
    (i64.const 0)
  )
  (func $array_fill_str (export "array_fill_str") (param $arr i64) (param $start i64) (param $count i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_65:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_67
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; i64
    ;; .for_step_66:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_65
    ;; .for_end_67:
    ;; ret count
    (i64.const 0)
  )
  (func $int_vec_new (export "int_vec_new") (param $initial_cap i64) (result i64)
    (local $c i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $buf i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; c:i64 = mov initial_cap
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 c, %t1
    ;; jz %t2, .if_end_68
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_68
    ;; .if_end_68:
    ;; %t5:i64 = const_i64 0
    ;; %t4:Array[i64] = alloc_array(c, init=%t5)
    ;; buf:Array[i64] = mov %t4
    ;; %t7:i64 = const_i64 3
    ;; %t8:i64 = const_i64 0
    ;; %t6:IntVector = alloc_array(%t7, init=%t8)
    ;; %t9:i64 = const_i64 0
    ;; %t6[%t9] = buf  ; Array[i64]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 1
    ;; %t6[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 2
    ;; %t6[%t12] = c  ; i64
    ;; ret %t6
    (i64.const 0)
  )
  (func $int_vec_len (export "int_vec_len") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $int_vec_cap (export "int_vec_cap") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $int_vec_is_empty (export "int_vec_is_empty") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; ret %t4
    (i64.const 0)
  )
  (func $int_vec_reserve (export "int_vec_reserve") (param $v i64) (param $min_capacity i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $new_data i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; %t3:bool = cmp_le_i64 min_capacity, %t2
    ;; jz %t3, .if_end_69
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_69
    ;; .if_end_69:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_70
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_70
    ;; .if_end_70:
    ;; %t12:i64 = const_i64 0
    ;; %t11:Array[i64] = alloc_array(new_cap, init=%t12)
    ;; new_data:Array[i64] = mov %t11
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = v[%t13]
    ;; %t15:i64 = const_i64 0
    ;; %t16:i64 = const_i64 0
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; %t19:i64 = call array_copy_i64(%t14, %t15, new_data, %t16, %t18)
    ;; %t20:i64 = const_i64 0
    ;; v[%t20] = new_data  ; Array[i64]
    ;; %t21:i64 = const_i64 2
    ;; v[%t21] = new_cap  ; i64
    ;; ret new_cap
    (i64.const 0)
  )
  (func $int_vec_push (export "int_vec_push") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $new_data i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 2
    ;; %t4:i64 = v[%t3]
    ;; %t5:bool = cmp_ge_i64 %t2, %t4
    ;; jz %t5, .if_end_71
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_72
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_72
    ;; .if_end_72:
    ;; %t14:i64 = const_i64 0
    ;; %t13:Array[i64] = alloc_array(new_cap, init=%t14)
    ;; new_data:Array[i64] = mov %t13
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t17:i64 = const_i64 0
    ;; %t18:i64 = const_i64 0
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = call array_copy_i64(%t16, %t17, new_data, %t18, %t20)
    ;; %t22:i64 = const_i64 0
    ;; v[%t22] = new_data  ; Array[i64]
    ;; %t23:i64 = const_i64 2
    ;; v[%t23] = new_cap  ; i64
    ;; jmp .if_end_71
    ;; .if_end_71:
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[i64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t25[%t27] = val  ; i64
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = v[%t28]
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = add_i64 %t29, %t30
    ;; %t32:i64 = const_i64 1
    ;; v[%t32] = %t31  ; i64
    ;; %t33:i64 = const_i64 1
    ;; %t34:i64 = v[%t33]
    ;; ret %t34
    (i64.const 0)
  )
  (func $int_vec_pop (export "int_vec_pop") (param $v i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_73
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_73
    ;; .if_end_73:
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = sub_i64 %t7, %t8
    ;; %t10:i64 = const_i64 1
    ;; v[%t10] = %t9  ; i64
    ;; %t11:i64 = const_i64 0
    ;; %t12:Array[i64] = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = v[%t13]
    ;; %t15:i64 = %t12[%t14]
    ;; ret %t15
    (i64.const 0)
  )
  (func $int_vec_get (export "int_vec_get") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_74
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_74
    ;; .if_end_74:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_75
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_75
    ;; .if_end_75:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = v[%t13]
    ;; %t15:i64 = %t14[real_idx]
    ;; ret %t15
    (i64.const 0)
  )
  (func $int_vec_set (export "int_vec_set") (param $v i64) (param $idx i64) (param $val i64) (result i64)
    (local $real_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_76
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_76
    ;; .if_end_76:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_77
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_77
    ;; .if_end_77:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = v[%t13]
    ;; %t14[real_idx] = val  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $int_vec_clear (export "int_vec_clear") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; v[%t2] = %t1  ; i64
    ;; %t3:i64 = const_i64 0
    ;; ret %t3
    (i64.const 0)
  )
  (func $int_vec_insert (export "int_vec_insert") (param $v i64) (param $idx i64) (param $val i64) (result i64)
    (local $real_idx i64)
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
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_78
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_78
    ;; .if_end_78:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_79
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_79
    ;; .if_end_79:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_80
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call int_vec_reserve(v, %t22)
    ;; jmp .if_end_80
    ;; .if_end_80:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_81:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_82
    ;; %t27:i64 = const_i64 0
    ;; %t28:Array[i64] = v[%t27]
    ;; %t29:i64 = const_i64 0
    ;; %t30:Array[i64] = v[%t29]
    ;; %t31:i64 = const_i64 1
    ;; %t32:i64 = sub_i64 i, %t31
    ;; %t33:i64 = %t30[%t32]
    ;; %t28[i] = %t33  ; i64
    ;; %t34:i64 = const_i64 1
    ;; %t35:i64 = sub_i64 i, %t34
    ;; i:i64 = mov %t35
    ;; jmp .while_cond_81
    ;; .while_end_82:
    ;; %t36:i64 = const_i64 0
    ;; %t37:Array[i64] = v[%t36]
    ;; %t37[real_idx] = val  ; i64
    ;; %t38:i64 = const_i64 1
    ;; %t39:i64 = v[%t38]
    ;; %t40:i64 = const_i64 1
    ;; %t41:i64 = add_i64 %t39, %t40
    ;; %t42:i64 = const_i64 1
    ;; v[%t42] = %t41  ; i64
    ;; %t43:i64 = const_i64 1
    ;; %t44:i64 = v[%t43]
    ;; ret %t44
    (i64.const 0)
  )
  (func $int_vec_remove (export "int_vec_remove") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $val i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last i64)
    (local $t_t20 i64)
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_83
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_83
    ;; .if_end_83:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_84
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_84
    ;; .if_end_84:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = v[%t13]
    ;; %t15:i64 = %t14[real_idx]
    ;; val:i64 = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last:i64 = mov %t19
    ;; %t20:i64 = const_i64 1
    ;; i:i64 = mov real_idx
    ;; .for_cond_85:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_87
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[i64] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[i64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:i64 = %t25[%t27]
    ;; %t23[i] = %t28  ; i64
    ;; .for_step_86:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_85
    ;; .for_end_87:
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = v[%t30]
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = sub_i64 %t31, %t32
    ;; %t34:i64 = const_i64 1
    ;; v[%t34] = %t33  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $int_vec_swap_remove (export "int_vec_swap_remove") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $val i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_88
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_88
    ;; .if_end_88:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_89
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_89
    ;; .if_end_89:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = v[%t13]
    ;; %t15:i64 = %t14[real_idx]
    ;; val:i64 = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last_idx:i64 = mov %t19
    ;; %t20:bool = cmp_ne_i64 real_idx, last_idx
    ;; jz %t20, .if_end_90
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[i64] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[i64] = v[%t23]
    ;; %t25:i64 = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; i64
    ;; jmp .if_end_90
    ;; .if_end_90:
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = sub_i64 %t27, %t28
    ;; %t30:i64 = const_i64 1
    ;; v[%t30] = %t29  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $int_vec_extend (export "int_vec_extend") (param $dst i64) (param $src i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $needed i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = dst[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = src[%t3]
    ;; %t5:i64 = add_i64 %t2, %t4
    ;; needed:i64 = mov %t5
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = dst[%t6]
    ;; %t8:bool = cmp_gt_i64 needed, %t7
    ;; jz %t8, .if_end_91
    ;; %t9:i64 = call int_vec_reserve(dst, needed)
    ;; jmp .if_end_91
    ;; .if_end_91:
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[i64] = src[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[i64] = dst[%t13]
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = dst[%t15]
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = src[%t17]
    ;; %t19:i64 = call array_copy_i64(%t11, %t12, %t14, %t16, %t18)
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = dst[%t20]
    ;; %t22:i64 = const_i64 1
    ;; %t23:i64 = src[%t22]
    ;; %t24:i64 = add_i64 %t21, %t23
    ;; %t25:i64 = const_i64 1
    ;; dst[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = dst[%t26]
    ;; ret %t27
    (i64.const 0)
  )
  (func $int_vec_copy (export "int_vec_copy") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $c i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $buf i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; c:i64 = mov %t2
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 c, %t3
    ;; jz %t4, .if_end_92
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_92
    ;; .if_end_92:
    ;; %t7:i64 = const_i64 0
    ;; %t6:Array[i64] = alloc_array(c, init=%t7)
    ;; buf:Array[i64] = mov %t6
    ;; %t8:i64 = const_i64 0
    ;; %t9:Array[i64] = v[%t8]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = v[%t12]
    ;; %t14:i64 = call array_copy_i64(%t9, %t10, buf, %t11, %t13)
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = const_i64 0
    ;; %t15:IntVector = alloc_array(%t16, init=%t17)
    ;; %t18:i64 = const_i64 0
    ;; %t15[%t18] = buf  ; Array[i64]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 1
    ;; %t15[%t21] = %t20  ; i64
    ;; %t22:i64 = const_i64 2
    ;; %t15[%t22] = c  ; i64
    ;; ret %t15
    (i64.const 0)
  )
  (func $int_vec_slice (export "int_vec_slice") (param $v i64) (param $start i64) (param $stop i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $e i64)
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
    (local $slice_len i64)
    (local $t_t23 i64)
    (local $res i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov start
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 s, %t1
    ;; jz %t2, .if_end_93
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_94
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_94
    ;; .if_end_94:
    ;; jmp .if_end_93
    ;; .if_end_93:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_95
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_95
    ;; .if_end_95:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_96
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_96
    ;; .if_end_96:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_97
    ;; %t20:i64 = const_i64 4
    ;; %t21:IntVector = call int_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_97
    ;; .if_end_97:
    ;; %t22:i64 = sub_i64 e, s
    ;; slice_len:i64 = mov %t22
    ;; %t23:IntVector = call int_vec_new(slice_len)
    ;; res:IntVector = mov %t23
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[i64] = v[%t24]
    ;; %t26:i64 = const_i64 0
    ;; %t27:Array[i64] = res[%t26]
    ;; %t28:i64 = const_i64 0
    ;; %t29:i64 = call array_copy_i64(%t25, s, %t27, %t28, slice_len)
    ;; %t30:i64 = const_i64 1
    ;; res[%t30] = slice_len  ; i64
    ;; ret res
    (i64.const 0)
  )
  (func $int_vec_contains (export "int_vec_contains") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_98:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_100
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = %t7[i]
    ;; %t9:bool = cmp_eq_i64 %t8, val
    ;; jz %t9, .if_end_101
    ;; %t10:bool = const_i64 1
    ;; ret %t10
    ;; jmp .if_end_101
    ;; .if_end_101:
    ;; .for_step_99:
    ;; %t11:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_98
    ;; .for_end_100:
    ;; %t12:bool = const_i64 0
    ;; ret %t12
    (i64.const 0)
  )
  (func $int_vec_index_of (export "int_vec_index_of") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_102:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_104
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = %t7[i]
    ;; %t9:bool = cmp_eq_i64 %t8, val
    ;; jz %t9, .if_end_105
    ;; ret i
    ;; jmp .if_end_105
    ;; .if_end_105:
    ;; .for_step_103:
    ;; %t10:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t10
    ;; jmp .for_cond_102
    ;; .for_end_104:
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = neg_i64 %t11
    ;; ret %t12
    (i64.const 0)
  )
  (func $int_vec_reverse (export "int_vec_reverse") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $i i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $j i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $tmp i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; i:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = sub_i64 %t3, %t4
    ;; j:i64 = mov %t5
    ;; .while_cond_106:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_107
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[i64] = v[%t7]
    ;; %t9:i64 = %t8[i]
    ;; tmp:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[i64] = v[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:Array[i64] = v[%t12]
    ;; %t14:i64 = %t13[j]
    ;; %t11[i] = %t14  ; i64
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t16[j] = tmp  ; i64
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = add_i64 i, %t17
    ;; i:i64 = mov %t18
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = sub_i64 j, %t19
    ;; j:i64 = mov %t20
    ;; jmp .while_cond_106
    ;; .while_end_107:
    ;; %t21:i64 = const_i64 0
    ;; ret %t21
    (i64.const 0)
  )
  (func $_int_qsort (export "_int_qsort") (param $arr i64) (param $low i64) (param $high i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $pivot i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $j i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $tmp i64)
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
    (local $p i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:bool = cmp_lt_i64 low, high
    ;; jz %t1, .if_end_108
    ;; %t2:i64 = arr[high]
    ;; pivot:i64 = mov %t2
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 low, %t3
    ;; i:i64 = mov %t4
    ;; %t5:i64 = const_i64 1
    ;; j:i64 = mov low
    ;; .for_cond_109:
    ;; %t6:bool = cmp_lt_i64 j, high
    ;; jz %t6, .for_end_111
    ;; %t7:i64 = arr[j]
    ;; %t8:bool = cmp_le_i64 %t7, pivot
    ;; jz %t8, .if_end_112
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 i, %t9
    ;; i:i64 = mov %t10
    ;; %t11:i64 = arr[i]
    ;; tmp:i64 = mov %t11
    ;; %t12:i64 = arr[j]
    ;; arr[i] = %t12  ; i64
    ;; arr[j] = tmp  ; i64
    ;; jmp .if_end_112
    ;; .if_end_112:
    ;; .for_step_110:
    ;; %t13:i64 = add_i64 j, %t5
    ;; j:i64 = mov %t13
    ;; jmp .for_cond_109
    ;; .for_end_111:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = add_i64 i, %t14
    ;; %t16:i64 = arr[%t15]
    ;; tmp:i64 = mov %t16
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = add_i64 i, %t17
    ;; %t19:i64 = arr[high]
    ;; arr[%t18] = %t19  ; i64
    ;; arr[high] = tmp  ; i64
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = add_i64 i, %t20
    ;; p:i64 = mov %t21
    ;; %t22:i64 = const_i64 1
    ;; %t23:i64 = sub_i64 p, %t22
    ;; %t24:i64 = call _int_qsort(arr, low, %t23)
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = add_i64 p, %t25
    ;; %t27:i64 = call _int_qsort(arr, %t26, high)
    ;; jmp .if_end_108
    ;; .if_end_108:
    ;; %t28:i64 = const_i64 0
    ;; ret %t28
    (i64.const 0)
  )
  (func $int_vec_sort (export "int_vec_sort") (param $v i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_113
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_113
    ;; .if_end_113:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = v[%t9]
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = sub_i64 %t10, %t11
    ;; %t13:i64 = call _int_qsort(%t7, %t8, %t12)
    ;; %t14:i64 = const_i64 0
    ;; ret %t14
    (i64.const 0)
  )
  (func $int_vec_binary_search (export "int_vec_binary_search") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $low i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $high i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $mid i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $mid_val i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; low:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = sub_i64 %t3, %t4
    ;; high:i64 = mov %t5
    ;; .while_cond_114:
    ;; %t6:bool = cmp_le_i64 low, high
    ;; jz %t6, .while_end_115
    ;; %t7:i64 = add_i64 low, high
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = div_i64 %t7, %t8
    ;; mid:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[i64] = v[%t10]
    ;; %t12:i64 = %t11[mid]
    ;; mid_val:i64 = mov %t12
    ;; %t13:bool = cmp_eq_i64 mid_val, val
    ;; jz %t13, .if_end_116
    ;; ret mid
    ;; jmp .if_end_116
    ;; .if_end_116:
    ;; %t14:bool = cmp_lt_i64 mid_val, val
    ;; jz %t14, .if_next_118
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = add_i64 mid, %t15
    ;; low:i64 = mov %t16
    ;; jmp .if_end_117
    ;; .if_next_118:
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = sub_i64 mid, %t17
    ;; high:i64 = mov %t18
    ;; .if_end_117:
    ;; jmp .while_cond_114
    ;; .while_end_115:
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = neg_i64 %t19
    ;; ret %t20
    (i64.const 0)
  )
  (func $int_vec_min (export "int_vec_min") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $m i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $i i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $val i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_119
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_119
    ;; .if_end_119:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; m:i64 = mov %t9
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; i:i64 = mov %t10
    ;; .for_cond_120:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_122
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t17:i64 = %t16[i]
    ;; val:i64 = mov %t17
    ;; %t18:bool = cmp_lt_i64 val, m
    ;; jz %t18, .if_end_123
    ;; m:i64 = mov val
    ;; jmp .if_end_123
    ;; .if_end_123:
    ;; .for_step_121:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_120
    ;; .for_end_122:
    ;; ret m
    (i64.const 0)
  )
  (func $int_vec_max (export "int_vec_max") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $m i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $i i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $val i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_124
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_124
    ;; .if_end_124:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; m:i64 = mov %t9
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; i:i64 = mov %t10
    ;; .for_cond_125:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_127
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t17:i64 = %t16[i]
    ;; val:i64 = mov %t17
    ;; %t18:bool = cmp_gt_i64 val, m
    ;; jz %t18, .if_end_128
    ;; m:i64 = mov val
    ;; jmp .if_end_128
    ;; .if_end_128:
    ;; .for_step_126:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_125
    ;; .for_end_127:
    ;; ret m
    (i64.const 0)
  )
  (func $int_vec_sum (export "int_vec_sum") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $s i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $i i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; s:i64 = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_129:
    ;; %t6:bool = cmp_lt_i64 i, %t4
    ;; jz %t6, .for_end_131
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[i64] = v[%t7]
    ;; %t9:i64 = %t8[i]
    ;; %t10:i64 = add_i64 s, %t9
    ;; s:i64 = mov %t10
    ;; .for_step_130:
    ;; %t11:i64 = add_i64 i, %t5
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_129
    ;; .for_end_131:
    ;; ret s
    (i64.const 0)
  )
  (func $int_vec_to_str (export "int_vec_to_str") (param $v i64) (result i64)
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
    (local $res i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; jz %t4, .if_end_132
    ;; %t5:str = const_str 47
    ;; ret %t5
    ;; jmp .if_end_132
    ;; .if_end_132:
    ;; %t6:str = const_str 48
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[i64] = v[%t7]
    ;; %t9:i64 = const_i64 0
    ;; %t10:i64 = %t8[%t9]
    ;; %t11:str = str_from_i64 %t10
    ;; %t12:str = str_concat(%t6, %t11)
    ;; res:str = mov %t12
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 1
    ;; i:i64 = mov %t13
    ;; .for_cond_133:
    ;; %t17:bool = cmp_lt_i64 i, %t15
    ;; jz %t17, .for_end_135
    ;; %t18:str = const_str 49
    ;; %t19:str = str_concat(res, %t18)
    ;; %t20:i64 = const_i64 0
    ;; %t21:Array[i64] = v[%t20]
    ;; %t22:i64 = %t21[i]
    ;; %t23:str = str_from_i64 %t22
    ;; %t24:str = str_concat(%t19, %t23)
    ;; res:str = mov %t24
    ;; .for_step_134:
    ;; %t25:i64 = add_i64 i, %t16
    ;; i:i64 = mov %t25
    ;; jmp .for_cond_133
    ;; .for_end_135:
    ;; %t26:str = const_str 50
    ;; %t27:str = str_concat(res, %t26)
    ;; res:str = mov %t27
    ;; ret res
    (i64.const 0)
  )
  (func $float_vec_new (export "float_vec_new") (param $initial_cap i64) (result i64)
    (local $c i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $buf i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; c:i64 = mov initial_cap
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 c, %t1
    ;; jz %t2, .if_end_136
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_136
    ;; .if_end_136:
    ;; %t5:f64 = const_f64 0.0
    ;; %t4:Array[f64] = alloc_array(c, init=%t5)
    ;; buf:Array[f64] = mov %t4
    ;; %t7:i64 = const_i64 3
    ;; %t8:i64 = const_i64 0
    ;; %t6:FloatVector = alloc_array(%t7, init=%t8)
    ;; %t9:i64 = const_i64 0
    ;; %t6[%t9] = buf  ; Array[f64]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 1
    ;; %t6[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 2
    ;; %t6[%t12] = c  ; i64
    ;; ret %t6
    (i64.const 0)
  )
  (func $float_vec_len (export "float_vec_len") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $float_vec_cap (export "float_vec_cap") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $float_vec_is_empty (export "float_vec_is_empty") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; ret %t4
    (i64.const 0)
  )
  (func $float_vec_reserve (export "float_vec_reserve") (param $v i64) (param $min_capacity i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 f64)
    (local $new_data i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; %t3:bool = cmp_le_i64 min_capacity, %t2
    ;; jz %t3, .if_end_137
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_137
    ;; .if_end_137:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_138
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_138
    ;; .if_end_138:
    ;; %t12:f64 = const_f64 0.0
    ;; %t11:Array[f64] = alloc_array(new_cap, init=%t12)
    ;; new_data:Array[f64] = mov %t11
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = v[%t13]
    ;; %t15:i64 = const_i64 0
    ;; %t16:i64 = const_i64 0
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; %t19:i64 = call array_copy_f64(%t14, %t15, new_data, %t16, %t18)
    ;; %t20:i64 = const_i64 0
    ;; v[%t20] = new_data  ; Array[f64]
    ;; %t21:i64 = const_i64 2
    ;; v[%t21] = new_cap  ; i64
    ;; ret new_cap
    (i64.const 0)
  )
  (func $float_vec_push (export "float_vec_push") (param $v i64) (param $val f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $new_data i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 2
    ;; %t4:i64 = v[%t3]
    ;; %t5:bool = cmp_ge_i64 %t2, %t4
    ;; jz %t5, .if_end_139
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_140
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_140
    ;; .if_end_140:
    ;; %t14:f64 = const_f64 0.0
    ;; %t13:Array[f64] = alloc_array(new_cap, init=%t14)
    ;; new_data:Array[f64] = mov %t13
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t17:i64 = const_i64 0
    ;; %t18:i64 = const_i64 0
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = call array_copy_f64(%t16, %t17, new_data, %t18, %t20)
    ;; %t22:i64 = const_i64 0
    ;; v[%t22] = new_data  ; Array[f64]
    ;; %t23:i64 = const_i64 2
    ;; v[%t23] = new_cap  ; i64
    ;; jmp .if_end_139
    ;; .if_end_139:
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[f64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t25[%t27] = val  ; f64
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = v[%t28]
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = add_i64 %t29, %t30
    ;; %t32:i64 = const_i64 1
    ;; v[%t32] = %t31  ; i64
    ;; %t33:i64 = const_i64 1
    ;; %t34:i64 = v[%t33]
    ;; ret %t34
    (i64.const 0)
  )
  (func $float_vec_pop (export "float_vec_pop") (param $v i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_141
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_141
    ;; .if_end_141:
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = sub_i64 %t7, %t8
    ;; %t10:i64 = const_i64 1
    ;; v[%t10] = %t9  ; i64
    ;; %t11:i64 = const_i64 0
    ;; %t12:Array[f64] = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = v[%t13]
    ;; %t15:f64 = %t12[%t14]
    ;; ret %t15
    (f64.const 0.0)
  )
  (func $float_vec_get (export "float_vec_get") (param $v i64) (param $idx i64) (result f64)
    (local $real_idx i64)
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
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_142
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_142
    ;; .if_end_142:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_143
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_143
    ;; .if_end_143:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = v[%t13]
    ;; %t15:f64 = %t14[real_idx]
    ;; ret %t15
    (f64.const 0.0)
  )
  (func $float_vec_set (export "float_vec_set") (param $v i64) (param $idx i64) (param $val f64) (result i64)
    (local $real_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_144
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_144
    ;; .if_end_144:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_145
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_145
    ;; .if_end_145:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = v[%t13]
    ;; %t14[real_idx] = val  ; f64
    ;; %t15:i64 = const_i64 0
    ;; ret %t15
    (i64.const 0)
  )
  (func $float_vec_clear (export "float_vec_clear") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; v[%t2] = %t1  ; i64
    ;; %t3:i64 = const_i64 0
    ;; ret %t3
    (i64.const 0)
  )
  (func $float_vec_insert (export "float_vec_insert") (param $v i64) (param $idx i64) (param $val f64) (result i64)
    (local $real_idx i64)
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
    (local $i i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 f64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_146
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_146
    ;; .if_end_146:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_147
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_147
    ;; .if_end_147:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_148
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call float_vec_reserve(v, %t22)
    ;; jmp .if_end_148
    ;; .if_end_148:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_149:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_150
    ;; %t27:i64 = const_i64 0
    ;; %t28:Array[f64] = v[%t27]
    ;; %t29:i64 = const_i64 0
    ;; %t30:Array[f64] = v[%t29]
    ;; %t31:i64 = const_i64 1
    ;; %t32:i64 = sub_i64 i, %t31
    ;; %t33:f64 = %t30[%t32]
    ;; %t28[i] = %t33  ; f64
    ;; %t34:i64 = const_i64 1
    ;; %t35:i64 = sub_i64 i, %t34
    ;; i:i64 = mov %t35
    ;; jmp .while_cond_149
    ;; .while_end_150:
    ;; %t36:i64 = const_i64 0
    ;; %t37:Array[f64] = v[%t36]
    ;; %t37[real_idx] = val  ; f64
    ;; %t38:i64 = const_i64 1
    ;; %t39:i64 = v[%t38]
    ;; %t40:i64 = const_i64 1
    ;; %t41:i64 = add_i64 %t39, %t40
    ;; %t42:i64 = const_i64 1
    ;; v[%t42] = %t41  ; i64
    ;; %t43:i64 = const_i64 1
    ;; %t44:i64 = v[%t43]
    ;; ret %t44
    (i64.const 0)
  )
  (func $float_vec_remove (export "float_vec_remove") (param $v i64) (param $idx i64) (result f64)
    (local $real_idx i64)
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
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $val f64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last i64)
    (local $t_t20 i64)
    (local $i i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 f64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_151
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_151
    ;; .if_end_151:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_152
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_152
    ;; .if_end_152:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = v[%t13]
    ;; %t15:f64 = %t14[real_idx]
    ;; val:f64 = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last:i64 = mov %t19
    ;; %t20:i64 = const_i64 1
    ;; i:i64 = mov real_idx
    ;; .for_cond_153:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_155
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[f64] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[f64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:f64 = %t25[%t27]
    ;; %t23[i] = %t28  ; f64
    ;; .for_step_154:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_153
    ;; .for_end_155:
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = v[%t30]
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = sub_i64 %t31, %t32
    ;; %t34:i64 = const_i64 1
    ;; v[%t34] = %t33  ; i64
    ;; ret val
    (f64.const 0.0)
  )
  (func $float_vec_swap_remove (export "float_vec_swap_remove") (param $v i64) (param $idx i64) (result f64)
    (local $real_idx i64)
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
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $val f64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last_idx i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 f64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_156
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_156
    ;; .if_end_156:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_157
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_157
    ;; .if_end_157:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = v[%t13]
    ;; %t15:f64 = %t14[real_idx]
    ;; val:f64 = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last_idx:i64 = mov %t19
    ;; %t20:bool = cmp_ne_i64 real_idx, last_idx
    ;; jz %t20, .if_end_158
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[f64] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[f64] = v[%t23]
    ;; %t25:f64 = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; f64
    ;; jmp .if_end_158
    ;; .if_end_158:
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = sub_i64 %t27, %t28
    ;; %t30:i64 = const_i64 1
    ;; v[%t30] = %t29  ; i64
    ;; ret val
    (f64.const 0.0)
  )
  (func $float_vec_extend (export "float_vec_extend") (param $dst i64) (param $src i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $needed i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = dst[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = src[%t3]
    ;; %t5:i64 = add_i64 %t2, %t4
    ;; needed:i64 = mov %t5
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = dst[%t6]
    ;; %t8:bool = cmp_gt_i64 needed, %t7
    ;; jz %t8, .if_end_159
    ;; %t9:i64 = call float_vec_reserve(dst, needed)
    ;; jmp .if_end_159
    ;; .if_end_159:
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[f64] = src[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[f64] = dst[%t13]
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = dst[%t15]
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = src[%t17]
    ;; %t19:i64 = call array_copy_f64(%t11, %t12, %t14, %t16, %t18)
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = dst[%t20]
    ;; %t22:i64 = const_i64 1
    ;; %t23:i64 = src[%t22]
    ;; %t24:i64 = add_i64 %t21, %t23
    ;; %t25:i64 = const_i64 1
    ;; dst[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = dst[%t26]
    ;; ret %t27
    (i64.const 0)
  )
  (func $float_vec_copy (export "float_vec_copy") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $c i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $buf i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; c:i64 = mov %t2
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 c, %t3
    ;; jz %t4, .if_end_160
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_160
    ;; .if_end_160:
    ;; %t7:f64 = const_f64 0.0
    ;; %t6:Array[f64] = alloc_array(c, init=%t7)
    ;; buf:Array[f64] = mov %t6
    ;; %t8:i64 = const_i64 0
    ;; %t9:Array[f64] = v[%t8]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = v[%t12]
    ;; %t14:i64 = call array_copy_f64(%t9, %t10, buf, %t11, %t13)
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = const_i64 0
    ;; %t15:FloatVector = alloc_array(%t16, init=%t17)
    ;; %t18:i64 = const_i64 0
    ;; %t15[%t18] = buf  ; Array[f64]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 1
    ;; %t15[%t21] = %t20  ; i64
    ;; %t22:i64 = const_i64 2
    ;; %t15[%t22] = c  ; i64
    ;; ret %t15
    (i64.const 0)
  )
  (func $float_vec_slice (export "float_vec_slice") (param $v i64) (param $start i64) (param $stop i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $e i64)
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
    (local $slice_len i64)
    (local $t_t23 i64)
    (local $res i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov start
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 s, %t1
    ;; jz %t2, .if_end_161
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_162
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_162
    ;; .if_end_162:
    ;; jmp .if_end_161
    ;; .if_end_161:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_163
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_163
    ;; .if_end_163:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_164
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_164
    ;; .if_end_164:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_165
    ;; %t20:i64 = const_i64 4
    ;; %t21:FloatVector = call float_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_165
    ;; .if_end_165:
    ;; %t22:i64 = sub_i64 e, s
    ;; slice_len:i64 = mov %t22
    ;; %t23:FloatVector = call float_vec_new(slice_len)
    ;; res:FloatVector = mov %t23
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[f64] = v[%t24]
    ;; %t26:i64 = const_i64 0
    ;; %t27:Array[f64] = res[%t26]
    ;; %t28:i64 = const_i64 0
    ;; %t29:i64 = call array_copy_f64(%t25, s, %t27, %t28, slice_len)
    ;; %t30:i64 = const_i64 1
    ;; res[%t30] = slice_len  ; i64
    ;; ret res
    (i64.const 0)
  )
  (func $float_vec_reverse (export "float_vec_reverse") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $i i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $j i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $tmp f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; i:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = sub_i64 %t3, %t4
    ;; j:i64 = mov %t5
    ;; .while_cond_166:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_167
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[f64] = v[%t7]
    ;; %t9:f64 = %t8[i]
    ;; tmp:f64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[f64] = v[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:Array[f64] = v[%t12]
    ;; %t14:f64 = %t13[j]
    ;; %t11[i] = %t14  ; f64
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t16[j] = tmp  ; f64
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = add_i64 i, %t17
    ;; i:i64 = mov %t18
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = sub_i64 j, %t19
    ;; j:i64 = mov %t20
    ;; jmp .while_cond_166
    ;; .while_end_167:
    ;; %t21:i64 = const_i64 0
    ;; ret %t21
    (i64.const 0)
  )
  (func $_float_qsort (export "_float_qsort") (param $arr i64) (param $low i64) (param $high i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 f64)
    (local $pivot f64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $j i64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $tmp f64)
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 f64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 f64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $p i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:bool = cmp_lt_i64 low, high
    ;; jz %t1, .if_end_168
    ;; %t2:f64 = arr[high]
    ;; pivot:f64 = mov %t2
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 low, %t3
    ;; i:i64 = mov %t4
    ;; %t5:i64 = const_i64 1
    ;; j:i64 = mov low
    ;; .for_cond_169:
    ;; %t6:bool = cmp_lt_i64 j, high
    ;; jz %t6, .for_end_171
    ;; %t7:f64 = arr[j]
    ;; %t8:bool = cmp_le_f64 %t7, pivot
    ;; jz %t8, .if_end_172
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 i, %t9
    ;; i:i64 = mov %t10
    ;; %t11:f64 = arr[i]
    ;; tmp:f64 = mov %t11
    ;; %t12:f64 = arr[j]
    ;; arr[i] = %t12  ; f64
    ;; arr[j] = tmp  ; f64
    ;; jmp .if_end_172
    ;; .if_end_172:
    ;; .for_step_170:
    ;; %t13:i64 = add_i64 j, %t5
    ;; j:i64 = mov %t13
    ;; jmp .for_cond_169
    ;; .for_end_171:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = add_i64 i, %t14
    ;; %t16:f64 = arr[%t15]
    ;; tmp:f64 = mov %t16
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = add_i64 i, %t17
    ;; %t19:f64 = arr[high]
    ;; arr[%t18] = %t19  ; f64
    ;; arr[high] = tmp  ; f64
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = add_i64 i, %t20
    ;; p:i64 = mov %t21
    ;; %t22:i64 = const_i64 1
    ;; %t23:i64 = sub_i64 p, %t22
    ;; %t24:i64 = call _float_qsort(arr, low, %t23)
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = add_i64 p, %t25
    ;; %t27:i64 = call _float_qsort(arr, %t26, high)
    ;; jmp .if_end_168
    ;; .if_end_168:
    ;; %t28:i64 = const_i64 0
    ;; ret %t28
    (i64.const 0)
  )
  (func $float_vec_sort (export "float_vec_sort") (param $v i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_173
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_173
    ;; .if_end_173:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[f64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = v[%t9]
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = sub_i64 %t10, %t11
    ;; %t13:i64 = call _float_qsort(%t7, %t8, %t12)
    ;; %t14:i64 = const_i64 0
    ;; ret %t14
    (i64.const 0)
  )
  (func $float_vec_min (export "float_vec_min") (param $v i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $m f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $i i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $val f64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_174
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_174
    ;; .if_end_174:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[f64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:f64 = %t7[%t8]
    ;; m:f64 = mov %t9
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; i:i64 = mov %t10
    ;; .for_cond_175:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_177
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t17:f64 = %t16[i]
    ;; val:f64 = mov %t17
    ;; %t18:bool = cmp_lt_f64 val, m
    ;; jz %t18, .if_end_178
    ;; m:f64 = mov val
    ;; jmp .if_end_178
    ;; .if_end_178:
    ;; .for_step_176:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_175
    ;; .for_end_177:
    ;; ret m
    (f64.const 0.0)
  )
  (func $float_vec_max (export "float_vec_max") (param $v i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $m f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $i i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $val f64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_179
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_179
    ;; .if_end_179:
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[f64] = v[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:f64 = %t7[%t8]
    ;; m:f64 = mov %t9
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; i:i64 = mov %t10
    ;; .for_cond_180:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_182
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t17:f64 = %t16[i]
    ;; val:f64 = mov %t17
    ;; %t18:bool = cmp_gt_f64 val, m
    ;; jz %t18, .if_end_183
    ;; m:f64 = mov val
    ;; jmp .if_end_183
    ;; .if_end_183:
    ;; .for_step_181:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_180
    ;; .for_end_182:
    ;; ret m
    (f64.const 0.0)
  )
  (func $float_vec_sum (export "float_vec_sum") (param $v i64) (result f64)
    (local $t_t1 f64)
    (local $s f64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $i i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $t_t11 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; s:f64 = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_184:
    ;; %t6:bool = cmp_lt_i64 i, %t4
    ;; jz %t6, .for_end_186
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[f64] = v[%t7]
    ;; %t9:f64 = %t8[i]
    ;; %t10:f64 = add_f64 s, %t9
    ;; s:f64 = mov %t10
    ;; .for_step_185:
    ;; %t11:i64 = add_i64 i, %t5
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_184
    ;; .for_end_186:
    ;; ret s
    (f64.const 0.0)
  )
  (func $float_vec_mean (export "float_vec_mean") (param $v i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_187
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_187
    ;; .if_end_187:
    ;; %t6:f64 = call float_vec_sum(v)
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = v[%t7]
    ;; %t9:f64 = i64_to_f64 %t8
    ;; %t10:f64 = div_f64 %t6, %t9
    ;; ret %t10
    (f64.const 0.0)
  )
  (func $float_vec_to_str (export "float_vec_to_str") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 f64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $res i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $i i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 f64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; jz %t4, .if_end_188
    ;; %t5:str = const_str 47
    ;; ret %t5
    ;; jmp .if_end_188
    ;; .if_end_188:
    ;; %t6:str = const_str 48
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[f64] = v[%t7]
    ;; %t9:i64 = const_i64 0
    ;; %t10:f64 = %t8[%t9]
    ;; %t11:str = str_from_f64 %t10
    ;; %t12:str = str_concat(%t6, %t11)
    ;; res:str = mov %t12
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 1
    ;; i:i64 = mov %t13
    ;; .for_cond_189:
    ;; %t17:bool = cmp_lt_i64 i, %t15
    ;; jz %t17, .for_end_191
    ;; %t18:str = const_str 49
    ;; %t19:str = str_concat(res, %t18)
    ;; %t20:i64 = const_i64 0
    ;; %t21:Array[f64] = v[%t20]
    ;; %t22:f64 = %t21[i]
    ;; %t23:str = str_from_f64 %t22
    ;; %t24:str = str_concat(%t19, %t23)
    ;; res:str = mov %t24
    ;; .for_step_190:
    ;; %t25:i64 = add_i64 i, %t16
    ;; i:i64 = mov %t25
    ;; jmp .for_cond_189
    ;; .for_end_191:
    ;; %t26:str = const_str 50
    ;; %t27:str = str_concat(res, %t26)
    ;; res:str = mov %t27
    ;; ret res
    (i64.const 0)
  )
  (func $str_vec_new (export "str_vec_new") (param $initial_cap i64) (result i64)
    (local $c i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $buf i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; c:i64 = mov initial_cap
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 c, %t1
    ;; jz %t2, .if_end_192
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_192
    ;; .if_end_192:
    ;; %t5:str = const_str 1
    ;; %t4:Array[str] = alloc_array(c, init=%t5)
    ;; buf:Array[str] = mov %t4
    ;; %t7:i64 = const_i64 3
    ;; %t8:i64 = const_i64 0
    ;; %t6:StrVector = alloc_array(%t7, init=%t8)
    ;; %t9:i64 = const_i64 0
    ;; %t6[%t9] = buf  ; Array[str]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 1
    ;; %t6[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 2
    ;; %t6[%t12] = c  ; i64
    ;; ret %t6
    (i64.const 0)
  )
  (func $str_vec_len (export "str_vec_len") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $str_vec_cap (export "str_vec_cap") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; ret %t2
    (i64.const 0)
  )
  (func $str_vec_is_empty (export "str_vec_is_empty") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; ret %t4
    (i64.const 0)
  )
  (func $str_vec_reserve (export "str_vec_reserve") (param $v i64) (param $min_capacity i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $new_data i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; %t3:bool = cmp_le_i64 min_capacity, %t2
    ;; jz %t3, .if_end_193
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_193
    ;; .if_end_193:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_194
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_194
    ;; .if_end_194:
    ;; %t12:str = const_str 1
    ;; %t11:Array[str] = alloc_array(new_cap, init=%t12)
    ;; new_data:Array[str] = mov %t11
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = v[%t13]
    ;; %t15:i64 = const_i64 0
    ;; %t16:i64 = const_i64 0
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; %t19:i64 = call array_copy_str(%t14, %t15, new_data, %t16, %t18)
    ;; %t20:i64 = const_i64 0
    ;; v[%t20] = new_data  ; Array[str]
    ;; %t21:i64 = const_i64 2
    ;; v[%t21] = new_cap  ; i64
    ;; ret new_cap
    (i64.const 0)
  )
  (func $str_vec_push (export "str_vec_push") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $new_cap i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $new_data i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 2
    ;; %t4:i64 = v[%t3]
    ;; %t5:bool = cmp_ge_i64 %t2, %t4
    ;; jz %t5, .if_end_195
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_196
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_196
    ;; .if_end_196:
    ;; %t14:str = const_str 1
    ;; %t13:Array[str] = alloc_array(new_cap, init=%t14)
    ;; new_data:Array[str] = mov %t13
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[str] = v[%t15]
    ;; %t17:i64 = const_i64 0
    ;; %t18:i64 = const_i64 0
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = call array_copy_str(%t16, %t17, new_data, %t18, %t20)
    ;; %t22:i64 = const_i64 0
    ;; v[%t22] = new_data  ; Array[str]
    ;; %t23:i64 = const_i64 2
    ;; v[%t23] = new_cap  ; i64
    ;; jmp .if_end_195
    ;; .if_end_195:
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t25[%t27] = val  ; i64
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = v[%t28]
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = add_i64 %t29, %t30
    ;; %t32:i64 = const_i64 1
    ;; v[%t32] = %t31  ; i64
    ;; %t33:i64 = const_i64 1
    ;; %t34:i64 = v[%t33]
    ;; ret %t34
    (i64.const 0)
  )
  (func $str_vec_pop (export "str_vec_pop") (param $v i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 %t2, %t3
    ;; jz %t4, .if_end_197
    ;; %t5:str = const_str 1
    ;; ret %t5
    ;; jmp .if_end_197
    ;; .if_end_197:
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = sub_i64 %t7, %t8
    ;; %t10:i64 = const_i64 1
    ;; v[%t10] = %t9  ; i64
    ;; %t11:i64 = const_i64 0
    ;; %t12:Array[str] = v[%t11]
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = v[%t13]
    ;; %t15:str = %t12[%t14]
    ;; ret %t15
    (i64.const 0)
  )
  (func $str_vec_get (export "str_vec_get") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_198
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_198
    ;; .if_end_198:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_199
    ;; %t12:str = const_str 1
    ;; ret %t12
    ;; jmp .if_end_199
    ;; .if_end_199:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = v[%t13]
    ;; %t15:str = %t14[real_idx]
    ;; ret %t15
    (i64.const 0)
  )
  (func $str_vec_set (export "str_vec_set") (param $v i64) (param $idx i64) (param $val i64) (result i64)
    (local $real_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_200
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_200
    ;; .if_end_200:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_201
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_201
    ;; .if_end_201:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = v[%t13]
    ;; %t14[real_idx] = val  ; i64
    ;; %t15:i64 = const_i64 0
    ;; ret %t15
    (i64.const 0)
  )
  (func $str_vec_clear (export "str_vec_clear") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; v[%t2] = %t1  ; i64
    ;; %t3:i64 = const_i64 0
    ;; ret %t3
    (i64.const 0)
  )
  (func $str_vec_insert (export "str_vec_insert") (param $v i64) (param $idx i64) (param $val i64) (result i64)
    (local $real_idx i64)
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
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_202
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_202
    ;; .if_end_202:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_203
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_203
    ;; .if_end_203:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_204
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call str_vec_reserve(v, %t22)
    ;; jmp .if_end_204
    ;; .if_end_204:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_205:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_206
    ;; %t27:i64 = const_i64 0
    ;; %t28:Array[str] = v[%t27]
    ;; %t29:i64 = const_i64 0
    ;; %t30:Array[str] = v[%t29]
    ;; %t31:i64 = const_i64 1
    ;; %t32:i64 = sub_i64 i, %t31
    ;; %t33:str = %t30[%t32]
    ;; %t28[i] = %t33  ; i64
    ;; %t34:i64 = const_i64 1
    ;; %t35:i64 = sub_i64 i, %t34
    ;; i:i64 = mov %t35
    ;; jmp .while_cond_205
    ;; .while_end_206:
    ;; %t36:i64 = const_i64 0
    ;; %t37:Array[str] = v[%t36]
    ;; %t37[real_idx] = val  ; i64
    ;; %t38:i64 = const_i64 1
    ;; %t39:i64 = v[%t38]
    ;; %t40:i64 = const_i64 1
    ;; %t41:i64 = add_i64 %t39, %t40
    ;; %t42:i64 = const_i64 1
    ;; v[%t42] = %t41  ; i64
    ;; %t43:i64 = const_i64 1
    ;; %t44:i64 = v[%t43]
    ;; ret %t44
    (i64.const 0)
  )
  (func $str_vec_remove (export "str_vec_remove") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $val i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last i64)
    (local $t_t20 i64)
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_207
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_207
    ;; .if_end_207:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_208
    ;; %t12:str = const_str 1
    ;; ret %t12
    ;; jmp .if_end_208
    ;; .if_end_208:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = v[%t13]
    ;; %t15:str = %t14[real_idx]
    ;; val:str = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last:i64 = mov %t19
    ;; %t20:i64 = const_i64 1
    ;; i:i64 = mov real_idx
    ;; .for_cond_209:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_211
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[str] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:str = %t25[%t27]
    ;; %t23[i] = %t28  ; i64
    ;; .for_step_210:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_209
    ;; .for_end_211:
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = v[%t30]
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = sub_i64 %t31, %t32
    ;; %t34:i64 = const_i64 1
    ;; v[%t34] = %t33  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $str_vec_swap_remove (export "str_vec_swap_remove") (param $v i64) (param $idx i64) (result i64)
    (local $real_idx i64)
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
    (local $val i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $last_idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; real_idx:i64 = mov idx
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 real_idx, %t1
    ;; jz %t2, .if_end_212
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_212
    ;; .if_end_212:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_213
    ;; %t12:str = const_str 1
    ;; ret %t12
    ;; jmp .if_end_213
    ;; .if_end_213:
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = v[%t13]
    ;; %t15:str = %t14[real_idx]
    ;; val:str = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = v[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = sub_i64 %t17, %t18
    ;; last_idx:i64 = mov %t19
    ;; %t20:bool = cmp_ne_i64 real_idx, last_idx
    ;; jz %t20, .if_end_214
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[str] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[str] = v[%t23]
    ;; %t25:str = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; i64
    ;; jmp .if_end_214
    ;; .if_end_214:
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = v[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = sub_i64 %t27, %t28
    ;; %t30:i64 = const_i64 1
    ;; v[%t30] = %t29  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $str_vec_extend (export "str_vec_extend") (param $dst i64) (param $src i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $needed i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = dst[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = src[%t3]
    ;; %t5:i64 = add_i64 %t2, %t4
    ;; needed:i64 = mov %t5
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = dst[%t6]
    ;; %t8:bool = cmp_gt_i64 needed, %t7
    ;; jz %t8, .if_end_215
    ;; %t9:i64 = call str_vec_reserve(dst, needed)
    ;; jmp .if_end_215
    ;; .if_end_215:
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[str] = src[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:i64 = const_i64 0
    ;; %t14:Array[str] = dst[%t13]
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = dst[%t15]
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = src[%t17]
    ;; %t19:i64 = call array_copy_str(%t11, %t12, %t14, %t16, %t18)
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = dst[%t20]
    ;; %t22:i64 = const_i64 1
    ;; %t23:i64 = src[%t22]
    ;; %t24:i64 = add_i64 %t21, %t23
    ;; %t25:i64 = const_i64 1
    ;; dst[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = dst[%t26]
    ;; ret %t27
    (i64.const 0)
  )
  (func $str_vec_copy (export "str_vec_copy") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $c i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $buf i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = v[%t1]
    ;; c:i64 = mov %t2
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_le_i64 c, %t3
    ;; jz %t4, .if_end_216
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_216
    ;; .if_end_216:
    ;; %t7:str = const_str 1
    ;; %t6:Array[str] = alloc_array(c, init=%t7)
    ;; buf:Array[str] = mov %t6
    ;; %t8:i64 = const_i64 0
    ;; %t9:Array[str] = v[%t8]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = v[%t12]
    ;; %t14:i64 = call array_copy_str(%t9, %t10, buf, %t11, %t13)
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = const_i64 0
    ;; %t15:StrVector = alloc_array(%t16, init=%t17)
    ;; %t18:i64 = const_i64 0
    ;; %t15[%t18] = buf  ; Array[str]
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 1
    ;; %t15[%t21] = %t20  ; i64
    ;; %t22:i64 = const_i64 2
    ;; %t15[%t22] = c  ; i64
    ;; ret %t15
    (i64.const 0)
  )
  (func $str_vec_slice (export "str_vec_slice") (param $v i64) (param $start i64) (param $stop i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $e i64)
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
    (local $slice_len i64)
    (local $t_t23 i64)
    (local $res i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov start
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 s, %t1
    ;; jz %t2, .if_end_217
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_218
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_218
    ;; .if_end_218:
    ;; jmp .if_end_217
    ;; .if_end_217:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_219
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_219
    ;; .if_end_219:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_220
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_220
    ;; .if_end_220:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_221
    ;; %t20:i64 = const_i64 4
    ;; %t21:StrVector = call str_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_221
    ;; .if_end_221:
    ;; %t22:i64 = sub_i64 e, s
    ;; slice_len:i64 = mov %t22
    ;; %t23:StrVector = call str_vec_new(slice_len)
    ;; res:StrVector = mov %t23
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:i64 = const_i64 0
    ;; %t27:Array[str] = res[%t26]
    ;; %t28:i64 = const_i64 0
    ;; %t29:i64 = call array_copy_str(%t25, s, %t27, %t28, slice_len)
    ;; %t30:i64 = const_i64 1
    ;; res[%t30] = slice_len  ; i64
    ;; ret res
    (i64.const 0)
  )
  (func $str_vec_contains (export "str_vec_contains") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_222:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_224
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[str] = v[%t6]
    ;; %t8:str = %t7[i]
    ;; %t9:bool = str_cmp_eq %t8, val
    ;; jz %t9, .if_end_225
    ;; %t10:bool = const_i64 1
    ;; ret %t10
    ;; jmp .if_end_225
    ;; .if_end_225:
    ;; .for_step_223:
    ;; %t11:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_222
    ;; .for_end_224:
    ;; %t12:bool = const_i64 0
    ;; ret %t12
    (i64.const 0)
  )
  (func $str_vec_index_of (export "str_vec_index_of") (param $v i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_226:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_228
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[str] = v[%t6]
    ;; %t8:str = %t7[i]
    ;; %t9:bool = str_cmp_eq %t8, val
    ;; jz %t9, .if_end_229
    ;; ret i
    ;; jmp .if_end_229
    ;; .if_end_229:
    ;; .for_step_227:
    ;; %t10:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t10
    ;; jmp .for_cond_226
    ;; .for_end_228:
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = neg_i64 %t11
    ;; ret %t12
    (i64.const 0)
  )
  (func $str_vec_join (export "str_vec_join") (param $v i64) (param $sep i64) (result i64)
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
    (local $res i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $i i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; jz %t4, .if_end_230
    ;; %t5:str = const_str 1
    ;; ret %t5
    ;; jmp .if_end_230
    ;; .if_end_230:
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:bool = cmp_eq_i64 %t7, %t8
    ;; jz %t9, .if_end_231
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[str] = v[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:str = %t11[%t12]
    ;; ret %t13
    ;; jmp .if_end_231
    ;; .if_end_231:
    ;; %t14:i64 = const_i64 0
    ;; %t15:Array[str] = v[%t14]
    ;; %t16:i64 = const_i64 0
    ;; %t17:str = %t15[%t16]
    ;; res:str = mov %t17
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 1
    ;; i:i64 = mov %t18
    ;; .for_cond_232:
    ;; %t22:bool = cmp_lt_i64 i, %t20
    ;; jz %t22, .for_end_234
    ;; %t23:str = str_concat(res, sep)
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:str = %t25[i]
    ;; %t27:str = str_concat(%t23, %t26)
    ;; res:str = mov %t27
    ;; .for_step_233:
    ;; %t28:i64 = add_i64 i, %t21
    ;; i:i64 = mov %t28
    ;; jmp .for_cond_232
    ;; .for_end_234:
    ;; ret res
    (i64.const 0)
  )
  (func $str_vec_reverse (export "str_vec_reverse") (param $v i64) (result i64)
    (local $t_t1 i64)
    (local $i i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $j i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $tmp i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; i:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = v[%t2]
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = sub_i64 %t3, %t4
    ;; j:i64 = mov %t5
    ;; .while_cond_235:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_236
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[str] = v[%t7]
    ;; %t9:str = %t8[i]
    ;; tmp:str = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[str] = v[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:Array[str] = v[%t12]
    ;; %t14:str = %t13[j]
    ;; %t11[i] = %t14  ; i64
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[str] = v[%t15]
    ;; %t16[j] = tmp  ; i64
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = add_i64 i, %t17
    ;; i:i64 = mov %t18
    ;; %t19:i64 = const_i64 1
    ;; %t20:i64 = sub_i64 j, %t19
    ;; j:i64 = mov %t20
    ;; jmp .while_cond_235
    ;; .while_end_236:
    ;; %t21:i64 = const_i64 0
    ;; ret %t21
    (i64.const 0)
  )
  (func $str_vec_to_str (export "str_vec_to_str") (param $v i64) (result i64)
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
    (local $res i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $i i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = v[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_eq_i64 %t2, %t3
    ;; jz %t4, .if_end_237
    ;; %t5:str = const_str 47
    ;; ret %t5
    ;; jmp .if_end_237
    ;; .if_end_237:
    ;; %t6:str = const_str 51
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[str] = v[%t7]
    ;; %t9:i64 = const_i64 0
    ;; %t10:str = %t8[%t9]
    ;; %t11:str = str_concat(%t6, %t10)
    ;; %t12:str = const_str 24
    ;; %t13:str = str_concat(%t11, %t12)
    ;; res:str = mov %t13
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = v[%t15]
    ;; %t17:i64 = const_i64 1
    ;; i:i64 = mov %t14
    ;; .for_cond_238:
    ;; %t18:bool = cmp_lt_i64 i, %t16
    ;; jz %t18, .for_end_240
    ;; %t19:str = const_str 52
    ;; %t20:str = str_concat(res, %t19)
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[str] = v[%t21]
    ;; %t23:str = %t22[i]
    ;; %t24:str = str_concat(%t20, %t23)
    ;; %t25:str = const_str 24
    ;; %t26:str = str_concat(%t24, %t25)
    ;; res:str = mov %t26
    ;; .for_step_239:
    ;; %t27:i64 = add_i64 i, %t17
    ;; i:i64 = mov %t27
    ;; jmp .for_cond_238
    ;; .for_end_240:
    ;; %t28:str = const_str 50
    ;; %t29:str = str_concat(res, %t28)
    ;; res:str = mov %t29
    ;; ret res
    (i64.const 0)
  )
  (func $int_slice_new (export "int_slice_new") (param $arr i64) (param $offset i64) (param $length i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t2:i64 = const_i64 3
    ;; %t3:i64 = const_i64 0
    ;; %t1:IntSlice = alloc_array(%t2, init=%t3)
    ;; %t4:i64 = const_i64 0
    ;; %t1[%t4] = arr  ; Array[i64]
    ;; %t5:i64 = const_i64 1
    ;; %t1[%t5] = offset  ; i64
    ;; %t6:i64 = const_i64 2
    ;; %t1[%t6] = length  ; i64
    ;; ret %t1
    (i64.const 0)
  )
  (func $int_slice_from_vec (export "int_slice_from_vec") (param $v i64) (param $start i64) (param $stop i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $e i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov start
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 s, %t1
    ;; jz %t2, .if_end_241
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_242
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_242
    ;; .if_end_242:
    ;; jmp .if_end_241
    ;; .if_end_241:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_243
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_243
    ;; .if_end_243:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_244
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_244
    ;; .if_end_244:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_245
    ;; %t21:i64 = const_i64 3
    ;; %t22:i64 = const_i64 0
    ;; %t20:IntSlice = alloc_array(%t21, init=%t22)
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[i64] = v[%t23]
    ;; %t25:i64 = const_i64 0
    ;; %t20[%t25] = %t24  ; Array[i64]
    ;; %t26:i64 = const_i64 1
    ;; %t20[%t26] = s  ; i64
    ;; %t27:i64 = const_i64 0
    ;; %t28:i64 = const_i64 2
    ;; %t20[%t28] = %t27  ; i64
    ;; ret %t20
    ;; jmp .if_end_245
    ;; .if_end_245:
    ;; %t30:i64 = const_i64 3
    ;; %t31:i64 = const_i64 0
    ;; %t29:IntSlice = alloc_array(%t30, init=%t31)
    ;; %t32:i64 = const_i64 0
    ;; %t33:Array[i64] = v[%t32]
    ;; %t34:i64 = const_i64 0
    ;; %t29[%t34] = %t33  ; Array[i64]
    ;; %t35:i64 = const_i64 1
    ;; %t29[%t35] = s  ; i64
    ;; %t36:i64 = sub_i64 e, s
    ;; %t37:i64 = const_i64 2
    ;; %t29[%t37] = %t36  ; i64
    ;; ret %t29
    (i64.const 0)
  )
  (func $int_slice_get (export "int_slice_get") (param $s i64) (param $idx i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $real_idx i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, idx
    ;; real_idx:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[i64] = s[%t4]
    ;; %t6:i64 = %t5[real_idx]
    ;; ret %t6
    (i64.const 0)
  )
  (func $int_slice_set (export "int_slice_set") (param $s i64) (param $idx i64) (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $real_idx i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, idx
    ;; real_idx:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[i64] = s[%t4]
    ;; %t5[real_idx] = val  ; i64
    ;; ret val
    (i64.const 0)
  )
  (func $int_slice_subslice (export "int_slice_subslice") (param $s i64) (param $start i64) (param $length i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $new_offset i64)
    (local $new_len i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, start
    ;; new_offset:i64 = mov %t3
    ;; new_len:i64 = mov length
    ;; %t4:i64 = add_i64 new_offset, new_len
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = s[%t5]
    ;; %t7:i64 = const_i64 2
    ;; %t8:i64 = s[%t7]
    ;; %t9:i64 = add_i64 %t6, %t8
    ;; %t10:bool = cmp_gt_i64 %t4, %t9
    ;; jz %t10, .if_end_246
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = const_i64 2
    ;; %t14:i64 = s[%t13]
    ;; %t15:i64 = add_i64 %t12, %t14
    ;; %t16:i64 = sub_i64 %t15, new_offset
    ;; new_len:i64 = mov %t16
    ;; %t17:i64 = const_i64 0
    ;; %t18:bool = cmp_lt_i64 new_len, %t17
    ;; jz %t18, .if_end_247
    ;; %t19:i64 = const_i64 0
    ;; new_len:i64 = mov %t19
    ;; jmp .if_end_247
    ;; .if_end_247:
    ;; jmp .if_end_246
    ;; .if_end_246:
    ;; %t21:i64 = const_i64 3
    ;; %t22:i64 = const_i64 0
    ;; %t20:IntSlice = alloc_array(%t21, init=%t22)
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[i64] = s[%t23]
    ;; %t25:i64 = const_i64 0
    ;; %t20[%t25] = %t24  ; Array[i64]
    ;; %t26:i64 = const_i64 1
    ;; %t20[%t26] = new_offset  ; i64
    ;; %t27:i64 = const_i64 2
    ;; %t20[%t27] = new_len  ; i64
    ;; ret %t20
    (i64.const 0)
  )
  (func $int_slice_to_vec (export "int_slice_to_vec") (param $s i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $res i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = s[%t1]
    ;; %t3:IntVector = call int_vec_new(%t2)
    ;; res:IntVector = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[i64] = s[%t4]
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = s[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:Array[i64] = res[%t8]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 2
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = call array_copy_i64(%t5, %t7, %t9, %t10, %t12)
    ;; %t14:i64 = const_i64 2
    ;; %t15:i64 = s[%t14]
    ;; %t16:i64 = const_i64 1
    ;; res[%t16] = %t15  ; i64
    ;; ret res
    (i64.const 0)
  )
  (func $float_slice_new (export "float_slice_new") (param $arr i64) (param $offset i64) (param $length i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t2:i64 = const_i64 3
    ;; %t3:i64 = const_i64 0
    ;; %t1:FloatSlice = alloc_array(%t2, init=%t3)
    ;; %t4:i64 = const_i64 0
    ;; %t1[%t4] = arr  ; Array[f64]
    ;; %t5:i64 = const_i64 1
    ;; %t1[%t5] = offset  ; i64
    ;; %t6:i64 = const_i64 2
    ;; %t1[%t6] = length  ; i64
    ;; ret %t1
    (i64.const 0)
  )
  (func $float_slice_from_vec (export "float_slice_from_vec") (param $v i64) (param $start i64) (param $stop i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $e i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov start
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 s, %t1
    ;; jz %t2, .if_end_248
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_249
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_249
    ;; .if_end_249:
    ;; jmp .if_end_248
    ;; .if_end_248:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_250
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_250
    ;; .if_end_250:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_251
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_251
    ;; .if_end_251:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_252
    ;; %t21:i64 = const_i64 3
    ;; %t22:i64 = const_i64 0
    ;; %t20:FloatSlice = alloc_array(%t21, init=%t22)
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[f64] = v[%t23]
    ;; %t25:i64 = const_i64 0
    ;; %t20[%t25] = %t24  ; Array[f64]
    ;; %t26:i64 = const_i64 1
    ;; %t20[%t26] = s  ; i64
    ;; %t27:i64 = const_i64 0
    ;; %t28:i64 = const_i64 2
    ;; %t20[%t28] = %t27  ; i64
    ;; ret %t20
    ;; jmp .if_end_252
    ;; .if_end_252:
    ;; %t30:i64 = const_i64 3
    ;; %t31:i64 = const_i64 0
    ;; %t29:FloatSlice = alloc_array(%t30, init=%t31)
    ;; %t32:i64 = const_i64 0
    ;; %t33:Array[f64] = v[%t32]
    ;; %t34:i64 = const_i64 0
    ;; %t29[%t34] = %t33  ; Array[f64]
    ;; %t35:i64 = const_i64 1
    ;; %t29[%t35] = s  ; i64
    ;; %t36:i64 = sub_i64 e, s
    ;; %t37:i64 = const_i64 2
    ;; %t29[%t37] = %t36  ; i64
    ;; ret %t29
    (i64.const 0)
  )
  (func $float_slice_get (export "float_slice_get") (param $s i64) (param $idx i64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $real_idx i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, idx
    ;; real_idx:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[f64] = s[%t4]
    ;; %t6:f64 = %t5[real_idx]
    ;; ret %t6
    (f64.const 0.0)
  )
  (func $float_slice_set (export "float_slice_set") (param $s i64) (param $idx i64) (param $val f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $real_idx i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, idx
    ;; real_idx:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[f64] = s[%t4]
    ;; %t5[real_idx] = val  ; f64
    ;; %t6:i64 = const_i64 0
    ;; ret %t6
    (i64.const 0)
  )
  (func $float_slice_subslice (export "float_slice_subslice") (param $s i64) (param $start i64) (param $length i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $new_offset i64)
    (local $new_len i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = s[%t1]
    ;; %t3:i64 = add_i64 %t2, start
    ;; new_offset:i64 = mov %t3
    ;; new_len:i64 = mov length
    ;; %t4:i64 = add_i64 new_offset, new_len
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = s[%t5]
    ;; %t7:i64 = const_i64 2
    ;; %t8:i64 = s[%t7]
    ;; %t9:i64 = add_i64 %t6, %t8
    ;; %t10:bool = cmp_gt_i64 %t4, %t9
    ;; jz %t10, .if_end_253
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = const_i64 2
    ;; %t14:i64 = s[%t13]
    ;; %t15:i64 = add_i64 %t12, %t14
    ;; %t16:i64 = sub_i64 %t15, new_offset
    ;; new_len:i64 = mov %t16
    ;; %t17:i64 = const_i64 0
    ;; %t18:bool = cmp_lt_i64 new_len, %t17
    ;; jz %t18, .if_end_254
    ;; %t19:i64 = const_i64 0
    ;; new_len:i64 = mov %t19
    ;; jmp .if_end_254
    ;; .if_end_254:
    ;; jmp .if_end_253
    ;; .if_end_253:
    ;; %t21:i64 = const_i64 3
    ;; %t22:i64 = const_i64 0
    ;; %t20:FloatSlice = alloc_array(%t21, init=%t22)
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[f64] = s[%t23]
    ;; %t25:i64 = const_i64 0
    ;; %t20[%t25] = %t24  ; Array[f64]
    ;; %t26:i64 = const_i64 1
    ;; %t20[%t26] = new_offset  ; i64
    ;; %t27:i64 = const_i64 2
    ;; %t20[%t27] = new_len  ; i64
    ;; ret %t20
    (i64.const 0)
  )
  (func $float_slice_to_vec (export "float_slice_to_vec") (param $s i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $res i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = s[%t1]
    ;; %t3:FloatVector = call float_vec_new(%t2)
    ;; res:FloatVector = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:Array[f64] = s[%t4]
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = s[%t6]
    ;; %t8:i64 = const_i64 0
    ;; %t9:Array[f64] = res[%t8]
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 2
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = call array_copy_f64(%t5, %t7, %t9, %t10, %t12)
    ;; %t14:i64 = const_i64 2
    ;; %t15:i64 = s[%t14]
    ;; %t16:i64 = const_i64 1
    ;; res[%t16] = %t15  ; i64
    ;; ret res
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $runner i64)
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
    (local $t_t39 f64)
    (local $t_t40 f64)
    (local $t_t41 f64)
    (local $t_t42 f64)
    (local $t_t43 f64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $t_t46 f64)
    (local $t_t47 f64)
    (local $t_t48 i64)
    (local $t_t49 i64)
    (local $t_t50 i64)
    (local $t_t51 f64)
    (local $t_t52 f64)
    (local $t_t53 i64)
    (local $t_t54 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $t_t64 i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $t_t67 i64)
    (local $t_t68 i64)
    (local $t_t69 i64)
    (local $t_t70 i64)
    (local $t_t71 i64)
    (local $t_t72 i64)
    (local $t_t73 i64)
    (local $t_t74 i64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $t_t77 i64)
    (local $t_t78 i64)
    (local $t_t79 i64)
    (local $t_t80 i64)
    (local $t_t81 i64)
    (local $t_t82 i64)
    (local $t_t83 i64)
    (local $t_t84 i64)
    (local $v i64)
    (local $t_t85 i64)
    (local $t_t86 i64)
    (local $t_t87 i64)
    (local $t_t88 i64)
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $t_t93 i64)
    (local $t_t94 i64)
    (local $t_t95 i64)
    (local $t_t96 i64)
    (local $t_t97 i64)
    (local $t_t98 i64)
    (local $t_t99 i64)
    (local $t_t100 i64)
    (local $t_t101 i64)
    (local $t_t102 i64)
    (local $t_t103 i64)
    (local $t_t104 i64)
    (local $t_t105 i64)
    (local $t_t106 i64)
    (local $t_t107 i64)
    (local $t_t108 i64)
    (local $t_t109 i64)
    (local $t_t110 i64)
    (local $t_t111 i64)
    (local $t_t112 i64)
    (local $t_t113 i64)
    (local $t_t114 i64)
    (local $t_t115 i64)
    (local $bs_idx i64)
    (local $t_t116 i64)
    (local $t_t117 i64)
    (local $t_t118 i64)
    (local $t_t119 i64)
    (local $t_t120 i64)
    (local $t_t121 i64)
    (local $t_t122 i64)
    (local $t_t123 i64)
    (local $b1_iters i64)
    (local $t_t124 i64)
    (local $b1_start i64)
    (local $t_t125 i64)
    (local $b1_acc i64)
    (local $t_t126 i64)
    (local $t_t127 i64)
    (local $i i64)
    (local $t_t128 i64)
    (local $t_t129 i64)
    (local $t_t130 i64)
    (local $t_t131 i64)
    (local $t_t132 i64)
    (local $t_t133 i64)
    (local $t_t134 i64)
    (local $b1_elapsed i64)
    (local $t_t135 i64)
    (local $t_t136 i64)
    (local $b1 i64)
    (local $t_t137 i64)
    (local $t_t138 i64)
    (local $b2_iters i64)
    (local $t_t139 i64)
    (local $b2_vec i64)
    (local $t_t140 i64)
    (local $b2_start i64)
    (local $t_t141 i64)
    (local $t_t142 i64)
    (local $t_t143 i64)
    (local $t_t144 i64)
    (local $t_t145 i64)
    (local $t_t146 i64)
    (local $t_t147 i64)
    (local $t_t148 i64)
    (local $t_t149 i64)
    (local $t_t150 i64)
    (local $t_t151 i64)
    (local $t_t152 i64)
    (local $b2_elapsed i64)
    (local $t_t153 i64)
    (local $t_t154 i64)
    (local $t_t155 i64)
    (local $t_t156 i64)
    (local $b2 i64)
    (local $t_t157 i64)
    (local $t_t158 i64)
    (local $b3_iters i64)
    (local $t_t159 i64)
    (local $b3_src i64)
    (local $t_t160 i64)
    (local $b3_start i64)
    (local $t_t161 i64)
    (local $b3_matches i64)
    (local $t_t162 i64)
    (local $t_t163 i64)
    (local $t_t164 i64)
    (local $t_t165 i64)
    (local $t_t166 i64)
    (local $t_t167 i64)
    (local $sub i64)
    (local $t_t168 i64)
    (local $t_t169 i64)
    (local $t_t170 i64)
    (local $t_t171 i64)
    (local $t_t172 i64)
    (local $t_t173 i64)
    (local $t_t174 i64)
    (local $b3_elapsed i64)
    (local $t_t175 i64)
    (local $t_t176 i64)
    (local $b3 i64)
    (local $t_t177 i64)
    (local $t_t178 i64)
    (local $t_arena_sp_main i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_main:i64 = arena_save None
    ;; %t1:str = const_str 53
    ;; print(%t1:str)
    ;; %t2:str = const_str 54
    ;; print(%t2:str)
    ;; %t3:str = const_str 53
    ;; print(%t3:str)
    ;; %t4:bool = const_i64 1
    ;; %t5:TestRunner = call test_runner_new(%t4)
    ;; runner:TestRunner = mov %t5
    ;; %t6:str = const_str 55
    ;; %t7:i64 = call test_suite(runner, %t6)
    ;; %t8:str = const_str 56
    ;; %t9:i64 = call test_case(runner, %t8)
    ;; %t12:i64 = const_i64 1048576
    ;; %t13:i64 = const_i64 1048576
    ;; %t14:str = const_str 57
    ;; %t15:bool = call assert_eq_i64(runner, %t12, %t13, %t14)
    ;; %t16:i64 = const_i64 42
    ;; %t17:i64 = const_i64 43
    ;; %t18:str = const_str 58
    ;; %t19:bool = call assert_ne_i64(runner, %t16, %t17, %t18)
    ;; %t20:i64 = const_i64 10
    ;; %t21:i64 = neg_i64 %t20
    ;; %t22:i64 = const_i64 0
    ;; %t23:str = const_str 59
    ;; %t24:bool = call assert_lt_i64(runner, %t21, %t22, %t23)
    ;; %t25:i64 = const_i64 100
    ;; %t26:i64 = const_i64 100
    ;; %t27:str = const_str 60
    ;; %t28:bool = call assert_le_i64(runner, %t25, %t26, %t27)
    ;; %t29:i64 = const_i64 100
    ;; %t30:i64 = const_i64 99
    ;; %t31:str = const_str 61
    ;; %t32:bool = call assert_gt_i64(runner, %t29, %t30, %t31)
    ;; %t33:i64 = const_i64 50
    ;; %t34:i64 = const_i64 50
    ;; %t35:str = const_str 62
    ;; %t36:bool = call assert_ge_i64(runner, %t33, %t34, %t35)
    ;; %t37:str = const_str 63
    ;; %t38:i64 = call test_case(runner, %t37)
    ;; %t41:f64 = const_f64 0.30000000000000004
    ;; %t42:f64 = const_f64 0.3
    ;; %t43:f64 = const_f64 1e-06
    ;; %t44:str = const_str 64
    ;; %t45:bool = call assert_eq_f64(runner, %t41, %t42, %t43, %t44)
    ;; %t48:bool = const_i64 1
    ;; %t49:str = const_str 65
    ;; %t50:bool = call assert_true(runner, %t48, %t49)
    ;; %t53:bool = const_i64 0
    ;; %t54:str = const_str 66
    ;; %t55:bool = call assert_false(runner, %t53, %t54)
    ;; %t56:str = const_str 67
    ;; %t57:i64 = call test_suite(runner, %t56)
    ;; %t58:str = const_str 68
    ;; %t59:i64 = call test_case(runner, %t58)
    ;; %t60:str = const_str 69
    ;; %t61:str = const_str 70
    ;; %t62:str = str_concat(%t60, %t61)
    ;; %t63:str = const_str 71
    ;; %t64:str = const_str 72
    ;; %t65:bool = call assert_eq_str(runner, %t62, %t63, %t64)
    ;; %t66:str = const_str 73
    ;; %t67:str = const_str 74
    ;; %t68:str = const_str 75
    ;; %t69:bool = call assert_ne_str(runner, %t66, %t67, %t68)
    ;; %t70:str = const_str 76
    ;; %t71:str = const_str 77
    ;; %t72:str = const_str 78
    ;; %t73:bool = call assert_str_contains(runner, %t70, %t71, %t72)
    ;; %t74:str = const_str 79
    ;; %t75:str = const_str 80
    ;; %t76:bool = call str_contains(%t74, %t75)
    ;; %t77:str = const_str 81
    ;; %t78:bool = call assert_false(runner, %t76, %t77)
    ;; %t79:str = const_str 82
    ;; %t80:i64 = call test_suite(runner, %t79)
    ;; %t81:str = const_str 83
    ;; %t82:i64 = call test_case(runner, %t81)
    ;; %t83:i64 = const_i64 2
    ;; %t84:IntVector = call int_vec_new(%t83)
    ;; v:IntVector = mov %t84
    ;; %t85:i64 = const_i64 40
    ;; %t86:i64 = call int_vec_push(v, %t85)
    ;; %t87:i64 = const_i64 10
    ;; %t88:i64 = call int_vec_push(v, %t87)
    ;; %t89:i64 = const_i64 30
    ;; %t90:i64 = call int_vec_push(v, %t89)
    ;; %t91:i64 = const_i64 20
    ;; %t92:i64 = call int_vec_push(v, %t91)
    ;; %t93:i64 = call int_vec_len(v)
    ;; %t94:i64 = const_i64 4
    ;; %t95:str = const_str 84
    ;; %t96:bool = call assert_eq_i64(runner, %t93, %t94, %t95)
    ;; %t97:i64 = const_i64 1
    ;; %t98:i64 = neg_i64 %t97
    ;; %t99:i64 = call int_vec_get(v, %t98)
    ;; %t100:i64 = const_i64 20
    ;; %t101:str = const_str 85
    ;; %t102:bool = call assert_eq_i64(runner, %t99, %t100, %t101)
    ;; %t103:i64 = call int_vec_sort(v)
    ;; %t104:i64 = const_i64 0
    ;; %t105:i64 = call int_vec_get(v, %t104)
    ;; %t106:i64 = const_i64 10
    ;; %t107:str = const_str 86
    ;; %t108:bool = call assert_eq_i64(runner, %t105, %t106, %t107)
    ;; %t109:i64 = const_i64 3
    ;; %t110:i64 = call int_vec_get(v, %t109)
    ;; %t111:i64 = const_i64 40
    ;; %t112:str = const_str 87
    ;; %t113:bool = call assert_eq_i64(runner, %t110, %t111, %t112)
    ;; %t114:i64 = const_i64 30
    ;; %t115:i64 = call int_vec_binary_search(v, %t114)
    ;; bs_idx:i64 = mov %t115
    ;; %t116:i64 = const_i64 2
    ;; %t117:str = const_str 88
    ;; %t118:bool = call assert_eq_i64(runner, bs_idx, %t116, %t117)
    ;; %t119:str = const_str 1
    ;; print(%t119:str)
    ;; %t120:str = const_str 53
    ;; print(%t120:str)
    ;; %t121:str = const_str 89
    ;; print(%t121:str)
    ;; %t122:str = const_str 53
    ;; print(%t122:str)
    ;; %t123:i64 = const_i64 1000000
    ;; b1_iters:i64 = mov %t123
    ;; %t124:i64 = clock_ns None
    ;; b1_start:i64 = mov %t124
    ;; %t125:i64 = const_i64 0
    ;; b1_acc:i64 = mov %t125
    ;; %t126:i64 = const_i64 0
    ;; %t127:i64 = const_i64 1
    ;; i:i64 = mov %t126
    ;; .for_cond_255:
    ;; %t128:bool = cmp_lt_i64 i, b1_iters
    ;; jz %t128, .for_end_257
    ;; %t129:i64 = add_i64 b1_acc, i
    ;; %t130:i64 = const_i64 1431655765
    ;; %t131:i64 = xor_i64 %t129, %t130
    ;; b1_acc:i64 = mov %t131
    ;; .for_step_256:
    ;; %t132:i64 = add_i64 i, %t127
    ;; i:i64 = mov %t132
    ;; jmp .for_cond_255
    ;; .for_end_257:
    ;; %t133:i64 = clock_ns None
    ;; %t134:i64 = sub_i64 %t133, b1_start
    ;; b1_elapsed:i64 = mov %t134
    ;; %t135:str = const_str 90
    ;; %t136:BenchmarkResult = call benchmark_create(%t135, b1_iters, b1_elapsed)
    ;; b1:BenchmarkResult = mov %t136
    ;; %t137:i64 = call benchmark_print(b1)
    ;; %t138:i64 = const_i64 100000
    ;; b2_iters:i64 = mov %t138
    ;; %t139:IntVector = call int_vec_new(b2_iters)
    ;; b2_vec:IntVector = mov %t139
    ;; %t140:i64 = clock_ns None
    ;; b2_start:i64 = mov %t140
    ;; %t141:i64 = const_i64 0
    ;; %t142:i64 = const_i64 1
    ;; i:i64 = mov %t141
    ;; .for_cond_258:
    ;; %t143:bool = cmp_lt_i64 i, b2_iters
    ;; jz %t143, .for_end_260
    ;; %t144:i64 = call int_vec_push(b2_vec, i)
    ;; .for_step_259:
    ;; %t145:i64 = add_i64 i, %t142
    ;; i:i64 = mov %t145
    ;; jmp .for_cond_258
    ;; .for_end_260:
    ;; %t146:i64 = const_i64 0
    ;; %t147:i64 = const_i64 1
    ;; i:i64 = mov %t146
    ;; .for_cond_261:
    ;; %t148:bool = cmp_lt_i64 i, b2_iters
    ;; jz %t148, .for_end_263
    ;; %t149:i64 = call int_vec_pop(b2_vec)
    ;; .for_step_262:
    ;; %t150:i64 = add_i64 i, %t147
    ;; i:i64 = mov %t150
    ;; jmp .for_cond_261
    ;; .for_end_263:
    ;; %t151:i64 = clock_ns None
    ;; %t152:i64 = sub_i64 %t151, b2_start
    ;; b2_elapsed:i64 = mov %t152
    ;; %t153:str = const_str 91
    ;; %t154:i64 = const_i64 2
    ;; %t155:i64 = mul_i64 b2_iters, %t154
    ;; %t156:BenchmarkResult = call benchmark_create(%t153, %t155, b2_elapsed)
    ;; b2:BenchmarkResult = mov %t156
    ;; %t157:i64 = call benchmark_print(b2)
    ;; %t158:i64 = const_i64 50000
    ;; b3_iters:i64 = mov %t158
    ;; %t159:str = const_str 92
    ;; b3_src:str = mov %t159
    ;; %t160:i64 = clock_ns None
    ;; b3_start:i64 = mov %t160
    ;; %t161:i64 = const_i64 0
    ;; b3_matches:i64 = mov %t161
    ;; %t162:i64 = const_i64 0
    ;; %t163:i64 = const_i64 1
    ;; i:i64 = mov %t162
    ;; .for_cond_264:
    ;; %t164:bool = cmp_lt_i64 i, b3_iters
    ;; jz %t164, .for_end_266
    ;; %t165:i64 = const_i64 6
    ;; %t166:i64 = const_i64 11
    ;; %t167:str = str_slice(b3_src[%t165:%t166])
    ;; sub:str = mov %t167
    ;; %t168:str = const_str 93
    ;; %t169:bool = str_cmp_eq sub, %t168
    ;; jz %t169, .if_end_267
    ;; %t170:i64 = const_i64 1
    ;; %t171:i64 = add_i64 b3_matches, %t170
    ;; b3_matches:i64 = mov %t171
    ;; jmp .if_end_267
    ;; .if_end_267:
    ;; .for_step_265:
    ;; %t172:i64 = add_i64 i, %t163
    ;; i:i64 = mov %t172
    ;; jmp .for_cond_264
    ;; .for_end_266:
    ;; %t173:i64 = clock_ns None
    ;; %t174:i64 = sub_i64 %t173, b3_start
    ;; b3_elapsed:i64 = mov %t174
    ;; %t175:str = const_str 94
    ;; %t176:BenchmarkResult = call benchmark_create(%t175, b3_iters, b3_elapsed)
    ;; b3:BenchmarkResult = mov %t176
    ;; %t177:i64 = call benchmark_print(b3)
    ;; %t178:i64 = call test_summary(runner)
    ;; arena_restore %arena_sp_main
    ;; ret %t178
    (i64.const 0)
  )
)