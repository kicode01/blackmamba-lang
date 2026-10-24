(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $angle f64)
    (local $t_t5 i64)
    (local $t_t6 i64)
    (local $t_t7 f64)
    (local $s i64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 f64)
    (local $num f64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $root i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $dyn_calc i64)
    (local $t_t18 i64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 i64)
    (local $t_t22 i64)
    (local $t_t23 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:str = const_str 1
    ;; print(%t2:str)
    ;; %t3:str = const_str 0
    ;; print(%t3:str)
    ;; %t4:f64 = const_f64 1.57079632679
    ;; angle:f64 = mov %t4
    ;; %t5:str = const_str 2
    ;; %t6:str = const_str 3
    ;; %t7:f64 = py_call_f64 %t5, %t6
    ;; %t8:i64 = f64_to_i64 %t7
    ;; s:i64 = mov %t8
    ;; %t9:str = const_str 4
    ;; print(%t9:str, s:i64)
    ;; %t10:f64 = const_f64 144.0
    ;; num:f64 = mov %t10
    ;; %t11:str = const_str 2
    ;; %t12:str = const_str 5
    ;; %t13:f64 = py_call_f64 %t11, %t12
    ;; %t14:i64 = f64_to_i64 %t13
    ;; root:i64 = mov %t14
    ;; %t15:str = const_str 6
    ;; print(%t15:str, root:i64)
    ;; %t16:str = const_str 7
    ;; %t17:f64 = py_eval_f64 %t16
    ;; %t18:i64 = f64_to_i64 %t17
    ;; dyn_calc:i64 = mov %t18
    ;; %t19:str = const_str 8
    ;; print(%t19:str, dyn_calc:i64)
    ;; %t20:str = const_str 0
    ;; print(%t20:str)
    ;; %t21:str = const_str 9
    ;; print(%t21:str)
    ;; %t22:str = const_str 0
    ;; print(%t22:str)
    ;; %t23:i64 = const_i64 0
    ;; ret %t23
    (i64.const 0)
  )
)