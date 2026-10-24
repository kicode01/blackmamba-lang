; ModuleID = 'black_mamba_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @printf(ptr nocapture readonly, ...)
declare ptr @calloc(i64, i64)
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f64 = private unnamed_addr constant [6 x i8] c"%.6g\0A\00"

define dso_local double @Particle__kinetic_energy(i64 %self.arg) #0 {
entry:
  %self.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %t2.slot = alloca i64, align 8
  %t3.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca i64, align 8
  %t6.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  store i64 %self.arg, ptr %self.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 5.000000e-01, ptr %t1.slot, align 8
  store i64 4, ptr %t2.slot, align 8
  ; %t3:f64 = self[%t2]
  ; %t4:f64 = mul_f64 %t1, %t3
  store i64 2, ptr %t5.slot, align 8
  ; %t6:f64 = self[%t5]
  store i64 2, ptr %t7.slot, align 8
  ; %t8:f64 = self[%t7]
  ; %t9:f64 = mul_f64 %t6, %t8
  store i64 3, ptr %t10.slot, align 8
  ; %t11:f64 = self[%t10]
  store i64 3, ptr %t12.slot, align 8
  ; %t13:f64 = self[%t12]
  ; %t14:f64 = mul_f64 %t11, %t13
  ; %t15:f64 = add_f64 %t9, %t14
  ; %t16:f64 = mul_f64 %t4, %t15
  %r1 = load double, ptr %t16.slot, align 8
  ret double %r1
ret_cont_1:
  ret double 0.0
}

define dso_local i64 @step_physics(i64 %p.arg, double %dt.arg, double %gravity.arg, double %restitution.arg, double %max_x.arg, double %max_y.arg) #0 {
entry:
  %p.slot = alloca i64, align 8
  %dt.slot = alloca double, align 8
  %gravity.slot = alloca double, align 8
  %restitution.slot = alloca double, align 8
  %max_x.slot = alloca double, align 8
  %max_y.slot = alloca double, align 8
  %t1.slot = alloca i64, align 8
  %t2.slot = alloca double, align 8
  %new_vx.slot = alloca double, align 8
  %t3.slot = alloca i64, align 8
  %t4.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %new_vy.slot = alloca double, align 8
  %t7.slot = alloca i64, align 8
  %t8.slot = alloca double, align 8
  %t9.slot = alloca double, align 8
  %t10.slot = alloca double, align 8
  %new_x.slot = alloca double, align 8
  %t11.slot = alloca i64, align 8
  %t12.slot = alloca double, align 8
  %t13.slot = alloca double, align 8
  %t14.slot = alloca double, align 8
  %new_y.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca i64, align 8
  %t17.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca double, align 8
  %t20.slot = alloca double, align 8
  %t21.slot = alloca i64, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca double, align 8
  %t24.slot = alloca double, align 8
  %t25.slot = alloca double, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca double, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca double, align 8
  %t30.slot = alloca double, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca double, align 8
  %t33.slot = alloca double, align 8
  %t34.slot = alloca double, align 8
  %t35.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca i64, align 8
  %t42.slot = alloca i64, align 8
  %t43.slot = alloca double, align 8
  %t44.slot = alloca i64, align 8
  store i64 %p.arg, ptr %p.slot, align 8
  store double %dt.arg, ptr %dt.slot, align 8
  store double %gravity.arg, ptr %gravity.slot, align 8
  store double %restitution.arg, ptr %restitution.slot, align 8
  store double %max_x.arg, ptr %max_x.slot, align 8
  store double %max_y.arg, ptr %max_y.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store i64 2, ptr %t1.slot, align 8
  ; %t2:f64 = p[%t1]
  %r1 = load double, ptr %t2.slot, align 8
  store double %r1, ptr %new_vx.slot, align 8
  store i64 3, ptr %t3.slot, align 8
  ; %t4:f64 = p[%t3]
  ; %t5:f64 = mul_f64 gravity, dt
  ; %t6:f64 = add_f64 %t4, %t5
  %r2 = load double, ptr %t6.slot, align 8
  store double %r2, ptr %new_vy.slot, align 8
  store i64 0, ptr %t7.slot, align 8
  ; %t8:f64 = p[%t7]
  ; %t9:f64 = mul_f64 new_vx, dt
  ; %t10:f64 = add_f64 %t8, %t9
  %r3 = load double, ptr %t10.slot, align 8
  store double %r3, ptr %new_x.slot, align 8
  store i64 1, ptr %t11.slot, align 8
  ; %t12:f64 = p[%t11]
  ; %t13:f64 = mul_f64 new_vy, dt
  ; %t14:f64 = add_f64 %t12, %t13
  %r4 = load double, ptr %t14.slot, align 8
  store double %r4, ptr %new_y.slot, align 8
  store double 0.000000e+00, ptr %t15.slot, align 8
  ; %t16:bool = cmp_le_f64 new_y, %t15
  %r5 = load i64, ptr %t16.slot, align 8
  %r6 = icmp eq i64 %r5, 0
  br i1 %r6, label %if_end_1, label %fall_6
fall_6:
  store double 0.000000e+00, ptr %t17.slot, align 8
  %r7 = load double, ptr %t17.slot, align 8
  store double %r7, ptr %new_y.slot, align 8
  store double 0.000000e+00, ptr %t18.slot, align 8
  ; %t19:f64 = mul_f64 new_vy, restitution
  ; %t20:f64 = sub_f64 %t18, %t19
  %r8 = load double, ptr %t20.slot, align 8
  store double %r8, ptr %new_vy.slot, align 8
  br label %if_end_1
dead_r9:
  br label %if_end_1
if_end_1:
  ; %t21:bool = cmp_ge_f64 new_y, max_y
  %r10 = load i64, ptr %t21.slot, align 8
  %r11 = icmp eq i64 %r10, 0
  br i1 %r11, label %if_end_2, label %fall_11
fall_11:
  %r12 = load double, ptr %max_y.slot, align 8
  store double %r12, ptr %new_y.slot, align 8
  store double 0.000000e+00, ptr %t22.slot, align 8
  ; %t23:f64 = mul_f64 new_vy, restitution
  ; %t24:f64 = sub_f64 %t22, %t23
  %r13 = load double, ptr %t24.slot, align 8
  store double %r13, ptr %new_vy.slot, align 8
  br label %if_end_2
dead_r14:
  br label %if_end_2
if_end_2:
  store double 0.000000e+00, ptr %t25.slot, align 8
  ; %t26:bool = cmp_le_f64 new_x, %t25
  %r15 = load i64, ptr %t26.slot, align 8
  %r16 = icmp eq i64 %r15, 0
  br i1 %r16, label %if_end_3, label %fall_16
fall_16:
  store double 0.000000e+00, ptr %t27.slot, align 8
  %r17 = load double, ptr %t27.slot, align 8
  store double %r17, ptr %new_x.slot, align 8
  store double 0.000000e+00, ptr %t28.slot, align 8
  ; %t29:f64 = mul_f64 new_vx, restitution
  ; %t30:f64 = sub_f64 %t28, %t29
  %r18 = load double, ptr %t30.slot, align 8
  store double %r18, ptr %new_vx.slot, align 8
  br label %if_end_3
dead_r19:
  br label %if_end_3
if_end_3:
  ; %t31:bool = cmp_ge_f64 new_x, max_x
  %r20 = load i64, ptr %t31.slot, align 8
  %r21 = icmp eq i64 %r20, 0
  br i1 %r21, label %if_end_4, label %fall_21
fall_21:
  %r22 = load double, ptr %max_x.slot, align 8
  store double %r22, ptr %new_x.slot, align 8
  store double 0.000000e+00, ptr %t32.slot, align 8
  ; %t33:f64 = mul_f64 new_vx, restitution
  ; %t34:f64 = sub_f64 %t32, %t33
  %r23 = load double, ptr %t34.slot, align 8
  store double %r23, ptr %new_vx.slot, align 8
  br label %if_end_4
dead_r24:
  br label %if_end_4
if_end_4:
  store i64 5, ptr %t36.slot, align 8
  store i64 0, ptr %t37.slot, align 8
  ; %t35:Particle = alloc_array(%t36, init=%t37)
  store i64 0, ptr %t38.slot, align 8
  ; %t35[%t38] = new_x  ; f64
  store i64 1, ptr %t39.slot, align 8
  ; %t35[%t39] = new_y  ; f64
  store i64 2, ptr %t40.slot, align 8
  ; %t35[%t40] = new_vx  ; f64
  store i64 3, ptr %t41.slot, align 8
  ; %t35[%t41] = new_vy  ; f64
  store i64 4, ptr %t42.slot, align 8
  ; %t43:f64 = p[%t42]
  store i64 4, ptr %t44.slot, align 8
  ; %t35[%t44] = %t43  ; f64
  %r25 = load i64, ptr %t35.slot, align 8
  ret i64 %r25
ret_cont_25:
  ret i64 0
}

define dso_local double @run_simulation(i64 %particle_count.arg, i64 %frame_count.arg) #0 {
entry:
  %particle_count.slot = alloca i64, align 8
  %frame_count.slot = alloca i64, align 8
  %t1.slot = alloca double, align 8
  %dt.slot = alloca double, align 8
  %t2.slot = alloca double, align 8
  %t3.slot = alloca double, align 8
  %gravity.slot = alloca double, align 8
  %t4.slot = alloca double, align 8
  %restitution.slot = alloca double, align 8
  %t5.slot = alloca double, align 8
  %world_w.slot = alloca double, align 8
  %t6.slot = alloca double, align 8
  %world_h.slot = alloca double, align 8
  %t7.slot = alloca double, align 8
  %total_energy.slot = alloca double, align 8
  %t8.slot = alloca i64, align 8
  %t9.slot = alloca i64, align 8
  %i.slot = alloca i64, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca double, align 8
  %t12.slot = alloca i64, align 8
  %t13.slot = alloca i64, align 8
  %t14.slot = alloca double, align 8
  %t15.slot = alloca double, align 8
  %t16.slot = alloca double, align 8
  %t17.slot = alloca double, align 8
  %v_init_x.slot = alloca double, align 8
  %t18.slot = alloca double, align 8
  %t19.slot = alloca i64, align 8
  %t20.slot = alloca i64, align 8
  %t21.slot = alloca double, align 8
  %t22.slot = alloca double, align 8
  %t23.slot = alloca double, align 8
  %t24.slot = alloca double, align 8
  %v_init_y.slot = alloca double, align 8
  %t25.slot = alloca i64, align 8
  %t26.slot = alloca i64, align 8
  %t27.slot = alloca i64, align 8
  %t28.slot = alloca double, align 8
  %t29.slot = alloca i64, align 8
  %t30.slot = alloca double, align 8
  %t31.slot = alloca i64, align 8
  %t32.slot = alloca i64, align 8
  %t33.slot = alloca i64, align 8
  %t34.slot = alloca double, align 8
  %t35.slot = alloca i64, align 8
  %p.slot = alloca i64, align 8
  %t36.slot = alloca i64, align 8
  %t37.slot = alloca i64, align 8
  %frame.slot = alloca i64, align 8
  %t38.slot = alloca i64, align 8
  %t39.slot = alloca i64, align 8
  %t40.slot = alloca i64, align 8
  %t41.slot = alloca double, align 8
  %t42.slot = alloca double, align 8
  %t43.slot = alloca i64, align 8
  store i64 %particle_count.arg, ptr %particle_count.slot, align 8
  store i64 %frame_count.arg, ptr %frame_count.slot, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  store double 1.666700e-02, ptr %t1.slot, align 8
  %r1 = load double, ptr %t1.slot, align 8
  store double %r1, ptr %dt.slot, align 8
  store double 9.810000e+00, ptr %t2.slot, align 8
  ; %t3:f64 = neg_f64 %t2
  %r2 = load double, ptr %t3.slot, align 8
  store double %r2, ptr %gravity.slot, align 8
  store double 8.200000e-01, ptr %t4.slot, align 8
  %r3 = load double, ptr %t4.slot, align 8
  store double %r3, ptr %restitution.slot, align 8
  store double 8.000000e+02, ptr %t5.slot, align 8
  %r4 = load double, ptr %t5.slot, align 8
  store double %r4, ptr %world_w.slot, align 8
  store double 6.000000e+02, ptr %t6.slot, align 8
  %r5 = load double, ptr %t6.slot, align 8
  store double %r5, ptr %world_h.slot, align 8
  store double 0.000000e+00, ptr %t7.slot, align 8
  %r6 = load double, ptr %t7.slot, align 8
  store double %r6, ptr %total_energy.slot, align 8
  store i64 1, ptr %t8.slot, align 8
  store i64 1, ptr %t9.slot, align 8
  %r7 = load i64, ptr %t8.slot, align 8
  store i64 %r7, ptr %i.slot, align 8
  br label %for_cond_5
for_cond_5:
  ; %t10:bool = cmp_le_i64 i, particle_count
  %r8 = load i64, ptr %t10.slot, align 8
  %r9 = icmp eq i64 %r8, 0
  br i1 %r9, label %for_end_7, label %fall_9
fall_9:
  store double 1.000000e+01, ptr %t11.slot, align 8
  store i64 25, ptr %t12.slot, align 8
  ; %t13:i64 = mod_i64 i, %t12
  store double 1.500000e+00, ptr %t14.slot, align 8
  ; %t15:f64 = i64_to_f64 %t13
  ; %t16:f64 = mul_f64 %t15, %t14
  ; %t17:f64 = add_f64 %t11, %t16
  %r10 = load double, ptr %t17.slot, align 8
  store double %r10, ptr %v_init_x.slot, align 8
  store double 4.500000e+01, ptr %t18.slot, align 8
  store i64 30, ptr %t19.slot, align 8
  ; %t20:i64 = mod_i64 i, %t19
  store double 1.200000e+00, ptr %t21.slot, align 8
  ; %t22:f64 = i64_to_f64 %t20
  ; %t23:f64 = mul_f64 %t22, %t21
  ; %t24:f64 = add_f64 %t18, %t23
  %r11 = load double, ptr %t24.slot, align 8
  store double %r11, ptr %v_init_y.slot, align 8
  store i64 5, ptr %t26.slot, align 8
  store i64 0, ptr %t27.slot, align 8
  ; %t25:Particle = alloc_array(%t26, init=%t27)
  store double 1.000000e+01, ptr %t28.slot, align 8
  store i64 0, ptr %t29.slot, align 8
  ; %t25[%t29] = %t28  ; f64
  store double 5.000000e+01, ptr %t30.slot, align 8
  store i64 1, ptr %t31.slot, align 8
  ; %t25[%t31] = %t30  ; f64
  store i64 2, ptr %t32.slot, align 8
  ; %t25[%t32] = v_init_x  ; f64
  store i64 3, ptr %t33.slot, align 8
  ; %t25[%t33] = v_init_y  ; f64
  store double 1.250000e+00, ptr %t34.slot, align 8
  store i64 4, ptr %t35.slot, align 8
  ; %t25[%t35] = %t34  ; f64
  %r12 = load i64, ptr %t25.slot, align 8
  store i64 %r12, ptr %p.slot, align 8
  store i64 1, ptr %t36.slot, align 8
  store i64 1, ptr %t37.slot, align 8
  %r13 = load i64, ptr %t36.slot, align 8
  store i64 %r13, ptr %frame.slot, align 8
  br label %for_cond_8
for_cond_8:
  ; %t38:bool = cmp_le_i64 frame, frame_count
  %r14 = load i64, ptr %t38.slot, align 8
  %r15 = icmp eq i64 %r14, 0
  br i1 %r15, label %for_end_10, label %fall_15
fall_15:
  ; %t39:Particle = call step_physics(p, dt, gravity, restitution, world_w, world_h)
  %r16 = load i64, ptr %t39.slot, align 8
  store i64 %r16, ptr %p.slot, align 8
  br label %for_step_9
for_step_9:
  ; %t40:i64 = add_i64 frame, %t37
  %r17 = load i64, ptr %t40.slot, align 8
  store i64 %r17, ptr %frame.slot, align 8
  br label %for_cond_8
dead_r18:
  br label %for_end_10
for_end_10:
  ; %t41:f64 = call Particle__kinetic_energy(p)
  ; %t42:f64 = add_f64 total_energy, %t41
  %r19 = load double, ptr %t42.slot, align 8
  store double %r19, ptr %total_energy.slot, align 8
  br label %for_step_6
for_step_6:
  ; %t43:i64 = add_i64 i, %t9
  %r20 = load i64, ptr %t43.slot, align 8
  store i64 %r20, ptr %i.slot, align 8
  br label %for_cond_5
dead_r21:
  br label %for_end_7
for_end_7:
  %r22 = load double, ptr %total_energy.slot, align 8
  ret double %r22
ret_cont_22:
  ret double 0.0
}

define dso_local i64 @main() #0 {
entry:
  %t1.slot = alloca ptr, align 8
  %t2.slot = alloca ptr, align 8
  %t3.slot = alloca ptr, align 8
  %t4.slot = alloca ptr, align 8
  %t5.slot = alloca i64, align 8
  %particles.slot = alloca i64, align 8
  %t6.slot = alloca i64, align 8
  %frames.slot = alloca i64, align 8
  %t7.slot = alloca double, align 8
  %final_energy.slot = alloca double, align 8
  %t8.slot = alloca ptr, align 8
  %t9.slot = alloca ptr, align 8
  %t10.slot = alloca i64, align 8
  %t11.slot = alloca ptr, align 8
  %t12.slot = alloca ptr, align 8
  %t13.slot = alloca ptr, align 8
  %t14.slot = alloca ptr, align 8
  %t15.slot = alloca ptr, align 8
  %t16.slot = alloca i64, align 8
  br label %__tco_entry
  br label %__tco_entry
__tco_entry:
  ; %t1:str = const_str 0
  ; print(%t1:str)
  ; %t2:str = const_str 1
  ; print(%t2:str)
  ; %t3:str = const_str 0
  ; print(%t3:str)
  ; %t4:str = const_str 2
  ; print(%t4:str)
  store i64 5000, ptr %t5.slot, align 8
  %r1 = load i64, ptr %t5.slot, align 8
  store i64 %r1, ptr %particles.slot, align 8
  store i64 120, ptr %t6.slot, align 8
  %r2 = load i64, ptr %t6.slot, align 8
  store i64 %r2, ptr %frames.slot, align 8
  ; %t7:f64 = call run_simulation(particles, frames)
  %r3 = load double, ptr %t7.slot, align 8
  store double %r3, ptr %final_energy.slot, align 8
  ; %t8:str = const_str 3
  ; print(%t8:str)
  ; %t9:str = const_str 4
  ; %t10:i64 = mul_i64 particles, frames
  ; %t11:str = const_str 5
  ; print(%t9:str, %t10:i64, %t11:str)
  ; %t12:str = const_str 6
  ; print(%t12:str, final_energy:f64)
  ; %t13:str = const_str 7
  ; print(%t13:str)
  ; %t14:str = const_str 8
  ; print(%t14:str)
  ; %t15:str = const_str 0
  ; print(%t15:str)
  store i64 0, ptr %t16.slot, align 8
  %r4 = load i64, ptr %t16.slot, align 8
  ret i64 %r4
ret_cont_4:
  ret i64 0
}
