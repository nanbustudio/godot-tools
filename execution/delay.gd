extends 'callback.gd'

var tools
var seconds_to_wait
var cancelled
var finished
var start_time
var end_time


func _init(context, method, args, seconds_to_wait=null).(context, method, []):
	if seconds_to_wait == null:
		self.seconds_to_wait = args
	else:
		self.args = args
		self.seconds_to_wait = seconds_to_wait
	self.cancelled = false
	self.finished  = false
	self.start_time = null
	self.end_time   = null


func set_start_time(value):
	start_time = value
	end_time = start_time + seconds_to_wait * 1000


func cancel():
	cancelled = true
	finished  = true


func timeout(now):
	return end_time <= now


func wake():
	if not cancelled:
		finished = true
		call()
