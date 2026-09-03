// Demo 08: Mini Arena Shooter
window("LOLang PRISM - Arena Shooter", 800, 600)

let px = 400
let py = 300
let speed = 200

let enemy_x = 100
let enemy_y = 100
let enemy_speed = 80
let kills = 0

while true do
    update()
    clear_screen()

    let delta = dt()

    // Player Movement controls
    if keydown("W") then py = py - speed * delta end
    if keydown("S") then py = py + speed * delta end
    if keydown("A") then px = px - speed * delta end
    if keydown("D") then px = px + speed * delta end

    // Chasing Enemy AI
    let edx = px - enemy_x
    let edy = py - enemy_y
    if edx > 0 then enemy_x = enemy_x + enemy_speed * delta end
    if edx < 0 then enemy_x = enemy_x - enemy_speed * delta end
    if edy > 0 then enemy_y = enemy_y + enemy_speed * delta end
    if edy < 0 then enemy_y = enemy_y - enemy_speed * delta end

    // Attack Action (Shoot / Attack on Mouse Click)
    if mouse_clicked() then
        let mx = mouse_x()
        let my = mouse_y()

        // Check distance between attack hit and enemy
        let hit_dx = enemy_x - mx
        let hit_dy = enemy_y - my
        let hit_dist = hit_dx * hit_dx + hit_dy * hit_dy

        if hit_dist < 2500 then
            kills = kills + 1
            enemy_x = 50
            enemy_y = 50
            synth_note(0, 150, "sawtooth", 0.2, 0.7)
        else
            synth_note(0, 800, "triangle", 0.05, 0.2)
        end
    end

    // Background
    set_color(15, 15, 30)
    draw_rect(0, 0, 800, 600)

    // Enemy
    set_color(255, 60, 60)
    draw_rect(enemy_x - 15, enemy_y - 15, 30, 30)

    // Player
    set_color(60, 200, 255)
    draw_circle(px, py, 15)

    // Crosshair
    set_color(255, 255, 255)
    let mx = mouse_x()
    let my = mouse_y()
    draw_rect(mx - 5, my - 1, 10, 2)
    draw_rect(mx - 1, my - 5, 2, 10)

    // UI
    draw_text("ENEMIES DESTROYED: " + to_string(kills), 20, 20)
    draw_text("WASD to Move | Left Click to Attack Enemy", 20, 50)

    frame_end(false)
end