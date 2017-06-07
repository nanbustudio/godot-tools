var _node
var _locks = {}
var _mode

func _init(node, mode='fixed_process'):
	_node = node
	_mode = mode

func add(tag):
	_locks[tag] = true
	update()

func remove(tag):
	_locks.erase(tag)
	update()

func set_tag(tag, value):
	if value:
		add(tag)
	else:
		remove(tag)

func update():
	_node.call('set_' + _mode, _locks.size() > 0)
