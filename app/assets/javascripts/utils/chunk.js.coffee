module.exports = (array, size) ->
  a = array.slice()
  r = []
  while a.length
    r.push a.splice(0, size)
  r
