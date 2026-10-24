(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
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
    ;; .for_cond_1:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_3
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:i64 = src[%t5]
    ;; dst[%t4] = %t6  ; i64
    ;; .for_step_2:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_1
    ;; .for_end_3:
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
    ;; .for_cond_4:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_6
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:f64 = src[%t5]
    ;; dst[%t4] = %t6  ; f64
    ;; .for_step_5:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_4
    ;; .for_end_6:
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
    ;; .for_cond_7:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_9
    ;; %t4:i64 = add_i64 dst_idx, i
    ;; %t5:i64 = add_i64 src_idx, i
    ;; %t6:str = src[%t5]
    ;; dst[%t4] = %t6  ; i64
    ;; .for_step_8:
    ;; %t7:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t7
    ;; jmp .for_cond_7
    ;; .for_end_9:
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
    ;; .for_cond_10:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_12
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; i64
    ;; .for_step_11:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_10
    ;; .for_end_12:
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
    ;; .for_cond_13:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_15
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; f64
    ;; .for_step_14:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_13
    ;; .for_end_15:
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
    ;; .for_cond_16:
    ;; %t3:bool = cmp_lt_i64 i, count
    ;; jz %t3, .for_end_18
    ;; %t4:i64 = add_i64 start, i
    ;; arr[%t4] = val  ; i64
    ;; .for_step_17:
    ;; %t5:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t5
    ;; jmp .for_cond_16
    ;; .for_end_18:
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
    ;; jz %t2, .if_end_19
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_19
    ;; .if_end_19:
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
    ;; jz %t3, .if_end_20
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_20
    ;; .if_end_20:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_21
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_21
    ;; .if_end_21:
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
    ;; jz %t5, .if_end_22
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_23
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_23
    ;; .if_end_23:
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
    ;; jmp .if_end_22
    ;; .if_end_22:
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
    ;; jz %t4, .if_end_24
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_24
    ;; .if_end_24:
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
    ;; jz %t2, .if_end_25
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_25
    ;; .if_end_25:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_26
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_26
    ;; .if_end_26:
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
    ;; jz %t2, .if_end_27
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_27
    ;; .if_end_27:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_28
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_28
    ;; .if_end_28:
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
    ;; jz %t2, .if_end_29
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_29
    ;; .if_end_29:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_30
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_30
    ;; .if_end_30:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_31
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call int_vec_reserve(v, %t22)
    ;; jmp .if_end_31
    ;; .if_end_31:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_32:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_33
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
    ;; jmp .while_cond_32
    ;; .while_end_33:
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
    ;; jz %t2, .if_end_34
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_34
    ;; .if_end_34:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_35
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_35
    ;; .if_end_35:
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
    ;; .for_cond_36:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_38
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[i64] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[i64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:i64 = %t25[%t27]
    ;; %t23[i] = %t28  ; i64
    ;; .for_step_37:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_36
    ;; .for_end_38:
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
    ;; jz %t2, .if_end_39
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_39
    ;; .if_end_39:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_40
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_40
    ;; .if_end_40:
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
    ;; jz %t20, .if_end_41
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[i64] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[i64] = v[%t23]
    ;; %t25:i64 = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; i64
    ;; jmp .if_end_41
    ;; .if_end_41:
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
    ;; jz %t8, .if_end_42
    ;; %t9:i64 = call int_vec_reserve(dst, needed)
    ;; jmp .if_end_42
    ;; .if_end_42:
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
    ;; jz %t4, .if_end_43
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_43
    ;; .if_end_43:
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
    ;; jz %t2, .if_end_44
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_45
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_45
    ;; .if_end_45:
    ;; jmp .if_end_44
    ;; .if_end_44:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_46
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_46
    ;; .if_end_46:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_47
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_47
    ;; .if_end_47:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_48
    ;; %t20:i64 = const_i64 4
    ;; %t21:IntVector = call int_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_48
    ;; .if_end_48:
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
    ;; .for_cond_49:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_51
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = %t7[i]
    ;; %t9:bool = cmp_eq_i64 %t8, val
    ;; jz %t9, .if_end_52
    ;; %t10:bool = const_i64 1
    ;; ret %t10
    ;; jmp .if_end_52
    ;; .if_end_52:
    ;; .for_step_50:
    ;; %t11:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_49
    ;; .for_end_51:
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
    ;; .for_cond_53:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_55
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[i64] = v[%t6]
    ;; %t8:i64 = %t7[i]
    ;; %t9:bool = cmp_eq_i64 %t8, val
    ;; jz %t9, .if_end_56
    ;; ret i
    ;; jmp .if_end_56
    ;; .if_end_56:
    ;; .for_step_54:
    ;; %t10:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t10
    ;; jmp .for_cond_53
    ;; .for_end_55:
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
    ;; .while_cond_57:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_58
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
    ;; jmp .while_cond_57
    ;; .while_end_58:
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
    ;; jz %t1, .if_end_59
    ;; %t2:i64 = arr[high]
    ;; pivot:i64 = mov %t2
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 low, %t3
    ;; i:i64 = mov %t4
    ;; %t5:i64 = const_i64 1
    ;; j:i64 = mov low
    ;; .for_cond_60:
    ;; %t6:bool = cmp_lt_i64 j, high
    ;; jz %t6, .for_end_62
    ;; %t7:i64 = arr[j]
    ;; %t8:bool = cmp_le_i64 %t7, pivot
    ;; jz %t8, .if_end_63
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 i, %t9
    ;; i:i64 = mov %t10
    ;; %t11:i64 = arr[i]
    ;; tmp:i64 = mov %t11
    ;; %t12:i64 = arr[j]
    ;; arr[i] = %t12  ; i64
    ;; arr[j] = tmp  ; i64
    ;; jmp .if_end_63
    ;; .if_end_63:
    ;; .for_step_61:
    ;; %t13:i64 = add_i64 j, %t5
    ;; j:i64 = mov %t13
    ;; jmp .for_cond_60
    ;; .for_end_62:
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
    ;; jmp .if_end_59
    ;; .if_end_59:
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
    ;; jz %t4, .if_end_64
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_64
    ;; .if_end_64:
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
    ;; .while_cond_65:
    ;; %t6:bool = cmp_le_i64 low, high
    ;; jz %t6, .while_end_66
    ;; %t7:i64 = add_i64 low, high
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = div_i64 %t7, %t8
    ;; mid:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[i64] = v[%t10]
    ;; %t12:i64 = %t11[mid]
    ;; mid_val:i64 = mov %t12
    ;; %t13:bool = cmp_eq_i64 mid_val, val
    ;; jz %t13, .if_end_67
    ;; ret mid
    ;; jmp .if_end_67
    ;; .if_end_67:
    ;; %t14:bool = cmp_lt_i64 mid_val, val
    ;; jz %t14, .if_next_69
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = add_i64 mid, %t15
    ;; low:i64 = mov %t16
    ;; jmp .if_end_68
    ;; .if_next_69:
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = sub_i64 mid, %t17
    ;; high:i64 = mov %t18
    ;; .if_end_68:
    ;; jmp .while_cond_65
    ;; .while_end_66:
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
    ;; jz %t4, .if_end_70
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_70
    ;; .if_end_70:
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
    ;; .for_cond_71:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_73
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t17:i64 = %t16[i]
    ;; val:i64 = mov %t17
    ;; %t18:bool = cmp_lt_i64 val, m
    ;; jz %t18, .if_end_74
    ;; m:i64 = mov val
    ;; jmp .if_end_74
    ;; .if_end_74:
    ;; .for_step_72:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_71
    ;; .for_end_73:
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
    ;; jz %t4, .if_end_75
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_75
    ;; .if_end_75:
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
    ;; .for_cond_76:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_78
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[i64] = v[%t15]
    ;; %t17:i64 = %t16[i]
    ;; val:i64 = mov %t17
    ;; %t18:bool = cmp_gt_i64 val, m
    ;; jz %t18, .if_end_79
    ;; m:i64 = mov val
    ;; jmp .if_end_79
    ;; .if_end_79:
    ;; .for_step_77:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_76
    ;; .for_end_78:
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
    ;; .for_cond_80:
    ;; %t6:bool = cmp_lt_i64 i, %t4
    ;; jz %t6, .for_end_82
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[i64] = v[%t7]
    ;; %t9:i64 = %t8[i]
    ;; %t10:i64 = add_i64 s, %t9
    ;; s:i64 = mov %t10
    ;; .for_step_81:
    ;; %t11:i64 = add_i64 i, %t5
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_80
    ;; .for_end_82:
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
    ;; jz %t4, .if_end_83
    ;; %t5:str = const_str 0
    ;; ret %t5
    ;; jmp .if_end_83
    ;; .if_end_83:
    ;; %t6:str = const_str 1
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
    ;; .for_cond_84:
    ;; %t17:bool = cmp_lt_i64 i, %t15
    ;; jz %t17, .for_end_86
    ;; %t18:str = const_str 2
    ;; %t19:str = str_concat(res, %t18)
    ;; %t20:i64 = const_i64 0
    ;; %t21:Array[i64] = v[%t20]
    ;; %t22:i64 = %t21[i]
    ;; %t23:str = str_from_i64 %t22
    ;; %t24:str = str_concat(%t19, %t23)
    ;; res:str = mov %t24
    ;; .for_step_85:
    ;; %t25:i64 = add_i64 i, %t16
    ;; i:i64 = mov %t25
    ;; jmp .for_cond_84
    ;; .for_end_86:
    ;; %t26:str = const_str 3
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
    ;; jz %t2, .if_end_87
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_87
    ;; .if_end_87:
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
    ;; jz %t3, .if_end_88
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_88
    ;; .if_end_88:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_89
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_89
    ;; .if_end_89:
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
    ;; jz %t5, .if_end_90
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_91
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_91
    ;; .if_end_91:
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
    ;; jmp .if_end_90
    ;; .if_end_90:
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
    ;; jz %t4, .if_end_92
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_92
    ;; .if_end_92:
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
    ;; jz %t2, .if_end_93
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_93
    ;; .if_end_93:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_94
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_94
    ;; .if_end_94:
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
    ;; jz %t2, .if_end_95
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_95
    ;; .if_end_95:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_96
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_96
    ;; .if_end_96:
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
    ;; jz %t2, .if_end_97
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_97
    ;; .if_end_97:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_98
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_98
    ;; .if_end_98:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_99
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call float_vec_reserve(v, %t22)
    ;; jmp .if_end_99
    ;; .if_end_99:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_100:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_101
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
    ;; jmp .while_cond_100
    ;; .while_end_101:
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
    ;; jz %t2, .if_end_102
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_102
    ;; .if_end_102:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_103
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_103
    ;; .if_end_103:
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
    ;; .for_cond_104:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_106
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[f64] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[f64] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:f64 = %t25[%t27]
    ;; %t23[i] = %t28  ; f64
    ;; .for_step_105:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_104
    ;; .for_end_106:
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
    ;; jz %t2, .if_end_107
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_107
    ;; .if_end_107:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_108
    ;; %t12:f64 = const_f64 0.0
    ;; ret %t12
    ;; jmp .if_end_108
    ;; .if_end_108:
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
    ;; jz %t20, .if_end_109
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[f64] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[f64] = v[%t23]
    ;; %t25:f64 = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; f64
    ;; jmp .if_end_109
    ;; .if_end_109:
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
    ;; jz %t8, .if_end_110
    ;; %t9:i64 = call float_vec_reserve(dst, needed)
    ;; jmp .if_end_110
    ;; .if_end_110:
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
    ;; jz %t4, .if_end_111
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_111
    ;; .if_end_111:
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
    ;; jz %t2, .if_end_112
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_113
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_113
    ;; .if_end_113:
    ;; jmp .if_end_112
    ;; .if_end_112:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_114
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_114
    ;; .if_end_114:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_115
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_115
    ;; .if_end_115:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_116
    ;; %t20:i64 = const_i64 4
    ;; %t21:FloatVector = call float_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_116
    ;; .if_end_116:
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
    ;; .while_cond_117:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_118
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
    ;; jmp .while_cond_117
    ;; .while_end_118:
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
    ;; jz %t1, .if_end_119
    ;; %t2:f64 = arr[high]
    ;; pivot:f64 = mov %t2
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 low, %t3
    ;; i:i64 = mov %t4
    ;; %t5:i64 = const_i64 1
    ;; j:i64 = mov low
    ;; .for_cond_120:
    ;; %t6:bool = cmp_lt_i64 j, high
    ;; jz %t6, .for_end_122
    ;; %t7:f64 = arr[j]
    ;; %t8:bool = cmp_le_f64 %t7, pivot
    ;; jz %t8, .if_end_123
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = add_i64 i, %t9
    ;; i:i64 = mov %t10
    ;; %t11:f64 = arr[i]
    ;; tmp:f64 = mov %t11
    ;; %t12:f64 = arr[j]
    ;; arr[i] = %t12  ; f64
    ;; arr[j] = tmp  ; f64
    ;; jmp .if_end_123
    ;; .if_end_123:
    ;; .for_step_121:
    ;; %t13:i64 = add_i64 j, %t5
    ;; j:i64 = mov %t13
    ;; jmp .for_cond_120
    ;; .for_end_122:
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
    ;; jmp .if_end_119
    ;; .if_end_119:
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
    ;; jz %t4, .if_end_124
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    ;; jmp .if_end_124
    ;; .if_end_124:
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
    ;; jz %t4, .if_end_125
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_125
    ;; .if_end_125:
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
    ;; .for_cond_126:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_128
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t17:f64 = %t16[i]
    ;; val:f64 = mov %t17
    ;; %t18:bool = cmp_lt_f64 val, m
    ;; jz %t18, .if_end_129
    ;; m:f64 = mov val
    ;; jmp .if_end_129
    ;; .if_end_129:
    ;; .for_step_127:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_126
    ;; .for_end_128:
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
    ;; jz %t4, .if_end_130
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_130
    ;; .if_end_130:
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
    ;; .for_cond_131:
    ;; %t14:bool = cmp_lt_i64 i, %t12
    ;; jz %t14, .for_end_133
    ;; %t15:i64 = const_i64 0
    ;; %t16:Array[f64] = v[%t15]
    ;; %t17:f64 = %t16[i]
    ;; val:f64 = mov %t17
    ;; %t18:bool = cmp_gt_f64 val, m
    ;; jz %t18, .if_end_134
    ;; m:f64 = mov val
    ;; jmp .if_end_134
    ;; .if_end_134:
    ;; .for_step_132:
    ;; %t19:i64 = add_i64 i, %t13
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_131
    ;; .for_end_133:
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
    ;; .for_cond_135:
    ;; %t6:bool = cmp_lt_i64 i, %t4
    ;; jz %t6, .for_end_137
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[f64] = v[%t7]
    ;; %t9:f64 = %t8[i]
    ;; %t10:f64 = add_f64 s, %t9
    ;; s:f64 = mov %t10
    ;; .for_step_136:
    ;; %t11:i64 = add_i64 i, %t5
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_135
    ;; .for_end_137:
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
    ;; jz %t4, .if_end_138
    ;; %t5:f64 = const_f64 0.0
    ;; ret %t5
    ;; jmp .if_end_138
    ;; .if_end_138:
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
    ;; jz %t4, .if_end_139
    ;; %t5:str = const_str 0
    ;; ret %t5
    ;; jmp .if_end_139
    ;; .if_end_139:
    ;; %t6:str = const_str 1
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
    ;; .for_cond_140:
    ;; %t17:bool = cmp_lt_i64 i, %t15
    ;; jz %t17, .for_end_142
    ;; %t18:str = const_str 2
    ;; %t19:str = str_concat(res, %t18)
    ;; %t20:i64 = const_i64 0
    ;; %t21:Array[f64] = v[%t20]
    ;; %t22:f64 = %t21[i]
    ;; %t23:str = str_from_f64 %t22
    ;; %t24:str = str_concat(%t19, %t23)
    ;; res:str = mov %t24
    ;; .for_step_141:
    ;; %t25:i64 = add_i64 i, %t16
    ;; i:i64 = mov %t25
    ;; jmp .for_cond_140
    ;; .for_end_142:
    ;; %t26:str = const_str 3
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
    ;; jz %t2, .if_end_143
    ;; %t3:i64 = const_i64 8
    ;; c:i64 = mov %t3
    ;; jmp .if_end_143
    ;; .if_end_143:
    ;; %t5:str = const_str 4
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
    ;; jz %t3, .if_end_144
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = v[%t4]
    ;; ret %t5
    ;; jmp .if_end_144
    ;; .if_end_144:
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:bool = cmp_lt_i64 new_cap, min_capacity
    ;; jz %t10, .if_end_145
    ;; new_cap:i64 = mov min_capacity
    ;; jmp .if_end_145
    ;; .if_end_145:
    ;; %t12:str = const_str 4
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
    ;; jz %t5, .if_end_146
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 2
    ;; %t9:i64 = mul_i64 %t7, %t8
    ;; new_cap:i64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_le_i64 new_cap, %t10
    ;; jz %t11, .if_end_147
    ;; %t12:i64 = const_i64 8
    ;; new_cap:i64 = mov %t12
    ;; jmp .if_end_147
    ;; .if_end_147:
    ;; %t14:str = const_str 4
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
    ;; jmp .if_end_146
    ;; .if_end_146:
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
    ;; jz %t4, .if_end_148
    ;; %t5:str = const_str 4
    ;; ret %t5
    ;; jmp .if_end_148
    ;; .if_end_148:
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
    ;; jz %t2, .if_end_149
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_149
    ;; .if_end_149:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_150
    ;; %t12:str = const_str 4
    ;; ret %t12
    ;; jmp .if_end_150
    ;; .if_end_150:
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
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    ;; jmp .if_end_152
    ;; .if_end_152:
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
    ;; jz %t2, .if_end_153
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_153
    ;; .if_end_153:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_gt_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_154
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; ret %t13
    ;; jmp .if_end_154
    ;; .if_end_154:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = v[%t16]
    ;; %t18:bool = cmp_ge_i64 %t15, %t17
    ;; jz %t18, .if_end_155
    ;; %t19:i64 = const_i64 2
    ;; %t20:i64 = v[%t19]
    ;; %t21:i64 = const_i64 2
    ;; %t22:i64 = mul_i64 %t20, %t21
    ;; %t23:i64 = call str_vec_reserve(v, %t22)
    ;; jmp .if_end_155
    ;; .if_end_155:
    ;; %t24:i64 = const_i64 1
    ;; %t25:i64 = v[%t24]
    ;; i:i64 = mov %t25
    ;; .while_cond_156:
    ;; %t26:bool = cmp_gt_i64 i, real_idx
    ;; jz %t26, .while_end_157
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
    ;; jmp .while_cond_156
    ;; .while_end_157:
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
    ;; jz %t2, .if_end_158
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_158
    ;; .if_end_158:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_159
    ;; %t12:str = const_str 4
    ;; ret %t12
    ;; jmp .if_end_159
    ;; .if_end_159:
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
    ;; .for_cond_160:
    ;; %t21:bool = cmp_lt_i64 i, last
    ;; jz %t21, .for_end_162
    ;; %t22:i64 = const_i64 0
    ;; %t23:Array[str] = v[%t22]
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = add_i64 i, %t26
    ;; %t28:str = %t25[%t27]
    ;; %t23[i] = %t28  ; i64
    ;; .for_step_161:
    ;; %t29:i64 = add_i64 i, %t20
    ;; i:i64 = mov %t29
    ;; jmp .for_cond_160
    ;; .for_end_162:
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
    ;; jz %t2, .if_end_163
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, real_idx
    ;; real_idx:i64 = mov %t5
    ;; jmp .if_end_163
    ;; .if_end_163:
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 real_idx, %t6
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = v[%t8]
    ;; %t10:bool = cmp_ge_i64 real_idx, %t9
    ;; %t11:bool = or_i64 %t7, %t10
    ;; jz %t11, .if_end_164
    ;; %t12:str = const_str 4
    ;; ret %t12
    ;; jmp .if_end_164
    ;; .if_end_164:
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
    ;; jz %t20, .if_end_165
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[str] = v[%t21]
    ;; %t23:i64 = const_i64 0
    ;; %t24:Array[str] = v[%t23]
    ;; %t25:str = %t24[last_idx]
    ;; %t22[real_idx] = %t25  ; i64
    ;; jmp .if_end_165
    ;; .if_end_165:
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
    ;; jz %t8, .if_end_166
    ;; %t9:i64 = call str_vec_reserve(dst, needed)
    ;; jmp .if_end_166
    ;; .if_end_166:
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
    ;; jz %t4, .if_end_167
    ;; %t5:i64 = const_i64 8
    ;; c:i64 = mov %t5
    ;; jmp .if_end_167
    ;; .if_end_167:
    ;; %t7:str = const_str 4
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
    ;; jz %t2, .if_end_168
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_169
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_169
    ;; .if_end_169:
    ;; jmp .if_end_168
    ;; .if_end_168:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_170
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_170
    ;; .if_end_170:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_171
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_171
    ;; .if_end_171:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_172
    ;; %t20:i64 = const_i64 4
    ;; %t21:StrVector = call str_vec_new(%t20)
    ;; ret %t21
    ;; jmp .if_end_172
    ;; .if_end_172:
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
    ;; .for_cond_173:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_175
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[str] = v[%t6]
    ;; %t8:str = %t7[i]
    ;; %t9:bool = str_cmp_eq %t8, val
    ;; jz %t9, .if_end_176
    ;; %t10:bool = const_i64 1
    ;; ret %t10
    ;; jmp .if_end_176
    ;; .if_end_176:
    ;; .for_step_174:
    ;; %t11:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t11
    ;; jmp .for_cond_173
    ;; .for_end_175:
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
    ;; .for_cond_177:
    ;; %t5:bool = cmp_lt_i64 i, %t3
    ;; jz %t5, .for_end_179
    ;; %t6:i64 = const_i64 0
    ;; %t7:Array[str] = v[%t6]
    ;; %t8:str = %t7[i]
    ;; %t9:bool = str_cmp_eq %t8, val
    ;; jz %t9, .if_end_180
    ;; ret i
    ;; jmp .if_end_180
    ;; .if_end_180:
    ;; .for_step_178:
    ;; %t10:i64 = add_i64 i, %t4
    ;; i:i64 = mov %t10
    ;; jmp .for_cond_177
    ;; .for_end_179:
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
    ;; jz %t4, .if_end_181
    ;; %t5:str = const_str 4
    ;; ret %t5
    ;; jmp .if_end_181
    ;; .if_end_181:
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = v[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:bool = cmp_eq_i64 %t7, %t8
    ;; jz %t9, .if_end_182
    ;; %t10:i64 = const_i64 0
    ;; %t11:Array[str] = v[%t10]
    ;; %t12:i64 = const_i64 0
    ;; %t13:str = %t11[%t12]
    ;; ret %t13
    ;; jmp .if_end_182
    ;; .if_end_182:
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
    ;; .for_cond_183:
    ;; %t22:bool = cmp_lt_i64 i, %t20
    ;; jz %t22, .for_end_185
    ;; %t23:str = str_concat(res, sep)
    ;; %t24:i64 = const_i64 0
    ;; %t25:Array[str] = v[%t24]
    ;; %t26:str = %t25[i]
    ;; %t27:str = str_concat(%t23, %t26)
    ;; res:str = mov %t27
    ;; .for_step_184:
    ;; %t28:i64 = add_i64 i, %t21
    ;; i:i64 = mov %t28
    ;; jmp .for_cond_183
    ;; .for_end_185:
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
    ;; .while_cond_186:
    ;; %t6:bool = cmp_lt_i64 i, j
    ;; jz %t6, .while_end_187
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
    ;; jmp .while_cond_186
    ;; .while_end_187:
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
    ;; jz %t4, .if_end_188
    ;; %t5:str = const_str 0
    ;; ret %t5
    ;; jmp .if_end_188
    ;; .if_end_188:
    ;; %t6:str = const_str 5
    ;; %t7:i64 = const_i64 0
    ;; %t8:Array[str] = v[%t7]
    ;; %t9:i64 = const_i64 0
    ;; %t10:str = %t8[%t9]
    ;; %t11:str = str_concat(%t6, %t10)
    ;; %t12:str = const_str 6
    ;; %t13:str = str_concat(%t11, %t12)
    ;; res:str = mov %t13
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = v[%t15]
    ;; %t17:i64 = const_i64 1
    ;; i:i64 = mov %t14
    ;; .for_cond_189:
    ;; %t18:bool = cmp_lt_i64 i, %t16
    ;; jz %t18, .for_end_191
    ;; %t19:str = const_str 7
    ;; %t20:str = str_concat(res, %t19)
    ;; %t21:i64 = const_i64 0
    ;; %t22:Array[str] = v[%t21]
    ;; %t23:str = %t22[i]
    ;; %t24:str = str_concat(%t20, %t23)
    ;; %t25:str = const_str 6
    ;; %t26:str = str_concat(%t24, %t25)
    ;; res:str = mov %t26
    ;; .for_step_190:
    ;; %t27:i64 = add_i64 i, %t17
    ;; i:i64 = mov %t27
    ;; jmp .for_cond_189
    ;; .for_end_191:
    ;; %t28:str = const_str 3
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
    ;; jz %t2, .if_end_192
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_193
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_193
    ;; .if_end_193:
    ;; jmp .if_end_192
    ;; .if_end_192:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_194
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_194
    ;; .if_end_194:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_195
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_195
    ;; .if_end_195:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_196
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
    ;; jmp .if_end_196
    ;; .if_end_196:
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
    ;; jz %t10, .if_end_197
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = const_i64 2
    ;; %t14:i64 = s[%t13]
    ;; %t15:i64 = add_i64 %t12, %t14
    ;; %t16:i64 = sub_i64 %t15, new_offset
    ;; new_len:i64 = mov %t16
    ;; %t17:i64 = const_i64 0
    ;; %t18:bool = cmp_lt_i64 new_len, %t17
    ;; jz %t18, .if_end_198
    ;; %t19:i64 = const_i64 0
    ;; new_len:i64 = mov %t19
    ;; jmp .if_end_198
    ;; .if_end_198:
    ;; jmp .if_end_197
    ;; .if_end_197:
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
    ;; jz %t2, .if_end_199
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = v[%t3]
    ;; %t5:i64 = add_i64 %t4, s
    ;; s:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:bool = cmp_lt_i64 s, %t6
    ;; jz %t7, .if_end_200
    ;; %t8:i64 = const_i64 0
    ;; s:i64 = mov %t8
    ;; jmp .if_end_200
    ;; .if_end_200:
    ;; jmp .if_end_199
    ;; .if_end_199:
    ;; e:i64 = mov stop
    ;; %t9:i64 = const_i64 0
    ;; %t10:bool = cmp_lt_i64 e, %t9
    ;; jz %t10, .if_end_201
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = v[%t11]
    ;; %t13:i64 = add_i64 %t12, e
    ;; e:i64 = mov %t13
    ;; jmp .if_end_201
    ;; .if_end_201:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = v[%t14]
    ;; %t16:bool = cmp_gt_i64 e, %t15
    ;; jz %t16, .if_end_202
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = v[%t17]
    ;; e:i64 = mov %t18
    ;; jmp .if_end_202
    ;; .if_end_202:
    ;; %t19:bool = cmp_ge_i64 s, e
    ;; jz %t19, .if_end_203
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
    ;; jmp .if_end_203
    ;; .if_end_203:
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
    ;; jz %t10, .if_end_204
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = s[%t11]
    ;; %t13:i64 = const_i64 2
    ;; %t14:i64 = s[%t13]
    ;; %t15:i64 = add_i64 %t12, %t14
    ;; %t16:i64 = sub_i64 %t15, new_offset
    ;; new_len:i64 = mov %t16
    ;; %t17:i64 = const_i64 0
    ;; %t18:bool = cmp_lt_i64 new_len, %t17
    ;; jz %t18, .if_end_205
    ;; %t19:i64 = const_i64 0
    ;; new_len:i64 = mov %t19
    ;; jmp .if_end_205
    ;; .if_end_205:
    ;; jmp .if_end_204
    ;; .if_end_204:
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
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $iv i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $i i64)
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
    (local $p i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $sr i64)
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
    (local $t_t85 i64)
    (local $t_t86 i64)
    (local $t_t87 i64)
    (local $t_t88 i64)
    (local $bs_49 i64)
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $bs_100 i64)
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
    (local $fv i64)
    (local $t_t115 f64)
    (local $t_t116 i64)
    (local $t_t117 f64)
    (local $t_t118 i64)
    (local $t_t119 f64)
    (local $t_t120 i64)
    (local $t_t121 f64)
    (local $t_t122 i64)
    (local $t_t123 f64)
    (local $t_t124 i64)
    (local $t_t125 i64)
    (local $t_t126 i64)
    (local $t_t127 i64)
    (local $t_t128 i64)
    (local $t_t129 i64)
    (local $t_t130 i64)
    (local $t_t131 i64)
    (local $t_t132 i64)
    (local $t_t133 f64)
    (local $t_t134 i64)
    (local $t_t135 i64)
    (local $t_t136 i64)
    (local $t_t137 f64)
    (local $t_t138 i64)
    (local $t_t139 i64)
    (local $t_t140 i64)
    (local $t_t141 f64)
    (local $t_t142 i64)
    (local $t_t143 i64)
    (local $t_t144 i64)
    (local $t_t145 f64)
    (local $t_t146 i64)
    (local $t_t147 i64)
    (local $t_t148 i64)
    (local $t_t149 i64)
    (local $t_t150 i64)
    (local $f_slice i64)
    (local $t_t151 i64)
    (local $t_t152 i64)
    (local $t_t153 i64)
    (local $t_t154 i64)
    (local $t_t155 i64)
    (local $t_t156 i64)
    (local $t_t157 i64)
    (local $sv i64)
    (local $t_t158 i64)
    (local $t_t159 i64)
    (local $t_t160 i64)
    (local $t_t161 i64)
    (local $t_t162 i64)
    (local $t_t163 i64)
    (local $t_t164 i64)
    (local $t_t165 i64)
    (local $t_t166 i64)
    (local $t_t167 i64)
    (local $t_t168 i64)
    (local $t_t169 i64)
    (local $t_t170 i64)
    (local $t_t171 i64)
    (local $t_t172 i64)
    (local $t_t173 i64)
    (local $t_t174 i64)
    (local $t_t175 i64)
    (local $t_t176 i64)
    (local $t_t177 i64)
    (local $t_t178 i64)
    (local $t_t179 i64)
    (local $t_t180 i64)
    (local $t_t181 i64)
    (local $t_t182 i64)
    (local $t_t183 i64)
    (local $t_t184 i64)
    (local $t_t185 i64)
    (local $t_t186 i64)
    (local $t_t187 i64)
    (local $t_t188 i64)
    (local $t_t189 i64)
    (local $t_t190 i64)
    (local $t_t191 i64)
    (local $t_t192 i64)
    (local $t_t193 i64)
    (local $base_v i64)
    (local $t_t194 i64)
    (local $t_t195 i64)
    (local $t_t196 i64)
    (local $t_t197 i64)
    (local $t_t198 i64)
    (local $t_t199 i64)
    (local $t_t200 i64)
    (local $t_t201 i64)
    (local $t_t202 i64)
    (local $t_t203 i64)
    (local $t_t204 i64)
    (local $t_t205 i64)
    (local $t_t206 i64)
    (local $t_t207 i64)
    (local $t_t208 i64)
    (local $t_t209 i64)
    (local $sl i64)
    (local $t_t210 i64)
    (local $t_t211 i64)
    (local $t_t212 i64)
    (local $t_t213 i64)
    (local $t_t214 i64)
    (local $t_t215 i64)
    (local $t_t216 i64)
    (local $t_t217 i64)
    (local $t_t218 i64)
    (local $t_t219 i64)
    (local $t_t220 i64)
    (local $t_t221 i64)
    (local $t_t222 i64)
    (local $t_t223 i64)
    (local $t_t224 i64)
    (local $t_t225 i64)
    (local $t_t226 i64)
    (local $t_t227 i64)
    (local $t_t228 i64)
    (local $t_t229 i64)
    (local $t_t230 i64)
    (local $t_t231 i64)
    (local $t_t232 i64)
    (local $t_t233 i64)
    (local $t_t234 i64)
    (local $t_t235 i64)
    (local $t_t236 i64)
    (local $t_t237 i64)
    (local $t_t238 i64)
    (local $t_t239 i64)
    (local $t_t240 i64)
    (local $t_t241 i64)
    (local $t_t242 i64)
    (local $t_t243 i64)
    (local $t_t244 i64)
    (local $t_t245 i64)
    (local $t_t246 i64)
    (local $t_t247 i64)
    (local $t_t248 i64)
    (local $t_t249 i64)
    (local $t_arena_sp_main i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_main:i64 = arena_save None
    ;; %t1:str = const_str 8
    ;; print(%t1:str)
    ;; %t2:str = const_str 9
    ;; print(%t2:str)
    ;; %t3:str = const_str 8
    ;; print(%t3:str)
    ;; %t4:str = const_str 4
    ;; print(%t4:str)
    ;; %t5:str = const_str 10
    ;; print(%t5:str)
    ;; %t6:i64 = const_i64 2
    ;; %t7:IntVector = call int_vec_new(%t6)
    ;; iv:IntVector = mov %t7
    ;; %t8:str = const_str 11
    ;; %t9:i64 = call int_vec_cap(iv)
    ;; %t10:str = str_from_i64 %t9
    ;; %t11:str = str_concat(%t8, %t10)
    ;; print(%t11:str)
    ;; %t12:i64 = const_i64 0
    ;; %t13:i64 = const_i64 12
    ;; %t14:i64 = const_i64 1
    ;; i:i64 = mov %t12
    ;; .for_cond_206:
    ;; %t15:bool = cmp_lt_i64 i, %t13
    ;; jz %t15, .for_end_208
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = add_i64 i, %t16
    ;; %t18:i64 = const_i64 7
    ;; %t19:i64 = mul_i64 %t17, %t18
    ;; %t20:i64 = call int_vec_push(iv, %t19)
    ;; .for_step_207:
    ;; %t21:i64 = add_i64 i, %t14
    ;; i:i64 = mov %t21
    ;; jmp .for_cond_206
    ;; .for_end_208:
    ;; %t22:str = const_str 12
    ;; print(%t22:str)
    ;; %t23:str = const_str 13
    ;; %t24:str = call int_vec_to_str(iv)
    ;; %t25:str = str_concat(%t23, %t24)
    ;; print(%t25:str)
    ;; %t26:str = const_str 14
    ;; %t27:i64 = call int_vec_len(iv)
    ;; %t28:str = str_from_i64 %t27
    ;; %t29:str = str_concat(%t26, %t28)
    ;; print(%t29:str)
    ;; %t30:str = const_str 15
    ;; %t31:i64 = call int_vec_cap(iv)
    ;; %t32:str = str_from_i64 %t31
    ;; %t33:str = str_concat(%t30, %t32)
    ;; print(%t33:str)
    ;; %t34:str = const_str 16
    ;; %t35:i64 = const_i64 0
    ;; %t36:i64 = call int_vec_get(iv, %t35)
    ;; %t37:str = str_from_i64 %t36
    ;; %t38:str = str_concat(%t34, %t37)
    ;; print(%t38:str)
    ;; %t39:str = const_str 17
    ;; %t40:i64 = const_i64 1
    ;; %t41:i64 = neg_i64 %t40
    ;; %t42:i64 = call int_vec_get(iv, %t41)
    ;; %t43:str = str_from_i64 %t42
    ;; %t44:str = str_concat(%t39, %t43)
    ;; print(%t44:str)
    ;; %t45:str = const_str 18
    ;; %t46:i64 = const_i64 2
    ;; %t47:i64 = neg_i64 %t46
    ;; %t48:i64 = call int_vec_get(iv, %t47)
    ;; %t49:str = str_from_i64 %t48
    ;; %t50:str = str_concat(%t45, %t49)
    ;; print(%t50:str)
    ;; %t51:i64 = const_i64 3
    ;; %t52:i64 = const_i64 999
    ;; %t53:i64 = call int_vec_insert(iv, %t51, %t52)
    ;; %t54:str = const_str 19
    ;; print(%t54:str)
    ;; %t55:str = const_str 13
    ;; %t56:str = call int_vec_to_str(iv)
    ;; %t57:str = str_concat(%t55, %t56)
    ;; print(%t57:str)
    ;; %t58:i64 = call int_vec_pop(iv)
    ;; p:i64 = mov %t58
    ;; %t59:str = const_str 20
    ;; %t60:str = str_from_i64 p
    ;; %t61:str = str_concat(%t59, %t60)
    ;; print(%t61:str)
    ;; %t62:i64 = const_i64 3
    ;; %t63:i64 = call int_vec_swap_remove(iv, %t62)
    ;; sr:i64 = mov %t63
    ;; %t64:str = const_str 21
    ;; %t65:str = str_from_i64 sr
    ;; %t66:str = str_concat(%t64, %t65)
    ;; %t67:str = const_str 22
    ;; %t68:str = str_concat(%t66, %t67)
    ;; print(%t68:str)
    ;; %t69:str = const_str 13
    ;; %t70:str = call int_vec_to_str(iv)
    ;; %t71:str = str_concat(%t69, %t70)
    ;; print(%t71:str)
    ;; %t72:i64 = const_i64 13
    ;; %t73:i64 = call int_vec_push(iv, %t72)
    ;; %t74:i64 = const_i64 3
    ;; %t75:i64 = call int_vec_push(iv, %t74)
    ;; %t76:i64 = const_i64 105
    ;; %t77:i64 = call int_vec_push(iv, %t76)
    ;; %t78:str = const_str 23
    ;; print(%t78:str)
    ;; %t79:str = const_str 13
    ;; %t80:str = call int_vec_to_str(iv)
    ;; %t81:str = str_concat(%t79, %t80)
    ;; print(%t81:str)
    ;; %t82:i64 = call int_vec_sort(iv)
    ;; %t83:str = const_str 24
    ;; print(%t83:str)
    ;; %t84:str = const_str 13
    ;; %t85:str = call int_vec_to_str(iv)
    ;; %t86:str = str_concat(%t84, %t85)
    ;; print(%t86:str)
    ;; %t87:i64 = const_i64 49
    ;; %t88:i64 = call int_vec_binary_search(iv, %t87)
    ;; bs_49:i64 = mov %t88
    ;; %t89:i64 = const_i64 100
    ;; %t90:i64 = call int_vec_binary_search(iv, %t89)
    ;; bs_100:i64 = mov %t90
    ;; %t91:str = const_str 25
    ;; %t92:str = str_from_i64 bs_49
    ;; %t93:str = str_concat(%t91, %t92)
    ;; print(%t93:str)
    ;; %t94:str = const_str 26
    ;; %t95:str = str_from_i64 bs_100
    ;; %t96:str = str_concat(%t94, %t95)
    ;; %t97:str = const_str 27
    ;; %t98:str = str_concat(%t96, %t97)
    ;; print(%t98:str)
    ;; %t99:str = const_str 28
    ;; %t100:i64 = call int_vec_min(iv)
    ;; %t101:str = str_from_i64 %t100
    ;; %t102:str = str_concat(%t99, %t101)
    ;; print(%t102:str)
    ;; %t103:str = const_str 29
    ;; %t104:i64 = call int_vec_max(iv)
    ;; %t105:str = str_from_i64 %t104
    ;; %t106:str = str_concat(%t103, %t105)
    ;; print(%t106:str)
    ;; %t107:str = const_str 30
    ;; %t108:i64 = call int_vec_sum(iv)
    ;; %t109:str = str_from_i64 %t108
    ;; %t110:str = str_concat(%t107, %t109)
    ;; print(%t110:str)
    ;; %t111:str = const_str 4
    ;; print(%t111:str)
    ;; %t112:str = const_str 31
    ;; print(%t112:str)
    ;; %t113:i64 = const_i64 4
    ;; %t114:FloatVector = call float_vec_new(%t113)
    ;; fv:FloatVector = mov %t114
    ;; %t115:f64 = const_f64 9.81
    ;; %t116:i64 = call float_vec_push(fv, %t115)
    ;; %t117:f64 = const_f64 2.718
    ;; %t118:i64 = call float_vec_push(fv, %t117)
    ;; %t119:f64 = const_f64 3.14159
    ;; %t120:i64 = call float_vec_push(fv, %t119)
    ;; %t121:f64 = const_f64 1.414
    ;; %t122:i64 = call float_vec_push(fv, %t121)
    ;; %t123:f64 = const_f64 1.618
    ;; %t124:i64 = call float_vec_push(fv, %t123)
    ;; %t125:str = const_str 32
    ;; %t126:str = call float_vec_to_str(fv)
    ;; %t127:str = str_concat(%t125, %t126)
    ;; print(%t127:str)
    ;; %t128:i64 = call float_vec_sort(fv)
    ;; %t129:str = const_str 33
    ;; %t130:str = call float_vec_to_str(fv)
    ;; %t131:str = str_concat(%t129, %t130)
    ;; print(%t131:str)
    ;; %t132:str = const_str 34
    ;; %t133:f64 = call float_vec_min(fv)
    ;; %t134:str = str_from_f64 %t133
    ;; %t135:str = str_concat(%t132, %t134)
    ;; print(%t135:str)
    ;; %t136:str = const_str 35
    ;; %t137:f64 = call float_vec_max(fv)
    ;; %t138:str = str_from_f64 %t137
    ;; %t139:str = str_concat(%t136, %t138)
    ;; print(%t139:str)
    ;; %t140:str = const_str 36
    ;; %t141:f64 = call float_vec_sum(fv)
    ;; %t142:str = str_from_f64 %t141
    ;; %t143:str = str_concat(%t140, %t142)
    ;; print(%t143:str)
    ;; %t144:str = const_str 37
    ;; %t145:f64 = call float_vec_mean(fv)
    ;; %t146:str = str_from_f64 %t145
    ;; %t147:str = str_concat(%t144, %t146)
    ;; print(%t147:str)
    ;; %t148:i64 = const_i64 1
    ;; %t149:i64 = const_i64 4
    ;; %t150:FloatVector = call float_vec_slice(fv, %t148, %t149)
    ;; f_slice:FloatVector = mov %t150
    ;; %t151:str = const_str 38
    ;; %t152:str = call float_vec_to_str(f_slice)
    ;; %t153:str = str_concat(%t151, %t152)
    ;; print(%t153:str)
    ;; %t154:str = const_str 4
    ;; print(%t154:str)
    ;; %t155:str = const_str 39
    ;; print(%t155:str)
    ;; %t156:i64 = const_i64 2
    ;; %t157:StrVector = call str_vec_new(%t156)
    ;; sv:StrVector = mov %t157
    ;; %t158:str = const_str 40
    ;; %t159:i64 = call str_vec_push(sv, %t158)
    ;; %t160:str = const_str 41
    ;; %t161:i64 = call str_vec_push(sv, %t160)
    ;; %t162:str = const_str 42
    ;; %t163:i64 = call str_vec_push(sv, %t162)
    ;; %t164:str = const_str 43
    ;; %t165:i64 = call str_vec_push(sv, %t164)
    ;; %t166:str = const_str 44
    ;; %t167:i64 = call str_vec_push(sv, %t166)
    ;; %t168:str = const_str 45
    ;; %t169:str = call str_vec_to_str(sv)
    ;; %t170:str = str_concat(%t168, %t169)
    ;; print(%t170:str)
    ;; %t171:str = const_str 46
    ;; %t172:str = const_str 47
    ;; %t173:str = call str_vec_join(sv, %t172)
    ;; %t174:str = str_concat(%t171, %t173)
    ;; print(%t174:str)
    ;; %t175:str = const_str 48
    ;; %t176:str = const_str 41
    ;; %t177:bool = call str_vec_contains(sv, %t176)
    ;; %t178:str = str_from_bool %t177
    ;; %t179:str = str_concat(%t175, %t178)
    ;; print(%t179:str)
    ;; %t180:str = const_str 49
    ;; %t181:str = const_str 50
    ;; %t182:bool = call str_vec_contains(sv, %t181)
    ;; %t183:str = str_from_bool %t182
    ;; %t184:str = str_concat(%t180, %t183)
    ;; print(%t184:str)
    ;; %t185:str = const_str 51
    ;; %t186:str = const_str 43
    ;; %t187:i64 = call str_vec_index_of(sv, %t186)
    ;; %t188:str = str_from_i64 %t187
    ;; %t189:str = str_concat(%t185, %t188)
    ;; print(%t189:str)
    ;; %t190:str = const_str 4
    ;; print(%t190:str)
    ;; %t191:str = const_str 52
    ;; print(%t191:str)
    ;; %t192:i64 = const_i64 6
    ;; %t193:IntVector = call int_vec_new(%t192)
    ;; base_v:IntVector = mov %t193
    ;; %t194:i64 = const_i64 0
    ;; %t195:i64 = const_i64 6
    ;; %t196:i64 = const_i64 1
    ;; i:i64 = mov %t194
    ;; .for_cond_209:
    ;; %t197:bool = cmp_lt_i64 i, %t195
    ;; jz %t197, .for_end_211
    ;; %t198:i64 = const_i64 1
    ;; %t199:i64 = add_i64 i, %t198
    ;; %t200:i64 = const_i64 10
    ;; %t201:i64 = mul_i64 %t199, %t200
    ;; %t202:i64 = call int_vec_push(base_v, %t201)
    ;; .for_step_210:
    ;; %t203:i64 = add_i64 i, %t196
    ;; i:i64 = mov %t203
    ;; jmp .for_cond_209
    ;; .for_end_211:
    ;; %t204:str = const_str 53
    ;; %t205:str = call int_vec_to_str(base_v)
    ;; %t206:str = str_concat(%t204, %t205)
    ;; print(%t206:str)
    ;; %t207:i64 = const_i64 2
    ;; %t208:i64 = const_i64 5
    ;; %t209:IntSlice = call int_slice_from_vec(base_v, %t207, %t208)
    ;; sl:IntSlice = mov %t209
    ;; %t210:str = const_str 54
    ;; %t211:i64 = const_i64 1
    ;; %t212:i64 = sl[%t211]
    ;; %t213:str = str_from_i64 %t212
    ;; %t214:str = str_concat(%t210, %t213)
    ;; %t215:str = const_str 55
    ;; %t216:str = str_concat(%t214, %t215)
    ;; %t217:i64 = const_i64 2
    ;; %t218:i64 = sl[%t217]
    ;; %t219:str = str_from_i64 %t218
    ;; %t220:str = str_concat(%t216, %t219)
    ;; %t221:str = const_str 22
    ;; %t222:str = str_concat(%t220, %t221)
    ;; print(%t222:str)
    ;; %t223:str = const_str 56
    ;; %t224:i64 = const_i64 0
    ;; %t225:i64 = call int_slice_get(sl, %t224)
    ;; %t226:str = str_from_i64 %t225
    ;; %t227:str = str_concat(%t223, %t226)
    ;; print(%t227:str)
    ;; %t228:str = const_str 57
    ;; %t229:i64 = const_i64 1
    ;; %t230:i64 = call int_slice_get(sl, %t229)
    ;; %t231:str = str_from_i64 %t230
    ;; %t232:str = str_concat(%t228, %t231)
    ;; print(%t232:str)
    ;; %t233:str = const_str 58
    ;; %t234:i64 = const_i64 2
    ;; %t235:i64 = call int_slice_get(sl, %t234)
    ;; %t236:str = str_from_i64 %t235
    ;; %t237:str = str_concat(%t233, %t236)
    ;; print(%t237:str)
    ;; %t238:i64 = const_i64 1
    ;; %t239:i64 = const_i64 7777
    ;; %t240:i64 = call int_slice_set(sl, %t238, %t239)
    ;; %t241:str = const_str 59
    ;; print(%t241:str)
    ;; %t242:str = const_str 60
    ;; %t243:str = call int_vec_to_str(base_v)
    ;; %t244:str = str_concat(%t242, %t243)
    ;; print(%t244:str)
    ;; %t245:str = const_str 4
    ;; print(%t245:str)
    ;; %t246:str = const_str 8
    ;; print(%t246:str)
    ;; %t247:str = const_str 61
    ;; print(%t247:str)
    ;; %t248:str = const_str 8
    ;; print(%t248:str)
    ;; %t249:i64 = const_i64 0
    ;; arena_restore %arena_sp_main
    ;; ret %t249
    (i64.const 0)
  )
)