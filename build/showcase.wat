(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $classify_quadrant (export "classify_quadrant") (param $p i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = p[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_gt_i64 %t2, %t3
    ;; %t5:bool = const_i64 1
    ;; %t6:bool = cmp_eq_i64 %t4, %t5
    ;; jz %t6, .match_case_0_2
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = p[%t7]
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_gt_i64 %t8, %t9
    ;; jz %t10, .if_end_3
    ;; %t11:str = const_str 0
    ;; ret %t11
    ;; jmp .if_end_3
    ;; .if_end_3:
    ;; %t12:str = const_str 1
    ;; ret %t12
    ;; jmp .match_end_1
    ;; .match_case_0_2:
    ;; %t13:bool = const_i64 0
    ;; %t14:bool = cmp_eq_i64 %t4, %t13
    ;; jz %t14, .match_case_1_4
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = p[%t15]
    ;; %t17:i64 = const_i64 0
    ;; %t18:bool = cmp_gt_i64 %t16, %t17
    ;; jz %t18, .if_end_5
    ;; %t19:str = const_str 2
    ;; ret %t19
    ;; jmp .if_end_5
    ;; .if_end_5:
    ;; %t20:str = const_str 3
    ;; ret %t20
    ;; jmp .match_end_1
    ;; .match_case_1_4:
    ;; .match_end_1:
    ;; %t21:str = const_str 4
    ;; ret %t21
    (i64.const 0)
  )
  (func $tail_sum (export "tail_sum") (param $n i64) (param $acc i64) (result i64)
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
    ;; jz %t2, .if_end_6
    ;; ret acc
    ;; jmp .if_end_6
    ;; .if_end_6:
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
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $pt i64)
    (local $t_t13 i64)
    (local $quad i64)
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
    (local $t_sum i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 5
    ;; print(%t1:str)
    ;; %t2:str = const_str 6
    ;; print(%t2:str)
    ;; %t3:str = const_str 7
    ;; print(%t3:str)
    ;; %t4:str = const_str 5
    ;; print(%t4:str)
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = const_i64 0
    ;; %t5:Point = alloc_array(%t6, init=%t7)
    ;; %t8:i64 = const_i64 12
    ;; %t9:i64 = const_i64 0
    ;; %t5[%t9] = %t8  ; i64
    ;; %t10:i64 = const_i64 5
    ;; %t11:i64 = neg_i64 %t10
    ;; %t12:i64 = const_i64 1
    ;; %t5[%t12] = %t11  ; i64
    ;; pt:Point = mov %t5
    ;; %t13:str = call classify_quadrant(pt)
    ;; quad:str = mov %t13
    ;; %t14:str = const_str 8
    ;; %t15:i64 = const_i64 0
    ;; %t16:i64 = pt[%t15]
    ;; %t17:str = const_str 9
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = pt[%t18]
    ;; %t20:str = const_str 10
    ;; print(%t14:str, %t16:i64, %t17:str, %t19:i64, %t20:str, quad:str)
    ;; %t21:i64 = const_i64 100000
    ;; %t22:i64 = const_i64 0
    ;; %t23:i64 = call tail_sum(%t21, %t22)
    ;; t_sum:i64 = mov %t23
    ;; %t24:str = const_str 11
    ;; print(%t24:str, t_sum:i64)
    ;; %t25:i64 = const_i64 0
    ;; ret %t25
    (i64.const 0)
  )
)