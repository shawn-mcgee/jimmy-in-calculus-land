extends CharacterBody2D

# derive from the original game which set walk_speed to 1.5 pixels per frame @ 60 frames per second
@export var walk_speed: float =  90  # pixels per second

# derive from the original game which set jump_speed to 15 pixels per frame @ 60 frames per second
@export var jump_speed: float = -900 # pixels per second

# derived from the original game which set knockback to   3 pixels per frame @ 60 frames per second
# derived from the original game which set knockback to -10 pixels per frame @ 60 frames per second
@export var knockback: float = -600

@onready var sprite = $AnimatedSprite2D
@onready var detect = $Detect

@onready var left       = $Left
@onready var down_left  = $DownLeft
@onready var down_right = $DownRight
@onready var right      = $Right

@onready var hurt = $Hurt


var maximum_health = 2
var current_health = 2
var facing: int = 1

var maximum_jumps = 1
var current_jumps = 0

func _ready() -> void:
  hurt.body_entered.connect(_on_hurt_entered)

func _on_hurt_entered(to: Node) -> void:
  if is_queued_for_deletion():
    return

  ZombieDamageReceiver.try_receive_zombie_damage(to, self, .5)

func _physics_process(delta: float) -> void:
  var nearest = get_nearest_jimmy()

  if nearest:
    if   nearest.position.x > position.x + 16:
      velocity.x =  walk_speed
    elif nearest.position.x < position.x - 16:
      velocity.x = -walk_speed
    else:
      velocity.x = 0
  else:
    velocity.x = 0

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

  if left .is_colliding() and left .get_collider() is TileMapLayer:
    jump()

  if right.is_colliding() and right.get_collider() is TileMapLayer:
    jump()

  if not down_left.is_colliding() and not down_right.is_colliding():
    jump()

  

  velocity.y += get_gravity().y * delta

  var c;

  # move and slide in the x axis
  c = move_and_collide(Vector2(velocity.x * delta, 0))
  if c:
    velocity.x = 0

  # move and slide in the y axis
  c = move_and_collide(Vector2(0, velocity.y * delta))
  if c:
    if velocity.y > 0:
      current_jumps = maximum_jumps
    velocity.y = 0


func jump() -> void:
  if current_jumps > 0:
    current_jumps -= 1
    velocity.y = jump_speed

func get_nearest_jimmy():
  var nearest: Jimmy = null

  for seeking in detect.get_overlapping_bodies():
    if seeking is Jimmy:
      if nearest == null or seeking.position.distance_to(position) < nearest.position.distance_to(position):
        nearest = seeking

  return nearest

func _receive_player_damage(amount: int) -> void:
  if is_queued_for_deletion():
    return

  current_jumps = 0
  velocity.y = knockback

  current_health -= amount
  if current_health <= 0:
    queue_free()
