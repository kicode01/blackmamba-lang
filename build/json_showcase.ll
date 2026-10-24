; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @json_doc_new(i64 %capacity.arg) #0 {
entry:
  %capacity.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %dummy.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %arr.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca ptr, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca double, align 8
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
  %t57.slot = alloca ptr, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  store i64 %capacity.arg, ptr %capacity.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 8, ptr %t2.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  ; %t1:JsonNode = alloc_array(%t2, init=%t3)
  store i64 0, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t1[%t5] = %t4  ; i64
  ; %t6:str = const_str 0
  store i64 1, ptr %t7.slot, align 8
  ; %t1[%t7] = %t6  ; str
  ; %t8:str = const_str 0
  store i64 2, ptr %t9.slot, align 8
  ; %t1[%t9] = %t8  ; str
  store i64 0, ptr %t10.slot, align 8
  store i64 3, ptr %t11.slot, align 8
  ; %t1[%t11] = %t10  ; i64
  store double 0.000000e+00, ptr %t12.slot, align 8
  store i64 4, ptr %t13.slot, align 8
  ; %t1[%t13] = %t12  ; f64
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = neg_i64 %t14
  store i64 5, ptr %t16.slot, align 8
  ; %t1[%t16] = %t15  ; i64
  store i64 1, ptr %t17.slot, align 8
  ; %t18:i64 = neg_i64 %t17
  store i64 6, ptr %t19.slot, align 8
  ; %t1[%t19] = %t18  ; i64
  store i64 0, ptr %t20.slot, align 8
  store i64 7, ptr %t21.slot, align 8
  ; %t1[%t21] = %t20  ; i64
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %dummy.slot, align 8
  ; %t22:Array[JsonNode] = alloc_array(capacity, init=dummy)
  %r2 = load ptr, ptr %t22.slot, align 8
  store ptr %r2, ptr %arr.slot, align 8
  store i64 0, ptr %t23.slot, align 8
  store i64 1, ptr %t24.slot, align 8
  %r3 = load i64, ptr %t23.slot, align 8
  store i64 %r3, ptr %i.slot, align 8
  br label %for_cond_1
for_cond_1:
  ; %t25:bool = cmp_lt_i64 i, capacity
  %r4 = load i64, ptr %t25.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %for_end_3, label %fall_5
fall_5:
  store i64 8, ptr %t27.slot, align 8
  store i64 0, ptr %t28.slot, align 8
  ; %t26:JsonNode = alloc_array(%t27, init=%t28)
  store i64 0, ptr %t29.slot, align 8
  store i64 0, ptr %t30.slot, align 8
  ; %t26[%t30] = %t29  ; i64
  ; %t31:str = const_str 0
  store i64 1, ptr %t32.slot, align 8
  ; %t26[%t32] = %t31  ; str
  ; %t33:str = const_str 0
  store i64 2, ptr %t34.slot, align 8
  ; %t26[%t34] = %t33  ; str
  store i64 0, ptr %t35.slot, align 8
  store i64 3, ptr %t36.slot, align 8
  ; %t26[%t36] = %t35  ; i64
  store double 0.000000e+00, ptr %t37.slot, align 8
  store i64 4, ptr %t38.slot, align 8
  ; %t26[%t38] = %t37  ; f64
  store i64 1, ptr %t39.slot, align 8
  ; %t40:i64 = neg_i64 %t39
  store i64 5, ptr %t41.slot, align 8
  ; %t26[%t41] = %t40  ; i64
  store i64 1, ptr %t42.slot, align 8
  ; %t43:i64 = neg_i64 %t42
  store i64 6, ptr %t44.slot, align 8
  ; %t26[%t44] = %t43  ; i64
  store i64 0, ptr %t45.slot, align 8
  store i64 7, ptr %t46.slot, align 8
  ; %t26[%t46] = %t45  ; i64
  ; arr[i] = %t26  ; i64
  br label %for_step_2
for_step_2:
  ; %t47:i64 = add_i64 i, %t24
  %r6 = load i64, ptr %t47.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %for_cond_1
dead_r7:
  br label %for_end_3
for_end_3:
  store i64 5, ptr %t49.slot, align 8
  store i64 0, ptr %t50.slot, align 8
  ; %t48:JsonDoc = alloc_array(%t49, init=%t50)
  store i64 1, ptr %t51.slot, align 8
  ; %t52:i64 = neg_i64 %t51
  store i64 0, ptr %t53.slot, align 8
  ; %t48[%t53] = %t52  ; i64
  store i64 0, ptr %t54.slot, align 8
  store i64 1, ptr %t55.slot, align 8
  ; %t48[%t55] = %t54  ; i64
  store i64 2, ptr %t56.slot, align 8
  ; %t48[%t56] = capacity  ; i64
  ; %t57:str = const_str 0
  store i64 3, ptr %t58.slot, align 8
  ; %t48[%t58] = %t57  ; str
  store i64 4, ptr %t59.slot, align 8
  ; %t48[%t59] = arr  ; Array[JsonNode]
  %r8 = load i64, ptr %t48.slot, align 8
  ret i64 %r8
ret_cont_8:
  ret i64 0
}

define dso_local i64 @json_alloc_node(i64 %doc.arg, i64 %kind.arg, ptr %key.arg, ptr %str_val.arg, i64 %int_val.arg, double %float_val.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %kind.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %str_val.slot = alloca ptr, align 8
  %int_val.slot = alloca i64, align 8
  %float_val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %node.slot = alloca i64, align 8
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
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %kind.arg, ptr %kind.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store ptr %str_val.arg, ptr %str_val.slot, align 8
  store i64 %int_val.arg, ptr %int_val.slot, align 8
  store double %float_val.arg, ptr %float_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = doc[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %idx.slot, align 8
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = doc[%t3]
  ; %t5:bool = cmp_ge_i64 idx, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_4, label %fall_3
fall_3:
  ; %t6:str = const_str 1
  store i64 3, ptr %t7.slot, align 8
  ; doc[%t7] = %t6  ; str
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = neg_i64 %t8
  %r4 = load i64, ptr %t9.slot, align 8
  ret i64 %r4
ret_cont_4:
  br label %if_end_4
dead_r5:
  br label %if_end_4
if_end_4:
  store i64 4, ptr %t10.slot, align 8
  ; %t11:Array[JsonNode] = doc[%t10]
  ; %t12:JsonNode = %t11[idx]
  %r6 = load i64, ptr %t12.slot, align 8
  store i64 %r6, ptr %node.slot, align 8
  store i64 0, ptr %t13.slot, align 8
  ; node[%t13] = kind  ; i64
  store i64 1, ptr %t14.slot, align 8
  ; node[%t14] = key  ; str
  store i64 2, ptr %t15.slot, align 8
  ; node[%t15] = str_val  ; str
  store i64 3, ptr %t16.slot, align 8
  ; node[%t16] = int_val  ; i64
  store i64 4, ptr %t17.slot, align 8
  ; node[%t17] = float_val  ; f64
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = neg_i64 %t18
  store i64 5, ptr %t20.slot, align 8
  ; node[%t20] = %t19  ; i64
  store i64 1, ptr %t21.slot, align 8
  ; %t22:i64 = neg_i64 %t21
  store i64 6, ptr %t23.slot, align 8
  ; node[%t23] = %t22  ; i64
  store i64 0, ptr %t24.slot, align 8
  store i64 7, ptr %t25.slot, align 8
  ; node[%t25] = %t24  ; i64
  store i64 1, ptr %t26.slot, align 8
  ; %t27:i64 = doc[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = add_i64 %t27, %t28
  store i64 1, ptr %t30.slot, align 8
  ; doc[%t30] = %t29  ; i64
  %r7 = load i64, ptr %idx.slot, align 8
  ret i64 %r7
ret_cont_7:
  ret i64 0
}

define dso_local i64 @json_skip_ws(i64 %st.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
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
  store i64 %st.arg, ptr %st.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  br label %while_cond_5
while_cond_5:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = st[%t1]
  store i64 2, ptr %t3.slot, align 8
  ; %t4:i64 = st[%t3]
  ; %t5:bool = cmp_lt_i64 %t2, %t4
  %r1 = load i64, ptr %t5.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %while_end_6, label %fall_2
fall_2:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:str = st[%t6]
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = st[%t8]
  ; %t10:str = str_index(%t7[%t9])
  ; %t11:i64 = str_ord %t10
  %r3 = load i64, ptr %t11.slot, align 8
  store i64 %r3, ptr %c.slot, align 8
  store i64 32, ptr %t12.slot, align 8
  ; %t13:bool = cmp_eq_i64 c, %t12
  store i64 9, ptr %t14.slot, align 8
  ; %t15:bool = cmp_eq_i64 c, %t14
  ; %t16:bool = or_i64 %t13, %t15
  store i64 10, ptr %t17.slot, align 8
  ; %t18:bool = cmp_eq_i64 c, %t17
  ; %t19:bool = or_i64 %t16, %t18
  store i64 13, ptr %t20.slot, align 8
  ; %t21:bool = cmp_eq_i64 c, %t20
  ; %t22:bool = or_i64 %t19, %t21
  %r4 = load i64, ptr %t22.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %if_next_8, label %fall_5
fall_5:
  store i64 1, ptr %t23.slot, align 8
  ; %t24:i64 = st[%t23]
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = add_i64 %t24, %t25
  store i64 1, ptr %t27.slot, align 8
  ; st[%t27] = %t26  ; i64
  br label %if_end_7
dead_r6:
  br label %if_next_8
if_next_8:
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = st[%t28]
  %r7 = load i64, ptr %t29.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_7
if_end_7:
  br label %while_cond_5
dead_r8:
  br label %while_end_6
while_end_6:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = st[%t30]
  %r9 = load i64, ptr %t31.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}

define dso_local ptr @json_parse_str(i64 %st.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %has_escape.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
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
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %end.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca ptr, align 8
  %t54.slot = alloca ptr, align 8
  %t55.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %i.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca ptr, align 8
  %t59.slot = alloca ptr, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %c2.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca ptr, align 8
  %t73.slot = alloca ptr, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca ptr, align 8
  %t77.slot = alloca ptr, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca ptr, align 8
  %t81.slot = alloca ptr, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca ptr, align 8
  %t85.slot = alloca ptr, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca ptr, align 8
  %t89.slot = alloca ptr, align 8
  %t90.slot = alloca ptr, align 8
  %t91.slot = alloca ptr, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca ptr, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  store i64 %st.arg, ptr %st.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = st[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 1, ptr %t5.slot, align 8
  ; st[%t5] = %t4  ; i64
  store i64 1, ptr %t6.slot, align 8
  ; %t7:i64 = st[%t6]
  %r1 = load i64, ptr %t7.slot, align 8
  store i64 %r1, ptr %start.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  %r2 = load i64, ptr %t8.slot, align 8
  store i64 %r2, ptr %has_escape.slot, align 8
  br label %while_cond_9
while_cond_9:
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = st[%t9]
  store i64 2, ptr %t11.slot, align 8
  ; %t12:i64 = st[%t11]
  ; %t13:bool = cmp_lt_i64 %t10, %t12
  %r3 = load i64, ptr %t13.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %while_end_10, label %fall_4
fall_4:
  store i64 0, ptr %t14.slot, align 8
  ; %t15:str = st[%t14]
  store i64 1, ptr %t16.slot, align 8
  ; %t17:i64 = st[%t16]
  ; %t18:str = str_index(%t15[%t17])
  ; %t19:i64 = str_ord %t18
  %r5 = load i64, ptr %t19.slot, align 8
  store i64 %r5, ptr %c.slot, align 8
  store i64 34, ptr %t20.slot, align 8
  ; %t21:bool = cmp_eq_i64 c, %t20
  %r6 = load i64, ptr %t21.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_next_12, label %fall_7
fall_7:
  br label %while_end_10
dead_r8:
  br label %if_end_11
dead_r9:
  br label %if_next_12
if_next_12:
  store i64 92, ptr %t22.slot, align 8
  ; %t23:bool = cmp_eq_i64 c, %t22
  %r10 = load i64, ptr %t23.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_elif_13, label %fall_11
fall_11:
  store i64 1, ptr %t24.slot, align 8
  %r12 = load i64, ptr %t24.slot, align 8
  store i64 %r12, ptr %has_escape.slot, align 8
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = st[%t25]
  store i64 2, ptr %t27.slot, align 8
  ; %t28:i64 = add_i64 %t26, %t27
  store i64 1, ptr %t29.slot, align 8
  ; st[%t29] = %t28  ; i64
  br label %if_end_11
dead_r13:
  br label %if_elif_13
if_elif_13:
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = st[%t30]
  store i64 1, ptr %t32.slot, align 8
  ; %t33:i64 = add_i64 %t31, %t32
  store i64 1, ptr %t34.slot, align 8
  ; st[%t34] = %t33  ; i64
  br label %if_end_11
if_end_11:
  br label %while_cond_9
dead_r14:
  br label %while_end_10
while_end_10:
  store i64 1, ptr %t35.slot, align 8
  ; %t36:i64 = st[%t35]
  store i64 2, ptr %t37.slot, align 8
  ; %t38:i64 = st[%t37]
  ; %t39:bool = cmp_ge_i64 %t36, %t38
  %r15 = load i64, ptr %t39.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_14, label %fall_16
fall_16:
  ; %t40:str = const_str 2
  store i64 3, ptr %t41.slot, align 8
  ; st[%t41] = %t40  ; str
  ; %t42:str = const_str 0
  %r17 = load ptr, ptr %t42.slot, align 8
  ret ptr %r17
ret_cont_17:
  br label %if_end_14
dead_r18:
  br label %if_end_14
if_end_14:
  store i64 1, ptr %t43.slot, align 8
  ; %t44:i64 = st[%t43]
  %r19 = load i64, ptr %t44.slot, align 8
  store i64 %r19, ptr %end.slot, align 8
  store i64 1, ptr %t45.slot, align 8
  ; %t46:i64 = st[%t45]
  store i64 1, ptr %t47.slot, align 8
  ; %t48:i64 = add_i64 %t46, %t47
  store i64 1, ptr %t49.slot, align 8
  ; st[%t49] = %t48  ; i64
  store i64 0, ptr %t51.slot, align 8
  ; %t50:bool = cmp_eq_i64 has_escape, %t51
  %r20 = load i64, ptr %t50.slot, align 8
  %r21 = icmp eq i64 %r20, 0
  br i1 %r21, label %if_end_15, label %fall_21
fall_21:
  store i64 0, ptr %t52.slot, align 8
  ; %t53:str = st[%t52]
  ; %t54:str = str_slice(%t53[start:end])
  %r22 = load ptr, ptr %t54.slot, align 8
  ret ptr %r22
ret_cont_22:
  br label %if_end_15
dead_r23:
  br label %if_end_15
if_end_15:
  ; %t55:str = const_str 0
  %r24 = load ptr, ptr %t55.slot, align 8
  store ptr %r24, ptr %res.slot, align 8
  %r25 = load i64, ptr %start.slot, align 8
  store i64 %r25, ptr %i.slot, align 8
  br label %while_cond_16
while_cond_16:
  ; %t56:bool = cmp_lt_i64 i, end
  %r26 = load i64, ptr %t56.slot, align 8
  %r27 = icmp eq i64 %r26, 0
  br i1 %r27, label %while_end_17, label %fall_27
fall_27:
  store i64 0, ptr %t57.slot, align 8
  ; %t58:str = st[%t57]
  ; %t59:str = str_index(%t58[i])
  ; %t60:i64 = str_ord %t59
  %r28 = load i64, ptr %t60.slot, align 8
  store i64 %r28, ptr %c.slot, align 8
  store i64 92, ptr %t61.slot, align 8
  ; %t62:bool = cmp_eq_i64 c, %t61
  %r29 = load i64, ptr %t62.slot, align 8
  %r30 = icmp eq i64 %r29, 0
  br i1 %r30, label %if_next_19, label %fall_30
fall_30:
  store i64 1, ptr %t63.slot, align 8
  ; %t64:i64 = add_i64 i, %t63
  %r31 = load i64, ptr %t64.slot, align 8
  store i64 %r31, ptr %i.slot, align 8
  ; %t65:bool = cmp_lt_i64 i, end
  %r32 = load i64, ptr %t65.slot, align 8
  %r33 = icmp eq i64 %r32, 0
  br i1 %r33, label %if_end_20, label %fall_33
fall_33:
  store i64 0, ptr %t66.slot, align 8
  ; %t67:str = st[%t66]
  ; %t68:str = str_index(%t67[i])
  ; %t69:i64 = str_ord %t68
  %r34 = load i64, ptr %t69.slot, align 8
  store i64 %r34, ptr %c2.slot, align 8
  store i64 110, ptr %t70.slot, align 8
  ; %t71:bool = cmp_eq_i64 c2, %t70
  %r35 = load i64, ptr %t71.slot, align 8
  %r36 = icmp eq i64 %r35, 0
  br i1 %r36, label %if_next_22, label %fall_36
fall_36:
  ; %t72:str = const_str 3
  ; %t73:str = str_concat(res, %t72)
  %r37 = load ptr, ptr %t73.slot, align 8
  store ptr %r37, ptr %res.slot, align 8
  br label %if_end_21
dead_r38:
  br label %if_next_22
if_next_22:
  store i64 116, ptr %t74.slot, align 8
  ; %t75:bool = cmp_eq_i64 c2, %t74
  %r39 = load i64, ptr %t75.slot, align 8
  %r40 = icmp eq i64 %r39, 0
  br i1 %r40, label %if_elif_23, label %fall_40
fall_40:
  ; %t76:str = const_str 4
  ; %t77:str = str_concat(res, %t76)
  %r41 = load ptr, ptr %t77.slot, align 8
  store ptr %r41, ptr %res.slot, align 8
  br label %if_end_21
dead_r42:
  br label %if_elif_23
if_elif_23:
  store i64 114, ptr %t78.slot, align 8
  ; %t79:bool = cmp_eq_i64 c2, %t78
  %r43 = load i64, ptr %t79.slot, align 8
  %r44 = icmp eq i64 %r43, 0
  br i1 %r44, label %if_elif_24, label %fall_44
fall_44:
  ; %t80:str = const_str 5
  ; %t81:str = str_concat(res, %t80)
  %r45 = load ptr, ptr %t81.slot, align 8
  store ptr %r45, ptr %res.slot, align 8
  br label %if_end_21
dead_r46:
  br label %if_elif_24
if_elif_24:
  store i64 34, ptr %t82.slot, align 8
  ; %t83:bool = cmp_eq_i64 c2, %t82
  %r47 = load i64, ptr %t83.slot, align 8
  %r48 = icmp eq i64 %r47, 0
  br i1 %r48, label %if_elif_25, label %fall_48
fall_48:
  ; %t84:str = const_str 6
  ; %t85:str = str_concat(res, %t84)
  %r49 = load ptr, ptr %t85.slot, align 8
  store ptr %r49, ptr %res.slot, align 8
  br label %if_end_21
dead_r50:
  br label %if_elif_25
if_elif_25:
  store i64 92, ptr %t86.slot, align 8
  ; %t87:bool = cmp_eq_i64 c2, %t86
  %r51 = load i64, ptr %t87.slot, align 8
  %r52 = icmp eq i64 %r51, 0
  br i1 %r52, label %if_elif_26, label %fall_52
fall_52:
  ; %t88:str = const_str 7
  ; %t89:str = str_concat(res, %t88)
  %r53 = load ptr, ptr %t89.slot, align 8
  store ptr %r53, ptr %res.slot, align 8
  br label %if_end_21
dead_r54:
  br label %if_elif_26
if_elif_26:
  ; %t90:str = str_chr c2
  ; %t91:str = str_concat(res, %t90)
  %r55 = load ptr, ptr %t91.slot, align 8
  store ptr %r55, ptr %res.slot, align 8
  br label %if_end_21
if_end_21:
  store i64 1, ptr %t92.slot, align 8
  ; %t93:i64 = add_i64 i, %t92
  %r56 = load i64, ptr %t93.slot, align 8
  store i64 %r56, ptr %i.slot, align 8
  br label %if_end_20
dead_r57:
  br label %if_end_20
if_end_20:
  br label %if_end_18
dead_r58:
  br label %if_next_19
if_next_19:
  ; %t94:str = str_chr c
  ; %t95:str = str_concat(res, %t94)
  %r59 = load ptr, ptr %t95.slot, align 8
  store ptr %r59, ptr %res.slot, align 8
  store i64 1, ptr %t96.slot, align 8
  ; %t97:i64 = add_i64 i, %t96
  %r60 = load i64, ptr %t97.slot, align 8
  store i64 %r60, ptr %i.slot, align 8
  br label %if_end_18
if_end_18:
  br label %while_cond_16
dead_r61:
  br label %while_end_17
while_end_17:
  %r62 = load ptr, ptr %res.slot, align 8
  ret ptr %r62
ret_cont_62:
  ret ptr 0
}

define dso_local i64 @json_parse_num(i64 %st.arg, i64 %doc.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %start.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %is_float.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
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
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
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
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca ptr, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca ptr, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca ptr, align 8
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
  %t95.slot = alloca ptr, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca ptr, align 8
  %num_str.slot = alloca ptr, align 8
  %t99.slot = alloca double, align 8
  %f.slot = alloca double, align 8
  %t100.slot = alloca i64, align 8
  %t101.slot = alloca ptr, align 8
  %t102.slot = alloca ptr, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca i64, align 8
  %t105.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t106.slot = alloca i64, align 8
  %t107.slot = alloca ptr, align 8
  %t108.slot = alloca ptr, align 8
  %t109.slot = alloca double, align 8
  %t110.slot = alloca i64, align 8
  %t111.slot = alloca i64, align 8
  store i64 %st.arg, ptr %st.slot, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = st[%t1]
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %start.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t3.slot, align 8
  store i64 %r2, ptr %is_float.slot, align 8
  store i64 1, ptr %t4.slot, align 8
  ; %t5:i64 = st[%t4]
  store i64 2, ptr %t6.slot, align 8
  ; %t7:i64 = st[%t6]
  ; %t8:bool = cmp_lt_i64 %t5, %t7
  store i64 0, ptr %t9.slot, align 8
  ; %t10:str = st[%t9]
  store i64 1, ptr %t11.slot, align 8
  ; %t12:i64 = st[%t11]
  ; %t13:str = str_index(%t10[%t12])
  ; %t14:i64 = str_ord %t13
  store i64 45, ptr %t15.slot, align 8
  ; %t16:bool = cmp_eq_i64 %t14, %t15
  ; %t17:bool = and_i64 %t8, %t16
  %r3 = load i64, ptr %t17.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_27, label %fall_4
fall_4:
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = st[%t18]
  store i64 1, ptr %t20.slot, align 8
  ; %t21:i64 = add_i64 %t19, %t20
  store i64 1, ptr %t22.slot, align 8
  ; st[%t22] = %t21  ; i64
  br label %if_end_27
dead_r5:
  br label %if_end_27
if_end_27:
  br label %while_cond_28
while_cond_28:
  store i64 1, ptr %t23.slot, align 8
  ; %t24:i64 = st[%t23]
  store i64 2, ptr %t25.slot, align 8
  ; %t26:i64 = st[%t25]
  ; %t27:bool = cmp_lt_i64 %t24, %t26
  %r6 = load i64, ptr %t27.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %while_end_29, label %fall_7
fall_7:
  store i64 0, ptr %t28.slot, align 8
  ; %t29:str = st[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t31:i64 = st[%t30]
  ; %t32:str = str_index(%t29[%t31])
  ; %t33:i64 = str_ord %t32
  %r8 = load i64, ptr %t33.slot, align 8
  store i64 %r8, ptr %c.slot, align 8
  store i64 48, ptr %t34.slot, align 8
  ; %t35:bool = cmp_ge_i64 c, %t34
  store i64 57, ptr %t36.slot, align 8
  ; %t37:bool = cmp_le_i64 c, %t36
  ; %t38:bool = and_i64 %t35, %t37
  %r9 = load i64, ptr %t38.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_next_31, label %fall_10
fall_10:
  store i64 1, ptr %t39.slot, align 8
  ; %t40:i64 = st[%t39]
  store i64 1, ptr %t41.slot, align 8
  ; %t42:i64 = add_i64 %t40, %t41
  store i64 1, ptr %t43.slot, align 8
  ; st[%t43] = %t42  ; i64
  br label %if_end_30
dead_r11:
  br label %if_next_31
if_next_31:
  store i64 46, ptr %t44.slot, align 8
  ; %t45:bool = cmp_eq_i64 c, %t44
  store i64 101, ptr %t46.slot, align 8
  ; %t47:bool = cmp_eq_i64 c, %t46
  ; %t48:bool = or_i64 %t45, %t47
  store i64 69, ptr %t49.slot, align 8
  ; %t50:bool = cmp_eq_i64 c, %t49
  ; %t51:bool = or_i64 %t48, %t50
  %r12 = load i64, ptr %t51.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_elif_32, label %fall_13
fall_13:
  store i64 1, ptr %t52.slot, align 8
  %r14 = load i64, ptr %t52.slot, align 8
  store i64 %r14, ptr %is_float.slot, align 8
  store i64 1, ptr %t53.slot, align 8
  ; %t54:i64 = st[%t53]
  store i64 1, ptr %t55.slot, align 8
  ; %t56:i64 = add_i64 %t54, %t55
  store i64 1, ptr %t57.slot, align 8
  ; st[%t57] = %t56  ; i64
  br label %if_end_30
dead_r15:
  br label %if_elif_32
if_elif_32:
  store i64 43, ptr %t58.slot, align 8
  ; %t59:bool = cmp_eq_i64 c, %t58
  store i64 45, ptr %t60.slot, align 8
  ; %t61:bool = cmp_eq_i64 c, %t60
  ; %t62:bool = or_i64 %t59, %t61
  store i64 1, ptr %t63.slot, align 8
  ; %t64:i64 = st[%t63]
  ; %t65:bool = cmp_gt_i64 %t64, start
  ; %t66:bool = and_i64 %t62, %t65
  store i64 0, ptr %t67.slot, align 8
  ; %t68:str = st[%t67]
  store i64 1, ptr %t69.slot, align 8
  ; %t70:i64 = st[%t69]
  store i64 1, ptr %t71.slot, align 8
  ; %t72:i64 = sub_i64 %t70, %t71
  ; %t73:str = str_index(%t68[%t72])
  ; %t74:i64 = str_ord %t73
  store i64 101, ptr %t75.slot, align 8
  ; %t76:bool = cmp_eq_i64 %t74, %t75
  store i64 0, ptr %t77.slot, align 8
  ; %t78:str = st[%t77]
  store i64 1, ptr %t79.slot, align 8
  ; %t80:i64 = st[%t79]
  store i64 1, ptr %t81.slot, align 8
  ; %t82:i64 = sub_i64 %t80, %t81
  ; %t83:str = str_index(%t78[%t82])
  ; %t84:i64 = str_ord %t83
  store i64 69, ptr %t85.slot, align 8
  ; %t86:bool = cmp_eq_i64 %t84, %t85
  ; %t87:bool = or_i64 %t76, %t86
  ; %t88:bool = and_i64 %t66, %t87
  %r16 = load i64, ptr %t88.slot, align 8
  %r17 = icmp eq i64 %r16, 0
  br i1 %r17, label %if_elif_33, label %fall_17
fall_17:
  store i64 1, ptr %t89.slot, align 8
  ; %t90:i64 = st[%t89]
  store i64 1, ptr %t91.slot, align 8
  ; %t92:i64 = add_i64 %t90, %t91
  store i64 1, ptr %t93.slot, align 8
  ; st[%t93] = %t92  ; i64
  br label %if_end_30
dead_r18:
  br label %if_elif_33
if_elif_33:
  br label %while_end_29
dead_r19:
  br label %if_end_30
if_end_30:
  br label %while_cond_28
dead_r20:
  br label %while_end_29
while_end_29:
  store i64 0, ptr %t94.slot, align 8
  ; %t95:str = st[%t94]
  store i64 1, ptr %t96.slot, align 8
  ; %t97:i64 = st[%t96]
  ; %t98:str = str_slice(%t95[start:%t97])
  %r21 = load ptr, ptr %t98.slot, align 8
  store ptr %r21, ptr %num_str.slot, align 8
  %r22 = load i64, ptr %is_float.slot, align 8
  %r23 = icmp eq i64 %r22, 0
  br i1 %r23, label %if_next_35, label %fall_23
fall_23:
  ; %t99:f64 = str_to_f64 num_str
  %r24 = load double, ptr %t99.slot, align 8
  store double %r24, ptr %f.slot, align 8
  store i64 3, ptr %t100.slot, align 8
  ; %t101:str = const_str 0
  ; %t102:str = const_str 0
  store i64 0, ptr %t103.slot, align 8
  ; %t104:i64 = call json_alloc_node(doc, %t100, %t101, %t102, %t103, f)
  %r25 = load i64, ptr %t104.slot, align 8
  ret i64 %r25
ret_cont_25:
  br label %if_end_34
dead_r26:
  br label %if_next_35
if_next_35:
  ; %t105:i64 = str_to_i64 num_str
  %r27 = load i64, ptr %t105.slot, align 8
  store i64 %r27, ptr %i.slot, align 8
  store i64 2, ptr %t106.slot, align 8
  ; %t107:str = const_str 0
  ; %t108:str = const_str 0
  store double 0.000000e+00, ptr %t109.slot, align 8
  ; %t110:i64 = call json_alloc_node(doc, %t106, %t107, %t108, i, %t109)
  %r28 = load i64, ptr %t110.slot, align 8
  ret i64 %r28
ret_cont_28:
  br label %if_end_34
if_end_34:
  store i64 0, ptr %t111.slot, align 8
  %r29 = load i64, ptr %t111.slot, align 8
  ret i64 %r29
ret_cont_29:
  ret i64 0
}

define dso_local i64 @json_parse_val(i64 %st.arg, i64 %doc.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
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
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %s.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca double, align 8
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
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca ptr, align 8
  %t58.slot = alloca ptr, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca i64, align 8
  %t61.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca i64, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca double, align 8
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
  %t82.slot = alloca ptr, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca ptr, align 8
  %t90.slot = alloca ptr, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca i64, align 8
  %t96.slot = alloca i64, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca ptr, align 8
  %t100.slot = alloca ptr, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca double, align 8
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
  %t121.slot = alloca ptr, align 8
  %t122.slot = alloca ptr, align 8
  %t123.slot = alloca i64, align 8
  %t124.slot = alloca i64, align 8
  %t125.slot = alloca i64, align 8
  %t126.slot = alloca i64, align 8
  %t127.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca ptr, align 8
  %t132.slot = alloca ptr, align 8
  %t133.slot = alloca i64, align 8
  %t134.slot = alloca double, align 8
  %t135.slot = alloca i64, align 8
  %t136.slot = alloca ptr, align 8
  %t137.slot = alloca i64, align 8
  %t138.slot = alloca i64, align 8
  %t139.slot = alloca i64, align 8
  store i64 %st.arg, ptr %st.slot, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call json_skip_ws(st)
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = st[%t2]
  store i64 2, ptr %t4.slot, align 8
  ; %t5:i64 = st[%t4]
  ; %t6:bool = cmp_ge_i64 %t3, %t5
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_36, label %fall_2
fall_2:
  ; %t7:str = const_str 8
  store i64 3, ptr %t8.slot, align 8
  ; st[%t8] = %t7  ; str
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = neg_i64 %t9
  %r3 = load i64, ptr %t10.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_36
dead_r4:
  br label %if_end_36
if_end_36:
  store i64 0, ptr %t11.slot, align 8
  ; %t12:str = st[%t11]
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = st[%t13]
  ; %t15:str = str_index(%t12[%t14])
  ; %t16:i64 = str_ord %t15
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %c.slot, align 8
  store i64 123, ptr %t17.slot, align 8
  ; %t18:bool = cmp_eq_i64 c, %t17
  %r6 = load i64, ptr %t18.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_next_38, label %fall_7
fall_7:
  ; %t19:i64 = call json_parse_obj(st, doc)
  %r8 = load i64, ptr %t19.slot, align 8
  ret i64 %r8
ret_cont_8:
  br label %if_end_37
dead_r9:
  br label %if_next_38
if_next_38:
  store i64 91, ptr %t20.slot, align 8
  ; %t21:bool = cmp_eq_i64 c, %t20
  %r10 = load i64, ptr %t21.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_elif_39, label %fall_11
fall_11:
  ; %t22:i64 = call json_parse_arr(st, doc)
  %r12 = load i64, ptr %t22.slot, align 8
  ret i64 %r12
ret_cont_12:
  br label %if_end_37
dead_r13:
  br label %if_elif_39
if_elif_39:
  store i64 34, ptr %t23.slot, align 8
  ; %t24:bool = cmp_eq_i64 c, %t23
  %r14 = load i64, ptr %t24.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %if_elif_40, label %fall_15
fall_15:
  ; %t25:str = call json_parse_str(st)
  %r16 = load ptr, ptr %t25.slot, align 8
  store ptr %r16, ptr %s.slot, align 8
  store i64 4, ptr %t26.slot, align 8
  ; %t27:str = const_str 0
  store i64 0, ptr %t28.slot, align 8
  store double 0.000000e+00, ptr %t29.slot, align 8
  ; %t30:i64 = call json_alloc_node(doc, %t26, %t27, s, %t28, %t29)
  %r17 = load i64, ptr %t30.slot, align 8
  ret i64 %r17
ret_cont_17:
  br label %if_end_37
dead_r18:
  br label %if_elif_40
if_elif_40:
  store i64 48, ptr %t31.slot, align 8
  ; %t32:bool = cmp_ge_i64 c, %t31
  store i64 57, ptr %t33.slot, align 8
  ; %t34:bool = cmp_le_i64 c, %t33
  ; %t35:bool = and_i64 %t32, %t34
  store i64 45, ptr %t36.slot, align 8
  ; %t37:bool = cmp_eq_i64 c, %t36
  ; %t38:bool = or_i64 %t35, %t37
  %r19 = load i64, ptr %t38.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_elif_41, label %fall_20
fall_20:
  ; %t39:i64 = call json_parse_num(st, doc)
  %r21 = load i64, ptr %t39.slot, align 8
  ret i64 %r21
ret_cont_21:
  br label %if_end_37
dead_r22:
  br label %if_elif_41
if_elif_41:
  store i64 116, ptr %t40.slot, align 8
  ; %t41:bool = cmp_eq_i64 c, %t40
  %r23 = load i64, ptr %t41.slot, align 8
  %r24 = icmp eq i64 %r23, 0
  br i1 %r24, label %if_elif_42, label %fall_24
fall_24:
  store i64 1, ptr %t42.slot, align 8
  ; %t43:i64 = st[%t42]
  store i64 4, ptr %t44.slot, align 8
  ; %t45:i64 = add_i64 %t43, %t44
  store i64 2, ptr %t46.slot, align 8
  ; %t47:i64 = st[%t46]
  ; %t48:bool = cmp_le_i64 %t45, %t47
  store i64 0, ptr %t49.slot, align 8
  ; %t50:str = st[%t49]
  store i64 1, ptr %t51.slot, align 8
  ; %t52:i64 = st[%t51]
  store i64 1, ptr %t53.slot, align 8
  ; %t54:i64 = st[%t53]
  store i64 4, ptr %t55.slot, align 8
  ; %t56:i64 = add_i64 %t54, %t55
  ; %t57:str = str_slice(%t50[%t52:%t56])
  ; %t58:str = const_str 9
  ; %t59:bool = str_cmp_eq %t57, %t58
  ; %t60:bool = and_i64 %t48, %t59
  %r25 = load i64, ptr %t60.slot, align 8
  %r26 = icmp eq i64 %r25, 0
  br i1 %r26, label %if_end_43, label %fall_26
fall_26:
  store i64 1, ptr %t61.slot, align 8
  ; %t62:i64 = st[%t61]
  store i64 4, ptr %t63.slot, align 8
  ; %t64:i64 = add_i64 %t62, %t63
  store i64 1, ptr %t65.slot, align 8
  ; st[%t65] = %t64  ; i64
  store i64 1, ptr %t66.slot, align 8
  ; %t67:str = const_str 0
  ; %t68:str = const_str 0
  store i64 1, ptr %t69.slot, align 8
  store double 0.000000e+00, ptr %t70.slot, align 8
  ; %t71:i64 = call json_alloc_node(doc, %t66, %t67, %t68, %t69, %t70)
  %r27 = load i64, ptr %t71.slot, align 8
  ret i64 %r27
ret_cont_27:
  br label %if_end_43
dead_r28:
  br label %if_end_43
if_end_43:
  br label %if_end_37
dead_r29:
  br label %if_elif_42
if_elif_42:
  store i64 102, ptr %t72.slot, align 8
  ; %t73:bool = cmp_eq_i64 c, %t72
  %r30 = load i64, ptr %t73.slot, align 8
  %r31 = icmp eq i64 %r30, 0
  br i1 %r31, label %if_elif_44, label %fall_31
fall_31:
  store i64 1, ptr %t74.slot, align 8
  ; %t75:i64 = st[%t74]
  store i64 5, ptr %t76.slot, align 8
  ; %t77:i64 = add_i64 %t75, %t76
  store i64 2, ptr %t78.slot, align 8
  ; %t79:i64 = st[%t78]
  ; %t80:bool = cmp_le_i64 %t77, %t79
  store i64 0, ptr %t81.slot, align 8
  ; %t82:str = st[%t81]
  store i64 1, ptr %t83.slot, align 8
  ; %t84:i64 = st[%t83]
  store i64 1, ptr %t85.slot, align 8
  ; %t86:i64 = st[%t85]
  store i64 5, ptr %t87.slot, align 8
  ; %t88:i64 = add_i64 %t86, %t87
  ; %t89:str = str_slice(%t82[%t84:%t88])
  ; %t90:str = const_str 10
  ; %t91:bool = str_cmp_eq %t89, %t90
  ; %t92:bool = and_i64 %t80, %t91
  %r32 = load i64, ptr %t92.slot, align 8
  %r33 = icmp eq i64 %r32, 0
  br i1 %r33, label %if_end_45, label %fall_33
fall_33:
  store i64 1, ptr %t93.slot, align 8
  ; %t94:i64 = st[%t93]
  store i64 5, ptr %t95.slot, align 8
  ; %t96:i64 = add_i64 %t94, %t95
  store i64 1, ptr %t97.slot, align 8
  ; st[%t97] = %t96  ; i64
  store i64 1, ptr %t98.slot, align 8
  ; %t99:str = const_str 0
  ; %t100:str = const_str 0
  store i64 0, ptr %t101.slot, align 8
  store double 0.000000e+00, ptr %t102.slot, align 8
  ; %t103:i64 = call json_alloc_node(doc, %t98, %t99, %t100, %t101, %t102)
  %r34 = load i64, ptr %t103.slot, align 8
  ret i64 %r34
ret_cont_34:
  br label %if_end_45
dead_r35:
  br label %if_end_45
if_end_45:
  br label %if_end_37
dead_r36:
  br label %if_elif_44
if_elif_44:
  store i64 110, ptr %t104.slot, align 8
  ; %t105:bool = cmp_eq_i64 c, %t104
  %r37 = load i64, ptr %t105.slot, align 8
  %r38 = icmp eq i64 %r37, 0
  br i1 %r38, label %if_end_37, label %fall_38
fall_38:
  store i64 1, ptr %t106.slot, align 8
  ; %t107:i64 = st[%t106]
  store i64 4, ptr %t108.slot, align 8
  ; %t109:i64 = add_i64 %t107, %t108
  store i64 2, ptr %t110.slot, align 8
  ; %t111:i64 = st[%t110]
  ; %t112:bool = cmp_le_i64 %t109, %t111
  store i64 0, ptr %t113.slot, align 8
  ; %t114:str = st[%t113]
  store i64 1, ptr %t115.slot, align 8
  ; %t116:i64 = st[%t115]
  store i64 1, ptr %t117.slot, align 8
  ; %t118:i64 = st[%t117]
  store i64 4, ptr %t119.slot, align 8
  ; %t120:i64 = add_i64 %t118, %t119
  ; %t121:str = str_slice(%t114[%t116:%t120])
  ; %t122:str = const_str 11
  ; %t123:bool = str_cmp_eq %t121, %t122
  ; %t124:bool = and_i64 %t112, %t123
  %r39 = load i64, ptr %t124.slot, align 8
  %r40 = icmp eq i64 %r39, 0
  br i1 %r40, label %if_end_46, label %fall_40
fall_40:
  store i64 1, ptr %t125.slot, align 8
  ; %t126:i64 = st[%t125]
  store i64 4, ptr %t127.slot, align 8
  ; %t128:i64 = add_i64 %t126, %t127
  store i64 1, ptr %t129.slot, align 8
  ; st[%t129] = %t128  ; i64
  store i64 0, ptr %t130.slot, align 8
  ; %t131:str = const_str 0
  ; %t132:str = const_str 0
  store i64 0, ptr %t133.slot, align 8
  store double 0.000000e+00, ptr %t134.slot, align 8
  ; %t135:i64 = call json_alloc_node(doc, %t130, %t131, %t132, %t133, %t134)
  %r41 = load i64, ptr %t135.slot, align 8
  ret i64 %r41
ret_cont_41:
  br label %if_end_46
dead_r42:
  br label %if_end_46
if_end_46:
  br label %if_end_37
dead_r43:
  br label %if_end_37
if_end_37:
  ; %t136:str = const_str 12
  store i64 3, ptr %t137.slot, align 8
  ; st[%t137] = %t136  ; str
  store i64 1, ptr %t138.slot, align 8
  ; %t139:i64 = neg_i64 %t138
  %r44 = load i64, ptr %t139.slot, align 8
  ret i64 %r44
ret_cont_44:
  ret i64 0
}

define dso_local i64 @json_parse_arr(i64 %st.arg, i64 %doc.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %arr_idx.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %prev_child.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
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
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
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
  %child_idx.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca ptr, align 8
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
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca ptr, align 8
  %t70.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
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
  %t85.slot = alloca ptr, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca ptr, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  store i64 %st.arg, ptr %st.slot, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = st[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 1, ptr %t5.slot, align 8
  ; st[%t5] = %t4  ; i64
  store i64 5, ptr %t6.slot, align 8
  ; %t7:str = const_str 0
  ; %t8:str = const_str 0
  store i64 0, ptr %t9.slot, align 8
  store double 0.000000e+00, ptr %t10.slot, align 8
  ; %t11:i64 = call json_alloc_node(doc, %t6, %t7, %t8, %t9, %t10)
  %r1 = load i64, ptr %t11.slot, align 8
  store i64 %r1, ptr %arr_idx.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r2 = load i64, ptr %t13.slot, align 8
  store i64 %r2, ptr %prev_child.slot, align 8
  store i64 0, ptr %t14.slot, align 8
  %r3 = load i64, ptr %t14.slot, align 8
  store i64 %r3, ptr %count.slot, align 8
  br label %while_cond_47
while_cond_47:
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = st[%t15]
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = st[%t17]
  ; %t19:bool = cmp_lt_i64 %t16, %t18
  %r4 = load i64, ptr %t19.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %while_end_48, label %fall_5
fall_5:
  ; %t20:i64 = call json_skip_ws(st)
  store i64 1, ptr %t21.slot, align 8
  ; %t22:i64 = st[%t21]
  store i64 2, ptr %t23.slot, align 8
  ; %t24:i64 = st[%t23]
  ; %t25:bool = cmp_lt_i64 %t22, %t24
  store i64 0, ptr %t26.slot, align 8
  ; %t27:str = st[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = st[%t28]
  ; %t30:str = str_index(%t27[%t29])
  ; %t31:i64 = str_ord %t30
  store i64 93, ptr %t32.slot, align 8
  ; %t33:bool = cmp_eq_i64 %t31, %t32
  ; %t34:bool = and_i64 %t25, %t33
  %r6 = load i64, ptr %t34.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_49, label %fall_7
fall_7:
  store i64 1, ptr %t35.slot, align 8
  ; %t36:i64 = st[%t35]
  store i64 1, ptr %t37.slot, align 8
  ; %t38:i64 = add_i64 %t36, %t37
  store i64 1, ptr %t39.slot, align 8
  ; st[%t39] = %t38  ; i64
  br label %while_end_48
dead_r8:
  br label %if_end_49
dead_r9:
  br label %if_end_49
if_end_49:
  ; %t40:i64 = call json_parse_val(st, doc)
  %r10 = load i64, ptr %t40.slot, align 8
  store i64 %r10, ptr %child_idx.slot, align 8
  store i64 1, ptr %t41.slot, align 8
  ; %t42:i64 = neg_i64 %t41
  ; %t43:bool = cmp_eq_i64 child_idx, %t42
  %r11 = load i64, ptr %t43.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_end_50, label %fall_12
fall_12:
  store i64 1, ptr %t44.slot, align 8
  ; %t45:i64 = neg_i64 %t44
  %r13 = load i64, ptr %t45.slot, align 8
  ret i64 %r13
ret_cont_13:
  br label %if_end_50
dead_r14:
  br label %if_end_50
if_end_50:
  store i64 1, ptr %t46.slot, align 8
  ; %t47:i64 = neg_i64 %t46
  ; %t48:bool = cmp_eq_i64 prev_child, %t47
  %r15 = load i64, ptr %t48.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_next_52, label %fall_16
fall_16:
  store i64 4, ptr %t49.slot, align 8
  ; %t50:Array[JsonNode] = doc[%t49]
  ; %t51:JsonNode = %t50[arr_idx]
  store i64 5, ptr %t52.slot, align 8
  ; %t51[%t52] = child_idx  ; i64
  br label %if_end_51
dead_r17:
  br label %if_next_52
if_next_52:
  store i64 4, ptr %t53.slot, align 8
  ; %t54:Array[JsonNode] = doc[%t53]
  ; %t55:JsonNode = %t54[prev_child]
  store i64 6, ptr %t56.slot, align 8
  ; %t55[%t56] = child_idx  ; i64
  br label %if_end_51
if_end_51:
  %r18 = load i64, ptr %child_idx.slot, align 8
  store i64 %r18, ptr %prev_child.slot, align 8
  store i64 1, ptr %t57.slot, align 8
  ; %t58:i64 = add_i64 count, %t57
  %r19 = load i64, ptr %t58.slot, align 8
  store i64 %r19, ptr %count.slot, align 8
  ; %t59:i64 = call json_skip_ws(st)
  store i64 1, ptr %t60.slot, align 8
  ; %t61:i64 = st[%t60]
  store i64 2, ptr %t62.slot, align 8
  ; %t63:i64 = st[%t62]
  ; %t64:bool = cmp_lt_i64 %t61, %t63
  %r20 = load i64, ptr %t64.slot, align 8
  %r21 = icmp eq i64 %r20, 0
  br i1 %r21, label %if_end_53, label %fall_21
fall_21:
  store i64 0, ptr %t65.slot, align 8
  ; %t66:str = st[%t65]
  store i64 1, ptr %t67.slot, align 8
  ; %t68:i64 = st[%t67]
  ; %t69:str = str_index(%t66[%t68])
  ; %t70:i64 = str_ord %t69
  %r22 = load i64, ptr %t70.slot, align 8
  store i64 %r22, ptr %c.slot, align 8
  store i64 44, ptr %t71.slot, align 8
  ; %t72:bool = cmp_eq_i64 c, %t71
  %r23 = load i64, ptr %t72.slot, align 8
  %r24 = icmp eq i64 %r23, 0
  br i1 %r24, label %if_next_55, label %fall_24
fall_24:
  store i64 1, ptr %t73.slot, align 8
  ; %t74:i64 = st[%t73]
  store i64 1, ptr %t75.slot, align 8
  ; %t76:i64 = add_i64 %t74, %t75
  store i64 1, ptr %t77.slot, align 8
  ; st[%t77] = %t76  ; i64
  br label %if_end_54
dead_r25:
  br label %if_next_55
if_next_55:
  store i64 93, ptr %t78.slot, align 8
  ; %t79:bool = cmp_eq_i64 c, %t78
  %r26 = load i64, ptr %t79.slot, align 8
  %r27 = icmp eq i64 %r26, 0
  br i1 %r27, label %if_elif_56, label %fall_27
fall_27:
  store i64 1, ptr %t80.slot, align 8
  ; %t81:i64 = st[%t80]
  store i64 1, ptr %t82.slot, align 8
  ; %t83:i64 = add_i64 %t81, %t82
  store i64 1, ptr %t84.slot, align 8
  ; st[%t84] = %t83  ; i64
  br label %while_end_48
dead_r28:
  br label %if_end_54
dead_r29:
  br label %if_elif_56
if_elif_56:
  ; %t85:str = const_str 13
  store i64 3, ptr %t86.slot, align 8
  ; st[%t86] = %t85  ; str
  store i64 1, ptr %t87.slot, align 8
  ; %t88:i64 = neg_i64 %t87
  %r30 = load i64, ptr %t88.slot, align 8
  ret i64 %r30
ret_cont_30:
  br label %if_end_54
if_end_54:
  br label %if_end_53
dead_r31:
  br label %if_end_53
if_end_53:
  br label %while_cond_47
dead_r32:
  br label %while_end_48
while_end_48:
  store i64 4, ptr %t89.slot, align 8
  ; %t90:Array[JsonNode] = doc[%t89]
  ; %t91:JsonNode = %t90[arr_idx]
  store i64 7, ptr %t92.slot, align 8
  ; %t91[%t92] = count  ; i64
  %r33 = load i64, ptr %arr_idx.slot, align 8
  ret i64 %r33
ret_cont_33:
  ret i64 0
}

define dso_local i64 @json_parse_obj(i64 %st.arg, i64 %doc.arg) #0 {
entry:
  %st.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %prev_child.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %count.slot = alloca i64, align 8
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
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca ptr, align 8
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
  %t41.slot = alloca ptr, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca ptr, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca ptr, align 8
  %key.slot = alloca ptr, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca i64, align 8
  %t62.slot = alloca i64, align 8
  %t63.slot = alloca ptr, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %t71.slot = alloca i64, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca i64, align 8
  %t77.slot = alloca i64, align 8
  %child_idx.slot = alloca i64, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca ptr, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca ptr, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca i64, align 8
  %t95.slot = alloca ptr, align 8
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
  %t107.slot = alloca ptr, align 8
  %t108.slot = alloca i64, align 8
  %t109.slot = alloca i64, align 8
  %t110.slot = alloca ptr, align 8
  %t111.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
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
  %t126.slot = alloca ptr, align 8
  %t127.slot = alloca i64, align 8
  %t128.slot = alloca i64, align 8
  %t129.slot = alloca i64, align 8
  %t130.slot = alloca i64, align 8
  %t131.slot = alloca ptr, align 8
  %t132.slot = alloca i64, align 8
  %t133.slot = alloca i64, align 8
  store i64 %st.arg, ptr %st.slot, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 1, ptr %t1.slot, align 8
  ; %t2:i64 = st[%t1]
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = add_i64 %t2, %t3
  store i64 1, ptr %t5.slot, align 8
  ; st[%t5] = %t4  ; i64
  store i64 6, ptr %t6.slot, align 8
  ; %t7:str = const_str 0
  ; %t8:str = const_str 0
  store i64 0, ptr %t9.slot, align 8
  store double 0.000000e+00, ptr %t10.slot, align 8
  ; %t11:i64 = call json_alloc_node(doc, %t6, %t7, %t8, %t9, %t10)
  %r1 = load i64, ptr %t11.slot, align 8
  store i64 %r1, ptr %obj_idx.slot, align 8
  store i64 1, ptr %t12.slot, align 8
  ; %t13:i64 = neg_i64 %t12
  %r2 = load i64, ptr %t13.slot, align 8
  store i64 %r2, ptr %prev_child.slot, align 8
  store i64 0, ptr %t14.slot, align 8
  %r3 = load i64, ptr %t14.slot, align 8
  store i64 %r3, ptr %count.slot, align 8
  br label %while_cond_57
while_cond_57:
  store i64 1, ptr %t15.slot, align 8
  ; %t16:i64 = st[%t15]
  store i64 2, ptr %t17.slot, align 8
  ; %t18:i64 = st[%t17]
  ; %t19:bool = cmp_lt_i64 %t16, %t18
  %r4 = load i64, ptr %t19.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %while_end_58, label %fall_5
fall_5:
  ; %t20:i64 = call json_skip_ws(st)
  store i64 1, ptr %t21.slot, align 8
  ; %t22:i64 = st[%t21]
  store i64 2, ptr %t23.slot, align 8
  ; %t24:i64 = st[%t23]
  ; %t25:bool = cmp_lt_i64 %t22, %t24
  store i64 0, ptr %t26.slot, align 8
  ; %t27:str = st[%t26]
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = st[%t28]
  ; %t30:str = str_index(%t27[%t29])
  ; %t31:i64 = str_ord %t30
  store i64 125, ptr %t32.slot, align 8
  ; %t33:bool = cmp_eq_i64 %t31, %t32
  ; %t34:bool = and_i64 %t25, %t33
  %r6 = load i64, ptr %t34.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_end_59, label %fall_7
fall_7:
  store i64 1, ptr %t35.slot, align 8
  ; %t36:i64 = st[%t35]
  store i64 1, ptr %t37.slot, align 8
  ; %t38:i64 = add_i64 %t36, %t37
  store i64 1, ptr %t39.slot, align 8
  ; st[%t39] = %t38  ; i64
  br label %while_end_58
dead_r8:
  br label %if_end_59
dead_r9:
  br label %if_end_59
if_end_59:
  store i64 0, ptr %t40.slot, align 8
  ; %t41:str = st[%t40]
  store i64 1, ptr %t42.slot, align 8
  ; %t43:i64 = st[%t42]
  ; %t44:str = str_index(%t41[%t43])
  ; %t45:i64 = str_ord %t44
  store i64 34, ptr %t46.slot, align 8
  ; %t47:bool = cmp_ne_i64 %t45, %t46
  %r10 = load i64, ptr %t47.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_60, label %fall_11
fall_11:
  ; %t48:str = const_str 14
  store i64 3, ptr %t49.slot, align 8
  ; st[%t49] = %t48  ; str
  store i64 1, ptr %t50.slot, align 8
  ; %t51:i64 = neg_i64 %t50
  %r12 = load i64, ptr %t51.slot, align 8
  ret i64 %r12
ret_cont_12:
  br label %if_end_60
dead_r13:
  br label %if_end_60
if_end_60:
  ; %t52:str = call json_parse_str(st)
  %r14 = load ptr, ptr %t52.slot, align 8
  store ptr %r14, ptr %key.slot, align 8
  ; %t53:i64 = call json_skip_ws(st)
  store i64 1, ptr %t54.slot, align 8
  ; %t55:i64 = st[%t54]
  store i64 2, ptr %t56.slot, align 8
  ; %t57:i64 = st[%t56]
  ; %t58:bool = cmp_ge_i64 %t55, %t57
  store i64 0, ptr %t59.slot, align 8
  ; %t60:str = st[%t59]
  store i64 1, ptr %t61.slot, align 8
  ; %t62:i64 = st[%t61]
  ; %t63:str = str_index(%t60[%t62])
  ; %t64:i64 = str_ord %t63
  store i64 58, ptr %t65.slot, align 8
  ; %t66:bool = cmp_ne_i64 %t64, %t65
  ; %t67:bool = or_i64 %t58, %t66
  %r15 = load i64, ptr %t67.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_61, label %fall_16
fall_16:
  ; %t68:str = const_str 15
  store i64 3, ptr %t69.slot, align 8
  ; st[%t69] = %t68  ; str
  store i64 1, ptr %t70.slot, align 8
  ; %t71:i64 = neg_i64 %t70
  %r17 = load i64, ptr %t71.slot, align 8
  ret i64 %r17
ret_cont_17:
  br label %if_end_61
dead_r18:
  br label %if_end_61
if_end_61:
  store i64 1, ptr %t72.slot, align 8
  ; %t73:i64 = st[%t72]
  store i64 1, ptr %t74.slot, align 8
  ; %t75:i64 = add_i64 %t73, %t74
  store i64 1, ptr %t76.slot, align 8
  ; st[%t76] = %t75  ; i64
  ; %t77:i64 = call json_parse_val(st, doc)
  %r19 = load i64, ptr %t77.slot, align 8
  store i64 %r19, ptr %child_idx.slot, align 8
  store i64 1, ptr %t78.slot, align 8
  ; %t79:i64 = neg_i64 %t78
  ; %t80:bool = cmp_eq_i64 child_idx, %t79
  %r20 = load i64, ptr %t80.slot, align 8
  %r21 = icmp eq i64 %r20, 0
  br i1 %r21, label %if_end_62, label %fall_21
fall_21:
  store i64 1, ptr %t81.slot, align 8
  ; %t82:i64 = neg_i64 %t81
  %r22 = load i64, ptr %t82.slot, align 8
  ret i64 %r22
ret_cont_22:
  br label %if_end_62
dead_r23:
  br label %if_end_62
if_end_62:
  store i64 4, ptr %t83.slot, align 8
  ; %t84:Array[JsonNode] = doc[%t83]
  ; %t85:JsonNode = %t84[child_idx]
  store i64 1, ptr %t86.slot, align 8
  ; %t85[%t86] = key  ; str
  store i64 1, ptr %t87.slot, align 8
  ; %t88:i64 = neg_i64 %t87
  ; %t89:bool = cmp_eq_i64 prev_child, %t88
  %r24 = load i64, ptr %t89.slot, align 8
  %r25 = icmp eq i64 %r24, 0
  br i1 %r25, label %if_next_64, label %fall_25
fall_25:
  store i64 4, ptr %t90.slot, align 8
  ; %t91:Array[JsonNode] = doc[%t90]
  ; %t92:JsonNode = %t91[obj_idx]
  store i64 5, ptr %t93.slot, align 8
  ; %t92[%t93] = child_idx  ; i64
  br label %if_end_63
dead_r26:
  br label %if_next_64
if_next_64:
  store i64 4, ptr %t94.slot, align 8
  ; %t95:Array[JsonNode] = doc[%t94]
  ; %t96:JsonNode = %t95[prev_child]
  store i64 6, ptr %t97.slot, align 8
  ; %t96[%t97] = child_idx  ; i64
  br label %if_end_63
if_end_63:
  %r27 = load i64, ptr %child_idx.slot, align 8
  store i64 %r27, ptr %prev_child.slot, align 8
  store i64 1, ptr %t98.slot, align 8
  ; %t99:i64 = add_i64 count, %t98
  %r28 = load i64, ptr %t99.slot, align 8
  store i64 %r28, ptr %count.slot, align 8
  ; %t100:i64 = call json_skip_ws(st)
  store i64 1, ptr %t101.slot, align 8
  ; %t102:i64 = st[%t101]
  store i64 2, ptr %t103.slot, align 8
  ; %t104:i64 = st[%t103]
  ; %t105:bool = cmp_lt_i64 %t102, %t104
  %r29 = load i64, ptr %t105.slot, align 8
  %r30 = icmp eq i64 %r29, 0
  br i1 %r30, label %if_end_65, label %fall_30
fall_30:
  store i64 0, ptr %t106.slot, align 8
  ; %t107:str = st[%t106]
  store i64 1, ptr %t108.slot, align 8
  ; %t109:i64 = st[%t108]
  ; %t110:str = str_index(%t107[%t109])
  ; %t111:i64 = str_ord %t110
  %r31 = load i64, ptr %t111.slot, align 8
  store i64 %r31, ptr %c.slot, align 8
  store i64 44, ptr %t112.slot, align 8
  ; %t113:bool = cmp_eq_i64 c, %t112
  %r32 = load i64, ptr %t113.slot, align 8
  %r33 = icmp eq i64 %r32, 0
  br i1 %r33, label %if_next_67, label %fall_33
fall_33:
  store i64 1, ptr %t114.slot, align 8
  ; %t115:i64 = st[%t114]
  store i64 1, ptr %t116.slot, align 8
  ; %t117:i64 = add_i64 %t115, %t116
  store i64 1, ptr %t118.slot, align 8
  ; st[%t118] = %t117  ; i64
  br label %if_end_66
dead_r34:
  br label %if_next_67
if_next_67:
  store i64 125, ptr %t119.slot, align 8
  ; %t120:bool = cmp_eq_i64 c, %t119
  %r35 = load i64, ptr %t120.slot, align 8
  %r36 = icmp eq i64 %r35, 0
  br i1 %r36, label %if_elif_68, label %fall_36
fall_36:
  store i64 1, ptr %t121.slot, align 8
  ; %t122:i64 = st[%t121]
  store i64 1, ptr %t123.slot, align 8
  ; %t124:i64 = add_i64 %t122, %t123
  store i64 1, ptr %t125.slot, align 8
  ; st[%t125] = %t124  ; i64
  br label %while_end_58
dead_r37:
  br label %if_end_66
dead_r38:
  br label %if_elif_68
if_elif_68:
  ; %t126:str = const_str 16
  store i64 3, ptr %t127.slot, align 8
  ; st[%t127] = %t126  ; str
  store i64 1, ptr %t128.slot, align 8
  ; %t129:i64 = neg_i64 %t128
  %r39 = load i64, ptr %t129.slot, align 8
  ret i64 %r39
ret_cont_39:
  br label %if_end_66
if_end_66:
  br label %if_end_65
dead_r40:
  br label %if_end_65
if_end_65:
  br label %while_cond_57
dead_r41:
  br label %while_end_58
while_end_58:
  store i64 4, ptr %t130.slot, align 8
  ; %t131:Array[JsonNode] = doc[%t130]
  ; %t132:JsonNode = %t131[obj_idx]
  store i64 7, ptr %t133.slot, align 8
  ; %t132[%t133] = count  ; i64
  %r42 = load i64, ptr %obj_idx.slot, align 8
  ret i64 %r42
ret_cont_42:
  ret i64 0
}

define dso_local i64 @json_parse(ptr %text.arg, i64 %max_nodes.arg) #0 {
entry:
  %text.slot = alloca ptr, align 8
  %max_nodes.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %st.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  store ptr %text.arg, ptr %text.slot, align 8
  store i64 %max_nodes.arg, ptr %max_nodes.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:JsonDoc = call json_doc_new(max_nodes)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %doc.slot, align 8
  store i64 4, ptr %t3.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t2:JsonParserState = alloc_array(%t3, init=%t4)
  store i64 0, ptr %t5.slot, align 8
  ; %t2[%t5] = text  ; str
  store i64 0, ptr %t6.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  ; %t2[%t7] = %t6  ; i64
  ; %t8:i64 = str_len(text)
  store i64 2, ptr %t9.slot, align 8
  ; %t2[%t9] = %t8  ; i64
  ; %t10:str = const_str 0
  store i64 3, ptr %t11.slot, align 8
  ; %t2[%t11] = %t10  ; str
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %st.slot, align 8
  ; %t12:i64 = call json_parse_val(st, doc)
  store i64 0, ptr %t13.slot, align 8
  ; doc[%t13] = %t12  ; i64
  store i64 3, ptr %t14.slot, align 8
  ; %t15:str = st[%t14]
  store i64 3, ptr %t16.slot, align 8
  ; doc[%t16] = %t15  ; str
  %r3 = load i64, ptr %doc.slot, align 8
  ret i64 %r3
ret_cont_3:
  ret i64 0
}

define dso_local i64 @json_get(i64 %doc.arg, i64 %obj_idx.arg, ptr %key.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %curr.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %obj_idx.arg, ptr %obj_idx.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 obj_idx, %t1
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = doc[%t3]
  ; %t5:bool = cmp_ge_i64 obj_idx, %t4
  ; %t6:bool = or_i64 %t2, %t5
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_69, label %fall_2
fall_2:
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = neg_i64 %t7
  %r3 = load i64, ptr %t8.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_69
dead_r4:
  br label %if_end_69
if_end_69:
  store i64 4, ptr %t9.slot, align 8
  ; %t10:Array[JsonNode] = doc[%t9]
  ; %t11:JsonNode = %t10[obj_idx]
  store i64 5, ptr %t12.slot, align 8
  ; %t13:i64 = %t11[%t12]
  %r5 = load i64, ptr %t13.slot, align 8
  store i64 %r5, ptr %curr.slot, align 8
  br label %while_cond_70
while_cond_70:
  store i64 1, ptr %t14.slot, align 8
  ; %t15:i64 = neg_i64 %t14
  ; %t16:bool = cmp_ne_i64 curr, %t15
  %r6 = load i64, ptr %t16.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %while_end_71, label %fall_7
fall_7:
  store i64 4, ptr %t17.slot, align 8
  ; %t18:Array[JsonNode] = doc[%t17]
  ; %t19:JsonNode = %t18[curr]
  store i64 1, ptr %t20.slot, align 8
  ; %t21:str = %t19[%t20]
  ; %t22:bool = str_cmp_eq %t21, key
  %r8 = load i64, ptr %t22.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %if_end_72, label %fall_9
fall_9:
  %r10 = load i64, ptr %curr.slot, align 8
  ret i64 %r10
ret_cont_10:
  br label %if_end_72
dead_r11:
  br label %if_end_72
if_end_72:
  store i64 4, ptr %t23.slot, align 8
  ; %t24:Array[JsonNode] = doc[%t23]
  ; %t25:JsonNode = %t24[curr]
  store i64 6, ptr %t26.slot, align 8
  ; %t27:i64 = %t25[%t26]
  %r12 = load i64, ptr %t27.slot, align 8
  store i64 %r12, ptr %curr.slot, align 8
  br label %while_cond_70
dead_r13:
  br label %while_end_71
while_end_71:
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = neg_i64 %t28
  %r14 = load i64, ptr %t29.slot, align 8
  ret i64 %r14
ret_cont_14:
  ret i64 0
}

define dso_local ptr @json_get_str(i64 %doc.arg, i64 %obj_idx.arg, ptr %key.arg, ptr %default_val.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %default_val.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca ptr, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %obj_idx.arg, ptr %obj_idx.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store ptr %default_val.arg, ptr %default_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call json_get(doc, obj_idx, key)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %idx.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = neg_i64 %t2
  ; %t4:bool = cmp_ne_i64 idx, %t3
  store i64 4, ptr %t5.slot, align 8
  ; %t6:Array[JsonNode] = doc[%t5]
  ; %t7:JsonNode = %t6[idx]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  store i64 4, ptr %t10.slot, align 8
  ; %t11:bool = cmp_eq_i64 %t9, %t10
  ; %t12:bool = and_i64 %t4, %t11
  %r2 = load i64, ptr %t12.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_73, label %fall_3
fall_3:
  store i64 4, ptr %t13.slot, align 8
  ; %t14:Array[JsonNode] = doc[%t13]
  ; %t15:JsonNode = %t14[idx]
  store i64 2, ptr %t16.slot, align 8
  ; %t17:str = %t15[%t16]
  %r4 = load ptr, ptr %t17.slot, align 8
  ret ptr %r4
ret_cont_4:
  br label %if_end_73
dead_r5:
  br label %if_end_73
if_end_73:
  %r6 = load ptr, ptr %default_val.slot, align 8
  ret ptr %r6
ret_cont_6:
  ret ptr 0
}

define dso_local i64 @json_get_int(i64 %doc.arg, i64 %obj_idx.arg, ptr %key.arg, i64 %default_val.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %default_val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %obj_idx.arg, ptr %obj_idx.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store i64 %default_val.arg, ptr %default_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call json_get(doc, obj_idx, key)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %idx.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = neg_i64 %t2
  ; %t4:bool = cmp_ne_i64 idx, %t3
  store i64 4, ptr %t5.slot, align 8
  ; %t6:Array[JsonNode] = doc[%t5]
  ; %t7:JsonNode = %t6[idx]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  store i64 2, ptr %t10.slot, align 8
  ; %t11:bool = cmp_eq_i64 %t9, %t10
  ; %t12:bool = and_i64 %t4, %t11
  %r2 = load i64, ptr %t12.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_74, label %fall_3
fall_3:
  store i64 4, ptr %t13.slot, align 8
  ; %t14:Array[JsonNode] = doc[%t13]
  ; %t15:JsonNode = %t14[idx]
  store i64 3, ptr %t16.slot, align 8
  ; %t17:i64 = %t15[%t16]
  %r4 = load i64, ptr %t17.slot, align 8
  ret i64 %r4
ret_cont_4:
  br label %if_end_74
dead_r5:
  br label %if_end_74
if_end_74:
  %r6 = load i64, ptr %default_val.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local double @json_get_float(i64 %doc.arg, i64 %obj_idx.arg, ptr %key.arg, double %default_val.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %default_val.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca double, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %obj_idx.arg, ptr %obj_idx.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store double %default_val.arg, ptr %default_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call json_get(doc, obj_idx, key)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %idx.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = neg_i64 %t2
  ; %t4:bool = cmp_ne_i64 idx, %t3
  store i64 4, ptr %t5.slot, align 8
  ; %t6:Array[JsonNode] = doc[%t5]
  ; %t7:JsonNode = %t6[idx]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  store i64 3, ptr %t10.slot, align 8
  ; %t11:bool = cmp_eq_i64 %t9, %t10
  ; %t12:bool = and_i64 %t4, %t11
  %r2 = load i64, ptr %t12.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_75, label %fall_3
fall_3:
  store i64 4, ptr %t13.slot, align 8
  ; %t14:Array[JsonNode] = doc[%t13]
  ; %t15:JsonNode = %t14[idx]
  store i64 4, ptr %t16.slot, align 8
  ; %t17:f64 = %t15[%t16]
  %r4 = load double, ptr %t17.slot, align 8
  ret double %r4
ret_cont_4:
  br label %if_end_75
dead_r5:
  br label %if_end_75
if_end_75:
  %r6 = load double, ptr %default_val.slot, align 8
  ret double %r6
ret_cont_6:
  ret double 0.0
}

define dso_local i64 @json_get_bool(i64 %doc.arg, i64 %obj_idx.arg, ptr %key.arg, i64 %default_val.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %obj_idx.slot = alloca i64, align 8
  %key.slot = alloca ptr, align 8
  %default_val.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %idx.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %obj_idx.arg, ptr %obj_idx.slot, align 8
  store ptr %key.arg, ptr %key.slot, align 8
  store i64 %default_val.arg, ptr %default_val.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call json_get(doc, obj_idx, key)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %idx.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  ; %t3:i64 = neg_i64 %t2
  ; %t4:bool = cmp_ne_i64 idx, %t3
  store i64 4, ptr %t5.slot, align 8
  ; %t6:Array[JsonNode] = doc[%t5]
  ; %t7:JsonNode = %t6[idx]
  store i64 0, ptr %t8.slot, align 8
  ; %t9:i64 = %t7[%t8]
  store i64 1, ptr %t10.slot, align 8
  ; %t11:bool = cmp_eq_i64 %t9, %t10
  ; %t12:bool = and_i64 %t4, %t11
  %r2 = load i64, ptr %t12.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_76, label %fall_3
fall_3:
  store i64 4, ptr %t13.slot, align 8
  ; %t14:Array[JsonNode] = doc[%t13]
  ; %t15:JsonNode = %t14[idx]
  store i64 3, ptr %t16.slot, align 8
  ; %t17:i64 = %t15[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:bool = cmp_eq_i64 %t17, %t18
  %r4 = load i64, ptr %t19.slot, align 8
  ret i64 %r4
ret_cont_4:
  br label %if_end_76
dead_r5:
  br label %if_end_76
if_end_76:
  %r6 = load i64, ptr %default_val.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @json_array_get(i64 %doc.arg, i64 %arr_idx.arg, i64 %index.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %arr_idx.slot = alloca i64, align 8
  %index.slot = alloca i64, align 8
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
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %curr.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %arr_idx.arg, ptr %arr_idx.slot, align 8
  store i64 %index.arg, ptr %index.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 arr_idx, %t1
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = doc[%t3]
  ; %t5:bool = cmp_ge_i64 arr_idx, %t4
  ; %t6:bool = or_i64 %t2, %t5
  store i64 0, ptr %t7.slot, align 8
  ; %t8:bool = cmp_lt_i64 index, %t7
  ; %t9:bool = or_i64 %t6, %t8
  %r1 = load i64, ptr %t9.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_77, label %fall_2
fall_2:
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = neg_i64 %t10
  %r3 = load i64, ptr %t11.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_77
dead_r4:
  br label %if_end_77
if_end_77:
  store i64 4, ptr %t12.slot, align 8
  ; %t13:Array[JsonNode] = doc[%t12]
  ; %t14:JsonNode = %t13[arr_idx]
  store i64 5, ptr %t15.slot, align 8
  ; %t16:i64 = %t14[%t15]
  %r5 = load i64, ptr %t16.slot, align 8
  store i64 %r5, ptr %curr.slot, align 8
  store i64 0, ptr %t17.slot, align 8
  %r6 = load i64, ptr %t17.slot, align 8
  store i64 %r6, ptr %i.slot, align 8
  br label %while_cond_78
while_cond_78:
  store i64 1, ptr %t18.slot, align 8
  ; %t19:i64 = neg_i64 %t18
  ; %t20:bool = cmp_ne_i64 curr, %t19
  %r7 = load i64, ptr %t20.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %while_end_79, label %fall_8
fall_8:
  ; %t21:bool = cmp_eq_i64 i, index
  %r9 = load i64, ptr %t21.slot, align 8
  %r10 = icmp eq i64 %r9, 0
  br i1 %r10, label %if_end_80, label %fall_10
fall_10:
  %r11 = load i64, ptr %curr.slot, align 8
  ret i64 %r11
ret_cont_11:
  br label %if_end_80
dead_r12:
  br label %if_end_80
if_end_80:
  store i64 4, ptr %t22.slot, align 8
  ; %t23:Array[JsonNode] = doc[%t22]
  ; %t24:JsonNode = %t23[curr]
  store i64 6, ptr %t25.slot, align 8
  ; %t26:i64 = %t24[%t25]
  %r13 = load i64, ptr %t26.slot, align 8
  store i64 %r13, ptr %curr.slot, align 8
  store i64 1, ptr %t27.slot, align 8
  ; %t28:i64 = add_i64 i, %t27
  %r14 = load i64, ptr %t28.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %while_cond_78
dead_r15:
  br label %while_end_79
while_end_79:
  store i64 1, ptr %t29.slot, align 8
  ; %t30:i64 = neg_i64 %t29
  %r16 = load i64, ptr %t30.slot, align 8
  ret i64 %r16
ret_cont_16:
  ret i64 0
}

define dso_local i64 @json_array_len(i64 %doc.arg, i64 %arr_idx.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %arr_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %arr_idx.arg, ptr %arr_idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 arr_idx, %t1
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = doc[%t3]
  ; %t5:bool = cmp_ge_i64 arr_idx, %t4
  ; %t6:bool = or_i64 %t2, %t5
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_81, label %fall_2
fall_2:
  store i64 0, ptr %t7.slot, align 8
  %r3 = load i64, ptr %t7.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_81
dead_r4:
  br label %if_end_81
if_end_81:
  store i64 4, ptr %t8.slot, align 8
  ; %t9:Array[JsonNode] = doc[%t8]
  ; %t10:JsonNode = %t9[arr_idx]
  store i64 7, ptr %t11.slot, align 8
  ; %t12:i64 = %t10[%t11]
  %r5 = load i64, ptr %t12.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local ptr @json_escape_str(ptr %s.arg) #0 {
entry:
  %s.slot = alloca ptr, align 8
  %t1.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %length.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %c.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca ptr, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca ptr, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca ptr, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  store ptr %s.arg, ptr %s.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 6
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %res.slot, align 8
  ; %t2:i64 = str_len(s)
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %length.slot, align 8
  store i64 0, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %i.slot, align 8
  br label %while_cond_82
while_cond_82:
  ; %t4:bool = cmp_lt_i64 i, length
  %r4 = load i64, ptr %t4.slot, align 8
  %r5 = icmp eq i64 %r4, 0
  br i1 %r5, label %while_end_83, label %fall_5
fall_5:
  ; %t5:str = str_index(s[i])
  ; %t6:i64 = str_ord %t5
  %r6 = load i64, ptr %t6.slot, align 8
  store i64 %r6, ptr %c.slot, align 8
  store i64 34, ptr %t7.slot, align 8
  ; %t8:bool = cmp_eq_i64 c, %t7
  %r7 = load i64, ptr %t8.slot, align 8
  %r8 = icmp eq i64 %r7, 0
  br i1 %r8, label %if_next_85, label %fall_8
fall_8:
  ; %t9:str = const_str 17
  ; %t10:str = str_concat(res, %t9)
  %r9 = load ptr, ptr %t10.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %if_end_84
dead_r10:
  br label %if_next_85
if_next_85:
  store i64 92, ptr %t11.slot, align 8
  ; %t12:bool = cmp_eq_i64 c, %t11
  %r11 = load i64, ptr %t12.slot, align 8
  %r12 = icmp eq i64 %r11, 0
  br i1 %r12, label %if_elif_86, label %fall_12
fall_12:
  ; %t13:str = const_str 18
  ; %t14:str = str_concat(res, %t13)
  %r13 = load ptr, ptr %t14.slot, align 8
  store ptr %r13, ptr %res.slot, align 8
  br label %if_end_84
dead_r14:
  br label %if_elif_86
if_elif_86:
  store i64 10, ptr %t15.slot, align 8
  ; %t16:bool = cmp_eq_i64 c, %t15
  %r15 = load i64, ptr %t16.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_elif_87, label %fall_16
fall_16:
  ; %t17:str = const_str 19
  ; %t18:str = str_concat(res, %t17)
  %r17 = load ptr, ptr %t18.slot, align 8
  store ptr %r17, ptr %res.slot, align 8
  br label %if_end_84
dead_r18:
  br label %if_elif_87
if_elif_87:
  store i64 9, ptr %t19.slot, align 8
  ; %t20:bool = cmp_eq_i64 c, %t19
  %r19 = load i64, ptr %t20.slot, align 8
  %r20 = icmp eq i64 %r19, 0
  br i1 %r20, label %if_elif_88, label %fall_20
fall_20:
  ; %t21:str = const_str 20
  ; %t22:str = str_concat(res, %t21)
  %r21 = load ptr, ptr %t22.slot, align 8
  store ptr %r21, ptr %res.slot, align 8
  br label %if_end_84
dead_r22:
  br label %if_elif_88
if_elif_88:
  store i64 13, ptr %t23.slot, align 8
  ; %t24:bool = cmp_eq_i64 c, %t23
  %r23 = load i64, ptr %t24.slot, align 8
  %r24 = icmp eq i64 %r23, 0
  br i1 %r24, label %if_elif_89, label %fall_24
fall_24:
  ; %t25:str = const_str 21
  ; %t26:str = str_concat(res, %t25)
  %r25 = load ptr, ptr %t26.slot, align 8
  store ptr %r25, ptr %res.slot, align 8
  br label %if_end_84
dead_r26:
  br label %if_elif_89
if_elif_89:
  ; %t27:str = str_chr c
  ; %t28:str = str_concat(res, %t27)
  %r27 = load ptr, ptr %t28.slot, align 8
  store ptr %r27, ptr %res.slot, align 8
  br label %if_end_84
if_end_84:
  store i64 1, ptr %t29.slot, align 8
  ; %t30:i64 = add_i64 i, %t29
  %r28 = load i64, ptr %t30.slot, align 8
  store i64 %r28, ptr %i.slot, align 8
  br label %while_cond_82
dead_r29:
  br label %while_end_83
while_end_83:
  ; %t31:str = const_str 6
  ; %t32:str = str_concat(res, %t31)
  %r30 = load ptr, ptr %t32.slot, align 8
  ret ptr %r30
ret_cont_30:
  ret ptr 0
}

define dso_local ptr @json_dumps(i64 %doc.arg, i64 %node_idx.arg) #0 {
entry:
  %doc.slot = alloca i64, align 8
  %node_idx.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %node.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca i64, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca i64, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca double, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca i64, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca i64, align 8
  %t51.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca i64, align 8
  %curr.slot = alloca i64, align 8
  %t54.slot = alloca i64, align 8
  %first.slot = alloca i64, align 8
  %t55.slot = alloca i64, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %t62.slot = alloca ptr, align 8
  %child_str.slot = alloca ptr, align 8
  %t63.slot = alloca ptr, align 8
  %t64.slot = alloca i64, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca i64, align 8
  %t68.slot = alloca i64, align 8
  %t69.slot = alloca i64, align 8
  %t70.slot = alloca ptr, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca i64, align 8
  %t75.slot = alloca i64, align 8
  %t76.slot = alloca ptr, align 8
  %t77.slot = alloca i64, align 8
  %t78.slot = alloca i64, align 8
  %t79.slot = alloca i64, align 8
  %t80.slot = alloca i64, align 8
  %t81.slot = alloca i64, align 8
  %t82.slot = alloca i64, align 8
  %t83.slot = alloca i64, align 8
  %t84.slot = alloca i64, align 8
  %t85.slot = alloca ptr, align 8
  %t86.slot = alloca ptr, align 8
  %t87.slot = alloca i64, align 8
  %t88.slot = alloca ptr, align 8
  %t89.slot = alloca i64, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca ptr, align 8
  %t92.slot = alloca ptr, align 8
  %k_esc.slot = alloca ptr, align 8
  %t93.slot = alloca ptr, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca ptr, align 8
  %t96.slot = alloca ptr, align 8
  %t97.slot = alloca ptr, align 8
  %t98.slot = alloca i64, align 8
  %t99.slot = alloca i64, align 8
  %t100.slot = alloca ptr, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca i64, align 8
  %t103.slot = alloca i64, align 8
  %t104.slot = alloca ptr, align 8
  %t105.slot = alloca ptr, align 8
  %t106.slot = alloca ptr, align 8
  store i64 %doc.arg, ptr %doc.slot, align 8
  store i64 %node_idx.arg, ptr %node_idx.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:bool = cmp_lt_i64 node_idx, %t1
  store i64 1, ptr %t3.slot, align 8
  ; %t4:i64 = doc[%t3]
  ; %t5:bool = cmp_ge_i64 node_idx, %t4
  ; %t6:bool = or_i64 %t2, %t5
  %r1 = load i64, ptr %t6.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_90, label %fall_2
fall_2:
  ; %t7:str = const_str 11
  %r3 = load ptr, ptr %t7.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_90
dead_r4:
  br label %if_end_90
if_end_90:
  store i64 4, ptr %t8.slot, align 8
  ; %t9:Array[JsonNode] = doc[%t8]
  ; %t10:JsonNode = %t9[node_idx]
  %r5 = load i64, ptr %t10.slot, align 8
  store i64 %r5, ptr %node.slot, align 8
  store i64 0, ptr %t11.slot, align 8
  ; %t12:i64 = node[%t11]
  store i64 0, ptr %t13.slot, align 8
  ; %t14:bool = cmp_eq_i64 %t12, %t13
  %r6 = load i64, ptr %t14.slot, align 8
  %r7 = icmp eq i64 %r6, 0
  br i1 %r7, label %if_next_92, label %fall_7
fall_7:
  ; %t15:str = const_str 11
  %r8 = load ptr, ptr %t15.slot, align 8
  ret ptr %r8
ret_cont_8:
  br label %if_end_91
dead_r9:
  br label %if_next_92
if_next_92:
  store i64 0, ptr %t16.slot, align 8
  ; %t17:i64 = node[%t16]
  store i64 1, ptr %t18.slot, align 8
  ; %t19:bool = cmp_eq_i64 %t17, %t18
  %r10 = load i64, ptr %t19.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_elif_93, label %fall_11
fall_11:
  store i64 3, ptr %t20.slot, align 8
  ; %t21:i64 = node[%t20]
  store i64 1, ptr %t22.slot, align 8
  ; %t23:bool = cmp_eq_i64 %t21, %t22
  %r12 = load i64, ptr %t23.slot, align 8
  %r13 = icmp eq i64 %r12, 0
  br i1 %r13, label %if_next_95, label %fall_13
fall_13:
  ; %t24:str = const_str 9
  %r14 = load ptr, ptr %t24.slot, align 8
  ret ptr %r14
ret_cont_14:
  br label %if_end_94
dead_r15:
  br label %if_next_95
if_next_95:
  ; %t25:str = const_str 10
  %r16 = load ptr, ptr %t25.slot, align 8
  ret ptr %r16
ret_cont_16:
  br label %if_end_94
if_end_94:
  br label %if_end_91
dead_r17:
  br label %if_elif_93
if_elif_93:
  store i64 0, ptr %t26.slot, align 8
  ; %t27:i64 = node[%t26]
  store i64 2, ptr %t28.slot, align 8
  ; %t29:bool = cmp_eq_i64 %t27, %t28
  %r18 = load i64, ptr %t29.slot, align 8
  %r19 = icmp eq i64 %r18, 0
  br i1 %r19, label %if_elif_96, label %fall_19
fall_19:
  store i64 3, ptr %t30.slot, align 8
  ; %t31:i64 = node[%t30]
  ; %t32:str = str_from_i64 %t31
  %r20 = load ptr, ptr %t32.slot, align 8
  ret ptr %r20
ret_cont_20:
  br label %if_end_91
dead_r21:
  br label %if_elif_96
if_elif_96:
  store i64 0, ptr %t33.slot, align 8
  ; %t34:i64 = node[%t33]
  store i64 3, ptr %t35.slot, align 8
  ; %t36:bool = cmp_eq_i64 %t34, %t35
  %r22 = load i64, ptr %t36.slot, align 8
  %r23 = icmp eq i64 %r22, 0
  br i1 %r23, label %if_elif_97, label %fall_23
fall_23:
  store i64 4, ptr %t37.slot, align 8
  ; %t38:f64 = node[%t37]
  ; %t39:str = str_from_f64 %t38
  %r24 = load ptr, ptr %t39.slot, align 8
  ret ptr %r24
ret_cont_24:
  br label %if_end_91
dead_r25:
  br label %if_elif_97
if_elif_97:
  store i64 0, ptr %t40.slot, align 8
  ; %t41:i64 = node[%t40]
  store i64 4, ptr %t42.slot, align 8
  ; %t43:bool = cmp_eq_i64 %t41, %t42
  %r26 = load i64, ptr %t43.slot, align 8
  %r27 = icmp eq i64 %r26, 0
  br i1 %r27, label %if_elif_98, label %fall_27
fall_27:
  store i64 2, ptr %t44.slot, align 8
  ; %t45:str = node[%t44]
  ; %t46:str = call json_escape_str(%t45)
  %r28 = load ptr, ptr %t46.slot, align 8
  ret ptr %r28
ret_cont_28:
  br label %if_end_91
dead_r29:
  br label %if_elif_98
if_elif_98:
  store i64 0, ptr %t47.slot, align 8
  ; %t48:i64 = node[%t47]
  store i64 5, ptr %t49.slot, align 8
  ; %t50:bool = cmp_eq_i64 %t48, %t49
  %r30 = load i64, ptr %t50.slot, align 8
  %r31 = icmp eq i64 %r30, 0
  br i1 %r31, label %if_elif_99, label %fall_31
fall_31:
  ; %t51:str = const_str 22
  %r32 = load ptr, ptr %t51.slot, align 8
  store ptr %r32, ptr %res.slot, align 8
  store i64 5, ptr %t52.slot, align 8
  ; %t53:i64 = node[%t52]
  %r33 = load i64, ptr %t53.slot, align 8
  store i64 %r33, ptr %curr.slot, align 8
  store i64 1, ptr %t54.slot, align 8
  %r34 = load i64, ptr %t54.slot, align 8
  store i64 %r34, ptr %first.slot, align 8
  br label %while_cond_100
while_cond_100:
  store i64 1, ptr %t55.slot, align 8
  ; %t56:i64 = neg_i64 %t55
  ; %t57:bool = cmp_ne_i64 curr, %t56
  %r35 = load i64, ptr %t57.slot, align 8
  %r36 = icmp eq i64 %r35, 0
  br i1 %r36, label %while_end_101, label %fall_36
fall_36:
  store i64 0, ptr %t59.slot, align 8
  ; %t58:bool = cmp_eq_i64 first, %t59
  %r37 = load i64, ptr %t58.slot, align 8
  %r38 = icmp eq i64 %r37, 0
  br i1 %r38, label %if_end_102, label %fall_38
fall_38:
  ; %t60:str = const_str 23
  ; %t61:str = str_concat(res, %t60)
  %r39 = load ptr, ptr %t61.slot, align 8
  store ptr %r39, ptr %res.slot, align 8
  br label %if_end_102
dead_r40:
  br label %if_end_102
if_end_102:
  ; %t62:str = call json_dumps(doc, curr)
  %r41 = load ptr, ptr %t62.slot, align 8
  store ptr %r41, ptr %child_str.slot, align 8
  ; %t63:str = str_concat(res, child_str)
  %r42 = load ptr, ptr %t63.slot, align 8
  store ptr %r42, ptr %res.slot, align 8
  store i64 0, ptr %t64.slot, align 8
  %r43 = load i64, ptr %t64.slot, align 8
  store i64 %r43, ptr %first.slot, align 8
  store i64 4, ptr %t65.slot, align 8
  ; %t66:Array[JsonNode] = doc[%t65]
  ; %t67:JsonNode = %t66[curr]
  store i64 6, ptr %t68.slot, align 8
  ; %t69:i64 = %t67[%t68]
  %r44 = load i64, ptr %t69.slot, align 8
  store i64 %r44, ptr %curr.slot, align 8
  br label %while_cond_100
dead_r45:
  br label %while_end_101
while_end_101:
  ; %t70:str = const_str 24
  ; %t71:str = str_concat(res, %t70)
  %r46 = load ptr, ptr %t71.slot, align 8
  ret ptr %r46
ret_cont_46:
  br label %if_end_91
dead_r47:
  br label %if_elif_99
if_elif_99:
  store i64 0, ptr %t72.slot, align 8
  ; %t73:i64 = node[%t72]
  store i64 6, ptr %t74.slot, align 8
  ; %t75:bool = cmp_eq_i64 %t73, %t74
  %r48 = load i64, ptr %t75.slot, align 8
  %r49 = icmp eq i64 %r48, 0
  br i1 %r49, label %if_end_91, label %fall_49
fall_49:
  ; %t76:str = const_str 25
  %r50 = load ptr, ptr %t76.slot, align 8
  store ptr %r50, ptr %res.slot, align 8
  store i64 5, ptr %t77.slot, align 8
  ; %t78:i64 = node[%t77]
  %r51 = load i64, ptr %t78.slot, align 8
  store i64 %r51, ptr %curr.slot, align 8
  store i64 1, ptr %t79.slot, align 8
  %r52 = load i64, ptr %t79.slot, align 8
  store i64 %r52, ptr %first.slot, align 8
  br label %while_cond_103
while_cond_103:
  store i64 1, ptr %t80.slot, align 8
  ; %t81:i64 = neg_i64 %t80
  ; %t82:bool = cmp_ne_i64 curr, %t81
  %r53 = load i64, ptr %t82.slot, align 8
  %r54 = icmp eq i64 %r53, 0
  br i1 %r54, label %while_end_104, label %fall_54
fall_54:
  store i64 0, ptr %t84.slot, align 8
  ; %t83:bool = cmp_eq_i64 first, %t84
  %r55 = load i64, ptr %t83.slot, align 8
  %r56 = icmp eq i64 %r55, 0
  br i1 %r56, label %if_end_105, label %fall_56
fall_56:
  ; %t85:str = const_str 23
  ; %t86:str = str_concat(res, %t85)
  %r57 = load ptr, ptr %t86.slot, align 8
  store ptr %r57, ptr %res.slot, align 8
  br label %if_end_105
dead_r58:
  br label %if_end_105
if_end_105:
  store i64 4, ptr %t87.slot, align 8
  ; %t88:Array[JsonNode] = doc[%t87]
  ; %t89:JsonNode = %t88[curr]
  store i64 1, ptr %t90.slot, align 8
  ; %t91:str = %t89[%t90]
  ; %t92:str = call json_escape_str(%t91)
  %r59 = load ptr, ptr %t92.slot, align 8
  store ptr %r59, ptr %k_esc.slot, align 8
  ; %t93:str = call json_dumps(doc, curr)
  %r60 = load ptr, ptr %t93.slot, align 8
  store ptr %r60, ptr %child_str.slot, align 8
  ; %t94:str = str_concat(res, k_esc)
  ; %t95:str = const_str 26
  ; %t96:str = str_concat(%t94, %t95)
  ; %t97:str = str_concat(%t96, child_str)
  %r61 = load ptr, ptr %t97.slot, align 8
  store ptr %r61, ptr %res.slot, align 8
  store i64 0, ptr %t98.slot, align 8
  %r62 = load i64, ptr %t98.slot, align 8
  store i64 %r62, ptr %first.slot, align 8
  store i64 4, ptr %t99.slot, align 8
  ; %t100:Array[JsonNode] = doc[%t99]
  ; %t101:JsonNode = %t100[curr]
  store i64 6, ptr %t102.slot, align 8
  ; %t103:i64 = %t101[%t102]
  %r63 = load i64, ptr %t103.slot, align 8
  store i64 %r63, ptr %curr.slot, align 8
  br label %while_cond_103
dead_r64:
  br label %while_end_104
while_end_104:
  ; %t104:str = const_str 27
  ; %t105:str = str_concat(res, %t104)
  %r65 = load ptr, ptr %t105.slot, align 8
  ret ptr %r65
ret_cont_65:
  br label %if_end_91
dead_r66:
  br label %if_end_91
if_end_91:
  ; %t106:str = const_str 11
  %r67 = load ptr, ptr %t106.slot, align 8
  ret ptr %r67
ret_cont_67:
  ret ptr 0
}

define dso_local ptr @json_dumps_int_array(ptr %arr.arg, i64 %count.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 22
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %res.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_106
for_cond_106:
  ; %t4:bool = cmp_lt_i64 i, count
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_108, label %fall_4
fall_4:
  store i64 0, ptr %t5.slot, align 8
  ; %t6:bool = cmp_gt_i64 i, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_109, label %fall_6
fall_6:
  ; %t7:str = const_str 23
  ; %t8:str = str_concat(res, %t7)
  %r7 = load ptr, ptr %t8.slot, align 8
  store ptr %r7, ptr %res.slot, align 8
  br label %if_end_109
dead_r8:
  br label %if_end_109
if_end_109:
  ; %t9:i64 = arr[i]
  ; %t10:str = str_from_i64 %t9
  ; %t11:str = str_concat(res, %t10)
  %r9 = load ptr, ptr %t11.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_107
for_step_107:
  ; %t12:i64 = add_i64 i, %t3
  %r10 = load i64, ptr %t12.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_106
dead_r11:
  br label %for_end_108
for_end_108:
  ; %t13:str = const_str 24
  ; %t14:str = str_concat(res, %t13)
  %r12 = load ptr, ptr %t14.slot, align 8
  ret ptr %r12
ret_cont_12:
  ret ptr 0
}

define dso_local ptr @json_dumps_float_array(ptr %arr.arg, i64 %count.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 22
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %res.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_110
for_cond_110:
  ; %t4:bool = cmp_lt_i64 i, count
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_112, label %fall_4
fall_4:
  store i64 0, ptr %t5.slot, align 8
  ; %t6:bool = cmp_gt_i64 i, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_113, label %fall_6
fall_6:
  ; %t7:str = const_str 23
  ; %t8:str = str_concat(res, %t7)
  %r7 = load ptr, ptr %t8.slot, align 8
  store ptr %r7, ptr %res.slot, align 8
  br label %if_end_113
dead_r8:
  br label %if_end_113
if_end_113:
  ; %t9:f64 = arr[i]
  ; %t10:str = str_from_f64 %t9
  ; %t11:str = str_concat(res, %t10)
  %r9 = load ptr, ptr %t11.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_111
for_step_111:
  ; %t12:i64 = add_i64 i, %t3
  %r10 = load i64, ptr %t12.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_110
dead_r11:
  br label %for_end_112
for_end_112:
  ; %t13:str = const_str 24
  ; %t14:str = str_concat(res, %t13)
  %r12 = load ptr, ptr %t14.slot, align 8
  ret ptr %r12
ret_cont_12:
  ret ptr 0
}

define dso_local ptr @json_dumps_str_array(ptr %arr.arg, i64 %count.arg) #0 {
entry:
  %arr.slot = alloca ptr, align 8
  %count.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  %res.slot = alloca ptr, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  store ptr %arr.arg, ptr %arr.slot, align 8
  store i64 %count.arg, ptr %count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 22
  %r1 = load ptr, ptr %t1.slot, align 8
  store ptr %r1, ptr %res.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  store i64 1, ptr %t3.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %i.slot, align 8
  br label %for_cond_114
for_cond_114:
  ; %t4:bool = cmp_lt_i64 i, count
  %r3 = load i64, ptr %t4.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %for_end_116, label %fall_4
fall_4:
  store i64 0, ptr %t5.slot, align 8
  ; %t6:bool = cmp_gt_i64 i, %t5
  %r5 = load i64, ptr %t6.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_117, label %fall_6
fall_6:
  ; %t7:str = const_str 23
  ; %t8:str = str_concat(res, %t7)
  %r7 = load ptr, ptr %t8.slot, align 8
  store ptr %r7, ptr %res.slot, align 8
  br label %if_end_117
dead_r8:
  br label %if_end_117
if_end_117:
  ; %t9:str = arr[i]
  ; %t10:str = call json_escape_str(%t9)
  ; %t11:str = str_concat(res, %t10)
  %r9 = load ptr, ptr %t11.slot, align 8
  store ptr %r9, ptr %res.slot, align 8
  br label %for_step_115
for_step_115:
  ; %t12:i64 = add_i64 i, %t3
  %r10 = load i64, ptr %t12.slot, align 8
  store i64 %r10, ptr %i.slot, align 8
  br label %for_cond_114
dead_r11:
  br label %for_end_116
for_end_116:
  ; %t13:str = const_str 24
  ; %t14:str = str_concat(res, %t13)
  %r12 = load ptr, ptr %t14.slot, align 8
  ret ptr %r12
ret_cont_12:
  ret ptr 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %json_text.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %doc.slot = alloca i64, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  %t18.slot = alloca ptr, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca i64, align 8
  %root.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca ptr, align 8
  %t24.slot = alloca ptr, align 8
  %name.slot = alloca ptr, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %ver.slot = alloca i64, align 8
  %t28.slot = alloca ptr, align 8
  %t29.slot = alloca double, align 8
  %t30.slot = alloca double, align 8
  %perf.slot = alloca double, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %is_open.slot = alloca i64, align 8
  %t34.slot = alloca ptr, align 8
  %t35.slot = alloca ptr, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca ptr, align 8
  %t39.slot = alloca ptr, align 8
  %t40.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %targets_idx.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %num_targets.slot = alloca i64, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca ptr, align 8
  %t45.slot = alloca i64, align 8
  %t46.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t47.slot = alloca i64, align 8
  %t48.slot = alloca i64, align 8
  %elem_idx.slot = alloca i64, align 8
  %t49.slot = alloca i64, align 8
  %t50.slot = alloca ptr, align 8
  %t51.slot = alloca i64, align 8
  %t52.slot = alloca i64, align 8
  %t53.slot = alloca ptr, align 8
  %target_name.slot = alloca ptr, align 8
  %t54.slot = alloca ptr, align 8
  %t55.slot = alloca ptr, align 8
  %t56.slot = alloca i64, align 8
  %t57.slot = alloca ptr, align 8
  %t58.slot = alloca i64, align 8
  %meta_idx.slot = alloca i64, align 8
  %t59.slot = alloca ptr, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %author.slot = alloca ptr, align 8
  %t62.slot = alloca ptr, align 8
  %t63.slot = alloca ptr, align 8
  %t64.slot = alloca ptr, align 8
  %license_str.slot = alloca ptr, align 8
  %t65.slot = alloca ptr, align 8
  %t66.slot = alloca ptr, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca ptr, align 8
  %t70.slot = alloca ptr, align 8
  %serialized.slot = alloca ptr, align 8
  %t71.slot = alloca ptr, align 8
  %t72.slot = alloca ptr, align 8
  %t73.slot = alloca ptr, align 8
  %t74.slot = alloca ptr, align 8
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
  %int_data.slot = alloca ptr, align 8
  %t87.slot = alloca ptr, align 8
  %t88.slot = alloca i64, align 8
  %t89.slot = alloca double, align 8
  %t90.slot = alloca double, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca double, align 8
  %t93.slot = alloca i64, align 8
  %t94.slot = alloca double, align 8
  %t95.slot = alloca i64, align 8
  %float_data.slot = alloca ptr, align 8
  %t96.slot = alloca ptr, align 8
  %t97.slot = alloca i64, align 8
  %t98.slot = alloca ptr, align 8
  %t99.slot = alloca ptr, align 8
  %t100.slot = alloca ptr, align 8
  %t101.slot = alloca i64, align 8
  %t102.slot = alloca ptr, align 8
  %t103.slot = alloca ptr, align 8
  %t104.slot = alloca ptr, align 8
  %t105.slot = alloca ptr, align 8
  %t106.slot = alloca ptr, align 8
  %t107.slot = alloca ptr, align 8
  %t108.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 28
  ; print(%t1:str)
  ; %t2:str = const_str 29
  ; print(%t2:str)
  ; %t3:str = const_str 28
  ; print(%t3:str)
  ; %t4:str = const_str 30
  %r1 = load ptr, ptr %t4.slot, align 8
  store ptr %r1, ptr %json_text.slot, align 8
  ; %t5:str = const_str 31
  ; print(%t5:str)
  ; print(json_text:str)
  ; %t6:str = const_str 0
  ; print(%t6:str)
  store i64 100, ptr %t7.slot, align 8
  ; %t8:JsonDoc = call json_parse(json_text, %t7)
  %r2 = load i64, ptr %t8.slot, align 8
  store i64 %r2, ptr %doc.slot, align 8
  ; %t9:str = const_str 32
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = doc[%t10]
  ; print(%t9:str, %t11:i64)
  store i64 3, ptr %t12.slot, align 8
  ; %t13:str = doc[%t12]
  ; %t14:str = const_str 0
  ; %t15:bool = str_cmp_ne %t13, %t14
  %r3 = load i64, ptr %t15.slot, align 8
  %r4 = icmp eq i64 %r3, 0
  br i1 %r4, label %if_end_118, label %fall_4
fall_4:
  ; %t16:str = const_str 33
  store i64 3, ptr %t17.slot, align 8
  ; %t18:str = doc[%t17]
  ; print(%t16:str, %t18:str)
  store i64 1, ptr %t19.slot, align 8
  ; arena_restore %arena_sp_main
  %r5 = load i64, ptr %t19.slot, align 8
  ret i64 %r5
ret_cont_5:
  br label %if_end_118
dead_r6:
  br label %if_end_118
if_end_118:
  store i64 0, ptr %t20.slot, align 8
  ; %t21:i64 = doc[%t20]
  %r7 = load i64, ptr %t21.slot, align 8
  store i64 %r7, ptr %root.slot, align 8
  ; %t22:str = const_str 34
  ; %t23:str = const_str 35
  ; %t24:str = call json_get_str(doc, root, %t22, %t23)
  %r8 = load ptr, ptr %t24.slot, align 8
  store ptr %r8, ptr %name.slot, align 8
  ; %t25:str = const_str 36
  store i64 0, ptr %t26.slot, align 8
  ; %t27:i64 = call json_get_int(doc, root, %t25, %t26)
  %r9 = load i64, ptr %t27.slot, align 8
  store i64 %r9, ptr %ver.slot, align 8
  ; %t28:str = const_str 37
  store double 0.000000e+00, ptr %t29.slot, align 8
  ; %t30:f64 = call json_get_float(doc, root, %t28, %t29)
  %r10 = load double, ptr %t30.slot, align 8
  store double %r10, ptr %perf.slot, align 8
  ; %t31:str = const_str 38
  store i64 0, ptr %t32.slot, align 8
  ; %t33:bool = call json_get_bool(doc, root, %t31, %t32)
  %r11 = load i64, ptr %t33.slot, align 8
  store i64 %r11, ptr %is_open.slot, align 8
  ; %t34:str = const_str 39
  ; print(%t34:str)
  ; %t35:str = const_str 40
  ; print(%t35:str, name:str)
  ; %t36:str = const_str 41
  ; print(%t36:str, ver:i64)
  ; %t37:str = const_str 42
  ; %t38:str = const_str 43
  ; print(%t37:str, perf:f64, %t38:str)
  ; %t39:str = const_str 44
  ; print(%t39:str, is_open:bool)
  ; %t40:str = const_str 45
  ; %t41:i64 = call json_get(doc, root, %t40)
  %r12 = load i64, ptr %t41.slot, align 8
  store i64 %r12, ptr %targets_idx.slot, align 8
  ; %t42:i64 = call json_array_len(doc, targets_idx)
  %r13 = load i64, ptr %t42.slot, align 8
  store i64 %r13, ptr %num_targets.slot, align 8
  ; %t43:str = const_str 46
  ; %t44:str = const_str 47
  ; print(%t43:str, num_targets:i64, %t44:str)
  store i64 0, ptr %t45.slot, align 8
  store i64 1, ptr %t46.slot, align 8
  %r14 = load i64, ptr %t45.slot, align 8
  store i64 %r14, ptr %i.slot, align 8
  br label %for_cond_119
for_cond_119:
  ; %t47:bool = cmp_lt_i64 i, num_targets
  %r15 = load i64, ptr %t47.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %for_end_121, label %fall_16
fall_16:
  ; %t48:i64 = call json_array_get(doc, targets_idx, i)
  %r17 = load i64, ptr %t48.slot, align 8
  store i64 %r17, ptr %elem_idx.slot, align 8
  store i64 4, ptr %t49.slot, align 8
  ; %t50:Array[JsonNode] = doc[%t49]
  ; %t51:JsonNode = %t50[elem_idx]
  store i64 2, ptr %t52.slot, align 8
  ; %t53:str = %t51[%t52]
  %r18 = load ptr, ptr %t53.slot, align 8
  store ptr %r18, ptr %target_name.slot, align 8
  ; %t54:str = const_str 48
  ; %t55:str = const_str 49
  ; print(%t54:str, i:i64, %t55:str, target_name:str)
  br label %for_step_120
for_step_120:
  ; %t56:i64 = add_i64 i, %t46
  %r19 = load i64, ptr %t56.slot, align 8
  store i64 %r19, ptr %i.slot, align 8
  br label %for_cond_119
dead_r20:
  br label %for_end_121
for_end_121:
  ; %t57:str = const_str 50
  ; %t58:i64 = call json_get(doc, root, %t57)
  %r21 = load i64, ptr %t58.slot, align 8
  store i64 %r21, ptr %meta_idx.slot, align 8
  ; %t59:str = const_str 51
  ; %t60:str = const_str 52
  ; %t61:str = call json_get_str(doc, meta_idx, %t59, %t60)
  %r22 = load ptr, ptr %t61.slot, align 8
  store ptr %r22, ptr %author.slot, align 8
  ; %t62:str = const_str 53
  ; %t63:str = const_str 52
  ; %t64:str = call json_get_str(doc, meta_idx, %t62, %t63)
  %r23 = load ptr, ptr %t64.slot, align 8
  store ptr %r23, ptr %license_str.slot, align 8
  ; %t65:str = const_str 54
  ; print(%t65:str)
  ; %t66:str = const_str 55
  ; print(%t66:str, author:str)
  ; %t67:str = const_str 56
  ; print(%t67:str, license_str:str)
  ; %t68:str = const_str 0
  ; print(%t68:str)
  ; %t69:str = const_str 57
  ; print(%t69:str)
  ; %t70:str = call json_dumps(doc, root)
  %r24 = load ptr, ptr %t70.slot, align 8
  store ptr %r24, ptr %serialized.slot, align 8
  ; %t71:str = const_str 58
  ; print(%t71:str)
  ; print(serialized:str)
  ; %t72:str = const_str 0
  ; print(%t72:str)
  ; %t73:str = const_str 59
  ; print(%t73:str)
  store i64 5, ptr %t75.slot, align 8
  store i64 0, ptr %t76.slot, align 8
  ; %t74:Array[i64] = alloc_array(%t75, init=%t76)
  store i64 10, ptr %t77.slot, align 8
  store i64 0, ptr %t78.slot, align 8
  ; %t74[%t78] = %t77  ; i64
  store i64 25, ptr %t79.slot, align 8
  store i64 1, ptr %t80.slot, align 8
  ; %t74[%t80] = %t79  ; i64
  store i64 50, ptr %t81.slot, align 8
  store i64 2, ptr %t82.slot, align 8
  ; %t74[%t82] = %t81  ; i64
  store i64 100, ptr %t83.slot, align 8
  store i64 3, ptr %t84.slot, align 8
  ; %t74[%t84] = %t83  ; i64
  store i64 250, ptr %t85.slot, align 8
  store i64 4, ptr %t86.slot, align 8
  ; %t74[%t86] = %t85  ; i64
  %r25 = load ptr, ptr %t74.slot, align 8
  store ptr %r25, ptr %int_data.slot, align 8
  store i64 3, ptr %t88.slot, align 8
  store double 0.000000e+00, ptr %t89.slot, align 8
  ; %t87:Array[f64] = alloc_array(%t88, init=%t89)
  store double 1.618000e+00, ptr %t90.slot, align 8
  store i64 0, ptr %t91.slot, align 8
  ; %t87[%t91] = %t90  ; f64
  store double 2.718000e+00, ptr %t92.slot, align 8
  store i64 1, ptr %t93.slot, align 8
  ; %t87[%t93] = %t92  ; f64
  store double 3.141590e+00, ptr %t94.slot, align 8
  store i64 2, ptr %t95.slot, align 8
  ; %t87[%t95] = %t94  ; f64
  %r26 = load ptr, ptr %t87.slot, align 8
  store ptr %r26, ptr %float_data.slot, align 8
  ; %t96:str = const_str 60
  store i64 5, ptr %t97.slot, align 8
  ; %t98:str = call json_dumps_int_array(int_data, %t97)
  ; %t99:str = str_concat(%t96, %t98)
  ; print(%t99:str)
  ; %t100:str = const_str 61
  store i64 3, ptr %t101.slot, align 8
  ; %t102:str = call json_dumps_float_array(float_data, %t101)
  ; %t103:str = str_concat(%t100, %t102)
  ; print(%t103:str)
  ; %t104:str = const_str 0
  ; print(%t104:str)
  ; %t105:str = const_str 28
  ; print(%t105:str)
  ; %t106:str = const_str 62
  ; print(%t106:str)
  ; %t107:str = const_str 28
  ; print(%t107:str)
  store i64 0, ptr %t108.slot, align 8
  ; arena_restore %arena_sp_main
  %r27 = load i64, ptr %t108.slot, align 8
  ret i64 %r27
ret_cont_27:
  ret i64 0
}

define dso_local i64 @__bmb_main__() #0 {
entry:
  %t1.slot = alloca i64, align 8
  %JSON_NULL.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %JSON_BOOL.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %JSON_INT.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %JSON_FLOAT.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %JSON_STR.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %JSON_ARR.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %JSON_OBJ.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %JSON_NULL.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %JSON_BOOL.slot, align 8
  store i64 2, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %JSON_INT.slot, align 8
  store i64 3, ptr %t4.slot, align 8
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %JSON_FLOAT.slot, align 8
  store i64 4, ptr %t5.slot, align 8
  %r5 = load i64, ptr %t5.slot, align 8
  store i64 %r5, ptr %JSON_STR.slot, align 8
  store i64 5, ptr %t6.slot, align 8
  %r6 = load i64, ptr %t6.slot, align 8
  store i64 %r6, ptr %JSON_ARR.slot, align 8
  store i64 6, ptr %t7.slot, align 8
  %r7 = load i64, ptr %t7.slot, align 8
  store i64 %r7, ptr %JSON_OBJ.slot, align 8
  ; %t8:i64 = call main()
  store i64 0, ptr %t9.slot, align 8
  %r8 = load i64, ptr %t9.slot, align 8
  ret i64 %r8
ret_cont_8:
  ret i64 0
}
