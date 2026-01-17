class_name ExtraJumpReceiver

static func can_receive_extra_jump(a: Object) -> bool:
  return a and a.has_method("_receive_extra_jump")

static func try_receive_extra_jump(a: Object) -> bool:
  if can_receive_extra_jump(a):
    a._receive_extra_jump()
    return true
  return false