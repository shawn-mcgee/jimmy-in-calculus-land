class_name World
extends Node2D

static var __default__: World

@export var playlist: Array[PackedScene]

var current_level: int = -1

func _ready():
  __default__ = self
  World.load_next_level()


static func load_this_level() -> void:
  var level = __default__.playlist[__default__.current_level].instantiate()

  for child in __default__.get_children():
    if child is Level:
      child.queue_free()

  __default__.add_child(level)


static func load_next_level() -> void:
  __default__.current_level += 1

  if __default__.current_level >= __default__.playlist.size():
    __default__.current_level = 0

  var level = __default__.playlist[__default__.current_level].instantiate()

  for child in __default__.get_children():
    if child is Level:
      child.queue_free()

  __default__.add_child(level)

  
    