const LEVEL_DEBUG = 'debug'
const LEVEL_WARN  = 'warn'

var tag

func _init(tag=null):
  self.tag = tag

func put(level, arg0, arg1=null, arg2=null, arg3=null, arg4=null, arg5=null, arg6=null, arg7=null, arg8=null, arg9=null):
	breakpoint

func debug(arg0, arg1=null, arg2=null, arg3=null, arg4=null, arg5=null, arg6=null, arg7=null, arg8=null, arg9=null):
  put(LEVEL_DEBUG, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)

func warn(arg0, arg1=null, arg2=null, arg3=null, arg4=null, arg5=null, arg6=null, arg7=null, arg8=null, arg9=null):
	put(LEVEL_WARN, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)