(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $fib (export "fib") (param $n i64) (result i64)
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
    ;; %t1:i64 = const_i64 1
    ;; %t2:bool = cmp_le_i64 n, %t1
    ;; jz %t2, .if_end_1
    ;; ret n
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t3:i64 = const_i64 1
    ;; %t4:i64 = sub_i64 n, %t3
    ;; %t5:i64 = call fib(%t4)
    ;; %t6:i64 = const_i64 2
    ;; %t7:i64 = sub_i64 n, %t6
    ;; %t8:i64 = call fib(%t7)
    ;; %t9:i64 = add_i64 %t5, %t8
    ;; ret %t9
    (i64.const 0)
  )
  (func $fib_iterative (export "fib_iterative") (param $n i64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $a i64)
    (local $t_t4 i64)
    (local $b i64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $i i64)
    (local $t_t7 i64)
    (local $t_t8 i64)
    (local $c i64)
    (local $t_t9 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 1
    ;; %t2:bool = cmp_le_i64 n, %t1
    ;; jz %t2, .if_end_2
    ;; ret n
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; %t3:i64 = const_i64 0
    ;; a:i64 = mov %t3
    ;; %t4:i64 = const_i64 1
    ;; b:i64 = mov %t4
    ;; %t5:i64 = const_i64 2
    ;; %t6:i64 = const_i64 1
    ;; i:i64 = mov %t5
    ;; .for_cond_3:
    ;; %t7:bool = cmp_le_i64 i, n
    ;; jz %t7, .for_end_5
    ;; %t8:i64 = add_i64 a, b
    ;; c:i64 = mov %t8
    ;; a:i64 = mov b
    ;; b:i64 = mov c
    ;; .for_step_4:
    ;; %t9:i64 = add_i64 i, %t6
    ;; i:i64 = mov %t9
    ;; jmp .for_cond_3
    ;; .for_end_5:
    ;; ret b
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
    (local $t_t11 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:str = const_str 1
    ;; %t3:i64 = const_i64 20
    ;; %t4:i64 = call fib(%t3)
    ;; print(%t2:str, %t4:i64)
    ;; %t5:str = const_str 2
    ;; %t6:i64 = const_i64 30
    ;; %t7:i64 = call fib(%t6)
    ;; print(%t5:str, %t7:i64)
    ;; %t8:str = const_str 3
    ;; %t9:i64 = const_i64 50
    ;; %t10:i64 = call fib_iterative(%t9)
    ;; print(%t8:str, %t10:i64)
    ;; %t11:i64 = const_i64 0
    ;; ret %t11
    (i64.const 0)
  )
)