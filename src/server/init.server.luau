-- Rojo mounts the server source tree under this bootstrap Script, so runtime modules are children of `script`.
local ArcadeRuntime = require(script:WaitForChild("ArcadeRuntime"))

ArcadeRuntime.start()
