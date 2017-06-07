const Delay = preload('delay.gd')
const Callback = preload('callback.gd')
const Call = preload('call.gd')

# Callbacks

func callback(context, method, args=[]):
	return Callback.new(context, method, args)

# Delay

var tools

func callv_deferred(context, method, args=[]):
  return Call.callv_deferred(context, method, args)

func _init(tools):
  self.tools = tools

var delayed_calls = []

func set_process(value):
  tools.set_tag_process('execution', value)

func set_fixed_process(value):
  tools.set_tag_fixed_process('execution', value)

func register_delayed_call(delayed_call):
	delayed_call.set_start_time(OS.get_ticks_msec())
	delayed_calls.append(delayed_call)
	delayed_calls.sort_custom(self, 'sort_delays')
	set_process(true)

func sort_delays(a, b):
	return a.end_time < b.end_time

func process_delayed_calls():
	var now = OS.get_ticks_msec()
	while delayed_calls.size() > 0 and delayed_calls[0].timeout(now):
		delayed_calls[0].wake()
		delayed_calls.pop_front()
	if delayed_calls.size() == 0:
		set_process(false)

func _process(delta):
	process_delayed_calls()

func delay(context, method, args, seconds_to_wait=null):
	# delay(context, method[, args], seconds_to_wait)
	var delayed_call = Delay.new(context, method, args, seconds_to_wait)
	register_delayed_call(delayed_call)
	return delayed_call
