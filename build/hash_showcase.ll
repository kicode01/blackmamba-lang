; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local ptr @hex_byte(i64 %val.arg) #0 {
entry:
  %val.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %digits.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %hi.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %lo.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %digits.slot, align 8
  store i64 4, ptr %t2.slot, align 8
  ; %t3:i64 = shr_i64 val, %t2
  store i64 15, ptr %t4.slot, align 8
  ; %t5:i64 = and_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %hi.slot, align 8
  store i64 15, ptr %t6.slot, align 8
  ; %t7:i64 = and_i64 val, %t6
  %r3 = load i64, ptr %t7.slot, align 8
  store i64 %r3, ptr %lo.slot, align 8
  ; %t8:str = str_index(digits[hi])
  ; %t9:str = str_index(digits[lo])
  ; %t10:str = str_concat(%t8, %t9)
  %r4 = load ptr, ptr %t10.slot, align 8
  ret ptr %r4
ret_cont_4:
  ret ptr 0
}

define dso_local ptr @hex32(i64 %val.arg) #0 {
entry:
  %val.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %digits.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %s0.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %s1.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %s2.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %s3.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %s4.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %s5.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca ptr, align 8
  %s6.slot = alloca ptr, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca ptr, align 8
  %s7.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %digits.slot, align 8
  store i64 28, ptr %t2.slot, align 8
  ; %t3:i64 = shr_i64 val, %t2
  store i64 15, ptr %t4.slot, align 8
  ; %t5:i64 = and_i64 %t3, %t4
  ; %t6:str = str_index(digits[%t5])
  %r2 = load ptr, ptr %t6.slot, align 8
  store ptr %r2, ptr %s0.slot, align 8
  store i64 24, ptr %t7.slot, align 8
  ; %t8:i64 = shr_i64 val, %t7
  store i64 15, ptr %t9.slot, align 8
  ; %t10:i64 = and_i64 %t8, %t9
  ; %t11:str = str_index(digits[%t10])
  %r3 = load ptr, ptr %t11.slot, align 8
  store ptr %r3, ptr %s1.slot, align 8
  store i64 20, ptr %t12.slot, align 8
  ; %t13:i64 = shr_i64 val, %t12
  store i64 15, ptr %t14.slot, align 8
  ; %t15:i64 = and_i64 %t13, %t14
  ; %t16:str = str_index(digits[%t15])
  %r4 = load ptr, ptr %t16.slot, align 8
  store ptr %r4, ptr %s2.slot, align 8
  store i64 16, ptr %t17.slot, align 8
  ; %t18:i64 = shr_i64 val, %t17
  store i64 15, ptr %t19.slot, align 8
  ; %t20:i64 = and_i64 %t18, %t19
  ; %t21:str = str_index(digits[%t20])
  %r5 = load ptr, ptr %t21.slot, align 8
  store ptr %r5, ptr %s3.slot, align 8
  store i64 12, ptr %t22.slot, align 8
  ; %t23:i64 = shr_i64 val, %t22
  store i64 15, ptr %t24.slot, align 8
  ; %t25:i64 = and_i64 %t23, %t24
  ; %t26:str = str_index(digits[%t25])
  %r6 = load ptr, ptr %t26.slot, align 8
  store ptr %r6, ptr %s4.slot, align 8
  store i64 8, ptr %t27.slot, align 8
  ; %t28:i64 = shr_i64 val, %t27
  store i64 15, ptr %t29.slot, align 8
  ; %t30:i64 = and_i64 %t28, %t29
  ; %t31:str = str_index(digits[%t30])
  %r7 = load ptr, ptr %t31.slot, align 8
  store ptr %r7, ptr %s5.slot, align 8
  store i64 4, ptr %t32.slot, align 8
  ; %t33:i64 = shr_i64 val, %t32
  store i64 15, ptr %t34.slot, align 8
  ; %t35:i64 = and_i64 %t33, %t34
  ; %t36:str = str_index(digits[%t35])
  %r8 = load ptr, ptr %t36.slot, align 8
  store ptr %r8, ptr %s6.slot, align 8
  store i64 15, ptr %t37.slot, align 8
  ; %t38:i64 = and_i64 val, %t37
  ; %t39:str = str_index(digits[%t38])
  %r9 = load ptr, ptr %t39.slot, align 8
  store ptr %r9, ptr %s7.slot, align 8
  ; %t40:str = str_concat(s0, s1)
  ; %t41:str = str_concat(%t40, s2)
  ; %t42:str = str_concat(%t41, s3)
  ; %t43:str = str_concat(%t42, s4)
  ; %t44:str = str_concat(%t43, s5)
  ; %t45:str = str_concat(%t44, s6)
  ; %t46:str = str_concat(%t45, s7)
  %r10 = load ptr, ptr %t46.slot, align 8
  ret ptr %r10
ret_cont_10:
  ret ptr 0
}

define dso_local ptr @hex256(ptr %h.arg) #0 {
entry:
  %h.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca ptr, align 8
  %s0.slot = alloca ptr, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %s1.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %s2.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %s3.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %s4.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %s5.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %s6.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %s7.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca ptr, align 8
  store ptr %h.arg, ptr %h.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = h[%t1]
  ; %t3:str = call hex32(%t2)
  %r1 = load ptr, ptr %t3.slot, align 8
  store ptr %r1, ptr %s0.slot, align 8
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = h[%t4]
  ; %t6:str = call hex32(%t5)
  %r2 = load ptr, ptr %t6.slot, align 8
  store ptr %r2, ptr %s1.slot, align 8
  store i64 2, ptr %t7.slot, align 8
  ; %t8:i64 = h[%t7]
  ; %t9:str = call hex32(%t8)
  %r3 = load ptr, ptr %t9.slot, align 8
  store ptr %r3, ptr %s2.slot, align 8
  store i64 3, ptr %t10.slot, align 8
  ; %t11:i64 = h[%t10]
  ; %t12:str = call hex32(%t11)
  %r4 = load ptr, ptr %t12.slot, align 8
  store ptr %r4, ptr %s3.slot, align 8
  store i64 4, ptr %t13.slot, align 8
  ; %t14:i64 = h[%t13]
  ; %t15:str = call hex32(%t14)
  %r5 = load ptr, ptr %t15.slot, align 8
  store ptr %r5, ptr %s4.slot, align 8
  store i64 5, ptr %t16.slot, align 8
  ; %t17:i64 = h[%t16]
  ; %t18:str = call hex32(%t17)
  %r6 = load ptr, ptr %t18.slot, align 8
  store ptr %r6, ptr %s5.slot, align 8
  store i64 6, ptr %t19.slot, align 8
  ; %t20:i64 = h[%t19]
  ; %t21:str = call hex32(%t20)
  %r7 = load ptr, ptr %t21.slot, align 8
  store ptr %r7, ptr %s6.slot, align 8
  store i64 7, ptr %t22.slot, align 8
  ; %t23:i64 = h[%t22]
  ; %t24:str = call hex32(%t23)
  %r8 = load ptr, ptr %t24.slot, align 8
  store ptr %r8, ptr %s7.slot, align 8
  ; %t25:str = str_concat(s0, s1)
  ; %t26:str = str_concat(%t25, s2)
  ; %t27:str = str_concat(%t26, s3)
  ; %t28:str = str_concat(%t27, s4)
  ; %t29:str = str_concat(%t28, s5)
  ; %t30:str = str_concat(%t29, s6)
  ; %t31:str = str_concat(%t30, s7)
  %r9 = load ptr, ptr %t31.slot, align 8
  ret ptr %r9
ret_cont_9:
  ret ptr 0
}

define dso_local i64 @rotr32(i64 %x.arg, i64 %n.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  store i64 %x.arg, ptr %x.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = shr_i64 x, n
  store i64 32, ptr %t2.slot, align 8
  ; %t3:i64 = sub_i64 %t2, n
  ; %t4:i64 = shl_i64 x, %t3
  store i64 4294967295, ptr %t5.slot, align 8
  ; %t6:i64 = and_i64 %t4, %t5
  ; %t7:i64 = or_i64 %t1, %t6
  store i64 4294967295, ptr %t8.slot, align 8
  ; %t9:i64 = and_i64 %t7, %t8
  %r1 = load i64, ptr %t9.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @rotl32(i64 %x.arg, i64 %n.arg) #0 {
entry:
  %x.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  store i64 %x.arg, ptr %x.slot, align 8
  store i64 %n.arg, ptr %n.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = shl_i64 x, n
  store i64 4294967295, ptr %t2.slot, align 8
  ; %t3:i64 = and_i64 %t1, %t2
  store i64 32, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t4, n
  ; %t6:i64 = shr_i64 x, %t5
  ; %t7:i64 = or_i64 %t3, %t6
  store i64 4294967295, ptr %t8.slot, align 8
  ; %t9:i64 = and_i64 %t7, %t8
  %r1 = load i64, ptr %t9.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @fnv1a_32(ptr %s.arg) #0 {
entry:
  %s.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %h.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %prime.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  store ptr %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2166136261, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %h.slot, align 8
  store i64 16777619, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %prime.slot, align 8
  ; %t3:i64 = str_len(s)
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %length.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %while_cond_1
while_cond_1:
  ; %t5:bool = cmp_lt_i64 i, length
  %r5 = load i64, ptr %t5.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %while_end_2, label %fall_6
fall_6:
  ; %t6:str = str_index(s[i])
  ; %t7:i64 = str_ord %t6
  ; %t8:i64 = xor_i64 h, %t7
  store i64 4294967295, ptr %t9.slot, align 8
  ; %t10:i64 = and_i64 %t8, %t9
  %r7 = load i64, ptr %t10.slot, align 8
  store i64 %r7, ptr %h.slot, align 8
  ; %t11:i64 = mul_i64 h, prime
  store i64 4294967295, ptr %t12.slot, align 8
  ; %t13:i64 = and_i64 %t11, %t12
  %r8 = load i64, ptr %t13.slot, align 8
  store i64 %r8, ptr %h.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = add_i64 i, %t14
  %r9 = load i64, ptr %t15.slot, align 8
  store i64 %r9, ptr %i.slot, align 8
  br label %while_cond_1
dead_r10:
  br label %while_end_2
while_end_2:
  %r11 = load i64, ptr %h.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @fnv1a_64(ptr %s.arg) #0 {
entry:
  %s.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %h.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %prime.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  store ptr %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 14695981039346656037, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %h.slot, align 8
  store i64 1099511628211, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %prime.slot, align 8
  ; %t3:i64 = str_len(s)
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %length.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %while_cond_3
while_cond_3:
  ; %t5:bool = cmp_lt_i64 i, length
  %r5 = load i64, ptr %t5.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %while_end_4, label %fall_6
fall_6:
  ; %t6:str = str_index(s[i])
  ; %t7:i64 = str_ord %t6
  ; %t8:i64 = xor_i64 h, %t7
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %h.slot, align 8
  ; %t9:i64 = mul_i64 h, prime
  %r8 = load i64, ptr %t9.slot, align 8
  store i64 %r8, ptr %h.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = add_i64 i, %t10
  %r9 = load i64, ptr %t11.slot, align 8
  store i64 %r9, ptr %i.slot, align 8
  br label %while_cond_3
dead_r10:
  br label %while_end_4
while_end_4:
  %r11 = load i64, ptr %h.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @murmurhash3_32(ptr %key.arg, i64 %seed.arg) #0 {
entry:
  %key.slot = alloca ptr, align 8
  %seed.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %c1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %h.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %nblocks.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %b0.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %b1.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %b2.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %b3.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %k.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %tail.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %tail_base.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %kt.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca ptr, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca ptr, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca i64, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  %t112.slot = alloca i64, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca ptr, align 8
  %t115.slot = alloca i64, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca i64, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca i64, align 8
  %t120.slot = alloca i64, align 8
  %t121.slot = alloca i64, align 8
  %t122.slot = alloca i64, align 8
  %t123.slot = alloca i64, align 8
  %t124.slot = alloca i64, align 8
  %t125.slot = alloca i64, align 8
  %t126.slot = alloca i64, align 8
  %t127.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca i64, align 8
  %t132.slot = alloca i64, align 8
  %t133.slot = alloca i64, align 8
  %t134.slot = alloca i64, align 8
  %t135.slot = alloca i64, align 8
  %t136.slot = alloca i64, align 8
  %t137.slot = alloca i64, align 8
  %t138.slot = alloca i64, align 8
  %t139.slot = alloca i64, align 8
  %t140.slot = alloca i64, align 8
  %t141.slot = alloca i64, align 8
  %t142.slot = alloca i64, align 8
  %t143.slot = alloca i64, align 8
  %t144.slot = alloca i64, align 8
  %t145.slot = alloca i64, align 8
  %t146.slot = alloca i64, align 8
  %t147.slot = alloca i64, align 8
  %t148.slot = alloca i64, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store i64 %seed.arg, ptr %seed.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3432918353, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %c1.slot, align 8
  store i64 461845907, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %c2.slot, align 8
  ; %t3:i64 = str_len(key)
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %length.slot, align 8
  store i64 4294967295, ptr %t4.slot, align 8
  ; %t5:i64 = and_i64 seed, %t4
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %h.slot, align 8
  store i64 4, ptr %t6.slot, align 8
  ; %t7:i64 = div_i64 length, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  store i64 %r5, ptr %nblocks.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  %r6 = load i64, ptr %t8.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %while_cond_5
while_cond_5:
  ; %t9:bool = cmp_lt_i64 i, nblocks
  %r7 = load i64, ptr %t9.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %while_end_6, label %fall_8
fall_8:
  store i64 4, ptr %t10.slot, align 8
  ; %t11:i64 = mul_i64 i, %t10
  ; %t12:str = str_index(key[%t11])
  ; %t13:i64 = str_ord %t12
  %r9 = load i64, ptr %t13.slot, align 8
  store i64 %r9, ptr %b0.slot, align 8
  store i64 4, ptr %t14.slot, align 8
  ; %t15:i64 = mul_i64 i, %t14
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = add_i64 %t15, %t16
  ; %t18:str = str_index(key[%t17])
  ; %t19:i64 = str_ord %t18
  %r10 = load i64, ptr %t19.slot, align 8
  store i64 %r10, ptr %b1.slot, align 8
  store i64 4, ptr %t20.slot, align 8
  ; %t21:i64 = mul_i64 i, %t20
  store i64 2, ptr %t22.slot, align 8
  ; %t23:i64 = add_i64 %t21, %t22
  ; %t24:str = str_index(key[%t23])
  ; %t25:i64 = str_ord %t24
  %r11 = load i64, ptr %t25.slot, align 8
  store i64 %r11, ptr %b2.slot, align 8
  store i64 4, ptr %t26.slot, align 8
  ; %t27:i64 = mul_i64 i, %t26
  store i64 3, ptr %t28.slot, align 8
  ; %t29:i64 = add_i64 %t27, %t28
  ; %t30:str = str_index(key[%t29])
  ; %t31:i64 = str_ord %t30
  %r12 = load i64, ptr %t31.slot, align 8
  store i64 %r12, ptr %b3.slot, align 8
  store i64 8, ptr %t32.slot, align 8
  ; %t33:i64 = shl_i64 b1, %t32
  ; %t34:i64 = or_i64 b0, %t33
  store i64 16, ptr %t35.slot, align 8
  ; %t36:i64 = shl_i64 b2, %t35
  ; %t37:i64 = or_i64 %t34, %t36
  store i64 24, ptr %t38.slot, align 8
  ; %t39:i64 = shl_i64 b3, %t38
  ; %t40:i64 = or_i64 %t37, %t39
  %r13 = load i64, ptr %t40.slot, align 8
  store i64 %r13, ptr %k.slot, align 8
  ; %t41:i64 = mul_i64 k, c1
  store i64 4294967295, ptr %t42.slot, align 8
  ; %t43:i64 = and_i64 %t41, %t42
  %r14 = load i64, ptr %t43.slot, align 8
  store i64 %r14, ptr %k.slot, align 8
  store i64 15, ptr %t44.slot, align 8
  ; %t45:i64 = call rotl32(k, %t44)
  %r15 = load i64, ptr %t45.slot, align 8
  store i64 %r15, ptr %k.slot, align 8
  ; %t46:i64 = mul_i64 k, c2
  store i64 4294967295, ptr %t47.slot, align 8
  ; %t48:i64 = and_i64 %t46, %t47
  %r16 = load i64, ptr %t48.slot, align 8
  store i64 %r16, ptr %k.slot, align 8
  ; %t49:i64 = xor_i64 h, k
  %r17 = load i64, ptr %t49.slot, align 8
  store i64 %r17, ptr %h.slot, align 8
  store i64 13, ptr %t50.slot, align 8
  ; %t51:i64 = call rotl32(h, %t50)
  %r18 = load i64, ptr %t51.slot, align 8
  store i64 %r18, ptr %h.slot, align 8
  store i64 5, ptr %t52.slot, align 8
  ; %t53:i64 = mul_i64 h, %t52
  store i64 3864292196, ptr %t54.slot, align 8
  ; %t55:i64 = add_i64 %t53, %t54
  store i64 4294967295, ptr %t56.slot, align 8
  ; %t57:i64 = and_i64 %t55, %t56
  %r19 = load i64, ptr %t57.slot, align 8
  store i64 %r19, ptr %h.slot, align 8
  store i64 1, ptr %t58.slot, align 8
  ; %t59:i64 = add_i64 i, %t58
  %r20 = load i64, ptr %t59.slot, align 8
  store i64 %r20, ptr %i.slot, align 8
  br label %while_cond_5
dead_r21:
  br label %while_end_6
while_end_6:
  store i64 4, ptr %t60.slot, align 8
  ; %t61:i64 = mod_i64 length, %t60
  %r22 = load i64, ptr %t61.slot, align 8
  store i64 %r22, ptr %tail.slot, align 8
  store i64 4, ptr %t62.slot, align 8
  ; %t63:i64 = mul_i64 nblocks, %t62
  %r23 = load i64, ptr %t63.slot, align 8
  store i64 %r23, ptr %tail_base.slot, align 8
  store i64 0, ptr %t64.slot, align 8
  %r24 = load i64, ptr %t64.slot, align 8
  store i64 %r24, ptr %kt.slot, align 8
  store i64 3, ptr %t65.slot, align 8
  ; %t66:bool = cmp_eq_i64 tail, %t65
  %r25 = load i64, ptr %t66.slot, align 8
  %r26 = icmp eq i64 %r25, 0
  br i1 %r26, label %if_next_8, label %fall_26
fall_26:
  ; %t67:str = str_index(key[tail_base])
  ; %t68:i64 = str_ord %t67
  store i64 1, ptr %t69.slot, align 8
  ; %t70:i64 = add_i64 tail_base, %t69
  ; %t71:str = str_index(key[%t70])
  ; %t72:i64 = str_ord %t71
  store i64 8, ptr %t73.slot, align 8
  ; %t74:i64 = shl_i64 %t72, %t73
  ; %t75:i64 = or_i64 %t68, %t74
  store i64 2, ptr %t76.slot, align 8
  ; %t77:i64 = add_i64 tail_base, %t76
  ; %t78:str = str_index(key[%t77])
  ; %t79:i64 = str_ord %t78
  store i64 16, ptr %t80.slot, align 8
  ; %t81:i64 = shl_i64 %t79, %t80
  ; %t82:i64 = or_i64 %t75, %t81
  %r27 = load i64, ptr %t82.slot, align 8
  store i64 %r27, ptr %kt.slot, align 8
  ; %t83:i64 = mul_i64 kt, c1
  store i64 4294967295, ptr %t84.slot, align 8
  ; %t85:i64 = and_i64 %t83, %t84
  %r28 = load i64, ptr %t85.slot, align 8
  store i64 %r28, ptr %kt.slot, align 8
  store i64 15, ptr %t86.slot, align 8
  ; %t87:i64 = call rotl32(kt, %t86)
  %r29 = load i64, ptr %t87.slot, align 8
  store i64 %r29, ptr %kt.slot, align 8
  ; %t88:i64 = mul_i64 kt, c2
  store i64 4294967295, ptr %t89.slot, align 8
  ; %t90:i64 = and_i64 %t88, %t89
  %r30 = load i64, ptr %t90.slot, align 8
  store i64 %r30, ptr %kt.slot, align 8
  ; %t91:i64 = xor_i64 h, kt
  %r31 = load i64, ptr %t91.slot, align 8
  store i64 %r31, ptr %h.slot, align 8
  br label %if_end_7
dead_r32:
  br label %if_next_8
if_next_8:
  store i64 2, ptr %t92.slot, align 8
  ; %t93:bool = cmp_eq_i64 tail, %t92
  %r33 = load i64, ptr %t93.slot, align 8
  %r34 = icmp eq i64 %r33, 0
  br i1 %r34, label %if_elif_9, label %fall_34
fall_34:
  ; %t94:str = str_index(key[tail_base])
  ; %t95:i64 = str_ord %t94
  store i64 1, ptr %t96.slot, align 8
  ; %t97:i64 = add_i64 tail_base, %t96
  ; %t98:str = str_index(key[%t97])
  ; %t99:i64 = str_ord %t98
  store i64 8, ptr %t100.slot, align 8
  ; %t101:i64 = shl_i64 %t99, %t100
  ; %t102:i64 = or_i64 %t95, %t101
  %r35 = load i64, ptr %t102.slot, align 8
  store i64 %r35, ptr %kt.slot, align 8
  ; %t103:i64 = mul_i64 kt, c1
  store i64 4294967295, ptr %t104.slot, align 8
  ; %t105:i64 = and_i64 %t103, %t104
  %r36 = load i64, ptr %t105.slot, align 8
  store i64 %r36, ptr %kt.slot, align 8
  store i64 15, ptr %t106.slot, align 8
  ; %t107:i64 = call rotl32(kt, %t106)
  %r37 = load i64, ptr %t107.slot, align 8
  store i64 %r37, ptr %kt.slot, align 8
  ; %t108:i64 = mul_i64 kt, c2
  store i64 4294967295, ptr %t109.slot, align 8
  ; %t110:i64 = and_i64 %t108, %t109
  %r38 = load i64, ptr %t110.slot, align 8
  store i64 %r38, ptr %kt.slot, align 8
  ; %t111:i64 = xor_i64 h, kt
  %r39 = load i64, ptr %t111.slot, align 8
  store i64 %r39, ptr %h.slot, align 8
  br label %if_end_7
dead_r40:
  br label %if_elif_9
if_elif_9:
  store i64 1, ptr %t112.slot, align 8
  ; %t113:bool = cmp_eq_i64 tail, %t112
  %r41 = load i64, ptr %t113.slot, align 8
  %r42 = icmp eq i64 %r41, 0
  br i1 %r42, label %if_end_7, label %fall_42
fall_42:
  ; %t114:str = str_index(key[tail_base])
  ; %t115:i64 = str_ord %t114
  %r43 = load i64, ptr %t115.slot, align 8
  store i64 %r43, ptr %kt.slot, align 8
  ; %t116:i64 = mul_i64 kt, c1
  store i64 4294967295, ptr %t117.slot, align 8
  ; %t118:i64 = and_i64 %t116, %t117
  %r44 = load i64, ptr %t118.slot, align 8
  store i64 %r44, ptr %kt.slot, align 8
  store i64 15, ptr %t119.slot, align 8
  ; %t120:i64 = call rotl32(kt, %t119)
  %r45 = load i64, ptr %t120.slot, align 8
  store i64 %r45, ptr %kt.slot, align 8
  ; %t121:i64 = mul_i64 kt, c2
  store i64 4294967295, ptr %t122.slot, align 8
  ; %t123:i64 = and_i64 %t121, %t122
  %r46 = load i64, ptr %t123.slot, align 8
  store i64 %r46, ptr %kt.slot, align 8
  ; %t124:i64 = xor_i64 h, kt
  %r47 = load i64, ptr %t124.slot, align 8
  store i64 %r47, ptr %h.slot, align 8
  br label %if_end_7
dead_r48:
  br label %if_end_7
if_end_7:
  ; %t125:i64 = xor_i64 h, length
  %r49 = load i64, ptr %t125.slot, align 8
  store i64 %r49, ptr %h.slot, align 8
  store i64 16, ptr %t126.slot, align 8
  ; %t127:i64 = shr_i64 h, %t126
  ; %t128:i64 = xor_i64 h, %t127
  store i64 4294967295, ptr %t129.slot, align 8
  ; %t130:i64 = and_i64 %t128, %t129
  %r50 = load i64, ptr %t130.slot, align 8
  store i64 %r50, ptr %h.slot, align 8
  store i64 2246822507, ptr %t131.slot, align 8
  ; %t132:i64 = mul_i64 h, %t131
  store i64 4294967295, ptr %t133.slot, align 8
  ; %t134:i64 = and_i64 %t132, %t133
  %r51 = load i64, ptr %t134.slot, align 8
  store i64 %r51, ptr %h.slot, align 8
  store i64 13, ptr %t135.slot, align 8
  ; %t136:i64 = shr_i64 h, %t135
  ; %t137:i64 = xor_i64 h, %t136
  store i64 4294967295, ptr %t138.slot, align 8
  ; %t139:i64 = and_i64 %t137, %t138
  %r52 = load i64, ptr %t139.slot, align 8
  store i64 %r52, ptr %h.slot, align 8
  store i64 3266489909, ptr %t140.slot, align 8
  ; %t141:i64 = mul_i64 h, %t140
  store i64 4294967295, ptr %t142.slot, align 8
  ; %t143:i64 = and_i64 %t141, %t142
  %r53 = load i64, ptr %t143.slot, align 8
  store i64 %r53, ptr %h.slot, align 8
  store i64 16, ptr %t144.slot, align 8
  ; %t145:i64 = shr_i64 h, %t144
  ; %t146:i64 = xor_i64 h, %t145
  store i64 4294967295, ptr %t147.slot, align 8
  ; %t148:i64 = and_i64 %t146, %t147
  %r54 = load i64, ptr %t148.slot, align 8
  store i64 %r54, ptr %h.slot, align 8
  %r55 = load i64, ptr %h.slot, align 8
  ret i64 %r55
ret_cont_55:
  ret i64 0
}

define dso_local i64 @murmurhash3(ptr %key.arg) #0 {
entry:
  %key.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = call murmurhash3_32(key, %t1)
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local ptr @sha256_k() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca i64, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  %t112.slot = alloca i64, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca i64, align 8
  %t115.slot = alloca i64, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca i64, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca i64, align 8
  %t120.slot = alloca i64, align 8
  %t121.slot = alloca i64, align 8
  %t122.slot = alloca i64, align 8
  %t123.slot = alloca i64, align 8
  %t124.slot = alloca i64, align 8
  %t125.slot = alloca i64, align 8
  %t126.slot = alloca i64, align 8
  %t127.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca i64, align 8
  %k.slot = alloca ptr, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 64, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:Array[i64] = alloc_array(%t2, init=%t3)
  store i64 1116352408, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t1[%t5] = %t4  ; i64
  store i64 1899447441, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  ; %t1[%t7] = %t6  ; i64
  store i64 3049323471, ptr %t8.slot, align 8
  store i64 2, ptr %t9.slot, align 8
  ; %t1[%t9] = %t8  ; i64
  store i64 3921009573, ptr %t10.slot, align 8
  store i64 3, ptr %t11.slot, align 8
  ; %t1[%t11] = %t10  ; i64
  store i64 961987163, ptr %t12.slot, align 8
  store i64 4, ptr %t13.slot, align 8
  ; %t1[%t13] = %t12  ; i64
  store i64 1508970993, ptr %t14.slot, align 8
  store i64 5, ptr %t15.slot, align 8
  ; %t1[%t15] = %t14  ; i64
  store i64 2453635748, ptr %t16.slot, align 8
  store i64 6, ptr %t17.slot, align 8
  ; %t1[%t17] = %t16  ; i64
  store i64 2870763221, ptr %t18.slot, align 8
  store i64 7, ptr %t19.slot, align 8
  ; %t1[%t19] = %t18  ; i64
  store i64 3624381080, ptr %t20.slot, align 8
  store i64 8, ptr %t21.slot, align 8
  ; %t1[%t21] = %t20  ; i64
  store i64 310598401, ptr %t22.slot, align 8
  store i64 9, ptr %t23.slot, align 8
  ; %t1[%t23] = %t22  ; i64
  store i64 607225278, ptr %t24.slot, align 8
  store i64 10, ptr %t25.slot, align 8
  ; %t1[%t25] = %t24  ; i64
  store i64 1426881987, ptr %t26.slot, align 8
  store i64 11, ptr %t27.slot, align 8
  ; %t1[%t27] = %t26  ; i64
  store i64 1925078388, ptr %t28.slot, align 8
  store i64 12, ptr %t29.slot, align 8
  ; %t1[%t29] = %t28  ; i64
  store i64 2162078206, ptr %t30.slot, align 8
  store i64 13, ptr %t31.slot, align 8
  ; %t1[%t31] = %t30  ; i64
  store i64 2614888103, ptr %t32.slot, align 8
  store i64 14, ptr %t33.slot, align 8
  ; %t1[%t33] = %t32  ; i64
  store i64 3248222580, ptr %t34.slot, align 8
  store i64 15, ptr %t35.slot, align 8
  ; %t1[%t35] = %t34  ; i64
  store i64 3835390401, ptr %t36.slot, align 8
  store i64 16, ptr %t37.slot, align 8
  ; %t1[%t37] = %t36  ; i64
  store i64 4022224774, ptr %t38.slot, align 8
  store i64 17, ptr %t39.slot, align 8
  ; %t1[%t39] = %t38  ; i64
  store i64 264347078, ptr %t40.slot, align 8
  store i64 18, ptr %t41.slot, align 8
  ; %t1[%t41] = %t40  ; i64
  store i64 604807628, ptr %t42.slot, align 8
  store i64 19, ptr %t43.slot, align 8
  ; %t1[%t43] = %t42  ; i64
  store i64 770255983, ptr %t44.slot, align 8
  store i64 20, ptr %t45.slot, align 8
  ; %t1[%t45] = %t44  ; i64
  store i64 1249150122, ptr %t46.slot, align 8
  store i64 21, ptr %t47.slot, align 8
  ; %t1[%t47] = %t46  ; i64
  store i64 1555081692, ptr %t48.slot, align 8
  store i64 22, ptr %t49.slot, align 8
  ; %t1[%t49] = %t48  ; i64
  store i64 1996064986, ptr %t50.slot, align 8
  store i64 23, ptr %t51.slot, align 8
  ; %t1[%t51] = %t50  ; i64
  store i64 2554220882, ptr %t52.slot, align 8
  store i64 24, ptr %t53.slot, align 8
  ; %t1[%t53] = %t52  ; i64
  store i64 2821834349, ptr %t54.slot, align 8
  store i64 25, ptr %t55.slot, align 8
  ; %t1[%t55] = %t54  ; i64
  store i64 2952996808, ptr %t56.slot, align 8
  store i64 26, ptr %t57.slot, align 8
  ; %t1[%t57] = %t56  ; i64
  store i64 3210313671, ptr %t58.slot, align 8
  store i64 27, ptr %t59.slot, align 8
  ; %t1[%t59] = %t58  ; i64
  store i64 3336571891, ptr %t60.slot, align 8
  store i64 28, ptr %t61.slot, align 8
  ; %t1[%t61] = %t60  ; i64
  store i64 3584528711, ptr %t62.slot, align 8
  store i64 29, ptr %t63.slot, align 8
  ; %t1[%t63] = %t62  ; i64
  store i64 113926993, ptr %t64.slot, align 8
  store i64 30, ptr %t65.slot, align 8
  ; %t1[%t65] = %t64  ; i64
  store i64 338241895, ptr %t66.slot, align 8
  store i64 31, ptr %t67.slot, align 8
  ; %t1[%t67] = %t66  ; i64
  store i64 666307205, ptr %t68.slot, align 8
  store i64 32, ptr %t69.slot, align 8
  ; %t1[%t69] = %t68  ; i64
  store i64 773529912, ptr %t70.slot, align 8
  store i64 33, ptr %t71.slot, align 8
  ; %t1[%t71] = %t70  ; i64
  store i64 1294757372, ptr %t72.slot, align 8
  store i64 34, ptr %t73.slot, align 8
  ; %t1[%t73] = %t72  ; i64
  store i64 1396182291, ptr %t74.slot, align 8
  store i64 35, ptr %t75.slot, align 8
  ; %t1[%t75] = %t74  ; i64
  store i64 1695183700, ptr %t76.slot, align 8
  store i64 36, ptr %t77.slot, align 8
  ; %t1[%t77] = %t76  ; i64
  store i64 1986661051, ptr %t78.slot, align 8
  store i64 37, ptr %t79.slot, align 8
  ; %t1[%t79] = %t78  ; i64
  store i64 2177026350, ptr %t80.slot, align 8
  store i64 38, ptr %t81.slot, align 8
  ; %t1[%t81] = %t80  ; i64
  store i64 2456956037, ptr %t82.slot, align 8
  store i64 39, ptr %t83.slot, align 8
  ; %t1[%t83] = %t82  ; i64
  store i64 2730485921, ptr %t84.slot, align 8
  store i64 40, ptr %t85.slot, align 8
  ; %t1[%t85] = %t84  ; i64
  store i64 2820302411, ptr %t86.slot, align 8
  store i64 41, ptr %t87.slot, align 8
  ; %t1[%t87] = %t86  ; i64
  store i64 3259730800, ptr %t88.slot, align 8
  store i64 42, ptr %t89.slot, align 8
  ; %t1[%t89] = %t88  ; i64
  store i64 3345764771, ptr %t90.slot, align 8
  store i64 43, ptr %t91.slot, align 8
  ; %t1[%t91] = %t90  ; i64
  store i64 3516065817, ptr %t92.slot, align 8
  store i64 44, ptr %t93.slot, align 8
  ; %t1[%t93] = %t92  ; i64
  store i64 3600352804, ptr %t94.slot, align 8
  store i64 45, ptr %t95.slot, align 8
  ; %t1[%t95] = %t94  ; i64
  store i64 4094571909, ptr %t96.slot, align 8
  store i64 46, ptr %t97.slot, align 8
  ; %t1[%t97] = %t96  ; i64
  store i64 275423344, ptr %t98.slot, align 8
  store i64 47, ptr %t99.slot, align 8
  ; %t1[%t99] = %t98  ; i64
  store i64 430227734, ptr %t100.slot, align 8
  store i64 48, ptr %t101.slot, align 8
  ; %t1[%t101] = %t100  ; i64
  store i64 506948616, ptr %t102.slot, align 8
  store i64 49, ptr %t103.slot, align 8
  ; %t1[%t103] = %t102  ; i64
  store i64 659060556, ptr %t104.slot, align 8
  store i64 50, ptr %t105.slot, align 8
  ; %t1[%t105] = %t104  ; i64
  store i64 883997877, ptr %t106.slot, align 8
  store i64 51, ptr %t107.slot, align 8
  ; %t1[%t107] = %t106  ; i64
  store i64 958139571, ptr %t108.slot, align 8
  store i64 52, ptr %t109.slot, align 8
  ; %t1[%t109] = %t108  ; i64
  store i64 1322822218, ptr %t110.slot, align 8
  store i64 53, ptr %t111.slot, align 8
  ; %t1[%t111] = %t110  ; i64
  store i64 1537002063, ptr %t112.slot, align 8
  store i64 54, ptr %t113.slot, align 8
  ; %t1[%t113] = %t112  ; i64
  store i64 1747873779, ptr %t114.slot, align 8
  store i64 55, ptr %t115.slot, align 8
  ; %t1[%t115] = %t114  ; i64
  store i64 1955562222, ptr %t116.slot, align 8
  store i64 56, ptr %t117.slot, align 8
  ; %t1[%t117] = %t116  ; i64
  store i64 2024104815, ptr %t118.slot, align 8
  store i64 57, ptr %t119.slot, align 8
  ; %t1[%t119] = %t118  ; i64
  store i64 2227730452, ptr %t120.slot, align 8
  store i64 58, ptr %t121.slot, align 8
  ; %t1[%t121] = %t120  ; i64
  store i64 2361852424, ptr %t122.slot, align 8
  store i64 59, ptr %t123.slot, align 8
  ; %t1[%t123] = %t122  ; i64
  store i64 2428436474, ptr %t124.slot, align 8
  store i64 60, ptr %t125.slot, align 8
  ; %t1[%t125] = %t124  ; i64
  store i64 2756734187, ptr %t126.slot, align 8
  store i64 61, ptr %t127.slot, align 8
  ; %t1[%t127] = %t126  ; i64
  store i64 3204031479, ptr %t128.slot, align 8
  store i64 62, ptr %t129.slot, align 8
  ; %t1[%t129] = %t128  ; i64
  store i64 3329325298, ptr %t130.slot, align 8
  store i64 63, ptr %t131.slot, align 8
  ; %t1[%t131] = %t130  ; i64
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %k.slot, align 8
  %r2 = load ptr, ptr %k.slot, align 8
  ret ptr %r2
ret_cont_2:
  ret ptr 0
}

define dso_local ptr @sha256_buffer(ptr %buf_in.arg, i64 %msg_len.arg) #0 {
entry:
  %buf_in.slot = alloca ptr, align 8
  %msg_len.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %bit_len.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %k_blocks.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %total_bytes.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %buf.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %shift.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca ptr, align 8
  %K.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %H.slot = alloca ptr, align 8
  %t54.slot = alloca ptr, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %W.slot = alloca ptr, align 8
  %t57.slot = alloca i64, align 8
  %chunk.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %base.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %t.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca i64, align 8
  %b0.slot = alloca i64, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %b1.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %b2.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %b3.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %x.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca i64, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  %t112.slot = alloca i64, align 8
  %s0.slot = alloca i64, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca i64, align 8
  %t115.slot = alloca i64, align 8
  %y.slot = alloca i64, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca i64, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca i64, align 8
  %t120.slot = alloca i64, align 8
  %t121.slot = alloca i64, align 8
  %t122.slot = alloca i64, align 8
  %t123.slot = alloca i64, align 8
  %s1.slot = alloca i64, align 8
  %t124.slot = alloca i64, align 8
  %t125.slot = alloca i64, align 8
  %t126.slot = alloca i64, align 8
  %t127.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca i64, align 8
  %t132.slot = alloca i64, align 8
  %t133.slot = alloca i64, align 8
  %t134.slot = alloca i64, align 8
  %t135.slot = alloca i64, align 8
  %t136.slot = alloca i64, align 8
  %t137.slot = alloca i64, align 8
  %t138.slot = alloca i64, align 8
  %a.slot = alloca i64, align 8
  %t139.slot = alloca i64, align 8
  %t140.slot = alloca i64, align 8
  %b.slot = alloca i64, align 8
  %t141.slot = alloca i64, align 8
  %t142.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t143.slot = alloca i64, align 8
  %t144.slot = alloca i64, align 8
  %d.slot = alloca i64, align 8
  %t145.slot = alloca i64, align 8
  %t146.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
  %t147.slot = alloca i64, align 8
  %t148.slot = alloca i64, align 8
  %f.slot = alloca i64, align 8
  %t149.slot = alloca i64, align 8
  %t150.slot = alloca i64, align 8
  %g.slot = alloca i64, align 8
  %t151.slot = alloca i64, align 8
  %t152.slot = alloca i64, align 8
  %h.slot = alloca i64, align 8
  %t153.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t154.slot = alloca i64, align 8
  %t155.slot = alloca i64, align 8
  %t156.slot = alloca i64, align 8
  %t157.slot = alloca i64, align 8
  %t158.slot = alloca i64, align 8
  %t159.slot = alloca i64, align 8
  %t160.slot = alloca i64, align 8
  %t161.slot = alloca i64, align 8
  %t162.slot = alloca i64, align 8
  %t163.slot = alloca i64, align 8
  %S1.slot = alloca i64, align 8
  %t164.slot = alloca i64, align 8
  %t165.slot = alloca i64, align 8
  %t166.slot = alloca i64, align 8
  %t167.slot = alloca i64, align 8
  %ch.slot = alloca i64, align 8
  %t168.slot = alloca i64, align 8
  %t169.slot = alloca i64, align 8
  %t170.slot = alloca i64, align 8
  %t171.slot = alloca i64, align 8
  %t172.slot = alloca i64, align 8
  %t173.slot = alloca i64, align 8
  %t174.slot = alloca i64, align 8
  %t175.slot = alloca i64, align 8
  %T1.slot = alloca i64, align 8
  %t176.slot = alloca i64, align 8
  %t177.slot = alloca i64, align 8
  %t178.slot = alloca i64, align 8
  %t179.slot = alloca i64, align 8
  %t180.slot = alloca i64, align 8
  %t181.slot = alloca i64, align 8
  %t182.slot = alloca i64, align 8
  %t183.slot = alloca i64, align 8
  %S0.slot = alloca i64, align 8
  %t184.slot = alloca i64, align 8
  %t185.slot = alloca i64, align 8
  %t186.slot = alloca i64, align 8
  %t187.slot = alloca i64, align 8
  %t188.slot = alloca i64, align 8
  %maj.slot = alloca i64, align 8
  %t189.slot = alloca i64, align 8
  %t190.slot = alloca i64, align 8
  %t191.slot = alloca i64, align 8
  %T2.slot = alloca i64, align 8
  %t192.slot = alloca i64, align 8
  %t193.slot = alloca i64, align 8
  %t194.slot = alloca i64, align 8
  %t195.slot = alloca i64, align 8
  %t196.slot = alloca i64, align 8
  %t197.slot = alloca i64, align 8
  %t198.slot = alloca i64, align 8
  %t199.slot = alloca i64, align 8
  %t200.slot = alloca i64, align 8
  %t201.slot = alloca i64, align 8
  %t202.slot = alloca i64, align 8
  %t203.slot = alloca i64, align 8
  %t204.slot = alloca i64, align 8
  %t205.slot = alloca i64, align 8
  %t206.slot = alloca i64, align 8
  %t207.slot = alloca i64, align 8
  %t208.slot = alloca i64, align 8
  %t209.slot = alloca i64, align 8
  %t210.slot = alloca i64, align 8
  %t211.slot = alloca i64, align 8
  %t212.slot = alloca i64, align 8
  %t213.slot = alloca i64, align 8
  %t214.slot = alloca i64, align 8
  %t215.slot = alloca i64, align 8
  %t216.slot = alloca i64, align 8
  %t217.slot = alloca i64, align 8
  %t218.slot = alloca i64, align 8
  %t219.slot = alloca i64, align 8
  %t220.slot = alloca i64, align 8
  %t221.slot = alloca i64, align 8
  %t222.slot = alloca i64, align 8
  %t223.slot = alloca i64, align 8
  %t224.slot = alloca i64, align 8
  %t225.slot = alloca i64, align 8
  %t226.slot = alloca i64, align 8
  %t227.slot = alloca i64, align 8
  %t228.slot = alloca i64, align 8
  %t229.slot = alloca i64, align 8
  %t230.slot = alloca i64, align 8
  %t231.slot = alloca i64, align 8
  %t232.slot = alloca i64, align 8
  %t233.slot = alloca i64, align 8
  %t234.slot = alloca i64, align 8
  %t235.slot = alloca i64, align 8
  %t236.slot = alloca i64, align 8
  %t237.slot = alloca i64, align 8
  %t238.slot = alloca i64, align 8
  %t239.slot = alloca i64, align 8
  %t240.slot = alloca i64, align 8
  %t241.slot = alloca i64, align 8
  %t242.slot = alloca i64, align 8
  %t243.slot = alloca i64, align 8
  %t244.slot = alloca i64, align 8
  %t245.slot = alloca i64, align 8
  %t246.slot = alloca i64, align 8
  %t247.slot = alloca i64, align 8
  %t248.slot = alloca i64, align 8
  %t249.slot = alloca i64, align 8
  store ptr %buf_in.arg, ptr %buf_in.slot, align 8
  store i64 %msg_len.arg, ptr %msg_len.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 8, ptr %t1.slot, align 8
  ; %t2:i64 = mul_i64 msg_len, %t1
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %bit_len.slot, align 8
  store i64 9, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 msg_len, %t3
  store i64 63, ptr %t5.slot, align 8
  ; %t6:i64 = add_i64 %t4, %t5
  store i64 64, ptr %t7.slot, align 8
  ; %t8:i64 = div_i64 %t6, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  store i64 %r2, ptr %k_blocks.slot, align 8
  store i64 64, ptr %t9.slot, align 8
  ; %t10:i64 = mul_i64 k_blocks, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  store i64 %r3, ptr %total_bytes.slot, align 8
  store i64 0, ptr %t12.slot, align 8
  ; %t11:Array[i64] = alloc_array(total_bytes, init=%t12)
  %r4 = load ptr, ptr %t11.slot, align 8
  store ptr %r4, ptr %buf.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  %r5 = load i64, ptr %t13.slot, align 8
  store i64 %r5, ptr %i.slot, align 8
  br label %while_cond_10
while_cond_10:
  ; %t14:bool = cmp_lt_i64 i, msg_len
  %r6 = load i64, ptr %t14.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %while_end_11, label %fall_7
fall_7:
  ; %t15:i64 = buf_in[i]
  store i64 255, ptr %t16.slot, align 8
  ; %t17:i64 = and_i64 %t15, %t16
  ; buf[i] = %t17  ; i64
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = add_i64 i, %t18
  %r8 = load i64, ptr %t19.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %while_cond_10
dead_r9:
  br label %while_end_11
while_end_11:
  store i64 128, ptr %t20.slot, align 8
  ; buf[msg_len] = %t20  ; i64
  store i64 0, ptr %t21.slot, align 8
  %r10 = load i64, ptr %t21.slot, align 8
  store i64 %r10, ptr %j.slot, align 8
  br label %while_cond_12
while_cond_12:
  store i64 8, ptr %t22.slot, align 8
  ; %t23:bool = cmp_lt_i64 j, %t22
  %r11 = load i64, ptr %t23.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %while_end_13, label %fall_12
fall_12:
  store i64 8, ptr %t24.slot, align 8
  ; %t25:i64 = mul_i64 j, %t24
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %shift.slot, align 8
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = sub_i64 total_bytes, %t26
  ; %t28:i64 = sub_i64 %t27, j
  ; %t29:i64 = shr_i64 bit_len, shift
  store i64 255, ptr %t30.slot, align 8
  ; %t31:i64 = and_i64 %t29, %t30
  ; buf[%t28] = %t31  ; i64
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = add_i64 j, %t32
  %r14 = load i64, ptr %t33.slot, align 8
  store i64 %r14, ptr %j.slot, align 8
  br label %while_cond_12
dead_r15:
  br label %while_end_13
while_end_13:
  ; %t34:Array[i64] = call sha256_k()
  %r16 = load ptr, ptr %t34.slot, align 8
  store ptr %r16, ptr %K.slot, align 8
  store i64 8, ptr %t36.slot, align 8
  store i64 0, ptr %t37.slot, align 8
  ; %t35:Array[i64] = alloc_array(%t36, init=%t37)
  store i64 1779033703, ptr %t38.slot, align 8
  store i64 0, ptr %t39.slot, align 8
  ; %t35[%t39] = %t38  ; i64
  store i64 3144134277, ptr %t40.slot, align 8
  store i64 1, ptr %t41.slot, align 8
  ; %t35[%t41] = %t40  ; i64
  store i64 1013904242, ptr %t42.slot, align 8
  store i64 2, ptr %t43.slot, align 8
  ; %t35[%t43] = %t42  ; i64
  store i64 2773480762, ptr %t44.slot, align 8
  store i64 3, ptr %t45.slot, align 8
  ; %t35[%t45] = %t44  ; i64
  store i64 1359893119, ptr %t46.slot, align 8
  store i64 4, ptr %t47.slot, align 8
  ; %t35[%t47] = %t46  ; i64
  store i64 2600822924, ptr %t48.slot, align 8
  store i64 5, ptr %t49.slot, align 8
  ; %t35[%t49] = %t48  ; i64
  store i64 528734635, ptr %t50.slot, align 8
  store i64 6, ptr %t51.slot, align 8
  ; %t35[%t51] = %t50  ; i64
  store i64 1541459225, ptr %t52.slot, align 8
  store i64 7, ptr %t53.slot, align 8
  ; %t35[%t53] = %t52  ; i64
  %r17 = load ptr, ptr %t35.slot, align 8
  store ptr %r17, ptr %H.slot, align 8
  store i64 64, ptr %t55.slot, align 8
  store i64 0, ptr %t56.slot, align 8
  ; %t54:Array[i64] = alloc_array(%t55, init=%t56)
  %r18 = load ptr, ptr %t54.slot, align 8
  store ptr %r18, ptr %W.slot, align 8
  store i64 0, ptr %t57.slot, align 8
  %r19 = load i64, ptr %t57.slot, align 8
  store i64 %r19, ptr %chunk.slot, align 8
  br label %while_cond_14
while_cond_14:
  ; %t58:bool = cmp_lt_i64 chunk, k_blocks
  %r20 = load i64, ptr %t58.slot, align 8
  %r21 = icmp eq i64 %r20, 0
  br i1 %r21, label %while_end_15, label %fall_21
fall_21:
  store i64 64, ptr %t59.slot, align 8
  ; %t60:i64 = mul_i64 chunk, %t59
  %r22 = load i64, ptr %t60.slot, align 8
  store i64 %r22, ptr %base.slot, align 8
  store i64 0, ptr %t61.slot, align 8
  %r23 = load i64, ptr %t61.slot, align 8
  store i64 %r23, ptr %t.slot, align 8
  br label %while_cond_16
while_cond_16:
  store i64 16, ptr %t62.slot, align 8
  ; %t63:bool = cmp_lt_i64 t, %t62
  %r24 = load i64, ptr %t63.slot, align 8
  %r25 = icmp eq i64 %r24, 0
  br i1 %r25, label %while_end_17, label %fall_25
fall_25:
  store i64 4, ptr %t64.slot, align 8
  ; %t65:i64 = mul_i64 t, %t64
  ; %t66:i64 = add_i64 base, %t65
  ; %t67:i64 = buf[%t66]
  %r26 = load i64, ptr %t67.slot, align 8
  store i64 %r26, ptr %b0.slot, align 8
  store i64 4, ptr %t68.slot, align 8
  ; %t69:i64 = mul_i64 t, %t68
  ; %t70:i64 = add_i64 base, %t69
  store i64 1, ptr %t71.slot, align 8
  ; %t72:i64 = add_i64 %t70, %t71
  ; %t73:i64 = buf[%t72]
  %r27 = load i64, ptr %t73.slot, align 8
  store i64 %r27, ptr %b1.slot, align 8
  store i64 4, ptr %t74.slot, align 8
  ; %t75:i64 = mul_i64 t, %t74
  ; %t76:i64 = add_i64 base, %t75
  store i64 2, ptr %t77.slot, align 8
  ; %t78:i64 = add_i64 %t76, %t77
  ; %t79:i64 = buf[%t78]
  %r28 = load i64, ptr %t79.slot, align 8
  store i64 %r28, ptr %b2.slot, align 8
  store i64 4, ptr %t80.slot, align 8
  ; %t81:i64 = mul_i64 t, %t80
  ; %t82:i64 = add_i64 base, %t81
  store i64 3, ptr %t83.slot, align 8
  ; %t84:i64 = add_i64 %t82, %t83
  ; %t85:i64 = buf[%t84]
  %r29 = load i64, ptr %t85.slot, align 8
  store i64 %r29, ptr %b3.slot, align 8
  store i64 24, ptr %t86.slot, align 8
  ; %t87:i64 = shl_i64 b0, %t86
  store i64 16, ptr %t88.slot, align 8
  ; %t89:i64 = shl_i64 b1, %t88
  ; %t90:i64 = or_i64 %t87, %t89
  store i64 8, ptr %t91.slot, align 8
  ; %t92:i64 = shl_i64 b2, %t91
  ; %t93:i64 = or_i64 %t90, %t92
  ; %t94:i64 = or_i64 %t93, b3
  store i64 4294967295, ptr %t95.slot, align 8
  ; %t96:i64 = and_i64 %t94, %t95
  ; W[t] = %t96  ; i64
  store i64 1, ptr %t97.slot, align 8
  ; %t98:i64 = add_i64 t, %t97
  %r30 = load i64, ptr %t98.slot, align 8
  store i64 %r30, ptr %t.slot, align 8
  br label %while_cond_16
dead_r31:
  br label %while_end_17
while_end_17:
  store i64 16, ptr %t99.slot, align 8
  %r32 = load i64, ptr %t99.slot, align 8
  store i64 %r32, ptr %t2.slot, align 8
  br label %while_cond_18
while_cond_18:
  store i64 64, ptr %t100.slot, align 8
  ; %t101:bool = cmp_lt_i64 t2, %t100
  %r33 = load i64, ptr %t101.slot, align 8
  %r34 = icmp eq i64 %r33, 0
  br i1 %r34, label %while_end_19, label %fall_34
fall_34:
  store i64 15, ptr %t102.slot, align 8
  ; %t103:i64 = sub_i64 t2, %t102
  ; %t104:i64 = W[%t103]
  %r35 = load i64, ptr %t104.slot, align 8
  store i64 %r35, ptr %x.slot, align 8
  store i64 7, ptr %t105.slot, align 8
  ; %t106:i64 = call rotr32(x, %t105)
  store i64 18, ptr %t107.slot, align 8
  ; %t108:i64 = call rotr32(x, %t107)
  ; %t109:i64 = xor_i64 %t106, %t108
  store i64 3, ptr %t110.slot, align 8
  ; %t111:i64 = shr_i64 x, %t110
  ; %t112:i64 = xor_i64 %t109, %t111
  %r36 = load i64, ptr %t112.slot, align 8
  store i64 %r36, ptr %s0.slot, align 8
  store i64 2, ptr %t113.slot, align 8
  ; %t114:i64 = sub_i64 t2, %t113
  ; %t115:i64 = W[%t114]
  %r37 = load i64, ptr %t115.slot, align 8
  store i64 %r37, ptr %y.slot, align 8
  store i64 17, ptr %t116.slot, align 8
  ; %t117:i64 = call rotr32(y, %t116)
  store i64 19, ptr %t118.slot, align 8
  ; %t119:i64 = call rotr32(y, %t118)
  ; %t120:i64 = xor_i64 %t117, %t119
  store i64 10, ptr %t121.slot, align 8
  ; %t122:i64 = shr_i64 y, %t121
  ; %t123:i64 = xor_i64 %t120, %t122
  %r38 = load i64, ptr %t123.slot, align 8
  store i64 %r38, ptr %s1.slot, align 8
  store i64 16, ptr %t124.slot, align 8
  ; %t125:i64 = sub_i64 t2, %t124
  ; %t126:i64 = W[%t125]
  ; %t127:i64 = add_i64 %t126, s0
  store i64 7, ptr %t128.slot, align 8
  ; %t129:i64 = sub_i64 t2, %t128
  ; %t130:i64 = W[%t129]
  ; %t131:i64 = add_i64 %t127, %t130
  ; %t132:i64 = add_i64 %t131, s1
  store i64 4294967295, ptr %t133.slot, align 8
  ; %t134:i64 = and_i64 %t132, %t133
  ; W[t2] = %t134  ; i64
  store i64 1, ptr %t135.slot, align 8
  ; %t136:i64 = add_i64 t2, %t135
  %r39 = load i64, ptr %t136.slot, align 8
  store i64 %r39, ptr %t2.slot, align 8
  br label %while_cond_18
dead_r40:
  br label %while_end_19
while_end_19:
  store i64 0, ptr %t137.slot, align 8
  ; %t138:i64 = H[%t137]
  %r41 = load i64, ptr %t138.slot, align 8
  store i64 %r41, ptr %a.slot, align 8
  store i64 1, ptr %t139.slot, align 8
  ; %t140:i64 = H[%t139]
  %r42 = load i64, ptr %t140.slot, align 8
  store i64 %r42, ptr %b.slot, align 8
  store i64 2, ptr %t141.slot, align 8
  ; %t142:i64 = H[%t141]
  %r43 = load i64, ptr %t142.slot, align 8
  store i64 %r43, ptr %c.slot, align 8
  store i64 3, ptr %t143.slot, align 8
  ; %t144:i64 = H[%t143]
  %r44 = load i64, ptr %t144.slot, align 8
  store i64 %r44, ptr %d.slot, align 8
  store i64 4, ptr %t145.slot, align 8
  ; %t146:i64 = H[%t145]
  %r45 = load i64, ptr %t146.slot, align 8
  store i64 %r45, ptr %e.slot, align 8
  store i64 5, ptr %t147.slot, align 8
  ; %t148:i64 = H[%t147]
  %r46 = load i64, ptr %t148.slot, align 8
  store i64 %r46, ptr %f.slot, align 8
  store i64 6, ptr %t149.slot, align 8
  ; %t150:i64 = H[%t149]
  %r47 = load i64, ptr %t150.slot, align 8
  store i64 %r47, ptr %g.slot, align 8
  store i64 7, ptr %t151.slot, align 8
  ; %t152:i64 = H[%t151]
  %r48 = load i64, ptr %t152.slot, align 8
  store i64 %r48, ptr %h.slot, align 8
  store i64 0, ptr %t153.slot, align 8
  %r49 = load i64, ptr %t153.slot, align 8
  store i64 %r49, ptr %t3.slot, align 8
  br label %while_cond_20
while_cond_20:
  store i64 64, ptr %t154.slot, align 8
  ; %t155:bool = cmp_lt_i64 t3, %t154
  %r50 = load i64, ptr %t155.slot, align 8
  %r51 = icmp eq i64 %r50, 0
  br i1 %r51, label %while_end_21, label %fall_51
fall_51:
  store i64 6, ptr %t156.slot, align 8
  ; %t157:i64 = call rotr32(e, %t156)
  store i64 11, ptr %t158.slot, align 8
  ; %t159:i64 = call rotr32(e, %t158)
  ; %t160:i64 = xor_i64 %t157, %t159
  store i64 25, ptr %t161.slot, align 8
  ; %t162:i64 = call rotr32(e, %t161)
  ; %t163:i64 = xor_i64 %t160, %t162
  %r52 = load i64, ptr %t163.slot, align 8
  store i64 %r52, ptr %S1.slot, align 8
  ; %t164:i64 = and_i64 e, f
  ; %t165:i64 = not_i64 e
  ; %t166:i64 = and_i64 %t165, g
  ; %t167:i64 = xor_i64 %t164, %t166
  %r53 = load i64, ptr %t167.slot, align 8
  store i64 %r53, ptr %ch.slot, align 8
  ; %t168:i64 = add_i64 h, S1
  ; %t169:i64 = add_i64 %t168, ch
  ; %t170:i64 = K[t3]
  ; %t171:i64 = add_i64 %t169, %t170
  ; %t172:i64 = W[t3]
  ; %t173:i64 = add_i64 %t171, %t172
  store i64 4294967295, ptr %t174.slot, align 8
  ; %t175:i64 = and_i64 %t173, %t174
  %r54 = load i64, ptr %t175.slot, align 8
  store i64 %r54, ptr %T1.slot, align 8
  store i64 2, ptr %t176.slot, align 8
  ; %t177:i64 = call rotr32(a, %t176)
  store i64 13, ptr %t178.slot, align 8
  ; %t179:i64 = call rotr32(a, %t178)
  ; %t180:i64 = xor_i64 %t177, %t179
  store i64 22, ptr %t181.slot, align 8
  ; %t182:i64 = call rotr32(a, %t181)
  ; %t183:i64 = xor_i64 %t180, %t182
  %r55 = load i64, ptr %t183.slot, align 8
  store i64 %r55, ptr %S0.slot, align 8
  ; %t184:i64 = and_i64 a, b
  ; %t185:i64 = and_i64 a, c
  ; %t186:i64 = xor_i64 %t184, %t185
  ; %t187:i64 = and_i64 b, c
  ; %t188:i64 = xor_i64 %t186, %t187
  %r56 = load i64, ptr %t188.slot, align 8
  store i64 %r56, ptr %maj.slot, align 8
  ; %t189:i64 = add_i64 S0, maj
  store i64 4294967295, ptr %t190.slot, align 8
  ; %t191:i64 = and_i64 %t189, %t190
  %r57 = load i64, ptr %t191.slot, align 8
  store i64 %r57, ptr %T2.slot, align 8
  %r58 = load i64, ptr %g.slot, align 8
  store i64 %r58, ptr %h.slot, align 8
  %r59 = load i64, ptr %f.slot, align 8
  store i64 %r59, ptr %g.slot, align 8
  %r60 = load i64, ptr %e.slot, align 8
  store i64 %r60, ptr %f.slot, align 8
  ; %t192:i64 = add_i64 d, T1
  store i64 4294967295, ptr %t193.slot, align 8
  ; %t194:i64 = and_i64 %t192, %t193
  %r61 = load i64, ptr %t194.slot, align 8
  store i64 %r61, ptr %e.slot, align 8
  %r62 = load i64, ptr %c.slot, align 8
  store i64 %r62, ptr %d.slot, align 8
  %r63 = load i64, ptr %b.slot, align 8
  store i64 %r63, ptr %c.slot, align 8
  %r64 = load i64, ptr %a.slot, align 8
  store i64 %r64, ptr %b.slot, align 8
  ; %t195:i64 = add_i64 T1, T2
  store i64 4294967295, ptr %t196.slot, align 8
  ; %t197:i64 = and_i64 %t195, %t196
  %r65 = load i64, ptr %t197.slot, align 8
  store i64 %r65, ptr %a.slot, align 8
  store i64 1, ptr %t198.slot, align 8
  ; %t199:i64 = add_i64 t3, %t198
  %r66 = load i64, ptr %t199.slot, align 8
  store i64 %r66, ptr %t3.slot, align 8
  br label %while_cond_20
dead_r67:
  br label %while_end_21
while_end_21:
  store i64 0, ptr %t200.slot, align 8
  store i64 0, ptr %t201.slot, align 8
  ; %t202:i64 = H[%t201]
  ; %t203:i64 = add_i64 %t202, a
  store i64 4294967295, ptr %t204.slot, align 8
  ; %t205:i64 = and_i64 %t203, %t204
  ; H[%t200] = %t205  ; i64
  store i64 1, ptr %t206.slot, align 8
  store i64 1, ptr %t207.slot, align 8
  ; %t208:i64 = H[%t207]
  ; %t209:i64 = add_i64 %t208, b
  store i64 4294967295, ptr %t210.slot, align 8
  ; %t211:i64 = and_i64 %t209, %t210
  ; H[%t206] = %t211  ; i64
  store i64 2, ptr %t212.slot, align 8
  store i64 2, ptr %t213.slot, align 8
  ; %t214:i64 = H[%t213]
  ; %t215:i64 = add_i64 %t214, c
  store i64 4294967295, ptr %t216.slot, align 8
  ; %t217:i64 = and_i64 %t215, %t216
  ; H[%t212] = %t217  ; i64
  store i64 3, ptr %t218.slot, align 8
  store i64 3, ptr %t219.slot, align 8
  ; %t220:i64 = H[%t219]
  ; %t221:i64 = add_i64 %t220, d
  store i64 4294967295, ptr %t222.slot, align 8
  ; %t223:i64 = and_i64 %t221, %t222
  ; H[%t218] = %t223  ; i64
  store i64 4, ptr %t224.slot, align 8
  store i64 4, ptr %t225.slot, align 8
  ; %t226:i64 = H[%t225]
  ; %t227:i64 = add_i64 %t226, e
  store i64 4294967295, ptr %t228.slot, align 8
  ; %t229:i64 = and_i64 %t227, %t228
  ; H[%t224] = %t229  ; i64
  store i64 5, ptr %t230.slot, align 8
  store i64 5, ptr %t231.slot, align 8
  ; %t232:i64 = H[%t231]
  ; %t233:i64 = add_i64 %t232, f
  store i64 4294967295, ptr %t234.slot, align 8
  ; %t235:i64 = and_i64 %t233, %t234
  ; H[%t230] = %t235  ; i64
  store i64 6, ptr %t236.slot, align 8
  store i64 6, ptr %t237.slot, align 8
  ; %t238:i64 = H[%t237]
  ; %t239:i64 = add_i64 %t238, g
  store i64 4294967295, ptr %t240.slot, align 8
  ; %t241:i64 = and_i64 %t239, %t240
  ; H[%t236] = %t241  ; i64
  store i64 7, ptr %t242.slot, align 8
  store i64 7, ptr %t243.slot, align 8
  ; %t244:i64 = H[%t243]
  ; %t245:i64 = add_i64 %t244, h
  store i64 4294967295, ptr %t246.slot, align 8
  ; %t247:i64 = and_i64 %t245, %t246
  ; H[%t242] = %t247  ; i64
  store i64 1, ptr %t248.slot, align 8
  ; %t249:i64 = add_i64 chunk, %t248
  %r68 = load i64, ptr %t249.slot, align 8
  store i64 %r68, ptr %chunk.slot, align 8
  br label %while_cond_14
dead_r69:
  br label %while_end_15
while_end_15:
  %r70 = load ptr, ptr %H.slot, align 8
  ret ptr %r70
ret_cont_70:
  ret ptr 0
}

define dso_local ptr @sha256_digest(ptr %msg.arg) #0 {
entry:
  %msg.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %msg_len.slot = alloca i64, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca i64, align 8
  %buf_in.slot = alloca ptr, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = str_len(msg)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %msg_len.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t2:Array[i64] = alloc_array(msg_len, init=%t3)
  %r2 = load ptr, ptr %t2.slot, align 8
  store ptr %r2, ptr %buf_in.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  %r3 = load i64, ptr %t4.slot, align 8
  store i64 %r3, ptr %i.slot, align 8
  br label %while_cond_22
while_cond_22:
  ; %t5:bool = cmp_lt_i64 i, msg_len
  %r4 = load i64, ptr %t5.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %while_end_23, label %fall_5
fall_5:
  ; %t6:str = str_index(msg[i])
  ; %t7:i64 = str_ord %t6
  ; buf_in[i] = %t7  ; i64
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = add_i64 i, %t8
  %r6 = load i64, ptr %t9.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %while_cond_22
dead_r7:
  br label %while_end_23
while_end_23:
  ; %t10:Array[i64] = call sha256_buffer(buf_in, msg_len)
  %r8 = load ptr, ptr %t10.slot, align 8
  ret ptr %r8
ret_cont_8:
  ret ptr 0
}

define dso_local ptr @sha256(ptr %msg.arg) #0 {
entry:
  %msg.slot = alloca ptr, align 8
  %t1.slot = alloca ptr, align 8
  %digest.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:Array[i64] = call sha256_digest(msg)
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %digest.slot, align 8
  ; %t2:str = call hex256(digest)
  %r2 = load ptr, ptr %t2.slot, align 8
  ret ptr %r2
ret_cont_2:
  ret ptr 0
}

define dso_local ptr @hmac_sha256_digest(ptr %key.arg, ptr %msg.arg) #0 {
entry:
  %key.slot = alloca ptr, align 8
  %msg.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %k_len.slot = alloca i64, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %key_block.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %kd.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %w.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %m_len.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %inner_len.slot = alloca i64, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca i64, align 8
  %inner_buf.slot = alloca ptr, align 8
  %t53.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %k.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca ptr, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca ptr, align 8
  %inner_digest.slot = alloca ptr, align 8
  %t70.slot = alloca ptr, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca i64, align 8
  %outer_buf.slot = alloca ptr, align 8
  %t73.slot = alloca i64, align 8
  %m.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %n.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca i64, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  %t112.slot = alloca i64, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca i64, align 8
  %t115.slot = alloca i64, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca i64, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca i64, align 8
  %t120.slot = alloca i64, align 8
  %t121.slot = alloca i64, align 8
  %t122.slot = alloca i64, align 8
  %t123.slot = alloca i64, align 8
  %t124.slot = alloca ptr, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = str_len(key)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %k_len.slot, align 8
  store i64 64, ptr %t3.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t2:Array[i64] = alloc_array(%t3, init=%t4)
  %r2 = load ptr, ptr %t2.slot, align 8
  store ptr %r2, ptr %key_block.slot, align 8
  store i64 64, ptr %t5.slot, align 8
  ; %t6:bool = cmp_gt_i64 k_len, %t5
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_next_25, label %fall_4
fall_4:
  ; %t7:Array[i64] = call sha256_digest(key)
  %r5 = load ptr, ptr %t7.slot, align 8
  store ptr %r5, ptr %kd.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  %r6 = load i64, ptr %t8.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %while_cond_26
while_cond_26:
  store i64 8, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 i, %t9
  %r7 = load i64, ptr %t10.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %while_end_27, label %fall_8
fall_8:
  ; %t11:i64 = kd[i]
  %r9 = load i64, ptr %t11.slot, align 8
  store i64 %r9, ptr %w.slot, align 8
  store i64 4, ptr %t12.slot, align 8
  ; %t13:i64 = mul_i64 i, %t12
  store i64 24, ptr %t14.slot, align 8
  ; %t15:i64 = shr_i64 w, %t14
  store i64 255, ptr %t16.slot, align 8
  ; %t17:i64 = and_i64 %t15, %t16
  ; key_block[%t13] = %t17  ; i64
  store i64 4, ptr %t18.slot, align 8
  ; %t19:i64 = mul_i64 i, %t18
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 %t19, %t20
  store i64 16, ptr %t22.slot, align 8
  ; %t23:i64 = shr_i64 w, %t22
  store i64 255, ptr %t24.slot, align 8
  ; %t25:i64 = and_i64 %t23, %t24
  ; key_block[%t21] = %t25  ; i64
  store i64 4, ptr %t26.slot, align 8
  ; %t27:i64 = mul_i64 i, %t26
  store i64 2, ptr %t28.slot, align 8
  ; %t29:i64 = add_i64 %t27, %t28
  store i64 8, ptr %t30.slot, align 8
  ; %t31:i64 = shr_i64 w, %t30
  store i64 255, ptr %t32.slot, align 8
  ; %t33:i64 = and_i64 %t31, %t32
  ; key_block[%t29] = %t33  ; i64
  store i64 4, ptr %t34.slot, align 8
  ; %t35:i64 = mul_i64 i, %t34
  store i64 3, ptr %t36.slot, align 8
  ; %t37:i64 = add_i64 %t35, %t36
  store i64 255, ptr %t38.slot, align 8
  ; %t39:i64 = and_i64 w, %t38
  ; key_block[%t37] = %t39  ; i64
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 i, %t40
  %r10 = load i64, ptr %t41.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %while_cond_26
dead_r11:
  br label %while_end_27
while_end_27:
  br label %if_end_24
dead_r12:
  br label %if_next_25
if_next_25:
  store i64 0, ptr %t42.slot, align 8
  %r13 = load i64, ptr %t42.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_28
while_cond_28:
  ; %t43:bool = cmp_lt_i64 i, k_len
  %r14 = load i64, ptr %t43.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_29, label %fall_15
fall_15:
  ; %t44:str = str_index(key[i])
  ; %t45:i64 = str_ord %t44
  ; key_block[i] = %t45  ; i64
  store i64 1, ptr %t46.slot, align 8
  ; %t47:i64 = add_i64 i, %t46
  %r16 = load i64, ptr %t47.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_28
dead_r17:
  br label %while_end_29
while_end_29:
  br label %if_end_24
if_end_24:
  ; %t48:i64 = str_len(msg)
  %r18 = load i64, ptr %t48.slot, align 8
  store i64 %r18, ptr %m_len.slot, align 8
  store i64 64, ptr %t49.slot, align 8
  ; %t50:i64 = add_i64 %t49, m_len
  %r19 = load i64, ptr %t50.slot, align 8
  store i64 %r19, ptr %inner_len.slot, align 8
  store i64 0, ptr %t52.slot, align 8
  ; %t51:Array[i64] = alloc_array(inner_len, init=%t52)
  %r20 = load ptr, ptr %t51.slot, align 8
  store ptr %r20, ptr %inner_buf.slot, align 8
  store i64 0, ptr %t53.slot, align 8
  %r21 = load i64, ptr %t53.slot, align 8
  store i64 %r21, ptr %j.slot, align 8
  br label %while_cond_30
while_cond_30:
  store i64 64, ptr %t54.slot, align 8
  ; %t55:bool = cmp_lt_i64 j, %t54
  %r22 = load i64, ptr %t55.slot, align 8
  %r23 = icmp eq i64 %r22, 0
  br i1 %r23, label %while_end_31, label %fall_23
fall_23:
  ; %t56:i64 = key_block[j]
  store i64 54, ptr %t57.slot, align 8
  ; %t58:i64 = xor_i64 %t56, %t57
  ; inner_buf[j] = %t58  ; i64
  store i64 1, ptr %t59.slot, align 8
  ; %t60:i64 = add_i64 j, %t59
  %r24 = load i64, ptr %t60.slot, align 8
  store i64 %r24, ptr %j.slot, align 8
  br label %while_cond_30
dead_r25:
  br label %while_end_31
while_end_31:
  store i64 0, ptr %t61.slot, align 8
  %r26 = load i64, ptr %t61.slot, align 8
  store i64 %r26, ptr %k.slot, align 8
  br label %while_cond_32
while_cond_32:
  ; %t62:bool = cmp_lt_i64 k, m_len
  %r27 = load i64, ptr %t62.slot, align 8
  %r28 = icmp eq i64 %r27, 0
  br i1 %r28, label %while_end_33, label %fall_28
fall_28:
  store i64 64, ptr %t63.slot, align 8
  ; %t64:i64 = add_i64 %t63, k
  ; %t65:str = str_index(msg[k])
  ; %t66:i64 = str_ord %t65
  ; inner_buf[%t64] = %t66  ; i64
  store i64 1, ptr %t67.slot, align 8
  ; %t68:i64 = add_i64 k, %t67
  %r29 = load i64, ptr %t68.slot, align 8
  store i64 %r29, ptr %k.slot, align 8
  br label %while_cond_32
dead_r30:
  br label %while_end_33
while_end_33:
  ; %t69:Array[i64] = call sha256_buffer(inner_buf, inner_len)
  %r31 = load ptr, ptr %t69.slot, align 8
  store ptr %r31, ptr %inner_digest.slot, align 8
  store i64 96, ptr %t71.slot, align 8
  store i64 0, ptr %t72.slot, align 8
  ; %t70:Array[i64] = alloc_array(%t71, init=%t72)
  %r32 = load ptr, ptr %t70.slot, align 8
  store ptr %r32, ptr %outer_buf.slot, align 8
  store i64 0, ptr %t73.slot, align 8
  %r33 = load i64, ptr %t73.slot, align 8
  store i64 %r33, ptr %m.slot, align 8
  br label %while_cond_34
while_cond_34:
  store i64 64, ptr %t74.slot, align 8
  ; %t75:bool = cmp_lt_i64 m, %t74
  %r34 = load i64, ptr %t75.slot, align 8
  %r35 = icmp eq i64 %r34, 0
  br i1 %r35, label %while_end_35, label %fall_35
fall_35:
  ; %t76:i64 = key_block[m]
  store i64 92, ptr %t77.slot, align 8
  ; %t78:i64 = xor_i64 %t76, %t77
  ; outer_buf[m] = %t78  ; i64
  store i64 1, ptr %t79.slot, align 8
  ; %t80:i64 = add_i64 m, %t79
  %r36 = load i64, ptr %t80.slot, align 8
  store i64 %r36, ptr %m.slot, align 8
  br label %while_cond_34
dead_r37:
  br label %while_end_35
while_end_35:
  store i64 0, ptr %t81.slot, align 8
  %r38 = load i64, ptr %t81.slot, align 8
  store i64 %r38, ptr %n.slot, align 8
  br label %while_cond_36
while_cond_36:
  store i64 8, ptr %t82.slot, align 8
  ; %t83:bool = cmp_lt_i64 n, %t82
  %r39 = load i64, ptr %t83.slot, align 8
  %r40 = icmp eq i64 %r39, 0
  br i1 %r40, label %while_end_37, label %fall_40
fall_40:
  ; %t84:i64 = inner_digest[n]
  %r41 = load i64, ptr %t84.slot, align 8
  store i64 %r41, ptr %w.slot, align 8
  store i64 64, ptr %t85.slot, align 8
  store i64 4, ptr %t86.slot, align 8
  ; %t87:i64 = mul_i64 n, %t86
  ; %t88:i64 = add_i64 %t85, %t87
  store i64 24, ptr %t89.slot, align 8
  ; %t90:i64 = shr_i64 w, %t89
  store i64 255, ptr %t91.slot, align 8
  ; %t92:i64 = and_i64 %t90, %t91
  ; outer_buf[%t88] = %t92  ; i64
  store i64 64, ptr %t93.slot, align 8
  store i64 4, ptr %t94.slot, align 8
  ; %t95:i64 = mul_i64 n, %t94
  ; %t96:i64 = add_i64 %t93, %t95
  store i64 1, ptr %t97.slot, align 8
  ; %t98:i64 = add_i64 %t96, %t97
  store i64 16, ptr %t99.slot, align 8
  ; %t100:i64 = shr_i64 w, %t99
  store i64 255, ptr %t101.slot, align 8
  ; %t102:i64 = and_i64 %t100, %t101
  ; outer_buf[%t98] = %t102  ; i64
  store i64 64, ptr %t103.slot, align 8
  store i64 4, ptr %t104.slot, align 8
  ; %t105:i64 = mul_i64 n, %t104
  ; %t106:i64 = add_i64 %t103, %t105
  store i64 2, ptr %t107.slot, align 8
  ; %t108:i64 = add_i64 %t106, %t107
  store i64 8, ptr %t109.slot, align 8
  ; %t110:i64 = shr_i64 w, %t109
  store i64 255, ptr %t111.slot, align 8
  ; %t112:i64 = and_i64 %t110, %t111
  ; outer_buf[%t108] = %t112  ; i64
  store i64 64, ptr %t113.slot, align 8
  store i64 4, ptr %t114.slot, align 8
  ; %t115:i64 = mul_i64 n, %t114
  ; %t116:i64 = add_i64 %t113, %t115
  store i64 3, ptr %t117.slot, align 8
  ; %t118:i64 = add_i64 %t116, %t117
  store i64 255, ptr %t119.slot, align 8
  ; %t120:i64 = and_i64 w, %t119
  ; outer_buf[%t118] = %t120  ; i64
  store i64 1, ptr %t121.slot, align 8
  ; %t122:i64 = add_i64 n, %t121
  %r42 = load i64, ptr %t122.slot, align 8
  store i64 %r42, ptr %n.slot, align 8
  br label %while_cond_36
dead_r43:
  br label %while_end_37
while_end_37:
  store i64 96, ptr %t123.slot, align 8
  ; %t124:Array[i64] = call sha256_buffer(outer_buf, %t123)
  %r44 = load ptr, ptr %t124.slot, align 8
  ret ptr %r44
ret_cont_44:
  ret ptr 0
}

define dso_local ptr @hmac_sha256(ptr %key.arg, ptr %msg.arg) #0 {
entry:
  %key.slot = alloca ptr, align 8
  %msg.slot = alloca ptr, align 8
  %t1.slot = alloca ptr, align 8
  %digest.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store ptr %msg.arg, ptr %msg.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:Array[i64] = call hmac_sha256_digest(key, msg)
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %digest.slot, align 8
  ; %t2:str = call hex256(digest)
  %r2 = load ptr, ptr %t2.slot, align 8
  ret ptr %r2
ret_cont_2:
  ret ptr 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %msg1.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %h1.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %msg2.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %h2.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %msg3.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %h3.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca ptr, align 8
  %msg4.slot = alloca ptr, align 8
  %t18.slot = alloca ptr, align 8
  %h4.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %api_key.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %payload.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %sig.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca ptr, align 8
  %rfc_key.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %rfc_data.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %rfc_sig.slot = alloca ptr, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca ptr, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca ptr, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca ptr, align 8
  %t53.slot = alloca ptr, align 8
  %t54.slot = alloca i64, align 8
  %mm1.slot = alloca i64, align 8
  %t55.slot = alloca ptr, align 8
  %t56.slot = alloca i64, align 8
  %mm2.slot = alloca i64, align 8
  %t57.slot = alloca ptr, align 8
  %t58.slot = alloca i64, align 8
  %mm3.slot = alloca i64, align 8
  %t59.slot = alloca ptr, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %t62.slot = alloca ptr, align 8
  %t63.slot = alloca ptr, align 8
  %t64.slot = alloca ptr, align 8
  %t65.slot = alloca ptr, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca ptr, align 8
  %t70.slot = alloca ptr, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca ptr, align 8
  %t73.slot = alloca ptr, align 8
  %t74.slot = alloca i64, align 8
  %fnv1.slot = alloca i64, align 8
  %t75.slot = alloca ptr, align 8
  %t76.slot = alloca i64, align 8
  %fnv2.slot = alloca i64, align 8
  %t77.slot = alloca ptr, align 8
  %t78.slot = alloca i64, align 8
  %fnv3.slot = alloca i64, align 8
  %t79.slot = alloca ptr, align 8
  %t80.slot = alloca ptr, align 8
  %t81.slot = alloca ptr, align 8
  %t82.slot = alloca ptr, align 8
  %t83.slot = alloca ptr, align 8
  %t84.slot = alloca ptr, align 8
  %t85.slot = alloca ptr, align 8
  %t86.slot = alloca ptr, align 8
  %t87.slot = alloca ptr, align 8
  %t88.slot = alloca ptr, align 8
  %t89.slot = alloca ptr, align 8
  %t90.slot = alloca ptr, align 8
  %t91.slot = alloca ptr, align 8
  %t92.slot = alloca ptr, align 8
  %t93.slot = alloca ptr, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 1
  ; print(%t1:str)
  ; %t2:str = const_str 2
  ; print(%t2:str)
  ; %t3:str = const_str 1
  ; print(%t3:str)
  ; %t4:str = const_str 3
  ; print(%t4:str)
  ; %t5:str = const_str 4
  %r1 = load ptr, ptr %t5.slot, align 8
  store ptr %r1, ptr %msg1.slot, align 8
  ; %t6:str = call sha256(msg1)
  %r2 = load ptr, ptr %t6.slot, align 8
  store ptr %r2, ptr %h1.slot, align 8
  ; %t7:str = const_str 5
  ; print(%t7:str)
  ; %t8:str = const_str 6
  ; print(%t8:str, h1:str)
  ; %t9:str = const_str 7
  %r3 = load ptr, ptr %t9.slot, align 8
  store ptr %r3, ptr %msg2.slot, align 8
  ; %t10:str = call sha256(msg2)
  %r4 = load ptr, ptr %t10.slot, align 8
  store ptr %r4, ptr %h2.slot, align 8
  ; %t11:str = const_str 8
  ; print(%t11:str)
  ; %t12:str = const_str 6
  ; print(%t12:str, h2:str)
  ; %t13:str = const_str 9
  %r5 = load ptr, ptr %t13.slot, align 8
  store ptr %r5, ptr %msg3.slot, align 8
  ; %t14:str = call sha256(msg3)
  %r6 = load ptr, ptr %t14.slot, align 8
  store ptr %r6, ptr %h3.slot, align 8
  ; %t15:str = const_str 10
  ; print(%t15:str)
  ; %t16:str = const_str 6
  ; print(%t16:str, h3:str)
  ; %t17:str = const_str 11
  %r7 = load ptr, ptr %t17.slot, align 8
  store ptr %r7, ptr %msg4.slot, align 8
  ; %t18:str = call sha256(msg4)
  %r8 = load ptr, ptr %t18.slot, align 8
  store ptr %r8, ptr %h4.slot, align 8
  ; %t19:str = const_str 12
  ; print(%t19:str)
  ; %t20:str = const_str 6
  ; print(%t20:str, h4:str)
  ; %t21:str = const_str 13
  ; %t22:bool = str_cmp_ne h1, %t21
  %r9 = load i64, ptr %t22.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_38, label %fall_10
fall_10:
  ; %t23:str = const_str 14
  ; print(%t23:str)
  store i64 1, ptr %t24.slot, align 8
  %r11 = load i64, ptr %t24.slot, align 8
  ret i64 %r11
ret_cont_11:
  br label %if_end_38
dead_r12:
  br label %if_end_38
if_end_38:
  ; %t25:str = const_str 15
  ; %t26:bool = str_cmp_ne h2, %t25
  %r13 = load i64, ptr %t26.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %if_end_39, label %fall_14
fall_14:
  ; %t27:str = const_str 16
  ; print(%t27:str)
  store i64 2, ptr %t28.slot, align 8
  %r15 = load i64, ptr %t28.slot, align 8
  ret i64 %r15
ret_cont_15:
  br label %if_end_39
dead_r16:
  br label %if_end_39
if_end_39:
  ; %t29:str = const_str 17
  ; %t30:bool = str_cmp_ne h3, %t29
  %r17 = load i64, ptr %t30.slot, align 8
  %r18 = icmp eq i64 %r17, 0
  br i1 %r18, label %if_end_40, label %fall_18
fall_18:
  ; %t31:str = const_str 18
  ; print(%t31:str)
  store i64 3, ptr %t32.slot, align 8
  %r19 = load i64, ptr %t32.slot, align 8
  ret i64 %r19
ret_cont_19:
  br label %if_end_40
dead_r20:
  br label %if_end_40
if_end_40:
  ; %t33:str = const_str 4
  ; print(%t33:str)
  ; %t34:str = const_str 19
  ; print(%t34:str)
  ; %t35:str = const_str 20
  %r21 = load ptr, ptr %t35.slot, align 8
  store ptr %r21, ptr %api_key.slot, align 8
  ; %t36:str = const_str 21
  %r22 = load ptr, ptr %t36.slot, align 8
  store ptr %r22, ptr %payload.slot, align 8
  ; %t37:str = call hmac_sha256(api_key, payload)
  %r23 = load ptr, ptr %t37.slot, align 8
  store ptr %r23, ptr %sig.slot, align 8
  ; %t38:str = const_str 22
  ; print(%t38:str)
  ; %t39:str = const_str 6
  ; print(%t39:str, payload:str)
  ; %t40:str = const_str 23
  ; print(%t40:str)
  ; %t41:str = const_str 6
  ; print(%t41:str, sig:str)
  ; %t42:str = const_str 24
  %r24 = load ptr, ptr %t42.slot, align 8
  store ptr %r24, ptr %rfc_key.slot, align 8
  ; %t43:str = const_str 9
  %r25 = load ptr, ptr %t43.slot, align 8
  store ptr %r25, ptr %rfc_data.slot, align 8
  ; %t44:str = call hmac_sha256(rfc_key, rfc_data)
  %r26 = load ptr, ptr %t44.slot, align 8
  store ptr %r26, ptr %rfc_sig.slot, align 8
  ; %t45:str = const_str 25
  ; print(%t45:str)
  ; %t46:str = const_str 6
  ; print(%t46:str, rfc_sig:str)
  ; %t47:str = const_str 26
  ; %t48:bool = str_cmp_ne rfc_sig, %t47
  %r27 = load i64, ptr %t48.slot, align 8
  %r28 = icmp eq i64 %r27, 0
  br i1 %r28, label %if_end_41, label %fall_28
fall_28:
  ; %t49:str = const_str 27
  ; print(%t49:str)
  store i64 4, ptr %t50.slot, align 8
  %r29 = load i64, ptr %t50.slot, align 8
  ret i64 %r29
ret_cont_29:
  br label %if_end_41
dead_r30:
  br label %if_end_41
if_end_41:
  ; %t51:str = const_str 4
  ; print(%t51:str)
  ; %t52:str = const_str 28
  ; print(%t52:str)
  ; %t53:str = const_str 29
  ; %t54:i64 = call murmurhash3(%t53)
  %r31 = load i64, ptr %t54.slot, align 8
  store i64 %r31, ptr %mm1.slot, align 8
  ; %t55:str = const_str 30
  ; %t56:i64 = call murmurhash3(%t55)
  %r32 = load i64, ptr %t56.slot, align 8
  store i64 %r32, ptr %mm2.slot, align 8
  ; %t57:str = const_str 31
  ; %t58:i64 = call murmurhash3(%t57)
  %r33 = load i64, ptr %t58.slot, align 8
  store i64 %r33, ptr %mm3.slot, align 8
  ; %t59:str = const_str 32
  ; %t60:str = const_str 33
  ; %t61:str = call hex32(mm1)
  ; %t62:str = const_str 34
  ; print(%t59:str, mm1:i64, %t60:str, %t61:str, %t62:str)
  ; %t63:str = const_str 35
  ; %t64:str = const_str 33
  ; %t65:str = call hex32(mm2)
  ; %t66:str = const_str 34
  ; print(%t63:str, mm2:i64, %t64:str, %t65:str, %t66:str)
  ; %t67:str = const_str 36
  ; %t68:str = const_str 33
  ; %t69:str = call hex32(mm3)
  ; %t70:str = const_str 34
  ; print(%t67:str, mm3:i64, %t68:str, %t69:str, %t70:str)
  ; %t71:str = const_str 4
  ; print(%t71:str)
  ; %t72:str = const_str 37
  ; print(%t72:str)
  ; %t73:str = const_str 29
  ; %t74:i64 = call fnv1a_32(%t73)
  %r34 = load i64, ptr %t74.slot, align 8
  store i64 %r34, ptr %fnv1.slot, align 8
  ; %t75:str = const_str 30
  ; %t76:i64 = call fnv1a_32(%t75)
  %r35 = load i64, ptr %t76.slot, align 8
  store i64 %r35, ptr %fnv2.slot, align 8
  ; %t77:str = const_str 31
  ; %t78:i64 = call fnv1a_32(%t77)
  %r36 = load i64, ptr %t78.slot, align 8
  store i64 %r36, ptr %fnv3.slot, align 8
  ; %t79:str = const_str 38
  ; %t80:str = const_str 33
  ; %t81:str = call hex32(fnv1)
  ; %t82:str = const_str 34
  ; print(%t79:str, fnv1:i64, %t80:str, %t81:str, %t82:str)
  ; %t83:str = const_str 39
  ; %t84:str = const_str 33
  ; %t85:str = call hex32(fnv2)
  ; %t86:str = const_str 34
  ; print(%t83:str, fnv2:i64, %t84:str, %t85:str, %t86:str)
  ; %t87:str = const_str 40
  ; %t88:str = const_str 33
  ; %t89:str = call hex32(fnv3)
  ; %t90:str = const_str 34
  ; print(%t87:str, fnv3:i64, %t88:str, %t89:str, %t90:str)
  ; %t91:str = const_str 4
  ; print(%t91:str)
  ; %t92:str = const_str 1
  ; print(%t92:str)
  ; %t93:str = const_str 41
  ; print(%t93:str)
  ; %t94:str = const_str 1
  ; print(%t94:str)
  store i64 0, ptr %t95.slot, align 8
  %r37 = load i64, ptr %t95.slot, align 8
  ret i64 %r37
ret_cont_37:
  ret i64 0
}
