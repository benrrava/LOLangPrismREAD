// Demo 03: Interactive Input & Motion
window("LOLang PRISM - Interactive Movement", 800, 600)

let player_x = 380
let player_y = 280
let speed = 250
let player_size = 40

while true do
    update()
    clear_screen()

    // Key input handling
    if keydown("W") or keydown("UP") then 
        player_y = player_y - speed * dt() 
    end
    if keydown("S") or keydown("DOWN") then 
        player_y = player_y + speed * dt() 
    end
    if keydown("A") or keydown("LEFT") then 
        player_x = player_x - speed * dt() 
    end
    if keydown("D") or keydown("RIGHT") then 
        player_x = player_x + speed * dt() 
    end

    // Screen bounds clamping
    if player_x < 0 then player_x = 0 end
    if player_x > 800 - player_size then player_x = 800 - player_size end
    if player_y < 0 then player_y = 0 end
    if player_y > 600 - player_size then player_y = 600 - player_size end

    // Draw player square
    set_color(0, 180, 255)
    draw_rect(player_x, player_y, player_size, player_size)

    // UI Overlay
    set_color(255, 255, 255)
    draw_text("Controls: WASD / Arrow Keys", 20, 20)
    draw_text("X: " + to_string(floor(player_x)) + " | Y: " + to_string(floor(player_y)), 20, 45)

    frame_end(false)
end