socket = io.connect 'http://127.0.0.1:9011'
mousePos = undefined
previousMousePos = undefined
id = monster.get "tracking-session"
pageId = ''

# on mousemove -> update the data
window.onmousemove = (event) ->
  event = event || window.event; # IE-ism
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]

  mousePos = {
    id: id,
    pageId: pageId,
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
    pageId: pageId,
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

# retrieve socketID
socket.emit 'getId'
socket.on 'newId', (newId) =>
  pageId = newId

  if id is null
    monster.set "tracking-session", newId
    id = newId;

  # On new ID, start sending data
  setInterval sendMousePosition, 100
