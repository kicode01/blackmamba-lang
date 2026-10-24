(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $socket_init (export "socket_init")  (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call __bmb_socket_init()
    ;; ret %t1
    (i64.const 0)
  )
  (func $socket_cleanup (export "socket_cleanup")  (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call __bmb_socket_cleanup()
    ;; ret %t1
    (i64.const 0)
  )
  (func $socket_create (export "socket_create") (param $family i64) (param $sock_type i64) (param $proto i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $fd i64)
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
    ;; %t1:i64 = call socket_init()
    ;; %t2:i64 = call __bmb_socket_create(family, sock_type, proto)
    ;; fd:i64 = mov %t2
    ;; %t4:i64 = const_i64 6
    ;; %t5:i64 = const_i64 0
    ;; %t3:Socket = alloc_array(%t4, init=%t5)
    ;; %t6:i64 = const_i64 0
    ;; %t3[%t6] = fd  ; i64
    ;; %t7:i64 = const_i64 1
    ;; %t3[%t7] = family  ; i64
    ;; %t8:i64 = const_i64 2
    ;; %t3[%t8] = sock_type  ; i64
    ;; %t9:bool = const_i64 0
    ;; %t10:i64 = const_i64 3
    ;; %t3[%t10] = %t9  ; bool
    ;; %t11:bool = const_i64 0
    ;; %t12:i64 = const_i64 4
    ;; %t3[%t12] = %t11  ; bool
    ;; %t13:bool = const_i64 0
    ;; %t14:i64 = const_i64 5
    ;; %t3[%t14] = %t13  ; bool
    ;; ret %t3
    (i64.const 0)
  )
  (func $tcp_socket (export "tcp_socket")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = const_i64 1
    ;; %t3:i64 = const_i64 6
    ;; %t4:Socket = call socket_create(%t1, %t2, %t3)
    ;; ret %t4
    (i64.const 0)
  )
  (func $udp_socket (export "udp_socket")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:i64 = const_i64 2
    ;; %t3:i64 = const_i64 17
    ;; %t4:Socket = call socket_create(%t1, %t2, %t3)
    ;; ret %t4
    (i64.const 0)
  )
  (func $socket_connect (export "socket_connect") (param $sock i64) (param $host i64) (param $port i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $res i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = call __bmb_socket_connect(%t2, host, port)
    ;; res:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_eq_i64 res, %t4
    ;; jz %t5, .if_end_1
    ;; %t6:bool = const_i64 1
    ;; %t7:i64 = const_i64 3
    ;; sock[%t7] = %t6  ; bool
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; ret res
    (i64.const 0)
  )
  (func $socket_bind (export "socket_bind") (param $sock i64) (param $host i64) (param $port i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $res i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = call __bmb_socket_bind(%t2, host, port)
    ;; res:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_eq_i64 res, %t4
    ;; jz %t5, .if_end_2
    ;; %t6:bool = const_i64 1
    ;; %t7:i64 = const_i64 4
    ;; sock[%t7] = %t6  ; bool
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; ret res
    (i64.const 0)
  )
  (func $socket_listen (export "socket_listen") (param $sock i64) (param $backlog i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $res i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = call __bmb_socket_listen(%t2, backlog)
    ;; res:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_eq_i64 res, %t4
    ;; jz %t5, .if_end_3
    ;; %t6:bool = const_i64 1
    ;; %t7:i64 = const_i64 5
    ;; sock[%t7] = %t6  ; bool
    ;; jmp .if_end_3
    ;; .if_end_3:
    ;; ret res
    (i64.const 0)
  )
  (func $socket_accept (export "socket_accept") (param $sock i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $client_fd i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = call __bmb_socket_accept(%t2)
    ;; client_fd:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_ge_i64 client_fd, %t4
    ;; jz %t5, .if_end_4
    ;; %t7:i64 = const_i64 6
    ;; %t8:i64 = const_i64 0
    ;; %t6:Socket = alloc_array(%t7, init=%t8)
    ;; %t9:i64 = const_i64 0
    ;; %t6[%t9] = client_fd  ; i64
    ;; %t10:i64 = const_i64 1
    ;; %t11:i64 = sock[%t10]
    ;; %t12:i64 = const_i64 1
    ;; %t6[%t12] = %t11  ; i64
    ;; %t13:i64 = const_i64 2
    ;; %t14:i64 = sock[%t13]
    ;; %t15:i64 = const_i64 2
    ;; %t6[%t15] = %t14  ; i64
    ;; %t16:bool = const_i64 1
    ;; %t17:i64 = const_i64 3
    ;; %t6[%t17] = %t16  ; bool
    ;; %t18:bool = const_i64 0
    ;; %t19:i64 = const_i64 4
    ;; %t6[%t19] = %t18  ; bool
    ;; %t20:bool = const_i64 0
    ;; %t21:i64 = const_i64 5
    ;; %t6[%t21] = %t20  ; bool
    ;; ret %t6
    ;; jmp .if_end_4
    ;; .if_end_4:
    ;; %t23:i64 = const_i64 6
    ;; %t24:i64 = const_i64 0
    ;; %t22:Socket = alloc_array(%t23, init=%t24)
    ;; %t25:i64 = const_i64 1
    ;; %t26:i64 = neg_i64 %t25
    ;; %t27:i64 = const_i64 0
    ;; %t22[%t27] = %t26  ; i64
    ;; %t28:i64 = const_i64 1
    ;; %t29:i64 = sock[%t28]
    ;; %t30:i64 = const_i64 1
    ;; %t22[%t30] = %t29  ; i64
    ;; %t31:i64 = const_i64 2
    ;; %t32:i64 = sock[%t31]
    ;; %t33:i64 = const_i64 2
    ;; %t22[%t33] = %t32  ; i64
    ;; %t34:bool = const_i64 0
    ;; %t35:i64 = const_i64 3
    ;; %t22[%t35] = %t34  ; bool
    ;; %t36:bool = const_i64 0
    ;; %t37:i64 = const_i64 4
    ;; %t22[%t37] = %t36  ; bool
    ;; %t38:bool = const_i64 0
    ;; %t39:i64 = const_i64 5
    ;; %t22[%t39] = %t38  ; bool
    ;; ret %t22
    (i64.const 0)
  )
  (func $socket_send (export "socket_send") (param $sock i64) (param $data i64) (result i64)
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
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_lt_i64 %t2, %t3
    ;; jz %t4, .if_end_5
    ;; %t5:i64 = const_i64 1
    ;; %t6:i64 = neg_i64 %t5
    ;; ret %t6
    ;; jmp .if_end_5
    ;; .if_end_5:
    ;; %t7:i64 = const_i64 0
    ;; %t8:i64 = sock[%t7]
    ;; %t9:i64 = call __bmb_socket_send(%t8, data)
    ;; ret %t9
    (i64.const 0)
  )
  (func $socket_recv (export "socket_recv") (param $sock i64) (param $max_bytes i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_lt_i64 %t2, %t3
    ;; jz %t4, .if_end_6
    ;; %t5:str = const_str 0
    ;; ret %t5
    ;; jmp .if_end_6
    ;; .if_end_6:
    ;; %t6:i64 = const_i64 0
    ;; %t7:i64 = sock[%t6]
    ;; %t8:str = call __bmb_socket_recv(%t7, max_bytes)
    ;; ret %t8
    (i64.const 0)
  )
  (func $socket_close (export "socket_close") (param $sock i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 i64)
    (local $res i64)
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
    ;; %t1:i64 = const_i64 0
    ;; %t2:i64 = sock[%t1]
    ;; %t3:i64 = const_i64 0
    ;; %t4:bool = cmp_ge_i64 %t2, %t3
    ;; jz %t4, .if_end_7
    ;; %t5:i64 = const_i64 0
    ;; %t6:i64 = sock[%t5]
    ;; %t7:i64 = call __bmb_socket_close(%t6)
    ;; res:i64 = mov %t7
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = neg_i64 %t8
    ;; %t10:i64 = const_i64 0
    ;; sock[%t10] = %t9  ; i64
    ;; %t11:bool = const_i64 0
    ;; %t12:i64 = const_i64 3
    ;; sock[%t12] = %t11  ; bool
    ;; %t13:bool = const_i64 0
    ;; %t14:i64 = const_i64 4
    ;; sock[%t14] = %t13  ; bool
    ;; %t15:bool = const_i64 0
    ;; %t16:i64 = const_i64 5
    ;; sock[%t16] = %t15  ; bool
    ;; ret res
    ;; jmp .if_end_7
    ;; .if_end_7:
    ;; %t17:i64 = const_i64 0
    ;; ret %t17
    (i64.const 0)
  )
  (func $tcp_connect (export "tcp_connect") (param $host i64) (param $port i64) (result i64)
    (local $t_t1 i64)
    (local $s i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $res i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:Socket = call tcp_socket()
    ;; s:Socket = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = s[%t2]
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_ge_i64 %t3, %t4
    ;; jz %t5, .if_end_8
    ;; %t6:i64 = call socket_connect(s, host, port)
    ;; res:i64 = mov %t6
    ;; %t7:i64 = const_i64 0
    ;; %t8:bool = cmp_ne_i64 res, %t7
    ;; jz %t8, .if_end_9
    ;; %t9:i64 = call socket_close(s)
    ;; %t11:i64 = const_i64 6
    ;; %t12:i64 = const_i64 0
    ;; %t10:Socket = alloc_array(%t11, init=%t12)
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = neg_i64 %t13
    ;; %t15:i64 = const_i64 0
    ;; %t10[%t15] = %t14  ; i64
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = const_i64 1
    ;; %t10[%t17] = %t16  ; i64
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = const_i64 2
    ;; %t10[%t19] = %t18  ; i64
    ;; %t20:bool = const_i64 0
    ;; %t21:i64 = const_i64 3
    ;; %t10[%t21] = %t20  ; bool
    ;; %t22:bool = const_i64 0
    ;; %t23:i64 = const_i64 4
    ;; %t10[%t23] = %t22  ; bool
    ;; %t24:bool = const_i64 0
    ;; %t25:i64 = const_i64 5
    ;; %t10[%t25] = %t24  ; bool
    ;; ret %t10
    ;; jmp .if_end_9
    ;; .if_end_9:
    ;; jmp .if_end_8
    ;; .if_end_8:
    ;; ret s
    (i64.const 0)
  )
  (func $tcp_server (export "tcp_server") (param $host i64) (param $port i64) (param $backlog i64) (result i64)
    (local $t_t1 i64)
    (local $s i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $b_res i64)
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
    (local $l_res i64)
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
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:Socket = call tcp_socket()
    ;; s:Socket = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = s[%t2]
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_ge_i64 %t3, %t4
    ;; jz %t5, .if_end_10
    ;; %t6:i64 = call socket_bind(s, host, port)
    ;; b_res:i64 = mov %t6
    ;; %t7:i64 = const_i64 0
    ;; %t8:bool = cmp_ne_i64 b_res, %t7
    ;; jz %t8, .if_end_11
    ;; %t9:i64 = call socket_close(s)
    ;; %t11:i64 = const_i64 6
    ;; %t12:i64 = const_i64 0
    ;; %t10:Socket = alloc_array(%t11, init=%t12)
    ;; %t13:i64 = const_i64 1
    ;; %t14:i64 = neg_i64 %t13
    ;; %t15:i64 = const_i64 0
    ;; %t10[%t15] = %t14  ; i64
    ;; %t16:i64 = const_i64 2
    ;; %t17:i64 = const_i64 1
    ;; %t10[%t17] = %t16  ; i64
    ;; %t18:i64 = const_i64 1
    ;; %t19:i64 = const_i64 2
    ;; %t10[%t19] = %t18  ; i64
    ;; %t20:bool = const_i64 0
    ;; %t21:i64 = const_i64 3
    ;; %t10[%t21] = %t20  ; bool
    ;; %t22:bool = const_i64 0
    ;; %t23:i64 = const_i64 4
    ;; %t10[%t23] = %t22  ; bool
    ;; %t24:bool = const_i64 0
    ;; %t25:i64 = const_i64 5
    ;; %t10[%t25] = %t24  ; bool
    ;; ret %t10
    ;; jmp .if_end_11
    ;; .if_end_11:
    ;; %t26:i64 = call socket_listen(s, backlog)
    ;; l_res:i64 = mov %t26
    ;; %t27:i64 = const_i64 0
    ;; %t28:bool = cmp_ne_i64 l_res, %t27
    ;; jz %t28, .if_end_12
    ;; %t29:i64 = call socket_close(s)
    ;; %t31:i64 = const_i64 6
    ;; %t32:i64 = const_i64 0
    ;; %t30:Socket = alloc_array(%t31, init=%t32)
    ;; %t33:i64 = const_i64 1
    ;; %t34:i64 = neg_i64 %t33
    ;; %t35:i64 = const_i64 0
    ;; %t30[%t35] = %t34  ; i64
    ;; %t36:i64 = const_i64 2
    ;; %t37:i64 = const_i64 1
    ;; %t30[%t37] = %t36  ; i64
    ;; %t38:i64 = const_i64 1
    ;; %t39:i64 = const_i64 2
    ;; %t30[%t39] = %t38  ; i64
    ;; %t40:bool = const_i64 0
    ;; %t41:i64 = const_i64 3
    ;; %t30[%t41] = %t40  ; bool
    ;; %t42:bool = const_i64 0
    ;; %t43:i64 = const_i64 4
    ;; %t30[%t43] = %t42  ; bool
    ;; %t44:bool = const_i64 0
    ;; %t45:i64 = const_i64 5
    ;; %t30[%t45] = %t44  ; bool
    ;; ret %t30
    ;; jmp .if_end_12
    ;; .if_end_12:
    ;; jmp .if_end_10
    ;; .if_end_10:
    ;; ret s
    (i64.const 0)
  )
  (func $raw_socket_send (export "raw_socket_send") (param $fd i64) (param $data i64) (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call __bmb_socket_send(fd, data)
    ;; ret %t1
    (i64.const 0)
  )
  (func $raw_socket_recv (export "raw_socket_recv") (param $fd i64) (param $max_bytes i64) (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = call __bmb_socket_recv(fd, max_bytes)
    ;; ret %t1
    (i64.const 0)
  )
  (func $raw_socket_close (export "raw_socket_close") (param $fd i64) (result i64)
    (local $t_t1 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = call __bmb_socket_close(fd)
    ;; ret %t1
    (i64.const 0)
  )
  (func $http_get (export "http_get") (param $host i64) (param $port i64) (param $path i64) (result i64)
    (local $t_t1 i64)
    (local $s i64)
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
    (local $req i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $resp i64)
    (local $t_t17 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:Socket = call tcp_connect(host, port)
    ;; s:Socket = mov %t1
    ;; %t2:i64 = const_i64 0
    ;; %t3:i64 = s[%t2]
    ;; %t4:i64 = const_i64 0
    ;; %t5:bool = cmp_lt_i64 %t3, %t4
    ;; jz %t5, .if_end_13
    ;; %t6:str = const_str 0
    ;; ret %t6
    ;; jmp .if_end_13
    ;; .if_end_13:
    ;; %t7:str = const_str 1
    ;; %t8:str = str_concat(%t7, path)
    ;; %t9:str = const_str 2
    ;; %t10:str = str_concat(%t8, %t9)
    ;; %t11:str = str_concat(%t10, host)
    ;; %t12:str = const_str 3
    ;; %t13:str = str_concat(%t11, %t12)
    ;; req:str = mov %t13
    ;; %t14:i64 = call socket_send(s, req)
    ;; %t15:i64 = const_i64 65536
    ;; %t16:str = call socket_recv(s, %t15)
    ;; resp:str = mov %t16
    ;; %t17:i64 = call socket_close(s)
    ;; ret resp
    (i64.const 0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $init_res i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $s i64)
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
    (local $test_port i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $t_t24 i64)
    (local $srv i64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 i64)
    (local $t_t29 i64)
    (local $t_t30 i64)
    (local $cli i64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 i64)
    (local $t_t35 i64)
    (local $conn i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $payload i64)
    (local $t_t41 i64)
    (local $bytes_sent i64)
    (local $t_t42 i64)
    (local $t_t43 i64)
    (local $t_t44 i64)
    (local $t_t45 i64)
    (local $received i64)
    (local $t_t46 i64)
    (local $t_t47 i64)
    (local $t_t48 i64)
    (local $t_t49 i64)
    (local $echo_msg i64)
    (local $t_t50 i64)
    (local $echo_sent i64)
    (local $t_t51 i64)
    (local $t_t52 i64)
    (local $t_t53 i64)
    (local $t_t54 i64)
    (local $client_echo i64)
    (local $t_t55 i64)
    (local $t_t56 i64)
    (local $t_t57 i64)
    (local $t_t58 i64)
    (local $t_t59 i64)
    (local $t_t60 i64)
    (local $t_t61 i64)
    (local $t_t62 i64)
    (local $t_t63 i64)
    (local $http_port i64)
    (local $t_t64 i64)
    (local $t_t65 i64)
    (local $t_t66 i64)
    (local $http_srv i64)
    (local $t_t67 i64)
    (local $t_t68 i64)
    (local $t_t69 i64)
    (local $http_cli i64)
    (local $t_t70 i64)
    (local $http_conn i64)
    (local $t_t71 i64)
    (local $http_req i64)
    (local $t_t72 i64)
    (local $t_t73 i64)
    (local $t_t74 i64)
    (local $req_data i64)
    (local $t_t75 i64)
    (local $t_t76 i64)
    (local $t_t77 i64)
    (local $json_body i64)
    (local $t_t78 i64)
    (local $body_len i64)
    (local $t_t79 i64)
    (local $t_t80 i64)
    (local $t_t81 i64)
    (local $t_t82 i64)
    (local $t_t83 i64)
    (local $t_t84 i64)
    (local $http_resp i64)
    (local $t_t85 i64)
    (local $t_t86 i64)
    (local $t_t87 i64)
    (local $full_resp i64)
    (local $t_t88 i64)
    (local $t_t89 i64)
    (local $t_t90 i64)
    (local $t_t91 i64)
    (local $t_t92 i64)
    (local $t_t93 i64)
    (local $t_t94 i64)
    (local $t_t95 i64)
    (local $cleanup_res i64)
    (local $t_t96 i64)
    (local $t_t97 i64)
    (local $t_t98 i64)
    (local $t_t99 i64)
    (local $t_t100 i64)
    (local $t_t101 i64)
    (local $t_t102 i64)
    (local $t_arena_sp_main i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %arena_sp_main:i64 = arena_save None
    ;; %t1:str = const_str 4
    ;; print(%t1:str)
    ;; %t2:str = const_str 5
    ;; print(%t2:str)
    ;; %t3:str = const_str 4
    ;; print(%t3:str)
    ;; %t4:str = const_str 0
    ;; print(%t4:str)
    ;; %t5:str = const_str 6
    ;; print(%t5:str)
    ;; %t6:i64 = call socket_init()
    ;; init_res:i64 = mov %t6
    ;; %t7:str = const_str 7
    ;; print(%t7:str)
    ;; %t8:str = const_str 8
    ;; print(%t8:str)
    ;; print(init_res:i64)
    ;; %t9:str = const_str 0
    ;; print(%t9:str)
    ;; %t10:str = const_str 9
    ;; print(%t10:str)
    ;; %t11:Socket = call tcp_socket()
    ;; s:Socket = mov %t11
    ;; %t12:str = const_str 10
    ;; print(%t12:str)
    ;; %t13:str = const_str 8
    ;; print(%t13:str)
    ;; %t14:i64 = const_i64 0
    ;; %t15:i64 = s[%t14]
    ;; print(%t15:i64)
    ;; %t16:str = const_str 11
    ;; print(%t16:str)
    ;; %t17:str = const_str 8
    ;; print(%t17:str)
    ;; %t18:i64 = call socket_close(s)
    ;; print(%t18:i64)
    ;; %t19:str = const_str 0
    ;; print(%t19:str)
    ;; %t20:str = const_str 12
    ;; print(%t20:str)
    ;; %t21:i64 = const_i64 17777
    ;; test_port:i64 = mov %t21
    ;; %t22:str = const_str 13
    ;; %t23:i64 = const_i64 5
    ;; %t24:Socket = call tcp_server(%t22, test_port, %t23)
    ;; srv:Socket = mov %t24
    ;; %t25:str = const_str 14
    ;; print(%t25:str)
    ;; %t26:str = const_str 15
    ;; print(%t26:str)
    ;; %t27:i64 = const_i64 0
    ;; %t28:i64 = srv[%t27]
    ;; print(%t28:i64)
    ;; %t29:str = const_str 13
    ;; %t30:Socket = call tcp_connect(%t29, test_port)
    ;; cli:Socket = mov %t30
    ;; %t31:str = const_str 16
    ;; print(%t31:str)
    ;; %t32:str = const_str 15
    ;; print(%t32:str)
    ;; %t33:i64 = const_i64 0
    ;; %t34:i64 = cli[%t33]
    ;; print(%t34:i64)
    ;; %t35:Socket = call socket_accept(srv)
    ;; conn:Socket = mov %t35
    ;; %t36:str = const_str 17
    ;; print(%t36:str)
    ;; %t37:str = const_str 18
    ;; print(%t37:str)
    ;; %t38:i64 = const_i64 0
    ;; %t39:i64 = conn[%t38]
    ;; print(%t39:i64)
    ;; %t40:str = const_str 19
    ;; payload:str = mov %t40
    ;; %t41:i64 = call socket_send(cli, payload)
    ;; bytes_sent:i64 = mov %t41
    ;; %t42:str = const_str 20
    ;; print(%t42:str)
    ;; %t43:str = const_str 8
    ;; print(%t43:str)
    ;; print(bytes_sent:i64)
    ;; %t44:i64 = const_i64 1024
    ;; %t45:str = call socket_recv(conn, %t44)
    ;; received:str = mov %t45
    ;; %t46:str = const_str 21
    ;; print(%t46:str)
    ;; %t47:str = const_str 8
    ;; print(%t47:str)
    ;; print(received:str)
    ;; %t48:str = const_str 22
    ;; %t49:str = str_concat(%t48, received)
    ;; echo_msg:str = mov %t49
    ;; %t50:i64 = call socket_send(conn, echo_msg)
    ;; echo_sent:i64 = mov %t50
    ;; %t51:str = const_str 23
    ;; print(%t51:str)
    ;; %t52:str = const_str 8
    ;; print(%t52:str)
    ;; print(echo_sent:i64)
    ;; %t53:i64 = const_i64 1024
    ;; %t54:str = call socket_recv(cli, %t53)
    ;; client_echo:str = mov %t54
    ;; %t55:str = const_str 24
    ;; print(%t55:str)
    ;; %t56:str = const_str 8
    ;; print(%t56:str)
    ;; print(client_echo:str)
    ;; %t57:i64 = call socket_close(conn)
    ;; %t58:i64 = call socket_close(cli)
    ;; %t59:i64 = call socket_close(srv)
    ;; %t60:str = const_str 25
    ;; print(%t60:str)
    ;; %t61:str = const_str 0
    ;; print(%t61:str)
    ;; %t62:str = const_str 26
    ;; print(%t62:str)
    ;; %t63:i64 = const_i64 18888
    ;; http_port:i64 = mov %t63
    ;; %t64:str = const_str 13
    ;; %t65:i64 = const_i64 5
    ;; %t66:Socket = call tcp_server(%t64, http_port, %t65)
    ;; http_srv:Socket = mov %t66
    ;; %t67:str = const_str 27
    ;; print(%t67:str)
    ;; %t68:str = const_str 13
    ;; %t69:Socket = call tcp_connect(%t68, http_port)
    ;; http_cli:Socket = mov %t69
    ;; %t70:Socket = call socket_accept(http_srv)
    ;; http_conn:Socket = mov %t70
    ;; %t71:str = const_str 28
    ;; http_req:str = mov %t71
    ;; %t72:i64 = call socket_send(http_cli, http_req)
    ;; %t73:i64 = const_i64 2048
    ;; %t74:str = call socket_recv(http_conn, %t73)
    ;; req_data:str = mov %t74
    ;; %t75:str = const_str 29
    ;; print(%t75:str)
    ;; %t76:str = const_str 8
    ;; print(%t76:str)
    ;; print(req_data:str)
    ;; %t77:str = const_str 30
    ;; json_body:str = mov %t77
    ;; %t78:i64 = str_len(json_body)
    ;; body_len:i64 = mov %t78
    ;; %t79:str = const_str 31
    ;; %t80:str = str_from_i64 body_len
    ;; %t81:str = str_concat(%t79, %t80)
    ;; %t82:str = const_str 3
    ;; %t83:str = str_concat(%t81, %t82)
    ;; %t84:str = str_concat(%t83, json_body)
    ;; http_resp:str = mov %t84
    ;; %t85:i64 = call socket_send(http_conn, http_resp)
    ;; %t86:i64 = const_i64 4096
    ;; %t87:str = call socket_recv(http_cli, %t86)
    ;; full_resp:str = mov %t87
    ;; %t88:str = const_str 32
    ;; print(%t88:str)
    ;; %t89:str = const_str 8
    ;; print(%t89:str)
    ;; print(full_resp:str)
    ;; %t90:i64 = call socket_close(http_conn)
    ;; %t91:i64 = call socket_close(http_cli)
    ;; %t92:i64 = call socket_close(http_srv)
    ;; %t93:str = const_str 0
    ;; print(%t93:str)
    ;; %t94:str = const_str 33
    ;; print(%t94:str)
    ;; %t95:i64 = call socket_cleanup()
    ;; cleanup_res:i64 = mov %t95
    ;; %t96:str = const_str 34
    ;; print(%t96:str)
    ;; %t97:str = const_str 8
    ;; print(%t97:str)
    ;; print(cleanup_res:i64)
    ;; %t98:str = const_str 0
    ;; print(%t98:str)
    ;; %t99:str = const_str 4
    ;; print(%t99:str)
    ;; %t100:str = const_str 35
    ;; print(%t100:str)
    ;; %t101:str = const_str 4
    ;; print(%t101:str)
    ;; %t102:i64 = const_i64 0
    ;; arena_restore %arena_sp_main
    ;; ret %t102
    (i64.const 0)
  )
  (func $__bmb_main__ (export "__bmb_main__")  (result i64)
    (local $t_t1 i64)
    (local $AF_INET i64)
    (local $t_t2 i64)
    (local $SOCK_STREAM i64)
    (local $t_t3 i64)
    (local $SOCK_DGRAM i64)
    (local $t_t4 i64)
    (local $IPPROTO_IP i64)
    (local $t_t5 i64)
    (local $IPPROTO_TCP i64)
    (local $t_t6 i64)
    (local $IPPROTO_UDP i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $INVALID_SOCKET i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $SOCKET_ERROR i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; AF_INET:i64 = mov %t1
    ;; %t2:i64 = const_i64 1
    ;; SOCK_STREAM:i64 = mov %t2
    ;; %t3:i64 = const_i64 2
    ;; SOCK_DGRAM:i64 = mov %t3
    ;; %t4:i64 = const_i64 0
    ;; IPPROTO_IP:i64 = mov %t4
    ;; %t5:i64 = const_i64 6
    ;; IPPROTO_TCP:i64 = mov %t5
    ;; %t6:i64 = const_i64 17
    ;; IPPROTO_UDP:i64 = mov %t6
    ;; %t7:i64 = const_i64 1
    ;; %t8:i64 = neg_i64 %t7
    ;; INVALID_SOCKET:i64 = mov %t8
    ;; %t9:i64 = const_i64 1
    ;; %t10:i64 = neg_i64 %t9
    ;; SOCKET_ERROR:i64 = mov %t10
    ;; %t11:i64 = call main()
    ;; %t12:i64 = const_i64 0
    ;; ret %t12
    (i64.const 0)
  )
)