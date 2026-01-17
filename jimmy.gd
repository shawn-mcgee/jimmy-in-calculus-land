class_name Jimmy
extends CharacterBody2D

# derived from the original game which set walk_speed to 4 pixels per frame @ 60 frames per second
@export var walk_speed: float =  240; # pixels per second

# derived from the original game which set jump_speed to 15 pixels per frame @ 60 frames per second
@export var jump_speed: float = -900; # pixels per second

# derived from the original game which set throw_speed to 20 pixels per frame @ 60 frames per second
@export var throw_speed: float = 1200; # pixels per second

# derived from the original game which set throw_angle_degrees to -30 and -150 degrees
@export var throw_angle_degrees: float = 60; # degrees

@export var Apple: PackedScene


@onready var sprite = $AnimatedSprite2D
@onready var health = $Health
@onready var jumps  = $Jumps

var facing: int = 1 # 1 = right, -1 = left

var falling_damage_tick = 0
var      knockback_tick = 0

func _process(delta: float) -> void:
  if falling_damage_tick > 0:
    falling_damage_tick -= delta

  if knockback_tick > 0:
    knockback_tick -= delta

  
  if velocity.y >= 6000 and falling_damage_tick <= 0:
    health.current_health -= .5
    falling_damage_tick    = .167
    if health.current_health <= 0:
      World.load_this_level()

func _physics_process(delta: float) -> void:
  var dx = Input.get_axis(
    "move_left",
    "move_right"
  )

  if knockback_tick <= 0:
    velocity.x  = dx * walk_speed
  velocity.y += get_gravity().y * delta

  if velocity.x != 0:
    facing = sign(velocity.x)
    if facing < 0:
      sprite.animation = "walk_left"
    else:
      sprite.animation = "walk_right"
  else:
    if facing < 0:
      sprite.animation = "idle_left"
    else:
      sprite.animation = "idle_right"
  

  if Input.is_action_just_pressed("jump") and jumps.current_jumps > 0:
    jumps.current_jumps -= 1
    velocity.y = jump_speed

  if Input.is_action_just_pressed("throw"):
    throw_apple()

  var c;

  # move and slide in the x axis
  c = move_and_collide(Vector2(velocity.x * delta, 0))
  if c:
    velocity.x = 0

  # move and slide in the y axis
  c = move_and_collide(Vector2(0, velocity.y * delta))
  if c:
    if velocity.y > 0:
      jumps.current_jumps = jumps.maximum_jumps

    velocity.y = 0




func throw_apple() -> void:
  var apple = Apple.instantiate()
  apple.position = position
  if facing < 0:
    var throw_angle = (-90 - throw_angle_degrees) * PI / 180
    apple.linear_velocity = velocity + Vector2(
      cos(throw_angle) * throw_speed, 
      sin(throw_angle) * throw_speed
    )
  else:
    var throw_angle = (-90 + throw_angle_degrees) * PI / 180
    apple.linear_velocity = velocity + Vector2(
      cos(throw_angle) * throw_speed, 
      sin(throw_angle) * throw_speed
    )
  get_parent().add_child(apple)

func _receive_extra_heart() -> void:
  health.maximum_health += 1
  health.current_health += 1

func _receive_extra_jump() -> void:
  jumps.maximum_jumps += 1
  jumps.current_jumps += 1

func _receive_zombie_damage(from: Node2D, amount: float) -> void:
  if knockback_tick > 0:
    return

  health.current_health -= amount
  if health.current_health <= 0:
    World.load_this_level()
  knockback_tick = .167

  if from.position.x < position.x:
    velocity.x =  180
  else:
    velocity.x = -180

  velocity.y = -600