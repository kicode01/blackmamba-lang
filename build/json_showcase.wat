(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $json_doc_new (export "json_doc_new") (param $capacity i64) (result i64)
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
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $dummy i64)
    (local $t_t22 i64)
    (local $arr i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $i i64)
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
    (local $t_t37 f64)
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
    (local $t_t59 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t2:i64 = const_i64 8
    ;; %t3:i64 = const_i64 0
    ;; %t1:JsonNode = alloc_array(%t2, init=%t3)
    ;; %t4:i64 = const_i64 0
    ;; %t5:i64 = const_i64 0
    ;; %t1[%t5] = %t4  ; i64
    ;; %t6:str = const_str 0
    ;; %t7:i64 = const_i64 1
    ;; %t1[%t7] = %t6  ; str
    ;; %t8:str = const_str 0
    ;; %t9:i64 = const_i64 2
    ;; %t1[%t9] = %t8  ; str
    ;; %t10:i64 = const_i64 0
    ;; %t11:i64 = const_i64 3
    ;; %t1[%t11] = %t10  ; i64
    ;; %t12:f64 = const_f64 0.0
    ;; %t13:i64 = const_i64 4
    ;; %t1[%t13] = %t12  ; f64
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = neg_i64 %t14
    ;; %t16:i64 = const_i64 5
    ;; %t1[%t16] = %t15  ; i64
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = neg_i64 %t17
    ;; %t19:i64 = const_i64 6
    ;; %t1[%t19] = %t18  ; i64
    ;; %t20:i64 = const_i64 0
    ;; %t21:i64 = const_i64 7
    ;; %t1[%t21] = %t20  ; i64
    ;; dummy:JsonNode = mov %t1
    ;; %t22:Array[JsonNode] = alloc_array(capacity, init=dummy)
    ;; arr:Array[JsonNode] = mov %t22
    ;; %t23:i64 = const_i64 0
    ;; %t24:i64 = const_i64 1
    ;; i:i64 = mov %t23
    ;; .for_cond_1:
    ;; %t25:bool = cmp_lt_i64 i, capacity
    ;; jz %t25, .for_end_3
    ;; %t27:i64 = const_i64 8
    ;; %t28:i64 = const_i64 0
    ;; %t26:JsonNode = alloc_array(%t27, init=%t28)
    ;; %t29:i64 = const_i64 0
    ;; %t30:i64 = const_i64 0
    ;; %t26[%t30] = %t29  ; i64
    ;; %t31:str = const_str 0
    ;; %t32:i64 = const_i64 1
    ;; %t26[%t32] = %t31  ; str
    ;; %t33:str = const_str 0
    ;; %t34:i64 = const_i64 2
    ;; %t26[%t34] = %t33  ; str
    ;; %t35:i64 = const_i64 0
    ;; %t36:i64 = const_i64 3
    ;; %t26[%t36] = %t35  ; i64
    ;; %t37:f64 = const_f64 0.0
    ;; %t38:i64 = const_i64 4
    ;; %t26[%t38] = %t37  ; f64
    ;; %t39:i64 = const_i64 1
    ;; %t40:i64 = neg_i64 %t39
    ;; %t41:i64 = const_i64 5
    ;; %t26[%t41] = %t40  ; i64
    ;; %t42:i64 = const_i64 1
    ;; %t43:i64 = neg_i64 %t42
    ;; %t44:i64 = const_i64 6
    ;; %t26[%t44] = %t43  ; i64
    ;; %t45:i64 = const_i64 0
    ;; %t46:i64 = const_i64 7
    ;; %t26[%t46] = %t45  ; i64
    ;; arr[i] = %t26  ; i64
    ;; .for_step_2:
    ;; %t47:i64 = add_i64 i, %t24
    ;; i:i64 = mov %t47
    ;; jmp .for_cond_1
    ;; .for_end_3:
    ;; %t49:i64 = const_i64 5
    ;; %t50:i64 = const_i64 0
    ;; %t48:JsonDoc = alloc_array(%t49, init=%t50)
    ;; %t51:i64 = const_i64 1
    ;; %t52:i64 = neg_i64 %t51
    ;; %t53:i64 = const_i64 0
    ;; %t48[%t53] = %t52  ; i64
    ;; %t54:i64 = const_i64 0
    ;; %t55:i64 = const_i64 1
    ;; %t48[%t55] = %t54  ; i64
    ;; %t56:i64 = const_i64 2
    ;; %t48[%t56] = capacity  ; i64
    ;; %t57:str = const_str 0
    ;; %t58:i64 = const_i64 3
    ;; %t48[%t58] = %t57  ; str
    ;; %t59:i64 = const_i64 4
    ;; %t48[%t59] = arr  ; Array[JsonNode]
    ;; ret %t48
    (i64.const 0)
  )
  (func $json_alloc_node (export "json_alloc_node") (param $doc i64) (param $kind i64) (param $key i64) (param $str_val i64) (param $int_val i64) (param $float_val f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $idx i64)
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
    (local $node i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = doc[%t1]
    ;; idx:i64 = mov %t2
    ;; %t3:i64 = const_i64 2
    ;; %t4:i64 = doc[%t3]
    ;; %t5:bool = cmp_ge_i64 idx, %t4
    ;; jz %t5, .if_end_4
    ;; %t6:str = const_str 1
    ;; %t7:i64 = const_i64 3
    ;; doc[%t7] = %t6  ; str
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = neg_i64 %t8
    ;; ret %t9
    ;; jmp .if_end_4
    ;; .if_end_4:
    ;; %t10:i64 = const_i64 4
    ;; %t11:Array[JsonNode] = doc[%t10]
    ;; %t12:JsonNode = %t11[idx]
    ;; node:JsonNode = mov %t12
    ;; %t13:i64 = const_i64 0
    ;; node[%t13] = kind  ; i64
    ;; %t14:i64 = const_i64 1
    ;; node[%t14] = key  ; str
    ;; %t15:i64 = const_i64 2
    ;; node[%t15] = str_val  ; str
    ;; %t16:i64 = const_i64 3
    ;; node[%t16] = int_val  ; i64
    ;; %t17:i64 = const_i64 4
    ;; node[%t17] = float_val  ; f64
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = neg_i64 %t18
    ;; %t20:i64 = const_i64 5
    ;; node[%t20] = %t19  ; i64
    ;; %t21:i64 = const_i64 1
    ;; %t22:i64 = neg_i64 %t21
    ;; %t23:i64 = const_i64 6
    ;; node[%t23] = %t22  ; i64
    ;; %t24:i64 = const_i64 0
    ;; %t25:i64 = const_i64 7
    ;; node[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = doc[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = add_i64 %t27, %t28
    ;; %t30:i64 = const_i64 1
    ;; doc[%t30] = %t29  ; i64
    ;; ret idx
    (i64.const 0)
  )
  (func $json_skip_ws (export "json_skip_ws") (param $st i64) (result i64)
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
    (local $c i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; .while_cond_5:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = st[%t1]
    ;; %t3:i64 = const_i64 2
    ;; %t4:i64 = st[%t3]
    ;; %t5:bool = cmp_lt_i64 %t2, %t4
    ;; jz %t5, .while_end_6
    ;; %t6:i64 = const_i64 0
    ;; %t7:str = st[%t6]
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = st[%t8]
    ;; %t10:str = str_index(%t7[%t9])
    ;; %t11:i64 = str_ord %t10
    ;; c:i64 = mov %t11
    ;; %t12:i64 = const_i64 32
    ;; %t13:bool = cmp_eq_i64 c, %t12
    ;; %t14:i64 = const_i64 9
    ;; %t15:bool = cmp_eq_i64 c, %t14
    ;; %t16:bool = or_i64 %t13, %t15
    ;; %t17:i64 = const_i64 10
    ;; %t18:bool = cmp_eq_i64 c, %t17
    ;; %t19:bool = or_i64 %t16, %t18
    ;; %t20:i64 = const_i64 13
    ;; %t21:bool = cmp_eq_i64 c, %t20
    ;; %t22:bool = or_i64 %t19, %t21
    ;; jz %t22, .if_next_8
    ;; %t23:i64 = const_i64 1
    ;; %t24:i64 = st[%t23]
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = add_i64 %t24, %t25
    ;; %t27:i64 = const_i64 1
    ;; st[%t27] = %t26  ; i64
    ;; jmp .if_end_7
    ;; .if_next_8:
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = st[%t28]
    ;; ret %t29
    ;; .if_end_7:
    ;; jmp .while_cond_5
    ;; .while_end_6:
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = st[%t30]
    ;; ret %t31
    (i64.const 0)
  )
  (func $json_parse_str (export "json_parse_str") (param $st i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $start i64)
    (local $t_t8 i64)
    (local $has_escape i64)
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
    (local $c i64)
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
    (local $end i64)
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
    (local $res i64)
    (local $i i64)
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
    (local $c2 i64)
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
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $t_t93 i64)
    (local $t_t94 i64)
    (local $t_t95 i64)
    (local $t_t96 i64)
    (local $t_t97 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = st[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 1
    ;; st[%t5] = %t4  ; i64
    ;; %t6:i64 = const_i64 1
    ;; %t7:i64 = st[%t6]
    ;; start:i64 = mov %t7
    ;; %t8:bool = const_i64 0
    ;; has_escape:bool = mov %t8
    ;; .while_cond_9:
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = st[%t9]
    ;; %t11:i64 = const_i64 2
    ;; %t12:i64 = st[%t11]
    ;; %t13:bool = cmp_lt_i64 %t10, %t12
    ;; jz %t13, .while_end_10
    ;; %t14:i64 = const_i64 0
    ;; %t15:str = st[%t14]
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = st[%t16]
    ;; %t18:str = str_index(%t15[%t17])
    ;; %t19:i64 = str_ord %t18
    ;; c:i64 = mov %t19
    ;; %t20:i64 = const_i64 34
    ;; %t21:bool = cmp_eq_i64 c, %t20
    ;; jz %t21, .if_next_12
    ;; jmp .while_end_10
    ;; jmp .if_end_11
    ;; .if_next_12:
    ;; %t22:i64 = const_i64 92
    ;; %t23:bool = cmp_eq_i64 c, %t22
    ;; jz %t23, .if_elif_13
    ;; %t24:bool = const_i64 1
    ;; has_escape:bool = mov %t24
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = st[%t25]
    ;; %t27:i64 = const_i64 2
    ;; %t28:i64 = add_i64 %t26, %t27
    ;; %t29:i64 = const_i64 1
    ;; st[%t29] = %t28  ; i64
    ;; jmp .if_end_11
    ;; .if_elif_13:
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = st[%t30]
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = add_i64 %t31, %t32
    ;; %t34:i64 = const_i64 1
    ;; st[%t34] = %t33  ; i64
    ;; .if_end_11:
    ;; jmp .while_cond_9
    ;; .while_end_10:
    ;; %t35:i64 = const_i64 1
    ;; %t36:i64 = st[%t35]
    ;; %t37:i64 = const_i64 2
    ;; %t38:i64 = st[%t37]
    ;; %t39:bool = cmp_ge_i64 %t36, %t38
    ;; jz %t39, .if_end_14
    ;; %t40:str = const_str 2
    ;; %t41:i64 = const_i64 3
    ;; st[%t41] = %t40  ; str
    ;; %t42:str = const_str 0
    ;; ret %t42
    ;; jmp .if_end_14
    ;; .if_end_14:
    ;; %t43:i64 = const_i64 1
    ;; %t44:i64 = st[%t43]
    ;; end:i64 = mov %t44
    ;; %t45:i64 = const_i64 1
    ;; %t46:i64 = st[%t45]
    ;; %t47:i64 = const_i64 1
    ;; %t48:i64 = add_i64 %t46, %t47
    ;; %t49:i64 = const_i64 1
    ;; st[%t49] = %t48  ; i64
    ;; %t51:i64 = const_i64 0
    ;; %t50:bool = cmp_eq_i64 has_escape, %t51
    ;; jz %t50, .if_end_15
    ;; %t52:i64 = const_i64 0
    ;; %t53:str = st[%t52]
    ;; %t54:str = str_slice(%t53[start:end])
    ;; ret %t54
    ;; jmp .if_end_15
    ;; .if_end_15:
    ;; %t55:str = const_str 0
    ;; res:str = mov %t55
    ;; i:i64 = mov start
    ;; .while_cond_16:
    ;; %t56:bool = cmp_lt_i64 i, end
    ;; jz %t56, .while_end_17
    ;; %t57:i64 = const_i64 0
    ;; %t58:str = st[%t57]
    ;; %t59:str = str_index(%t58[i])
    ;; %t60:i64 = str_ord %t59
    ;; c:i64 = mov %t60
    ;; %t61:i64 = const_i64 92
    ;; %t62:bool = cmp_eq_i64 c, %t61
    ;; jz %t62, .if_next_19
    ;; %t63:i64 = const_i64 1
    ;; %t64:i64 = add_i64 i, %t63
    ;; i:i64 = mov %t64
    ;; %t65:bool = cmp_lt_i64 i, end
    ;; jz %t65, .if_end_20
    ;; %t66:i64 = const_i64 0
    ;; %t67:str = st[%t66]
    ;; %t68:str = str_index(%t67[i])
    ;; %t69:i64 = str_ord %t68
    ;; c2:i64 = mov %t69
    ;; %t70:i64 = const_i64 110
    ;; %t71:bool = cmp_eq_i64 c2, %t70
    ;; jz %t71, .if_next_22
    ;; %t72:str = const_str 3
    ;; %t73:str = str_concat(res, %t72)
    ;; res:str = mov %t73
    ;; jmp .if_end_21
    ;; .if_next_22:
    ;; %t74:i64 = const_i64 116
    ;; %t75:bool = cmp_eq_i64 c2, %t74
    ;; jz %t75, .if_elif_23
    ;; %t76:str = const_str 4
    ;; %t77:str = str_concat(res, %t76)
    ;; res:str = mov %t77
    ;; jmp .if_end_21
    ;; .if_elif_23:
    ;; %t78:i64 = const_i64 114
    ;; %t79:bool = cmp_eq_i64 c2, %t78
    ;; jz %t79, .if_elif_24
    ;; %t80:str = const_str 5
    ;; %t81:str = str_concat(res, %t80)
    ;; res:str = mov %t81
    ;; jmp .if_end_21
    ;; .if_elif_24:
    ;; %t82:i64 = const_i64 34
    ;; %t83:bool = cmp_eq_i64 c2, %t82
    ;; jz %t83, .if_elif_25
    ;; %t84:str = const_str 6
    ;; %t85:str = str_concat(res, %t84)
    ;; res:str = mov %t85
    ;; jmp .if_end_21
    ;; .if_elif_25:
    ;; %t86:i64 = const_i64 92
    ;; %t87:bool = cmp_eq_i64 c2, %t86
    ;; jz %t87, .if_elif_26
    ;; %t88:str = const_str 7
    ;; %t89:str = str_concat(res, %t88)
    ;; res:str = mov %t89
    ;; jmp .if_end_21
    ;; .if_elif_26:
    ;; %t90:str = str_chr c2
    ;; %t91:str = str_concat(res, %t90)
    ;; res:str = mov %t91
    ;; .if_end_21:
    ;; %t92:i64 = const_i64 1
    ;; %t93:i64 = add_i64 i, %t92
    ;; i:i64 = mov %t93
    ;; jmp .if_end_20
    ;; .if_end_20:
    ;; jmp .if_end_18
    ;; .if_next_19:
    ;; %t94:str = str_chr c
    ;; %t95:str = str_concat(res, %t94)
    ;; res:str = mov %t95
    ;; %t96:i64 = const_i64 1
    ;; %t97:i64 = add_i64 i, %t96
    ;; i:i64 = mov %t97
    ;; .if_end_18:
    ;; jmp .while_cond_16
    ;; .while_end_17:
    ;; ret res
    (i64.const 0)
  )
  (func $json_parse_num (export "json_parse_num") (param $st i64) (param $doc i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $start i64)
    (local $t_t3 i64)
    (local $is_float i64)
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
    (local $c i64)
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
    (local $num_str i64)
    (local $t_t99 f64)
    (local $f f64)
    (local $t_t100 i64)
    (local $t_t101 i64)
    (local $t_t102 i64)
    (local $t_t103 i64)
    (local $t_t104 i64)
    (local $t_t105 i64)
    (local $i i64)
    (local $t_t106 i64)
    (local $t_t107 i64)
    (local $t_t108 i64)
    (local $t_t109 f64)
    (local $t_t110 i64)
    (local $t_t111 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = st[%t1]
    ;; start:i64 = mov %t2
    ;; %t3:bool = const_i64 0
    ;; is_float:bool = mov %t3
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = st[%t4]
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = st[%t6]
    ;; %t8:bool = cmp_lt_i64 %t5, %t7
    ;; %t9:i64 = const_i64 0
    ;; %t10:str = st[%t9]
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = st[%t11]
    ;; %t13:str = str_index(%t10[%t12])
    ;; %t14:i64 = str_ord %t13
    ;; %t15:i64 = const_i64 45
    ;; %t16:bool = cmp_eq_i64 %t14, %t15
    ;; %t17:bool = and_i64 %t8, %t16
    ;; jz %t17, .if_end_27
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = st[%t18]
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = add_i64 %t19, %t20
    ;; %t22:i64 = const_i64 1
    ;; st[%t22] = %t21  ; i64
    ;; jmp .if_end_27
    ;; .if_end_27:
    ;; .while_cond_28:
    ;; %t23:i64 = const_i64 1
    ;; %t24:i64 = st[%t23]
    ;; %t25:i64 = const_i64 2
    ;; %t26:i64 = st[%t25]
    ;; %t27:bool = cmp_lt_i64 %t24, %t26
    ;; jz %t27, .while_end_29
    ;; %t28:i64 = const_i64 0
    ;; %t29:str = st[%t28]
    ;; %t30:i64 = const_i64 1
    ;; %t31:i64 = st[%t30]
    ;; %t32:str = str_index(%t29[%t31])
    ;; %t33:i64 = str_ord %t32
    ;; c:i64 = mov %t33
    ;; %t34:i64 = const_i64 48
    ;; %t35:bool = cmp_ge_i64 c, %t34
    ;; %t36:i64 = const_i64 57
    ;; %t37:bool = cmp_le_i64 c, %t36
    ;; %t38:bool = and_i64 %t35, %t37
    ;; jz %t38, .if_next_31
    ;; %t39:i64 = const_i64 1
    ;; %t40:i64 = st[%t39]
    ;; %t41:i64 = const_i64 1
    ;; %t42:i64 = add_i64 %t40, %t41
    ;; %t43:i64 = const_i64 1
    ;; st[%t43] = %t42  ; i64
    ;; jmp .if_end_30
    ;; .if_next_31:
    ;; %t44:i64 = const_i64 46
    ;; %t45:bool = cmp_eq_i64 c, %t44
    ;; %t46:i64 = const_i64 101
    ;; %t47:bool = cmp_eq_i64 c, %t46
    ;; %t48:bool = or_i64 %t45, %t47
    ;; %t49:i64 = const_i64 69
    ;; %t50:bool = cmp_eq_i64 c, %t49
    ;; %t51:bool = or_i64 %t48, %t50
    ;; jz %t51, .if_elif_32
    ;; %t52:bool = const_i64 1
    ;; is_float:bool = mov %t52
    ;; %t53:i64 = const_i64 1
    ;; %t54:i64 = st[%t53]
    ;; %t55:i64 = const_i64 1
    ;; %t56:i64 = add_i64 %t54, %t55
    ;; %t57:i64 = const_i64 1
    ;; st[%t57] = %t56  ; i64
    ;; jmp .if_end_30
    ;; .if_elif_32:
    ;; %t58:i64 = const_i64 43
    ;; %t59:bool = cmp_eq_i64 c, %t58
    ;; %t60:i64 = const_i64 45
    ;; %t61:bool = cmp_eq_i64 c, %t60
    ;; %t62:bool = or_i64 %t59, %t61
    ;; %t63:i64 = const_i64 1
    ;; %t64:i64 = st[%t63]
    ;; %t65:bool = cmp_gt_i64 %t64, start
    ;; %t66:bool = and_i64 %t62, %t65
    ;; %t67:i64 = const_i64 0
    ;; %t68:str = st[%t67]
    ;; %t69:i64 = const_i64 1
    ;; %t70:i64 = st[%t69]
    ;; %t71:i64 = const_i64 1
    ;; %t72:i64 = sub_i64 %t70, %t71
    ;; %t73:str = str_index(%t68[%t72])
    ;; %t74:i64 = str_ord %t73
    ;; %t75:i64 = const_i64 101
    ;; %t76:bool = cmp_eq_i64 %t74, %t75
    ;; %t77:i64 = const_i64 0
    ;; %t78:str = st[%t77]
    ;; %t79:i64 = const_i64 1
    ;; %t80:i64 = st[%t79]
    ;; %t81:i64 = const_i64 1
    ;; %t82:i64 = sub_i64 %t80, %t81
    ;; %t83:str = str_index(%t78[%t82])
    ;; %t84:i64 = str_ord %t83
    ;; %t85:i64 = const_i64 69
    ;; %t86:bool = cmp_eq_i64 %t84, %t85
    ;; %t87:bool = or_i64 %t76, %t86
    ;; %t88:bool = and_i64 %t66, %t87
    ;; jz %t88, .if_elif_33
    ;; %t89:i64 = const_i64 1
    ;; %t90:i64 = st[%t89]
    ;; %t91:i64 = const_i64 1
    ;; %t92:i64 = add_i64 %t90, %t91
    ;; %t93:i64 = const_i64 1
    ;; st[%t93] = %t92  ; i64
    ;; jmp .if_end_30
    ;; .if_elif_33:
    ;; jmp .while_end_29
    ;; .if_end_30:
    ;; jmp .while_cond_28
    ;; .while_end_29:
    ;; %t94:i64 = const_i64 0
    ;; %t95:str = st[%t94]
    ;; %t96:i64 = const_i64 1
    ;; %t97:i64 = st[%t96]
    ;; %t98:str = str_slice(%t95[start:%t97])
    ;; num_str:str = mov %t98
    ;; jz is_float, .if_next_35
    ;; %t99:f64 = str_to_f64 num_str
    ;; f:f64 = mov %t99
    ;; %t100:i64 = const_i64 3
    ;; %t101:str = const_str 0
    ;; %t102:str = const_str 0
    ;; %t103:i64 = const_i64 0
    ;; %t104:i64 = call json_alloc_node(doc, %t100, %t101, %t102, %t103, f)
    ;; ret %t104
    ;; jmp .if_end_34
    ;; .if_next_35:
    ;; %t105:i64 = str_to_i64 num_str
    ;; i:i64 = mov %t105
    ;; %t106:i64 = const_i64 2
    ;; %t107:str = const_str 0
    ;; %t108:str = const_str 0
    ;; %t109:f64 = const_f64 0.0
    ;; %t110:i64 = call json_alloc_node(doc, %t106, %t107, %t108, i, %t109)
    ;; ret %t110
    ;; .if_end_34:
    ;; %t111:i64 = const_i64 0
    ;; ret %t111
    (i64.const 0)
  )
  (func $json_parse_val (export "json_parse_val") (param $st i64) (param $doc i64) (result i64)
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
    (local $c i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $s i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 f64)
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
    (local $t_t70 f64)
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
    (local $t_t102 f64)
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
    (local $t_t116 i64)
    (local $t_t117 i64)
    (local $t_t118 i64)
    (local $t_t119 i64)
    (local $t_t120 i64)
    (local $t_t121 i64)
    (local $t_t122 i64)
    (local $t_t123 i64)
    (local $t_t124 i64)
    (local $t_t125 i64)
    (local $t_t126 i64)
    (local $t_t127 i64)
    (local $t_t128 i64)
    (local $t_t129 i64)
    (local $t_t130 i64)
    (local $t_t131 i64)
    (local $t_t132 i64)
    (local $t_t133 i64)
    (local $t_t134 f64)
    (local $t_t135 i64)
    (local $t_t136 i64)
    (local $t_t137 i64)
    (local $t_t138 i64)
    (local $t_t139 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call json_skip_ws(st)
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = st[%t2]
    ;; %t4:i64 = const_i64 2
    ;; %t5:i64 = st[%t4]
    ;; %t6:bool = cmp_ge_i64 %t3, %t5
    ;; jz %t6, .if_end_36
    ;; %t7:str = const_str 8
    ;; %t8:i64 = const_i64 3
    ;; st[%t8] = %t7  ; str
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = neg_i64 %t9
    ;; ret %t10
    ;; jmp .if_end_36
    ;; .if_end_36:
    ;; %t11:i64 = const_i64 0
    ;; %t12:str = st[%t11]
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = st[%t13]
    ;; %t15:str = str_index(%t12[%t14])
    ;; %t16:i64 = str_ord %t15
    ;; c:i64 = mov %t16
    ;; %t17:i64 = const_i64 123
    ;; %t18:bool = cmp_eq_i64 c, %t17
    ;; jz %t18, .if_next_38
    ;; %t19:i64 = call json_parse_obj(st, doc)
    ;; ret %t19
    ;; jmp .if_end_37
    ;; .if_next_38:
    ;; %t20:i64 = const_i64 91
    ;; %t21:bool = cmp_eq_i64 c, %t20
    ;; jz %t21, .if_elif_39
    ;; %t22:i64 = call json_parse_arr(st, doc)
    ;; ret %t22
    ;; jmp .if_end_37
    ;; .if_elif_39:
    ;; %t23:i64 = const_i64 34
    ;; %t24:bool = cmp_eq_i64 c, %t23
    ;; jz %t24, .if_elif_40
    ;; %t25:str = call json_parse_str(st)
    ;; s:str = mov %t25
    ;; %t26:i64 = const_i64 4
    ;; %t27:str = const_str 0
    ;; %t28:i64 = const_i64 0
    ;; %t29:f64 = const_f64 0.0
    ;; %t30:i64 = call json_alloc_node(doc, %t26, %t27, s, %t28, %t29)
    ;; ret %t30
    ;; jmp .if_end_37
    ;; .if_elif_40:
    ;; %t31:i64 = const_i64 48
    ;; %t32:bool = cmp_ge_i64 c, %t31
    ;; %t33:i64 = const_i64 57
    ;; %t34:bool = cmp_le_i64 c, %t33
    ;; %t35:bool = and_i64 %t32, %t34
    ;; %t36:i64 = const_i64 45
    ;; %t37:bool = cmp_eq_i64 c, %t36
    ;; %t38:bool = or_i64 %t35, %t37
    ;; jz %t38, .if_elif_41
    ;; %t39:i64 = call json_parse_num(st, doc)
    ;; ret %t39
    ;; jmp .if_end_37
    ;; .if_elif_41:
    ;; %t40:i64 = const_i64 116
    ;; %t41:bool = cmp_eq_i64 c, %t40
    ;; jz %t41, .if_elif_42
    ;; %t42:i64 = const_i64 1
    ;; %t43:i64 = st[%t42]
    ;; %t44:i64 = const_i64 4
    ;; %t45:i64 = add_i64 %t43, %t44
    ;; %t46:i64 = const_i64 2
    ;; %t47:i64 = st[%t46]
    ;; %t48:bool = cmp_le_i64 %t45, %t47
    ;; %t49:i64 = const_i64 0
    ;; %t50:str = st[%t49]
    ;; %t51:i64 = const_i64 1
    ;; %t52:i64 = st[%t51]
    ;; %t53:i64 = const_i64 1
    ;; %t54:i64 = st[%t53]
    ;; %t55:i64 = const_i64 4
    ;; %t56:i64 = add_i64 %t54, %t55
    ;; %t57:str = str_slice(%t50[%t52:%t56])
    ;; %t58:str = const_str 9
    ;; %t59:bool = str_cmp_eq %t57, %t58
    ;; %t60:bool = and_i64 %t48, %t59
    ;; jz %t60, .if_end_43
    ;; %t61:i64 = const_i64 1
    ;; %t62:i64 = st[%t61]
    ;; %t63:i64 = const_i64 4
    ;; %t64:i64 = add_i64 %t62, %t63
    ;; %t65:i64 = const_i64 1
    ;; st[%t65] = %t64  ; i64
    ;; %t66:i64 = const_i64 1
    ;; %t67:str = const_str 0
    ;; %t68:str = const_str 0
    ;; %t69:i64 = const_i64 1
    ;; %t70:f64 = const_f64 0.0
    ;; %t71:i64 = call json_alloc_node(doc, %t66, %t67, %t68, %t69, %t70)
    ;; ret %t71
    ;; jmp .if_end_43
    ;; .if_end_43:
    ;; jmp .if_end_37
    ;; .if_elif_42:
    ;; %t72:i64 = const_i64 102
    ;; %t73:bool = cmp_eq_i64 c, %t72
    ;; jz %t73, .if_elif_44
    ;; %t74:i64 = const_i64 1
    ;; %t75:i64 = st[%t74]
    ;; %t76:i64 = const_i64 5
    ;; %t77:i64 = add_i64 %t75, %t76
    ;; %t78:i64 = const_i64 2
    ;; %t79:i64 = st[%t78]
    ;; %t80:bool = cmp_le_i64 %t77, %t79
    ;; %t81:i64 = const_i64 0
    ;; %t82:str = st[%t81]
    ;; %t83:i64 = const_i64 1
    ;; %t84:i64 = st[%t83]
    ;; %t85:i64 = const_i64 1
    ;; %t86:i64 = st[%t85]
    ;; %t87:i64 = const_i64 5
    ;; %t88:i64 = add_i64 %t86, %t87
    ;; %t89:str = str_slice(%t82[%t84:%t88])
    ;; %t90:str = const_str 10
    ;; %t91:bool = str_cmp_eq %t89, %t90
    ;; %t92:bool = and_i64 %t80, %t91
    ;; jz %t92, .if_end_45
    ;; %t93:i64 = const_i64 1
    ;; %t94:i64 = st[%t93]
    ;; %t95:i64 = const_i64 5
    ;; %t96:i64 = add_i64 %t94, %t95
    ;; %t97:i64 = const_i64 1
    ;; st[%t97] = %t96  ; i64
    ;; %t98:i64 = const_i64 1
    ;; %t99:str = const_str 0
    ;; %t100:str = const_str 0
    ;; %t101:i64 = const_i64 0
    ;; %t102:f64 = const_f64 0.0
    ;; %t103:i64 = call json_alloc_node(doc, %t98, %t99, %t100, %t101, %t102)
    ;; ret %t103
    ;; jmp .if_end_45
    ;; .if_end_45:
    ;; jmp .if_end_37
    ;; .if_elif_44:
    ;; %t104:i64 = const_i64 110
    ;; %t105:bool = cmp_eq_i64 c, %t104
    ;; jz %t105, .if_end_37
    ;; %t106:i64 = const_i64 1
    ;; %t107:i64 = st[%t106]
    ;; %t108:i64 = const_i64 4
    ;; %t109:i64 = add_i64 %t107, %t108
    ;; %t110:i64 = const_i64 2
    ;; %t111:i64 = st[%t110]
    ;; %t112:bool = cmp_le_i64 %t109, %t111
    ;; %t113:i64 = const_i64 0
    ;; %t114:str = st[%t113]
    ;; %t115:i64 = const_i64 1
    ;; %t116:i64 = st[%t115]
    ;; %t117:i64 = const_i64 1
    ;; %t118:i64 = st[%t117]
    ;; %t119:i64 = const_i64 4
    ;; %t120:i64 = add_i64 %t118, %t119
    ;; %t121:str = str_slice(%t114[%t116:%t120])
    ;; %t122:str = const_str 11
    ;; %t123:bool = str_cmp_eq %t121, %t122
    ;; %t124:bool = and_i64 %t112, %t123
    ;; jz %t124, .if_end_46
    ;; %t125:i64 = const_i64 1
    ;; %t126:i64 = st[%t125]
    ;; %t127:i64 = const_i64 4
    ;; %t128:i64 = add_i64 %t126, %t127
    ;; %t129:i64 = const_i64 1
    ;; st[%t129] = %t128  ; i64
    ;; %t130:i64 = const_i64 0
    ;; %t131:str = const_str 0
    ;; %t132:str = const_str 0
    ;; %t133:i64 = const_i64 0
    ;; %t134:f64 = const_f64 0.0
    ;; %t135:i64 = call json_alloc_node(doc, %t130, %t131, %t132, %t133, %t134)
    ;; ret %t135
    ;; jmp .if_end_46
    ;; .if_end_46:
    ;; jmp .if_end_37
    ;; .if_end_37:
    ;; %t136:str = const_str 12
    ;; %t137:i64 = const_i64 3
    ;; st[%t137] = %t136  ; str
    ;; %t138:i64 = const_i64 1
    ;; %t139:i64 = neg_i64 %t138
    ;; ret %t139
    (i64.const 0)
  )
  (func $json_parse_arr (export "json_parse_arr") (param $st i64) (param $doc i64) (result i64)
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
    (local $arr_idx i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $prev_child i64)
    (local $t_t14 i64)
    (local $count i64)
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
    (local $child_idx i64)
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
    (local $c i64)
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
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = st[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 1
    ;; st[%t5] = %t4  ; i64
    ;; %t6:i64 = const_i64 5
    ;; %t7:str = const_str 0
    ;; %t8:str = const_str 0
    ;; %t9:i64 = const_i64 0
    ;; %t10:f64 = const_f64 0.0
    ;; %t11:i64 = call json_alloc_node(doc, %t6, %t7, %t8, %t9, %t10)
    ;; arr_idx:i64 = mov %t11
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; prev_child:i64 = mov %t13
    ;; %t14:i64 = const_i64 0
    ;; count:i64 = mov %t14
    ;; .while_cond_47:
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = st[%t15]
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = st[%t17]
    ;; %t19:bool = cmp_lt_i64 %t16, %t18
    ;; jz %t19, .while_end_48
    ;; %t20:i64 = call json_skip_ws(st)
    ;; %t21:i64 = const_i64 1
    ;; %t22:i64 = st[%t21]
    ;; %t23:i64 = const_i64 2
    ;; %t24:i64 = st[%t23]
    ;; %t25:bool = cmp_lt_i64 %t22, %t24
    ;; %t26:i64 = const_i64 0
    ;; %t27:str = st[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = st[%t28]
    ;; %t30:str = str_index(%t27[%t29])
    ;; %t31:i64 = str_ord %t30
    ;; %t32:i64 = const_i64 93
    ;; %t33:bool = cmp_eq_i64 %t31, %t32
    ;; %t34:bool = and_i64 %t25, %t33
    ;; jz %t34, .if_end_49
    ;; %t35:i64 = const_i64 1
    ;; %t36:i64 = st[%t35]
    ;; %t37:i64 = const_i64 1
    ;; %t38:i64 = add_i64 %t36, %t37
    ;; %t39:i64 = const_i64 1
    ;; st[%t39] = %t38  ; i64
    ;; jmp .while_end_48
    ;; jmp .if_end_49
    ;; .if_end_49:
    ;; %t40:i64 = call json_parse_val(st, doc)
    ;; child_idx:i64 = mov %t40
    ;; %t41:i64 = const_i64 1
    ;; %t42:i64 = neg_i64 %t41
    ;; %t43:bool = cmp_eq_i64 child_idx, %t42
    ;; jz %t43, .if_end_50
    ;; %t44:i64 = const_i64 1
    ;; %t45:i64 = neg_i64 %t44
    ;; ret %t45
    ;; jmp .if_end_50
    ;; .if_end_50:
    ;; %t46:i64 = const_i64 1
    ;; %t47:i64 = neg_i64 %t46
    ;; %t48:bool = cmp_eq_i64 prev_child, %t47
    ;; jz %t48, .if_next_52
    ;; %t49:i64 = const_i64 4
    ;; %t50:Array[JsonNode] = doc[%t49]
    ;; %t51:JsonNode = %t50[arr_idx]
    ;; %t52:i64 = const_i64 5
    ;; %t51[%t52] = child_idx  ; i64
    ;; jmp .if_end_51
    ;; .if_next_52:
    ;; %t53:i64 = const_i64 4
    ;; %t54:Array[JsonNode] = doc[%t53]
    ;; %t55:JsonNode = %t54[prev_child]
    ;; %t56:i64 = const_i64 6
    ;; %t55[%t56] = child_idx  ; i64
    ;; .if_end_51:
    ;; prev_child:i64 = mov child_idx
    ;; %t57:i64 = const_i64 1
    ;; %t58:i64 = add_i64 count, %t57
    ;; count:i64 = mov %t58
    ;; %t59:i64 = call json_skip_ws(st)
    ;; %t60:i64 = const_i64 1
    ;; %t61:i64 = st[%t60]
    ;; %t62:i64 = const_i64 2
    ;; %t63:i64 = st[%t62]
    ;; %t64:bool = cmp_lt_i64 %t61, %t63
    ;; jz %t64, .if_end_53
    ;; %t65:i64 = const_i64 0
    ;; %t66:str = st[%t65]
    ;; %t67:i64 = const_i64 1
    ;; %t68:i64 = st[%t67]
    ;; %t69:str = str_index(%t66[%t68])
    ;; %t70:i64 = str_ord %t69
    ;; c:i64 = mov %t70
    ;; %t71:i64 = const_i64 44
    ;; %t72:bool = cmp_eq_i64 c, %t71
    ;; jz %t72, .if_next_55
    ;; %t73:i64 = const_i64 1
    ;; %t74:i64 = st[%t73]
    ;; %t75:i64 = const_i64 1
    ;; %t76:i64 = add_i64 %t74, %t75
    ;; %t77:i64 = const_i64 1
    ;; st[%t77] = %t76  ; i64
    ;; jmp .if_end_54
    ;; .if_next_55:
    ;; %t78:i64 = const_i64 93
    ;; %t79:bool = cmp_eq_i64 c, %t78
    ;; jz %t79, .if_elif_56
    ;; %t80:i64 = const_i64 1
    ;; %t81:i64 = st[%t80]
    ;; %t82:i64 = const_i64 1
    ;; %t83:i64 = add_i64 %t81, %t82
    ;; %t84:i64 = const_i64 1
    ;; st[%t84] = %t83  ; i64
    ;; jmp .while_end_48
    ;; jmp .if_end_54
    ;; .if_elif_56:
    ;; %t85:str = const_str 13
    ;; %t86:i64 = const_i64 3
    ;; st[%t86] = %t85  ; str
    ;; %t87:i64 = const_i64 1
    ;; %t88:i64 = neg_i64 %t87
    ;; ret %t88
    ;; .if_end_54:
    ;; jmp .if_end_53
    ;; .if_end_53:
    ;; jmp .while_cond_47
    ;; .while_end_48:
    ;; %t89:i64 = const_i64 4
    ;; %t90:Array[JsonNode] = doc[%t89]
    ;; %t91:JsonNode = %t90[arr_idx]
    ;; %t92:i64 = const_i64 7
    ;; %t91[%t92] = count  ; i64
    ;; ret arr_idx
    (i64.const 0)
  )
  (func $json_parse_obj (export "json_parse_obj") (param $st i64) (param $doc i64) (result i64)
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
    (local $obj_idx i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $prev_child i64)
    (local $t_t14 i64)
    (local $count i64)
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
    (local $key i64)
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
    (local $child_idx i64)
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
    (local $c i64)
    (local $t_t112 i64)
    (local $t_t113 i64)
    (local $t_t114 i64)
    (local $t_t115 i64)
    (local $t_t116 i64)
    (local $t_t117 i64)
    (local $t_t118 i64)
    (local $t_t119 i64)
    (local $t_t120 i64)
    (local $t_t121 i64)
    (local $t_t122 i64)
    (local $t_t123 i64)
    (local $t_t124 i64)
    (local $t_t125 i64)
    (local $t_t126 i64)
    (local $t_t127 i64)
    (local $t_t128 i64)
    (local $t_t129 i64)
    (local $t_t130 i64)
    (local $t_t131 i64)
    (local $t_t132 i64)
    (local $t_t133 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:i64 = st[%t1]
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; %t5:i64 = const_i64 1
    ;; st[%t5] = %t4  ; i64
    ;; %t6:i64 = const_i64 6
    ;; %t7:str = const_str 0
    ;; %t8:str = const_str 0
    ;; %t9:i64 = const_i64 0
    ;; %t10:f64 = const_f64 0.0
    ;; %t11:i64 = call json_alloc_node(doc, %t6, %t7, %t8, %t9, %t10)
    ;; obj_idx:i64 = mov %t11
    ;; %t12:i64 = const_i64 1
    ;; %t13:i64 = neg_i64 %t12
    ;; prev_child:i64 = mov %t13
    ;; %t14:i64 = const_i64 0
    ;; count:i64 = mov %t14
    ;; .while_cond_57:
    ;; %t15:i64 = const_i64 1
    ;; %t16:i64 = st[%t15]
    ;; %t17:i64 = const_i64 2
    ;; %t18:i64 = st[%t17]
    ;; %t19:bool = cmp_lt_i64 %t16, %t18
    ;; jz %t19, .while_end_58
    ;; %t20:i64 = call json_skip_ws(st)
    ;; %t21:i64 = const_i64 1
    ;; %t22:i64 = st[%t21]
    ;; %t23:i64 = const_i64 2
    ;; %t24:i64 = st[%t23]
    ;; %t25:bool = cmp_lt_i64 %t22, %t24
    ;; %t26:i64 = const_i64 0
    ;; %t27:str = st[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = st[%t28]
    ;; %t30:str = str_index(%t27[%t29])
    ;; %t31:i64 = str_ord %t30
    ;; %t32:i64 = const_i64 125
    ;; %t33:bool = cmp_eq_i64 %t31, %t32
    ;; %t34:bool = and_i64 %t25, %t33
    ;; jz %t34, .if_end_59
    ;; %t35:i64 = const_i64 1
    ;; %t36:i64 = st[%t35]
    ;; %t37:i64 = const_i64 1
    ;; %t38:i64 = add_i64 %t36, %t37
    ;; %t39:i64 = const_i64 1
    ;; st[%t39] = %t38  ; i64
    ;; jmp .while_end_58
    ;; jmp .if_end_59
    ;; .if_end_59:
    ;; %t40:i64 = const_i64 0
    ;; %t41:str = st[%t40]
    ;; %t42:i64 = const_i64 1
    ;; %t43:i64 = st[%t42]
    ;; %t44:str = str_index(%t41[%t43])
    ;; %t45:i64 = str_ord %t44
    ;; %t46:i64 = const_i64 34
    ;; %t47:bool = cmp_ne_i64 %t45, %t46
    ;; jz %t47, .if_end_60
    ;; %t48:str = const_str 14
    ;; %t49:i64 = const_i64 3
    ;; st[%t49] = %t48  ; str
    ;; %t50:i64 = const_i64 1
    ;; %t51:i64 = neg_i64 %t50
    ;; ret %t51
    ;; jmp .if_end_60
    ;; .if_end_60:
    ;; %t52:str = call json_parse_str(st)
    ;; key:str = mov %t52
    ;; %t53:i64 = call json_skip_ws(st)
    ;; %t54:i64 = const_i64 1
    ;; %t55:i64 = st[%t54]
    ;; %t56:i64 = const_i64 2
    ;; %t57:i64 = st[%t56]
    ;; %t58:bool = cmp_ge_i64 %t55, %t57
    ;; %t59:i64 = const_i64 0
    ;; %t60:str = st[%t59]
    ;; %t61:i64 = const_i64 1
    ;; %t62:i64 = st[%t61]
    ;; %t63:str = str_index(%t60[%t62])
    ;; %t64:i64 = str_ord %t63
    ;; %t65:i64 = const_i64 58
    ;; %t66:bool = cmp_ne_i64 %t64, %t65
    ;; %t67:bool = or_i64 %t58, %t66
    ;; jz %t67, .if_end_61
    ;; %t68:str = const_str 15
    ;; %t69:i64 = const_i64 3
    ;; st[%t69] = %t68  ; str
    ;; %t70:i64 = const_i64 1
    ;; %t71:i64 = neg_i64 %t70
    ;; ret %t71
    ;; jmp .if_end_61
    ;; .if_end_61:
    ;; %t72:i64 = const_i64 1
    ;; %t73:i64 = st[%t72]
    ;; %t74:i64 = const_i64 1
    ;; %t75:i64 = add_i64 %t73, %t74
    ;; %t76:i64 = const_i64 1
    ;; st[%t76] = %t75  ; i64
    ;; %t77:i64 = call json_parse_val(st, doc)
    ;; child_idx:i64 = mov %t77
    ;; %t78:i64 = const_i64 1
    ;; %t79:i64 = neg_i64 %t78
    ;; %t80:bool = cmp_eq_i64 child_idx, %t79
    ;; jz %t80, .if_end_62
    ;; %t81:i64 = const_i64 1
    ;; %t82:i64 = neg_i64 %t81
    ;; ret %t82
    ;; jmp .if_end_62
    ;; .if_end_62:
    ;; %t83:i64 = const_i64 4
    ;; %t84:Array[JsonNode] = doc[%t83]
    ;; %t85:JsonNode = %t84[child_idx]
    ;; %t86:i64 = const_i64 1
    ;; %t85[%t86] = key  ; str
    ;; %t87:i64 = const_i64 1
    ;; %t88:i64 = neg_i64 %t87
    ;; %t89:bool = cmp_eq_i64 prev_child, %t88
    ;; jz %t89, .if_next_64
    ;; %t90:i64 = const_i64 4
    ;; %t91:Array[JsonNode] = doc[%t90]
    ;; %t92:JsonNode = %t91[obj_idx]
    ;; %t93:i64 = const_i64 5
    ;; %t92[%t93] = child_idx  ; i64
    ;; jmp .if_end_63
    ;; .if_next_64:
    ;; %t94:i64 = const_i64 4
    ;; %t95:Array[JsonNode] = doc[%t94]
    ;; %t96:JsonNode = %t95[prev_child]
    ;; %t97:i64 = const_i64 6
    ;; %t96[%t97] = child_idx  ; i64
    ;; .if_end_63:
    ;; prev_child:i64 = mov child_idx
    ;; %t98:i64 = const_i64 1
    ;; %t99:i64 = add_i64 count, %t98
    ;; count:i64 = mov %t99
    ;; %t100:i64 = call json_skip_ws(st)
    ;; %t101:i64 = const_i64 1
    ;; %t102:i64 = st[%t101]
    ;; %t103:i64 = const_i64 2
    ;; %t104:i64 = st[%t103]
    ;; %t105:bool = cmp_lt_i64 %t102, %t104
    ;; jz %t105, .if_end_65
    ;; %t106:i64 = const_i64 0
    ;; %t107:str = st[%t106]
    ;; %t108:i64 = const_i64 1
    ;; %t109:i64 = st[%t108]
    ;; %t110:str = str_index(%t107[%t109])
    ;; %t111:i64 = str_ord %t110
    ;; c:i64 = mov %t111
    ;; %t112:i64 = const_i64 44
    ;; %t113:bool = cmp_eq_i64 c, %t112
    ;; jz %t113, .if_next_67
    ;; %t114:i64 = const_i64 1
    ;; %t115:i64 = st[%t114]
    ;; %t116:i64 = const_i64 1
    ;; %t117:i64 = add_i64 %t115, %t116
    ;; %t118:i64 = const_i64 1
    ;; st[%t118] = %t117  ; i64
    ;; jmp .if_end_66
    ;; .if_next_67:
    ;; %t119:i64 = const_i64 125
    ;; %t120:bool = cmp_eq_i64 c, %t119
    ;; jz %t120, .if_elif_68
    ;; %t121:i64 = const_i64 1
    ;; %t122:i64 = st[%t121]
    ;; %t123:i64 = const_i64 1
    ;; %t124:i64 = add_i64 %t122, %t123
    ;; %t125:i64 = const_i64 1
    ;; st[%t125] = %t124  ; i64
    ;; jmp .while_end_58
    ;; jmp .if_end_66
    ;; .if_elif_68:
    ;; %t126:str = const_str 16
    ;; %t127:i64 = const_i64 3
    ;; st[%t127] = %t126  ; str
    ;; %t128:i64 = const_i64 1
    ;; %t129:i64 = neg_i64 %t128
    ;; ret %t129
    ;; .if_end_66:
    ;; jmp .if_end_65
    ;; .if_end_65:
    ;; jmp .while_cond_57
    ;; .while_end_58:
    ;; %t130:i64 = const_i64 4
    ;; %t131:Array[JsonNode] = doc[%t130]
    ;; %t132:JsonNode = %t131[obj_idx]
    ;; %t133:i64 = const_i64 7
    ;; %t132[%t133] = count  ; i64
    ;; ret obj_idx
    (i64.const 0)
  )
  (func $json_parse (export "json_parse") (param $text i64) (param $max_nodes i64) (result i64)
    (local $t_t1 i64)
    (local $doc i64)
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
    (local $st i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:JsonDoc = call json_doc_new(max_nodes)
    ;; doc:JsonDoc = mov %t1
    ;; %t3:i64 = const_i64 4
    ;; %t4:i64 = const_i64 0
    ;; %t2:JsonParserState = alloc_array(%t3, init=%t4)
    ;; %t5:i64 = const_i64 0
    ;; %t2[%t5] = text  ; str
    ;; %t6:i64 = const_i64 0
    ;; %t7:i64 = const_i64 1
    ;; %t2[%t7] = %t6  ; i64
    ;; %t8:i64 = str_len(text)
    ;; %t9:i64 = const_i64 2
    ;; %t2[%t9] = %t8  ; i64
    ;; %t10:str = const_str 0
    ;; %t11:i64 = const_i64 3
    ;; %t2[%t11] = %t10  ; str
    ;; st:JsonParserState = mov %t2
    ;; %t12:i64 = call json_parse_val(st, doc)
    ;; %t13:i64 = const_i64 0
    ;; doc[%t13] = %t12  ; i64
    ;; %t14:i64 = const_i64 3
    ;; %t15:str = st[%t14]
    ;; %t16:i64 = const_i64 3
    ;; doc[%t16] = %t15  ; str
    ;; ret doc
    (i64.const 0)
  )
  (func $json_get (export "json_get") (param $doc i64) (param $obj_idx i64) (param $key i64) (result i64)
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
    (local $curr i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 obj_idx, %t1
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = doc[%t3]
    ;; %t5:bool = cmp_ge_i64 obj_idx, %t4
    ;; %t6:bool = or_i64 %t2, %t5
    ;; jz %t6, .if_end_69
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = neg_i64 %t7
    ;; ret %t8
    ;; jmp .if_end_69
    ;; .if_end_69:
    ;; %t9:i64 = const_i64 4
    ;; %t10:Array[JsonNode] = doc[%t9]
    ;; %t11:JsonNode = %t10[obj_idx]
    ;; %t12:i64 = const_i64 5
    ;; %t13:i64 = %t11[%t12]
    ;; curr:i64 = mov %t13
    ;; .while_cond_70:
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = neg_i64 %t14
    ;; %t16:bool = cmp_ne_i64 curr, %t15
    ;; jz %t16, .while_end_71
    ;; %t17:i64 = const_i64 4
    ;; %t18:Array[JsonNode] = doc[%t17]
    ;; %t19:JsonNode = %t18[curr]
    ;; %t20:i64 = const_i64 1
    ;; %t21:str = %t19[%t20]
    ;; %t22:bool = str_cmp_eq %t21, key
    ;; jz %t22, .if_end_72
    ;; ret curr
    ;; jmp .if_end_72
    ;; .if_end_72:
    ;; %t23:i64 = const_i64 4
    ;; %t24:Array[JsonNode] = doc[%t23]
    ;; %t25:JsonNode = %t24[curr]
    ;; %t26:i64 = const_i64 6
    ;; %t27:i64 = %t25[%t26]
    ;; curr:i64 = mov %t27
    ;; jmp .while_cond_70
    ;; .while_end_71:
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = neg_i64 %t28
    ;; ret %t29
    (i64.const 0)
  )
  (func $json_get_str (export "json_get_str") (param $doc i64) (param $obj_idx i64) (param $key i64) (param $default_val i64) (result i64)
    (local $t_t1 i64)
    (local $idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call json_get(doc, obj_idx, key)
    ;; idx:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = neg_i64 %t2
    ;; %t4:bool = cmp_ne_i64 idx, %t3
    ;; %t5:i64 = const_i64 4
    ;; %t6:Array[JsonNode] = doc[%t5]
    ;; %t7:JsonNode = %t6[idx]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; %t10:i64 = const_i64 4
    ;; %t11:bool = cmp_eq_i64 %t9, %t10
    ;; %t12:bool = and_i64 %t4, %t11
    ;; jz %t12, .if_end_73
    ;; %t13:i64 = const_i64 4
    ;; %t14:Array[JsonNode] = doc[%t13]
    ;; %t15:JsonNode = %t14[idx]
    ;; %t16:i64 = const_i64 2
    ;; %t17:str = %t15[%t16]
    ;; ret %t17
    ;; jmp .if_end_73
    ;; .if_end_73:
    ;; ret default_val
    (i64.const 0)
  )
  (func $json_get_int (export "json_get_int") (param $doc i64) (param $obj_idx i64) (param $key i64) (param $default_val i64) (result i64)
    (local $t_t1 i64)
    (local $idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call json_get(doc, obj_idx, key)
    ;; idx:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = neg_i64 %t2
    ;; %t4:bool = cmp_ne_i64 idx, %t3
    ;; %t5:i64 = const_i64 4
    ;; %t6:Array[JsonNode] = doc[%t5]
    ;; %t7:JsonNode = %t6[idx]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; %t10:i64 = const_i64 2
    ;; %t11:bool = cmp_eq_i64 %t9, %t10
    ;; %t12:bool = and_i64 %t4, %t11
    ;; jz %t12, .if_end_74
    ;; %t13:i64 = const_i64 4
    ;; %t14:Array[JsonNode] = doc[%t13]
    ;; %t15:JsonNode = %t14[idx]
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = %t15[%t16]
    ;; ret %t17
    ;; jmp .if_end_74
    ;; .if_end_74:
    ;; ret default_val
    (i64.const 0)
  )
  (func $json_get_float (export "json_get_float") (param $doc i64) (param $obj_idx i64) (param $key i64) (param $default_val f64) (result f64)
    (local $t_t1 i64)
    (local $idx i64)
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
    (local $t_t17 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call json_get(doc, obj_idx, key)
    ;; idx:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = neg_i64 %t2
    ;; %t4:bool = cmp_ne_i64 idx, %t3
    ;; %t5:i64 = const_i64 4
    ;; %t6:Array[JsonNode] = doc[%t5]
    ;; %t7:JsonNode = %t6[idx]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; %t10:i64 = const_i64 3
    ;; %t11:bool = cmp_eq_i64 %t9, %t10
    ;; %t12:bool = and_i64 %t4, %t11
    ;; jz %t12, .if_end_75
    ;; %t13:i64 = const_i64 4
    ;; %t14:Array[JsonNode] = doc[%t13]
    ;; %t15:JsonNode = %t14[idx]
    ;; %t16:i64 = const_i64 4
    ;; %t17:f64 = %t15[%t16]
    ;; ret %t17
    ;; jmp .if_end_75
    ;; .if_end_75:
    ;; ret default_val
    (f64.const 0.0)
  )
  (func $json_get_bool (export "json_get_bool") (param $doc i64) (param $obj_idx i64) (param $key i64) (param $default_val i64) (result i64)
    (local $t_t1 i64)
    (local $idx i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call json_get(doc, obj_idx, key)
    ;; idx:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = neg_i64 %t2
    ;; %t4:bool = cmp_ne_i64 idx, %t3
    ;; %t5:i64 = const_i64 4
    ;; %t6:Array[JsonNode] = doc[%t5]
    ;; %t7:JsonNode = %t6[idx]
    ;; %t8:i64 = const_i64 0
    ;; %t9:i64 = %t7[%t8]
    ;; %t10:i64 = const_i64 1
    ;; %t11:bool = cmp_eq_i64 %t9, %t10
    ;; %t12:bool = and_i64 %t4, %t11
    ;; jz %t12, .if_end_76
    ;; %t13:i64 = const_i64 4
    ;; %t14:Array[JsonNode] = doc[%t13]
    ;; %t15:JsonNode = %t14[idx]
    ;; %t16:i64 = const_i64 3
    ;; %t17:i64 = %t15[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:bool = cmp_eq_i64 %t17, %t18
    ;; ret %t19
    ;; jmp .if_end_76
    ;; .if_end_76:
    ;; ret default_val
    (i64.const 0)
  )
  (func $json_array_get (export "json_array_get") (param $doc i64) (param $arr_idx i64) (param $index i64) (result i64)
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
    (local $curr i64)
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
    (local $t_t30 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 arr_idx, %t1
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = doc[%t3]
    ;; %t5:bool = cmp_ge_i64 arr_idx, %t4
    ;; %t6:bool = or_i64 %t2, %t5
    ;; %t7:i64 = const_i64 0
    ;; %t8:bool = cmp_lt_i64 index, %t7
    ;; %t9:bool = or_i64 %t6, %t8
    ;; jz %t9, .if_end_77
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = neg_i64 %t10
    ;; ret %t11
    ;; jmp .if_end_77
    ;; .if_end_77:
    ;; %t12:i64 = const_i64 4
    ;; %t13:Array[JsonNode] = doc[%t12]
    ;; %t14:JsonNode = %t13[arr_idx]
    ;; %t15:i64 = const_i64 5
    ;; %t16:i64 = %t14[%t15]
    ;; curr:i64 = mov %t16
    ;; %t17:i64 = const_i64 0
    ;; i:i64 = mov %t17
    ;; .while_cond_78:
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = neg_i64 %t18
    ;; %t20:bool = cmp_ne_i64 curr, %t19
    ;; jz %t20, .while_end_79
    ;; %t21:bool = cmp_eq_i64 i, index
    ;; jz %t21, .if_end_80
    ;; ret curr
    ;; jmp .if_end_80
    ;; .if_end_80:
    ;; %t22:i64 = const_i64 4
    ;; %t23:Array[JsonNode] = doc[%t22]
    ;; %t24:JsonNode = %t23[curr]
    ;; %t25:i64 = const_i64 6
    ;; %t26:i64 = %t24[%t25]
    ;; curr:i64 = mov %t26
    ;; %t27:i64 = const_i64 1
    ;; %t28:i64 = add_i64 i, %t27
    ;; i:i64 = mov %t28
    ;; jmp .while_cond_78
    ;; .while_end_79:
    ;; %t29:i64 = const_i64 1
    ;; %t30:i64 = neg_i64 %t29
    ;; ret %t30
    (i64.const 0)
  )
  (func $json_array_len (export "json_array_len") (param $doc i64) (param $arr_idx i64) (result i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 arr_idx, %t1
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = doc[%t3]
    ;; %t5:bool = cmp_ge_i64 arr_idx, %t4
    ;; %t6:bool = or_i64 %t2, %t5
    ;; jz %t6, .if_end_81
    ;; %t7:i64 = const_i64 0
    ;; ret %t7
    ;; jmp .if_end_81
    ;; .if_end_81:
    ;; %t8:i64 = const_i64 4
    ;; %t9:Array[JsonNode] = doc[%t8]
    ;; %t10:JsonNode = %t9[arr_idx]
    ;; %t11:i64 = const_i64 7
    ;; %t12:i64 = %t10[%t11]
    ;; ret %t12
    (i64.const 0)
  )
  (func $json_escape_str (export "json_escape_str") (param $s i64) (result i64)
    (local $t_t1 i64)
    (local $res i64)
    (local $t_t2 i64)
    (local $length i64)
    (local $t_t3 i64)
    (local $i i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $c i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 6
    ;; res:str = mov %t1
    ;; %t2:i64 = str_len(s)
    ;; length:i64 = mov %t2
    ;; %t3:i64 = const_i64 0
    ;; i:i64 = mov %t3
    ;; .while_cond_82:
    ;; %t4:bool = cmp_lt_i64 i, length
    ;; jz %t4, .while_end_83
    ;; %t5:str = str_index(s[i])
    ;; %t6:i64 = str_ord %t5
    ;; c:i64 = mov %t6
    ;; %t7:i64 = const_i64 34
    ;; %t8:bool = cmp_eq_i64 c, %t7
    ;; jz %t8, .if_next_85
    ;; %t9:str = const_str 17
    ;; %t10:str = str_concat(res, %t9)
    ;; res:str = mov %t10
    ;; jmp .if_end_84
    ;; .if_next_85:
    ;; %t11:i64 = const_i64 92
    ;; %t12:bool = cmp_eq_i64 c, %t11
    ;; jz %t12, .if_elif_86
    ;; %t13:str = const_str 18
    ;; %t14:str = str_concat(res, %t13)
    ;; res:str = mov %t14
    ;; jmp .if_end_84
    ;; .if_elif_86:
    ;; %t15:i64 = const_i64 10
    ;; %t16:bool = cmp_eq_i64 c, %t15
    ;; jz %t16, .if_elif_87
    ;; %t17:str = const_str 19
    ;; %t18:str = str_concat(res, %t17)
    ;; res:str = mov %t18
    ;; jmp .if_end_84
    ;; .if_elif_87:
    ;; %t19:i64 = const_i64 9
    ;; %t20:bool = cmp_eq_i64 c, %t19
    ;; jz %t20, .if_elif_88
    ;; %t21:str = const_str 20
    ;; %t22:str = str_concat(res, %t21)
    ;; res:str = mov %t22
    ;; jmp .if_end_84
    ;; .if_elif_88:
    ;; %t23:i64 = const_i64 13
    ;; %t24:bool = cmp_eq_i64 c, %t23
    ;; jz %t24, .if_elif_89
    ;; %t25:str = const_str 21
    ;; %t26:str = str_concat(res, %t25)
    ;; res:str = mov %t26
    ;; jmp .if_end_84
    ;; .if_elif_89:
    ;; %t27:str = str_chr c
    ;; %t28:str = str_concat(res, %t27)
    ;; res:str = mov %t28
    ;; .if_end_84:
    ;; %t29:i64 = const_i64 1
    ;; %t30:i64 = add_i64 i, %t29
    ;; i:i64 = mov %t30
    ;; jmp .while_cond_82
    ;; .while_end_83:
    ;; %t31:str = const_str 6
    ;; %t32:str = str_concat(res, %t31)
    ;; ret %t32
    (i64.const 0)
  )
  (func $json_dumps (export "json_dumps") (param $doc i64) (param $node_idx i64) (result i64)
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
    (local $node i64)
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
    (local $t_t38 f64)
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
    (local $res i64)
    (local $t_t52 i64)
    (local $t_t53 i64)
    (local $curr i64)
    (local $t_t54 i64)
    (local $first i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $t_t62 i64)
    (local $child_str i64)
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
    (local $t_t85 i64)
    (local $t_t86 i64)
    (local $t_t87 i64)
    (local $t_t88 i64)
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $k_esc i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_lt_i64 node_idx, %t1
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = doc[%t3]
    ;; %t5:bool = cmp_ge_i64 node_idx, %t4
    ;; %t6:bool = or_i64 %t2, %t5
    ;; jz %t6, .if_end_90
    ;; %t7:str = const_str 11
    ;; ret %t7
    ;; jmp .if_end_90
    ;; .if_end_90:
    ;; %t8:i64 = const_i64 4
    ;; %t9:Array[JsonNode] = doc[%t8]
    ;; %t10:JsonNode = %t9[node_idx]
    ;; node:JsonNode = mov %t10
    ;; %t11:i64 = const_i64 0
    ;; %t12:i64 = node[%t11]
    ;; %t13:i64 = const_i64 0
    ;; %t14:bool = cmp_eq_i64 %t12, %t13
    ;; jz %t14, .if_next_92
    ;; %t15:str = const_str 11
    ;; ret %t15
    ;; jmp .if_end_91
    ;; .if_next_92:
    ;; %t16:i64 = const_i64 0
    ;; %t17:i64 = node[%t16]
    ;; %t18:i64 = const_i64 1
    ;; %t19:bool = cmp_eq_i64 %t17, %t18
    ;; jz %t19, .if_elif_93
    ;; %t20:i64 = const_i64 3
    ;; %t21:i64 = node[%t20]
    ;; %t22:i64 = const_i64 1
    ;; %t23:bool = cmp_eq_i64 %t21, %t22
    ;; jz %t23, .if_next_95
    ;; %t24:str = const_str 9
    ;; ret %t24
    ;; jmp .if_end_94
    ;; .if_next_95:
    ;; %t25:str = const_str 10
    ;; ret %t25
    ;; .if_end_94:
    ;; jmp .if_end_91
    ;; .if_elif_93:
    ;; %t26:i64 = const_i64 0
    ;; %t27:i64 = node[%t26]
    ;; %t28:i64 = const_i64 2
    ;; %t29:bool = cmp_eq_i64 %t27, %t28
    ;; jz %t29, .if_elif_96
    ;; %t30:i64 = const_i64 3
    ;; %t31:i64 = node[%t30]
    ;; %t32:str = str_from_i64 %t31
    ;; ret %t32
    ;; jmp .if_end_91
    ;; .if_elif_96:
    ;; %t33:i64 = const_i64 0
    ;; %t34:i64 = node[%t33]
    ;; %t35:i64 = const_i64 3
    ;; %t36:bool = cmp_eq_i64 %t34, %t35
    ;; jz %t36, .if_elif_97
    ;; %t37:i64 = const_i64 4
    ;; %t38:f64 = node[%t37]
    ;; %t39:str = str_from_f64 %t38
    ;; ret %t39
    ;; jmp .if_end_91
    ;; .if_elif_97:
    ;; %t40:i64 = const_i64 0
    ;; %t41:i64 = node[%t40]
    ;; %t42:i64 = const_i64 4
    ;; %t43:bool = cmp_eq_i64 %t41, %t42
    ;; jz %t43, .if_elif_98
    ;; %t44:i64 = const_i64 2
    ;; %t45:str = node[%t44]
    ;; %t46:str = call json_escape_str(%t45)
    ;; ret %t46
    ;; jmp .if_end_91
    ;; .if_elif_98:
    ;; %t47:i64 = const_i64 0
    ;; %t48:i64 = node[%t47]
    ;; %t49:i64 = const_i64 5
    ;; %t50:bool = cmp_eq_i64 %t48, %t49
    ;; jz %t50, .if_elif_99
    ;; %t51:str = const_str 22
    ;; res:str = mov %t51
    ;; %t52:i64 = const_i64 5
    ;; %t53:i64 = node[%t52]
    ;; curr:i64 = mov %t53
    ;; %t54:bool = const_i64 1
    ;; first:bool = mov %t54
    ;; .while_cond_100:
    ;; %t55:i64 = const_i64 1
    ;; %t56:i64 = neg_i64 %t55
    ;; %t57:bool = cmp_ne_i64 curr, %t56
    ;; jz %t57, .while_end_101
    ;; %t59:i64 = const_i64 0
    ;; %t58:bool = cmp_eq_i64 first, %t59
    ;; jz %t58, .if_end_102
    ;; %t60:str = const_str 23
    ;; %t61:str = str_concat(res, %t60)
    ;; res:str = mov %t61
    ;; jmp .if_end_102
    ;; .if_end_102:
    ;; %t62:str = call json_dumps(doc, curr)
    ;; child_str:str = mov %t62
    ;; %t63:str = str_concat(res, child_str)
    ;; res:str = mov %t63
    ;; %t64:bool = const_i64 0
    ;; first:bool = mov %t64
    ;; %t65:i64 = const_i64 4
    ;; %t66:Array[JsonNode] = doc[%t65]
    ;; %t67:JsonNode = %t66[curr]
    ;; %t68:i64 = const_i64 6
    ;; %t69:i64 = %t67[%t68]
    ;; curr:i64 = mov %t69
    ;; jmp .while_cond_100
    ;; .while_end_101:
    ;; %t70:str = const_str 24
    ;; %t71:str = str_concat(res, %t70)
    ;; ret %t71
    ;; jmp .if_end_91
    ;; .if_elif_99:
    ;; %t72:i64 = const_i64 0
    ;; %t73:i64 = node[%t72]
    ;; %t74:i64 = const_i64 6
    ;; %t75:bool = cmp_eq_i64 %t73, %t74
    ;; jz %t75, .if_end_91
    ;; %t76:str = const_str 25
    ;; res:str = mov %t76
    ;; %t77:i64 = const_i64 5
    ;; %t78:i64 = node[%t77]
    ;; curr:i64 = mov %t78
    ;; %t79:bool = const_i64 1
    ;; first:bool = mov %t79
    ;; .while_cond_103:
    ;; %t80:i64 = const_i64 1
    ;; %t81:i64 = neg_i64 %t80
    ;; %t82:bool = cmp_ne_i64 curr, %t81
    ;; jz %t82, .while_end_104
    ;; %t84:i64 = const_i64 0
    ;; %t83:bool = cmp_eq_i64 first, %t84
    ;; jz %t83, .if_end_105
    ;; %t85:str = const_str 23
    ;; %t86:str = str_concat(res, %t85)
    ;; res:str = mov %t86
    ;; jmp .if_end_105
    ;; .if_end_105:
    ;; %t87:i64 = const_i64 4
    ;; %t88:Array[JsonNode] = doc[%t87]
    ;; %t89:JsonNode = %t88[curr]
    ;; %t90:i64 = const_i64 1
    ;; %t91:str = %t89[%t90]
    ;; %t92:str = call json_escape_str(%t91)
    ;; k_esc:str = mov %t92
    ;; %t93:str = call json_dumps(doc, curr)
    ;; child_str:str = mov %t93
    ;; %t94:str = str_concat(res, k_esc)
    ;; %t95:str = const_str 26
    ;; %t96:str = str_concat(%t94, %t95)
    ;; %t97:str = str_concat(%t96, child_str)
    ;; res:str = mov %t97
    ;; %t98:bool = const_i64 0
    ;; first:bool = mov %t98
    ;; %t99:i64 = const_i64 4
    ;; %t100:Array[JsonNode] = doc[%t99]
    ;; %t101:JsonNode = %t100[curr]
    ;; %t102:i64 = const_i64 6
    ;; %t103:i64 = %t101[%t102]
    ;; curr:i64 = mov %t103
    ;; jmp .while_cond_103
    ;; .while_end_104:
    ;; %t104:str = const_str 27
    ;; %t105:str = str_concat(res, %t104)
    ;; ret %t105
    ;; jmp .if_end_91
    ;; .if_end_91:
    ;; %t106:str = const_str 11
    ;; ret %t106
    (i64.const 0)
  )
  (func $json_dumps_int_array (export "json_dumps_int_array") (param $arr i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $res i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $i i64)
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
    ;; %t1:str = const_str 22
    ;; res:str = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_106:
    ;; %t4:bool = cmp_lt_i64 i, count
    ;; jz %t4, .for_end_108
    ;; %t5:i64 = const_i64 0
    ;; %t6:bool = cmp_gt_i64 i, %t5
    ;; jz %t6, .if_end_109
    ;; %t7:str = const_str 23
    ;; %t8:str = str_concat(res, %t7)
    ;; res:str = mov %t8
    ;; jmp .if_end_109
    ;; .if_end_109:
    ;; %t9:i64 = arr[i]
    ;; %t10:str = str_from_i64 %t9
    ;; %t11:str = str_concat(res, %t10)
    ;; res:str = mov %t11
    ;; .for_step_107:
    ;; %t12:i64 = add_i64 i, %t3
    ;; i:i64 = mov %t12
    ;; jmp .for_cond_106
    ;; .for_end_108:
    ;; %t13:str = const_str 24
    ;; %t14:str = str_concat(res, %t13)
    ;; ret %t14
    (i64.const 0)
  )
  (func $json_dumps_float_array (export "json_dumps_float_array") (param $arr i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $res i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $i i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 22
    ;; res:str = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_110:
    ;; %t4:bool = cmp_lt_i64 i, count
    ;; jz %t4, .for_end_112
    ;; %t5:i64 = const_i64 0
    ;; %t6:bool = cmp_gt_i64 i, %t5
    ;; jz %t6, .if_end_113
    ;; %t7:str = const_str 23
    ;; %t8:str = str_concat(res, %t7)
    ;; res:str = mov %t8
    ;; jmp .if_end_113
    ;; .if_end_113:
    ;; %t9:f64 = arr[i]
    ;; %t10:str = str_from_f64 %t9
    ;; %t11:str = str_concat(res, %t10)
    ;; res:str = mov %t11
    ;; .for_step_111:
    ;; %t12:i64 = add_i64 i, %t3
    ;; i:i64 = mov %t12
    ;; jmp .for_cond_110
    ;; .for_end_112:
    ;; %t13:str = const_str 24
    ;; %t14:str = str_concat(res, %t13)
    ;; ret %t14
    (i64.const 0)
  )
  (func $json_dumps_str_array (export "json_dumps_str_array") (param $arr i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $res i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $i i64)
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
    ;; %t1:str = const_str 22
    ;; res:str = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = const_i64 1
    ;; i:i64 = mov %t2
    ;; .for_cond_114:
    ;; %t4:bool = cmp_lt_i64 i, count
    ;; jz %t4, .for_end_116
    ;; %t5:i64 = const_i64 0
    ;; %t6:bool = cmp_gt_i64 i, %t5
    ;; jz %t6, .if_end_117
    ;; %t7:str = const_str 23
    ;; %t8:str = str_concat(res, %t7)
    ;; res:str = mov %t8
    ;; jmp .if_end_117
    ;; .if_end_117:
    ;; %t9:str = arr[i]
    ;; %t10:str = call json_escape_str(%t9)
    ;; %t11:str = str_concat(res, %t10)
    ;; res:str = mov %t11
    ;; .for_step_115:
    ;; %t12:i64 = add_i64 i, %t3
    ;; i:i64 = mov %t12
    ;; jmp .for_cond_114
    ;; .for_end_116:
    ;; %t13:str = const_str 24
    ;; %t14:str = str_concat(res, %t13)
    ;; ret %t14
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $json_text i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $doc i64)
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
    (local $root i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $name i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $ver i64)
    (local $t_t28 i64)
    (local $t_t29 f64)
    (local $t_t30 f64)
    (local $perf f64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $is_open i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $targets_idx i64)
    (local $t_t42 i64)
    (local $num_targets i64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $t_t46 i64)
    (local $i i64)
    (local $t_t47 i64)
    (local $t_t48 i64)
    (local $elem_idx i64)
    (local $t_t49 i64)
    (local $t_t50 i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $t_t53 i64)
    (local $target_name i64)
    (local $t_t54 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $meta_idx i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $author i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $t_t64 i64)
    (local $license_str i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $t_t67 i64)
    (local $t_t68 i64)
    (local $t_t69 i64)
    (local $t_t70 i64)
    (local $serialized i64)
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
    (local $int_data i64)
    (local $t_t87 i64)
    (local $t_t88 i64)
    (local $t_t89 f64)
    (local $t_t90 f64)
    (local $t_t91 i64)
    (local $t_t92 f64)
    (local $t_t93 i64)
    (local $t_t94 f64)
    (local $t_t95 i64)
    (local $float_data i64)
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
    (local $t_arena_sp_main i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_main:i64 = arena_save None
    ;; %t1:str = const_str 28
    ;; print(%t1:str)
    ;; %t2:str = const_str 29
    ;; print(%t2:str)
    ;; %t3:str = const_str 28
    ;; print(%t3:str)
    ;; %t4:str = const_str 30
    ;; json_text:str = mov %t4
    ;; %t5:str = const_str 31
    ;; print(%t5:str)
    ;; print(json_text:str)
    ;; %t6:str = const_str 0
    ;; print(%t6:str)
    ;; %t7:i64 = const_i64 100
    ;; %t8:JsonDoc = call json_parse(json_text, %t7)
    ;; doc:JsonDoc = mov %t8
    ;; %t9:str = const_str 32
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = doc[%t10]
    ;; print(%t9:str, %t11:i64)
    ;; %t12:i64 = const_i64 3
    ;; %t13:str = doc[%t12]
    ;; %t14:str = const_str 0
    ;; %t15:bool = str_cmp_ne %t13, %t14
    ;; jz %t15, .if_end_118
    ;; %t16:str = const_str 33
    ;; %t17:i64 = const_i64 3
    ;; %t18:str = doc[%t17]
    ;; print(%t16:str, %t18:str)
    ;; %t19:i64 = const_i64 1
    ;; arena_restore %arena_sp_main
    ;; ret %t19
    ;; jmp .if_end_118
    ;; .if_end_118:
    ;; %t20:i64 = const_i64 0
    ;; %t21:i64 = doc[%t20]
    ;; root:i64 = mov %t21
    ;; %t22:str = const_str 34
    ;; %t23:str = const_str 35
    ;; %t24:str = call json_get_str(doc, root, %t22, %t23)
    ;; name:str = mov %t24
    ;; %t25:str = const_str 36
    ;; %t26:i64 = const_i64 0
    ;; %t27:i64 = call json_get_int(doc, root, %t25, %t26)
    ;; ver:i64 = mov %t27
    ;; %t28:str = const_str 37
    ;; %t29:f64 = const_f64 0.0
    ;; %t30:f64 = call json_get_float(doc, root, %t28, %t29)
    ;; perf:f64 = mov %t30
    ;; %t31:str = const_str 38
    ;; %t32:bool = const_i64 0
    ;; %t33:bool = call json_get_bool(doc, root, %t31, %t32)
    ;; is_open:bool = mov %t33
    ;; %t34:str = const_str 39
    ;; print(%t34:str)
    ;; %t35:str = const_str 40
    ;; print(%t35:str, name:str)
    ;; %t36:str = const_str 41
    ;; print(%t36:str, ver:i64)
    ;; %t37:str = const_str 42
    ;; %t38:str = const_str 43
    ;; print(%t37:str, perf:f64, %t38:str)
    ;; %t39:str = const_str 44
    ;; print(%t39:str, is_open:bool)
    ;; %t40:str = const_str 45
    ;; %t41:i64 = call json_get(doc, root, %t40)
    ;; targets_idx:i64 = mov %t41
    ;; %t42:i64 = call json_array_len(doc, targets_idx)
    ;; num_targets:i64 = mov %t42
    ;; %t43:str = const_str 46
    ;; %t44:str = const_str 47
    ;; print(%t43:str, num_targets:i64, %t44:str)
    ;; %t45:i64 = const_i64 0
    ;; %t46:i64 = const_i64 1
    ;; i:i64 = mov %t45
    ;; .for_cond_119:
    ;; %t47:bool = cmp_lt_i64 i, num_targets
    ;; jz %t47, .for_end_121
    ;; %t48:i64 = call json_array_get(doc, targets_idx, i)
    ;; elem_idx:i64 = mov %t48
    ;; %t49:i64 = const_i64 4
    ;; %t50:Array[JsonNode] = doc[%t49]
    ;; %t51:JsonNode = %t50[elem_idx]
    ;; %t52:i64 = const_i64 2
    ;; %t53:str = %t51[%t52]
    ;; target_name:str = mov %t53
    ;; %t54:str = const_str 48
    ;; %t55:str = const_str 49
    ;; print(%t54:str, i:i64, %t55:str, target_name:str)
    ;; .for_step_120:
    ;; %t56:i64 = add_i64 i, %t46
    ;; i:i64 = mov %t56
    ;; jmp .for_cond_119
    ;; .for_end_121:
    ;; %t57:str = const_str 50
    ;; %t58:i64 = call json_get(doc, root, %t57)
    ;; meta_idx:i64 = mov %t58
    ;; %t59:str = const_str 51
    ;; %t60:str = const_str 52
    ;; %t61:str = call json_get_str(doc, meta_idx, %t59, %t60)
    ;; author:str = mov %t61
    ;; %t62:str = const_str 53
    ;; %t63:str = const_str 52
    ;; %t64:str = call json_get_str(doc, meta_idx, %t62, %t63)
    ;; license_str:str = mov %t64
    ;; %t65:str = const_str 54
    ;; print(%t65:str)
    ;; %t66:str = const_str 55
    ;; print(%t66:str, author:str)
    ;; %t67:str = const_str 56
    ;; print(%t67:str, license_str:str)
    ;; %t68:str = const_str 0
    ;; print(%t68:str)
    ;; %t69:str = const_str 57
    ;; print(%t69:str)
    ;; %t70:str = call json_dumps(doc, root)
    ;; serialized:str = mov %t70
    ;; %t71:str = const_str 58
    ;; print(%t71:str)
    ;; print(serialized:str)
    ;; %t72:str = const_str 0
    ;; print(%t72:str)
    ;; %t73:str = const_str 59
    ;; print(%t73:str)
    ;; %t75:i64 = const_i64 5
    ;; %t76:i64 = const_i64 0
    ;; %t74:Array[i64] = alloc_array(%t75, init=%t76)
    ;; %t77:i64 = const_i64 10
    ;; %t78:i64 = const_i64 0
    ;; %t74[%t78] = %t77  ; i64
    ;; %t79:i64 = const_i64 25
    ;; %t80:i64 = const_i64 1
    ;; %t74[%t80] = %t79  ; i64
    ;; %t81:i64 = const_i64 50
    ;; %t82:i64 = const_i64 2
    ;; %t74[%t82] = %t81  ; i64
    ;; %t83:i64 = const_i64 100
    ;; %t84:i64 = const_i64 3
    ;; %t74[%t84] = %t83  ; i64
    ;; %t85:i64 = const_i64 250
    ;; %t86:i64 = const_i64 4
    ;; %t74[%t86] = %t85  ; i64
    ;; int_data:Array[i64] = mov %t74
    ;; %t88:i64 = const_i64 3
    ;; %t89:f64 = const_f64 0.0
    ;; %t87:Array[f64] = alloc_array(%t88, init=%t89)
    ;; %t90:f64 = const_f64 1.618
    ;; %t91:i64 = const_i64 0
    ;; %t87[%t91] = %t90  ; f64
    ;; %t92:f64 = const_f64 2.718
    ;; %t93:i64 = const_i64 1
    ;; %t87[%t93] = %t92  ; f64
    ;; %t94:f64 = const_f64 3.14159
    ;; %t95:i64 = const_i64 2
    ;; %t87[%t95] = %t94  ; f64
    ;; float_data:Array[f64] = mov %t87
    ;; %t96:str = const_str 60
    ;; %t97:i64 = const_i64 5
    ;; %t98:str = call json_dumps_int_array(int_data, %t97)
    ;; %t99:str = str_concat(%t96, %t98)
    ;; print(%t99:str)
    ;; %t100:str = const_str 61
    ;; %t101:i64 = const_i64 3
    ;; %t102:str = call json_dumps_float_array(float_data, %t101)
    ;; %t103:str = str_concat(%t100, %t102)
    ;; print(%t103:str)
    ;; %t104:str = const_str 0
    ;; print(%t104:str)
    ;; %t105:str = const_str 28
    ;; print(%t105:str)
    ;; %t106:str = const_str 62
    ;; print(%t106:str)
    ;; %t107:str = const_str 28
    ;; print(%t107:str)
    ;; %t108:i64 = const_i64 0
    ;; arena_restore %arena_sp_main
    ;; ret %t108
    (i64.const 0)
  )
  (func $__bmb_main__ (export "__bmb_main__")  (result i64)
    (local $t_t1 i64)
    (local $JSON_NULL i64)
    (local $t_t2 i64)
    (local $JSON_BOOL i64)
    (local $t_t3 i64)
    (local $JSON_INT i64)
    (local $t_t4 i64)
    (local $JSON_FLOAT i64)
    (local $t_t5 i64)
    (local $JSON_STR i64)
    (local $t_t6 i64)
    (local $JSON_ARR i64)
    (local $t_t7 i64)
    (local $JSON_OBJ i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; JSON_NULL:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; JSON_BOOL:i64 = mov %t2
    ;; %t3:i64 = const_i64 2
    ;; JSON_INT:i64 = mov %t3
    ;; %t4:i64 = const_i64 3
    ;; JSON_FLOAT:i64 = mov %t4
    ;; %t5:i64 = const_i64 4
    ;; JSON_STR:i64 = mov %t5
    ;; %t6:i64 = const_i64 5
    ;; JSON_ARR:i64 = mov %t6
    ;; %t7:i64 = const_i64 6
    ;; JSON_OBJ:i64 = mov %t7
    ;; %t8:i64 = call main()
    ;; %t9:i64 = const_i64 0
    ;; ret %t9
    (i64.const 0)
  )
)