// Demo 04: Procedural 2D Terrain Generation
window("LOLang PRISM - Procedural Terrain", 1000, 600)

let time_offset = 0

while true do
    update()
    clear_screen()

    time_offset = time_offset + dt() * 2

    // Draw sky
    set_color(15, 15, 35)
    draw_rect(0, 0, 1000, 600)

    // Draw dynamic procedural heightmap column by column
    let col = 0
    while col < 1000 do
        let height = 300 + sin(col * 0.01 + time_offset) * 80 + cos(col * 0.025 - time_offset) * 40
        
        // Ground color
        set_color(30, 160, 90)
        draw_rect(col, height, 2, 600 - height)

        // Surface highlight
        set_color(80, 220, 120)
        draw_rect(col, height, 2, 4)

        col = col + 2
    end

    set_color(255, 255, 255)
    draw_text("Procedural Wave Heightmap", 20, 20)

    frame_end(false)
end