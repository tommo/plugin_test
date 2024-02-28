import std/[os, strutils, dynlib, tables]

type
  SimpleCall* = proc() {.nimcall.}
  
  PluginMgrObj* = object
    procs:Table[string, pointer]

  PluginMgr* = ptr PluginMgrObj


var pluginMgr:PluginMgr
#----------------------------------------------------------------
proc callProc*(name:string) =
  let p = pluginMgr.procs.getOrDefault(name, nil)
  if p != nil:
    cast[SimpleCall](p)()
  else:
    discard

#----------------------------------------------------------------
when defined(IsPlugin):
  template definePluginEntry*(userBody:untyped) =
    proc registerProcImpl(name:static string, p:SimpleCall) =
      pluginMgr.procs[name] = p

    template registerProc(name:static string, procBody:untyped) {.inject.} =
      proc pluginProc() {.gensym.} =
        procBody
      registerProcImpl(name, pluginProc)

    proc pluginEntry( mgr:PluginMgr) {.cdecl, exportc, dynlib.} =
      pluginMgr = mgr
      userBody

#----------------------------------------------------------------
when defined(IsHost):
  pluginMgr = createShared(PluginMgrObj)

  proc loadPlugin*(name:string) =
    let libname = DynlibFormat % name
    let lib = loadLib( libname )
    let entryProc  = cast[proc(pluginMgr:PluginMgr) {.cdecl.}](lib.symAddr("pluginEntry"))
    entryProc(pluginMgr)
