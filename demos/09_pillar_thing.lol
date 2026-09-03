// 3D Pillar Spinner Jump - Endgame Evolution Edition
window("3D Pillar Spinner Jump", 1920, 1080)
set_clear_color(10, 12, 22)

let player = {
    x = 0.0, y = 0.75, z = 12.0,
    vx = 0.0, vy = 0.0, vz = 0.0,
    yaw = 0.0, pitch = 20.0,
    size = 1.5,
    half_size = 0.75,
    mass = 70.0,
    base_move_force = 2400.0,
    drag = 7.0,
    is_grounded = true,
    mesh = create_cube(1.5, 1.5, 1.5)
}

let gravity = -34.0
let base_jump_force = 14.0

// Cylinder Arena
let platform_radius = 28.0
let platform_y = 0.0

let max_arm_length = 26.0
let arm_height = 0.5
let arm_thickness = 0.7

// Telegraphed Growing Spinner Lengths
let arm1_len = max_arm_length
let arm2_len = 0.0
let arm3_len = 0.0
let arm4_len = 0.0

let spinner_angle = 0.0
let base_spinner_speed = 2.0

let is_game_over = false
let score = 0.0
let high_score = 0.0

// Active Power-up Timers
let speed_timer = 0.0
let jump_timer = 0.0
let shield_timer = 0.0
let slows_timer = 0.0
let boots_timer = 0.0
let double_timer = 0.0

let upgrade_level = 1

// Active Power-up Pickup Item
let item = {
    x = rand(-20, 20),
    y = 0.8,
    z = rand(-20, 20),
    type = "speed",
    active = true,
    rotation = 0.0,
    mesh = create_cube(1.2, 1.2, 1.2)
}

// Falling Hazard
let meteor = {
    x = 0.0, z = 0.0, y = 35.0,
    active = false,
    mesh = create_cube(2.5, 2.5, 2.5)
}

let shockwave_r = 0.0
let shockwave_active = false

// Camera & Controls
let mouse_locked = true
let sensitivity = 0.15
let m_was_down = false
let prev_mouse_x = mouse_x()
let prev_mouse_y = mouse_y()
let shake_time = 0.0

// Meshes
let shaft_mesh = create_cube(2.8, 5.0, 2.8)
let platform_mesh = create_cylinder(platform_radius, 8.0, 32)
let water_mesh = create_plane(300, 300, 1)
let shock_mesh = create_cylinder(1.0, 0.2, 24)

// Collision with Growing Spinner Arms
func check_arm_collision(angle, current_len)
    if shield_timer > 0.0 or current_len <= 1.0 then
        return false
    end

    let player_top = player.y + player.half_size
    let player_bottom = player.y - player.half_size
    let arm_top = arm_height + (arm_thickness / 2.0)
    let arm_bottom = arm_height - (arm_thickness / 2.0)

    if player_bottom < arm_top and player_top > arm_bottom then
        let arm_dir_x = cos(angle)
        let arm_dir_z = -sin(angle)

        let proj = player.x * arm_dir_x + player.z * arm_dir_z
        let clamped_proj = clamp(proj, -current_len, current_len)

        let close_x = arm_dir_x * clamped_proj
        let close_z = arm_dir_z * clamped_proj

        let dx = player.x - close_x
        let dz = player.z - close_z
        let dist_sq = dx * dx + dz * dz

        let hit_radius = (arm_thickness / 2.0) + player.half_size
        if dist_sq <= (hit_radius * hit_radius) then
            return true
        end
    end
    return false
end

while true do
    update()
    let dt_s = dt()
    if dt_s > 0.1 then dt_s = 0.1 end

    let m_is_down = keydown("M")
    if m_is_down and not m_was_down then
        mouse_locked = not mouse_locked
    end
    m_was_down = m_is_down

    let curr_mouse_x = mouse_x()
    let curr_mouse_y = mouse_y()
    let mdx = curr_mouse_x - prev_mouse_x
    let mdy = curr_mouse_y - prev_mouse_y
    prev_mouse_x = curr_mouse_x
    prev_mouse_y = curr_mouse_y

    if not is_game_over then
        // Double Score Power-up
        let score_mult = 1.0
        if double_timer > 0.0 then score_mult = 2.0 end
        score = score + (dt_s * score_mult)

        if score > high_score then 
            high_score = score 
        end

        upgrade_level = 1 + floor(score / 12.0)

        // Time Slow Power-up affect overall game speed
        let speed_time_mult = 1.0
        if slows_timer > 0.0 then speed_time_mult = 0.4 end

        let current_spinner_speed = (base_spinner_speed + (score * 0.04)) * speed_time_mult
        spinner_angle = spinner_angle + current_spinner_speed * dt_s

        // --- GRADUAL BAR GROWING MECHANIC (Spawn Animation) ---
        if score >= 10.0 then
            arm2_len = clamp(arm2_len + (max_arm_length / 2.0) * dt_s, 0.0, max_arm_length)
        end
        if score >= 22.0 then
            arm3_len = clamp(arm3_len + (max_arm_length / 2.0) * dt_s, 0.0, max_arm_length)
        end
        if score >= 38.0 then
            arm4_len = clamp(arm4_len + (max_arm_length / 2.0) * dt_s, 0.0, max_arm_length)
        end

        // Decrement Active Buff Timers
        if speed_timer > 0.0 then speed_timer = speed_timer - dt_s end
        if jump_timer > 0.0 then jump_timer = jump_timer - dt_s end
        if shield_timer > 0.0 then shield_timer = shield_timer - dt_s end
        if slows_timer > 0.0 then slows_timer = slows_timer - dt_s end
        if boots_timer > 0.0 then boots_timer = boots_timer - dt_s end
        if double_timer > 0.0 then double_timer = double_timer - dt_s end

        // Orbit Camera Controls
        if mouse_locked then
            player.yaw = player.yaw - mdx * sensitivity
            player.pitch = clamp(player.pitch + mdy * sensitivity, -10.0, 85.0)
        end

        let rad = player.yaw * 3.14159265 / 180.0
        let fwd_x = -sin(rad)
        let fwd_z = -cos(rad)
        let right_x = cos(rad)
        let right_z = -sin(rad)

        let speed_boost = 1.8 + (upgrade_level * 0.2)
        let force_mult = 1.0
        if speed_timer > 0.0 then force_mult = speed_boost end
        if keydown("LSHIFT") then force_mult = force_mult * 1.3 end

        let input_x = 0.0
        let input_z = 0.0

        if keydown("W") or keydown("UP") then input_x = input_x + fwd_x input_z = input_z + fwd_z end
        if keydown("S") or keydown("DOWN") then input_x = input_x - fwd_x input_z = input_z - fwd_z end
        if keydown("A") or keydown("LEFT") then input_x = input_x - right_x input_z = input_z - right_z end
        if keydown("D") or keydown("RIGHT") then input_x = input_x + right_x input_z = input_z + right_z end

        let input_len_sq = input_x * input_x + input_z * input_z
        if input_len_sq > 0.0001 then
            let inv_len = 1.0 / sqrt(input_len_sq)
            input_x = input_x * inv_len
            input_z = input_z * inv_len

            let move_force = player.base_move_force * force_mult
            player.vx = player.vx + (input_x * move_force / player.mass) * dt_s
            player.vz = player.vz + (input_z * move_force / player.mass) * dt_s
        end

        let air_drag = player.drag
        if not player.is_grounded then air_drag = player.drag * 0.2 end

        player.vx = player.vx - player.vx * air_drag * dt_s
        player.vz = player.vz - player.vz * air_drag * dt_s

        // Gravity Boots Modifier
        let current_gravity = gravity
        if boots_timer > 0.0 then current_gravity = gravity * 2.2 end
        player.vy = player.vy + current_gravity * dt_s

        player.x = player.x + player.vx * dt_s
        player.y = player.y + player.vy * dt_s
        player.z = player.z + player.vz * dt_s

        // Ground Physics Check
        let dist_from_center = sqrt(player.x * player.x + player.z * player.z)
        if dist_from_center <= platform_radius then
            let min_y = platform_y + player.half_size
            if player.y <= min_y then
                player.y = min_y
                player.vy = 0.0
                player.is_grounded = true
            end
        else
            player.is_grounded = false
        end

        // Jump Mechanics
        let jump_boost = 1.4 + (upgrade_level * 0.1)
        let current_jump_force = base_jump_force
        if jump_timer > 0.0 then current_jump_force = base_jump_force * jump_boost end

        if keydown("SPACE") and player.is_grounded then
            player.vy = current_jump_force
            player.is_grounded = false
        end

        // --- HAZARD 1: TARGETED METEOR ---
        if score >= 12.0 then
            if not meteor.active then
                meteor.x = player.x + rand(-2, 2)
                meteor.z = player.z + rand(-2, 2)
                meteor.y = 35.0
                meteor.active = true
            else
                meteor.y = meteor.y - (35.0 * speed_time_mult) * dt_s
                if meteor.y <= 0.5 then
                    let mdx = player.x - meteor.x
                    let mdz = player.z - meteor.z
                    if sqrt(mdx * mdx + mdz * mdz) < 3.0 and shield_timer <= 0.0 then
                        is_game_over = true
                        shake_time = 0.6
                    end
                    meteor.active = false
                end
            end
        end

        // --- HAZARD 2: EXPANDING GROUND SHOCKWAVE ---
        if score >= 28.0 then
            if not shockwave_active then
                if score % 7.0 < 0.1 then
                    shockwave_active = true
                    shockwave_r = 1.0
                end
            else
                shockwave_r = shockwave_r + (22.0 * speed_time_mult) * dt_s
                let player_dist = sqrt(player.x * player.x + player.z * player.z)
                if abs(player_dist - shockwave_r) < 1.5 and player.y <= 1.2 and shield_timer <= 0.0 then
                    is_game_over = true
                    shake_time = 0.6
                end
                if shockwave_r >= platform_radius then
                    shockwave_active = false
                end
            end
        end

        // Death Fall Check
        if player.y < -4.0 then
            is_game_over = true
            shake_time = 0.4
        end

        // --- SPINNER ARM COLLISIONS ---
        if check_arm_collision(spinner_angle, arm1_len) then
            is_game_over = true shake_time = 0.5
        end

        if check_arm_collision(spinner_angle + 1.570796, arm2_len) then
            is_game_over = true shake_time = 0.5
        end

        if check_arm_collision(-spinner_angle * 1.4, arm3_len) then
            is_game_over = true shake_time = 0.5
        end

        if check_arm_collision(-spinner_angle * 1.4 + 1.570796, arm4_len) then
            is_game_over = true shake_time = 0.5
        end

        // --- SCALING POWER-UP ITEM PICKUP ---
        if item.active then
            item.rotation = item.rotation + 4.0 * dt_s
            item.y = 0.8 + sin(score * 6.0) * 0.3

            let dx = player.x - item.x
            let dz = player.z - item.z
            if sqrt(dx * dx + dz * dz) < 2.0 then
                let duration = 6.0 + (upgrade_level * 1.2)
                if item.type == "speed" then speed_timer = duration
                else if item.type == "jump" then jump_timer = duration
                else if item.type == "shield" then shield_timer = duration
                else if item.type == "slow" then slows_timer = duration
                else if item.type == "boots" then boots_timer = duration
                else double_timer = duration end end end end end

                item.active = false
            end
        else
            // Faster respawns as the game progresses
            let spawn_rate = clamp(5.0 - (upgrade_level * 0.2), 2.0, 5.0)
            if score % spawn_rate < 0.1 then
                item.x = rand(-22, 22)
                item.z = rand(-22, 22)

                let p_type = rand(1, 6)
                if p_type == 1 then item.type = "speed"
                else if p_type == 2 then item.type = "jump"
                else if p_type == 3 then item.type = "shield"
                else if p_type == 4 then item.type = "slow"
                else if p_type == 5 then item.type = "boots"
                else item.type = "double" end end end end end

                item.active = true
            end
        end
    else
        if keydown("R") then
            player.x = 0.0
            player.y = platform_y + player.half_size
            player.z = 12.0
            player.vx = 0.0
            player.vy = 0.0
            player.vz = 0.0
            player.is_grounded = true
            is_game_over = false
            score = 0.0
            spinner_angle = 0.0

            arm1_len = max_arm_length
            arm2_len = 0.0
            arm3_len = 0.0
            arm4_len = 0.0

            speed_timer = 0.0
            jump_timer = 0.0
            shield_timer = 0.0
            slows_timer = 0.0
            boots_timer = 0.0
            double_timer = 0.0

            item.active = true
            meteor.active = false
            shockwave_active = false
        end
    end

    clear_screen()

    // Screen Shake
    let cam_x = player.x
    let cam_y = player.y
    let cam_z = player.z
    if shake_time > 0.0 then
        shake_time = shake_time - dt_s
        cam_x = cam_x + (sin(shake_time * 60.0) * 0.4)
        cam_y = cam_y + (cos(shake_time * 60.0) * 0.4)
    end

    camera_target(cam_x, cam_y, cam_z)
    camera(player.yaw, player.pitch, 13)

    // Render Scene
    draw_mesh(water_mesh, 0, -10, 0, 0, 0, 0, 1, 1, 1, 10, 40, 110, 255, false)
    draw_mesh(platform_mesh, 0, -4.0, 0, 0, 0, 0, 1, 1, 1, 55, 60, 75, 255, false)
    draw_mesh(shaft_mesh, 0, 0, 0, 0, 0, 0, 1, 1, 1, 30, 30, 30, 255, false)

    // Ground Shockwave
    if shockwave_active then
        draw_mesh(shock_mesh, 0, 0.1, 0, 0, 0, 0, shockwave_r, 1, shockwave_r, 255, 30, 30, 200, false)
    end

    // Player Color Dynamics
    let pr = 230 let pg = 60 let pb = 60
    if shield_timer > 0.0 then pr = 255 pg = 215 pb = 0
    else if slows_timer > 0.0 then pr = 180 pg = 60 pb = 255
    else if boots_timer > 0.0 then pr = 255 pg = 120 pb = 0
    else if double_timer > 0.0 then pr = 255 pg = 20 pb = 140
    else if speed_timer > 0.0 then pr = 60 pg = 220 pb = 255
    else if jump_timer > 0.0 then pr = 80 pg = 255 pb = 120 end end end end end end

    draw_mesh(player.mesh, player.x, player.y, player.z, 0, player.yaw, 0, 1, 1, 1, pr, pg, pb, 255, false)

    // Render Dynamically Sized Spinner Arms
    let spinner_deg = spinner_angle * 57.2958

    if arm1_len > 0.1 then
        let mesh1 = create_cube(arm1_len * 2, arm_thickness, arm_thickness)
        draw_mesh(mesh1, 0, arm_height, 0, 0, spinner_deg, 0, 1, 1, 1, 255, 180, 0, 255, false)
    end

    if arm2_len > 0.1 then
        let mesh2 = create_cube(arm2_len * 2, arm_thickness, arm_thickness)
        draw_mesh(mesh2, 0, arm_height, 0, 0, spinner_deg + 90.0, 0, 1, 1, 1, 255, 80, 0, 255, false)
    end

    if arm3_len > 0.1 then
        let mesh3 = create_cube(arm3_len * 2, arm_thickness, arm_thickness)
        draw_mesh(mesh3, 0, arm_height + 0.8, 0, 0, -spinner_deg * 1.4, 0, 1, 1, 1, 255, 0, 100, 255, false)
    end

    if arm4_len > 0.1 then
        let mesh4 = create_cube(arm4_len * 2, arm_thickness, arm_thickness)
        draw_mesh(mesh4, 0, arm_height + 0.8, 0, 0, -spinner_deg * 1.4 + 90.0, 0, 1, 1, 1, 220, 0, 200, 255, false)
    end

    // Meteor Hazard
    if meteor.active then
        draw_mesh(meteor.mesh, meteor.x, meteor.y, meteor.z, 0, score * 120.0, 0, 1, 1, 1, 255, 40, 0, 255, false)
    end

    // Power-up Pickups
    if item.active then
        let ir = 60 let ig = 220 let ib = 255
        if item.type == "jump" then ir = 80 ig = 255 ib = 120
        else if item.type == "shield" then ir = 255 ig = 215 ib = 0
        else if item.type == "slow" then ir = 180 ig = 60 ib = 255
        else if item.type == "boots" then ir = 255 ig = 120 ib = 0
        else if item.type == "double" then ir = 255 ig = 20 ib = 140 end end end end end

        draw_mesh(item.mesh, item.x, item.y, item.z, 0, item.rotation * 57.29, 0, 1, 1, 1, ir, ig, ib, 255, false)
    end

    // HUD Text
    set_color(255, 255, 255)
    draw_text("TIME: " + tostring(score), 40, 40)
    draw_text("BEST: " + tostring(high_score), 40, 70)

    set_color(255, 200, 50)
    draw_text("UPGRADE LEVEL: " + tostring(upgrade_level), 40, 105)

    if shield_timer > 0.0 then set_color(255, 215, 0) draw_text("INVINCIBLE SHIELD!", 40, 135)
    else if slows_timer > 0.0 then set_color(180, 60, 255) draw_text("CHRONO SLOW ACTIVE!", 40, 135)
    else if boots_timer > 0.0 then set_color(255, 120, 0) draw_text("GRAVITY BOOTS ACTIVE!", 40, 135)
    else if double_timer > 0.0 then set_color(255, 20, 140) draw_text("2X SCORE OVERCLOCK!", 40, 135)
    else if speed_timer > 0.0 then set_color(60, 220, 255) draw_text("SPEED BOOST ACTIVE!", 40, 135)
    else if jump_timer > 0.0 then set_color(80, 255, 120) draw_text("SUPER JUMP ACTIVE!", 40, 135) end end end end end end

    if is_game_over then
        set_color(255, 60, 60)
        draw_text("GAME OVER!", 880, 480)
        set_color(255, 255, 255)
        draw_text("Press 'R' to Restart", 840, 520)
    end

    frame_end(true)
end