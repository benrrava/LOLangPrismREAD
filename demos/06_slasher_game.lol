// Demo 06: Neon Particle Slasher
window("LOLang PRISM - Neon Slasher", 800, 600)

let player_x = 400
let player_y = 500
let target_x = 400
let target_y = 200
let score = 0
let combo = 1
let target_radius = 25
let pulse_timer = 0
let note_index = 1

while true do
    update()
    clear_screen()

    // Smooth player movement toward target
    player_x = player_x + (target_x - player_x) * 0.15
    player_y = player_y + (target_y - player_y) * 0.15

    // Pulse target visual
    pulse_timer = pulse_timer + dt() * 5
    let target_draw_radius = target_radius + (5 * (pulse_timer % 2))

    // Input handling
    if mouse_clicked() then
        target_x = mouse_x()
        target_y = mouse_y()
    end

    // Check hit collision
    let dx = player_x - target_x
    let dy = player_y - target_y
    let dist = (dx * dx + dy * dy)

    if dist < (target_radius * target_radius) then
        score = score + (100 * combo)
        combo = combo + 1
        
        // Randomize next target position using index step
        note_index = note_index + 1
        target_x = 100 + ((note_index * 70) % 600)
        target_y = 100 + ((note_index * 50) % 400)

        // Play feedback synth sound
        synth_note(0, 440 + (combo * 40), "triangle", 0.1, 0.4)
    end

    // Visuals
    set_color(10, 10, 25)
    draw_rect(0, 0, 800, 600)

    // Target
    set_color(255, 50, 120)
    draw_circle(target_x, target_y, target_draw_radius)

    // Player
    set_color(0, 255, 200)
    draw_circle(player_x, player_y, 15)

    // HUD
    set_color(255, 255, 255)
    draw_text("SCORE: " + to_string(score), 20, 20)
    draw_text("COMBO: x" + to_string(combo), 20, 45)

    frame_end(false)
end