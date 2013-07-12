socket = io.connect 'http://10.20.82.179:9011'
mousePos = undefined
previousMousePos = undefined

#get the ID or undefined
id = monster.get "tracking-session"

# on mousemove -> update the data
window.onmousemove = (event) ->
  event = event || window.event; # IE-ism
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]

  mousePos = {
    id: id,
    ms: event.timeStamp,
    type: 'mouseMovement',
    url: document.URL,
    x: event.layerX,
    y: event.layerY,
    windowX: w.innerWidth || e.clientWidth || g.clientWidth,
    windowY: w.innerHeight|| e.clientHeight|| g.clientHeight
  }

window.onclick = (event) ->
  event = event || window.event; # IE-ism
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]

  mouseClickPos = {
    id: id,
    ms: event.timeStamp,
    type: 'mouseClick',
    url: document.URL,
    x: event.layerX,
    y: event.layerY,
    windowX: w.innerWidth || e.clientWidth || g.clientWidth,
    windowY: w.innerHeight|| e.clientHeight|| g.clientHeight
  }

  #send click event to the server
  socket.emit 'mouseEvent', mouseClickPos


# Send the data to the server
sendMousePosition = () ->
  pos = mousePos
  if previousMousePos and previousMousePos.ms isnt pos.ms
    socket.emit 'mouseEvent', pos
  previousMousePos = pos



# ask for new ID if needed
if id is null
  now = new Date
  str = now.getTime() + '' + now.getUTCMilliseconds()
  socket.emit 'getId',str
  # On new ID, start sending data
  socket.on 'newId', (newId) =>
    id = newId
    monster.set "tracking-session", newId
    setInterval sendMousePosition, 100
else
  # If we have an ID, start data
  setInterval sendMousePosition, 100
