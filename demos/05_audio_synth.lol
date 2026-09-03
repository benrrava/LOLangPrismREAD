// Demo 05: Audio Synthesis & Sound Generation
window("LOLang PRISM - Audio Synth", 800, 600)

let timer = 0
let note_index = 1
let frequencies = {261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25}

while true do
    update()
    clear_screen()

    timer = timer + dt()

    // Trigger next synthesized note every 0.3 seconds
    if timer >= 0.3 then
        timer = 0
        let current_freq = frequencies[note_index]
        
        // Channel, Frequency, Waveform, Duration, Volume
        synth_note(0, current_freq, "square", 0.2, 0.5)

        note_index = note_index + 1
        if note_index > 8 then
            note_index = 1
        end
    end

    set_color(255, 255, 255)
    draw_text("Real-Time Audio Synthesizer Loop", 20, 20)
    draw_text("Playing Frequency: " + tostring(frequencies[note_index]) + " Hz", 20, 50)

    // Visualizer bar
    let bar_height = (frequencies[note_index] / 523.25) * 300
    set_color(255, 100, 0)
    draw_rect(350, 500 - bar_height, 100, bar_height)

    frame_end(false)
end