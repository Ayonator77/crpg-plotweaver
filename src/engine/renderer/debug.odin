package renderer

import "base:runtime"
import"core:log"
import gl "vendor:OpenGL"

//Ask driver to report problems through gl_debug_callback
//only works if platform created the context with the debug flag 

enable_debug_output :: proc(state: ^State){
  flags: i32
  gl.GetIntegerv(gl.CONTEXT_FLAGS, &flags)
  if u32(flags) & gl.CONTEXT_FLAG_DEBUG_BIT == 0 {
    log.warn("GL context has no debug flag; GL debug output is off")
    return
  }

  //the calllback is a "c" proc, no odin context
  state.debug_context = context
  gl.Enable(gl.DEBUG_OUTPUT)
  gl.Enable(gl.DEBUG_OUTPUT_SYNCHRONOUS)
  gl.DebugMessageCallback(gl_debug_callback, &state.debug_context)
  log.info("GL debug output enabled")
}

gl_debug_callback :: proc "c" (source, type, id, severity: u32, length: i32, message: cstring, user_param: rawptr){
  context = (cast(^runtime.Context)user_param)^

  switch severity{
    case gl.DEBUG_SEVERITY_HIGH:
      log.errorf("GL [id %d]: %s", id, message)
    
    case gl.DEBUG_SEVERITY_MEDIUM, gl.DEBUG_SEVERITY_LOW:
      log.warnf("GL [id %d]: %s", id, message)

    case:
      //chatty driver info, ignore
  }

  
}
