func get(array, index, else_value=null):
	if index < array.size():
		return array[index]
	else:
		return else_value
