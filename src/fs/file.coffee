exports.exists = (file) ->
   # TODO: Implement me
   console.log "exists called on", file
   return true

exports.open = (file) ->
   # TODO: Implement me
   handle = Math.floor(Math.random() * 1000) + 1
   console.log "open called on", file, "with handle: ", handle
   return handle

exports.read = (handle, bytes) ->
   # TODO: Implement me
   value = Math.floor(Math.random() * Math.pow(8, bytes))
   console.log "read called on", file, "with handle: ", handle, "returned:", value
   return value
