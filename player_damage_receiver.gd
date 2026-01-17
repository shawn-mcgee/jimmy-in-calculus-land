class_name PlayerDamageReceiver

static func can_receive_player_damage(a: Object             ) -> bool:
  return a and a.has_method("_receive_player_damage")

static func try_receive_player_damage(a: Object, amount: int) -> bool:
  if can_receive_player_damage(a):
    a._receive_player_damage(amount)
    return true
  return false
