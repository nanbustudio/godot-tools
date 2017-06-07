var Call = preload('./call.gd').new()

var context
var method
var args


func _init(context, method, args=[]):
  self.context = context
  self.method = method
  self.args = args


func call():
  return context.callv(method, args)


func call_deferred():
  Call.callv_deferred(context, method, args)
