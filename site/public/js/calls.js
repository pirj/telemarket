var flashvars = { 
  rtmp_url: 'rtmp://192.168.1.34'
}

var current_uuid
var state = 'disconnected'

// RTMP events
function onCallState(uuid, state) {
  current_uuid = uuid
  if(state == 'RINGING')
    ringing()
  else if(state == 'ACTIVE')
    talking()
  else if(state == 'HANGUP')
    hangedup()
}

function onDisconnected() {
  disconnected()

  // Reconnect
  setTimeout(function() {
    $("#flash")[0].connect()
  }, 3000)
}

function onDebug(message) {
}

function checkMic() {
  try {
    return !$("#flash")[0].isMuted()
  } catch(err) {
    return false
  }
}

function onConnected(sessionid) {
  if (!checkMic())
    $('#flash')[0].showPrivacy()
  else
    connected()
}

$(document).ready(function() {
  swfobject.embedSWF("/freeswitch.swf", "flash", "250", "150", "9.0.0", "/expressInstall.swf", flashvars, {allowScriptAccess: 'always'}, [])

  $('button, #result').tooltip()

  Mousetrap.bind('f r', function(){
    $('#result').focus()
  }, 'keyup')

  Mousetrap.bind('esc', function(){
    $('#result').blur()
  })

  $('#call').live('click', call_number)
  Mousetrap.bind('c', call_number)

  $('#hangup').live('click', hangup)
  Mousetrap.bind('h', hangup)

  $('#transfer').live('click', transfer)
  Mousetrap.bind('t', transfer)

  $('#success').live('click', success)
  Mousetrap.bind('z s', success)

  $('#not-interested').live('click', not_interested)
  Mousetrap.bind('z n', not_interested)

  $('#wrong-number').live('click', wrong_number)
  Mousetrap.bind('z w', wrong_number)

  $('#has-been-disconnected').live('click', has_been_disconnected)
  Mousetrap.bind('z d', has_been_disconnected)
})

// Actions
function call_number() {
  if(state == 'connected')
    $("#flash")[0].makeCall("session-"+$('#session_id').val(), null, [])
}

function hangup() {
  if(state == 'ringing' || state == 'talking') {
    $("#flash")[0].hangup(current_uuid)
    hangedup()    
  }
}

function transfer() {
  if(state == 'talking'){
    $.post('/operator/call/transfer')
    connected()
  }
}

function success() {
  if(state == 'filling')
    connected()
}

function not_interested() {
  if(state == 'filling')
    connected()
}

function wrong_number() {
  if(state == 'filling')
    connected()  
}

function has_been_disconnected() {
  if(state == 'filling')
    connected()
}

// States
function disconnected() {
  state = 'disconnected'
  $('#state').text('Инициализация').addClass('active')
  $('#call, #hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected').hide()
}

function connected() {
  state = 'connected'
  $('#state').text('Готово к вызовам').removeClass('active')
  $('#call').show()
  $('#hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected').hide()
  $('#call, #hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected').removeClass('hidden')
}

function ringing() {
  state = 'ringing'
  $('#state').text('Идёт вызов').addClass('active')
  $('#hangup').show()
  $('#call, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected').hide()
}

function talking() {
  var who = $.ajax('/operator/call/who').done(function(data){
    $('#target-title').text(data.title)
    $('#target-contact-name').text(data.name)
  })

  state = 'talking'
  $('#state').text('Разговор').addClass('active')
  $('#hangup, #transfer').show()
  $('#call, #success, #not-interested, #wrong-number, #has-been-disconnected').hide()
}

function filling() {
  state = 'filling'
  $('#state').text('Заполнение отчёта').removeClass('active')
  $('#success, #not-interested, #wrong-number, #has-been-disconnected').show()
  $('#call, #hangup, #transfer').hide()
}

function hangedup() {
  if(state == 'ringing')
    connected()
  else if(state == 'talking')
    filling()
}
