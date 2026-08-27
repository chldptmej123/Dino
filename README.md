# Dino Days

A small portrait mobile virtual-pet prototype made with Godot 4.7.

## Run

Open this folder in Godot and press **F6** or the Play button. The main scene is already configured.

## Controls

- **Feed** restores Hunger by 24 and Happiness by 3.
- **Play** restores Happiness by 22 and costs 4 Hunger.
- Both stats gradually decrease and remain between 0 and 100.
- Progress is saved automatically to `user://dino_save.json`.

The pet artwork is stored at `assets/dino_pet.png`, while its animation is isolated in `scripts/dino_pet.gd`. It can later be replaced by an animated scene without changing the game-state logic.

