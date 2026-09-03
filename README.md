# LOLangPRISM

LOLangPRISM serves as the central repository for the LOLang project. LOLang is a lightweight scripting language designed for game engines.

Visit the official website at [prismtechnologies.com.br/home](https://prismtechnologies.com.br/home) for downloads, documentation, and news.

---

## Community Links

* **Official Website:** [PRISM Technologies](https://prismtechnologies.com.br/home)
* **Discord:** [Join the Community Server](https://discord.gg/Z56bWFsQZj)
* **Reddit:** [r/lolang Subreddit](https://www.reddit.com/r/lolang/)
* **Instagram:** [@benrrava](https://www.instagram.com/benrrava/)

---

## Quick Start Examples

### 1. Game Loop & 2D Drawing

```lolang
window("LOLang Process", 960, 600)

let position = 0

while true do
    update()
    clear_screen()
    
    set_color(255, 255, 255)
    draw_text("LOLang PRISM Demo", 20, 20)
    
    draw_rect(position, 100, 50, 50)
    position = position + (100 * dt())
    
    frame_end(false)
end

```

### 2. 3D Model Rendering (.glb)

```lolang
window("3D Scene", 1280, 720)
let model = load_model("asset.glb")

while true do
    update()
    clear_screen()
    
    draw_model(model, 0, 0, 0, 0, 45, 0, 1, 1, 1)
    
    frame_end(true)
end

```

### 3. Audio Synthesis

```lolang
synth_note(0, 440, "square", 0.15, 0.6)

```

---

## Repository Demos

* **`demos/01_hello_world.lol`**: Basic output and variable usage.
* **`demos/02_basic_window.lol`**: Native OS window initialization and clearing loop.
* **`demos/03_interactive_movement.lol`**: Keyboard and mouse input handling.
* **`demos/04_procedural_terrain.lol`**: Dynamic heightmap terrain generation.
* **`demos/05_audio_synth.lol`**: Built-in multi-track audio synthesis.

---

## CLI Reference

| Command | Action |
| --- | --- |
| `lolang script.lol` | Executes script directly via runtime VM |
| `lolang --repl` | Launches interactive line-by-line prompt |
| `lolang --compile main.lol -o game.exe` | Compiles script into a native executable |

---

Developed by benrrava.
