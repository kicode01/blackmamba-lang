(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $exp (export "exp") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $t_t9 i64)
    (local $t_t10 f64)
    (local $t_t11 f64)
    (local $t_t12 f64)
    (local $val f64)
    (local $t_t13 f64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $t_t18 f64)
    (local $t_t19 f64)
    (local $t_t20 f64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $t_t23 f64)
    (local $t_t24 f64)
    (local $t_t25 f64)
    (local $t_t26 f64)
    (local $t_t27 f64)
    (local $t_t28 f64)
    (local $t_t29 f64)
    (local $t_t30 f64)
    (local $t_t31 f64)
    (local $t_t32 f64)
    (local $t_t33 f64)
    (local $t_t34 f64)
    (local $term f64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $_ i64)
    (local $t_t38 i64)
    (local $t_t39 f64)
    (local $t_t40 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; %t2:bool = cmp_eq_f64 x, %t1
    ;; jz %t2, .if_end_1
    ;; %t3:f64 = const_f64 1.0
    ;; ret %t3
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t4:f64 = const_f64 50.0
    ;; %t5:f64 = neg_f64 %t4
    ;; %t6:bool = cmp_lt_f64 x, %t5
    ;; jz %t6, .if_end_2
    ;; %t7:f64 = const_f64 0.0
    ;; ret %t7
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; %t8:f64 = const_f64 700.0
    ;; %t9:bool = cmp_gt_f64 x, %t8
    ;; jz %t9, .if_end_3
    ;; %t10:f64 = const_f64 1e+300
    ;; ret %t10
    ;; jmp .if_end_3
    ;; .if_end_3:
    ;; %t11:f64 = const_f64 256.0
    ;; %t12:f64 = div_f64 x, %t11
    ;; val:f64 = mov %t12
    ;; %t13:f64 = const_f64 1.0
    ;; %t14:f64 = const_f64 1.0
    ;; %t15:f64 = const_f64 0.5
    ;; %t18:f64 = const_f64 0.16666666666666666
    ;; %t21:f64 = const_f64 0.041666666666666664
    ;; %t24:f64 = const_f64 0.008333333333333333
    ;; %t25:f64 = mul_f64 val, %t24
    ;; %t26:f64 = add_f64 %t21, %t25
    ;; %t27:f64 = mul_f64 val, %t26
    ;; %t28:f64 = add_f64 %t18, %t27
    ;; %t29:f64 = mul_f64 val, %t28
    ;; %t30:f64 = add_f64 %t15, %t29
    ;; %t31:f64 = mul_f64 val, %t30
    ;; %t32:f64 = add_f64 %t14, %t31
    ;; %t33:f64 = mul_f64 val, %t32
    ;; %t34:f64 = add_f64 %t13, %t33
    ;; term:f64 = mov %t34
    ;; %t35:i64 = const_i64 0
    ;; %t36:i64 = const_i64 8
    ;; %t37:i64 = const_i64 1
    ;; _:i64 = mov %t35
    ;; .for_cond_4:
    ;; %t38:bool = cmp_lt_i64 _, %t36
    ;; jz %t38, .for_end_6
    ;; %t39:f64 = mul_f64 term, term
    ;; term:f64 = mov %t39
    ;; .for_step_5:
    ;; %t40:i64 = add_i64 _, %t37
    ;; _:i64 = mov %t40
    ;; jmp .for_cond_4
    ;; .for_end_6:
    ;; ret term
    (f64.const 0.0)
  )
  (func $tensor_fill (export "tensor_fill") (param $arr i64) (param $n i64) (param $val f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_7:
    ;; %t3:bool = cmp_lt_i64 i, n
    ;; jz %t3, .for_end_9
    ;; arr[i] = val  ; f64
    ;; .for_step_8:
    ;; %t4:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t4
    ;; jmp .for_cond_7
    ;; .for_end_9:
    ;; ret n
    (i64.const 0)
  )
  (func $tensor_saxpy (export "tensor_saxpy") (param $x i64) (param $y i64) (param $out i64) (param $a f64) (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_10:
    ;; %t3:bool = cmp_lt_i64 i, n
    ;; jz %t3, .for_end_12
    ;; %t4:f64 = x[i]
    ;; %t5:f64 = mul_f64 a, %t4
    ;; %t6:f64 = y[i]
    ;; %t7:f64 = add_f64 %t5, %t6
    ;; out[i] = %t7  ; f64
    ;; .for_step_11:
    ;; %t8:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t8
    ;; jmp .for_cond_10
    ;; .for_end_12:
    ;; ret n
    (i64.const 0)
  )
  (func $tensor_dot (export "tensor_dot") (param $a i64) (param $b i64) (param $n i64) (result f64)
    (local $t_t1 f64)
    (local $acc f64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $i i64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; acc:f64 = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_13:
    ;; %t4:bool = cmp_lt_i64 i, n
    ;; jz %t4, .for_end_15
    ;; %t5:f64 = a[i]
    ;; %t6:f64 = b[i]
    ;; %t7:f64 = mul_f64 %t5, %t6
    ;; %t8:f64 = add_f64 acc, %t7
    ;; acc:f64 = mov %t8
    ;; .for_step_14:
    ;; %t9:i64 = add_i64 i, %t3
    ;; i:i64 = mov %t9
    ;; jmp .for_cond_13
    ;; .for_end_15:
    ;; ret acc
    (f64.const 0.0)
  )
  (func $tensor_norm (export "tensor_norm") (param $arr i64) (param $n i64) (result f64)
    (local $t_t1 f64)
    (local $d f64)
    (local $t_t2 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call tensor_dot(arr, arr, n)
    ;; d:f64 = mov %t1
    ;; %t2:f64 = sqrt_f64 d
    ;; ret %t2
    (f64.const 0.0)
  )
  (func $tensor_relu (export "tensor_relu") (param $x i64) (param $out i64) (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $v f64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_16:
    ;; %t3:bool = cmp_lt_i64 i, n
    ;; jz %t3, .for_end_18
    ;; %t4:f64 = x[i]
    ;; v:f64 = mov %t4
    ;; %t5:f64 = const_f64 0.0
    ;; %t6:bool = cmp_gt_f64 v, %t5
    ;; jz %t6, .if_next_20
    ;; out[i] = v  ; f64
    ;; jmp .if_end_19
    ;; .if_next_20:
    ;; %t7:f64 = const_f64 0.0
    ;; out[i] = %t7  ; f64
    ;; .if_end_19:
    ;; .for_step_17:
    ;; %t8:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t8
    ;; jmp .for_cond_16
    ;; .for_end_18:
    ;; ret n
    (i64.const 0)
  )
  (func $tensor_sigmoid (export "tensor_sigmoid") (param $x i64) (param $out i64) (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $v f64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 f64)
    (local $t_t13 f64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $t_t18 f64)
    (local $t_t19 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_21:
    ;; %t3:bool = cmp_lt_i64 i, n
    ;; jz %t3, .for_end_23
    ;; %t4:f64 = x[i]
    ;; v:f64 = mov %t4
    ;; %t5:f64 = const_f64 40.0
    ;; %t6:bool = cmp_ge_f64 v, %t5
    ;; jz %t6, .if_next_25
    ;; %t7:f64 = const_f64 1.0
    ;; out[i] = %t7  ; f64
    ;; jmp .if_end_24
    ;; .if_next_25:
    ;; %t8:f64 = const_f64 40.0
    ;; %t9:f64 = neg_f64 %t8
    ;; %t10:bool = cmp_le_f64 v, %t9
    ;; jz %t10, .if_elif_26
    ;; %t11:f64 = const_f64 0.0
    ;; out[i] = %t11  ; f64
    ;; jmp .if_end_24
    ;; .if_elif_26:
    ;; %t12:f64 = const_f64 1.0
    ;; %t13:f64 = const_f64 1.0
    ;; %t14:f64 = const_f64 0.0
    ;; %t15:f64 = sub_f64 %t14, v
    ;; %t16:f64 = call exp(%t15)
    ;; %t17:f64 = add_f64 %t13, %t16
    ;; %t18:f64 = div_f64 %t12, %t17
    ;; out[i] = %t18  ; f64
    ;; .if_end_24:
    ;; .for_step_22:
    ;; %t19:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t19
    ;; jmp .for_cond_21
    ;; .for_end_23:
    ;; ret n
    (i64.const 0)
  )
  (func $tensor_matmul (export "tensor_matmul") (param $A i64) (param $B i64) (param $C i64) (param $M i64) (param $K i64) (param $N i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $i i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $row_a i64)
    (local $t_t5 i64)
    (local $row_c i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $j i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $acc f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $k i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $t_t18 f64)
    (local $t_t19 f64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = const_i64 1
    ;; i:i64 = mov %t1
    ;; .for_cond_27:
    ;; %t3:bool = cmp_lt_i64 i, M
    ;; jz %t3, .for_end_29
    ;; %t4:i64 = mul_i64 i, K
    ;; row_a:i64 = mov %t4
    ;; %t5:i64 = mul_i64 i, N
    ;; row_c:i64 = mov %t5
    ;; %t6:i64 = const_i64 0
    ;; %t7:i64 = const_i64 1
    ;; j:i64 = mov %t6
    ;; .for_cond_30:
    ;; %t8:bool = cmp_lt_i64 j, N
    ;; jz %t8, .for_end_32
    ;; %t9:f64 = const_f64 0.0
    ;; acc:f64 = mov %t9
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 1
    ;; k:i64 = mov %t10
    ;; .for_cond_33:
    ;; %t12:bool = cmp_lt_i64 k, K
    ;; jz %t12, .for_end_35
    ;; %t13:i64 = add_i64 row_a, k
    ;; %t14:f64 = A[%t13]
    ;; %t15:i64 = mul_i64 k, N
    ;; %t16:i64 = add_i64 %t15, j
    ;; %t17:f64 = B[%t16]
    ;; %t18:f64 = mul_f64 %t14, %t17
    ;; %t19:f64 = add_f64 acc, %t18
    ;; acc:f64 = mov %t19
    ;; .for_step_34:
    ;; %t20:i64 = add_i64 k, %t11
    ;; k:i64 = mov %t20
    ;; jmp .for_cond_33
    ;; .for_end_35:
    ;; %t21:i64 = add_i64 row_c, j
    ;; C[%t21] = acc  ; f64
    ;; .for_step_31:
    ;; %t22:i64 = add_i64 j, %t7
    ;; j:i64 = mov %t22
    ;; jmp .for_cond_30
    ;; .for_end_32:
    ;; .for_step_28:
    ;; %t23:i64 = add_i64 i, %t2
    ;; i:i64 = mov %t23
    ;; jmp .for_cond_27
    ;; .for_end_29:
    ;; %t24:i64 = mul_i64 M, N
    ;; ret %t24
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $n i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $x i64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $y i64)
    (local $t_t7 i64)
    (local $t_t8 f64)
    (local $out i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $i i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 f64)
    (local $t_t24 i64)
    (local $t_t25 f64)
    (local $dot_val f64)
    (local $t_t26 f64)
    (local $norm_val f64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 f64)
    (local $t_t32 f64)
    (local $t_t33 i64)
    (local $t_t34 f64)
    (local $t_t35 i64)
    (local $t_t36 f64)
    (local $t_t37 i64)
    (local $t_t38 f64)
    (local $t_t39 i64)
    (local $A i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 f64)
    (local $t_t43 f64)
    (local $t_t44 i64)
    (local $t_t45 f64)
    (local $t_t46 i64)
    (local $t_t47 f64)
    (local $t_t48 i64)
    (local $t_t49 f64)
    (local $t_t50 i64)
    (local $B i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $t_t53 f64)
    (local $t_t54 f64)
    (local $t_t55 i64)
    (local $t_t56 f64)
    (local $t_t57 i64)
    (local $t_t58 f64)
    (local $t_t59 i64)
    (local $t_t60 f64)
    (local $t_t61 i64)
    (local $C i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $t_t64 i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $t_t67 i64)
    (local $t_t68 f64)
    (local $t_t69 i64)
    (local $t_t70 f64)
    (local $t_t71 i64)
    (local $t_t72 f64)
    (local $t_t73 i64)
    (local $t_t74 f64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $t_t77 f64)
    (local $t_t78 f64)
    (local $t_t79 f64)
    (local $t_t80 i64)
    (local $t_t81 f64)
    (local $t_t82 i64)
    (local $t_t83 f64)
    (local $t_t84 i64)
    (local $t_t85 f64)
    (local $t_t86 i64)
    (local $acts_in i64)
    (local $t_t87 i64)
    (local $t_t88 i64)
    (local $t_t89 f64)
    (local $relu_out i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $t_t93 i64)
    (local $t_t94 f64)
    (local $t_t95 i64)
    (local $t_t96 f64)
    (local $t_t97 i64)
    (local $t_t98 f64)
    (local $t_t99 i64)
    (local $t_t100 f64)
    (local $t_t101 i64)
    (local $t_arena_sp_main i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_main:i64 = arena_save None
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:i64 = const_i64 5
    ;; n:i64 = mov %t2
    ;; %t4:f64 = const_f64 1.0
    ;; %t3:Array[f64] = alloc_array(n, init=%t4)
    ;; x:Array[f64] = mov %t3
    ;; %t6:f64 = const_f64 2.0
    ;; %t5:Array[f64] = alloc_array(n, init=%t6)
    ;; y:Array[f64] = mov %t5
    ;; %t8:f64 = const_f64 0.0
    ;; %t7:Array[f64] = alloc_array(n, init=%t8)
    ;; out:Array[f64] = mov %t7
    ;; %t9:i64 = const_i64 0
    ;; %t10:i64 = const_i64 1
    ;; i:i64 = mov %t9
    ;; .for_cond_36:
    ;; %t11:bool = cmp_lt_i64 i, n
    ;; jz %t11, .for_end_38
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = add_i64 i, %t12
    ;; %t14:f64 = i64_to_f64 %t13
    ;; x[i] = %t14  ; f64
    ;; %t15:f64 = const_f64 10.0
    ;; y[i] = %t15  ; f64
    ;; .for_step_37:
    ;; %t16:i64 = add_i64 i, %t10
    ;; i:i64 = mov %t16
    ;; jmp .for_cond_36
    ;; .for_end_38:
    ;; %t17:f64 = const_f64 3.0
    ;; %t18:i64 = call tensor_saxpy(x, y, out, %t17, n)
    ;; %t19:str = const_str 1
    ;; print(%t19:str)
    ;; %t20:i64 = const_i64 0
    ;; %t21:i64 = const_i64 1
    ;; i:i64 = mov %t20
    ;; .for_cond_39:
    ;; %t22:bool = cmp_lt_i64 i, n
    ;; jz %t22, .for_end_41
    ;; %t23:f64 = out[i]
    ;; print(%t23:f64)
    ;; .for_step_40:
    ;; %t24:i64 = add_i64 i, %t21
    ;; i:i64 = mov %t24
    ;; jmp .for_cond_39
    ;; .for_end_41:
    ;; %t25:f64 = call tensor_dot(out, out, n)
    ;; dot_val:f64 = mov %t25
    ;; %t26:f64 = call tensor_norm(out, n)
    ;; norm_val:f64 = mov %t26
    ;; %t27:str = const_str 2
    ;; print(%t27:str)
    ;; print(dot_val:f64)
    ;; %t28:str = const_str 3
    ;; print(%t28:str)
    ;; print(norm_val:f64)
    ;; %t30:i64 = const_i64 4
    ;; %t31:f64 = const_f64 0.0
    ;; %t29:Array[f64] = alloc_array(%t30, init=%t31)
    ;; %t32:f64 = const_f64 1.0
    ;; %t33:i64 = const_i64 0
    ;; %t29[%t33] = %t32  ; f64
    ;; %t34:f64 = const_f64 2.0
    ;; %t35:i64 = const_i64 1
    ;; %t29[%t35] = %t34  ; f64
    ;; %t36:f64 = const_f64 3.0
    ;; %t37:i64 = const_i64 2
    ;; %t29[%t37] = %t36  ; f64
    ;; %t38:f64 = const_f64 4.0
    ;; %t39:i64 = const_i64 3
    ;; %t29[%t39] = %t38  ; f64
    ;; A:Array[f64] = mov %t29
    ;; %t41:i64 = const_i64 4
    ;; %t42:f64 = const_f64 0.0
    ;; %t40:Array[f64] = alloc_array(%t41, init=%t42)
    ;; %t43:f64 = const_f64 5.0
    ;; %t44:i64 = const_i64 0
    ;; %t40[%t44] = %t43  ; f64
    ;; %t45:f64 = const_f64 6.0
    ;; %t46:i64 = const_i64 1
    ;; %t40[%t46] = %t45  ; f64
    ;; %t47:f64 = const_f64 7.0
    ;; %t48:i64 = const_i64 2
    ;; %t40[%t48] = %t47  ; f64
    ;; %t49:f64 = const_f64 8.0
    ;; %t50:i64 = const_i64 3
    ;; %t40[%t50] = %t49  ; f64
    ;; B:Array[f64] = mov %t40
    ;; %t52:i64 = const_i64 4
    ;; %t53:f64 = const_f64 0.0
    ;; %t51:Array[f64] = alloc_array(%t52, init=%t53)
    ;; %t54:f64 = const_f64 0.0
    ;; %t55:i64 = const_i64 0
    ;; %t51[%t55] = %t54  ; f64
    ;; %t56:f64 = const_f64 0.0
    ;; %t57:i64 = const_i64 1
    ;; %t51[%t57] = %t56  ; f64
    ;; %t58:f64 = const_f64 0.0
    ;; %t59:i64 = const_i64 2
    ;; %t51[%t59] = %t58  ; f64
    ;; %t60:f64 = const_f64 0.0
    ;; %t61:i64 = const_i64 3
    ;; %t51[%t61] = %t60  ; f64
    ;; C:Array[f64] = mov %t51
    ;; %t62:i64 = const_i64 2
    ;; %t63:i64 = const_i64 2
    ;; %t64:i64 = const_i64 2
    ;; %t65:i64 = call tensor_matmul(A, B, C, %t62, %t63, %t64)
    ;; %t66:str = const_str 4
    ;; print(%t66:str)
    ;; %t67:i64 = const_i64 0
    ;; %t68:f64 = C[%t67]
    ;; print(%t68:f64)
    ;; %t69:i64 = const_i64 1
    ;; %t70:f64 = C[%t69]
    ;; print(%t70:f64)
    ;; %t71:i64 = const_i64 2
    ;; %t72:f64 = C[%t71]
    ;; print(%t72:f64)
    ;; %t73:i64 = const_i64 3
    ;; %t74:f64 = C[%t73]
    ;; print(%t74:f64)
    ;; %t76:i64 = const_i64 4
    ;; %t77:f64 = const_f64 0.0
    ;; %t75:Array[f64] = alloc_array(%t76, init=%t77)
    ;; %t78:f64 = const_f64 2.0
    ;; %t79:f64 = neg_f64 %t78
    ;; %t80:i64 = const_i64 0
    ;; %t75[%t80] = %t79  ; f64
    ;; %t81:f64 = const_f64 0.0
    ;; %t82:i64 = const_i64 1
    ;; %t75[%t82] = %t81  ; f64
    ;; %t83:f64 = const_f64 1.5
    ;; %t84:i64 = const_i64 2
    ;; %t75[%t84] = %t83  ; f64
    ;; %t85:f64 = const_f64 4.0
    ;; %t86:i64 = const_i64 3
    ;; %t75[%t86] = %t85  ; f64
    ;; acts_in:Array[f64] = mov %t75
    ;; %t88:i64 = const_i64 4
    ;; %t89:f64 = const_f64 0.0
    ;; %t87:Array[f64] = alloc_array(%t88, init=%t89)
    ;; relu_out:Array[f64] = mov %t87
    ;; %t90:i64 = const_i64 4
    ;; %t91:i64 = call tensor_relu(acts_in, relu_out, %t90)
    ;; %t92:str = const_str 5
    ;; print(%t92:str)
    ;; %t93:i64 = const_i64 0
    ;; %t94:f64 = relu_out[%t93]
    ;; print(%t94:f64)
    ;; %t95:i64 = const_i64 1
    ;; %t96:f64 = relu_out[%t95]
    ;; print(%t96:f64)
    ;; %t97:i64 = const_i64 2
    ;; %t98:f64 = relu_out[%t97]
    ;; print(%t98:f64)
    ;; %t99:i64 = const_i64 3
    ;; %t100:f64 = relu_out[%t99]
    ;; print(%t100:f64)
    ;; %t101:void = const_i64 0
    ;; arena_restore %arena_sp_main
    ;; ret %t101
    (i64.const 0)
  )
  (func $__bmb_main__ (export "__bmb_main__")  (result i64)
    (local $t_t1 f64)
    (local $PI f64)
    (local $t_t2 f64)
    (local $TAU f64)
    (local $t_t3 f64)
    (local $E f64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 3.141592653589793
    ;; PI:f64 = mov %t1
    ;; %t2:f64 = const_f64 6.283185307179586
    ;; TAU:f64 = mov %t2
    ;; %t3:f64 = const_f64 2.718281828459045
    ;; E:f64 = mov %t3
    ;; %t4:void = call main()
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    (i64.const 0)
  )
)