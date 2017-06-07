extends 'abstract_logger.gd'

func _wrap(s=null):
  if s:
    return '[' + str(s) + ']'
  else:
    return ''

func put(level, arg0, arg1=null, arg2=null, arg3=null, arg4=null, arg5=null, arg6=null, arg7=null, arg8=null, arg9=null):
  var parts = [_wrap(level), _wrap(tag), arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]
  var out = ''
  for p in parts:
    p = str(p)
    if p != '' and p != null:
      out += p + ' '
  print(out)