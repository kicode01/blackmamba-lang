; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @array_copy_i64(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_1
for_cond_1:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_3, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:i64 = src[%t5]
  ; dst[%t4] = %t6  ; i64
  br label %for_step_2
for_step_2:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_1
dead_r5:
  br label %for_end_3
for_end_3:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_copy_f64(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_4
for_cond_4:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_6, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:f64 = src[%t5]
  ; dst[%t4] = %t6  ; f64
  br label %for_step_5
for_step_5:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_4
dead_r5:
  br label %for_end_6
for_end_6:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_copy_str(ptr %src.arg, i64 %src_idx.arg, ptr %dst.arg, i64 %dst_idx.arg, i64 %count.arg) #0 {
entry:
  %src.slot = alloca ptr, align 8
  %src_idx.slot = alloca i64, align 8
  %dst.slot = alloca ptr, align 8
  %dst_idx.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  store ptr %src.arg, ptr %src.slot, align 8
  store i64 %src_idx.arg, ptr %src_idx.slot, align 8
  store ptr %dst.arg, ptr %dst.slot, align 8
  store i64 %dst_idx.arg, ptr %dst_idx.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_7
for_cond_7:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_9, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 dst_idx, i
  ; %t5:i64 = add_i64 src_idx, i
  ; %t6:str = src[%t5]
  ; dst[%t4] = %t6  ; i64
  br label %for_step_8
for_step_8:
  ; %t7:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t7.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_7
dead_r5:
  br label %for_end_9
for_end_9:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_i64(ptr %arr.arg, i64 %start.arg, i64 %count.arg, i64 %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_10
for_cond_10:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_12, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; i64
  br label %for_step_11
for_step_11:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_10
dead_r5:
  br label %for_end_12
for_end_12:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_f64(ptr %arr.arg, i64 %start.arg, i64 %count.arg, double %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_13
for_cond_13:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_15, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; f64
  br label %for_step_14
for_step_14:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_13
dead_r5:
  br label %for_end_15
for_end_15:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @array_fill_str(ptr %arr.arg, i64 %start.arg, i64 %count.arg, ptr %val.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %start.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_16
for_cond_16:
  ; %t3:bool = cmp_lt_i64 i, count
  %r2 = load i64, ptr %t3.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_18, label %fall_3
fall_3:
  ; %t4:i64 = add_i64 start, i
  ; arr[%t4] = val  ; i64
  br label %for_step_17
for_step_17:
  ; %t5:i64 = add_i64 i, %t2
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  br label %for_cond_16
dead_r5:
  br label %for_end_18
for_end_18:
  %r6 = load i64, ptr %count.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @int_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_19, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_19
dead_r5:
  br label %if_end_19
if_end_19:
  store i64 0, ptr %t5.slot, align 8
  ; %t4:Array[i64] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:IntVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[i64]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @int_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_20, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_20
dead_r4:
  br label %if_end_20
if_end_20:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_21, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_21
dead_r9:
  br label %if_end_21
if_end_21:
  store i64 0, ptr %t12.slot, align 8
  ; %t11:Array[i64] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_i64(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[i64]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @int_vec_push(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_22, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_23, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_23
dead_r7:
  br label %if_end_23
if_end_23:
  store i64 0, ptr %t14.slot, align 8
  ; %t13:Array[i64] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_i64(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[i64]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_22
dead_r9:
  br label %if_end_22
if_end_22:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; i64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_24, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_24
dead_r4:
  br label %if_end_24
if_end_24:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[i64] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:i64 = %t12[%t14]
  %r5 = load i64, ptr %t15.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_25, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_25
dead_r5:
  br label %if_end_25
if_end_25:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_26, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_26
dead_r9:
  br label %if_end_26
if_end_26:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_set(i64 %v.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_27, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_27
dead_r5:
  br label %if_end_27
if_end_27:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_28, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_28
dead_r9:
  br label %if_end_28
if_end_28:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t14[real_idx] = val  ; i64
  %r10 = load i64, ptr %val.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_vec_insert(i64 %v.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_29, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_29
dead_r5:
  br label %if_end_29
if_end_29:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_30, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_30
dead_r9:
  br label %if_end_30
if_end_30:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_31, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call int_vec_reserve(v, %t22)
  br label %if_end_31
dead_r12:
  br label %if_end_31
if_end_31:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_32
while_cond_32:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_33, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[i64] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[i64] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:i64 = %t30[%t32]
  ; %t28[i] = %t33  ; i64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_32
dead_r17:
  br label %while_end_33
while_end_33:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[i64] = v[%t36]
  ; %t37[real_idx] = val  ; i64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @int_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_34, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_34
dead_r5:
  br label %if_end_34
if_end_34:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_35, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_35
dead_r9:
  br label %if_end_35
if_end_35:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  store i64 %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_36
for_cond_36:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_38, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[i64] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:i64 = %t25[%t27]
  ; %t23[i] = %t28  ; i64
  br label %for_step_37
for_step_37:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_36
dead_r16:
  br label %for_end_38
for_end_38:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load i64, ptr %val.slot, align 8
  ret i64 %r17
ret_cont_17:
  ret i64 0
}

define dso_local i64 @int_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_39, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_39
dead_r5:
  br label %if_end_39
if_end_39:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_40, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_40
dead_r9:
  br label %if_end_40
if_end_40:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = v[%t13]
  ; %t15:i64 = %t14[real_idx]
  %r10 = load i64, ptr %t15.slot, align 8
  store i64 %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_41, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[i64] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = v[%t23]
  ; %t25:i64 = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; i64
  br label %if_end_41
dead_r14:
  br label %if_end_41
if_end_41:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load i64, ptr %val.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @int_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
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
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_42, label %fall_3
fall_3:
  ; %t9:i64 = call int_vec_reserve(dst, needed)
  br label %if_end_42
dead_r4:
  br label %if_end_42
if_end_42:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[i64] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_i64(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
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
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_43, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_43
dead_r5:
  br label %if_end_43
if_end_43:
  store i64 0, ptr %t7.slot, align 8
  ; %t6:Array[i64] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[i64] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_i64(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:IntVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[i64]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @int_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
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
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_44, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_45, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_45
dead_r8:
  br label %if_end_45
if_end_45:
  br label %if_end_44
dead_r9:
  br label %if_end_44
if_end_44:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_46, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_46
dead_r14:
  br label %if_end_46
if_end_46:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_47, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_47
dead_r18:
  br label %if_end_47
if_end_47:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_48, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:IntVector = call int_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_48
dead_r22:
  br label %if_end_48
if_end_48:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:IntVector = call int_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[i64] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[i64] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_i64(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @int_vec_contains(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_49
for_cond_49:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_51, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  ; %t8:i64 = %t7[i]
  ; %t9:bool = cmp_eq_i64 %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_52, label %fall_5
fall_5:
  store i64 1, ptr %t10.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_52
dead_r7:
  br label %if_end_52
if_end_52:
  br label %for_step_50
for_step_50:
  ; %t11:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t11.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_49
dead_r9:
  br label %for_end_51
for_end_51:
  store i64 0, ptr %t12.slot, align 8
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_index_of(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_53
for_cond_53:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_55, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  ; %t8:i64 = %t7[i]
  ; %t9:bool = cmp_eq_i64 %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_56, label %fall_5
fall_5:
  %r6 = load i64, ptr %i.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_56
dead_r7:
  br label %if_end_56
if_end_56:
  br label %for_step_54
for_step_54:
  ; %t10:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t10.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_53
dead_r9:
  br label %for_end_55
for_end_55:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = neg_i64 %t11
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @int_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %tmp.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_57
while_cond_57:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_58, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  ; %t9:i64 = %t8[i]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[i64] = v[%t12]
  ; %t14:i64 = %t13[j]
  ; %t11[i] = %t14  ; i64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t16[j] = tmp  ; i64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_57
dead_r8:
  br label %while_end_58
while_end_58:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @_int_qsort(ptr %arr.arg, i64 %low.arg, i64 %high.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %pivot.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %tmp.slot = alloca i64, align 8
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
  %p.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_lt_i64 low, high
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_59, label %fall_2
fall_2:
  ; %t2:i64 = arr[high]
  %r3 = load i64, ptr %t2.slot, align 8
  store i64 %r3, ptr %pivot.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 low, %t3
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  store i64 1, ptr %t5.slot, align 8
  %r5 = load i64, ptr %low.slot, align 8
  store i64 %r5, ptr %j.slot, align 8
  br label %for_cond_60
for_cond_60:
  ; %t6:bool = cmp_lt_i64 j, high
  %r6 = load i64, ptr %t6.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %for_end_62, label %fall_7
fall_7:
  ; %t7:i64 = arr[j]
  ; %t8:bool = cmp_le_i64 %t7, pivot
  %r8 = load i64, ptr %t8.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_63, label %fall_9
fall_9:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 i, %t9
  %r10 = load i64, ptr %t10.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  ; %t11:i64 = arr[i]
  %r11 = load i64, ptr %t11.slot, align 8
  store i64 %r11, ptr %tmp.slot, align 8
  ; %t12:i64 = arr[j]
  ; arr[i] = %t12  ; i64
  ; arr[j] = tmp  ; i64
  br label %if_end_63
dead_r12:
  br label %if_end_63
if_end_63:
  br label %for_step_61
for_step_61:
  ; %t13:i64 = add_i64 j, %t5
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %j.slot, align 8
  br label %for_cond_60
dead_r14:
  br label %for_end_62
for_end_62:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = add_i64 i, %t14
  ; %t16:i64 = arr[%t15]
  %r15 = load i64, ptr %t16.slot, align 8
  store i64 %r15, ptr %tmp.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  ; %t19:i64 = arr[high]
  ; arr[%t18] = %t19  ; i64
  ; arr[high] = tmp  ; i64
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 i, %t20
  %r16 = load i64, ptr %t21.slot, align 8
  store i64 %r16, ptr %p.slot, align 8
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = sub_i64 p, %t22
  ; %t24:i64 = call _int_qsort(arr, low, %t23)
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = add_i64 p, %t25
  ; %t27:i64 = call _int_qsort(arr, %t26, high)
  br label %if_end_59
dead_r17:
  br label %if_end_59
if_end_59:
  store i64 0, ptr %t28.slot, align 8
  %r18 = load i64, ptr %t28.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @int_vec_sort(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_64, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_64
dead_r4:
  br label %if_end_64
if_end_64:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = v[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = sub_i64 %t10, %t11
  ; %t13:i64 = call _int_qsort(%t7, %t8, %t12)
  store i64 0, ptr %t14.slot, align 8
  %r5 = load i64, ptr %t14.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @int_vec_binary_search(i64 %v.arg, i64 %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %low.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %mid.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %mid_val.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %low.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %high.slot, align 8
  br label %while_cond_65
while_cond_65:
  ; %t6:bool = cmp_le_i64 low, high
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_66, label %fall_4
fall_4:
  ; %t7:i64 = add_i64 low, high
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = div_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %mid.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[i64] = v[%t10]
  ; %t12:i64 = %t11[mid]
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %mid_val.slot, align 8
  ; %t13:bool = cmp_eq_i64 mid_val, val
  %r7 = load i64, ptr %t13.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_end_67, label %fall_8
fall_8:
  %r9 = load i64, ptr %mid.slot, align 8
  ret i64 %r9
ret_cont_9:
  br label %if_end_67
dead_r10:
  br label %if_end_67
if_end_67:
  ; %t14:bool = cmp_lt_i64 mid_val, val
  %r11 = load i64, ptr %t14.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_next_69, label %fall_12
fall_12:
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = add_i64 mid, %t15
  %r13 = load i64, ptr %t16.slot, align 8
  store i64 %r13, ptr %low.slot, align 8
  br label %if_end_68
dead_r14:
  br label %if_next_69
if_next_69:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = sub_i64 mid, %t17
  %r15 = load i64, ptr %t18.slot, align 8
  store i64 %r15, ptr %high.slot, align 8
  br label %if_end_68
if_end_68:
  br label %while_cond_65
dead_r16:
  br label %while_end_66
while_end_66:
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = neg_i64 %t19
  %r17 = load i64, ptr %t20.slot, align 8
  ret i64 %r17
ret_cont_17:
  ret i64 0
}

define dso_local i64 @int_vec_min(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %m.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_70, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_70
dead_r4:
  br label %if_end_70
if_end_70:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_71
for_cond_71:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_73, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t17:i64 = %t16[i]
  %r9 = load i64, ptr %t17.slot, align 8
  store i64 %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_lt_i64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_74, label %fall_11
fall_11:
  %r12 = load i64, ptr %val.slot, align 8
  store i64 %r12, ptr %m.slot, align 8
  br label %if_end_74
dead_r13:
  br label %if_end_74
if_end_74:
  br label %for_step_72
for_step_72:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_71
dead_r15:
  br label %for_end_73
for_end_73:
  %r16 = load i64, ptr %m.slot, align 8
  ret i64 %r16
ret_cont_16:
  ret i64 0
}

define dso_local i64 @int_vec_max(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %m.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_75, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_75
dead_r4:
  br label %if_end_75
if_end_75:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[i64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_76
for_cond_76:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_78, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[i64] = v[%t15]
  ; %t17:i64 = %t16[i]
  %r9 = load i64, ptr %t17.slot, align 8
  store i64 %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_gt_i64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_79, label %fall_11
fall_11:
  %r12 = load i64, ptr %val.slot, align 8
  store i64 %r12, ptr %m.slot, align 8
  br label %if_end_79
dead_r13:
  br label %if_end_79
if_end_79:
  br label %for_step_77
for_step_77:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_76
dead_r15:
  br label %for_end_78
for_end_78:
  %r16 = load i64, ptr %m.slot, align 8
  ret i64 %r16
ret_cont_16:
  ret i64 0
}

define dso_local i64 @int_vec_sum(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  store i64 1, ptr %t5.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_80
for_cond_80:
  ; %t6:bool = cmp_lt_i64 i, %t4
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_82, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  ; %t9:i64 = %t8[i]
  ; %t10:i64 = add_i64 s, %t9
  %r5 = load i64, ptr %t10.slot, align 8
  store i64 %r5, ptr %s.slot, align 8
  br label %for_step_81
for_step_81:
  ; %t11:i64 = add_i64 i, %t5
  %r6 = load i64, ptr %t11.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_80
dead_r7:
  br label %for_end_82
for_end_82:
  %r8 = load i64, ptr %s.slot, align 8
  ret i64 %r8
ret_cont_8:
  ret i64 0
}

define dso_local ptr @int_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_83, label %fall_2
fall_2:
  ; %t5:str = const_str 0
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_83
dead_r4:
  br label %if_end_83
if_end_83:
  ; %t6:str = const_str 1
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[i64] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:i64 = %t8[%t9]
  ; %t11:str = str_from_i64 %t10
  ; %t12:str = str_concat(%t6, %t11)
  %r5 = load ptr, ptr %t12.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t13.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t13.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_84
for_cond_84:
  ; %t17:bool = cmp_lt_i64 i, %t15
  %r7 = load i64, ptr %t17.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_86, label %fall_8
fall_8:
  ; %t18:str = const_str 2
  ; %t19:str = str_concat(res, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; %t21:Array[i64] = v[%t20]
  ; %t22:i64 = %t21[i]
  ; %t23:str = str_from_i64 %t22
  ; %t24:str = str_concat(%t19, %t23)
  %r9 = load ptr, ptr %t24.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_85
for_step_85:
  ; %t25:i64 = add_i64 i, %t16
  %r10 = load i64, ptr %t25.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_84
dead_r11:
  br label %for_end_86
for_end_86:
  ; %t26:str = const_str 3
  ; %t27:str = str_concat(res, %t26)
  %r12 = load ptr, ptr %t27.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @float_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca double, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_87, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_87
dead_r5:
  br label %if_end_87
if_end_87:
  store double 0.000000e+00, ptr %t5.slot, align 8
  ; %t4:Array[f64] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:FloatVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[f64]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @float_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca double, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_88, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_88
dead_r4:
  br label %if_end_88
if_end_88:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_89, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_89
dead_r9:
  br label %if_end_89
if_end_89:
  store double 0.000000e+00, ptr %t12.slot, align 8
  ; %t11:Array[f64] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_f64(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[f64]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @float_vec_push(i64 %v.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca double, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_90, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_91, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_91
dead_r7:
  br label %if_end_91
if_end_91:
  store double 0.000000e+00, ptr %t14.slot, align 8
  ; %t13:Array[f64] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_f64(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[f64]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_90
dead_r9:
  br label %if_end_90
if_end_90:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; f64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local double @float_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_92, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_92
dead_r4:
  br label %if_end_92
if_end_92:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[f64] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:f64 = %t12[%t14]
  %r5 = load double, ptr %t15.slot, align 8
  ret double %r5
ret_cont_5:
  ret double 0.0
}

define dso_local double @float_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_93, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_93
dead_r5:
  br label %if_end_93
if_end_93:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_94, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_94
dead_r9:
  br label %if_end_94
if_end_94:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  ret double %r10
ret_cont_10:
  ret double 0.0
}

define dso_local i64 @float_vec_set(i64 %v.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_95, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_95
dead_r5:
  br label %if_end_95
if_end_95:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_96, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_96
dead_r9:
  br label %if_end_96
if_end_96:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t14[real_idx] = val  ; f64
  store i64 0, ptr %t15.slot, align 8
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @float_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_vec_insert(i64 %v.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_97, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_97
dead_r5:
  br label %if_end_97
if_end_97:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_98, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_98
dead_r9:
  br label %if_end_98
if_end_98:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_99, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call float_vec_reserve(v, %t22)
  br label %if_end_99
dead_r12:
  br label %if_end_99
if_end_99:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_100
while_cond_100:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_101, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[f64] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[f64] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:f64 = %t30[%t32]
  ; %t28[i] = %t33  ; f64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_100
dead_r17:
  br label %while_end_101
while_end_101:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[f64] = v[%t36]
  ; %t37[real_idx] = val  ; f64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local double @float_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_102, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_102
dead_r5:
  br label %if_end_102
if_end_102:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_103, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_103
dead_r9:
  br label %if_end_103
if_end_103:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  store double %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_104
for_cond_104:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_106, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[f64] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:f64 = %t25[%t27]
  ; %t23[i] = %t28  ; f64
  br label %for_step_105
for_step_105:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_104
dead_r16:
  br label %for_end_106
for_end_106:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load double, ptr %val.slot, align 8
  ret double %r17
ret_cont_17:
  ret double 0.0
}

define dso_local double @float_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_107, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_107
dead_r5:
  br label %if_end_107
if_end_107:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_108, label %fall_7
fall_7:
  store double 0.000000e+00, ptr %t12.slot, align 8
  %r8 = load double, ptr %t12.slot, align 8
  ret double %r8
ret_cont_8:
  br label %if_end_108
dead_r9:
  br label %if_end_108
if_end_108:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = v[%t13]
  ; %t15:f64 = %t14[real_idx]
  %r10 = load double, ptr %t15.slot, align 8
  store double %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_109, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[f64] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = v[%t23]
  ; %t25:f64 = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; f64
  br label %if_end_109
dead_r14:
  br label %if_end_109
if_end_109:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load double, ptr %val.slot, align 8
  ret double %r15
ret_cont_15:
  ret double 0.0
}

define dso_local i64 @float_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
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
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_110, label %fall_3
fall_3:
  ; %t9:i64 = call float_vec_reserve(dst, needed)
  br label %if_end_110
dead_r4:
  br label %if_end_110
if_end_110:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[f64] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[f64] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_f64(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @float_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca double, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
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
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_111, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_111
dead_r5:
  br label %if_end_111
if_end_111:
  store double 0.000000e+00, ptr %t7.slot, align 8
  ; %t6:Array[f64] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[f64] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_f64(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:FloatVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[f64]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @float_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
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
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_112, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_113, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_113
dead_r8:
  br label %if_end_113
if_end_113:
  br label %if_end_112
dead_r9:
  br label %if_end_112
if_end_112:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_114, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_114
dead_r14:
  br label %if_end_114
if_end_114:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_115, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_115
dead_r18:
  br label %if_end_115
if_end_115:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_116, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:FloatVector = call float_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_116
dead_r22:
  br label %if_end_116
if_end_116:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:FloatVector = call float_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[f64] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[f64] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_f64(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @float_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca double, align 8
  %tmp.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_117
while_cond_117:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_118, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  ; %t9:f64 = %t8[i]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[f64] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[f64] = v[%t12]
  ; %t14:f64 = %t13[j]
  ; %t11[i] = %t14  ; f64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t16[j] = tmp  ; f64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_117
dead_r8:
  br label %while_end_118
while_end_118:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local i64 @_float_qsort(ptr %arr.arg, i64 %low.arg, i64 %high.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %low.slot = alloca i64, align 8
  %high.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %pivot.slot = alloca double, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %tmp.slot = alloca double, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %low.arg, ptr %low.slot, align 8
  store i64 %high.arg, ptr %high.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:bool = cmp_lt_i64 low, high
  %r1 = load i64, ptr %t1.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_119, label %fall_2
fall_2:
  ; %t2:f64 = arr[high]
  %r3 = load double, ptr %t2.slot, align 8
  store double %r3, ptr %pivot.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = sub_i64 low, %t3
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %i.slot, align 8
  store i64 1, ptr %t5.slot, align 8
  %r5 = load i64, ptr %low.slot, align 8
  store i64 %r5, ptr %j.slot, align 8
  br label %for_cond_120
for_cond_120:
  ; %t6:bool = cmp_lt_i64 j, high
  %r6 = load i64, ptr %t6.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %for_end_122, label %fall_7
fall_7:
  ; %t7:f64 = arr[j]
  ; %t8:bool = cmp_le_f64 %t7, pivot
  %r8 = load i64, ptr %t8.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_123, label %fall_9
fall_9:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = add_i64 i, %t9
  %r10 = load i64, ptr %t10.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  ; %t11:f64 = arr[i]
  %r11 = load double, ptr %t11.slot, align 8
  store double %r11, ptr %tmp.slot, align 8
  ; %t12:f64 = arr[j]
  ; arr[i] = %t12  ; f64
  ; arr[j] = tmp  ; f64
  br label %if_end_123
dead_r12:
  br label %if_end_123
if_end_123:
  br label %for_step_121
for_step_121:
  ; %t13:i64 = add_i64 j, %t5
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %j.slot, align 8
  br label %for_cond_120
dead_r14:
  br label %for_end_122
for_end_122:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = add_i64 i, %t14
  ; %t16:f64 = arr[%t15]
  %r15 = load double, ptr %t16.slot, align 8
  store double %r15, ptr %tmp.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  ; %t19:f64 = arr[high]
  ; arr[%t18] = %t19  ; f64
  ; arr[high] = tmp  ; f64
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 i, %t20
  %r16 = load i64, ptr %t21.slot, align 8
  store i64 %r16, ptr %p.slot, align 8
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = sub_i64 p, %t22
  ; %t24:i64 = call _float_qsort(arr, low, %t23)
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = add_i64 p, %t25
  ; %t27:i64 = call _float_qsort(arr, %t26, high)
  br label %if_end_119
dead_r17:
  br label %if_end_119
if_end_119:
  store i64 0, ptr %t28.slot, align 8
  %r18 = load i64, ptr %t28.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local i64 @float_vec_sort(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_124, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_124
dead_r4:
  br label %if_end_124
if_end_124:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = v[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = sub_i64 %t10, %t11
  ; %t13:i64 = call _float_qsort(%t7, %t8, %t12)
  store i64 0, ptr %t14.slot, align 8
  %r5 = load i64, ptr %t14.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local double @float_vec_min(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %m.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_125, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_125
dead_r4:
  br label %if_end_125
if_end_125:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:f64 = %t7[%t8]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_126
for_cond_126:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_128, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t17:f64 = %t16[i]
  %r9 = load double, ptr %t17.slot, align 8
  store double %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_lt_f64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_129, label %fall_11
fall_11:
  %r12 = load double, ptr %val.slot, align 8
  store double %r12, ptr %m.slot, align 8
  br label %if_end_129
dead_r13:
  br label %if_end_129
if_end_129:
  br label %for_step_127
for_step_127:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_126
dead_r15:
  br label %for_end_128
for_end_128:
  %r16 = load double, ptr %m.slot, align 8
  ret double %r16
ret_cont_16:
  ret double 0.0
}

define dso_local double @float_vec_max(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %m.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca double, align 8
  %val.slot = alloca double, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_130, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_130
dead_r4:
  br label %if_end_130
if_end_130:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[f64] = v[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:f64 = %t7[%t8]
  %r5 = load double, ptr %t9.slot, align 8
  store double %r5, ptr %m.slot, align 8
  store i64 1, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_131
for_cond_131:
  ; %t14:bool = cmp_lt_i64 i, %t12
  %r7 = load i64, ptr %t14.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_133, label %fall_8
fall_8:
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[f64] = v[%t15]
  ; %t17:f64 = %t16[i]
  %r9 = load double, ptr %t17.slot, align 8
  store double %r9, ptr %val.slot, align 8
  ; %t18:bool = cmp_gt_f64 val, m
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_134, label %fall_11
fall_11:
  %r12 = load double, ptr %val.slot, align 8
  store double %r12, ptr %m.slot, align 8
  br label %if_end_134
dead_r13:
  br label %if_end_134
if_end_134:
  br label %for_step_132
for_step_132:
  ; %t19:i64 = add_i64 i, %t13
  %r14 = load i64, ptr %t19.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_131
dead_r15:
  br label %for_end_133
for_end_133:
  %r16 = load double, ptr %m.slot, align 8
  ret double %r16
ret_cont_16:
  ret double 0.0
}

define dso_local double @float_vec_sum(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %s.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 0.000000e+00, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  store i64 1, ptr %t5.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_135
for_cond_135:
  ; %t6:bool = cmp_lt_i64 i, %t4
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_137, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  ; %t9:f64 = %t8[i]
  ; %t10:f64 = add_f64 s, %t9
  %r5 = load double, ptr %t10.slot, align 8
  store double %r5, ptr %s.slot, align 8
  br label %for_step_136
for_step_136:
  ; %t11:i64 = add_i64 i, %t5
  %r6 = load i64, ptr %t11.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_135
dead_r7:
  br label %for_end_137
for_end_137:
  %r8 = load double, ptr %s.slot, align 8
  ret double %r8
ret_cont_8:
  ret double 0.0
}

define dso_local double @float_vec_mean(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_138, label %fall_2
fall_2:
  store double 0.000000e+00, ptr %t5.slot, align 8
  %r3 = load double, ptr %t5.slot, align 8
  ret double %r3
ret_cont_3:
  br label %if_end_138
dead_r4:
  br label %if_end_138
if_end_138:
  ; %t6:f64 = call float_vec_sum(v)
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = v[%t7]
  ; %t9:f64 = i64_to_f64 %t8
  ; %t10:f64 = div_f64 %t6, %t9
  %r5 = load double, ptr %t10.slot, align 8
  ret double %r5
ret_cont_5:
  ret double 0.0
}

define dso_local ptr @float_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_139, label %fall_2
fall_2:
  ; %t5:str = const_str 0
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_139
dead_r4:
  br label %if_end_139
if_end_139:
  ; %t6:str = const_str 1
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[f64] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:f64 = %t8[%t9]
  ; %t11:str = str_from_f64 %t10
  ; %t12:str = str_concat(%t6, %t11)
  %r5 = load ptr, ptr %t12.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t13.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 1, ptr %t16.slot, align 8
  %r6 = load i64, ptr %t13.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_140
for_cond_140:
  ; %t17:bool = cmp_lt_i64 i, %t15
  %r7 = load i64, ptr %t17.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_142, label %fall_8
fall_8:
  ; %t18:str = const_str 2
  ; %t19:str = str_concat(res, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; %t21:Array[f64] = v[%t20]
  ; %t22:f64 = %t21[i]
  ; %t23:str = str_from_f64 %t22
  ; %t24:str = str_concat(%t19, %t23)
  %r9 = load ptr, ptr %t24.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_141
for_step_141:
  ; %t25:i64 = add_i64 i, %t16
  %r10 = load i64, ptr %t25.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_140
dead_r11:
  br label %for_end_142
for_end_142:
  ; %t26:str = const_str 3
  ; %t27:str = str_concat(res, %t26)
  %r12 = load ptr, ptr %t27.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @str_vec_new(i64 %initial_cap.arg) #0 {
entry:
  %initial_cap.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %buf.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %initial_cap.arg, ptr %initial_cap.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %initial_cap.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_le_i64 c, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_143, label %fall_3
fall_3:
  store i64 8, ptr %t3.slot, align 8
  %r4 = load i64, ptr %t3.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_143
dead_r5:
  br label %if_end_143
if_end_143:
  ; %t5:str = const_str 4
  ; %t4:Array[str] = alloc_array(c, init=%t5)
  %r6 = load ptr, ptr %t4.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:StrVector = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = buf  ; Array[str]
  store i64 0, ptr %t10.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t6[%t11] = %t10  ; i64
  store i64 2, ptr %t12.slot, align 8
  ; %t6[%t12] = c  ; i64
  %r7 = load i64, ptr %t6.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @str_vec_len(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_cap(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_is_empty(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_reserve(i64 %v.arg, i64 %min_capacity.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %min_capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %new_data.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %min_capacity.arg, ptr %min_capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  ; %t3:bool = cmp_le_i64 min_capacity, %t2
  %r1 = load i64, ptr %t3.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_144, label %fall_2
fall_2:
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = v[%t4]
  %r3 = load i64, ptr %t5.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_144
dead_r4:
  br label %if_end_144
if_end_144:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  store i64 %r5, ptr %new_cap.slot, align 8
  ; %t10:bool = cmp_lt_i64 new_cap, min_capacity
  %r6 = load i64, ptr %t10.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_145, label %fall_7
fall_7:
  %r8 = load i64, ptr %min_capacity.slot, align 8
  store i64 %r8, ptr %new_cap.slot, align 8
  br label %if_end_145
dead_r9:
  br label %if_end_145
if_end_145:
  ; %t12:str = const_str 4
  ; %t11:Array[str] = alloc_array(new_cap, init=%t12)
  %r10 = load ptr, ptr %t11.slot, align 8
  store ptr %r10, ptr %new_data.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  store i64 0, ptr %t15.slot, align 8
  store i64 0, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  ; %t19:i64 = call array_copy_str(%t14, %t15, new_data, %t16, %t18)
  store i64 0, ptr %t20.slot, align 8
  ; v[%t20] = new_data  ; Array[str]
  store i64 2, ptr %t21.slot, align 8
  ; v[%t21] = new_cap  ; i64
  %r11 = load i64, ptr %new_cap.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @str_vec_push(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %new_cap.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %new_data.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:bool = cmp_ge_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_146, label %fall_2
fall_2:
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 2, ptr %t8.slot, align 8
  ; %t9:i64 = mul_i64 %t7, %t8
  %r3 = load i64, ptr %t9.slot, align 8
  store i64 %r3, ptr %new_cap.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:bool = cmp_le_i64 new_cap, %t10
  %r4 = load i64, ptr %t11.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_147, label %fall_5
fall_5:
  store i64 8, ptr %t12.slot, align 8
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %new_cap.slot, align 8
  br label %if_end_147
dead_r7:
  br label %if_end_147
if_end_147:
  ; %t14:str = const_str 4
  ; %t13:Array[str] = alloc_array(new_cap, init=%t14)
  %r8 = load ptr, ptr %t13.slot, align 8
  store ptr %r8, ptr %new_data.slot, align 8
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[str] = v[%t15]
  store i64 0, ptr %t17.slot, align 8
  store i64 0, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  ; %t21:i64 = call array_copy_str(%t16, %t17, new_data, %t18, %t20)
  store i64 0, ptr %t22.slot, align 8
  ; v[%t22] = new_data  ; Array[str]
  store i64 2, ptr %t23.slot, align 8
  ; v[%t23] = new_cap  ; i64
  br label %if_end_146
dead_r9:
  br label %if_end_146
if_end_146:
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  ; %t25[%t27] = val  ; i64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = v[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = add_i64 %t29, %t30
  store i64 1, ptr %t32.slot, align 8
  ; v[%t32] = %t31  ; i64
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = v[%t33]
  %r10 = load i64, ptr %t34.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local ptr @str_vec_pop(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_148, label %fall_2
fall_2:
  ; %t5:str = const_str 4
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_148
dead_r4:
  br label %if_end_148
if_end_148:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = sub_i64 %t7, %t8
  store i64 1, ptr %t10.slot, align 8
  ; v[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  ; %t12:Array[str] = v[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = v[%t13]
  ; %t15:str = %t12[%t14]
  %r5 = load ptr, ptr %t15.slot, align 8
  ret ptr %r5
ret_cont_5:
  ret ptr 0
}

define dso_local ptr @str_vec_get(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_149, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_149
dead_r5:
  br label %if_end_149
if_end_149:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_150, label %fall_7
fall_7:
  ; %t12:str = const_str 4
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_150
dead_r9:
  br label %if_end_150
if_end_150:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  ret ptr %r10
ret_cont_10:
  ret ptr 0
}

define dso_local i64 @str_vec_set(i64 %v.arg, i64 %idx.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_151, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_151
dead_r5:
  br label %if_end_151
if_end_151:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_152, label %fall_7
fall_7:
  store i64 0, ptr %t12.slot, align 8
  %r8 = load i64, ptr %t12.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_152
dead_r9:
  br label %if_end_152
if_end_152:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t14[real_idx] = val  ; i64
  store i64 0, ptr %t15.slot, align 8
  %r10 = load i64, ptr %t15.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @str_vec_clear(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; v[%t2] = %t1  ; i64
  store i64 0, ptr %t3.slot, align 8
  %r1 = load i64, ptr %t3.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @str_vec_insert(i64 %v.arg, i64 %idx.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %i.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_153, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_153
dead_r5:
  br label %if_end_153
if_end_153:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_gt_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_154, label %fall_7
fall_7:
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r8 = load i64, ptr %t13.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_154
dead_r9:
  br label %if_end_154
if_end_154:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  ; %t18:bool = cmp_ge_i64 %t15, %t17
  %r10 = load i64, ptr %t18.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_155, label %fall_11
fall_11:
  store i64 2, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 2, ptr %t21.slot, align 8
  ; %t22:i64 = mul_i64 %t20, %t21
  ; %t23:i64 = call str_vec_reserve(v, %t22)
  br label %if_end_155
dead_r12:
  br label %if_end_155
if_end_155:
  store i64 1, ptr %t24.slot, align 8
  ; %t25:i64 = v[%t24]
  %r13 = load i64, ptr %t25.slot, align 8
  store i64 %r13, ptr %i.slot, align 8
  br label %while_cond_156
while_cond_156:
  ; %t26:bool = cmp_gt_i64 i, real_idx
  %r14 = load i64, ptr %t26.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %while_end_157, label %fall_15
fall_15:
  store i64 0, ptr %t27.slot, align 8
  ; %t28:Array[str] = v[%t27]
  store i64 0, ptr %t29.slot, align 8
  ; %t30:Array[str] = v[%t29]
  store i64 1, ptr %t31.slot, align 8
  ; %t32:i64 = sub_i64 i, %t31
  ; %t33:str = %t30[%t32]
  ; %t28[i] = %t33  ; i64
  store i64 1, ptr %t34.slot, align 8
  ; %t35:i64 = sub_i64 i, %t34
  %r16 = load i64, ptr %t35.slot, align 8
  store i64 %r16, ptr %i.slot, align 8
  br label %while_cond_156
dead_r17:
  br label %while_end_157
while_end_157:
  store i64 0, ptr %t36.slot, align 8
  ; %t37:Array[str] = v[%t36]
  ; %t37[real_idx] = val  ; i64
  store i64 1, ptr %t38.slot, align 8
  ; %t39:i64 = v[%t38]
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = add_i64 %t39, %t40
  store i64 1, ptr %t42.slot, align 8
  ; v[%t42] = %t41  ; i64
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = v[%t43]
  %r18 = load i64, ptr %t44.slot, align 8
  ret i64 %r18
ret_cont_18:
  ret i64 0
}

define dso_local ptr @str_vec_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %val.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_158, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_158
dead_r5:
  br label %if_end_158
if_end_158:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_159, label %fall_7
fall_7:
  ; %t12:str = const_str 4
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_159
dead_r9:
  br label %if_end_159
if_end_159:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  store ptr %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last.slot, align 8
  store i64 1, ptr %t20.slot, align 8
  %r12 = load i64, ptr %real_idx.slot, align 8
  store i64 %r12, ptr %i.slot, align 8
  br label %for_cond_160
for_cond_160:
  ; %t21:bool = cmp_lt_i64 i, last
  %r13 = load i64, ptr %t21.slot, align 8
  %r14 = icmp eq i64 %r13, 0
  br i1 %r14, label %for_end_162, label %fall_14
fall_14:
  store i64 0, ptr %t22.slot, align 8
  ; %t23:Array[str] = v[%t22]
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = add_i64 i, %t26
  ; %t28:str = %t25[%t27]
  ; %t23[i] = %t28  ; i64
  br label %for_step_161
for_step_161:
  ; %t29:i64 = add_i64 i, %t20
  %r15 = load i64, ptr %t29.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_160
dead_r16:
  br label %for_end_162
for_end_162:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = v[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = sub_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; v[%t34] = %t33  ; i64
  %r17 = load ptr, ptr %val.slot, align 8
  ret ptr %r17
ret_cont_17:
  ret ptr 0
}

define dso_local ptr @str_vec_swap_remove(i64 %v.arg, i64 %idx.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
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
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %val.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %last_idx.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %idx.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 real_idx, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_163, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, real_idx
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %real_idx.slot, align 8
  br label %if_end_163
dead_r5:
  br label %if_end_163
if_end_163:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 real_idx, %t6
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = v[%t8]
  ; %t10:bool = cmp_ge_i64 real_idx, %t9
  ; %t11:bool = or_i64 %t7, %t10
  %r6 = load i64, ptr %t11.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_164, label %fall_7
fall_7:
  ; %t12:str = const_str 4
  %r8 = load ptr, ptr %t12.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_164
dead_r9:
  br label %if_end_164
if_end_164:
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = v[%t13]
  ; %t15:str = %t14[real_idx]
  %r10 = load ptr, ptr %t15.slot, align 8
  store ptr %r10, ptr %val.slot, align 8
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = v[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = sub_i64 %t17, %t18
  %r11 = load i64, ptr %t19.slot, align 8
  store i64 %r11, ptr %last_idx.slot, align 8
  ; %t20:bool = cmp_ne_i64 real_idx, last_idx
  %r12 = load i64, ptr %t20.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_end_165, label %fall_13
fall_13:
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[str] = v[%t21]
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[str] = v[%t23]
  ; %t25:str = %t24[last_idx]
  ; %t22[real_idx] = %t25  ; i64
  br label %if_end_165
dead_r14:
  br label %if_end_165
if_end_165:
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = v[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sub_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; v[%t30] = %t29  ; i64
  %r15 = load ptr, ptr %val.slot, align 8
  ret ptr %r15
ret_cont_15:
  ret ptr 0
}

define dso_local i64 @str_vec_extend(i64 %dst.arg, i64 %src.arg) #0 {
entry:
  %dst.slot = alloca i64, align 8
  %src.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %needed.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
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
  store i64 %dst.arg, ptr %dst.slot, align 8
  store i64 %src.arg, ptr %src.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = dst[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = src[%t3]
  ; %t5:i64 = add_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %needed.slot, align 8
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = dst[%t6]
  ; %t8:bool = cmp_gt_i64 needed, %t7
  %r2 = load i64, ptr %t8.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_166, label %fall_3
fall_3:
  ; %t9:i64 = call str_vec_reserve(dst, needed)
  br label %if_end_166
dead_r4:
  br label %if_end_166
if_end_166:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = src[%t10]
  store i64 0, ptr %t12.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; %t14:Array[str] = dst[%t13]
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = dst[%t15]
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = src[%t17]
  ; %t19:i64 = call array_copy_str(%t11, %t12, %t14, %t16, %t18)
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = dst[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:i64 = src[%t22]
  ; %t24:i64 = add_i64 %t21, %t23
  store i64 1, ptr %t25.slot, align 8
  ; dst[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = dst[%t26]
  %r5 = load i64, ptr %t27.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @str_vec_copy(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %buf.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
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
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %c.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_le_i64 c, %t3
  %r2 = load i64, ptr %t4.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_167, label %fall_3
fall_3:
  store i64 8, ptr %t5.slot, align 8
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %c.slot, align 8
  br label %if_end_167
dead_r5:
  br label %if_end_167
if_end_167:
  ; %t7:str = const_str 4
  ; %t6:Array[str] = alloc_array(c, init=%t7)
  %r6 = load ptr, ptr %t6.slot, align 8
  store ptr %r6, ptr %buf.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[str] = v[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = v[%t12]
  ; %t14:i64 = call array_copy_str(%t9, %t10, buf, %t11, %t13)
  store i64 3, ptr %t16.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t15:StrVector = alloc_array(%t16, init=%t17)
  store i64 0, ptr %t18.slot, align 8
  ; %t15[%t18] = buf  ; Array[str]
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  ; %t15[%t21] = %t20  ; i64
  store i64 2, ptr %t22.slot, align 8
  ; %t15[%t22] = c  ; i64
  %r7 = load i64, ptr %t15.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @str_vec_slice(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
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
  %slice_len.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_168, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_169, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_169
dead_r8:
  br label %if_end_169
if_end_169:
  br label %if_end_168
dead_r9:
  br label %if_end_168
if_end_168:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_170, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_170
dead_r14:
  br label %if_end_170
if_end_170:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_171, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_171
dead_r18:
  br label %if_end_171
if_end_171:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_172, label %fall_20
fall_20:
  store i64 4, ptr %t20.slot, align 8
  ; %t21:StrVector = call str_vec_new(%t20)
  %r21 = load i64, ptr %t21.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_172
dead_r22:
  br label %if_end_172
if_end_172:
  ; %t22:i64 = sub_i64 e, s
  %r23 = load i64, ptr %t22.slot, align 8
  store i64 %r23, ptr %slice_len.slot, align 8
  ; %t23:StrVector = call str_vec_new(slice_len)
  %r24 = load i64, ptr %t23.slot, align 8
  store i64 %r24, ptr %res.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  store i64 0, ptr %t26.slot, align 8
  ; %t27:Array[str] = res[%t26]
  store i64 0, ptr %t28.slot, align 8
  ; %t29:i64 = call array_copy_str(%t25, s, %t27, %t28, slice_len)
  store i64 1, ptr %t30.slot, align 8
  ; res[%t30] = slice_len  ; i64
  %r25 = load i64, ptr %res.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local i64 @str_vec_contains(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_173
for_cond_173:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_175, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[str] = v[%t6]
  ; %t8:str = %t7[i]
  ; %t9:bool = str_cmp_eq %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_176, label %fall_5
fall_5:
  store i64 1, ptr %t10.slot, align 8
  %r6 = load i64, ptr %t10.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_176
dead_r7:
  br label %if_end_176
if_end_176:
  br label %for_step_174
for_step_174:
  ; %t11:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t11.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_173
dead_r9:
  br label %for_end_175
for_end_175:
  store i64 0, ptr %t12.slot, align 8
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @str_vec_index_of(i64 %v.arg, ptr %val.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  br label %for_cond_177
for_cond_177:
  ; %t5:bool = cmp_lt_i64 i, %t3
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %for_end_179, label %fall_3
fall_3:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:Array[str] = v[%t6]
  ; %t8:str = %t7[i]
  ; %t9:bool = str_cmp_eq %t8, val
  %r4 = load i64, ptr %t9.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_end_180, label %fall_5
fall_5:
  %r6 = load i64, ptr %i.slot, align 8
  ret i64 %r6
ret_cont_6:
  br label %if_end_180
dead_r7:
  br label %if_end_180
if_end_180:
  br label %for_step_178
for_step_178:
  ; %t10:i64 = add_i64 i, %t4
  %r8 = load i64, ptr %t10.slot, align 8
  store i64 %r8, ptr %i.slot, align 8
  br label %for_cond_177
dead_r9:
  br label %for_end_179
for_end_179:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = neg_i64 %t11
  %r10 = load i64, ptr %t12.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local ptr @str_vec_join(i64 %v.arg, ptr %sep.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %sep.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store ptr %sep.arg, ptr %sep.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_181, label %fall_2
fall_2:
  ; %t5:str = const_str 4
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_181
dead_r4:
  br label %if_end_181
if_end_181:
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = v[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:bool = cmp_eq_i64 %t7, %t8
  %r5 = load i64, ptr %t9.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_182, label %fall_6
fall_6:
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:str = %t11[%t12]
  %r7 = load ptr, ptr %t13.slot, align 8
  ret ptr %r7
ret_cont_7:
  br label %if_end_182
dead_r8:
  br label %if_end_182
if_end_182:
  store i64 0, ptr %t14.slot, align 8
  ; %t15:Array[str] = v[%t14]
  store i64 0, ptr %t16.slot, align 8
  ; %t17:str = %t15[%t16]
  %r9 = load ptr, ptr %t17.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  store i64 1, ptr %t18.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = v[%t19]
  store i64 1, ptr %t21.slot, align 8
  %r10 = load i64, ptr %t18.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_183
for_cond_183:
  ; %t22:bool = cmp_lt_i64 i, %t20
  %r11 = load i64, ptr %t22.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %for_end_185, label %fall_12
fall_12:
  ; %t23:str = str_concat(res, sep)
  store i64 0, ptr %t24.slot, align 8
  ; %t25:Array[str] = v[%t24]
  ; %t26:str = %t25[i]
  ; %t27:str = str_concat(%t23, %t26)
  %r13 = load ptr, ptr %t27.slot, align 8
  store ptr %r13, ptr %res.slot, align 8
  br label %for_step_184
for_step_184:
  ; %t28:i64 = add_i64 i, %t21
  %r14 = load i64, ptr %t28.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_183
dead_r15:
  br label %for_end_185
for_end_185:
  %r16 = load ptr, ptr %res.slot, align 8
  ret ptr %r16
ret_cont_16:
  ret ptr 0
}

define dso_local i64 @str_vec_reverse(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %j.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %tmp.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %i.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = v[%t2]
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = sub_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  store i64 %r2, ptr %j.slot, align 8
  br label %while_cond_186
while_cond_186:
  ; %t6:bool = cmp_lt_i64 i, j
  %r3 = load i64, ptr %t6.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_187, label %fall_4
fall_4:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[str] = v[%t7]
  ; %t9:str = %t8[i]
  %r5 = load ptr, ptr %t9.slot, align 8
  store ptr %r5, ptr %tmp.slot, align 8
  store i64 0, ptr %t10.slot, align 8
  ; %t11:Array[str] = v[%t10]
  store i64 0, ptr %t12.slot, align 8
  ; %t13:Array[str] = v[%t12]
  ; %t14:str = %t13[j]
  ; %t11[i] = %t14  ; i64
  store i64 0, ptr %t15.slot, align 8
  ; %t16:Array[str] = v[%t15]
  ; %t16[j] = tmp  ; i64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = add_i64 i, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  store i64 1, ptr %t19.slot, align 8
  ; %t20:i64 = sub_i64 j, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  store i64 %r7, ptr %j.slot, align 8
  br label %while_cond_186
dead_r8:
  br label %while_end_187
while_end_187:
  store i64 0, ptr %t21.slot, align 8
  %r9 = load i64, ptr %t21.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local ptr @str_vec_to_str(i64 %v.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = v[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_eq_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_188, label %fall_2
fall_2:
  ; %t5:str = const_str 0
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_188
dead_r4:
  br label %if_end_188
if_end_188:
  ; %t6:str = const_str 5
  store i64 0, ptr %t7.slot, align 8
  ; %t8:Array[str] = v[%t7]
  store i64 0, ptr %t9.slot, align 8
  ; %t10:str = %t8[%t9]
  ; %t11:str = str_concat(%t6, %t10)
  ; %t12:str = const_str 6
  ; %t13:str = str_concat(%t11, %t12)
  %r5 = load ptr, ptr %t13.slot, align 8
  store ptr %r5, ptr %res.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = v[%t15]
  store i64 1, ptr %t17.slot, align 8
  %r6 = load i64, ptr %t14.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_189
for_cond_189:
  ; %t18:bool = cmp_lt_i64 i, %t16
  %r7 = load i64, ptr %t18.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %for_end_191, label %fall_8
fall_8:
  ; %t19:str = const_str 7
  ; %t20:str = str_concat(res, %t19)
  store i64 0, ptr %t21.slot, align 8
  ; %t22:Array[str] = v[%t21]
  ; %t23:str = %t22[i]
  ; %t24:str = str_concat(%t20, %t23)
  ; %t25:str = const_str 6
  ; %t26:str = str_concat(%t24, %t25)
  %r9 = load ptr, ptr %t26.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_190
for_step_190:
  ; %t27:i64 = add_i64 i, %t17
  %r10 = load i64, ptr %t27.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_189
dead_r11:
  br label %for_end_191
for_end_191:
  ; %t28:str = const_str 3
  ; %t29:str = str_concat(res, %t28)
  %r12 = load ptr, ptr %t29.slot, align 8
  store ptr %r12, ptr %res.slot, align 8
  %r13 = load ptr, ptr %res.slot, align 8
  ret ptr %r13
ret_cont_13:
  ret ptr 0
}

define dso_local i64 @int_slice_new(ptr %arr.arg, i64 %offset.arg, i64 %length.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %offset.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %offset.arg, ptr %offset.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:IntSlice = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  ; %t1[%t4] = arr  ; Array[i64]
  store i64 1, ptr %t5.slot, align 8
  ; %t1[%t5] = offset  ; i64
  store i64 2, ptr %t6.slot, align 8
  ; %t1[%t6] = length  ; i64
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @int_slice_from_vec(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
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
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_192, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_193, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_193
dead_r8:
  br label %if_end_193
if_end_193:
  br label %if_end_192
dead_r9:
  br label %if_end_192
if_end_192:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_194, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_194
dead_r14:
  br label %if_end_194
if_end_194:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_195, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_195
dead_r18:
  br label %if_end_195
if_end_195:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_196, label %fall_20
fall_20:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:IntSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = v[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[i64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = s  ; i64
  store i64 0, ptr %t27.slot, align 8
  store i64 2, ptr %t28.slot, align 8
  ; %t20[%t28] = %t27  ; i64
  %r21 = load i64, ptr %t20.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_196
dead_r22:
  br label %if_end_196
if_end_196:
  store i64 3, ptr %t30.slot, align 8
  store i64 0, ptr %t31.slot, align 8
  ; %t29:IntSlice = alloc_array(%t30, init=%t31)
  store i64 0, ptr %t32.slot, align 8
  ; %t33:Array[i64] = v[%t32]
  store i64 0, ptr %t34.slot, align 8
  ; %t29[%t34] = %t33  ; Array[i64]
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = s  ; i64
  ; %t36:i64 = sub_i64 e, s
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; i64
  %r23 = load i64, ptr %t29.slot, align 8
  ret i64 %r23
ret_cont_23:
  ret i64 0
}

define dso_local i64 @int_slice_get(i64 %s.arg, i64 %idx.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  ; %t6:i64 = %t5[real_idx]
  %r2 = load i64, ptr %t6.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @int_slice_set(i64 %s.arg, i64 %idx.arg, i64 %val.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store i64 %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  ; %t5[real_idx] = val  ; i64
  %r2 = load i64, ptr %val.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @int_slice_subslice(i64 %s.arg, i64 %start.arg, i64 %length.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %new_offset.slot = alloca i64, align 8
  %new_len.slot = alloca i64, align 8
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
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, start
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %new_offset.slot, align 8
  %r2 = load i64, ptr %length.slot, align 8
  store i64 %r2, ptr %new_len.slot, align 8
  ; %t4:i64 = add_i64 new_offset, new_len
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = s[%t5]
  store i64 2, ptr %t7.slot, align 8
  ; %t8:i64 = s[%t7]
  ; %t9:i64 = add_i64 %t6, %t8
  ; %t10:bool = cmp_gt_i64 %t4, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_197, label %fall_4
fall_4:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  store i64 2, ptr %t13.slot, align 8
  ; %t14:i64 = s[%t13]
  ; %t15:i64 = add_i64 %t12, %t14
  ; %t16:i64 = sub_i64 %t15, new_offset
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %new_len.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t18:bool = cmp_lt_i64 new_len, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_198, label %fall_7
fall_7:
  store i64 0, ptr %t19.slot, align 8
  %r8 = load i64, ptr %t19.slot, align 8
  store i64 %r8, ptr %new_len.slot, align 8
  br label %if_end_198
dead_r9:
  br label %if_end_198
if_end_198:
  br label %if_end_197
dead_r10:
  br label %if_end_197
if_end_197:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:IntSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[i64] = s[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[i64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = new_offset  ; i64
  store i64 2, ptr %t27.slot, align 8
  ; %t20[%t27] = new_len  ; i64
  %r11 = load i64, ptr %t20.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @int_slice_to_vec(i64 %s.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:IntVector = call int_vec_new(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[i64] = s[%t4]
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = s[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[i64] = res[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  ; %t13:i64 = call array_copy_i64(%t5, %t7, %t9, %t10, %t12)
  store i64 2, ptr %t14.slot, align 8
  ; %t15:i64 = s[%t14]
  store i64 1, ptr %t16.slot, align 8
  ; res[%t16] = %t15  ; i64
  %r2 = load i64, ptr %res.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @float_slice_new(ptr %arr.arg, i64 %offset.arg, i64 %length.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %offset.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %offset.arg, ptr %offset.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 3, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:FloatSlice = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  ; %t1[%t4] = arr  ; Array[f64]
  store i64 1, ptr %t5.slot, align 8
  ; %t1[%t5] = offset  ; i64
  store i64 2, ptr %t6.slot, align 8
  ; %t1[%t6] = length  ; i64
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @float_slice_from_vec(i64 %v.arg, i64 %start.arg, i64 %stop.arg) #0 {
entry:
  %v.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %stop.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %e.slot = alloca i64, align 8
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
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  store i64 %v.arg, ptr %v.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %stop.arg, ptr %stop.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  %r1 = load i64, ptr %start.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 s, %t1
  %r2 = load i64, ptr %t2.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_199, label %fall_3
fall_3:
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = v[%t3]
  ; %t5:i64 = add_i64 %t4, s
  %r4 = load i64, ptr %t5.slot, align 8
  store i64 %r4, ptr %s.slot, align 8
  store i64 0, ptr %t6.slot, align 8
  ; %t7:bool = cmp_lt_i64 s, %t6
  %r5 = load i64, ptr %t7.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_200, label %fall_6
fall_6:
  store i64 0, ptr %t8.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %s.slot, align 8
  br label %if_end_200
dead_r8:
  br label %if_end_200
if_end_200:
  br label %if_end_199
dead_r9:
  br label %if_end_199
if_end_199:
  %r10 = load i64, ptr %stop.slot, align 8
  store i64 %r10, ptr %e.slot, align 8
  store i64 0, ptr %t9.slot, align 8
  ; %t10:bool = cmp_lt_i64 e, %t9
  %r11 = load i64, ptr %t10.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_201, label %fall_12
fall_12:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = v[%t11]
  ; %t13:i64 = add_i64 %t12, e
  %r13 = load i64, ptr %t13.slot, align 8
  store i64 %r13, ptr %e.slot, align 8
  br label %if_end_201
dead_r14:
  br label %if_end_201
if_end_201:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = v[%t14]
  ; %t16:bool = cmp_gt_i64 e, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_202, label %fall_16
fall_16:
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = v[%t17]
  %r17 = load i64, ptr %t18.slot, align 8
  store i64 %r17, ptr %e.slot, align 8
  br label %if_end_202
dead_r18:
  br label %if_end_202
if_end_202:
  ; %t19:bool = cmp_ge_i64 s, e
  %r19 = load i64, ptr %t19.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_end_203, label %fall_20
fall_20:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:FloatSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = v[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[f64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = s  ; i64
  store i64 0, ptr %t27.slot, align 8
  store i64 2, ptr %t28.slot, align 8
  ; %t20[%t28] = %t27  ; i64
  %r21 = load i64, ptr %t20.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_203
dead_r22:
  br label %if_end_203
if_end_203:
  store i64 3, ptr %t30.slot, align 8
  store i64 0, ptr %t31.slot, align 8
  ; %t29:FloatSlice = alloc_array(%t30, init=%t31)
  store i64 0, ptr %t32.slot, align 8
  ; %t33:Array[f64] = v[%t32]
  store i64 0, ptr %t34.slot, align 8
  ; %t29[%t34] = %t33  ; Array[f64]
  store i64 1, ptr %t35.slot, align 8
  ; %t29[%t35] = s  ; i64
  ; %t36:i64 = sub_i64 e, s
  store i64 2, ptr %t37.slot, align 8
  ; %t29[%t37] = %t36  ; i64
  %r23 = load i64, ptr %t29.slot, align 8
  ret i64 %r23
ret_cont_23:
  ret i64 0
}

define dso_local double @float_slice_get(i64 %s.arg, i64 %idx.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca double, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  ; %t6:f64 = %t5[real_idx]
  %r2 = load double, ptr %t6.slot, align 8
  ret double %r2
ret_cont_2:
  ret double 0.0
}

define dso_local i64 @float_slice_set(i64 %s.arg, i64 %idx.arg, double %val.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %real_idx.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %idx.arg, ptr %idx.slot, align 8
  store double %val.arg, ptr %val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, idx
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %real_idx.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  ; %t5[real_idx] = val  ; f64
  store i64 0, ptr %t6.slot, align 8
  %r2 = load i64, ptr %t6.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @float_slice_subslice(i64 %s.arg, i64 %start.arg, i64 %length.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %new_offset.slot = alloca i64, align 8
  %new_len.slot = alloca i64, align 8
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
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  store i64 %start.arg, ptr %start.slot, align 8
  store i64 %length.arg, ptr %length.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:i64 = add_i64 %t2, start
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %new_offset.slot, align 8
  %r2 = load i64, ptr %length.slot, align 8
  store i64 %r2, ptr %new_len.slot, align 8
  ; %t4:i64 = add_i64 new_offset, new_len
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = s[%t5]
  store i64 2, ptr %t7.slot, align 8
  ; %t8:i64 = s[%t7]
  ; %t9:i64 = add_i64 %t6, %t8
  ; %t10:bool = cmp_gt_i64 %t4, %t9
  %r3 = load i64, ptr %t10.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_204, label %fall_4
fall_4:
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  store i64 2, ptr %t13.slot, align 8
  ; %t14:i64 = s[%t13]
  ; %t15:i64 = add_i64 %t12, %t14
  ; %t16:i64 = sub_i64 %t15, new_offset
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %new_len.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  ; %t18:bool = cmp_lt_i64 new_len, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_205, label %fall_7
fall_7:
  store i64 0, ptr %t19.slot, align 8
  %r8 = load i64, ptr %t19.slot, align 8
  store i64 %r8, ptr %new_len.slot, align 8
  br label %if_end_205
dead_r9:
  br label %if_end_205
if_end_205:
  br label %if_end_204
dead_r10:
  br label %if_end_204
if_end_204:
  store i64 3, ptr %t21.slot, align 8
  store i64 0, ptr %t22.slot, align 8
  ; %t20:FloatSlice = alloc_array(%t21, init=%t22)
  store i64 0, ptr %t23.slot, align 8
  ; %t24:Array[f64] = s[%t23]
  store i64 0, ptr %t25.slot, align 8
  ; %t20[%t25] = %t24  ; Array[f64]
  store i64 1, ptr %t26.slot, align 8
  ; %t20[%t26] = new_offset  ; i64
  store i64 2, ptr %t27.slot, align 8
  ; %t20[%t27] = new_len  ; i64
  %r11 = load i64, ptr %t20.slot, align 8
  ret i64 %r11
ret_cont_11:
  ret i64 0
}

define dso_local i64 @float_slice_to_vec(i64 %s.arg) #0 {
entry:
  %s.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  store i64 %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:i64 = s[%t1]
  ; %t3:FloatVector = call float_vec_new(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:Array[f64] = s[%t4]
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = s[%t6]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:Array[f64] = res[%t8]
  store i64 0, ptr %t10.slot, align 8
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = s[%t11]
  ; %t13:i64 = call array_copy_f64(%t5, %t7, %t9, %t10, %t12)
  store i64 2, ptr %t14.slot, align 8
  ; %t15:i64 = s[%t14]
  store i64 1, ptr %t16.slot, align 8
  ; res[%t16] = %t15  ; i64
  %r2 = load i64, ptr %res.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %iv.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca ptr, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca ptr, align 8
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca ptr, align 8
  %t55.slot = alloca ptr, align 8
  %t56.slot = alloca ptr, align 8
  %t57.slot = alloca ptr, align 8
  %t58.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t59.slot = alloca ptr, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %sr.slot = alloca i64, align 8
  %t64.slot = alloca ptr, align 8
  %t65.slot = alloca ptr, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca ptr, align 8
  %t70.slot = alloca ptr, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca ptr, align 8
  %t79.slot = alloca ptr, align 8
  %t80.slot = alloca ptr, align 8
  %t81.slot = alloca ptr, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca ptr, align 8
  %t84.slot = alloca ptr, align 8
  %t85.slot = alloca ptr, align 8
  %t86.slot = alloca ptr, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %bs_49.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %bs_100.slot = alloca i64, align 8
  %t91.slot = alloca ptr, align 8
  %t92.slot = alloca ptr, align 8
  %t93.slot = alloca ptr, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca ptr, align 8
  %t96.slot = alloca ptr, align 8
  %t97.slot = alloca ptr, align 8
  %t98.slot = alloca ptr, align 8
  %t99.slot = alloca ptr, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca ptr, align 8
  %t102.slot = alloca ptr, align 8
  %t103.slot = alloca ptr, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca ptr, align 8
  %t106.slot = alloca ptr, align 8
  %t107.slot = alloca ptr, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca ptr, align 8
  %t110.slot = alloca ptr, align 8
  %t111.slot = alloca ptr, align 8
  %t112.slot = alloca ptr, align 8
  %t113.slot = alloca i64, align 8
  %t114.slot = alloca i64, align 8
  %fv.slot = alloca i64, align 8
  %t115.slot = alloca double, align 8
  %t116.slot = alloca i64, align 8
  %t117.slot = alloca double, align 8
  %t118.slot = alloca i64, align 8
  %t119.slot = alloca double, align 8
  %t120.slot = alloca i64, align 8
  %t121.slot = alloca double, align 8
  %t122.slot = alloca i64, align 8
  %t123.slot = alloca double, align 8
  %t124.slot = alloca i64, align 8
  %t125.slot = alloca ptr, align 8
  %t126.slot = alloca ptr, align 8
  %t127.slot = alloca ptr, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca ptr, align 8
  %t130.slot = alloca ptr, align 8
  %t131.slot = alloca ptr, align 8
  %t132.slot = alloca ptr, align 8
  %t133.slot = alloca double, align 8
  %t134.slot = alloca ptr, align 8
  %t135.slot = alloca ptr, align 8
  %t136.slot = alloca ptr, align 8
  %t137.slot = alloca double, align 8
  %t138.slot = alloca ptr, align 8
  %t139.slot = alloca ptr, align 8
  %t140.slot = alloca ptr, align 8
  %t141.slot = alloca double, align 8
  %t142.slot = alloca ptr, align 8
  %t143.slot = alloca ptr, align 8
  %t144.slot = alloca ptr, align 8
  %t145.slot = alloca double, align 8
  %t146.slot = alloca ptr, align 8
  %t147.slot = alloca ptr, align 8
  %t148.slot = alloca i64, align 8
  %t149.slot = alloca i64, align 8
  %t150.slot = alloca i64, align 8
  %f_slice.slot = alloca i64, align 8
  %t151.slot = alloca ptr, align 8
  %t152.slot = alloca ptr, align 8
  %t153.slot = alloca ptr, align 8
  %t154.slot = alloca ptr, align 8
  %t155.slot = alloca ptr, align 8
  %t156.slot = alloca i64, align 8
  %t157.slot = alloca i64, align 8
  %sv.slot = alloca i64, align 8
  %t158.slot = alloca ptr, align 8
  %t159.slot = alloca i64, align 8
  %t160.slot = alloca ptr, align 8
  %t161.slot = alloca i64, align 8
  %t162.slot = alloca ptr, align 8
  %t163.slot = alloca i64, align 8
  %t164.slot = alloca ptr, align 8
  %t165.slot = alloca i64, align 8
  %t166.slot = alloca ptr, align 8
  %t167.slot = alloca i64, align 8
  %t168.slot = alloca ptr, align 8
  %t169.slot = alloca ptr, align 8
  %t170.slot = alloca ptr, align 8
  %t171.slot = alloca ptr, align 8
  %t172.slot = alloca ptr, align 8
  %t173.slot = alloca ptr, align 8
  %t174.slot = alloca ptr, align 8
  %t175.slot = alloca ptr, align 8
  %t176.slot = alloca ptr, align 8
  %t177.slot = alloca i64, align 8
  %t178.slot = alloca ptr, align 8
  %t179.slot = alloca ptr, align 8
  %t180.slot = alloca ptr, align 8
  %t181.slot = alloca ptr, align 8
  %t182.slot = alloca i64, align 8
  %t183.slot = alloca ptr, align 8
  %t184.slot = alloca ptr, align 8
  %t185.slot = alloca ptr, align 8
  %t186.slot = alloca ptr, align 8
  %t187.slot = alloca i64, align 8
  %t188.slot = alloca ptr, align 8
  %t189.slot = alloca ptr, align 8
  %t190.slot = alloca ptr, align 8
  %t191.slot = alloca ptr, align 8
  %t192.slot = alloca i64, align 8
  %t193.slot = alloca i64, align 8
  %base_v.slot = alloca i64, align 8
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
  %t204.slot = alloca ptr, align 8
  %t205.slot = alloca ptr, align 8
  %t206.slot = alloca ptr, align 8
  %t207.slot = alloca i64, align 8
  %t208.slot = alloca i64, align 8
  %t209.slot = alloca i64, align 8
  %sl.slot = alloca i64, align 8
  %t210.slot = alloca ptr, align 8
  %t211.slot = alloca i64, align 8
  %t212.slot = alloca i64, align 8
  %t213.slot = alloca ptr, align 8
  %t214.slot = alloca ptr, align 8
  %t215.slot = alloca ptr, align 8
  %t216.slot = alloca ptr, align 8
  %t217.slot = alloca i64, align 8
  %t218.slot = alloca i64, align 8
  %t219.slot = alloca ptr, align 8
  %t220.slot = alloca ptr, align 8
  %t221.slot = alloca ptr, align 8
  %t222.slot = alloca ptr, align 8
  %t223.slot = alloca ptr, align 8
  %t224.slot = alloca i64, align 8
  %t225.slot = alloca i64, align 8
  %t226.slot = alloca ptr, align 8
  %t227.slot = alloca ptr, align 8
  %t228.slot = alloca ptr, align 8
  %t229.slot = alloca i64, align 8
  %t230.slot = alloca i64, align 8
  %t231.slot = alloca ptr, align 8
  %t232.slot = alloca ptr, align 8
  %t233.slot = alloca ptr, align 8
  %t234.slot = alloca i64, align 8
  %t235.slot = alloca i64, align 8
  %t236.slot = alloca ptr, align 8
  %t237.slot = alloca ptr, align 8
  %t238.slot = alloca i64, align 8
  %t239.slot = alloca i64, align 8
  %t240.slot = alloca i64, align 8
  %t241.slot = alloca ptr, align 8
  %t242.slot = alloca ptr, align 8
  %t243.slot = alloca ptr, align 8
  %t244.slot = alloca ptr, align 8
  %t245.slot = alloca ptr, align 8
  %t246.slot = alloca ptr, align 8
  %t247.slot = alloca ptr, align 8
  %t248.slot = alloca ptr, align 8
  %t249.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 8
  ; print(%t1:str)
  ; %t2:str = const_str 9
  ; print(%t2:str)
  ; %t3:str = const_str 8
  ; print(%t3:str)
  ; %t4:str = const_str 4
  ; print(%t4:str)
  ; %t5:str = const_str 10
  ; print(%t5:str)
  store i64 2, ptr %t6.slot, align 8
  ; %t7:IntVector = call int_vec_new(%t6)
  %r1 = load i64, ptr %t7.slot, align 8
  store i64 %r1, ptr %iv.slot, align 8
  ; %t8:str = const_str 11
  ; %t9:i64 = call int_vec_cap(iv)
  ; %t10:str = str_from_i64 %t9
  ; %t11:str = str_concat(%t8, %t10)
  ; print(%t11:str)
  store i64 0, ptr %t12.slot, align 8
  store i64 12, ptr %t13.slot, align 8
  store i64 1, ptr %t14.slot, align 8
  %r2 = load i64, ptr %t12.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_206
for_cond_206:
  ; %t15:bool = cmp_lt_i64 i, %t13
  %r3 = load i64, ptr %t15.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_208, label %fall_4
fall_4:
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = add_i64 i, %t16
  store i64 7, ptr %t18.slot, align 8
  ; %t19:i64 = mul_i64 %t17, %t18
  ; %t20:i64 = call int_vec_push(iv, %t19)
  br label %for_step_207
for_step_207:
  ; %t21:i64 = add_i64 i, %t14
  %r5 = load i64, ptr %t21.slot, align 8
  store i64 %r5, ptr %i.slot, align 8
  br label %for_cond_206
dead_r6:
  br label %for_end_208
for_end_208:
  ; %t22:str = const_str 12
  ; print(%t22:str)
  ; %t23:str = const_str 13
  ; %t24:str = call int_vec_to_str(iv)
  ; %t25:str = str_concat(%t23, %t24)
  ; print(%t25:str)
  ; %t26:str = const_str 14
  ; %t27:i64 = call int_vec_len(iv)
  ; %t28:str = str_from_i64 %t27
  ; %t29:str = str_concat(%t26, %t28)
  ; print(%t29:str)
  ; %t30:str = const_str 15
  ; %t31:i64 = call int_vec_cap(iv)
  ; %t32:str = str_from_i64 %t31
  ; %t33:str = str_concat(%t30, %t32)
  ; print(%t33:str)
  ; %t34:str = const_str 16
  store i64 0, ptr %t35.slot, align 8
  ; %t36:i64 = call int_vec_get(iv, %t35)
  ; %t37:str = str_from_i64 %t36
  ; %t38:str = str_concat(%t34, %t37)
  ; print(%t38:str)
  ; %t39:str = const_str 17
  store i64 1, ptr %t40.slot, align 8
  ; %t41:i64 = neg_i64 %t40
  ; %t42:i64 = call int_vec_get(iv, %t41)
  ; %t43:str = str_from_i64 %t42
  ; %t44:str = str_concat(%t39, %t43)
  ; print(%t44:str)
  ; %t45:str = const_str 18
  store i64 2, ptr %t46.slot, align 8
  ; %t47:i64 = neg_i64 %t46
  ; %t48:i64 = call int_vec_get(iv, %t47)
  ; %t49:str = str_from_i64 %t48
  ; %t50:str = str_concat(%t45, %t49)
  ; print(%t50:str)
  store i64 3, ptr %t51.slot, align 8
  store i64 999, ptr %t52.slot, align 8
  ; %t53:i64 = call int_vec_insert(iv, %t51, %t52)
  ; %t54:str = const_str 19
  ; print(%t54:str)
  ; %t55:str = const_str 13
  ; %t56:str = call int_vec_to_str(iv)
  ; %t57:str = str_concat(%t55, %t56)
  ; print(%t57:str)
  ; %t58:i64 = call int_vec_pop(iv)
  %r7 = load i64, ptr %t58.slot, align 8
  store i64 %r7, ptr %p.slot, align 8
  ; %t59:str = const_str 20
  ; %t60:str = str_from_i64 p
  ; %t61:str = str_concat(%t59, %t60)
  ; print(%t61:str)
  store i64 3, ptr %t62.slot, align 8
  ; %t63:i64 = call int_vec_swap_remove(iv, %t62)
  %r8 = load i64, ptr %t63.slot, align 8
  store i64 %r8, ptr %sr.slot, align 8
  ; %t64:str = const_str 21
  ; %t65:str = str_from_i64 sr
  ; %t66:str = str_concat(%t64, %t65)
  ; %t67:str = const_str 22
  ; %t68:str = str_concat(%t66, %t67)
  ; print(%t68:str)
  ; %t69:str = const_str 13
  ; %t70:str = call int_vec_to_str(iv)
  ; %t71:str = str_concat(%t69, %t70)
  ; print(%t71:str)
  store i64 13, ptr %t72.slot, align 8
  ; %t73:i64 = call int_vec_push(iv, %t72)
  store i64 3, ptr %t74.slot, align 8
  ; %t75:i64 = call int_vec_push(iv, %t74)
  store i64 105, ptr %t76.slot, align 8
  ; %t77:i64 = call int_vec_push(iv, %t76)
  ; %t78:str = const_str 23
  ; print(%t78:str)
  ; %t79:str = const_str 13
  ; %t80:str = call int_vec_to_str(iv)
  ; %t81:str = str_concat(%t79, %t80)
  ; print(%t81:str)
  ; %t82:i64 = call int_vec_sort(iv)
  ; %t83:str = const_str 24
  ; print(%t83:str)
  ; %t84:str = const_str 13
  ; %t85:str = call int_vec_to_str(iv)
  ; %t86:str = str_concat(%t84, %t85)
  ; print(%t86:str)
  store i64 49, ptr %t87.slot, align 8
  ; %t88:i64 = call int_vec_binary_search(iv, %t87)
  %r9 = load i64, ptr %t88.slot, align 8
  store i64 %r9, ptr %bs_49.slot, align 8
  store i64 100, ptr %t89.slot, align 8
  ; %t90:i64 = call int_vec_binary_search(iv, %t89)
  %r10 = load i64, ptr %t90.slot, align 8
  store i64 %r10, ptr %bs_100.slot, align 8
  ; %t91:str = const_str 25
  ; %t92:str = str_from_i64 bs_49
  ; %t93:str = str_concat(%t91, %t92)
  ; print(%t93:str)
  ; %t94:str = const_str 26
  ; %t95:str = str_from_i64 bs_100
  ; %t96:str = str_concat(%t94, %t95)
  ; %t97:str = const_str 27
  ; %t98:str = str_concat(%t96, %t97)
  ; print(%t98:str)
  ; %t99:str = const_str 28
  ; %t100:i64 = call int_vec_min(iv)
  ; %t101:str = str_from_i64 %t100
  ; %t102:str = str_concat(%t99, %t101)
  ; print(%t102:str)
  ; %t103:str = const_str 29
  ; %t104:i64 = call int_vec_max(iv)
  ; %t105:str = str_from_i64 %t104
  ; %t106:str = str_concat(%t103, %t105)
  ; print(%t106:str)
  ; %t107:str = const_str 30
  ; %t108:i64 = call int_vec_sum(iv)
  ; %t109:str = str_from_i64 %t108
  ; %t110:str = str_concat(%t107, %t109)
  ; print(%t110:str)
  ; %t111:str = const_str 4
  ; print(%t111:str)
  ; %t112:str = const_str 31
  ; print(%t112:str)
  store i64 4, ptr %t113.slot, align 8
  ; %t114:FloatVector = call float_vec_new(%t113)
  %r11 = load i64, ptr %t114.slot, align 8
  store i64 %r11, ptr %fv.slot, align 8
  store double 9.810000e+00, ptr %t115.slot, align 8
  ; %t116:i64 = call float_vec_push(fv, %t115)
  store double 2.718000e+00, ptr %t117.slot, align 8
  ; %t118:i64 = call float_vec_push(fv, %t117)
  store double 3.141590e+00, ptr %t119.slot, align 8
  ; %t120:i64 = call float_vec_push(fv, %t119)
  store double 1.414000e+00, ptr %t121.slot, align 8
  ; %t122:i64 = call float_vec_push(fv, %t121)
  store double 1.618000e+00, ptr %t123.slot, align 8
  ; %t124:i64 = call float_vec_push(fv, %t123)
  ; %t125:str = const_str 32
  ; %t126:str = call float_vec_to_str(fv)
  ; %t127:str = str_concat(%t125, %t126)
  ; print(%t127:str)
  ; %t128:i64 = call float_vec_sort(fv)
  ; %t129:str = const_str 33
  ; %t130:str = call float_vec_to_str(fv)
  ; %t131:str = str_concat(%t129, %t130)
  ; print(%t131:str)
  ; %t132:str = const_str 34
  ; %t133:f64 = call float_vec_min(fv)
  ; %t134:str = str_from_f64 %t133
  ; %t135:str = str_concat(%t132, %t134)
  ; print(%t135:str)
  ; %t136:str = const_str 35
  ; %t137:f64 = call float_vec_max(fv)
  ; %t138:str = str_from_f64 %t137
  ; %t139:str = str_concat(%t136, %t138)
  ; print(%t139:str)
  ; %t140:str = const_str 36
  ; %t141:f64 = call float_vec_sum(fv)
  ; %t142:str = str_from_f64 %t141
  ; %t143:str = str_concat(%t140, %t142)
  ; print(%t143:str)
  ; %t144:str = const_str 37
  ; %t145:f64 = call float_vec_mean(fv)
  ; %t146:str = str_from_f64 %t145
  ; %t147:str = str_concat(%t144, %t146)
  ; print(%t147:str)
  store i64 1, ptr %t148.slot, align 8
  store i64 4, ptr %t149.slot, align 8
  ; %t150:FloatVector = call float_vec_slice(fv, %t148, %t149)
  %r12 = load i64, ptr %t150.slot, align 8
  store i64 %r12, ptr %f_slice.slot, align 8
  ; %t151:str = const_str 38
  ; %t152:str = call float_vec_to_str(f_slice)
  ; %t153:str = str_concat(%t151, %t152)
  ; print(%t153:str)
  ; %t154:str = const_str 4
  ; print(%t154:str)
  ; %t155:str = const_str 39
  ; print(%t155:str)
  store i64 2, ptr %t156.slot, align 8
  ; %t157:StrVector = call str_vec_new(%t156)
  %r13 = load i64, ptr %t157.slot, align 8
  store i64 %r13, ptr %sv.slot, align 8
  ; %t158:str = const_str 40
  ; %t159:i64 = call str_vec_push(sv, %t158)
  ; %t160:str = const_str 41
  ; %t161:i64 = call str_vec_push(sv, %t160)
  ; %t162:str = const_str 42
  ; %t163:i64 = call str_vec_push(sv, %t162)
  ; %t164:str = const_str 43
  ; %t165:i64 = call str_vec_push(sv, %t164)
  ; %t166:str = const_str 44
  ; %t167:i64 = call str_vec_push(sv, %t166)
  ; %t168:str = const_str 45
  ; %t169:str = call str_vec_to_str(sv)
  ; %t170:str = str_concat(%t168, %t169)
  ; print(%t170:str)
  ; %t171:str = const_str 46
  ; %t172:str = const_str 47
  ; %t173:str = call str_vec_join(sv, %t172)
  ; %t174:str = str_concat(%t171, %t173)
  ; print(%t174:str)
  ; %t175:str = const_str 48
  ; %t176:str = const_str 41
  ; %t177:bool = call str_vec_contains(sv, %t176)
  ; %t178:str = str_from_bool %t177
  ; %t179:str = str_concat(%t175, %t178)
  ; print(%t179:str)
  ; %t180:str = const_str 49
  ; %t181:str = const_str 50
  ; %t182:bool = call str_vec_contains(sv, %t181)
  ; %t183:str = str_from_bool %t182
  ; %t184:str = str_concat(%t180, %t183)
  ; print(%t184:str)
  ; %t185:str = const_str 51
  ; %t186:str = const_str 43
  ; %t187:i64 = call str_vec_index_of(sv, %t186)
  ; %t188:str = str_from_i64 %t187
  ; %t189:str = str_concat(%t185, %t188)
  ; print(%t189:str)
  ; %t190:str = const_str 4
  ; print(%t190:str)
  ; %t191:str = const_str 52
  ; print(%t191:str)
  store i64 6, ptr %t192.slot, align 8
  ; %t193:IntVector = call int_vec_new(%t192)
  %r14 = load i64, ptr %t193.slot, align 8
  store i64 %r14, ptr %base_v.slot, align 8
  store i64 0, ptr %t194.slot, align 8
  store i64 6, ptr %t195.slot, align 8
  store i64 1, ptr %t196.slot, align 8
  %r15 = load i64, ptr %t194.slot, align 8
  store i64 %r15, ptr %i.slot, align 8
  br label %for_cond_209
for_cond_209:
  ; %t197:bool = cmp_lt_i64 i, %t195
  %r16 = load i64, ptr %t197.slot, align 8
  %r17 = icmp eq i64 %r16, 0
  br i1 %r17, label %for_end_211, label %fall_17
fall_17:
  store i64 1, ptr %t198.slot, align 8
  ; %t199:i64 = add_i64 i, %t198
  store i64 10, ptr %t200.slot, align 8
  ; %t201:i64 = mul_i64 %t199, %t200
  ; %t202:i64 = call int_vec_push(base_v, %t201)
  br label %for_step_210
for_step_210:
  ; %t203:i64 = add_i64 i, %t196
  %r18 = load i64, ptr %t203.slot, align 8
  store i64 %r18, ptr %i.slot, align 8
  br label %for_cond_209
dead_r19:
  br label %for_end_211
for_end_211:
  ; %t204:str = const_str 53
  ; %t205:str = call int_vec_to_str(base_v)
  ; %t206:str = str_concat(%t204, %t205)
  ; print(%t206:str)
  store i64 2, ptr %t207.slot, align 8
  store i64 5, ptr %t208.slot, align 8
  ; %t209:IntSlice = call int_slice_from_vec(base_v, %t207, %t208)
  %r20 = load i64, ptr %t209.slot, align 8
  store i64 %r20, ptr %sl.slot, align 8
  ; %t210:str = const_str 54
  store i64 1, ptr %t211.slot, align 8
  ; %t212:i64 = sl[%t211]
  ; %t213:str = str_from_i64 %t212
  ; %t214:str = str_concat(%t210, %t213)
  ; %t215:str = const_str 55
  ; %t216:str = str_concat(%t214, %t215)
  store i64 2, ptr %t217.slot, align 8
  ; %t218:i64 = sl[%t217]
  ; %t219:str = str_from_i64 %t218
  ; %t220:str = str_concat(%t216, %t219)
  ; %t221:str = const_str 22
  ; %t222:str = str_concat(%t220, %t221)
  ; print(%t222:str)
  ; %t223:str = const_str 56
  store i64 0, ptr %t224.slot, align 8
  ; %t225:i64 = call int_slice_get(sl, %t224)
  ; %t226:str = str_from_i64 %t225
  ; %t227:str = str_concat(%t223, %t226)
  ; print(%t227:str)
  ; %t228:str = const_str 57
  store i64 1, ptr %t229.slot, align 8
  ; %t230:i64 = call int_slice_get(sl, %t229)
  ; %t231:str = str_from_i64 %t230
  ; %t232:str = str_concat(%t228, %t231)
  ; print(%t232:str)
  ; %t233:str = const_str 58
  store i64 2, ptr %t234.slot, align 8
  ; %t235:i64 = call int_slice_get(sl, %t234)
  ; %t236:str = str_from_i64 %t235
  ; %t237:str = str_concat(%t233, %t236)
  ; print(%t237:str)
  store i64 1, ptr %t238.slot, align 8
  store i64 7777, ptr %t239.slot, align 8
  ; %t240:i64 = call int_slice_set(sl, %t238, %t239)
  ; %t241:str = const_str 59
  ; print(%t241:str)
  ; %t242:str = const_str 60
  ; %t243:str = call int_vec_to_str(base_v)
  ; %t244:str = str_concat(%t242, %t243)
  ; print(%t244:str)
  ; %t245:str = const_str 4
  ; print(%t245:str)
  ; %t246:str = const_str 8
  ; print(%t246:str)
  ; %t247:str = const_str 61
  ; print(%t247:str)
  ; %t248:str = const_str 8
  ; print(%t248:str)
  store i64 0, ptr %t249.slot, align 8
  ; arena_restore %arena_sp_main
  %r21 = load i64, ptr %t249.slot, align 8
  ret i64 %r21
ret_cont_21:
  ret i64 0
}
