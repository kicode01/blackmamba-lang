; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local i64 @socket_init() #0 {
entry:
  %t1.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call __bmb_socket_init()
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @socket_cleanup() #0 {
entry:
  %t1.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call __bmb_socket_cleanup()
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @socket_create(i64 %family.arg, i64 %sock_type.arg, i64 %proto.arg) #0 {
entry:
  %family.slot = alloca i64, align 8
  %sock_type.slot = alloca i64, align 8
  %proto.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %fd.slot = alloca i64, align 8
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
  store i64 %family.arg, ptr %family.slot, align 8
  store i64 %sock_type.arg, ptr %sock_type.slot, align 8
  store i64 %proto.arg, ptr %proto.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call socket_init()
  ; %t2:i64 = call __bmb_socket_create(family, sock_type, proto)
  %r1 = load i64, ptr %t2.slot, align 8
  store i64 %r1, ptr %fd.slot, align 8
  store i64 6, ptr %t4.slot, align 8
  store i64 0, ptr %t5.slot, align 8
  ; %t3:Socket = alloc_array(%t4, init=%t5)
  store i64 0, ptr %t6.slot, align 8
  ; %t3[%t6] = fd  ; i64
  store i64 1, ptr %t7.slot, align 8
  ; %t3[%t7] = family  ; i64
  store i64 2, ptr %t8.slot, align 8
  ; %t3[%t8] = sock_type  ; i64
  store i64 0, ptr %t9.slot, align 8
  store i64 3, ptr %t10.slot, align 8
  ; %t3[%t10] = %t9  ; bool
  store i64 0, ptr %t11.slot, align 8
  store i64 4, ptr %t12.slot, align 8
  ; %t3[%t12] = %t11  ; bool
  store i64 0, ptr %t13.slot, align 8
  store i64 5, ptr %t14.slot, align 8
  ; %t3[%t14] = %t13  ; bool
  %r2 = load i64, ptr %t3.slot, align 8
  ret i64 %r2
ret_cont_2:
  ret i64 0
}

define dso_local i64 @tcp_socket() #0 {
entry:
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  store i64 6, ptr %t3.slot, align 8
  ; %t4:Socket = call socket_create(%t1, %t2, %t3)
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @udp_socket() #0 {
entry:
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  store i64 2, ptr %t2.slot, align 8
  store i64 17, ptr %t3.slot, align 8
  ; %t4:Socket = call socket_create(%t1, %t2, %t3)
  %r1 = load i64, ptr %t4.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local i64 @socket_connect(i64 %sock.arg, ptr %host.arg, i64 %port.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %host.slot = alloca ptr, align 8
  %port.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %sock.arg, ptr %sock.slot, align 8
  store ptr %host.arg, ptr %host.slot, align 8
  store i64 %port.arg, ptr %port.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  ; %t3:i64 = call __bmb_socket_connect(%t2, host, port)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_eq_i64 res, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_1, label %fall_3
fall_3:
  store i64 1, ptr %t6.slot, align 8
  store i64 3, ptr %t7.slot, align 8
  ; sock[%t7] = %t6  ; bool
  br label %if_end_1
dead_r4:
  br label %if_end_1
if_end_1:
  %r5 = load i64, ptr %res.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @socket_bind(i64 %sock.arg, ptr %host.arg, i64 %port.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %host.slot = alloca ptr, align 8
  %port.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %sock.arg, ptr %sock.slot, align 8
  store ptr %host.arg, ptr %host.slot, align 8
  store i64 %port.arg, ptr %port.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  ; %t3:i64 = call __bmb_socket_bind(%t2, host, port)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_eq_i64 res, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_2, label %fall_3
fall_3:
  store i64 1, ptr %t6.slot, align 8
  store i64 4, ptr %t7.slot, align 8
  ; sock[%t7] = %t6  ; bool
  br label %if_end_2
dead_r4:
  br label %if_end_2
if_end_2:
  %r5 = load i64, ptr %res.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @socket_listen(i64 %sock.arg, i64 %backlog.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %backlog.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  store i64 %sock.arg, ptr %sock.slot, align 8
  store i64 %backlog.arg, ptr %backlog.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  ; %t3:i64 = call __bmb_socket_listen(%t2, backlog)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %res.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_eq_i64 res, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_3, label %fall_3
fall_3:
  store i64 1, ptr %t6.slot, align 8
  store i64 5, ptr %t7.slot, align 8
  ; sock[%t7] = %t6  ; bool
  br label %if_end_3
dead_r4:
  br label %if_end_3
if_end_3:
  %r5 = load i64, ptr %res.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local i64 @socket_accept(i64 %sock.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %client_fd.slot = alloca i64, align 8
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
  store i64 %sock.arg, ptr %sock.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  ; %t3:i64 = call __bmb_socket_accept(%t2)
  %r1 = load i64, ptr %t3.slot, align 8
  store i64 %r1, ptr %client_fd.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_ge_i64 client_fd, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_4, label %fall_3
fall_3:
  store i64 6, ptr %t7.slot, align 8
  store i64 0, ptr %t8.slot, align 8
  ; %t6:Socket = alloc_array(%t7, init=%t8)
  store i64 0, ptr %t9.slot, align 8
  ; %t6[%t9] = client_fd  ; i64
  store i64 1, ptr %t10.slot, align 8
  ; %t11:i64 = sock[%t10]
  store i64 1, ptr %t12.slot, align 8
  ; %t6[%t12] = %t11  ; i64
  store i64 2, ptr %t13.slot, align 8
  ; %t14:i64 = sock[%t13]
  store i64 2, ptr %t15.slot, align 8
  ; %t6[%t15] = %t14  ; i64
  store i64 1, ptr %t16.slot, align 8
  store i64 3, ptr %t17.slot, align 8
  ; %t6[%t17] = %t16  ; bool
  store i64 0, ptr %t18.slot, align 8
  store i64 4, ptr %t19.slot, align 8
  ; %t6[%t19] = %t18  ; bool
  store i64 0, ptr %t20.slot, align 8
  store i64 5, ptr %t21.slot, align 8
  ; %t6[%t21] = %t20  ; bool
  %r4 = load i64, ptr %t6.slot, align 8
  ret i64 %r4
ret_cont_4:
  br label %if_end_4
dead_r5:
  br label %if_end_4
if_end_4:
  store i64 6, ptr %t23.slot, align 8
  store i64 0, ptr %t24.slot, align 8
  ; %t22:Socket = alloc_array(%t23, init=%t24)
  store i64 1, ptr %t25.slot, align 8
  ; %t26:i64 = neg_i64 %t25
  store i64 0, ptr %t27.slot, align 8
  ; %t22[%t27] = %t26  ; i64
  store i64 1, ptr %t28.slot, align 8
  ; %t29:i64 = sock[%t28]
  store i64 1, ptr %t30.slot, align 8
  ; %t22[%t30] = %t29  ; i64
  store i64 2, ptr %t31.slot, align 8
  ; %t32:i64 = sock[%t31]
  store i64 2, ptr %t33.slot, align 8
  ; %t22[%t33] = %t32  ; i64
  store i64 0, ptr %t34.slot, align 8
  store i64 3, ptr %t35.slot, align 8
  ; %t22[%t35] = %t34  ; bool
  store i64 0, ptr %t36.slot, align 8
  store i64 4, ptr %t37.slot, align 8
  ; %t22[%t37] = %t36  ; bool
  store i64 0, ptr %t38.slot, align 8
  store i64 5, ptr %t39.slot, align 8
  ; %t22[%t39] = %t38  ; bool
  %r6 = load i64, ptr %t22.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @socket_send(i64 %sock.arg, ptr %data.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %data.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  store i64 %sock.arg, ptr %sock.slot, align 8
  store ptr %data.arg, ptr %data.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_lt_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_5, label %fall_2
fall_2:
  store i64 1, ptr %t5.slot, align 8
  ; %t6:i64 = neg_i64 %t5
  %r3 = load i64, ptr %t6.slot, align 8
  ret i64 %r3
ret_cont_3:
  br label %if_end_5
dead_r4:
  br label %if_end_5
if_end_5:
  store i64 0, ptr %t7.slot, align 8
  ; %t8:i64 = sock[%t7]
  ; %t9:i64 = call __bmb_socket_send(%t8, data)
  %r5 = load i64, ptr %t9.slot, align 8
  ret i64 %r5
ret_cont_5:
  ret i64 0
}

define dso_local ptr @socket_recv(i64 %sock.arg, i64 %max_bytes.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %max_bytes.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca ptr, align 8
  store i64 %sock.arg, ptr %sock.slot, align 8
  store i64 %max_bytes.arg, ptr %max_bytes.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_lt_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_6, label %fall_2
fall_2:
  ; %t5:str = const_str 0
  %r3 = load ptr, ptr %t5.slot, align 8
  ret ptr %r3
ret_cont_3:
  br label %if_end_6
dead_r4:
  br label %if_end_6
if_end_6:
  store i64 0, ptr %t6.slot, align 8
  ; %t7:i64 = sock[%t6]
  ; %t8:str = call __bmb_socket_recv(%t7, max_bytes)
  %r5 = load ptr, ptr %t8.slot, align 8
  ret ptr %r5
ret_cont_5:
  ret ptr 0
}

define dso_local i64 @socket_close(i64 %sock.arg) #0 {
entry:
  %sock.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
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
  store i64 %sock.arg, ptr %sock.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 0, ptr %t1.slot, align 8
  ; %t2:i64 = sock[%t1]
  store i64 0, ptr %t3.slot, align 8
  ; %t4:bool = cmp_ge_i64 %t2, %t3
  %r1 = load i64, ptr %t4.slot, align 8
  %r2 = icmp eq i64 %r1, 0
  br i1 %r2, label %if_end_7, label %fall_2
fall_2:
  store i64 0, ptr %t5.slot, align 8
  ; %t6:i64 = sock[%t5]
  ; %t7:i64 = call __bmb_socket_close(%t6)
  %r3 = load i64, ptr %t7.slot, align 8
  store i64 %r3, ptr %res.slot, align 8
  store i64 1, ptr %t8.slot, align 8
  ; %t9:i64 = neg_i64 %t8
  store i64 0, ptr %t10.slot, align 8
  ; sock[%t10] = %t9  ; i64
  store i64 0, ptr %t11.slot, align 8
  store i64 3, ptr %t12.slot, align 8
  ; sock[%t12] = %t11  ; bool
  store i64 0, ptr %t13.slot, align 8
  store i64 4, ptr %t14.slot, align 8
  ; sock[%t14] = %t13  ; bool
  store i64 0, ptr %t15.slot, align 8
  store i64 5, ptr %t16.slot, align 8
  ; sock[%t16] = %t15  ; bool
  %r4 = load i64, ptr %res.slot, align 8
  ret i64 %r4
ret_cont_4:
  br label %if_end_7
dead_r5:
  br label %if_end_7
if_end_7:
  store i64 0, ptr %t17.slot, align 8
  %r6 = load i64, ptr %t17.slot, align 8
  ret i64 %r6
ret_cont_6:
  ret i64 0
}

define dso_local i64 @tcp_connect(ptr %host.arg, i64 %port.arg) #0 {
entry:
  %host.slot = alloca ptr, align 8
  %port.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %res.slot = alloca i64, align 8
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
  store ptr %host.arg, ptr %host.slot, align 8
  store i64 %port.arg, ptr %port.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:Socket = call tcp_socket()
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  ; %t3:i64 = s[%t2]
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_ge_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_8, label %fall_3
fall_3:
  ; %t6:i64 = call socket_connect(s, host, port)
  %r4 = load i64, ptr %t6.slot, align 8
  store i64 %r4, ptr %res.slot, align 8
  store i64 0, ptr %t7.slot, align 8
  ; %t8:bool = cmp_ne_i64 res, %t7
  %r5 = load i64, ptr %t8.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_9, label %fall_6
fall_6:
  ; %t9:i64 = call socket_close(s)
  store i64 6, ptr %t11.slot, align 8
  store i64 0, ptr %t12.slot, align 8
  ; %t10:Socket = alloc_array(%t11, init=%t12)
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = neg_i64 %t13
  store i64 0, ptr %t15.slot, align 8
  ; %t10[%t15] = %t14  ; i64
  store i64 2, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t10[%t17] = %t16  ; i64
  store i64 1, ptr %t18.slot, align 8
  store i64 2, ptr %t19.slot, align 8
  ; %t10[%t19] = %t18  ; i64
  store i64 0, ptr %t20.slot, align 8
  store i64 3, ptr %t21.slot, align 8
  ; %t10[%t21] = %t20  ; bool
  store i64 0, ptr %t22.slot, align 8
  store i64 4, ptr %t23.slot, align 8
  ; %t10[%t23] = %t22  ; bool
  store i64 0, ptr %t24.slot, align 8
  store i64 5, ptr %t25.slot, align 8
  ; %t10[%t25] = %t24  ; bool
  %r7 = load i64, ptr %t10.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_9
dead_r8:
  br label %if_end_9
if_end_9:
  br label %if_end_8
dead_r9:
  br label %if_end_8
if_end_8:
  %r10 = load i64, ptr %s.slot, align 8
  ret i64 %r10
ret_cont_10:
  ret i64 0
}

define dso_local i64 @tcp_server(ptr %host.arg, i64 %port.arg, i64 %backlog.arg) #0 {
entry:
  %host.slot = alloca ptr, align 8
  %port.slot = alloca i64, align 8
  %backlog.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %b_res.slot = alloca i64, align 8
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
  %l_res.slot = alloca i64, align 8
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
  store ptr %host.arg, ptr %host.slot, align 8
  store i64 %port.arg, ptr %port.slot, align 8
  store i64 %backlog.arg, ptr %backlog.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:Socket = call tcp_socket()
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  ; %t3:i64 = s[%t2]
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_ge_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_10, label %fall_3
fall_3:
  ; %t6:i64 = call socket_bind(s, host, port)
  %r4 = load i64, ptr %t6.slot, align 8
  store i64 %r4, ptr %b_res.slot, align 8
  store i64 0, ptr %t7.slot, align 8
  ; %t8:bool = cmp_ne_i64 b_res, %t7
  %r5 = load i64, ptr %t8.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_11, label %fall_6
fall_6:
  ; %t9:i64 = call socket_close(s)
  store i64 6, ptr %t11.slot, align 8
  store i64 0, ptr %t12.slot, align 8
  ; %t10:Socket = alloc_array(%t11, init=%t12)
  store i64 1, ptr %t13.slot, align 8
  ; %t14:i64 = neg_i64 %t13
  store i64 0, ptr %t15.slot, align 8
  ; %t10[%t15] = %t14  ; i64
  store i64 2, ptr %t16.slot, align 8
  store i64 1, ptr %t17.slot, align 8
  ; %t10[%t17] = %t16  ; i64
  store i64 1, ptr %t18.slot, align 8
  store i64 2, ptr %t19.slot, align 8
  ; %t10[%t19] = %t18  ; i64
  store i64 0, ptr %t20.slot, align 8
  store i64 3, ptr %t21.slot, align 8
  ; %t10[%t21] = %t20  ; bool
  store i64 0, ptr %t22.slot, align 8
  store i64 4, ptr %t23.slot, align 8
  ; %t10[%t23] = %t22  ; bool
  store i64 0, ptr %t24.slot, align 8
  store i64 5, ptr %t25.slot, align 8
  ; %t10[%t25] = %t24  ; bool
  %r7 = load i64, ptr %t10.slot, align 8
  ret i64 %r7
ret_cont_7:
  br label %if_end_11
dead_r8:
  br label %if_end_11
if_end_11:
  ; %t26:i64 = call socket_listen(s, backlog)
  %r9 = load i64, ptr %t26.slot, align 8
  store i64 %r9, ptr %l_res.slot, align 8
  store i64 0, ptr %t27.slot, align 8
  ; %t28:bool = cmp_ne_i64 l_res, %t27
  %r10 = load i64, ptr %t28.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_12, label %fall_11
fall_11:
  ; %t29:i64 = call socket_close(s)
  store i64 6, ptr %t31.slot, align 8
  store i64 0, ptr %t32.slot, align 8
  ; %t30:Socket = alloc_array(%t31, init=%t32)
  store i64 1, ptr %t33.slot, align 8
  ; %t34:i64 = neg_i64 %t33
  store i64 0, ptr %t35.slot, align 8
  ; %t30[%t35] = %t34  ; i64
  store i64 2, ptr %t36.slot, align 8
  store i64 1, ptr %t37.slot, align 8
  ; %t30[%t37] = %t36  ; i64
  store i64 1, ptr %t38.slot, align 8
  store i64 2, ptr %t39.slot, align 8
  ; %t30[%t39] = %t38  ; i64
  store i64 0, ptr %t40.slot, align 8
  store i64 3, ptr %t41.slot, align 8
  ; %t30[%t41] = %t40  ; bool
  store i64 0, ptr %t42.slot, align 8
  store i64 4, ptr %t43.slot, align 8
  ; %t30[%t43] = %t42  ; bool
  store i64 0, ptr %t44.slot, align 8
  store i64 5, ptr %t45.slot, align 8
  ; %t30[%t45] = %t44  ; bool
  %r12 = load i64, ptr %t30.slot, align 8
  ret i64 %r12
ret_cont_12:
  br label %if_end_12
dead_r13:
  br label %if_end_12
if_end_12:
  br label %if_end_10
dead_r14:
  br label %if_end_10
if_end_10:
  %r15 = load i64, ptr %s.slot, align 8
  ret i64 %r15
ret_cont_15:
  ret i64 0
}

define dso_local i64 @raw_socket_send(i64 %fd.arg, ptr %data.arg) #0 {
entry:
  %fd.slot = alloca i64, align 8
  %data.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  store i64 %fd.arg, ptr %fd.slot, align 8
  store ptr %data.arg, ptr %data.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call __bmb_socket_send(fd, data)
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local ptr @raw_socket_recv(i64 %fd.arg, i64 %max_bytes.arg) #0 {
entry:
  %fd.slot = alloca i64, align 8
  %max_bytes.slot = alloca i64, align 8
  %t1.slot = alloca ptr, align 8
  store i64 %fd.arg, ptr %fd.slot, align 8
  store i64 %max_bytes.arg, ptr %max_bytes.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = call __bmb_socket_recv(fd, max_bytes)
  %r1 = load ptr, ptr %t1.slot, align 8
  ret ptr %r1
ret_cont_1:
  ret ptr 0
}

define dso_local i64 @raw_socket_close(i64 %fd.arg) #0 {
entry:
  %fd.slot = alloca i64, align 8
  %t1.slot = alloca i64, align 8
  store i64 %fd.arg, ptr %fd.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:i64 = call __bmb_socket_close(fd)
  %r1 = load i64, ptr %t1.slot, align 8
  ret i64 %r1
ret_cont_1:
  ret i64 0
}

define dso_local ptr @http_get(ptr %host.arg, i64 %port.arg, ptr %path.arg) #0 {
entry:
  %host.slot = alloca ptr, align 8
  %port.slot = alloca i64, align 8
  %path.slot = alloca ptr, align 8
  %t1.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca ptr, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %req.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %resp.slot = alloca ptr, align 8
  %t17.slot = alloca i64, align 8
  store ptr %host.arg, ptr %host.slot, align 8
  store i64 %port.arg, ptr %port.slot, align 8
  store ptr %path.arg, ptr %path.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:Socket = call tcp_connect(host, port)
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %s.slot, align 8
  store i64 0, ptr %t2.slot, align 8
  ; %t3:i64 = s[%t2]
  store i64 0, ptr %t4.slot, align 8
  ; %t5:bool = cmp_lt_i64 %t3, %t4
  %r2 = load i64, ptr %t5.slot, align 8
  %r3 = icmp eq i64 %r2, 0
  br i1 %r3, label %if_end_13, label %fall_3
fall_3:
  ; %t6:str = const_str 0
  %r4 = load ptr, ptr %t6.slot, align 8
  ret ptr %r4
ret_cont_4:
  br label %if_end_13
dead_r5:
  br label %if_end_13
if_end_13:
  ; %t7:str = const_str 1
  ; %t8:str = str_concat(%t7, path)
  ; %t9:str = const_str 2
  ; %t10:str = str_concat(%t8, %t9)
  ; %t11:str = str_concat(%t10, host)
  ; %t12:str = const_str 3
  ; %t13:str = str_concat(%t11, %t12)
  %r6 = load ptr, ptr %t13.slot, align 8
  store ptr %r6, ptr %req.slot, align 8
  ; %t14:i64 = call socket_send(s, req)
  store i64 65536, ptr %t15.slot, align 8
  ; %t16:str = call socket_recv(s, %t15)
  %r7 = load ptr, ptr %t16.slot, align 8
  store ptr %r7, ptr %resp.slot, align 8
  ; %t17:i64 = call socket_close(s)
  %r8 = load ptr, ptr %resp.slot, align 8
  ret ptr %r8
ret_cont_8:
  ret ptr 0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca ptr, align 8
  %t6.slot = alloca i64, align 8
  %init_res.slot = alloca i64, align 8
  %t7.slot = alloca ptr, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca ptr, align 8
  %t11.slot = alloca i64, align 8
  %s.slot = alloca i64, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca i64, align 8
  %t15.slot = alloca i64, align 8
  %t16.slot = alloca ptr, align 8
  %t17.slot = alloca ptr, align 8
  %t18.slot = alloca i64, align 8
  %t19.slot = alloca ptr, align 8
  %t20.slot = alloca ptr, align 8
  %t21.slot = alloca i64, align 8
  %test_port.slot = alloca i64, align 8
  %t22.slot = alloca ptr, align 8
  %t23.slot = alloca i64, align 8
  %t24.slot = alloca i64, align 8
  %srv.slot = alloca i64, align 8
  %t25.slot = alloca ptr, align 8
  %t26.slot = alloca ptr, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca i64, align 8
  %t29.slot = alloca ptr, align 8
  %t30.slot = alloca i64, align 8
  %cli.slot = alloca i64, align 8
  %t31.slot = alloca ptr, align 8
  %t32.slot = alloca ptr, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca i64, align 8
  %t35.slot = alloca i64, align 8
  %conn.slot = alloca i64, align 8
  %t36.slot = alloca ptr, align 8
  %t37.slot = alloca ptr, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca ptr, align 8
  %payload.slot = alloca ptr, align 8
  %t41.slot = alloca i64, align 8
  %bytes_sent.slot = alloca i64, align 8
  %t42.slot = alloca ptr, align 8
  %t43.slot = alloca ptr, align 8
  %t44.slot = alloca i64, align 8
  %t45.slot = alloca ptr, align 8
  %received.slot = alloca ptr, align 8
  %t46.slot = alloca ptr, align 8
  %t47.slot = alloca ptr, align 8
  %t48.slot = alloca ptr, align 8
  %t49.slot = alloca ptr, align 8
  %echo_msg.slot = alloca ptr, align 8
  %t50.slot = alloca i64, align 8
  %echo_sent.slot = alloca i64, align 8
  %t51.slot = alloca ptr, align 8
  %t52.slot = alloca ptr, align 8
  %t53.slot = alloca i64, align 8
  %t54.slot = alloca ptr, align 8
  %client_echo.slot = alloca ptr, align 8
  %t55.slot = alloca ptr, align 8
  %t56.slot = alloca ptr, align 8
  %t57.slot = alloca i64, align 8
  %t58.slot = alloca i64, align 8
  %t59.slot = alloca i64, align 8
  %t60.slot = alloca ptr, align 8
  %t61.slot = alloca ptr, align 8
  %t62.slot = alloca ptr, align 8
  %t63.slot = alloca i64, align 8
  %http_port.slot = alloca i64, align 8
  %t64.slot = alloca ptr, align 8
  %t65.slot = alloca i64, align 8
  %t66.slot = alloca i64, align 8
  %http_srv.slot = alloca i64, align 8
  %t67.slot = alloca ptr, align 8
  %t68.slot = alloca ptr, align 8
  %t69.slot = alloca i64, align 8
  %http_cli.slot = alloca i64, align 8
  %t70.slot = alloca i64, align 8
  %http_conn.slot = alloca i64, align 8
  %t71.slot = alloca ptr, align 8
  %http_req.slot = alloca ptr, align 8
  %t72.slot = alloca i64, align 8
  %t73.slot = alloca i64, align 8
  %t74.slot = alloca ptr, align 8
  %req_data.slot = alloca ptr, align 8
  %t75.slot = alloca ptr, align 8
  %t76.slot = alloca ptr, align 8
  %t77.slot = alloca ptr, align 8
  %json_body.slot = alloca ptr, align 8
  %t78.slot = alloca i64, align 8
  %body_len.slot = alloca i64, align 8
  %t79.slot = alloca ptr, align 8
  %t80.slot = alloca ptr, align 8
  %t81.slot = alloca ptr, align 8
  %t82.slot = alloca ptr, align 8
  %t83.slot = alloca ptr, align 8
  %t84.slot = alloca ptr, align 8
  %http_resp.slot = alloca ptr, align 8
  %t85.slot = alloca i64, align 8
  %t86.slot = alloca i64, align 8
  %t87.slot = alloca ptr, align 8
  %full_resp.slot = alloca ptr, align 8
  %t88.slot = alloca ptr, align 8
  %t89.slot = alloca ptr, align 8
  %t90.slot = alloca i64, align 8
  %t91.slot = alloca i64, align 8
  %t92.slot = alloca i64, align 8
  %t93.slot = alloca ptr, align 8
  %t94.slot = alloca ptr, align 8
  %t95.slot = alloca i64, align 8
  %cleanup_res.slot = alloca i64, align 8
  %t96.slot = alloca ptr, align 8
  %t97.slot = alloca ptr, align 8
  %t98.slot = alloca ptr, align 8
  %t99.slot = alloca ptr, align 8
  %t100.slot = alloca ptr, align 8
  %t101.slot = alloca ptr, align 8
  %t102.slot = alloca i64, align 8
  %arena_sp_main.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %arena_sp_main:i64 = arena_save None
  ; %t1:str = const_str 4
  ; print(%t1:str)
  ; %t2:str = const_str 5
  ; print(%t2:str)
  ; %t3:str = const_str 4
  ; print(%t3:str)
  ; %t4:str = const_str 0
  ; print(%t4:str)
  ; %t5:str = const_str 6
  ; print(%t5:str)
  ; %t6:i64 = call socket_init()
  %r1 = load i64, ptr %t6.slot, align 8
  store i64 %r1, ptr %init_res.slot, align 8
  ; %t7:str = const_str 7
  ; print(%t7:str)
  ; %t8:str = const_str 8
  ; print(%t8:str)
  ; print(init_res:i64)
  ; %t9:str = const_str 0
  ; print(%t9:str)
  ; %t10:str = const_str 9
  ; print(%t10:str)
  ; %t11:Socket = call tcp_socket()
  %r2 = load i64, ptr %t11.slot, align 8
  store i64 %r2, ptr %s.slot, align 8
  ; %t12:str = const_str 10
  ; print(%t12:str)
  ; %t13:str = const_str 8
  ; print(%t13:str)
  store i64 0, ptr %t14.slot, align 8
  ; %t15:i64 = s[%t14]
  ; print(%t15:i64)
  ; %t16:str = const_str 11
  ; print(%t16:str)
  ; %t17:str = const_str 8
  ; print(%t17:str)
  ; %t18:i64 = call socket_close(s)
  ; print(%t18:i64)
  ; %t19:str = const_str 0
  ; print(%t19:str)
  ; %t20:str = const_str 12
  ; print(%t20:str)
  store i64 17777, ptr %t21.slot, align 8
  %r3 = load i64, ptr %t21.slot, align 8
  store i64 %r3, ptr %test_port.slot, align 8
  ; %t22:str = const_str 13
  store i64 5, ptr %t23.slot, align 8
  ; %t24:Socket = call tcp_server(%t22, test_port, %t23)
  %r4 = load i64, ptr %t24.slot, align 8
  store i64 %r4, ptr %srv.slot, align 8
  ; %t25:str = const_str 14
  ; print(%t25:str)
  ; %t26:str = const_str 15
  ; print(%t26:str)
  store i64 0, ptr %t27.slot, align 8
  ; %t28:i64 = srv[%t27]
  ; print(%t28:i64)
  ; %t29:str = const_str 13
  ; %t30:Socket = call tcp_connect(%t29, test_port)
  %r5 = load i64, ptr %t30.slot, align 8
  store i64 %r5, ptr %cli.slot, align 8
  ; %t31:str = const_str 16
  ; print(%t31:str)
  ; %t32:str = const_str 15
  ; print(%t32:str)
  store i64 0, ptr %t33.slot, align 8
  ; %t34:i64 = cli[%t33]
  ; print(%t34:i64)
  ; %t35:Socket = call socket_accept(srv)
  %r6 = load i64, ptr %t35.slot, align 8
  store i64 %r6, ptr %conn.slot, align 8
  ; %t36:str = const_str 17
  ; print(%t36:str)
  ; %t37:str = const_str 18
  ; print(%t37:str)
  store i64 0, ptr %t38.slot, align 8
  ; %t39:i64 = conn[%t38]
  ; print(%t39:i64)
  ; %t40:str = const_str 19
  %r7 = load ptr, ptr %t40.slot, align 8
  store ptr %r7, ptr %payload.slot, align 8
  ; %t41:i64 = call socket_send(cli, payload)
  %r8 = load i64, ptr %t41.slot, align 8
  store i64 %r8, ptr %bytes_sent.slot, align 8
  ; %t42:str = const_str 20
  ; print(%t42:str)
  ; %t43:str = const_str 8
  ; print(%t43:str)
  ; print(bytes_sent:i64)
  store i64 1024, ptr %t44.slot, align 8
  ; %t45:str = call socket_recv(conn, %t44)
  %r9 = load ptr, ptr %t45.slot, align 8
  store ptr %r9, ptr %received.slot, align 8
  ; %t46:str = const_str 21
  ; print(%t46:str)
  ; %t47:str = const_str 8
  ; print(%t47:str)
  ; print(received:str)
  ; %t48:str = const_str 22
  ; %t49:str = str_concat(%t48, received)
  %r10 = load ptr, ptr %t49.slot, align 8
  store ptr %r10, ptr %echo_msg.slot, align 8
  ; %t50:i64 = call socket_send(conn, echo_msg)
  %r11 = load i64, ptr %t50.slot, align 8
  store i64 %r11, ptr %echo_sent.slot, align 8
  ; %t51:str = const_str 23
  ; print(%t51:str)
  ; %t52:str = const_str 8
  ; print(%t52:str)
  ; print(echo_sent:i64)
  store i64 1024, ptr %t53.slot, align 8
  ; %t54:str = call socket_recv(cli, %t53)
  %r12 = load ptr, ptr %t54.slot, align 8
  store ptr %r12, ptr %client_echo.slot, align 8
  ; %t55:str = const_str 24
  ; print(%t55:str)
  ; %t56:str = const_str 8
  ; print(%t56:str)
  ; print(client_echo:str)
  ; %t57:i64 = call socket_close(conn)
  ; %t58:i64 = call socket_close(cli)
  ; %t59:i64 = call socket_close(srv)
  ; %t60:str = const_str 25
  ; print(%t60:str)
  ; %t61:str = const_str 0
  ; print(%t61:str)
  ; %t62:str = const_str 26
  ; print(%t62:str)
  store i64 18888, ptr %t63.slot, align 8
  %r13 = load i64, ptr %t63.slot, align 8
  store i64 %r13, ptr %http_port.slot, align 8
  ; %t64:str = const_str 13
  store i64 5, ptr %t65.slot, align 8
  ; %t66:Socket = call tcp_server(%t64, http_port, %t65)
  %r14 = load i64, ptr %t66.slot, align 8
  store i64 %r14, ptr %http_srv.slot, align 8
  ; %t67:str = const_str 27
  ; print(%t67:str)
  ; %t68:str = const_str 13
  ; %t69:Socket = call tcp_connect(%t68, http_port)
  %r15 = load i64, ptr %t69.slot, align 8
  store i64 %r15, ptr %http_cli.slot, align 8
  ; %t70:Socket = call socket_accept(http_srv)
  %r16 = load i64, ptr %t70.slot, align 8
  store i64 %r16, ptr %http_conn.slot, align 8
  ; %t71:str = const_str 28
  %r17 = load ptr, ptr %t71.slot, align 8
  store ptr %r17, ptr %http_req.slot, align 8
  ; %t72:i64 = call socket_send(http_cli, http_req)
  store i64 2048, ptr %t73.slot, align 8
  ; %t74:str = call socket_recv(http_conn, %t73)
  %r18 = load ptr, ptr %t74.slot, align 8
  store ptr %r18, ptr %req_data.slot, align 8
  ; %t75:str = const_str 29
  ; print(%t75:str)
  ; %t76:str = const_str 8
  ; print(%t76:str)
  ; print(req_data:str)
  ; %t77:str = const_str 30
  %r19 = load ptr, ptr %t77.slot, align 8
  store ptr %r19, ptr %json_body.slot, align 8
  ; %t78:i64 = str_len(json_body)
  %r20 = load i64, ptr %t78.slot, align 8
  store i64 %r20, ptr %body_len.slot, align 8
  ; %t79:str = const_str 31
  ; %t80:str = str_from_i64 body_len
  ; %t81:str = str_concat(%t79, %t80)
  ; %t82:str = const_str 3
  ; %t83:str = str_concat(%t81, %t82)
  ; %t84:str = str_concat(%t83, json_body)
  %r21 = load ptr, ptr %t84.slot, align 8
  store ptr %r21, ptr %http_resp.slot, align 8
  ; %t85:i64 = call socket_send(http_conn, http_resp)
  store i64 4096, ptr %t86.slot, align 8
  ; %t87:str = call socket_recv(http_cli, %t86)
  %r22 = load ptr, ptr %t87.slot, align 8
  store ptr %r22, ptr %full_resp.slot, align 8
  ; %t88:str = const_str 32
  ; print(%t88:str)
  ; %t89:str = const_str 8
  ; print(%t89:str)
  ; print(full_resp:str)
  ; %t90:i64 = call socket_close(http_conn)
  ; %t91:i64 = call socket_close(http_cli)
  ; %t92:i64 = call socket_close(http_srv)
  ; %t93:str = const_str 0
  ; print(%t93:str)
  ; %t94:str = const_str 33
  ; print(%t94:str)
  ; %t95:i64 = call socket_cleanup()
  %r23 = load i64, ptr %t95.slot, align 8
  store i64 %r23, ptr %cleanup_res.slot, align 8
  ; %t96:str = const_str 34
  ; print(%t96:str)
  ; %t97:str = const_str 8
  ; print(%t97:str)
  ; print(cleanup_res:i64)
  ; %t98:str = const_str 0
  ; print(%t98:str)
  ; %t99:str = const_str 4
  ; print(%t99:str)
  ; %t100:str = const_str 35
  ; print(%t100:str)
  ; %t101:str = const_str 4
  ; print(%t101:str)
  store i64 0, ptr %t102.slot, align 8
  ; arena_restore %arena_sp_main
  %r24 = load i64, ptr %t102.slot, align 8
  ret i64 %r24
ret_cont_24:
  ret i64 0
}

define dso_local i64 @__bmb_main__() #0 {
entry:
  %t1.slot = alloca i64, align 8
  %AF_INET.slot = alloca i64, align 8
  %t2.slot = alloca i64, align 8
  %SOCK_STREAM.slot = alloca i64, align 8
  %t3.slot = alloca i64, align 8
  %SOCK_DGRAM.slot = alloca i64, align 8
  %t4.slot = alloca i64, align 8
  %IPPROTO_IP.slot = alloca i64, align 8
  %t5.slot = alloca i64, align 8
  %IPPROTO_TCP.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %IPPROTO_UDP.slot = alloca i64, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca i64, align 8
  %INVALID_SOCKET.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %SOCKET_ERROR.slot = alloca i64, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  %r1 = load i64, ptr %t1.slot, align 8
  store i64 %r1, ptr %AF_INET.slot, align 8
  store i64 1, ptr %t2.slot, align 8
  %r2 = load i64, ptr %t2.slot, align 8
  store i64 %r2, ptr %SOCK_STREAM.slot, align 8
  store i64 2, ptr %t3.slot, align 8
  %r3 = load i64, ptr %t3.slot, align 8
  store i64 %r3, ptr %SOCK_DGRAM.slot, align 8
  store i64 0, ptr %t4.slot, align 8
  %r4 = load i64, ptr %t4.slot, align 8
  store i64 %r4, ptr %IPPROTO_IP.slot, align 8
  store i64 6, ptr %t5.slot, align 8
  %r5 = load i64, ptr %t5.slot, align 8
  store i64 %r5, ptr %IPPROTO_TCP.slot, align 8
  store i64 17, ptr %t6.slot, align 8
  %r6 = load i64, ptr %t6.slot, align 8
  store i64 %r6, ptr %IPPROTO_UDP.slot, align 8
  store i64 1, ptr %t7.slot, align 8
  ; %t8:i64 = neg_i64 %t7
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %INVALID_SOCKET.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  ; %t10:i64 = neg_i64 %t9
  %r8 = load i64, ptr %t10.slot, align 8
  store i64 %r8, ptr %SOCKET_ERROR.slot, align 8
  ; %t11:i64 = call main()
  store i64 0, ptr %t12.slot, align 8
  %r9 = load i64, ptr %t12.slot, align 8
  ret i64 %r9
ret_cont_9:
  ret i64 0
}
