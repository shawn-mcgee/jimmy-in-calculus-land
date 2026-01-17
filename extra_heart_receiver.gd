class_name ExtraHeartReceiver

static func can_receive_extra_heart(a: Object) -> bool:
  return a and a.has_method("_receive_extra_heart")

static func try_receive_extra_heart(a: Object) -> bool:
  if can_receive_extra_heart(a):
    a._receive_extra_heart()
    return true
  return false