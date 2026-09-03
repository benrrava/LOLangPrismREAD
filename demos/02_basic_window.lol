// Demo 02: Native OS Window & Background Loop
window("LOLang PRISM - Basic Window", 960, 540)

let r = 20
let g = 30
let b = 50

while true do
    update()
    
    // Clear background with custom color
    set_clear_color(r, g, b)
    clear_screen()

    set_color(255, 255, 255)
    draw_text("Native Window Initialized Successfully", 30, 30)
    draw_text("Press ESC or close the window to exit", 30, 60)

    frame_end(false)
end