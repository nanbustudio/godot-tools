const Iterator = preload('weakref_array_iterator.gd')
var _ = preload('../tools.gd').new()

var _refs

func _init(objects=[]):
  _refs = []
  extend(objects)

func iterator(from=0):
  return Iterator.new(self, from)

func extend(objects):
  for o in objects:
    append(o)
  return self

func append(object):
  _refs.append(_.as_ref(object))
  return self

func _pos_step(step):
  if step > 0:
    return step - 1
  else:
    return step

func _search_pos_and_clean(pos, step=1):
  step = _pos_step(step)
  var current_pos = pos
  while _refs.size() > 0 and not _.has_ref(_refs[current_pos]):
    _refs.remove(current_pos)
    current_pos += step
  return current_pos

func get(pos, unwrap=true, step=-1):
  var value = null
  if _refs.size() > 0:
    pos = _search_pos_and_clean(pos, step)
    if pos < _refs.size():
      if unwrap:
        value = _.ref_val(_refs[pos])
      else:
        value = _refs[pos]
    return value

func front():
  return get(0)

func back():
  return get(_refs.size()-1)

func find(what, from=0):
  var iterator = iterator(from)
  var item
  var pos = -1
  while iterator.has_next():
    item = iterator.next()
    if item == what:
      pos = iterator.get_pos()
      break
  return pos

func remove(pos):
  _refs.remove(_search_pos_and_clean(pos))

func erase(value):
  remove(find(value))

func pop_back():
  remove(_refs.size()-1)

func pop_front():
  remove(0)

func empty():
  return get(0) != null

func clear():
  var new_refs = []
  for r in _refs:
    if _.has_ref(r):
      new_refs.append(r)
  _refs = new_refs
  return self
