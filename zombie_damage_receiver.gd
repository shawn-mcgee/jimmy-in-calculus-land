class_name ZombieDamageReceiver


static func can_receive_zombie_damage(a: Object) -> bool:
  return a and a.has_method("_receive_zombie_damage")

static func try_receive_zombie_damage(a: Object, from: Node2D, amount: float) -> bool:
  if can_receive_zombie_damage(a):
    a._receive_zombie_damage(from, amount)
    return true
  return false
