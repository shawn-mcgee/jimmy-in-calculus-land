extends RigidBody2D

@onready var hurt = $Hurt

var maximum_lifetime: float = 3
var minimum_lifetime: float = 0
var current_lifetime: float = maximum_lifetime

@onready var sprite = $Sprite2D
@onready var shape  = $CollisionShape2D

func _ready() -> void:
  hurt.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
  current_lifetime -= delta

  var lifetime = max(0, current_lifetime / maximum_lifetime)
  sprite.scale = Vector2(lifetime, lifetime)
  shape .scale = Vector2(lifetime, lifetime)

  if current_lifetime <= minimum_lifetime:
    queue_free()

func _on_body_entered(body: Node) -> void:
  if current_lifetime <= minimum_lifetime or is_queued_for_deletion():
    return
    
  if PlayerDamageReceiver.try_receive_player_damage(body, 1):
    queue_free()