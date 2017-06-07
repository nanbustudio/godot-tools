var rs
var i

func _init(weakrefs, from=0):
  rs = weakrefs
  i  = from - 1

func current(unwrap=true):
  return rs.get(i, unwrap)

func next(unwrap=true):
  i += 1
  return current(unwrap)

func has_next():
  return not rs.empty() and rs.get(i+1) != null

func remove():
  rs.remove(i)

func get_pos():
  return i
