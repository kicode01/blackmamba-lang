(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $hex_byte (export "hex_byte") (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $digits i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $hi i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $lo i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; digits:str = mov %t1
    ;; %t2:i64 = const_i64 4
    ;; %t3:i64 = shr_i64 val, %t2
    ;; %t4:i64 = const_i64 15
    ;; %t5:i64 = and_i64 %t3, %t4
    ;; hi:i64 = mov %t5
    ;; %t6:i64 = const_i64 15
    ;; %t7:i64 = and_i64 val, %t6
    ;; lo:i64 = mov %t7
    ;; %t8:str = str_index(digits[hi])
    ;; %t9:str = str_index(digits[lo])
    ;; %t10:str = str_concat(%t8, %t9)
    ;; ret %t10
    (i64.const 0)
  )
  (func $hex32 (export "hex32") (param $val i64) (result i64)
    (local $t_t1 i64)
    (local $digits i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $s0 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $s1 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $s2 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $s3 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $s4 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $s5 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $s6 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $s7 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $t_t46 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; digits:str = mov %t1
    ;; %t2:i64 = const_i64 28
    ;; %t3:i64 = shr_i64 val, %t2
    ;; %t4:i64 = const_i64 15
    ;; %t5:i64 = and_i64 %t3, %t4
    ;; %t6:str = str_index(digits[%t5])
    ;; s0:str = mov %t6
    ;; %t7:i64 = const_i64 24
    ;; %t8:i64 = shr_i64 val, %t7
    ;; %t9:i64 = const_i64 15
    ;; %t10:i64 = and_i64 %t8, %t9
    ;; %t11:str = str_index(digits[%t10])
    ;; s1:str = mov %t11
    ;; %t12:i64 = const_i64 20
    ;; %t13:i64 = shr_i64 val, %t12
    ;; %t14:i64 = const_i64 15
    ;; %t15:i64 = and_i64 %t13, %t14
    ;; %t16:str = str_index(digits[%t15])
    ;; s2:str = mov %t16
    ;; %t17:i64 = const_i64 16
    ;; %t18:i64 = shr_i64 val, %t17
    ;; %t19:i64 = const_i64 15
    ;; %t20:i64 = and_i64 %t18, %t19
    ;; %t21:str = str_index(digits[%t20])
    ;; s3:str = mov %t21
    ;; %t22:i64 = const_i64 12
    ;; %t23:i64 = shr_i64 val, %t22
    ;; %t24:i64 = const_i64 15
    ;; %t25:i64 = and_i64 %t23, %t24
    ;; %t26:str = str_index(digits[%t25])
    ;; s4:str = mov %t26
    ;; %t27:i64 = const_i64 8
    ;; %t28:i64 = shr_i64 val, %t27
    ;; %t29:i64 = const_i64 15
    ;; %t30:i64 = and_i64 %t28, %t29
    ;; %t31:str = str_index(digits[%t30])
    ;; s5:str = mov %t31
    ;; %t32:i64 = const_i64 4
    ;; %t33:i64 = shr_i64 val, %t32
    ;; %t34:i64 = const_i64 15
    ;; %t35:i64 = and_i64 %t33, %t34
    ;; %t36:str = str_index(digits[%t35])
    ;; s6:str = mov %t36
    ;; %t37:i64 = const_i64 15
    ;; %t38:i64 = and_i64 val, %t37
    ;; %t39:str = str_index(digits[%t38])
    ;; s7:str = mov %t39
    ;; %t40:str = str_concat(s0, s1)
    ;; %t41:str = str_concat(%t40, s2)
    ;; %t42:str = str_concat(%t41, s3)
    ;; %t43:str = str_concat(%t42, s4)
    ;; %t44:str = str_concat(%t43, s5)
    ;; %t45:str = str_concat(%t44, s6)
    ;; %t46:str = str_concat(%t45, s7)
    ;; ret %t46
    (i64.const 0)
  )
  (func $hex256 (export "hex256") (param $h i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $s0 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $s1 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $s2 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $s3 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $s4 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $s5 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $s6 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $s7 i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = h[%t1]
    ;; %t3:str = call hex32(%t2)
    ;; s0:str = mov %t3
    ;; %t4:i64 = const_i64 1
    ;; %t5:i64 = h[%t4]
    ;; %t6:str = call hex32(%t5)
    ;; s1:str = mov %t6
    ;; %t7:i64 = const_i64 2
    ;; %t8:i64 = h[%t7]
    ;; %t9:str = call hex32(%t8)
    ;; s2:str = mov %t9
    ;; %t10:i64 = const_i64 3
    ;; %t11:i64 = h[%t10]
    ;; %t12:str = call hex32(%t11)
    ;; s3:str = mov %t12
    ;; %t13:i64 = const_i64 4
    ;; %t14:i64 = h[%t13]
    ;; %t15:str = call hex32(%t14)
    ;; s4:str = mov %t15
    ;; %t16:i64 = const_i64 5
    ;; %t17:i64 = h[%t16]
    ;; %t18:str = call hex32(%t17)
    ;; s5:str = mov %t18
    ;; %t19:i64 = const_i64 6
    ;; %t20:i64 = h[%t19]
    ;; %t21:str = call hex32(%t20)
    ;; s6:str = mov %t21
    ;; %t22:i64 = const_i64 7
    ;; %t23:i64 = h[%t22]
    ;; %t24:str = call hex32(%t23)
    ;; s7:str = mov %t24
    ;; %t25:str = str_concat(s0, s1)
    ;; %t26:str = str_concat(%t25, s2)
    ;; %t27:str = str_concat(%t26, s3)
    ;; %t28:str = str_concat(%t27, s4)
    ;; %t29:str = str_concat(%t28, s5)
    ;; %t30:str = str_concat(%t29, s6)
    ;; %t31:str = str_concat(%t30, s7)
    ;; ret %t31
    (i64.const 0)
  )
  (func $rotr32 (export "rotr32") (param $x i64) (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = shr_i64 x, n
    ;; %t2:i64 = const_i64 32
    ;; %t3:i64 = sub_i64 %t2, n
    ;; %t4:i64 = shl_i64 x, %t3
    ;; %t5:i64 = const_i64 4294967295
    ;; %t6:i64 = and_i64 %t4, %t5
    ;; %t7:i64 = or_i64 %t1, %t6
    ;; %t8:i64 = const_i64 4294967295
    ;; %t9:i64 = and_i64 %t7, %t8
    ;; ret %t9
    (i64.const 0)
  )
  (func $rotl32 (export "rotl32") (param $x i64) (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = shl_i64 x, n
    ;; %t2:i64 = const_i64 4294967295
    ;; %t3:i64 = and_i64 %t1, %t2
    ;; %t4:i64 = const_i64 32
    ;; %t5:i64 = sub_i64 %t4, n
    ;; %t6:i64 = shr_i64 x, %t5
    ;; %t7:i64 = or_i64 %t3, %t6
    ;; %t8:i64 = const_i64 4294967295
    ;; %t9:i64 = and_i64 %t7, %t8
    ;; ret %t9
    (i64.const 0)
  )
  (func $fnv1a_32 (export "fnv1a_32") (param $s i64) (result i64)
    (local $t_t1 i64)
    (local $h i64)
    (local $t_t2 i64)
    (local $prime i64)
    (local $t_t3 i64)
    (local $length i64)
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
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2166136261
    ;; h:i64 = mov %t1
    ;; %t2:i64 = const_i64 16777619
    ;; prime:i64 = mov %t2
    ;; %t3:i64 = str_len(s)
    ;; length:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; i:i64 = mov %t4
    ;; .while_cond_1:
    ;; %t5:bool = cmp_lt_i64 i, length
    ;; jz %t5, .while_end_2
    ;; %t6:str = str_index(s[i])
    ;; %t7:i64 = str_ord %t6
    ;; %t8:i64 = xor_i64 h, %t7
    ;; %t9:i64 = const_i64 4294967295
    ;; %t10:i64 = and_i64 %t8, %t9
    ;; h:i64 = mov %t10
    ;; %t11:i64 = mul_i64 h, prime
    ;; %t12:i64 = const_i64 4294967295
    ;; %t13:i64 = and_i64 %t11, %t12
    ;; h:i64 = mov %t13
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = add_i64 i, %t14
    ;; i:i64 = mov %t15
    ;; jmp .while_cond_1
    ;; .while_end_2:
    ;; ret h
    (i64.const 0)
  )
  (func $fnv1a_64 (export "fnv1a_64") (param $s i64) (result i64)
    (local $t_t1 i64)
    (local $h i64)
    (local $t_t2 i64)
    (local $prime i64)
    (local $t_t3 i64)
    (local $length i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 14695981039346656037
    ;; h:i64 = mov %t1
    ;; %t2:i64 = const_i64 1099511628211
    ;; prime:i64 = mov %t2
    ;; %t3:i64 = str_len(s)
    ;; length:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; i:i64 = mov %t4
    ;; .while_cond_3:
    ;; %t5:bool = cmp_lt_i64 i, length
    ;; jz %t5, .while_end_4
    ;; %t6:str = str_index(s[i])
    ;; %t7:i64 = str_ord %t6
    ;; %t8:i64 = xor_i64 h, %t7
    ;; h:i64 = mov %t8
    ;; %t9:i64 = mul_i64 h, prime
    ;; h:i64 = mov %t9
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = add_i64 i, %t10
    ;; i:i64 = mov %t11
    ;; jmp .while_cond_3
    ;; .while_end_4:
    ;; ret h
    (i64.const 0)
  )
  (func $murmurhash3_32 (export "murmurhash3_32") (param $key i64) (param $seed i64) (result i64)
    (local $t_t1 i64)
    (local $c1 i64)
    (local $t_t2 i64)
    (local $c2 i64)
    (local $t_t3 i64)
    (local $length i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $h i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $nblocks i64)
    (local $t_t8 i64)
    (local $i i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $b0 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $b1 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $b2 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $b3 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $k i64)
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
    (local $tail i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $tail_base i64)
    (local $t_t64 i64)
    (local $kt i64)
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
    (local $t_t134 i64)
    (local $t_t135 i64)
    (local $t_t136 i64)
    (local $t_t137 i64)
    (local $t_t138 i64)
    (local $t_t139 i64)
    (local $t_t140 i64)
    (local $t_t141 i64)
    (local $t_t142 i64)
    (local $t_t143 i64)
    (local $t_t144 i64)
    (local $t_t145 i64)
    (local $t_t146 i64)
    (local $t_t147 i64)
    (local $t_t148 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 3432918353
    ;; c1:i64 = mov %t1
    ;; %t2:i64 = const_i64 461845907
    ;; c2:i64 = mov %t2
    ;; %t3:i64 = str_len(key)
    ;; length:i64 = mov %t3
    ;; %t4:i64 = const_i64 4294967295
    ;; %t5:i64 = and_i64 seed, %t4
    ;; h:i64 = mov %t5
    ;; %t6:i64 = const_i64 4
    ;; %t7:i64 = div_i64 length, %t6
    ;; nblocks:i64 = mov %t7
    ;; %t8:i64 = const_i64 0
    ;; i:i64 = mov %t8
    ;; .while_cond_5:
    ;; %t9:bool = cmp_lt_i64 i, nblocks
    ;; jz %t9, .while_end_6
    ;; %t10:i64 = const_i64 4
    ;; %t11:i64 = mul_i64 i, %t10
    ;; %t12:str = str_index(key[%t11])
    ;; %t13:i64 = str_ord %t12
    ;; b0:i64 = mov %t13
    ;; %t14:i64 = const_i64 4
    ;; %t15:i64 = mul_i64 i, %t14
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = add_i64 %t15, %t16
    ;; %t18:str = str_index(key[%t17])
    ;; %t19:i64 = str_ord %t18
    ;; b1:i64 = mov %t19
    ;; %t20:i64 = const_i64 4
    ;; %t21:i64 = mul_i64 i, %t20
    ;; %t22:i64 = const_i64 2
    ;; %t23:i64 = add_i64 %t21, %t22
    ;; %t24:str = str_index(key[%t23])
    ;; %t25:i64 = str_ord %t24
    ;; b2:i64 = mov %t25
    ;; %t26:i64 = const_i64 4
    ;; %t27:i64 = mul_i64 i, %t26
    ;; %t28:i64 = const_i64 3
    ;; %t29:i64 = add_i64 %t27, %t28
    ;; %t30:str = str_index(key[%t29])
    ;; %t31:i64 = str_ord %t30
    ;; b3:i64 = mov %t31
    ;; %t32:i64 = const_i64 8
    ;; %t33:i64 = shl_i64 b1, %t32
    ;; %t34:i64 = or_i64 b0, %t33
    ;; %t35:i64 = const_i64 16
    ;; %t36:i64 = shl_i64 b2, %t35
    ;; %t37:i64 = or_i64 %t34, %t36
    ;; %t38:i64 = const_i64 24
    ;; %t39:i64 = shl_i64 b3, %t38
    ;; %t40:i64 = or_i64 %t37, %t39
    ;; k:i64 = mov %t40
    ;; %t41:i64 = mul_i64 k, c1
    ;; %t42:i64 = const_i64 4294967295
    ;; %t43:i64 = and_i64 %t41, %t42
    ;; k:i64 = mov %t43
    ;; %t44:i64 = const_i64 15
    ;; %t45:i64 = call rotl32(k, %t44)
    ;; k:i64 = mov %t45
    ;; %t46:i64 = mul_i64 k, c2
    ;; %t47:i64 = const_i64 4294967295
    ;; %t48:i64 = and_i64 %t46, %t47
    ;; k:i64 = mov %t48
    ;; %t49:i64 = xor_i64 h, k
    ;; h:i64 = mov %t49
    ;; %t50:i64 = const_i64 13
    ;; %t51:i64 = call rotl32(h, %t50)
    ;; h:i64 = mov %t51
    ;; %t52:i64 = const_i64 5
    ;; %t53:i64 = mul_i64 h, %t52
    ;; %t54:i64 = const_i64 3864292196
    ;; %t55:i64 = add_i64 %t53, %t54
    ;; %t56:i64 = const_i64 4294967295
    ;; %t57:i64 = and_i64 %t55, %t56
    ;; h:i64 = mov %t57
    ;; %t58:i64 = const_i64 1
    ;; %t59:i64 = add_i64 i, %t58
    ;; i:i64 = mov %t59
    ;; jmp .while_cond_5
    ;; .while_end_6:
    ;; %t60:i64 = const_i64 4
    ;; %t61:i64 = mod_i64 length, %t60
    ;; tail:i64 = mov %t61
    ;; %t62:i64 = const_i64 4
    ;; %t63:i64 = mul_i64 nblocks, %t62
    ;; tail_base:i64 = mov %t63
    ;; %t64:i64 = const_i64 0
    ;; kt:i64 = mov %t64
    ;; %t65:i64 = const_i64 3
    ;; %t66:bool = cmp_eq_i64 tail, %t65
    ;; jz %t66, .if_next_8
    ;; %t67:str = str_index(key[tail_base])
    ;; %t68:i64 = str_ord %t67
    ;; %t69:i64 = const_i64 1
    ;; %t70:i64 = add_i64 tail_base, %t69
    ;; %t71:str = str_index(key[%t70])
    ;; %t72:i64 = str_ord %t71
    ;; %t73:i64 = const_i64 8
    ;; %t74:i64 = shl_i64 %t72, %t73
    ;; %t75:i64 = or_i64 %t68, %t74
    ;; %t76:i64 = const_i64 2
    ;; %t77:i64 = add_i64 tail_base, %t76
    ;; %t78:str = str_index(key[%t77])
    ;; %t79:i64 = str_ord %t78
    ;; %t80:i64 = const_i64 16
    ;; %t81:i64 = shl_i64 %t79, %t80
    ;; %t82:i64 = or_i64 %t75, %t81
    ;; kt:i64 = mov %t82
    ;; %t83:i64 = mul_i64 kt, c1
    ;; %t84:i64 = const_i64 4294967295
    ;; %t85:i64 = and_i64 %t83, %t84
    ;; kt:i64 = mov %t85
    ;; %t86:i64 = const_i64 15
    ;; %t87:i64 = call rotl32(kt, %t86)
    ;; kt:i64 = mov %t87
    ;; %t88:i64 = mul_i64 kt, c2
    ;; %t89:i64 = const_i64 4294967295
    ;; %t90:i64 = and_i64 %t88, %t89
    ;; kt:i64 = mov %t90
    ;; %t91:i64 = xor_i64 h, kt
    ;; h:i64 = mov %t91
    ;; jmp .if_end_7
    ;; .if_next_8:
    ;; %t92:i64 = const_i64 2
    ;; %t93:bool = cmp_eq_i64 tail, %t92
    ;; jz %t93, .if_elif_9
    ;; %t94:str = str_index(key[tail_base])
    ;; %t95:i64 = str_ord %t94
    ;; %t96:i64 = const_i64 1
    ;; %t97:i64 = add_i64 tail_base, %t96
    ;; %t98:str = str_index(key[%t97])
    ;; %t99:i64 = str_ord %t98
    ;; %t100:i64 = const_i64 8
    ;; %t101:i64 = shl_i64 %t99, %t100
    ;; %t102:i64 = or_i64 %t95, %t101
    ;; kt:i64 = mov %t102
    ;; %t103:i64 = mul_i64 kt, c1
    ;; %t104:i64 = const_i64 4294967295
    ;; %t105:i64 = and_i64 %t103, %t104
    ;; kt:i64 = mov %t105
    ;; %t106:i64 = const_i64 15
    ;; %t107:i64 = call rotl32(kt, %t106)
    ;; kt:i64 = mov %t107
    ;; %t108:i64 = mul_i64 kt, c2
    ;; %t109:i64 = const_i64 4294967295
    ;; %t110:i64 = and_i64 %t108, %t109
    ;; kt:i64 = mov %t110
    ;; %t111:i64 = xor_i64 h, kt
    ;; h:i64 = mov %t111
    ;; jmp .if_end_7
    ;; .if_elif_9:
    ;; %t112:i64 = const_i64 1
    ;; %t113:bool = cmp_eq_i64 tail, %t112
    ;; jz %t113, .if_end_7
    ;; %t114:str = str_index(key[tail_base])
    ;; %t115:i64 = str_ord %t114
    ;; kt:i64 = mov %t115
    ;; %t116:i64 = mul_i64 kt, c1
    ;; %t117:i64 = const_i64 4294967295
    ;; %t118:i64 = and_i64 %t116, %t117
    ;; kt:i64 = mov %t118
    ;; %t119:i64 = const_i64 15
    ;; %t120:i64 = call rotl32(kt, %t119)
    ;; kt:i64 = mov %t120
    ;; %t121:i64 = mul_i64 kt, c2
    ;; %t122:i64 = const_i64 4294967295
    ;; %t123:i64 = and_i64 %t121, %t122
    ;; kt:i64 = mov %t123
    ;; %t124:i64 = xor_i64 h, kt
    ;; h:i64 = mov %t124
    ;; jmp .if_end_7
    ;; .if_end_7:
    ;; %t125:i64 = xor_i64 h, length
    ;; h:i64 = mov %t125
    ;; %t126:i64 = const_i64 16
    ;; %t127:i64 = shr_i64 h, %t126
    ;; %t128:i64 = xor_i64 h, %t127
    ;; %t129:i64 = const_i64 4294967295
    ;; %t130:i64 = and_i64 %t128, %t129
    ;; h:i64 = mov %t130
    ;; %t131:i64 = const_i64 2246822507
    ;; %t132:i64 = mul_i64 h, %t131
    ;; %t133:i64 = const_i64 4294967295
    ;; %t134:i64 = and_i64 %t132, %t133
    ;; h:i64 = mov %t134
    ;; %t135:i64 = const_i64 13
    ;; %t136:i64 = shr_i64 h, %t135
    ;; %t137:i64 = xor_i64 h, %t136
    ;; %t138:i64 = const_i64 4294967295
    ;; %t139:i64 = and_i64 %t137, %t138
    ;; h:i64 = mov %t139
    ;; %t140:i64 = const_i64 3266489909
    ;; %t141:i64 = mul_i64 h, %t140
    ;; %t142:i64 = const_i64 4294967295
    ;; %t143:i64 = and_i64 %t141, %t142
    ;; h:i64 = mov %t143
    ;; %t144:i64 = const_i64 16
    ;; %t145:i64 = shr_i64 h, %t144
    ;; %t146:i64 = xor_i64 h, %t145
    ;; %t147:i64 = const_i64 4294967295
    ;; %t148:i64 = and_i64 %t146, %t147
    ;; h:i64 = mov %t148
    ;; ret h
    (i64.const 0)
  )
  (func $murmurhash3 (export "murmurhash3") (param $key i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = call murmurhash3_32(key, %t1)
    ;; ret %t2
    (i64.const 0)
  )
  (func $sha256_k (export "sha256_k")  (result i64)
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
    (local $k i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t2:i64 = const_i64 64
    ;; %t3:i64 = const_i64 0
    ;; %t1:Array[i64] = alloc_array(%t2, init=%t3)
    ;; %t4:i64 = const_i64 1116352408
    ;; %t5:i64 = const_i64 0
    ;; %t1[%t5] = %t4  ; i64
    ;; %t6:i64 = const_i64 1899447441
    ;; %t7:i64 = const_i64 1
    ;; %t1[%t7] = %t6  ; i64
    ;; %t8:i64 = const_i64 3049323471
    ;; %t9:i64 = const_i64 2
    ;; %t1[%t9] = %t8  ; i64
    ;; %t10:i64 = const_i64 3921009573
    ;; %t11:i64 = const_i64 3
    ;; %t1[%t11] = %t10  ; i64
    ;; %t12:i64 = const_i64 961987163
    ;; %t13:i64 = const_i64 4
    ;; %t1[%t13] = %t12  ; i64
    ;; %t14:i64 = const_i64 1508970993
    ;; %t15:i64 = const_i64 5
    ;; %t1[%t15] = %t14  ; i64
    ;; %t16:i64 = const_i64 2453635748
    ;; %t17:i64 = const_i64 6
    ;; %t1[%t17] = %t16  ; i64
    ;; %t18:i64 = const_i64 2870763221
    ;; %t19:i64 = const_i64 7
    ;; %t1[%t19] = %t18  ; i64
    ;; %t20:i64 = const_i64 3624381080
    ;; %t21:i64 = const_i64 8
    ;; %t1[%t21] = %t20  ; i64
    ;; %t22:i64 = const_i64 310598401
    ;; %t23:i64 = const_i64 9
    ;; %t1[%t23] = %t22  ; i64
    ;; %t24:i64 = const_i64 607225278
    ;; %t25:i64 = const_i64 10
    ;; %t1[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 1426881987
    ;; %t27:i64 = const_i64 11
    ;; %t1[%t27] = %t26  ; i64
    ;; %t28:i64 = const_i64 1925078388
    ;; %t29:i64 = const_i64 12
    ;; %t1[%t29] = %t28  ; i64
    ;; %t30:i64 = const_i64 2162078206
    ;; %t31:i64 = const_i64 13
    ;; %t1[%t31] = %t30  ; i64
    ;; %t32:i64 = const_i64 2614888103
    ;; %t33:i64 = const_i64 14
    ;; %t1[%t33] = %t32  ; i64
    ;; %t34:i64 = const_i64 3248222580
    ;; %t35:i64 = const_i64 15
    ;; %t1[%t35] = %t34  ; i64
    ;; %t36:i64 = const_i64 3835390401
    ;; %t37:i64 = const_i64 16
    ;; %t1[%t37] = %t36  ; i64
    ;; %t38:i64 = const_i64 4022224774
    ;; %t39:i64 = const_i64 17
    ;; %t1[%t39] = %t38  ; i64
    ;; %t40:i64 = const_i64 264347078
    ;; %t41:i64 = const_i64 18
    ;; %t1[%t41] = %t40  ; i64
    ;; %t42:i64 = const_i64 604807628
    ;; %t43:i64 = const_i64 19
    ;; %t1[%t43] = %t42  ; i64
    ;; %t44:i64 = const_i64 770255983
    ;; %t45:i64 = const_i64 20
    ;; %t1[%t45] = %t44  ; i64
    ;; %t46:i64 = const_i64 1249150122
    ;; %t47:i64 = const_i64 21
    ;; %t1[%t47] = %t46  ; i64
    ;; %t48:i64 = const_i64 1555081692
    ;; %t49:i64 = const_i64 22
    ;; %t1[%t49] = %t48  ; i64
    ;; %t50:i64 = const_i64 1996064986
    ;; %t51:i64 = const_i64 23
    ;; %t1[%t51] = %t50  ; i64
    ;; %t52:i64 = const_i64 2554220882
    ;; %t53:i64 = const_i64 24
    ;; %t1[%t53] = %t52  ; i64
    ;; %t54:i64 = const_i64 2821834349
    ;; %t55:i64 = const_i64 25
    ;; %t1[%t55] = %t54  ; i64
    ;; %t56:i64 = const_i64 2952996808
    ;; %t57:i64 = const_i64 26
    ;; %t1[%t57] = %t56  ; i64
    ;; %t58:i64 = const_i64 3210313671
    ;; %t59:i64 = const_i64 27
    ;; %t1[%t59] = %t58  ; i64
    ;; %t60:i64 = const_i64 3336571891
    ;; %t61:i64 = const_i64 28
    ;; %t1[%t61] = %t60  ; i64
    ;; %t62:i64 = const_i64 3584528711
    ;; %t63:i64 = const_i64 29
    ;; %t1[%t63] = %t62  ; i64
    ;; %t64:i64 = const_i64 113926993
    ;; %t65:i64 = const_i64 30
    ;; %t1[%t65] = %t64  ; i64
    ;; %t66:i64 = const_i64 338241895
    ;; %t67:i64 = const_i64 31
    ;; %t1[%t67] = %t66  ; i64
    ;; %t68:i64 = const_i64 666307205
    ;; %t69:i64 = const_i64 32
    ;; %t1[%t69] = %t68  ; i64
    ;; %t70:i64 = const_i64 773529912
    ;; %t71:i64 = const_i64 33
    ;; %t1[%t71] = %t70  ; i64
    ;; %t72:i64 = const_i64 1294757372
    ;; %t73:i64 = const_i64 34
    ;; %t1[%t73] = %t72  ; i64
    ;; %t74:i64 = const_i64 1396182291
    ;; %t75:i64 = const_i64 35
    ;; %t1[%t75] = %t74  ; i64
    ;; %t76:i64 = const_i64 1695183700
    ;; %t77:i64 = const_i64 36
    ;; %t1[%t77] = %t76  ; i64
    ;; %t78:i64 = const_i64 1986661051
    ;; %t79:i64 = const_i64 37
    ;; %t1[%t79] = %t78  ; i64
    ;; %t80:i64 = const_i64 2177026350
    ;; %t81:i64 = const_i64 38
    ;; %t1[%t81] = %t80  ; i64
    ;; %t82:i64 = const_i64 2456956037
    ;; %t83:i64 = const_i64 39
    ;; %t1[%t83] = %t82  ; i64
    ;; %t84:i64 = const_i64 2730485921
    ;; %t85:i64 = const_i64 40
    ;; %t1[%t85] = %t84  ; i64
    ;; %t86:i64 = const_i64 2820302411
    ;; %t87:i64 = const_i64 41
    ;; %t1[%t87] = %t86  ; i64
    ;; %t88:i64 = const_i64 3259730800
    ;; %t89:i64 = const_i64 42
    ;; %t1[%t89] = %t88  ; i64
    ;; %t90:i64 = const_i64 3345764771
    ;; %t91:i64 = const_i64 43
    ;; %t1[%t91] = %t90  ; i64
    ;; %t92:i64 = const_i64 3516065817
    ;; %t93:i64 = const_i64 44
    ;; %t1[%t93] = %t92  ; i64
    ;; %t94:i64 = const_i64 3600352804
    ;; %t95:i64 = const_i64 45
    ;; %t1[%t95] = %t94  ; i64
    ;; %t96:i64 = const_i64 4094571909
    ;; %t97:i64 = const_i64 46
    ;; %t1[%t97] = %t96  ; i64
    ;; %t98:i64 = const_i64 275423344
    ;; %t99:i64 = const_i64 47
    ;; %t1[%t99] = %t98  ; i64
    ;; %t100:i64 = const_i64 430227734
    ;; %t101:i64 = const_i64 48
    ;; %t1[%t101] = %t100  ; i64
    ;; %t102:i64 = const_i64 506948616
    ;; %t103:i64 = const_i64 49
    ;; %t1[%t103] = %t102  ; i64
    ;; %t104:i64 = const_i64 659060556
    ;; %t105:i64 = const_i64 50
    ;; %t1[%t105] = %t104  ; i64
    ;; %t106:i64 = const_i64 883997877
    ;; %t107:i64 = const_i64 51
    ;; %t1[%t107] = %t106  ; i64
    ;; %t108:i64 = const_i64 958139571
    ;; %t109:i64 = const_i64 52
    ;; %t1[%t109] = %t108  ; i64
    ;; %t110:i64 = const_i64 1322822218
    ;; %t111:i64 = const_i64 53
    ;; %t1[%t111] = %t110  ; i64
    ;; %t112:i64 = const_i64 1537002063
    ;; %t113:i64 = const_i64 54
    ;; %t1[%t113] = %t112  ; i64
    ;; %t114:i64 = const_i64 1747873779
    ;; %t115:i64 = const_i64 55
    ;; %t1[%t115] = %t114  ; i64
    ;; %t116:i64 = const_i64 1955562222
    ;; %t117:i64 = const_i64 56
    ;; %t1[%t117] = %t116  ; i64
    ;; %t118:i64 = const_i64 2024104815
    ;; %t119:i64 = const_i64 57
    ;; %t1[%t119] = %t118  ; i64
    ;; %t120:i64 = const_i64 2227730452
    ;; %t121:i64 = const_i64 58
    ;; %t1[%t121] = %t120  ; i64
    ;; %t122:i64 = const_i64 2361852424
    ;; %t123:i64 = const_i64 59
    ;; %t1[%t123] = %t122  ; i64
    ;; %t124:i64 = const_i64 2428436474
    ;; %t125:i64 = const_i64 60
    ;; %t1[%t125] = %t124  ; i64
    ;; %t126:i64 = const_i64 2756734187
    ;; %t127:i64 = const_i64 61
    ;; %t1[%t127] = %t126  ; i64
    ;; %t128:i64 = const_i64 3204031479
    ;; %t129:i64 = const_i64 62
    ;; %t1[%t129] = %t128  ; i64
    ;; %t130:i64 = const_i64 3329325298
    ;; %t131:i64 = const_i64 63
    ;; %t1[%t131] = %t130  ; i64
    ;; k:Array[i64] = mov %t1
    ;; ret k
    (i64.const 0)
  )
  (func $sha256_buffer (export "sha256_buffer") (param $buf_in i64) (param $msg_len i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $bit_len i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $k_blocks i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $total_bytes i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $buf i64)
    (local $t_t13 i64)
    (local $i i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $j i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $t_t25 i64)
    (local $shift i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $K i64)
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
    (local $H i64)
    (local $t_t54 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $W i64)
    (local $t_t57 i64)
    (local $chunk i64)
    (local $t_t58 i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $base i64)
    (local $t_t61 i64)
    (local $t i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $t_t64 i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $t_t67 i64)
    (local $b0 i64)
    (local $t_t68 i64)
    (local $t_t69 i64)
    (local $t_t70 i64)
    (local $t_t71 i64)
    (local $t_t72 i64)
    (local $t_t73 i64)
    (local $b1 i64)
    (local $t_t74 i64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $t_t77 i64)
    (local $t_t78 i64)
    (local $t_t79 i64)
    (local $b2 i64)
    (local $t_t80 i64)
    (local $t_t81 i64)
    (local $t_t82 i64)
    (local $t_t83 i64)
    (local $t_t84 i64)
    (local $t_t85 i64)
    (local $b3 i64)
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
    (local $t2 i64)
    (local $t_t100 i64)
    (local $t_t101 i64)
    (local $t_t102 i64)
    (local $t_t103 i64)
    (local $t_t104 i64)
    (local $x i64)
    (local $t_t105 i64)
    (local $t_t106 i64)
    (local $t_t107 i64)
    (local $t_t108 i64)
    (local $t_t109 i64)
    (local $t_t110 i64)
    (local $t_t111 i64)
    (local $t_t112 i64)
    (local $s0 i64)
    (local $t_t113 i64)
    (local $t_t114 i64)
    (local $t_t115 i64)
    (local $y i64)
    (local $t_t116 i64)
    (local $t_t117 i64)
    (local $t_t118 i64)
    (local $t_t119 i64)
    (local $t_t120 i64)
    (local $t_t121 i64)
    (local $t_t122 i64)
    (local $t_t123 i64)
    (local $s1 i64)
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
    (local $t_t134 i64)
    (local $t_t135 i64)
    (local $t_t136 i64)
    (local $t_t137 i64)
    (local $t_t138 i64)
    (local $a i64)
    (local $t_t139 i64)
    (local $t_t140 i64)
    (local $b i64)
    (local $t_t141 i64)
    (local $t_t142 i64)
    (local $c i64)
    (local $t_t143 i64)
    (local $t_t144 i64)
    (local $d i64)
    (local $t_t145 i64)
    (local $t_t146 i64)
    (local $e i64)
    (local $t_t147 i64)
    (local $t_t148 i64)
    (local $f i64)
    (local $t_t149 i64)
    (local $t_t150 i64)
    (local $g i64)
    (local $t_t151 i64)
    (local $t_t152 i64)
    (local $h i64)
    (local $t_t153 i64)
    (local $t3 i64)
    (local $t_t154 i64)
    (local $t_t155 i64)
    (local $t_t156 i64)
    (local $t_t157 i64)
    (local $t_t158 i64)
    (local $t_t159 i64)
    (local $t_t160 i64)
    (local $t_t161 i64)
    (local $t_t162 i64)
    (local $t_t163 i64)
    (local $S1 i64)
    (local $t_t164 i64)
    (local $t_t165 i64)
    (local $t_t166 i64)
    (local $t_t167 i64)
    (local $ch i64)
    (local $t_t168 i64)
    (local $t_t169 i64)
    (local $t_t170 i64)
    (local $t_t171 i64)
    (local $t_t172 i64)
    (local $t_t173 i64)
    (local $t_t174 i64)
    (local $t_t175 i64)
    (local $T1 i64)
    (local $t_t176 i64)
    (local $t_t177 i64)
    (local $t_t178 i64)
    (local $t_t179 i64)
    (local $t_t180 i64)
    (local $t_t181 i64)
    (local $t_t182 i64)
    (local $t_t183 i64)
    (local $S0 i64)
    (local $t_t184 i64)
    (local $t_t185 i64)
    (local $t_t186 i64)
    (local $t_t187 i64)
    (local $t_t188 i64)
    (local $maj i64)
    (local $t_t189 i64)
    (local $t_t190 i64)
    (local $t_t191 i64)
    (local $T2 i64)
    (local $t_t192 i64)
    (local $t_t193 i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 8
    ;; %t2:i64 = mul_i64 msg_len, %t1
    ;; bit_len:i64 = mov %t2
    ;; %t3:i64 = const_i64 9
    ;; %t4:i64 = add_i64 msg_len, %t3
    ;; %t5:i64 = const_i64 63
    ;; %t6:i64 = add_i64 %t4, %t5
    ;; %t7:i64 = const_i64 64
    ;; %t8:i64 = div_i64 %t6, %t7
    ;; k_blocks:i64 = mov %t8
    ;; %t9:i64 = const_i64 64
    ;; %t10:i64 = mul_i64 k_blocks, %t9
    ;; total_bytes:i64 = mov %t10
    ;; %t12:i64 = const_i64 0
    ;; %t11:Array[i64] = alloc_array(total_bytes, init=%t12)
    ;; buf:Array[i64] = mov %t11
    ;; %t13:i64 = const_i64 0
    ;; i:i64 = mov %t13
    ;; .while_cond_10:
    ;; %t14:bool = cmp_lt_i64 i, msg_len
    ;; jz %t14, .while_end_11
    ;; %t15:i64 = buf_in[i]
    ;; %t16:i64 = const_i64 255
    ;; %t17:i64 = and_i64 %t15, %t16
    ;; buf[i] = %t17  ; i64
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = add_i64 i, %t18
    ;; i:i64 = mov %t19
    ;; jmp .while_cond_10
    ;; .while_end_11:
    ;; %t20:i64 = const_i64 128
    ;; buf[msg_len] = %t20  ; i64
    ;; %t21:i64 = const_i64 0
    ;; j:i64 = mov %t21
    ;; .while_cond_12:
    ;; %t22:i64 = const_i64 8
    ;; %t23:bool = cmp_lt_i64 j, %t22
    ;; jz %t23, .while_end_13
    ;; %t24:i64 = const_i64 8
    ;; %t25:i64 = mul_i64 j, %t24
    ;; shift:i64 = mov %t25
    ;; %t26:i64 = const_i64 1
    ;; %t27:i64 = sub_i64 total_bytes, %t26
    ;; %t28:i64 = sub_i64 %t27, j
    ;; %t29:i64 = shr_i64 bit_len, shift
    ;; %t30:i64 = const_i64 255
    ;; %t31:i64 = and_i64 %t29, %t30
    ;; buf[%t28] = %t31  ; i64
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = add_i64 j, %t32
    ;; j:i64 = mov %t33
    ;; jmp .while_cond_12
    ;; .while_end_13:
    ;; %t34:Array[i64] = call sha256_k()
    ;; K:Array[i64] = mov %t34
    ;; %t36:i64 = const_i64 8
    ;; %t37:i64 = const_i64 0
    ;; %t35:Array[i64] = alloc_array(%t36, init=%t37)
    ;; %t38:i64 = const_i64 1779033703
    ;; %t39:i64 = const_i64 0
    ;; %t35[%t39] = %t38  ; i64
    ;; %t40:i64 = const_i64 3144134277
    ;; %t41:i64 = const_i64 1
    ;; %t35[%t41] = %t40  ; i64
    ;; %t42:i64 = const_i64 1013904242
    ;; %t43:i64 = const_i64 2
    ;; %t35[%t43] = %t42  ; i64
    ;; %t44:i64 = const_i64 2773480762
    ;; %t45:i64 = const_i64 3
    ;; %t35[%t45] = %t44  ; i64
    ;; %t46:i64 = const_i64 1359893119
    ;; %t47:i64 = const_i64 4
    ;; %t35[%t47] = %t46  ; i64
    ;; %t48:i64 = const_i64 2600822924
    ;; %t49:i64 = const_i64 5
    ;; %t35[%t49] = %t48  ; i64
    ;; %t50:i64 = const_i64 528734635
    ;; %t51:i64 = const_i64 6
    ;; %t35[%t51] = %t50  ; i64
    ;; %t52:i64 = const_i64 1541459225
    ;; %t53:i64 = const_i64 7
    ;; %t35[%t53] = %t52  ; i64
    ;; H:Array[i64] = mov %t35
    ;; %t55:i64 = const_i64 64
    ;; %t56:i64 = const_i64 0
    ;; %t54:Array[i64] = alloc_array(%t55, init=%t56)
    ;; W:Array[i64] = mov %t54
    ;; %t57:i64 = const_i64 0
    ;; chunk:i64 = mov %t57
    ;; .while_cond_14:
    ;; %t58:bool = cmp_lt_i64 chunk, k_blocks
    ;; jz %t58, .while_end_15
    ;; %t59:i64 = const_i64 64
    ;; %t60:i64 = mul_i64 chunk, %t59
    ;; base:i64 = mov %t60
    ;; %t61:i64 = const_i64 0
    ;; t:i64 = mov %t61
    ;; .while_cond_16:
    ;; %t62:i64 = const_i64 16
    ;; %t63:bool = cmp_lt_i64 t, %t62
    ;; jz %t63, .while_end_17
    ;; %t64:i64 = const_i64 4
    ;; %t65:i64 = mul_i64 t, %t64
    ;; %t66:i64 = add_i64 base, %t65
    ;; %t67:i64 = buf[%t66]
    ;; b0:i64 = mov %t67
    ;; %t68:i64 = const_i64 4
    ;; %t69:i64 = mul_i64 t, %t68
    ;; %t70:i64 = add_i64 base, %t69
    ;; %t71:i64 = const_i64 1
    ;; %t72:i64 = add_i64 %t70, %t71
    ;; %t73:i64 = buf[%t72]
    ;; b1:i64 = mov %t73
    ;; %t74:i64 = const_i64 4
    ;; %t75:i64 = mul_i64 t, %t74
    ;; %t76:i64 = add_i64 base, %t75
    ;; %t77:i64 = const_i64 2
    ;; %t78:i64 = add_i64 %t76, %t77
    ;; %t79:i64 = buf[%t78]
    ;; b2:i64 = mov %t79
    ;; %t80:i64 = const_i64 4
    ;; %t81:i64 = mul_i64 t, %t80
    ;; %t82:i64 = add_i64 base, %t81
    ;; %t83:i64 = const_i64 3
    ;; %t84:i64 = add_i64 %t82, %t83
    ;; %t85:i64 = buf[%t84]
    ;; b3:i64 = mov %t85
    ;; %t86:i64 = const_i64 24
    ;; %t87:i64 = shl_i64 b0, %t86
    ;; %t88:i64 = const_i64 16
    ;; %t89:i64 = shl_i64 b1, %t88
    ;; %t90:i64 = or_i64 %t87, %t89
    ;; %t91:i64 = const_i64 8
    ;; %t92:i64 = shl_i64 b2, %t91
    ;; %t93:i64 = or_i64 %t90, %t92
    ;; %t94:i64 = or_i64 %t93, b3
    ;; %t95:i64 = const_i64 4294967295
    ;; %t96:i64 = and_i64 %t94, %t95
    ;; W[t] = %t96  ; i64
    ;; %t97:i64 = const_i64 1
    ;; %t98:i64 = add_i64 t, %t97
    ;; t:i64 = mov %t98
    ;; jmp .while_cond_16
    ;; .while_end_17:
    ;; %t99:i64 = const_i64 16
    ;; t2:i64 = mov %t99
    ;; .while_cond_18:
    ;; %t100:i64 = const_i64 64
    ;; %t101:bool = cmp_lt_i64 t2, %t100
    ;; jz %t101, .while_end_19
    ;; %t102:i64 = const_i64 15
    ;; %t103:i64 = sub_i64 t2, %t102
    ;; %t104:i64 = W[%t103]
    ;; x:i64 = mov %t104
    ;; %t105:i64 = const_i64 7
    ;; %t106:i64 = call rotr32(x, %t105)
    ;; %t107:i64 = const_i64 18
    ;; %t108:i64 = call rotr32(x, %t107)
    ;; %t109:i64 = xor_i64 %t106, %t108
    ;; %t110:i64 = const_i64 3
    ;; %t111:i64 = shr_i64 x, %t110
    ;; %t112:i64 = xor_i64 %t109, %t111
    ;; s0:i64 = mov %t112
    ;; %t113:i64 = const_i64 2
    ;; %t114:i64 = sub_i64 t2, %t113
    ;; %t115:i64 = W[%t114]
    ;; y:i64 = mov %t115
    ;; %t116:i64 = const_i64 17
    ;; %t117:i64 = call rotr32(y, %t116)
    ;; %t118:i64 = const_i64 19
    ;; %t119:i64 = call rotr32(y, %t118)
    ;; %t120:i64 = xor_i64 %t117, %t119
    ;; %t121:i64 = const_i64 10
    ;; %t122:i64 = shr_i64 y, %t121
    ;; %t123:i64 = xor_i64 %t120, %t122
    ;; s1:i64 = mov %t123
    ;; %t124:i64 = const_i64 16
    ;; %t125:i64 = sub_i64 t2, %t124
    ;; %t126:i64 = W[%t125]
    ;; %t127:i64 = add_i64 %t126, s0
    ;; %t128:i64 = const_i64 7
    ;; %t129:i64 = sub_i64 t2, %t128
    ;; %t130:i64 = W[%t129]
    ;; %t131:i64 = add_i64 %t127, %t130
    ;; %t132:i64 = add_i64 %t131, s1
    ;; %t133:i64 = const_i64 4294967295
    ;; %t134:i64 = and_i64 %t132, %t133
    ;; W[t2] = %t134  ; i64
    ;; %t135:i64 = const_i64 1
    ;; %t136:i64 = add_i64 t2, %t135
    ;; t2:i64 = mov %t136
    ;; jmp .while_cond_18
    ;; .while_end_19:
    ;; %t137:i64 = const_i64 0
    ;; %t138:i64 = H[%t137]
    ;; a:i64 = mov %t138
    ;; %t139:i64 = const_i64 1
    ;; %t140:i64 = H[%t139]
    ;; b:i64 = mov %t140
    ;; %t141:i64 = const_i64 2
    ;; %t142:i64 = H[%t141]
    ;; c:i64 = mov %t142
    ;; %t143:i64 = const_i64 3
    ;; %t144:i64 = H[%t143]
    ;; d:i64 = mov %t144
    ;; %t145:i64 = const_i64 4
    ;; %t146:i64 = H[%t145]
    ;; e:i64 = mov %t146
    ;; %t147:i64 = const_i64 5
    ;; %t148:i64 = H[%t147]
    ;; f:i64 = mov %t148
    ;; %t149:i64 = const_i64 6
    ;; %t150:i64 = H[%t149]
    ;; g:i64 = mov %t150
    ;; %t151:i64 = const_i64 7
    ;; %t152:i64 = H[%t151]
    ;; h:i64 = mov %t152
    ;; %t153:i64 = const_i64 0
    ;; t3:i64 = mov %t153
    ;; .while_cond_20:
    ;; %t154:i64 = const_i64 64
    ;; %t155:bool = cmp_lt_i64 t3, %t154
    ;; jz %t155, .while_end_21
    ;; %t156:i64 = const_i64 6
    ;; %t157:i64 = call rotr32(e, %t156)
    ;; %t158:i64 = const_i64 11
    ;; %t159:i64 = call rotr32(e, %t158)
    ;; %t160:i64 = xor_i64 %t157, %t159
    ;; %t161:i64 = const_i64 25
    ;; %t162:i64 = call rotr32(e, %t161)
    ;; %t163:i64 = xor_i64 %t160, %t162
    ;; S1:i64 = mov %t163
    ;; %t164:i64 = and_i64 e, f
    ;; %t165:i64 = not_i64 e
    ;; %t166:i64 = and_i64 %t165, g
    ;; %t167:i64 = xor_i64 %t164, %t166
    ;; ch:i64 = mov %t167
    ;; %t168:i64 = add_i64 h, S1
    ;; %t169:i64 = add_i64 %t168, ch
    ;; %t170:i64 = K[t3]
    ;; %t171:i64 = add_i64 %t169, %t170
    ;; %t172:i64 = W[t3]
    ;; %t173:i64 = add_i64 %t171, %t172
    ;; %t174:i64 = const_i64 4294967295
    ;; %t175:i64 = and_i64 %t173, %t174
    ;; T1:i64 = mov %t175
    ;; %t176:i64 = const_i64 2
    ;; %t177:i64 = call rotr32(a, %t176)
    ;; %t178:i64 = const_i64 13
    ;; %t179:i64 = call rotr32(a, %t178)
    ;; %t180:i64 = xor_i64 %t177, %t179
    ;; %t181:i64 = const_i64 22
    ;; %t182:i64 = call rotr32(a, %t181)
    ;; %t183:i64 = xor_i64 %t180, %t182
    ;; S0:i64 = mov %t183
    ;; %t184:i64 = and_i64 a, b
    ;; %t185:i64 = and_i64 a, c
    ;; %t186:i64 = xor_i64 %t184, %t185
    ;; %t187:i64 = and_i64 b, c
    ;; %t188:i64 = xor_i64 %t186, %t187
    ;; maj:i64 = mov %t188
    ;; %t189:i64 = add_i64 S0, maj
    ;; %t190:i64 = const_i64 4294967295
    ;; %t191:i64 = and_i64 %t189, %t190
    ;; T2:i64 = mov %t191
    ;; h:i64 = mov g
    ;; g:i64 = mov f
    ;; f:i64 = mov e
    ;; %t192:i64 = add_i64 d, T1
    ;; %t193:i64 = const_i64 4294967295
    ;; %t194:i64 = and_i64 %t192, %t193
    ;; e:i64 = mov %t194
    ;; d:i64 = mov c
    ;; c:i64 = mov b
    ;; b:i64 = mov a
    ;; %t195:i64 = add_i64 T1, T2
    ;; %t196:i64 = const_i64 4294967295
    ;; %t197:i64 = and_i64 %t195, %t196
    ;; a:i64 = mov %t197
    ;; %t198:i64 = const_i64 1
    ;; %t199:i64 = add_i64 t3, %t198
    ;; t3:i64 = mov %t199
    ;; jmp .while_cond_20
    ;; .while_end_21:
    ;; %t200:i64 = const_i64 0
    ;; %t201:i64 = const_i64 0
    ;; %t202:i64 = H[%t201]
    ;; %t203:i64 = add_i64 %t202, a
    ;; %t204:i64 = const_i64 4294967295
    ;; %t205:i64 = and_i64 %t203, %t204
    ;; H[%t200] = %t205  ; i64
    ;; %t206:i64 = const_i64 1
    ;; %t207:i64 = const_i64 1
    ;; %t208:i64 = H[%t207]
    ;; %t209:i64 = add_i64 %t208, b
    ;; %t210:i64 = const_i64 4294967295
    ;; %t211:i64 = and_i64 %t209, %t210
    ;; H[%t206] = %t211  ; i64
    ;; %t212:i64 = const_i64 2
    ;; %t213:i64 = const_i64 2
    ;; %t214:i64 = H[%t213]
    ;; %t215:i64 = add_i64 %t214, c
    ;; %t216:i64 = const_i64 4294967295
    ;; %t217:i64 = and_i64 %t215, %t216
    ;; H[%t212] = %t217  ; i64
    ;; %t218:i64 = const_i64 3
    ;; %t219:i64 = const_i64 3
    ;; %t220:i64 = H[%t219]
    ;; %t221:i64 = add_i64 %t220, d
    ;; %t222:i64 = const_i64 4294967295
    ;; %t223:i64 = and_i64 %t221, %t222
    ;; H[%t218] = %t223  ; i64
    ;; %t224:i64 = const_i64 4
    ;; %t225:i64 = const_i64 4
    ;; %t226:i64 = H[%t225]
    ;; %t227:i64 = add_i64 %t226, e
    ;; %t228:i64 = const_i64 4294967295
    ;; %t229:i64 = and_i64 %t227, %t228
    ;; H[%t224] = %t229  ; i64
    ;; %t230:i64 = const_i64 5
    ;; %t231:i64 = const_i64 5
    ;; %t232:i64 = H[%t231]
    ;; %t233:i64 = add_i64 %t232, f
    ;; %t234:i64 = const_i64 4294967295
    ;; %t235:i64 = and_i64 %t233, %t234
    ;; H[%t230] = %t235  ; i64
    ;; %t236:i64 = const_i64 6
    ;; %t237:i64 = const_i64 6
    ;; %t238:i64 = H[%t237]
    ;; %t239:i64 = add_i64 %t238, g
    ;; %t240:i64 = const_i64 4294967295
    ;; %t241:i64 = and_i64 %t239, %t240
    ;; H[%t236] = %t241  ; i64
    ;; %t242:i64 = const_i64 7
    ;; %t243:i64 = const_i64 7
    ;; %t244:i64 = H[%t243]
    ;; %t245:i64 = add_i64 %t244, h
    ;; %t246:i64 = const_i64 4294967295
    ;; %t247:i64 = and_i64 %t245, %t246
    ;; H[%t242] = %t247  ; i64
    ;; %t248:i64 = const_i64 1
    ;; %t249:i64 = add_i64 chunk, %t248
    ;; chunk:i64 = mov %t249
    ;; jmp .while_cond_14
    ;; .while_end_15:
    ;; ret H
    (i64.const 0)
  )
  (func $sha256_digest (export "sha256_digest") (param $msg i64) (result i64)
    (local $t_t1 i64)
    (local $msg_len i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $buf_in i64)
    (local $t_t4 i64)
    (local $i i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = str_len(msg)
    ;; msg_len:i64 = mov %t1
    ;; %t3:i64 = const_i64 0
    ;; %t2:Array[i64] = alloc_array(msg_len, init=%t3)
    ;; buf_in:Array[i64] = mov %t2
    ;; %t4:i64 = const_i64 0
    ;; i:i64 = mov %t4
    ;; .while_cond_22:
    ;; %t5:bool = cmp_lt_i64 i, msg_len
    ;; jz %t5, .while_end_23
    ;; %t6:str = str_index(msg[i])
    ;; %t7:i64 = str_ord %t6
    ;; buf_in[i] = %t7  ; i64
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = add_i64 i, %t8
    ;; i:i64 = mov %t9
    ;; jmp .while_cond_22
    ;; .while_end_23:
    ;; %t10:Array[i64] = call sha256_buffer(buf_in, msg_len)
    ;; ret %t10
    (i64.const 0)
  )
  (func $sha256 (export "sha256") (param $msg i64) (result i64)
    (local $t_t1 i64)
    (local $digest i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:Array[i64] = call sha256_digest(msg)
    ;; digest:Array[i64] = mov %t1
    ;; %t2:str = call hex256(digest)
    ;; ret %t2
    (i64.const 0)
  )
  (func $hmac_sha256_digest (export "hmac_sha256_digest") (param $key i64) (param $msg i64) (result i64)
    (local $t_t1 i64)
    (local $k_len i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $key_block i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $kd i64)
    (local $t_t8 i64)
    (local $i i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $w i64)
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
    (local $m_len i64)
    (local $t_t49 i64)
    (local $t_t50 i64)
    (local $inner_len i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $inner_buf i64)
    (local $t_t53 i64)
    (local $j i64)
    (local $t_t54 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $k i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $t_t64 i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $t_t67 i64)
    (local $t_t68 i64)
    (local $t_t69 i64)
    (local $inner_digest i64)
    (local $t_t70 i64)
    (local $t_t71 i64)
    (local $t_t72 i64)
    (local $outer_buf i64)
    (local $t_t73 i64)
    (local $m i64)
    (local $t_t74 i64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $t_t77 i64)
    (local $t_t78 i64)
    (local $t_t79 i64)
    (local $t_t80 i64)
    (local $t_t81 i64)
    (local $n i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = str_len(key)
    ;; k_len:i64 = mov %t1
    ;; %t3:i64 = const_i64 64
    ;; %t4:i64 = const_i64 0
    ;; %t2:Array[i64] = alloc_array(%t3, init=%t4)
    ;; key_block:Array[i64] = mov %t2
    ;; %t5:i64 = const_i64 64
    ;; %t6:bool = cmp_gt_i64 k_len, %t5
    ;; jz %t6, .if_next_25
    ;; %t7:Array[i64] = call sha256_digest(key)
    ;; kd:Array[i64] = mov %t7
    ;; %t8:i64 = const_i64 0
    ;; i:i64 = mov %t8
    ;; .while_cond_26:
    ;; %t9:i64 = const_i64 8
    ;; %t10:bool = cmp_lt_i64 i, %t9
    ;; jz %t10, .while_end_27
    ;; %t11:i64 = kd[i]
    ;; w:i64 = mov %t11
    ;; %t12:i64 = const_i64 4
    ;; %t13:i64 = mul_i64 i, %t12
    ;; %t14:i64 = const_i64 24
    ;; %t15:i64 = shr_i64 w, %t14
    ;; %t16:i64 = const_i64 255
    ;; %t17:i64 = and_i64 %t15, %t16
    ;; key_block[%t13] = %t17  ; i64
    ;; %t18:i64 = const_i64 4
    ;; %t19:i64 = mul_i64 i, %t18
    ;; %t20:i64 = const_i64 1
    ;; %t21:i64 = add_i64 %t19, %t20
    ;; %t22:i64 = const_i64 16
    ;; %t23:i64 = shr_i64 w, %t22
    ;; %t24:i64 = const_i64 255
    ;; %t25:i64 = and_i64 %t23, %t24
    ;; key_block[%t21] = %t25  ; i64
    ;; %t26:i64 = const_i64 4
    ;; %t27:i64 = mul_i64 i, %t26
    ;; %t28:i64 = const_i64 2
    ;; %t29:i64 = add_i64 %t27, %t28
    ;; %t30:i64 = const_i64 8
    ;; %t31:i64 = shr_i64 w, %t30
    ;; %t32:i64 = const_i64 255
    ;; %t33:i64 = and_i64 %t31, %t32
    ;; key_block[%t29] = %t33  ; i64
    ;; %t34:i64 = const_i64 4
    ;; %t35:i64 = mul_i64 i, %t34
    ;; %t36:i64 = const_i64 3
    ;; %t37:i64 = add_i64 %t35, %t36
    ;; %t38:i64 = const_i64 255
    ;; %t39:i64 = and_i64 w, %t38
    ;; key_block[%t37] = %t39  ; i64
    ;; %t40:i64 = const_i64 1
    ;; %t41:i64 = add_i64 i, %t40
    ;; i:i64 = mov %t41
    ;; jmp .while_cond_26
    ;; .while_end_27:
    ;; jmp .if_end_24
    ;; .if_next_25:
    ;; %t42:i64 = const_i64 0
    ;; i:i64 = mov %t42
    ;; .while_cond_28:
    ;; %t43:bool = cmp_lt_i64 i, k_len
    ;; jz %t43, .while_end_29
    ;; %t44:str = str_index(key[i])
    ;; %t45:i64 = str_ord %t44
    ;; key_block[i] = %t45  ; i64
    ;; %t46:i64 = const_i64 1
    ;; %t47:i64 = add_i64 i, %t46
    ;; i:i64 = mov %t47
    ;; jmp .while_cond_28
    ;; .while_end_29:
    ;; .if_end_24:
    ;; %t48:i64 = str_len(msg)
    ;; m_len:i64 = mov %t48
    ;; %t49:i64 = const_i64 64
    ;; %t50:i64 = add_i64 %t49, m_len
    ;; inner_len:i64 = mov %t50
    ;; %t52:i64 = const_i64 0
    ;; %t51:Array[i64] = alloc_array(inner_len, init=%t52)
    ;; inner_buf:Array[i64] = mov %t51
    ;; %t53:i64 = const_i64 0
    ;; j:i64 = mov %t53
    ;; .while_cond_30:
    ;; %t54:i64 = const_i64 64
    ;; %t55:bool = cmp_lt_i64 j, %t54
    ;; jz %t55, .while_end_31
    ;; %t56:i64 = key_block[j]
    ;; %t57:i64 = const_i64 54
    ;; %t58:i64 = xor_i64 %t56, %t57
    ;; inner_buf[j] = %t58  ; i64
    ;; %t59:i64 = const_i64 1
    ;; %t60:i64 = add_i64 j, %t59
    ;; j:i64 = mov %t60
    ;; jmp .while_cond_30
    ;; .while_end_31:
    ;; %t61:i64 = const_i64 0
    ;; k:i64 = mov %t61
    ;; .while_cond_32:
    ;; %t62:bool = cmp_lt_i64 k, m_len
    ;; jz %t62, .while_end_33
    ;; %t63:i64 = const_i64 64
    ;; %t64:i64 = add_i64 %t63, k
    ;; %t65:str = str_index(msg[k])
    ;; %t66:i64 = str_ord %t65
    ;; inner_buf[%t64] = %t66  ; i64
    ;; %t67:i64 = const_i64 1
    ;; %t68:i64 = add_i64 k, %t67
    ;; k:i64 = mov %t68
    ;; jmp .while_cond_32
    ;; .while_end_33:
    ;; %t69:Array[i64] = call sha256_buffer(inner_buf, inner_len)
    ;; inner_digest:Array[i64] = mov %t69
    ;; %t71:i64 = const_i64 96
    ;; %t72:i64 = const_i64 0
    ;; %t70:Array[i64] = alloc_array(%t71, init=%t72)
    ;; outer_buf:Array[i64] = mov %t70
    ;; %t73:i64 = const_i64 0
    ;; m:i64 = mov %t73
    ;; .while_cond_34:
    ;; %t74:i64 = const_i64 64
    ;; %t75:bool = cmp_lt_i64 m, %t74
    ;; jz %t75, .while_end_35
    ;; %t76:i64 = key_block[m]
    ;; %t77:i64 = const_i64 92
    ;; %t78:i64 = xor_i64 %t76, %t77
    ;; outer_buf[m] = %t78  ; i64
    ;; %t79:i64 = const_i64 1
    ;; %t80:i64 = add_i64 m, %t79
    ;; m:i64 = mov %t80
    ;; jmp .while_cond_34
    ;; .while_end_35:
    ;; %t81:i64 = const_i64 0
    ;; n:i64 = mov %t81
    ;; .while_cond_36:
    ;; %t82:i64 = const_i64 8
    ;; %t83:bool = cmp_lt_i64 n, %t82
    ;; jz %t83, .while_end_37
    ;; %t84:i64 = inner_digest[n]
    ;; w:i64 = mov %t84
    ;; %t85:i64 = const_i64 64
    ;; %t86:i64 = const_i64 4
    ;; %t87:i64 = mul_i64 n, %t86
    ;; %t88:i64 = add_i64 %t85, %t87
    ;; %t89:i64 = const_i64 24
    ;; %t90:i64 = shr_i64 w, %t89
    ;; %t91:i64 = const_i64 255
    ;; %t92:i64 = and_i64 %t90, %t91
    ;; outer_buf[%t88] = %t92  ; i64
    ;; %t93:i64 = const_i64 64
    ;; %t94:i64 = const_i64 4
    ;; %t95:i64 = mul_i64 n, %t94
    ;; %t96:i64 = add_i64 %t93, %t95
    ;; %t97:i64 = const_i64 1
    ;; %t98:i64 = add_i64 %t96, %t97
    ;; %t99:i64 = const_i64 16
    ;; %t100:i64 = shr_i64 w, %t99
    ;; %t101:i64 = const_i64 255
    ;; %t102:i64 = and_i64 %t100, %t101
    ;; outer_buf[%t98] = %t102  ; i64
    ;; %t103:i64 = const_i64 64
    ;; %t104:i64 = const_i64 4
    ;; %t105:i64 = mul_i64 n, %t104
    ;; %t106:i64 = add_i64 %t103, %t105
    ;; %t107:i64 = const_i64 2
    ;; %t108:i64 = add_i64 %t106, %t107
    ;; %t109:i64 = const_i64 8
    ;; %t110:i64 = shr_i64 w, %t109
    ;; %t111:i64 = const_i64 255
    ;; %t112:i64 = and_i64 %t110, %t111
    ;; outer_buf[%t108] = %t112  ; i64
    ;; %t113:i64 = const_i64 64
    ;; %t114:i64 = const_i64 4
    ;; %t115:i64 = mul_i64 n, %t114
    ;; %t116:i64 = add_i64 %t113, %t115
    ;; %t117:i64 = const_i64 3
    ;; %t118:i64 = add_i64 %t116, %t117
    ;; %t119:i64 = const_i64 255
    ;; %t120:i64 = and_i64 w, %t119
    ;; outer_buf[%t118] = %t120  ; i64
    ;; %t121:i64 = const_i64 1
    ;; %t122:i64 = add_i64 n, %t121
    ;; n:i64 = mov %t122
    ;; jmp .while_cond_36
    ;; .while_end_37:
    ;; %t123:i64 = const_i64 96
    ;; %t124:Array[i64] = call sha256_buffer(outer_buf, %t123)
    ;; ret %t124
    (i64.const 0)
  )
  (func $hmac_sha256 (export "hmac_sha256") (param $key i64) (param $msg i64) (result i64)
    (local $t_t1 i64)
    (local $digest i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:Array[i64] = call hmac_sha256_digest(key, msg)
    ;; digest:Array[i64] = mov %t1
    ;; %t2:str = call hex256(digest)
    ;; ret %t2
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $msg1 i64)
    (local $t_t6 i64)
    (local $h1 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $msg2 i64)
    (local $t_t10 i64)
    (local $h2 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $msg3 i64)
    (local $t_t14 i64)
    (local $h3 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $msg4 i64)
    (local $t_t18 i64)
    (local $h4 i64)
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
    (local $api_key i64)
    (local $t_t36 i64)
    (local $payload i64)
    (local $t_t37 i64)
    (local $sig i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $rfc_key i64)
    (local $t_t43 i64)
    (local $rfc_data i64)
    (local $t_t44 i64)
    (local $rfc_sig i64)
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
    (local $mm1 i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $mm2 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $mm3 i64)
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
    (local $fnv1 i64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $fnv2 i64)
    (local $t_t77 i64)
    (local $t_t78 i64)
    (local $fnv3 i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 1
    ;; print(%t1:str)
    ;; %t2:str = const_str 2
    ;; print(%t2:str)
    ;; %t3:str = const_str 1
    ;; print(%t3:str)
    ;; %t4:str = const_str 3
    ;; print(%t4:str)
    ;; %t5:str = const_str 4
    ;; msg1:str = mov %t5
    ;; %t6:str = call sha256(msg1)
    ;; h1:str = mov %t6
    ;; %t7:str = const_str 5
    ;; print(%t7:str)
    ;; %t8:str = const_str 6
    ;; print(%t8:str, h1:str)
    ;; %t9:str = const_str 7
    ;; msg2:str = mov %t9
    ;; %t10:str = call sha256(msg2)
    ;; h2:str = mov %t10
    ;; %t11:str = const_str 8
    ;; print(%t11:str)
    ;; %t12:str = const_str 6
    ;; print(%t12:str, h2:str)
    ;; %t13:str = const_str 9
    ;; msg3:str = mov %t13
    ;; %t14:str = call sha256(msg3)
    ;; h3:str = mov %t14
    ;; %t15:str = const_str 10
    ;; print(%t15:str)
    ;; %t16:str = const_str 6
    ;; print(%t16:str, h3:str)
    ;; %t17:str = const_str 11
    ;; msg4:str = mov %t17
    ;; %t18:str = call sha256(msg4)
    ;; h4:str = mov %t18
    ;; %t19:str = const_str 12
    ;; print(%t19:str)
    ;; %t20:str = const_str 6
    ;; print(%t20:str, h4:str)
    ;; %t21:str = const_str 13
    ;; %t22:bool = str_cmp_ne h1, %t21
    ;; jz %t22, .if_end_38
    ;; %t23:str = const_str 14
    ;; print(%t23:str)
    ;; %t24:i64 = const_i64 1
    ;; ret %t24
    ;; jmp .if_end_38
    ;; .if_end_38:
    ;; %t25:str = const_str 15
    ;; %t26:bool = str_cmp_ne h2, %t25
    ;; jz %t26, .if_end_39
    ;; %t27:str = const_str 16
    ;; print(%t27:str)
    ;; %t28:i64 = const_i64 2
    ;; ret %t28
    ;; jmp .if_end_39
    ;; .if_end_39:
    ;; %t29:str = const_str 17
    ;; %t30:bool = str_cmp_ne h3, %t29
    ;; jz %t30, .if_end_40
    ;; %t31:str = const_str 18
    ;; print(%t31:str)
    ;; %t32:i64 = const_i64 3
    ;; ret %t32
    ;; jmp .if_end_40
    ;; .if_end_40:
    ;; %t33:str = const_str 4
    ;; print(%t33:str)
    ;; %t34:str = const_str 19
    ;; print(%t34:str)
    ;; %t35:str = const_str 20
    ;; api_key:str = mov %t35
    ;; %t36:str = const_str 21
    ;; payload:str = mov %t36
    ;; %t37:str = call hmac_sha256(api_key, payload)
    ;; sig:str = mov %t37
    ;; %t38:str = const_str 22
    ;; print(%t38:str)
    ;; %t39:str = const_str 6
    ;; print(%t39:str, payload:str)
    ;; %t40:str = const_str 23
    ;; print(%t40:str)
    ;; %t41:str = const_str 6
    ;; print(%t41:str, sig:str)
    ;; %t42:str = const_str 24
    ;; rfc_key:str = mov %t42
    ;; %t43:str = const_str 9
    ;; rfc_data:str = mov %t43
    ;; %t44:str = call hmac_sha256(rfc_key, rfc_data)
    ;; rfc_sig:str = mov %t44
    ;; %t45:str = const_str 25
    ;; print(%t45:str)
    ;; %t46:str = const_str 6
    ;; print(%t46:str, rfc_sig:str)
    ;; %t47:str = const_str 26
    ;; %t48:bool = str_cmp_ne rfc_sig, %t47
    ;; jz %t48, .if_end_41
    ;; %t49:str = const_str 27
    ;; print(%t49:str)
    ;; %t50:i64 = const_i64 4
    ;; ret %t50
    ;; jmp .if_end_41
    ;; .if_end_41:
    ;; %t51:str = const_str 4
    ;; print(%t51:str)
    ;; %t52:str = const_str 28
    ;; print(%t52:str)
    ;; %t53:str = const_str 29
    ;; %t54:i64 = call murmurhash3(%t53)
    ;; mm1:i64 = mov %t54
    ;; %t55:str = const_str 30
    ;; %t56:i64 = call murmurhash3(%t55)
    ;; mm2:i64 = mov %t56
    ;; %t57:str = const_str 31
    ;; %t58:i64 = call murmurhash3(%t57)
    ;; mm3:i64 = mov %t58
    ;; %t59:str = const_str 32
    ;; %t60:str = const_str 33
    ;; %t61:str = call hex32(mm1)
    ;; %t62:str = const_str 34
    ;; print(%t59:str, mm1:i64, %t60:str, %t61:str, %t62:str)
    ;; %t63:str = const_str 35
    ;; %t64:str = const_str 33
    ;; %t65:str = call hex32(mm2)
    ;; %t66:str = const_str 34
    ;; print(%t63:str, mm2:i64, %t64:str, %t65:str, %t66:str)
    ;; %t67:str = const_str 36
    ;; %t68:str = const_str 33
    ;; %t69:str = call hex32(mm3)
    ;; %t70:str = const_str 34
    ;; print(%t67:str, mm3:i64, %t68:str, %t69:str, %t70:str)
    ;; %t71:str = const_str 4
    ;; print(%t71:str)
    ;; %t72:str = const_str 37
    ;; print(%t72:str)
    ;; %t73:str = const_str 29
    ;; %t74:i64 = call fnv1a_32(%t73)
    ;; fnv1:i64 = mov %t74
    ;; %t75:str = const_str 30
    ;; %t76:i64 = call fnv1a_32(%t75)
    ;; fnv2:i64 = mov %t76
    ;; %t77:str = const_str 31
    ;; %t78:i64 = call fnv1a_32(%t77)
    ;; fnv3:i64 = mov %t78
    ;; %t79:str = const_str 38
    ;; %t80:str = const_str 33
    ;; %t81:str = call hex32(fnv1)
    ;; %t82:str = const_str 34
    ;; print(%t79:str, fnv1:i64, %t80:str, %t81:str, %t82:str)
    ;; %t83:str = const_str 39
    ;; %t84:str = const_str 33
    ;; %t85:str = call hex32(fnv2)
    ;; %t86:str = const_str 34
    ;; print(%t83:str, fnv2:i64, %t84:str, %t85:str, %t86:str)
    ;; %t87:str = const_str 40
    ;; %t88:str = const_str 33
    ;; %t89:str = call hex32(fnv3)
    ;; %t90:str = const_str 34
    ;; print(%t87:str, fnv3:i64, %t88:str, %t89:str, %t90:str)
    ;; %t91:str = const_str 4
    ;; print(%t91:str)
    ;; %t92:str = const_str 1
    ;; print(%t92:str)
    ;; %t93:str = const_str 41
    ;; print(%t93:str)
    ;; %t94:str = const_str 1
    ;; print(%t94:str)
    ;; %t95:i64 = const_i64 0
    ;; ret %t95
    (i64.const 0)
  )
)