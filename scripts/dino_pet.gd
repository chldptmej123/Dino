class_name DinoPet
extends TextureRect

var mood: float = 1.0
var _home_position := Vector2.ZERO
var _bounce_time := 0.0
var _bounce_strength := 0.0


func _ready() -> void:
	_home_position = position
	pivot_offset = size * 0.5


func _process(delta: float) -> void:
	_bounce_time += delta
	_bounce_strength = move_toward(_bounce_strength, 0.0, delta * 1.8)
	position = _home_position + Vector2(0.0, -absf(sin(_bounce_time * 8.0)) * 34.0 * _bounce_strength)
	rotation = sin(_bounce_time * 10.0) * 0.035 * _bounce_strength
	var pulse := 1.0 + sin(_bounce_time * 8.0) * 0.025 * _bounce_strength
	scale = Vector2.ONE * pulse


func celebrate() -> void:
	_bounce_strength = 1.0
	_bounce_time = 0.0


func set_mood(value: float) -> void:
	mood = clampf(value, 0.0, 1.0)
	modulate = Color.WHITE.lerp(Color(0.72, 0.76, 0.78), (1.0 - mood) * 0.38)

