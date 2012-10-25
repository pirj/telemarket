var flashvars = { 
  rtmp_url: 'rtmp://192.168.1.34'
}

var current_uuid

function makeCall(number) {
  $("#flash")[0].makeCall(number, null, [])
  var who = $.ajax('/operator/call/who').done(function(data){
    $('#target-title').text(data.title)
    $('#target-contact-name').text(data.name)
    console.log(data.title)
  })
}

function hangup() {
  $("#flash")[0].hangup(current_uuid)
}

function onCallState(uuid, state) {
  current_uuid = uuid
  if(state == 'RINGING')
    $('#call_button').attr('rel', 'ringing').text('Вызов ...')
  else if(state == 'ACTIVE'){
    $('#call_button').attr('rel', 'talking').text('Разговор')
    $('.actions button').removeClass('hidden')
  } else if(state == 'HANGUP') {
    $('#call_button').attr('rel', 'hangup').text('Вызов')
    $('#transfer').addClass('hidden')
  }
}

function onDisconnected() {
  $('#call_button').addClass('disabled').removeClass('enabled').attr('rel', 'hangup').text("Инициализация ...")
  setTimeout(function() {
    $("#flash")[0].connect()
  }, 5000)
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
  else {
    $('#call_button').removeClass('disabled').addClass('enabled').attr('rel', 'hangup').text("Вызов")
  }
}

function callButton() {
  var state = $('#call_button').attr('rel')
  if(state == 'hangup')
    makeCall($('#session_id').val())
  else if(state == 'ringing' || state == 'talking')
    hangup()
}

$(document).ready(function() {
  swfobject.embedSWF("/freeswitch.swf", "flash", "250", "150", "9.0.0", "/expressInstall.swf", flashvars, {allowScriptAccess: 'always'}, [])
  
  if (swfobject.ua.ie) {
    $("#flash").css("top", "-500px") 
    $("#flash").css("left", "-500px")        
  } else {
    $("#flash").css("visibility", "hidden")
  }

  $('#call_button[rel=hangup]').live('click', function(){
    callButton()
  })

  Mousetrap.bind('ctrl+c', function() {
    callButton()
  })

  $('#call_button').tooltip()

  $('#transfer').live('click', function(){

  })

  $('#success').live('click', function(){

  })

  $('#not-interested').live('click', function(){

  })

  $('#wrong-number').live('click', function(){

  })
})
