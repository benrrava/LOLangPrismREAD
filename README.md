# LOLangPRISM 🌈

Welcome to **LOLangPRISM**, the ultimate reference, demo hub, and community showcase for **LOLang** — an embeddable, high-performance scripting language built specifically for game development.

LOLang provides low-overhead game logic, native windowing, 2D canvas drawing, 3D mesh and PBR model rendering, procedural terrain, audio synthesis, and real-time UDP networking.

---

## 🔗 Official Community & Links

Connect with the community, discuss features, and share your creations:

* 💬 **Discord:** [Join the Community Server](https://discord.gg/Z56bWFsQZj)
* 🔴 **Reddit:** [r/lolang Subreddit](https://www.reddit.com/r/lolang/)
* 📸 **Instagram:** [@benrrava](https://www.instagram.com/benrrava/)

---

## ⚡ Quick Start & Examples

Below are quick examples demonstrating core feature sets in LOLang.

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
