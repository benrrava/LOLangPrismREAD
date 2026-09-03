// Demo 10: Audio-Reactive Rhythm Bounce
window("LOLang PRISM - Rhythm Bounce", 800, 600)

let ball_x = 400
let ball_y = 300
let ball_vy = 0
let gravity = 600
let bpm_timer = 0
let beat_interval = 0.4
let target_zone_y = 480
let score = 0

// Arrays/Tables in LOLang are 1-indexed
let notes = {130.81, 164.81, 196.00, 261.63}
let note_idx = 1

while true do
    update()
    clear_screen()

    let delta = dt()
    bpm_timer = bpm_timer + delta

    // Play steady background kick/bass synth
    if bpm_timer >= beat_interval then
        bpm_timer = bpm_timer - beat_interval
        synth_note(1, notes[note_idx], "sine", 0.15, 0.6)
        
        note_idx = note_idx + 1
        if note_idx > 4 then
            note_idx = 1
        end
    end

    // Ball physics
    ball_vy = ball_vy + gravity * delta
    ball_y = ball_y + ball_vy * delta

    // Click or Press Space to bounce
    if keypressed("SPACE") or mouse_clicked() then
        ball_vy = -350

        // Timing precision check
        let diff = ball_y - target_zone_y
        if diff < 0 then diff = -diff end

        if diff < 40 then
            score = score + 250
            synth_note(0, 523.25, "square", 0.1, 0.5)
        end
    end

    // Ground collision
    if ball_y > 550 then
        ball_y = 550
        ball_vy = -200
    end

    // Drawing
    set_color(20, 20, 20)
    draw_rect(0, 0, 800, 600)

    // Rhythm Target Zone
    set_color(0, 255, 100)
    draw_rect(0, target_zone_y, 800, 10)

    // Bouncing Ball
    set_color(255, 200, 0)
    draw_circle(ball_x, ball_y, 20)

    // Score UI
    set_color(255, 255, 255)
    draw_text("SCORE: " + to_string(score), 20, 20)
    draw_text("Press SPACE / Click to Bounce on the Green Line!", 20, 50)

    frame_end(false)
end