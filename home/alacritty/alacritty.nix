{ ... }:


{
programs.alacritty = {
enable = true;


settings = {
general.live_config_reload = true;


env.COLORTERM = "truecolor";


window = {
opacity = 0.8;
dynamic_title = true;
};


font = {
size = 14.25;
normal = { family = "Hack Nerd Font Mono"; style = "Regular"; };
bold = { family = "Hack Nerd Font Mono"; style = "Bold"; };
italic = { family = "Hack Nerd Font Mono"; style = "Italic"; };
bold_italic = { family = "Hack Nerd Font Mono"; style = "Bold Italic"; };
};


cursor = {
style = { shape = "Block"; blinking = "On"; };
blink_interval = 750;
};


scrolling = { history = 10000; multiplier = 3; };


selection.save_to_clipboard = true;


keyboard.bindings = [
{ key = "C"; mods = "Control|Shift"; action = "Copy"; }
{ key = "V"; mods = "Control|Shift"; action = "Paste"; }
{ key = "Q"; mods = "Control|Shift"; action = "Quit"; }
{ key = "Return"; mods = "Alt"; action = "SpawnNewInstance"; }
];


colors = {
primary = { background = "#1e1e2e"; foreground = "#cdd6f4"; };
cursor = { text = "#1e1e2e"; cursor = "#f5e0dc"; };
selection = { text = "CellForeground"; background = "#45475a"; };


normal = {
black = "#45475a"; red = "#f38ba8"; green = "#a6e3a1";
yellow = "#f9e2af"; blue = "#89b4fa"; magenta = "#f5c2e7";
cyan = "#94e2d5"; white = "#bac2de";
};


bright = {
black = "#585b70"; red = "#f38ba8"; green = "#a6e3a1";
yellow = "#f9e2af"; blue = "#89b4fa"; magenta = "#f5c2e7";
cyan = "#94e2d5"; white = "#a6adc8";
};
};
};
};
}


