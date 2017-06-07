var Arrays = preload('../classes/array.gd').new()

func callv_deferred(context, method, args=[]):
	context.call_deferred(method, Arrays.get(args, 0), Arrays.get(args, 1), Arrays.get(args, 2), Arrays.get(args, 3), Arrays.get(args, 4))
