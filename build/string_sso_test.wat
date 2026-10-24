(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $test_sso_and_slicing (export "test_sso_and_slicing")  (result i64)
    (local $t_t1 i64)
    (local $s1 i64)
    (local $t_t2 i64)
    (local $s2 i64)
    (local $t_t3 i64)
    (local $s3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $full i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $sub1 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $sub2 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $sub_tail i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $sub_head i64)
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
    (local $ch0 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $ch6 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $t_t43 i64)
    (local $is_match1 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $is_match2 i64)
    (local $t_t46 i64)
    (local $t_t47 i64)
    (local $t_t48 f64)
    (local $speedup f64)
    (local $t_t49 i64)
    (local $t_t50 i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $t_t53 i64)
    (local $status i64)
    (local $t_t54 i64)
    (local $t_arena_sp_test_sso_and_slicing i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_test_sso_and_slicing:i64 = arena_save None
    ;; %t1:str = const_str 0
    ;; s1:str = mov %t1
    ;; %t2:str = const_str 1
    ;; s2:str = mov %t2
    ;; %t3:str = const_str 2
    ;; s3:str = mov %t3
    ;; %t4:str = str_concat(s1, s2)
    ;; %t5:str = str_concat(%t4, s3)
    ;; full:str = mov %t5
    ;; %t6:str = const_str 3
    ;; %t7:str = const_str 4
    ;; print(%t6:str, full:str, %t7:str)
    ;; %t8:str = const_str 5
    ;; %t9:str = const_str 6
    ;; %t10:i64 = str_len(full)
    ;; print(%t8:str, full:str, %t9:str, %t10:i64)
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = const_i64 5
    ;; %t13:str = str_slice(full[%t11:%t12])
    ;; sub1:str = mov %t13
    ;; %t14:i64 = const_i64 6
    ;; %t15:i64 = const_i64 11
    ;; %t16:str = str_slice(full[%t14:%t15])
    ;; sub2:str = mov %t16
    ;; %t17:i64 = const_i64 6
    ;; %t18:i64 = const_i64 -1
    ;; %t19:str = str_slice(full[%t17:%t18])
    ;; sub_tail:str = mov %t19
    ;; %t20:i64 = const_i64 0
    ;; %t21:i64 = const_i64 5
    ;; %t22:str = str_slice(full[%t20:%t21])
    ;; sub_head:str = mov %t22
    ;; %t23:str = const_str 7
    ;; %t24:str = const_str 8
    ;; %t25:i64 = str_len(sub1)
    ;; %t26:str = const_str 9
    ;; print(%t23:str, sub1:str, %t24:str, %t25:i64, %t26:str)
    ;; %t27:str = const_str 10
    ;; %t28:str = const_str 8
    ;; %t29:i64 = str_len(sub2)
    ;; %t30:str = const_str 9
    ;; print(%t27:str, sub2:str, %t28:str, %t29:i64, %t30:str)
    ;; %t31:str = const_str 11
    ;; %t32:str = const_str 4
    ;; print(%t31:str, sub_tail:str, %t32:str)
    ;; %t33:str = const_str 12
    ;; %t34:str = const_str 4
    ;; print(%t33:str, sub_head:str, %t34:str)
    ;; %t35:i64 = const_i64 0
    ;; %t36:str = str_index(full[%t35])
    ;; ch0:str = mov %t36
    ;; %t37:i64 = const_i64 6
    ;; %t38:str = str_index(full[%t37])
    ;; ch6:str = mov %t38
    ;; %t39:str = const_str 13
    ;; %t40:str = const_str 14
    ;; %t41:str = const_str 4
    ;; print(%t39:str, ch0:str, %t40:str, ch6:str, %t41:str)
    ;; %t42:str = const_str 0
    ;; %t43:bool = str_cmp_eq sub1, %t42
    ;; is_match1:bool = mov %t43
    ;; %t44:str = const_str 15
    ;; %t45:bool = str_cmp_eq sub2, %t44
    ;; is_match2:bool = mov %t45
    ;; %t46:str = const_str 16
    ;; print(%t46:str, is_match1:bool)
    ;; %t47:str = const_str 17
    ;; print(%t47:str, is_match2:bool)
    ;; %t48:f64 = const_f64 27.5
    ;; speedup:f64 = mov %t48
    ;; %t49:str = const_str 18
    ;; %t50:str = str_from_f64 speedup
    ;; %t51:str = str_concat(%t49, %t50)
    ;; %t52:str = const_str 19
    ;; %t53:str = str_concat(%t51, %t52)
    ;; status:str = mov %t53
    ;; print(status:str)
    ;; %t54:i64 = const_i64 0
    ;; arena_restore %arena_sp_test_sso_and_slicing
    ;; ret %t54
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 20
    ;; print(%t1:str)
    ;; %t2:str = const_str 21
    ;; print(%t2:str)
    ;; %t3:str = const_str 20
    ;; print(%t3:str)
    ;; %t4:i64 = call test_sso_and_slicing()
    ;; %t5:str = const_str 20
    ;; print(%t5:str)
    ;; %t6:i64 = const_i64 0
    ;; ret %t6
    (i64.const 0)
  )
)