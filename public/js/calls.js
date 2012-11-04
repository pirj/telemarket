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
  Mousetrap.bind('c', call_number, 'keyup')

  $('#hangup').live('click', hangup)
  Mousetrap.bind('h', hangup, 'keyup')

  $('#transfer').live('click', transfer)
  Mousetrap.bind('t', transfer, 'keyup')

  $('#success').live('click', success)
  Mousetrap.bind('s a', success, 'keyup')

  $('#not-interested').live('click', not_interested)
  Mousetrap.bind('s u', not_interested, 'keyup')

  $('#wrong-number').live('click', wrong_number)
  Mousetrap.bind('s j', wrong_number, 'keyup')

  $('#has-been-disconnected').live('click', has_been_disconnected)
  Mousetrap.bind('s m', has_been_disconnected, 'keyup')

  $('#add-new-contact').live('click', new_contact)
  Mousetrap.bind('s x', new_contact, 'keyup')
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
  if(check_filled() && state == 'talking'){
    $.post('/operator/call/transfer')
    connected()
  }
}

function success() {
  if(check_filled() && state == 'filling') {
    $.post('/operator/call/success', {result: $('#result').text()})
    connected()
  }
}

function not_interested() {
  if(check_filled() && state == 'filling') {
   $.post('/operator/call/success', {result: $('#result').text()})
    connected()
  }
}

function wrong_number() {
  if(check_filled() && state == 'filling') {
    $.post('/operator/call/wrongnumber', {result: $('#result').text()})
    connected()
  }
}

function has_been_disconnected() {
  if(check_filled() && state == 'filling') {
    $.post('/operator/call/disconnected')
    connected()
  }
}

function new_contact() {
  if(check_filled() && state == 'filling') {
    $.post('/operator/call/newcontact', {name: $('#name').val(), name: $('#phone').val(), name: $('#email').val()})
    connected()
  }
}

// Checks
function check_filled() {
  return $('#result').text() != ''
}

function check_contact_filled() {
  return $('#name').val() != '' && $('#phone').val() != ''
}

// States
function disconnected() {
  state = 'disconnected'
  $('#company').hide()
  $('#result-div').hide()
  $('#state').text('Инициализация').addClass('active')
  $('#call, #hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').hide()
}

function connected() {
  state = 'connected'
  $('#company').hide()
  $('#result-div').hide().removeClass('hidden')
  $('#state').text('Готово к вызовам').removeClass('active')
  $('#call').show()
  $('#hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').hide()
  $('#call, #hangup, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').removeClass('hidden')
}

function ringing() {
  state = 'ringing'
  $('#state').text('Идёт вызов').addClass('active')
  $('#hangup').show()
  $('#call, #transfer, #success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').hide()
}

function talking() {
  var who = $.ajax('/operator/call/who').done(function(data){
    $('#target-title').text(data.title)
    $('#target-contact-name').text(data.name)
    $('#company').removeClass('hidden').show()
  })

  state = 'talking'
  $('#result').text('')
  $('#result-div').show()
  $('#result').focus()
  $('#state').text('Разговор').addClass('active')
  $('#hangup, #transfer').show()
  $('#call, #success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').hide()
}

function filling() {
  state = 'filling'
  $('#result').focus()
  $('#state').text('Заполнение отчёта').removeClass('active')
  $('#success, #not-interested, #wrong-number, #has-been-disconnected, #new-contact').show()
  $('#call, #hangup, #transfer').hide()
}

function hangedup() {
  if(state == 'ringing')
    connected()
  else if(state == 'talking')
    filling()
}
