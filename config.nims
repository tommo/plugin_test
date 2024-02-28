import os
import strutils
import strformat

task test, "test":
  block:
    let libname = DynlibFormat % "plugin"
    exec &"nim cpp -d:IsPlugin --app:lib -o:{libname} plugin"
  block:
    let libname = DynlibFormat % "app"
    exec &"nim cpp -d:IsPlugin --app:lib -o:{libname} app"
    
  exec "nim cpp -r -d:IsHost host"