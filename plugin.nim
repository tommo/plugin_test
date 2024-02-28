import common

definePluginEntry:
  registerProc "plugin.hello":
    echo "hello, world"

  registerProc "plugin.valueError":
    raise newException(ValueError, "test exception")

