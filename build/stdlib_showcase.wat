(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $deg_to_rad (export "deg_to_rad") (param $deg f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t3:f64 = const_f64 0.017453292519943295
    ;; %t4:f64 = mul_f64 deg, %t3
    ;; ret %t4
    (f64.const 0.0)
  )
  (func $rad_to_deg (export "rad_to_deg") (param $rad f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t3:f64 = const_f64 57.29577951308232
    ;; %t4:f64 = mul_f64 rad, %t3
    ;; ret %t4
    (f64.const 0.0)
  )
  (func $degrees (export "degrees") (param $rad f64) (result f64)
    (local $t_t1 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call rad_to_deg(rad)
    ;; ret %t1
    (f64.const 0.0)
  )
  (func $radians (export "radians") (param $deg f64) (result f64)
    (local $t_t1 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call deg_to_rad(deg)
    ;; ret %t1
    (f64.const 0.0)
  )
  (func $clamp (export "clamp") (param $val f64) (param $low f64) (param $high f64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:bool = cmp_lt_f64 val, low
    ;; jz %t1, .if_end_1
    ;; ret low
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t2:bool = cmp_gt_f64 val, high
    ;; jz %t2, .if_end_2
    ;; ret high
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; ret val
    (f64.const 0.0)
  )
  (func $lerp (export "lerp") (param $a f64) (param $b f64) (param $t f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = sub_f64 b, a
    ;; %t2:f64 = mul_f64 %t1, t
    ;; %t3:f64 = add_f64 a, %t2
    ;; ret %t3
    (f64.const 0.0)
  )
  (func $hypot (export "hypot") (param $x f64) (param $y f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = mul_f64 x, x
    ;; %t2:f64 = mul_f64 y, y
    ;; %t3:f64 = add_f64 %t1, %t2
    ;; %t4:f64 = sqrt_f64 %t3
    ;; ret %t4
    (f64.const 0.0)
  )
  (func $sign (export "sign") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; %t2:bool = cmp_gt_f64 x, %t1
    ;; jz %t2, .if_end_3
    ;; %t3:f64 = const_f64 1.0
    ;; ret %t3
    ;; jmp .if_end_3
    ;; .if_end_3:
    ;; %t4:f64 = const_f64 0.0
    ;; %t5:bool = cmp_lt_f64 x, %t4
    ;; jz %t5, .if_end_4
    ;; %t6:f64 = const_f64 1.0
    ;; %t7:f64 = neg_f64 %t6
    ;; ret %t7
    ;; jmp .if_end_4
    ;; .if_end_4:
    ;; %t8:f64 = const_f64 0.0
    ;; ret %t8
    (f64.const 0.0)
  )
  (func $floor (export "floor") (param $x f64) (result f64)
    (local $t_t1 i64)
    (local $i i64)
    (local $t_t2 f64)
    (local $fi f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = f64_to_i64 x
    ;; i:i64 = mov %t1
    ;; %t2:f64 = i64_to_f64 i
    ;; fi:f64 = mov %t2
    ;; %t3:f64 = const_f64 0.0
    ;; %t4:bool = cmp_lt_f64 x, %t3
    ;; %t5:bool = cmp_ne_f64 x, fi
    ;; %t6:bool = and_i64 %t4, %t5
    ;; jz %t6, .if_end_5
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = sub_i64 i, %t7
    ;; %t9:f64 = i64_to_f64 %t8
    ;; ret %t9
    ;; jmp .if_end_5
    ;; .if_end_5:
    ;; ret fi
    (f64.const 0.0)
  )
  (func $ceil (export "ceil") (param $x f64) (result f64)
    (local $t_t1 i64)
    (local $i i64)
    (local $t_t2 f64)
    (local $fi f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = f64_to_i64 x
    ;; i:i64 = mov %t1
    ;; %t2:f64 = i64_to_f64 i
    ;; fi:f64 = mov %t2
    ;; %t3:f64 = const_f64 0.0
    ;; %t4:bool = cmp_gt_f64 x, %t3
    ;; %t5:bool = cmp_ne_f64 x, fi
    ;; %t6:bool = and_i64 %t4, %t5
    ;; jz %t6, .if_end_6
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = add_i64 i, %t7
    ;; %t9:f64 = i64_to_f64 %t8
    ;; ret %t9
    ;; jmp .if_end_6
    ;; .if_end_6:
    ;; ret fi
    (f64.const 0.0)
  )
  (func $trunc (export "trunc") (param $x f64) (result f64)
    (local $t_t1 i64)
    (local $t_t2 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = f64_to_i64 x
    ;; %t2:f64 = i64_to_f64 %t1
    ;; ret %t2
    (f64.const 0.0)
  )
  (func $sin (export "sin") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $tau f64)
    (local $t_t2 f64)
    (local $pi f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $k i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $r f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $t_t11 i64)
    (local $t_t12 f64)
    (local $t_t13 f64)
    (local $r2 f64)
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
    (local $t_t35 f64)
    (local $t_t36 f64)
    (local $t_t37 f64)
    (local $t_t38 f64)
    (local $t_t39 f64)
    (local $t_t40 f64)
    (local $t_t41 f64)
    (local $t_t42 f64)
    (local $t_t43 f64)
    (local $t_t44 f64)
    (local $t_t45 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 6.283185307179586
    ;; tau:f64 = mov %t1
    ;; %t2:f64 = const_f64 3.141592653589793
    ;; pi:f64 = mov %t2
    ;; %t3:f64 = div_f64 x, tau
    ;; %t4:i64 = f64_to_i64 %t3
    ;; k:i64 = mov %t4
    ;; %t5:f64 = i64_to_f64 k
    ;; %t6:f64 = mul_f64 %t5, tau
    ;; %t7:f64 = sub_f64 x, %t6
    ;; r:f64 = mov %t7
    ;; %t8:bool = cmp_gt_f64 r, pi
    ;; jz %t8, .if_next_8
    ;; %t9:f64 = sub_f64 r, tau
    ;; r:f64 = mov %t9
    ;; jmp .if_end_7
    ;; .if_next_8:
    ;; %t10:f64 = neg_f64 pi
    ;; %t11:bool = cmp_lt_f64 r, %t10
    ;; jz %t11, .if_end_7
    ;; %t12:f64 = add_f64 r, tau
    ;; r:f64 = mov %t12
    ;; jmp .if_end_7
    ;; .if_end_7:
    ;; %t13:f64 = mul_f64 r, r
    ;; r2:f64 = mov %t13
    ;; %t14:f64 = const_f64 1.0
    ;; %t17:f64 = const_f64 0.16666666666666666
    ;; %t20:f64 = const_f64 0.008333333333333333
    ;; %t23:f64 = const_f64 0.0001984126984126984
    ;; %t26:f64 = const_f64 2.7557319223985893e-06
    ;; %t29:f64 = const_f64 2.505210838544172e-08
    ;; %t32:f64 = const_f64 1.6059043836821613e-10
    ;; %t33:f64 = mul_f64 r2, %t32
    ;; %t34:f64 = sub_f64 %t29, %t33
    ;; %t35:f64 = mul_f64 r2, %t34
    ;; %t36:f64 = sub_f64 %t26, %t35
    ;; %t37:f64 = mul_f64 r2, %t36
    ;; %t38:f64 = sub_f64 %t23, %t37
    ;; %t39:f64 = mul_f64 r2, %t38
    ;; %t40:f64 = sub_f64 %t20, %t39
    ;; %t41:f64 = mul_f64 r2, %t40
    ;; %t42:f64 = sub_f64 %t17, %t41
    ;; %t43:f64 = mul_f64 r2, %t42
    ;; %t44:f64 = sub_f64 %t14, %t43
    ;; %t45:f64 = mul_f64 r, %t44
    ;; ret %t45
    (f64.const 0.0)
  )
  (func $cos (export "cos") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $half_pi f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 1.5707963267948966
    ;; half_pi:f64 = mov %t1
    ;; %t2:f64 = add_f64 x, half_pi
    ;; %t3:f64 = call sin(%t2)
    ;; ret %t3
    (f64.const 0.0)
  )
  (func $tan (export "tan") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $c f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call cos(x)
    ;; c:f64 = mov %t1
    ;; %t2:f64 = abs_f64 c
    ;; %t3:f64 = const_f64 1e-15
    ;; %t4:bool = cmp_lt_f64 %t2, %t3
    ;; jz %t4, .if_end_9
    ;; %t5:f64 = const_f64 1000000000000000.0
    ;; ret %t5
    ;; jmp .if_end_9
    ;; .if_end_9:
    ;; %t6:f64 = call sin(x)
    ;; %t7:f64 = div_f64 %t6, c
    ;; ret %t7
    (f64.const 0.0)
  )
  (func $atan (export "atan") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $half_pi f64)
    (local $t_t2 f64)
    (local $sign_val f64)
    (local $val f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $invert i64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 f64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $v2 f64)
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
    (local $res f64)
    (local $t_t32 f64)
    (local $t_t33 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 1.5707963267948966
    ;; half_pi:f64 = mov %t1
    ;; %t2:f64 = const_f64 1.0
    ;; sign_val:f64 = mov %t2
    ;; val:f64 = mov x
    ;; %t3:f64 = const_f64 0.0
    ;; %t4:bool = cmp_lt_f64 val, %t3
    ;; jz %t4, .if_end_10
    ;; %t5:f64 = const_f64 1.0
    ;; %t6:f64 = neg_f64 %t5
    ;; sign_val:f64 = mov %t6
    ;; %t7:f64 = neg_f64 val
    ;; val:f64 = mov %t7
    ;; jmp .if_end_10
    ;; .if_end_10:
    ;; %t8:bool = const_i64 0
    ;; invert:bool = mov %t8
    ;; %t9:f64 = const_f64 1.0
    ;; %t10:bool = cmp_gt_f64 val, %t9
    ;; jz %t10, .if_end_11
    ;; %t11:f64 = const_f64 1.0
    ;; %t12:f64 = div_f64 %t11, val
    ;; val:f64 = mov %t12
    ;; %t13:bool = const_i64 1
    ;; invert:bool = mov %t13
    ;; jmp .if_end_11
    ;; .if_end_11:
    ;; %t14:f64 = mul_f64 val, val
    ;; v2:f64 = mov %t14
    ;; %t15:f64 = const_f64 1.0
    ;; %t16:f64 = const_f64 0.3333314528
    ;; %t17:f64 = const_f64 0.1999355085
    ;; %t18:f64 = const_f64 0.1420889944
    ;; %t19:f64 = const_f64 0.1065626393
    ;; %t20:f64 = const_f64 0.07528964
    ;; %t21:f64 = mul_f64 v2, %t20
    ;; %t22:f64 = sub_f64 %t19, %t21
    ;; %t23:f64 = mul_f64 v2, %t22
    ;; %t24:f64 = sub_f64 %t18, %t23
    ;; %t25:f64 = mul_f64 v2, %t24
    ;; %t26:f64 = sub_f64 %t17, %t25
    ;; %t27:f64 = mul_f64 v2, %t26
    ;; %t28:f64 = sub_f64 %t16, %t27
    ;; %t29:f64 = mul_f64 v2, %t28
    ;; %t30:f64 = sub_f64 %t15, %t29
    ;; %t31:f64 = mul_f64 val, %t30
    ;; res:f64 = mov %t31
    ;; jz invert, .if_end_12
    ;; %t32:f64 = sub_f64 half_pi, res
    ;; res:f64 = mov %t32
    ;; jmp .if_end_12
    ;; .if_end_12:
    ;; %t33:f64 = mul_f64 sign_val, res
    ;; ret %t33
    (f64.const 0.0)
  )
  (func $atan2 (export "atan2") (param $y f64) (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $pi f64)
    (local $t_t2 f64)
    (local $half_pi f64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 f64)
    (local $t_t13 f64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $t_t18 i64)
    (local $t_t19 f64)
    (local $t_t20 i64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 3.141592653589793
    ;; pi:f64 = mov %t1
    ;; %t2:f64 = const_f64 1.5707963267948966
    ;; half_pi:f64 = mov %t2
    ;; %t3:f64 = const_f64 0.0
    ;; %t4:bool = cmp_gt_f64 x, %t3
    ;; jz %t4, .if_end_13
    ;; %t5:f64 = div_f64 y, x
    ;; %t6:f64 = call atan(%t5)
    ;; ret %t6
    ;; jmp .if_end_13
    ;; .if_end_13:
    ;; %t7:f64 = const_f64 0.0
    ;; %t8:bool = cmp_lt_f64 x, %t7
    ;; jz %t8, .if_end_14
    ;; %t9:f64 = const_f64 0.0
    ;; %t10:bool = cmp_ge_f64 y, %t9
    ;; jz %t10, .if_next_16
    ;; %t11:f64 = div_f64 y, x
    ;; %t12:f64 = call atan(%t11)
    ;; %t13:f64 = add_f64 %t12, pi
    ;; ret %t13
    ;; jmp .if_end_15
    ;; .if_next_16:
    ;; %t14:f64 = div_f64 y, x
    ;; %t15:f64 = call atan(%t14)
    ;; %t16:f64 = sub_f64 %t15, pi
    ;; ret %t16
    ;; .if_end_15:
    ;; jmp .if_end_14
    ;; .if_end_14:
    ;; %t17:f64 = const_f64 0.0
    ;; %t18:bool = cmp_gt_f64 y, %t17
    ;; jz %t18, .if_end_17
    ;; ret half_pi
    ;; jmp .if_end_17
    ;; .if_end_17:
    ;; %t19:f64 = const_f64 0.0
    ;; %t20:bool = cmp_lt_f64 y, %t19
    ;; jz %t20, .if_end_18
    ;; %t21:f64 = neg_f64 half_pi
    ;; ret %t21
    ;; jmp .if_end_18
    ;; .if_end_18:
    ;; %t22:f64 = const_f64 0.0
    ;; ret %t22
    (f64.const 0.0)
  )
  (func $asin (export "asin") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $c f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $denom f64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $half_pi f64)
    (local $t_t12 f64)
    (local $t_t13 f64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 1.0
    ;; %t2:f64 = neg_f64 %t1
    ;; %t3:f64 = const_f64 1.0
    ;; %t4:f64 = call clamp(x, %t2, %t3)
    ;; c:f64 = mov %t4
    ;; %t5:f64 = const_f64 1.0
    ;; %t6:f64 = mul_f64 c, c
    ;; %t7:f64 = sub_f64 %t5, %t6
    ;; %t8:f64 = sqrt_f64 %t7
    ;; denom:f64 = mov %t8
    ;; %t9:f64 = const_f64 0.0
    ;; %t10:bool = cmp_eq_f64 denom, %t9
    ;; jz %t10, .if_end_19
    ;; %t11:f64 = const_f64 1.5707963267948966
    ;; half_pi:f64 = mov %t11
    ;; %t13:f64 = const_f64 0.0
    ;; %t14:bool = cmp_gt_f64 c, %t13
    ;; jz %t14, .tern_else_20
    ;; %t12:f64 = mov half_pi
    ;; jmp .tern_end_21
    ;; .tern_else_20:
    ;; %t15:f64 = neg_f64 half_pi
    ;; %t12:f64 = mov %t15
    ;; .tern_end_21:
    ;; ret %t12
    ;; jmp .if_end_19
    ;; .if_end_19:
    ;; %t16:f64 = div_f64 c, denom
    ;; %t17:f64 = call atan(%t16)
    ;; ret %t17
    (f64.const 0.0)
  )
  (func $acos (export "acos") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $half_pi f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 1.5707963267948966
    ;; half_pi:f64 = mov %t1
    ;; %t2:f64 = call asin(x)
    ;; %t3:f64 = sub_f64 half_pi, %t2
    ;; ret %t3
    (f64.const 0.0)
  )
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
    ;; jz %t2, .if_end_22
    ;; %t3:f64 = const_f64 1.0
    ;; ret %t3
    ;; jmp .if_end_22
    ;; .if_end_22:
    ;; %t4:f64 = const_f64 50.0
    ;; %t5:f64 = neg_f64 %t4
    ;; %t6:bool = cmp_lt_f64 x, %t5
    ;; jz %t6, .if_end_23
    ;; %t7:f64 = const_f64 0.0
    ;; ret %t7
    ;; jmp .if_end_23
    ;; .if_end_23:
    ;; %t8:f64 = const_f64 700.0
    ;; %t9:bool = cmp_gt_f64 x, %t8
    ;; jz %t9, .if_end_24
    ;; %t10:f64 = const_f64 1e+300
    ;; ret %t10
    ;; jmp .if_end_24
    ;; .if_end_24:
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
    ;; .for_cond_25:
    ;; %t38:bool = cmp_lt_i64 _, %t36
    ;; jz %t38, .for_end_27
    ;; %t39:f64 = mul_f64 term, term
    ;; term:f64 = mov %t39
    ;; .for_step_26:
    ;; %t40:i64 = add_i64 _, %t37
    ;; _:i64 = mov %t40
    ;; jmp .for_cond_25
    ;; .for_end_27:
    ;; ret term
    (f64.const 0.0)
  )
  (func $log (export "log") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $ln2 f64)
    (local $val f64)
    (local $t_t6 i64)
    (local $k i64)
    (local $t_t7 f64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 f64)
    (local $t_t20 f64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $t_t23 f64)
    (local $z f64)
    (local $t_t24 f64)
    (local $z2 f64)
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
    (local $t_t35 f64)
    (local $t_t36 f64)
    (local $t_t37 f64)
    (local $t_t38 f64)
    (local $t_t39 f64)
    (local $t_t40 f64)
    (local $t_t41 f64)
    (local $t_t42 f64)
    (local $t_t43 f64)
    (local $t_t44 f64)
    (local $t_t45 f64)
    (local $t_t46 f64)
    (local $t_t47 f64)
    (local $t_t48 f64)
    (local $res f64)
    (local $t_t49 f64)
    (local $t_t50 f64)
    (local $t_t51 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.0
    ;; %t2:bool = cmp_le_f64 x, %t1
    ;; jz %t2, .if_end_28
    ;; %t3:f64 = const_f64 1e+300
    ;; %t4:f64 = neg_f64 %t3
    ;; ret %t4
    ;; jmp .if_end_28
    ;; .if_end_28:
    ;; %t5:f64 = const_f64 0.6931471805599453
    ;; ln2:f64 = mov %t5
    ;; val:f64 = mov x
    ;; %t6:i64 = const_i64 0
    ;; k:i64 = mov %t6
    ;; .while_cond_29:
    ;; %t7:f64 = const_f64 1.5
    ;; %t8:bool = cmp_gt_f64 val, %t7
    ;; jz %t8, .while_end_30
    ;; %t9:f64 = const_f64 0.5
    ;; %t10:f64 = mul_f64 val, %t9
    ;; val:f64 = mov %t10
    ;; %t11:i64 = const_i64 1
    ;; %t12:i64 = add_i64 k, %t11
    ;; k:i64 = mov %t12
    ;; jmp .while_cond_29
    ;; .while_end_30:
    ;; .while_cond_31:
    ;; %t13:f64 = const_f64 0.75
    ;; %t14:bool = cmp_lt_f64 val, %t13
    ;; jz %t14, .while_end_32
    ;; %t15:f64 = const_f64 2.0
    ;; %t16:f64 = mul_f64 val, %t15
    ;; val:f64 = mov %t16
    ;; %t17:i64 = const_i64 1
    ;; %t18:i64 = sub_i64 k, %t17
    ;; k:i64 = mov %t18
    ;; jmp .while_cond_31
    ;; .while_end_32:
    ;; %t19:f64 = const_f64 1.0
    ;; %t20:f64 = sub_f64 val, %t19
    ;; %t21:f64 = const_f64 1.0
    ;; %t22:f64 = add_f64 val, %t21
    ;; %t23:f64 = div_f64 %t20, %t22
    ;; z:f64 = mov %t23
    ;; %t24:f64 = mul_f64 z, z
    ;; z2:f64 = mov %t24
    ;; %t25:f64 = const_f64 2.0
    ;; %t26:f64 = mul_f64 %t25, z
    ;; %t27:f64 = const_f64 1.0
    ;; %t30:f64 = const_f64 0.3333333333333333
    ;; %t33:f64 = const_f64 0.2
    ;; %t36:f64 = const_f64 0.14285714285714285
    ;; %t39:f64 = const_f64 0.1111111111111111
    ;; %t40:f64 = mul_f64 z2, %t39
    ;; %t41:f64 = add_f64 %t36, %t40
    ;; %t42:f64 = mul_f64 z2, %t41
    ;; %t43:f64 = add_f64 %t33, %t42
    ;; %t44:f64 = mul_f64 z2, %t43
    ;; %t45:f64 = add_f64 %t30, %t44
    ;; %t46:f64 = mul_f64 z2, %t45
    ;; %t47:f64 = add_f64 %t27, %t46
    ;; %t48:f64 = mul_f64 %t26, %t47
    ;; res:f64 = mov %t48
    ;; %t49:f64 = i64_to_f64 k
    ;; %t50:f64 = mul_f64 %t49, ln2
    ;; %t51:f64 = add_f64 res, %t50
    ;; ret %t51
    (f64.const 0.0)
  )
  (func $log10 (export "log10") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call log(x)
    ;; %t2:f64 = const_f64 2.302585092994046
    ;; %t3:f64 = div_f64 %t1, %t2
    ;; ret %t3
    (f64.const 0.0)
  )
  (func $log2 (export "log2") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call log(x)
    ;; %t2:f64 = const_f64 0.6931471805599453
    ;; %t3:f64 = div_f64 %t1, %t2
    ;; ret %t3
    (f64.const 0.0)
  )
  (func $sinh (export "sinh") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $ex f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call exp(x)
    ;; ex:f64 = mov %t1
    ;; %t2:f64 = const_f64 1.0
    ;; %t3:f64 = div_f64 %t2, ex
    ;; %t4:f64 = sub_f64 ex, %t3
    ;; %t5:f64 = const_f64 0.5
    ;; %t6:f64 = mul_f64 %t4, %t5
    ;; ret %t6
    (f64.const 0.0)
  )
  (func $cosh (export "cosh") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $ex f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call exp(x)
    ;; ex:f64 = mov %t1
    ;; %t2:f64 = const_f64 1.0
    ;; %t3:f64 = div_f64 %t2, ex
    ;; %t4:f64 = add_f64 ex, %t3
    ;; %t5:f64 = const_f64 0.5
    ;; %t6:f64 = mul_f64 %t4, %t5
    ;; ret %t6
    (f64.const 0.0)
  )
  (func $tanh (export "tanh") (param $x f64) (result f64)
    (local $t_t1 f64)
    (local $ex f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $emx f64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = call exp(x)
    ;; ex:f64 = mov %t1
    ;; %t2:f64 = const_f64 1.0
    ;; %t3:f64 = div_f64 %t2, ex
    ;; emx:f64 = mov %t3
    ;; %t4:f64 = sub_f64 ex, emx
    ;; %t5:f64 = add_f64 ex, emx
    ;; %t6:f64 = div_f64 %t4, %t5
    ;; ret %t6
    (f64.const 0.0)
  )
  (func $gcd (export "gcd") (param $a i64) (param $b i64) (result i64)
    (local $t_t1 i64)
    (local $x i64)
    (local $t_t2 i64)
    (local $y i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = abs_i64 a
    ;; x:i64 = mov %t1
    ;; %t2:i64 = abs_i64 b
    ;; y:i64 = mov %t2
    ;; .while_cond_33:
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_ne_i64 y, %t3
    ;; jz %t4, .while_end_34
    ;; t:i64 = mov y
    ;; %t5:i64 = mod_i64 x, y
    ;; y:i64 = mov %t5
    ;; x:i64 = mov t
    ;; jmp .while_cond_33
    ;; .while_end_34:
    ;; ret x
    (i64.const 0)
  )
  (func $factorial (export "factorial") (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $res i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $i i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:bool = cmp_le_i64 n, %t1
    ;; jz %t2, .if_end_35
    ;; %t3:i64 = const_i64 1
    ;; ret %t3
    ;; jmp .if_end_35
    ;; .if_end_35:
    ;; %t4:i64 = const_i64 1
    ;; res:i64 = mov %t4
    ;; %t5:i64 = const_i64 2
    ;; %t6:i64 = const_i64 1
    ;; i:i64 = mov %t5
    ;; .for_cond_36:
    ;; %t7:bool = cmp_le_i64 i, n
    ;; jz %t7, .for_end_38
    ;; %t8:i64 = mul_i64 res, i
    ;; res:i64 = mov %t8
    ;; .for_step_37:
    ;; %t9:i64 = add_i64 i, %t6
    ;; i:i64 = mov %t9
    ;; jmp .for_cond_36
    ;; .for_end_38:
    ;; ret res
    (i64.const 0)
  )
  (func $clock_sec (export "clock_sec")  (result f64)
    (local $t_t1 i64)
    (local $ns i64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = clock_ns None
    ;; ns:i64 = mov %t1
    ;; %t2:f64 = i64_to_f64 ns
    ;; %t3:f64 = const_f64 1000000000.0
    ;; %t4:f64 = div_f64 %t2, %t3
    ;; ret %t4
    (f64.const 0.0)
  )
  (func $sleep_ns (export "sleep_ns") (param $ns i64) (result i64)
    (local $t_t1 i64)
    (local $start i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = clock_ns None
    ;; start:i64 = mov %t1
    ;; .while_cond_39:
    ;; %t2:i64 = clock_ns None
    ;; %t3:i64 = sub_i64 %t2, start
    ;; %t4:bool = cmp_lt_i64 %t3, ns
    ;; jz %t4, .while_end_40
    ;; jmp .while_cond_39
    ;; .while_end_40:
    ;; %t5:void = const_i64 0
    ;; ret %t5
    (i64.const 0)
  )
  (func $sleep_ms (export "sleep_ms") (param $ms i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $target_ns i64)
    (local $t_t3 i64)
    (local $start i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1000000
    ;; %t2:i64 = mul_i64 ms, %t1
    ;; target_ns:i64 = mov %t2
    ;; %t3:i64 = clock_ns None
    ;; start:i64 = mov %t3
    ;; .while_cond_41:
    ;; %t4:i64 = clock_ns None
    ;; %t5:i64 = sub_i64 %t4, start
    ;; %t6:bool = cmp_lt_i64 %t5, target_ns
    ;; jz %t6, .while_end_42
    ;; jmp .while_cond_41
    ;; .while_end_42:
    ;; %t7:void = const_i64 0
    ;; ret %t7
    (i64.const 0)
  )
  (func $_splitmix64 (export "_splitmix64") (param $x i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $z i64)
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
    ;; %t1:i64 = const_i64 11400714819323198485
    ;; %t2:i64 = add_i64 x, %t1
    ;; z:i64 = mov %t2
    ;; %t3:i64 = const_i64 30
    ;; %t4:i64 = shr_i64 z, %t3
    ;; %t5:i64 = xor_i64 z, %t4
    ;; %t6:i64 = const_i64 5700355208116473369
    ;; %t7:i64 = mul_i64 %t5, %t6
    ;; z:i64 = mov %t7
    ;; %t8:i64 = const_i64 27
    ;; %t9:i64 = shr_i64 z, %t8
    ;; %t10:i64 = xor_i64 z, %t9
    ;; %t11:i64 = const_i64 2685821657736338717
    ;; %t12:i64 = mul_i64 %t10, %t11
    ;; z:i64 = mov %t12
    ;; %t13:i64 = const_i64 31
    ;; %t14:i64 = shr_i64 z, %t13
    ;; %t15:i64 = xor_i64 z, %t14
    ;; ret %t15
    (i64.const 0)
  )
  (func $rng_new (export "rng_new") (param $seed_val i64) (result i64)
    (local $s i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $s0 i64)
    (local $t_t5 i64)
    (local $s1 i64)
    (local $t_t6 i64)
    (local $s2 i64)
    (local $t_t7 i64)
    (local $s3 i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; s:i64 = mov seed_val
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_eq_i64 s, %t1
    ;; jz %t2, .if_end_43
    ;; %t3:i64 = clock_ns None
    ;; s:i64 = mov %t3
    ;; jmp .if_end_43
    ;; .if_end_43:
    ;; %t4:i64 = call _splitmix64(s)
    ;; s0:i64 = mov %t4
    ;; %t5:i64 = call _splitmix64(s0)
    ;; s1:i64 = mov %t5
    ;; %t6:i64 = call _splitmix64(s1)
    ;; s2:i64 = mov %t6
    ;; %t7:i64 = call _splitmix64(s2)
    ;; s3:i64 = mov %t7
    ;; %t8:i64 = const_i64 0
    ;; %t9:bool = cmp_eq_i64 s0, %t8
    ;; %t10:i64 = const_i64 0
    ;; %t11:bool = cmp_eq_i64 s1, %t10
    ;; %t12:bool = and_i64 %t9, %t11
    ;; %t13:i64 = const_i64 0
    ;; %t14:bool = cmp_eq_i64 s2, %t13
    ;; %t15:bool = and_i64 %t12, %t14
    ;; %t16:i64 = const_i64 0
    ;; %t17:bool = cmp_eq_i64 s3, %t16
    ;; %t18:bool = and_i64 %t15, %t17
    ;; jz %t18, .if_end_44
    ;; %t19:i64 = const_i64 123456789
    ;; s0:i64 = mov %t19
    ;; %t20:i64 = const_i64 987654321
    ;; s1:i64 = mov %t20
    ;; %t21:i64 = const_i64 456789123
    ;; s2:i64 = mov %t21
    ;; %t22:i64 = const_i64 321654987
    ;; s3:i64 = mov %t22
    ;; jmp .if_end_44
    ;; .if_end_44:
    ;; %t24:i64 = const_i64 4
    ;; %t25:i64 = const_i64 0
    ;; %t23:Xoshiro256 = alloc_array(%t24, init=%t25)
    ;; %t26:i64 = const_i64 0
    ;; %t23[%t26] = s0  ; i64
    ;; %t27:i64 = const_i64 1
    ;; %t23[%t27] = s1  ; i64
    ;; %t28:i64 = const_i64 2
    ;; %t23[%t28] = s2  ; i64
    ;; %t29:i64 = const_i64 3
    ;; %t23[%t29] = s3  ; i64
    ;; ret %t23
    (i64.const 0)
  )
  (func $rng_next (export "rng_next") (param $rng i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $sum_val i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $rot23 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $result i64)
    (local $t_t16 i64)
    (local $t_t17 i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = rng[%t1]
    ;; %t3:i64 = const_i64 3
    ;; %t4:i64 = rng[%t3]
    ;; %t5:i64 = add_i64 %t2, %t4
    ;; sum_val:i64 = mov %t5
    ;; %t6:i64 = const_i64 23
    ;; %t7:i64 = shl_i64 sum_val, %t6
    ;; %t8:i64 = const_i64 41
    ;; %t9:i64 = shr_i64 sum_val, %t8
    ;; %t10:i64 = const_i64 8388607
    ;; %t11:i64 = and_i64 %t9, %t10
    ;; %t12:i64 = or_i64 %t7, %t11
    ;; rot23:i64 = mov %t12
    ;; %t13:i64 = const_i64 0
    ;; %t14:i64 = rng[%t13]
    ;; %t15:i64 = add_i64 rot23, %t14
    ;; result:i64 = mov %t15
    ;; %t16:i64 = const_i64 1
    ;; %t17:i64 = rng[%t16]
    ;; %t18:i64 = const_i64 17
    ;; %t19:i64 = shl_i64 %t17, %t18
    ;; t:i64 = mov %t19
    ;; %t20:i64 = const_i64 2
    ;; %t21:i64 = rng[%t20]
    ;; %t22:i64 = const_i64 0
    ;; %t23:i64 = rng[%t22]
    ;; %t24:i64 = xor_i64 %t21, %t23
    ;; %t25:i64 = const_i64 2
    ;; rng[%t25] = %t24  ; i64
    ;; %t26:i64 = const_i64 3
    ;; %t27:i64 = rng[%t26]
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = rng[%t28]
    ;; %t30:i64 = xor_i64 %t27, %t29
    ;; %t31:i64 = const_i64 3
    ;; rng[%t31] = %t30  ; i64
    ;; %t32:i64 = const_i64 1
    ;; %t33:i64 = rng[%t32]
    ;; %t34:i64 = const_i64 2
    ;; %t35:i64 = rng[%t34]
    ;; %t36:i64 = xor_i64 %t33, %t35
    ;; %t37:i64 = const_i64 1
    ;; rng[%t37] = %t36  ; i64
    ;; %t38:i64 = const_i64 0
    ;; %t39:i64 = rng[%t38]
    ;; %t40:i64 = const_i64 3
    ;; %t41:i64 = rng[%t40]
    ;; %t42:i64 = xor_i64 %t39, %t41
    ;; %t43:i64 = const_i64 0
    ;; rng[%t43] = %t42  ; i64
    ;; %t44:i64 = const_i64 2
    ;; %t45:i64 = rng[%t44]
    ;; %t46:i64 = xor_i64 %t45, t
    ;; %t47:i64 = const_i64 2
    ;; rng[%t47] = %t46  ; i64
    ;; %t48:i64 = const_i64 3
    ;; %t49:i64 = rng[%t48]
    ;; %t50:i64 = const_i64 45
    ;; %t51:i64 = shl_i64 %t49, %t50
    ;; %t52:i64 = const_i64 3
    ;; %t53:i64 = rng[%t52]
    ;; %t54:i64 = const_i64 19
    ;; %t55:i64 = shr_i64 %t53, %t54
    ;; %t56:i64 = const_i64 35184372088831
    ;; %t57:i64 = and_i64 %t55, %t56
    ;; %t58:i64 = or_i64 %t51, %t57
    ;; %t59:i64 = const_i64 3
    ;; rng[%t59] = %t58  ; i64
    ;; %t60:i64 = const_i64 0
    ;; %t61:bool = cmp_lt_i64 result, %t60
    ;; jz %t61, .if_end_45
    ;; %t62:i64 = neg_i64 result
    ;; ret %t62
    ;; jmp .if_end_45
    ;; .if_end_45:
    ;; ret result
    (i64.const 0)
  )
  (func $rng_random_f64 (export "rng_random_f64") (param $rng i64) (result f64)
    (local $t_t1 i64)
    (local $u i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $bits53 i64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call rng_next(rng)
    ;; u:i64 = mov %t1
    ;; %t2:i64 = const_i64 9007199254740991
    ;; %t3:i64 = and_i64 u, %t2
    ;; bits53:i64 = mov %t3
    ;; %t4:f64 = i64_to_f64 bits53
    ;; %t5:f64 = const_f64 9007199254740992.0
    ;; %t6:f64 = div_f64 %t4, %t5
    ;; ret %t6
    (f64.const 0.0)
  )
  (func $rng_randint (export "rng_randint") (param $rng i64) (param $low i64) (param $high i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $span i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:bool = cmp_ge_i64 low, high
    ;; jz %t1, .if_end_46
    ;; ret low
    ;; jmp .if_end_46
    ;; .if_end_46:
    ;; %t2:i64 = sub_i64 high, low
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = add_i64 %t2, %t3
    ;; span:i64 = mov %t4
    ;; %t5:i64 = call rng_next(rng)
    ;; %t6:i64 = mod_i64 %t5, span
    ;; %t7:i64 = add_i64 low, %t6
    ;; ret %t7
    (i64.const 0)
  )
  (func $rng_uniform (export "rng_uniform") (param $rng i64) (param $low f64) (param $high f64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = sub_f64 high, low
    ;; %t2:f64 = call rng_random_f64(rng)
    ;; %t3:f64 = mul_f64 %t1, %t2
    ;; %t4:f64 = add_f64 low, %t3
    ;; ret %t4
    (f64.const 0.0)
  )
  (func $rng_choice (export "rng_choice") (param $rng i64) (param $arr i64) (param $count i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $idx i64)
    (local $t_t8 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:bool = cmp_le_i64 count, %t1
    ;; jz %t2, .if_end_47
    ;; %t3:i64 = const_i64 0
    ;; ret %t3
    ;; jmp .if_end_47
    ;; .if_end_47:
    ;; %t4:i64 = const_i64 0
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = sub_i64 count, %t5
    ;; %t7:i64 = call rng_randint(rng, %t4, %t6)
    ;; idx:i64 = mov %t7
    ;; %t8:i64 = arr[idx]
    ;; ret %t8
    (i64.const 0)
  )
  (func $test_math (export "test_math")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 i64)
    (local $t_t5 f64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $angle_90 f64)
    (local $t_t11 f64)
    (local $sin_90 f64)
    (local $t_t12 f64)
    (local $cos_90 f64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $angle_45 f64)
    (local $t_t18 f64)
    (local $sin_45 f64)
    (local $t_t19 i64)
    (local $t_t20 f64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $h f64)
    (local $t_t23 i64)
    (local $t_t24 f64)
    (local $t_t25 f64)
    (local $t_t26 f64)
    (local $at2 f64)
    (local $t_t27 i64)
    (local $t_t28 f64)
    (local $t_t29 f64)
    (local $t_t30 f64)
    (local $f_val f64)
    (local $t_t31 f64)
    (local $t_t32 f64)
    (local $c_val f64)
    (local $t_t33 f64)
    (local $t_t34 f64)
    (local $t_t35 f64)
    (local $t_t36 f64)
    (local $l_val f64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:str = const_str 1
    ;; %t3:f64 = const_f64 3.141592653589793
    ;; print(%t2:str, %t3:f64)
    ;; %t4:str = const_str 2
    ;; %t5:f64 = const_f64 6.283185307179586
    ;; print(%t4:str, %t5:f64)
    ;; %t6:str = const_str 3
    ;; %t7:f64 = const_f64 2.718281828459045
    ;; print(%t6:str, %t7:f64)
    ;; %t10:f64 = const_f64 1.5707963267948966
    ;; angle_90:f64 = mov %t10
    ;; %t11:f64 = call sin(angle_90)
    ;; sin_90:f64 = mov %t11
    ;; %t12:f64 = call cos(angle_90)
    ;; cos_90:f64 = mov %t12
    ;; %t13:str = const_str 4
    ;; print(%t13:str, sin_90:f64)
    ;; %t14:str = const_str 5
    ;; print(%t14:str, cos_90:f64)
    ;; %t17:f64 = const_f64 0.7853981633974483
    ;; angle_45:f64 = mov %t17
    ;; %t18:f64 = call sin(angle_45)
    ;; sin_45:f64 = mov %t18
    ;; %t19:str = const_str 6
    ;; print(%t19:str, sin_45:f64)
    ;; %t20:f64 = const_f64 3.0
    ;; %t21:f64 = const_f64 4.0
    ;; %t22:f64 = call hypot(%t20, %t21)
    ;; h:f64 = mov %t22
    ;; %t23:str = const_str 7
    ;; print(%t23:str, h:f64)
    ;; %t24:f64 = const_f64 4.0
    ;; %t25:f64 = const_f64 3.0
    ;; %t26:f64 = call atan2(%t24, %t25)
    ;; at2:f64 = mov %t26
    ;; %t27:str = const_str 8
    ;; %t28:f64 = call rad_to_deg(at2)
    ;; print(%t27:str, %t28:f64)
    ;; %t29:f64 = const_f64 3.7
    ;; %t30:f64 = call floor(%t29)
    ;; f_val:f64 = mov %t30
    ;; %t31:f64 = const_f64 3.2
    ;; %t32:f64 = call ceil(%t31)
    ;; c_val:f64 = mov %t32
    ;; %t33:f64 = const_f64 10.0
    ;; %t34:f64 = const_f64 20.0
    ;; %t35:f64 = const_f64 0.75
    ;; %t36:f64 = call lerp(%t33, %t34, %t35)
    ;; l_val:f64 = mov %t36
    ;; %t37:str = const_str 9
    ;; %t38:str = const_str 10
    ;; %t39:str = const_str 11
    ;; print(%t37:str, f_val:f64, %t38:str, c_val:f64, %t39:str, l_val:f64)
    ;; %t40:i64 = const_i64 0
    ;; ret %t40
    (i64.const 0)
  )
  (func $test_time (export "test_time")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t0 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t1 i64)
    (local $t_t6 i64)
    (local $elapsed_ns i64)
    (local $t_t7 f64)
    (local $t_t8 f64)
    (local $t_t9 f64)
    (local $elapsed_ms f64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 12
    ;; print(%t1:str)
    ;; %t2:i64 = clock_ns None
    ;; t0:i64 = mov %t2
    ;; %t3:i64 = const_i64 500000
    ;; %t4:void = call sleep_ns(%t3)
    ;; %t5:i64 = clock_ns None
    ;; t1:i64 = mov %t5
    ;; %t6:i64 = sub_i64 t1, t0
    ;; elapsed_ns:i64 = mov %t6
    ;; %t7:f64 = i64_to_f64 elapsed_ns
    ;; %t8:f64 = const_f64 1000000.0
    ;; %t9:f64 = div_f64 %t7, %t8
    ;; elapsed_ms:f64 = mov %t9
    ;; %t10:str = const_str 13
    ;; %t11:str = const_str 14
    ;; %t12:str = const_str 15
    ;; print(%t10:str, elapsed_ns:i64, %t11:str, elapsed_ms:f64, %t12:str)
    ;; %t13:i64 = const_i64 0
    ;; ret %t13
    (i64.const 0)
  )
  (func $test_random (export "test_random")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $rng i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $i i64)
    (local $t_t8 i64)
    (local $t_t9 f64)
    (local $rf f64)
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
    (local $die i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 16
    ;; print(%t1:str)
    ;; %t2:i64 = const_i64 1337
    ;; %t3:Xoshiro256 = call rng_new(%t2)
    ;; rng:Xoshiro256 = mov %t3
    ;; %t4:str = const_str 17
    ;; print(%t4:str)
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = const_i64 5
    ;; %t7:i64 = const_i64 1
    ;; i:i64 = mov %t5
    ;; .for_cond_48:
    ;; %t8:bool = cmp_le_i64 i, %t6
    ;; jz %t8, .for_end_50
    ;; %t9:f64 = call rng_random_f64(rng)
    ;; rf:f64 = mov %t9
    ;; %t10:str = const_str 18
    ;; %t11:str = const_str 19
    ;; print(%t10:str, i:i64, %t11:str, rf:f64)
    ;; .for_step_49:
    ;; %t12:i64 = add_i64 i, %t7
    ;; i:i64 = mov %t12
    ;; jmp .for_cond_48
    ;; .for_end_50:
    ;; %t13:str = const_str 20
    ;; print(%t13:str)
    ;; %t14:i64 = const_i64 1
    ;; %t15:i64 = const_i64 5
    ;; %t16:i64 = const_i64 1
    ;; i:i64 = mov %t14
    ;; .for_cond_51:
    ;; %t17:bool = cmp_le_i64 i, %t15
    ;; jz %t17, .for_end_53
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = const_i64 6
    ;; %t20:i64 = call rng_randint(rng, %t18, %t19)
    ;; die:i64 = mov %t20
    ;; %t21:str = const_str 21
    ;; %t22:str = const_str 19
    ;; print(%t21:str, i:i64, %t22:str, die:i64)
    ;; .for_step_52:
    ;; %t23:i64 = add_i64 i, %t16
    ;; i:i64 = mov %t23
    ;; jmp .for_cond_51
    ;; .for_end_53:
    ;; %t24:i64 = const_i64 0
    ;; ret %t24
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 22
    ;; print(%t1:str)
    ;; %t2:str = const_str 23
    ;; print(%t2:str)
    ;; %t3:str = const_str 22
    ;; print(%t3:str)
    ;; %t4:i64 = call test_math()
    ;; %t5:i64 = call test_time()
    ;; %t6:i64 = call test_random()
    ;; %t7:str = const_str 22
    ;; print(%t7:str)
    ;; %t8:str = const_str 24
    ;; print(%t8:str)
    ;; %t9:str = const_str 22
    ;; print(%t9:str)
    ;; %t10:i64 = const_i64 0
    ;; ret %t10
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
    ;; %t4:i64 = call main()
    ;; %t5:i64 = const_i64 0
    ;; ret %t5
    (i64.const 0)
  )
)