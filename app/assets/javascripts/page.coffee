# to make functions global
root = exports ? this

root.urlParam = (name) ->
  results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if results == null
    return null
  else
    return results[1] || 0
