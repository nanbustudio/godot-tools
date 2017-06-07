extends Node

const WeakRefArray = preload('classes/weakref_array.gd')
const BasicLogger = preload('logging/basic_logger.gd')
const NullLogger = preload('logging/null_logger.gd')
const Execution   = preload('execution/main.gd')
const TagProcess  = preload('execution/tag_process.gd')
var Arrays = preload('classes/array.gd').new()

var internal_name

var LoggerClass = BasicLogger
var logger
var loggers = {}
var execution

var life_cycle_objects = []


var process_lock
var fixed_process_lock

func _init(internal_name = '_'):
	process_lock = TagProcess.new(self, 'process')
	fixed_process_lock = TagProcess.new(self)

	logger = LoggerClass.new()
	internal_name = internal_name
	execution = Execution.new(self)
	life_cycle_objects.append(execution)

func _process(delta):
	for o in life_cycle_objects:
		if o.has_method('_process'):
			o.call('_process', delta)

func _fixed_process(delta):
	for o in life_cycle_objects:
		if o.has_method('_fixed_process'):
			o.call('_fixed_process', delta)

func set_tag_fixed_process(tag, value):
	fixed_process_lock.set_tag(tag, value)

func set_tag_process(tag, value):
	process_lock.set_tag(tag, value)



# Execution
func ticks():
	return OS.get_ticks_msec()

func delay(context, method, args, seconds_to_wait=null):
	return execution.delay(context, method, args, seconds_to_wait)

func callback(context, method, args):
	return execution.callback(context, method, args)


# Tree

func insert_child(parent, node, position=null):
	parent.add_child(node)
	if position != null:
		parent.move_child(node, 0)

# filte

func file_exists(path):
	return File.new().file_exists(path)

# Logging

func logger(tag=null, active=true):
	if not loggers.has(tag):
		if active:
			loggers[tag] = LoggerClass.new(tag)
		else:
			loggers[tag] = NullLogger.new(tag)
	return loggers[tag]


func debug(arg0, arg1=null, arg2=null, arg3=null, arg4=null, arg5=null, arg6=null, arg7=null, arg8=null, arg9=null):
	logger.debug(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)


# Randomness

var _seed = null

func rand():
	if _seed == null:
		_seed = OS.get_ticks_msec()
		seed(_seed)
	return randf()


func call_with_args(context, method_name, args=[]):
	var a = args
	a.resize(10)
	return context.call(method_name, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9])

func meta(object, meta_name, value=null, default=null):
	if value != null:
		set_meta(meta_name, value)
	else:
		if has_meta(meta_name):
			return get_meta(meta_name)
		else:
			return default

func get_name():
	return 'Tools'
# Type Utils

func is_value_type(v, value_type):
	return typeof(v) == value_type

func is_int(v):
	return is_value_type(v, TYPE_INT)

func is_float(v):
	return is_value_type(v, TYPE_REAL)

func is_number(v):
	return is_int(v) or is_float(v)

func is_string(v):
	return is_value_type(v, TYPE_STRING)

func is_object(v):
	return is_value_type(v, TYPE_OBJECT)

func bool_to_int(v):
	return ifelse(v, 1, 0)

# File Utils

func save_json(path, data):
	# Open a file
	var file = File.new()
	if file.open(path, File.WRITE) != 0:
    	print("Error opening file '", path, "'")
    	return
	file.store_string(data.to_json())
	file.close()

func load_json(path):
	var file = File.new()
	if not file.file_exists(path):
	    print("File '", path, "' does not exist!")
	    return
	# Open existing file
	if file.open(path, File.READ) != 0:
	    print("Error opening file '", path, "'")
	    return
	# Parse
	var data = {}
	var text = file.get_as_text()
	data.parse_json(text)
	return data

# Editor Utils

func editor_mode(node):
	return node.get_tree() != null and node.get_tree().is_editor_hint()

# Scene Utils

func main_scene(node):
	return node.get_parent() == node.get_node('/root')

# Functions

func recursive(context, method_name, arguments=[], target=null, method_should_add_children_name=null):
	if target == null:
		target = context
	var children = [target]
	var current = target
	#print('Rec [', context.get_name(), '@', method_name, '] : children : ', children)
	while children.size() > 0:
		#print('Rec [', context.get_name(), '@', method_name, '] : children : ', children)
		#print('Rec [', context.get_name(), '@', method_name, '] -> ', current.get_name())
		context.callv(method_name, [current] + arguments)
		var add_children = true
		if method_should_add_children_name != null:
			add_children = add_children and context.callv(method_should_add_children_name, [current])
		if add_children:
			children = children + current.get_children()
		current = children.front()
		children.pop_front()

# Node Utils

func each_children(node, method_name, args=[]):
	for c in node.get_children():
		c.callv(method_name, args)

func hide_children(node):
	each_children(node, 'hide')

func free_children(node, queue=true):
	if queue:
		each_children(node, 'queue_free')
	else:
		each_children(node, 'free')

func remove_children2(node, remove_internal=false):
	for c in node.get_children():
		if c.get_name() == internal_name:
			if remove_internal:
				node.remove_child(c)
		else:
			node.remove_child(c)

func get_children(node):
	var children = []
	for c in node.get_children():
		if c.get_name() != internal_name:
			children.append(c)
	return children

# Reference Utils

func as_ref(v):
	if is_ref(v):
		return v
	else:
		return weakref(v)

func is_ref(v):
	return typeof(v) == TYPE_OBJECT and v.has_method('get_ref')

func has_ref(v):
	return ref(v) != null

func ref_val(v):
	if v != null:
		return v.get_ref()
	else:
		return null

func ref(v):
	return ref_val(v)

func refs(objects=[]):
	return WeakRefArray.new(objects)

# Array Utils

func as_array(v):
	return ifelse(typeof(v) == TYPE_ARRAY, v, [v])


# Dictionary

func extend(target, source1=null, source2=null, source3=null):
	for source in [source1, source2, source3]:
		if source != null:
			for key in source.keys():
				if source[key] != null or not target.has(key):
					target[key] = source[key]
	return target

func dict_get(dict, key, else_value=null):
	if dict.has(key):
		return dict[key]
	else:
		return else_value

func to_dict(object):
	var dict = {}
	for prop in object.get_property_list():
		dict[prop.name] = object.get(prop.name)
	
	print(object.get_property_list())
	return dict
		
	
# Number Utils

func randi_in_range(_min, _max=null):
	if _max == null:
		_max = _min
		_min = 0
	return int(randf() * (_max - _min) + _min)

# Array Utils

func array_get(array, index, else_value=null):
	return Arrays.get(array, index, else_value)

func random_element_id(array):
	return randi_in_range(array.size())

func random_element(array):
	return array[random_element_id(array)]

# Values in general

func ifelse(b, v1, v2=null):
	if b:
		return v1
	else:
		return v2

func value(value, else_value):
	return ifelse(value != null, value, else_value)

# Bits


func bitmask(value, start=null, count=0):
	# bitmask([value,] start [, count])
	if start == null:
		start = value
		value = true


	var mask = 0
	var exclude = 0
	var include = 0
	var end = start + count
	if count == 0:
		include =  1 << start
	elif count > 0:
		exclude = int(pow(2, start) - 1)
		include = int(pow(2, end + 1 ) - 1)
	elif count < 0:
		exclude = int(pow(2, max(end, 0)) - 1)
		include = int(pow(2, max(start, 0) + 1 ) - 1)

	if value:
		mask = include ^ exclude
	else:
		mask = ~ (include ^ exclude)

	return mask
