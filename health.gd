@tool
extends Node2D

@export var heart_full : Texture
@export var heart_half : Texture
@export var heart_empty: Texture

@export var maximum_health: float = 3:
  set(value):
    maximum_health = max(value, 0)
    queue_redraw()
  
@export var current_health: float = 3:
  set(value):
    current_health = clamp(value, 0, maximum_health)
    queue_redraw()

func _draw() -> void:
  var hearts_width = ceil(maximum_health) * 32

  for i in range(ceil(maximum_health)):
    if i + 1 <= current_health:
      draw_texture(heart_full , Vector2(i * 32 - hearts_width / 2, -16))
    elif i + .5 <= current_health:
      draw_texture(heart_half , Vector2(i * 32 - hearts_width / 2, -16))
    else:
      draw_texture(heart_empty, Vector2(i * 32 - hearts_width / 2, -16))
