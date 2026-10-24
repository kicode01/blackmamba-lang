(module
  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend
  (memory (export "memory") 1)
  (func $Particle__kinetic_energy (export "Particle__kinetic_energy") (param $self i64) (result f64)
    (local $t_t1 f64)
    (local $t_t2 i64)
    (local $t_t3 f64)
    (local $t_t4 f64)
    (local $t_t5 i64)
    (local $t_t6 f64)
    (local $t_t7 i64)
    (local $t_t8 f64)
    (local $t_t9 f64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 i64)
    (local $t_t13 f64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.5
    ;; %t2:i64 = const_i64 4
    ;; %t3:f64 = self[%t2]
    ;; %t4:f64 = mul_f64 %t1, %t3
    ;; %t5:i64 = const_i64 2
    ;; %t6:f64 = self[%t5]
    ;; %t7:i64 = const_i64 2
    ;; %t8:f64 = self[%t7]
    ;; %t9:f64 = mul_f64 %t6, %t8
    ;; %t10:i64 = const_i64 3
    ;; %t11:f64 = self[%t10]
    ;; %t12:i64 = const_i64 3
    ;; %t13:f64 = self[%t12]
    ;; %t14:f64 = mul_f64 %t11, %t13
    ;; %t15:f64 = add_f64 %t9, %t14
    ;; %t16:f64 = mul_f64 %t4, %t15
    ;; ret %t16
    (f64.const 0.0)
  )
  (func $step_physics (export "step_physics") (param $p i64) (param $dt f64) (param $gravity f64) (param $restitution f64) (param $max_x f64) (param $max_y f64) (result i64)
    (local $t_t1 i64)
    (local $t_t2 f64)
    (local $new_vx f64)
    (local $t_t3 i64)
    (local $t_t4 f64)
    (local $t_t5 f64)
    (local $t_t6 f64)
    (local $new_vy f64)
    (local $t_t7 i64)
    (local $t_t8 f64)
    (local $t_t9 f64)
    (local $t_t10 f64)
    (local $new_x f64)
    (local $t_t11 i64)
    (local $t_t12 f64)
    (local $t_t13 f64)
    (local $t_t14 f64)
    (local $new_y f64)
    (local $t_t15 f64)
    (local $t_t16 i64)
    (local $t_t17 f64)
    (local $t_t18 f64)
    (local $t_t19 f64)
    (local $t_t20 f64)
    (local $t_t21 i64)
    (local $t_t22 f64)
    (local $t_t23 f64)
    (local $t_t24 f64)
    (local $t_t25 f64)
    (local $t_t26 i64)
    (local $t_t27 f64)
    (local $t_t28 f64)
    (local $t_t29 f64)
    (local $t_t30 f64)
    (local $t_t31 i64)
    (local $t_t32 f64)
    (local $t_t33 f64)
    (local $t_t34 f64)
    (local $t_t35 i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 i64)
    (local $t_t42 i64)
    (local $t_t43 f64)
    (local $t_t44 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:i64 = const_i64 2
    ;; %t2:f64 = p[%t1]
    ;; new_vx:f64 = mov %t2
    ;; %t3:i64 = const_i64 3
    ;; %t4:f64 = p[%t3]
    ;; %t5:f64 = mul_f64 gravity, dt
    ;; %t6:f64 = add_f64 %t4, %t5
    ;; new_vy:f64 = mov %t6
    ;; %t7:i64 = const_i64 0
    ;; %t8:f64 = p[%t7]
    ;; %t9:f64 = mul_f64 new_vx, dt
    ;; %t10:f64 = add_f64 %t8, %t9
    ;; new_x:f64 = mov %t10
    ;; %t11:i64 = const_i64 1
    ;; %t12:f64 = p[%t11]
    ;; %t13:f64 = mul_f64 new_vy, dt
    ;; %t14:f64 = add_f64 %t12, %t13
    ;; new_y:f64 = mov %t14
    ;; %t15:f64 = const_f64 0.0
    ;; %t16:bool = cmp_le_f64 new_y, %t15
    ;; jz %t16, .if_end_1
    ;; %t17:f64 = const_f64 0.0
    ;; new_y:f64 = mov %t17
    ;; %t18:f64 = const_f64 0.0
    ;; %t19:f64 = mul_f64 new_vy, restitution
    ;; %t20:f64 = sub_f64 %t18, %t19
    ;; new_vy:f64 = mov %t20
    ;; jmp .if_end_1
    ;; .if_end_1:
    ;; %t21:bool = cmp_ge_f64 new_y, max_y
    ;; jz %t21, .if_end_2
    ;; new_y:f64 = mov max_y
    ;; %t22:f64 = const_f64 0.0
    ;; %t23:f64 = mul_f64 new_vy, restitution
    ;; %t24:f64 = sub_f64 %t22, %t23
    ;; new_vy:f64 = mov %t24
    ;; jmp .if_end_2
    ;; .if_end_2:
    ;; %t25:f64 = const_f64 0.0
    ;; %t26:bool = cmp_le_f64 new_x, %t25
    ;; jz %t26, .if_end_3
    ;; %t27:f64 = const_f64 0.0
    ;; new_x:f64 = mov %t27
    ;; %t28:f64 = const_f64 0.0
    ;; %t29:f64 = mul_f64 new_vx, restitution
    ;; %t30:f64 = sub_f64 %t28, %t29
    ;; new_vx:f64 = mov %t30
    ;; jmp .if_end_3
    ;; .if_end_3:
    ;; %t31:bool = cmp_ge_f64 new_x, max_x
    ;; jz %t31, .if_end_4
    ;; new_x:f64 = mov max_x
    ;; %t32:f64 = const_f64 0.0
    ;; %t33:f64 = mul_f64 new_vx, restitution
    ;; %t34:f64 = sub_f64 %t32, %t33
    ;; new_vx:f64 = mov %t34
    ;; jmp .if_end_4
    ;; .if_end_4:
    ;; %t36:i64 = const_i64 5
    ;; %t37:i64 = const_i64 0
    ;; %t35:Particle = alloc_array(%t36, init=%t37)
    ;; %t38:i64 = const_i64 0
    ;; %t35[%t38] = new_x  ; f64
    ;; %t39:i64 = const_i64 1
    ;; %t35[%t39] = new_y  ; f64
    ;; %t40:i64 = const_i64 2
    ;; %t35[%t40] = new_vx  ; f64
    ;; %t41:i64 = const_i64 3
    ;; %t35[%t41] = new_vy  ; f64
    ;; %t42:i64 = const_i64 4
    ;; %t43:f64 = p[%t42]
    ;; %t44:i64 = const_i64 4
    ;; %t35[%t44] = %t43  ; f64
    ;; ret %t35
    (i64.const 0)
  )
  (func $run_simulation (export "run_simulation") (param $particle_count i64) (param $frame_count i64) (result f64)
    (local $t_t1 f64)
    (local $dt f64)
    (local $t_t2 f64)
    (local $t_t3 f64)
    (local $gravity f64)
    (local $t_t4 f64)
    (local $restitution f64)
    (local $t_t5 f64)
    (local $world_w f64)
    (local $t_t6 f64)
    (local $world_h f64)
    (local $t_t7 f64)
    (local $total_energy f64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $i i64)
    (local $t_t10 i64)
    (local $t_t11 f64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 f64)
    (local $t_t15 f64)
    (local $t_t16 f64)
    (local $t_t17 f64)
    (local $v_init_x f64)
    (local $t_t18 f64)
    (local $t_t19 i64)
    (local $t_t20 i64)
    (local $t_t21 f64)
    (local $t_t22 f64)
    (local $t_t23 f64)
    (local $t_t24 f64)
    (local $v_init_y f64)
    (local $t_t25 i64)
    (local $t_t26 i64)
    (local $t_t27 i64)
    (local $t_t28 f64)
    (local $t_t29 i64)
    (local $t_t30 f64)
    (local $t_t31 i64)
    (local $t_t32 i64)
    (local $t_t33 i64)
    (local $t_t34 f64)
    (local $t_t35 i64)
    (local $p i64)
    (local $t_t36 i64)
    (local $t_t37 i64)
    (local $frame i64)
    (local $t_t38 i64)
    (local $t_t39 i64)
    (local $t_t40 i64)
    (local $t_t41 f64)
    (local $t_t42 f64)
    (local $t_t43 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:f64 = const_f64 0.016667
    ;; dt:f64 = mov %t1
    ;; %t2:f64 = const_f64 9.81
    ;; %t3:f64 = neg_f64 %t2
    ;; gravity:f64 = mov %t3
    ;; %t4:f64 = const_f64 0.82
    ;; restitution:f64 = mov %t4
    ;; %t5:f64 = const_f64 800.0
    ;; world_w:f64 = mov %t5
    ;; %t6:f64 = const_f64 600.0
    ;; world_h:f64 = mov %t6
    ;; %t7:f64 = const_f64 0.0
    ;; total_energy:f64 = mov %t7
    ;; %t8:i64 = const_i64 1
    ;; %t9:i64 = const_i64 1
    ;; i:i64 = mov %t8
    ;; .for_cond_5:
    ;; %t10:bool = cmp_le_i64 i, particle_count
    ;; jz %t10, .for_end_7
    ;; %t11:f64 = const_f64 10.0
    ;; %t12:i64 = const_i64 25
    ;; %t13:i64 = mod_i64 i, %t12
    ;; %t14:f64 = const_f64 1.5
    ;; %t15:f64 = i64_to_f64 %t13
    ;; %t16:f64 = mul_f64 %t15, %t14
    ;; %t17:f64 = add_f64 %t11, %t16
    ;; v_init_x:f64 = mov %t17
    ;; %t18:f64 = const_f64 45.0
    ;; %t19:i64 = const_i64 30
    ;; %t20:i64 = mod_i64 i, %t19
    ;; %t21:f64 = const_f64 1.2
    ;; %t22:f64 = i64_to_f64 %t20
    ;; %t23:f64 = mul_f64 %t22, %t21
    ;; %t24:f64 = add_f64 %t18, %t23
    ;; v_init_y:f64 = mov %t24
    ;; %t26:i64 = const_i64 5
    ;; %t27:i64 = const_i64 0
    ;; %t25:Particle = alloc_array(%t26, init=%t27)
    ;; %t28:f64 = const_f64 10.0
    ;; %t29:i64 = const_i64 0
    ;; %t25[%t29] = %t28  ; f64
    ;; %t30:f64 = const_f64 50.0
    ;; %t31:i64 = const_i64 1
    ;; %t25[%t31] = %t30  ; f64
    ;; %t32:i64 = const_i64 2
    ;; %t25[%t32] = v_init_x  ; f64
    ;; %t33:i64 = const_i64 3
    ;; %t25[%t33] = v_init_y  ; f64
    ;; %t34:f64 = const_f64 1.25
    ;; %t35:i64 = const_i64 4
    ;; %t25[%t35] = %t34  ; f64
    ;; p:Particle = mov %t25
    ;; %t36:i64 = const_i64 1
    ;; %t37:i64 = const_i64 1
    ;; frame:i64 = mov %t36
    ;; .for_cond_8:
    ;; %t38:bool = cmp_le_i64 frame, frame_count
    ;; jz %t38, .for_end_10
    ;; %t39:Particle = call step_physics(p, dt, gravity, restitution, world_w, world_h)
    ;; p:Particle = mov %t39
    ;; .for_step_9:
    ;; %t40:i64 = add_i64 frame, %t37
    ;; frame:i64 = mov %t40
    ;; jmp .for_cond_8
    ;; .for_end_10:
    ;; %t41:f64 = call Particle__kinetic_energy(p)
    ;; %t42:f64 = add_f64 total_energy, %t41
    ;; total_energy:f64 = mov %t42
    ;; .for_step_6:
    ;; %t43:i64 = add_i64 i, %t9
    ;; i:i64 = mov %t43
    ;; jmp .for_cond_5
    ;; .for_end_7:
    ;; ret total_energy
    (f64.const 0.0)
  )
  (func $main (export "main")  (result i64)
    (local $t_t1 i64)
    (local $t_t2 i64)
    (local $t_t3 i64)
    (local $t_t4 i64)
    (local $t_t5 i64)
    (local $particles i64)
    (local $t_t6 i64)
    (local $frames i64)
    (local $t_t7 f64)
    (local $final_energy f64)
    (local $t_t8 i64)
    (local $t_t9 i64)
    (local $t_t10 i64)
    (local $t_t11 i64)
    (local $t_t12 i64)
    (local $t_t13 i64)
    (local $t_t14 i64)
    (local $t_t15 i64)
    (local $t_t16 i64)
    (local $__pc i32)
    ;; __tco_entry:
    ;; %t1:str = const_str 0
    ;; print(%t1:str)
    ;; %t2:str = const_str 1
    ;; print(%t2:str)
    ;; %t3:str = const_str 0
    ;; print(%t3:str)
    ;; %t4:str = const_str 2
    ;; print(%t4:str)
    ;; %t5:i64 = const_i64 5000
    ;; particles:i64 = mov %t5
    ;; %t6:i64 = const_i64 120
    ;; frames:i64 = mov %t6
    ;; %t7:f64 = call run_simulation(particles, frames)
    ;; final_energy:f64 = mov %t7
    ;; %t8:str = const_str 3
    ;; print(%t8:str)
    ;; %t9:str = const_str 4
    ;; %t10:i64 = mul_i64 particles, frames
    ;; %t11:str = const_str 5
    ;; print(%t9:str, %t10:i64, %t11:str)
    ;; %t12:str = const_str 6
    ;; print(%t12:str, final_energy:f64)
    ;; %t13:str = const_str 7
    ;; print(%t13:str)
    ;; %t14:str = const_str 8
    ;; print(%t14:str)
    ;; %t15:str = const_str 0
    ;; print(%t15:str)
    ;; %t16:i64 = const_i64 0
    ;; ret %t16
    (i64.const 0)
  )
)