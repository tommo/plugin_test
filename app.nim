import common

definePluginEntry:
  echo ">>>call plugin.hello from APP:"
  callProc "plugin.hello"

  echo ">>>call plugin.valueError from APP:"
  try:
    callProc "plugin.valueError"
  except ValueError as e:
    echo e.msg