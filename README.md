# Anchor Point (anchor.point)

Unbind your widgets from the bar! **Anchor Point** is an independent Omarchy service plugin that provides an invisible Wayland anchor and a dedicated IPC channel. 

It allows you to open *any* standard Omarchy bar-widget dropdown menu (like the clock calendar, audio mixer, or custom plugins) as a standalone floating panel via terminal commands or keybinds, entirely independent of the physical Omarchy bar.

This is especially useful if you are using a custom replacement bar (like a dynamic island) that doesn't natively support all the default dropdowns, or if you simply prefer triggering menus via keyboard shortcuts without a visible bar.

## Features
- **Invisible Footprint:** Runs silently in the background with a 0% opacity anchor window.
- **Universal Compatibility:** Mocks the native `Bar.qml` API, meaning default plugins like `omarchy.clock` and `omarchy.audio` render their themes perfectly.
- **Zero Configuration:** Automatically discovers and preloads all available bar-widgets on boot, maintaining their background services (like clocks and UPower monitors) without requiring a physical bar.

## Installation

1. Copy the `anchor.point` folder into your Omarchy user plugins directory:
   ```bash
   cp -r anchor.point ~/.config/omarchy/plugins/
   ```
2. Reload Quickshell / Omarchy for the shell to discover the new plugin:
   ```bash
   pkill quickshell
   ```

## Usage

You can toggle any bar widget using the custom IPC command provided by Anchor Point. 
Pass the `id` of the plugin you want to open.

**Syntax:**
```bash
omarchy-shell anchor.point toggle <plugin.id> "{}"
```

**Examples (Hyprland Keybinds):**
Add these to your `hyprland.conf` to trigger native widgets via keyboard shortcuts:

```hyprlang
# Open the default Omarchy Calendar
bind = SUPER, C, exec, omarchy-shell anchor.point toggle omarchy.clock "{}"

# Open the default Omarchy Audio Mixer
bind = SUPER, V, exec, omarchy-shell anchor.point toggle omarchy.audio "{}"

# Open a third-party bar widget (e.g., chaz.bar-autohide)
bind = SUPER, B, exec, omarchy-shell anchor.point toggle chaz.bar-autohide "{}"
```

### Notes on Compatibility
- **Panels/Menus vs Bar-Widgets:** Anchor Point is specifically designed to host `"bar-widget"` popups. If a plugin is registered purely as a `"panel"` (like `meviusisback.keybinds`) or a UI-less `"service"` (like `omarchy.battery`), you do not need Anchor Point to trigger them. You can trigger pure panels using the standard shell command: `omarchy-shell shell toggle <plugin.id>`.

## License
MIT
