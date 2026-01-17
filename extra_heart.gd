extends Area2D

func _ready() -> void:
  body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
  if is_queued_for_deletion():
    return
    
  if ExtraHeartReceiver.try_receive_extra_heart(body):
    queue_free()
