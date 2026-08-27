extends Control

const MAX_STAT := 100.0
const HUNGER_DECAY_PER_SECOND := 0.8
const HAPPINESS_DECAY_PER_SECOND := 0.55
const SAVE_PATH := "user://dino_save.json"

@onready var hunger_bar: ProgressBar = $Content/Stats/HungerRow/Bar
@onready var hunger_value: Label = $Content/Stats/HungerRow/Value
@onready var happiness_bar: ProgressBar = $Content/Stats/HappinessRow/Bar
@onready var happiness_value: Label = $Content/Stats/HappinessRow/Value
@onready var feed_button: Button = $Content/Buttons/Feed
@onready var play_button: Button = $Content/Buttons/Play
@onready var dino: DinoPet = $Content/PetArea/DinoPet

var hunger := MAX_STAT
var happiness := MAX_STAT
var save_timer := 0.0


func _ready() -> void:
	_apply_button_styles()
	_load_game()
	feed_button.pressed.connect(_on_feed_pressed)
	play_button.pressed.connect(_on_play_pressed)
	_update_ui()


func _process(delta: float) -> void:
	hunger = clampf(hunger - HUNGER_DECAY_PER_SECOND * delta, 0.0, MAX_STAT)
	happiness = clampf(happiness - HAPPINESS_DECAY_PER_SECOND * delta, 0.0, MAX_STAT)
	save_timer += delta
	if save_timer >= 5.0:
		save_timer = 0.0
		_save_game()
	_update_ui()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_game()


func _on_feed_pressed() -> void:
	hunger = clampf(hunger + 24.0, 0.0, MAX_STAT)
	happiness = clampf(happiness + 3.0, 0.0, MAX_STAT)
	dino.celebrate()
	_update_ui()


func _on_play_pressed() -> void:
	happiness = clampf(happiness + 22.0, 0.0, MAX_STAT)
	hunger = clampf(hunger - 4.0, 0.0, MAX_STAT)
	dino.celebrate()
	_update_ui()


func _update_ui() -> void:
	hunger_bar.value = hunger
	happiness_bar.value = happiness
	hunger_value.text = str(roundi(hunger))
	happiness_value.text = str(roundi(happiness))
	dino.set_mood(minf(hunger, happiness) / MAX_STAT)


func _apply_button_styles() -> void:
	_style_button(feed_button, Color("ef8c45"))
	_style_button(play_button, Color("4e9bd9"))
	_style_bar(hunger_bar, Color("ef8c45"))
	_style_bar(happiness_bar, Color("4e9bd9"))


func _style_button(button: Button, color: Color) -> void:
	for state in ["normal", "hover", "pressed"]:
		var box := StyleBoxFlat.new()
		box.bg_color = color.lightened(0.08) if state == "hover" else color.darkened(0.12) if state == "pressed" else color
		box.corner_radius_top_left = 24
		box.corner_radius_top_right = 24
		box.corner_radius_bottom_left = 24
		box.corner_radius_bottom_right = 24
		box.shadow_color = Color(0.1, 0.2, 0.15, 0.22)
		box.shadow_size = 8
		button.add_theme_stylebox_override(state, box)


func _style_bar(bar: ProgressBar, fill_color: Color) -> void:
	var background := StyleBoxFlat.new()
	background.bg_color = Color("d7dfcd")
	background.corner_radius_top_left = 18
	background.corner_radius_top_right = 18
	background.corner_radius_bottom_left = 18
	background.corner_radius_bottom_right = 18
	bar.add_theme_stylebox_override("background", background)
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.corner_radius_top_left = 18
	fill.corner_radius_top_right = 18
	fill.corner_radius_bottom_left = 18
	fill.corner_radius_bottom_right = 18
	bar.add_theme_stylebox_override("fill", fill)


func _save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"hunger": hunger, "happiness": happiness}))


func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		hunger = clampf(float(data.get("hunger", MAX_STAT)), 0.0, MAX_STAT)
		happiness = clampf(float(data.get("happiness", MAX_STAT)), 0.0, MAX_STAT)


