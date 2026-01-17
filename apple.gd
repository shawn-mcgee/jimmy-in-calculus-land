extends RigidBody2D

@onready var hurt = $Hurt

func _ready() -> void:
  hurt.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
  if is_queued_for_deletion():
    return
    
  if PlayerDamageReceiver.try_receive_player_damage(body, 1):
    queue_free()