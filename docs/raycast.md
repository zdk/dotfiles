Raycast scripts
===============

Paths inside the linked trees mirror `$HOME`, so `home/.gitconfig` becomes
`~/.gitconfig` and `darwin/.config/raycast/scripts` becomes
`~/.config/raycast/scripts`.

Raycast only reads folders registered in its settings, and has no CLI to
register one. Do this once per machine:

1. Open Raycast Settings → Extensions → Script Commands.
2. Click **+** and pick `darwin/.config/raycast/scripts`.

Keep scripts directly in that folder. Raycast does not scan subfolders.
After adding a script, run **Reload Script Commands**.
