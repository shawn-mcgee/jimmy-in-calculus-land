@tool
extends Node2D

@export var jump_full : Texture
@export var jump_empty: Texture

@export var maximum_jumps: int = 1:
  set(value):
    maximum_jumps = max(value, 0)
    queue_redraw()
  
@export var current_jumps: int = 1:
  set(value):
    current_jumps = clamp(value, 0, maximum_jumps)
    queue_redraw()

func _draw() -> void:
  var jumps_width = ceil(maximum_jumps) * 16

  for i in range(ceil(maximum_jumps)):
    if i + 1 <= current_jumps:
      draw_texture(jump_full , Vector2(i * 16 - jumps_width / 2, -8))
    else:
      draw_texture(jump_empty, Vector2(i * 16 - jumps_width / 2, -8))
