// Demo 01: Hello World & Basic Variables
window("LOLang PRISM - Hello World", 800, 600)

let message = "Hello, LOLang PRISM!"
let counter = 0

while true do
    update()
    clear_screen()

    counter = counter + dt()

    set_color(255, 255, 255)
    draw_text(message, 300, 280)
    
    set_color(180, 180, 180)
    draw_text("Uptime: " + to_string(floor(counter)) + " seconds", 300, 310)

    frame_end(false)
end