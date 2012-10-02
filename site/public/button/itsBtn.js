	var flashvars = { 
		rtmp_url: 'rtmp://192.168.1.34/phone'
	};
	
	var params  = {
		allowScriptAccess: 'always'
	};
	
	function makeCall(number, account, options) {
		$("#flash")[0].makeCall(number, account, options);
	}
	
	function sendDTMF(digit, duration) {
		$("#flash")[0].sendDTMF(digit, duration);
	}
	
	function onDisplayUpdate(uuid, name, number) {
		var elm = $("#call_" + uuid);
		elm.children(".callerid_name").text(name);
		elm.children(".callerid_number").text(number);
		elm.data("name", name);
		elm.data("number", number);
		
		if (uuid == $("#incoming_call").data("uuid")) {
			$("#incoming_name").text(name);
			$("#incoming_number").text(number);
		}
	}
	
	function hangup(uuid) {
		$("#flash")[0].hangup(uuid);
	}
	
	function answer(uuid) {
		$("#flash")[0].answer(uuid);
	}
	
	function attach(uuid) {
		$("#flash")[0].attach(uuid);
	}
	
	function transfer(uuid, dest) {
		$("#flash")[0].transfer(uuid, dest);
	}
	
	function ui_transfer(uuid) {
		$("#transfer").data("uuid", uuid);
		$("#transfer").dialog('open');
	}
	
	function three_way(uuid1, uuid2) {
		$("#flash")[0].three_way(uuid1, uuid2);
	}
	
	function do_three_way(uuid) {
		var a = $(".active_call").data("uuid");
		if (a != "") {
			three_way(a, uuid);
		}
	}

	function do_join(uuid) {
		var a = $(".active_call").data("uuid");
		if (a != "") {
			join(a, uuid);
		}
	}

	
	function join(uuid1, uuid2) {
		$("#flash")[0].join(uuid1, uuid2);
	}
	
	function onCallState(uuid, state) {
		$("#call_"+uuid).children('.call_state').text(state);
	}
	
	function onIncomingCall(uuid, name, number, account, evt) {
		if (name == "") {
			name = "Unknown Name";
		}
		if (number == "") {
			number = "Unknown Number";
		}
		
		add_call(uuid, name, number);
		
		$("#incoming_call").data("uuid", uuid);
		$("#incoming_name").text(name);
		$("#incoming_number").text(number);
		$("#incoming_account").text(account);
		$("#incoming_call").dialog('open');
	}
	
	function onDisconnected() {
		$("#status").text("Disconnected");
		$("#sessionid").text("");
		setTimeout(function() {
			$("#status").text("Connecting...");
			$("#flash")[0].connect();
		}, 5000);
	}
	
	function onMakeCall(uuid, number, account) {
		add_call(uuid, "", number, account);
	}
	
	function onHangup(uuid, cause) {
		if ($("#incoming_call").data("uuid") == uuid) {
			$("#incoming_call").dialog('close');
		}
		
		$("#call_" + uuid).children(".hangupcause").text(cause);
		
		setTimeout(function() {
			remove_call(uuid);
		}, 1000);
	}

	function onDebug(message) {
	$('#log').html('');
		$("#log").append(message + "<br/>");
		
	}

	function onAttach(uuid) {
		$(".active_call").removeClass('active_call');
		
		if (uuid == "") {
				$("a", "#controls").button("option", "disabled", true);
			} else {
				$("a", "#controls").button("option", "disabled", false); 
				$("#call_" + uuid).addClass('active_call');
		}
	}
	
	function checkMic() {
		try {
			if ($("#flash")[0].isMuted()) {
				$("#no_mic").show();
				$("#input_source").hide();
				return false;
			} else {
				$("#no_mic").hide();
				$("#input_source").show();
				return true;
			}					
		} catch(err) {
			return false;
		}
	}
	
	function onConnected(sessionid) {
		$("#sessionid").text(sessionid);
		$(".call", "#call_container").remove();
		$(".account", "#account_container").remove();
		$("#status").text("Connected");
		
		if (!checkMic()) {
			$("#security").dialog('open');
		}
	}
	
	function login(user,pass) {
		$("#flash")[0].login(user,pass);
	} 
	
	function logout(account) {
		$("#flash")[0].logout(account);
	}
	
	function onLogin(status, user, domain) {
		if (status != "success") {
			softAlert("Authentication failed!", "onAuth");
		} else {
			$("#status").html("Connected as <span class='user'>" + user + "</span>@<span class='domain'>" + domain + "</span>");
			var u = user + '@' + domain;
			$("#flash")[0].register(u, $.query.get('code'));
			add_account(user, domain);
		}
	}
	
	function onLogout(user,domain) {
		remove_account(user, domain);
	}
	
	function onInit() {
		var mics = eval($("#flash")[0].micList());
		var sources = $("#input_source");
		var current_mic = $("#flash")[0].getMic();
		sources.children().remove();
		
		$("#status").text("Connecting...");

		for (i = 0; i < mics.length; i++) {
			var a = (i == current_mic) ? "selected" : "";
			sources.append("<option value='"+ i + "' " + a + " >" + mics[i] + "</option");
		}
	}
	
	function onEvent(data) {
		onDebug("Got event: " + data);
	}
	
	function softAlert(message,title) {
		$("#message_text").text(message);
		$("#message").dialog('option', 'title', title);
		$("#message").dialog('open');
	}
	
	function get_uuid(object) {
		return object.parent(".call").data("uuid");
	}
	
	function add_call(uuid, name, number, account) {
		var c = [ {uuid: uuid, name: name, number: number, account: account } ];
		
		var elm = $("#call_template").tmpl(c);

		elm.data("uuid", uuid);
		elm.data("name", name);
		elm.data("number", number);
		elm.data("account", account);
		
		elm.appendTo("#call_container");
	}
	
	function remove_call(uuid) {
		var c = $('#call_'+ uuid);
		c.fadeOut("slow", function() { c.remove() } );
	}
	
	function get_user(object) {
		return object.parent(".account").data("user");
	}
	
	function add_account(suser, domain) {
		var u = suser + "@" + domain;
		var sid = u.replace("@", "_").replace(/\./g, "_");
		var c = [ { id: sid, user: u} ];
		var elm = $("#account_template").tmpl(c);
		elm.data("user", u);
		elm.appendTo("#account_container");
		$("a", "#account_" + sid).button();
	}
	
	function remove_account(suser,domain) {
		var u = suser + "_" + domain;
		var sid = u.replace(/\./g, "_")
		
		var c = $('#account_'+ sid);
		c.fadeOut("slow", function() { c.remove() } );
	}
	
	function showSecurity() {
		$("#security").dialog('open');
	}
	
	function newcall(user,account) {
		makeCall(user, account, '');
	}
	
 $(document).ready(function() {
	var fs = btnSite + 'freeswitch.swf';
	var exinstall = btnSite + 'expressInstall.swf';
	swfobject.embedSWF(fs, "flash", "250", "150", "9.0.0", exinstall, flashvars, params, []);
	
	if (swfobject.ua.ie) {
		$("#flash").css("top", "-500px"); 
		$("#flash").css("left", "-500px");				
	} else {
		$("#flash").css("visibility", "hidden"); 				
	}
	
   $("#incoming_call").dialog({ 
	autoOpen: false,
	resizable: false,
	buttons: { 
		"Answer": function() { 
			answer($(this).data("uuid"));
			$(this).dialog("close"); 
		},
		"Decline": function() { 
			hangup($(this).data("uuid"));
			$(this).dialog("close"); 
		}
	}});
	
  $("#callout").dialog({ 
		autoOpen: false, 
		resizable: false,
		width: 600,
		buttons: { 
			"Call": function() { 
				makeCall($("#number").val(), $(this).data('account'), []);
				$(this).dialog("close"); 
			},
			"Cancel": function() { 
				$(this).dialog("close"); }
			}
		});
	$("#message").dialog({ 
		autoOpen: false,
		resizable: false,
		buttons: { 
			"OK": function() { 
				$(this).dialog("close"); 
			}
		}});
		
	$("#controls").dialog({
		title: "Клавиатура",
		autoOpen: false,
		resizable: false,
		width: 200,
		height: 220
	});
	
	$("#auth").dialog({
		modal: true,
		autoOpen: false,
		resizable: false,
		buttons: {
			"OK": function() {
				login($("#username").val(), $("#password").val());
				$("#password").val('');
				$(this).dialog('close');
			},
			"Cancel": function() {
				$(this).dialog('close');
			}
		}
	});
	
	$("#transfer").dialog({
		autoOpen: false,
		resizable: false,
		width: 600,
		buttons: {
			"OK": function() {
				transfer($(this).data("uuid"), $("#transfer_number").val());
				$(this).dialog('close');
			},
			"Cancel": function() {
				$(this).dialog('close');
			}
		}
	});
		
	$("#security").dialog({
		autoOpen: false,
		modal: true,
		resizable: false,
		buttons: {
			"OK": function() { 
				$(this).dialog("close"); 
			}
		},
		minWidth: 300,
		minHeight: 70,
		drag: function () {
			var flash = $("#flash");
			var fake_flash = $("#fake_flash");
			var offset = fake_flash.offset();
			
			flash.css("left", offset.left);
			flash.css("top", offset.top + 20);	
		},
		open: function () {
			var flash = $("#flash");
			var fake_flash = $("#fake_flash");
			var offset = fake_flash.offset();
			
			fake_flash.css("width", flash.width())
			fake_flash.css("height", flash.height() + 20)
			
			flash.css("left", offset.left);
			flash.css("top", offset.top + 20);
			flash.css("visibility", "visible");
			flash.css("z-index", $("#security").parent(".ui-dialog").css("z-index") + 1);
			flash[0].showPrivacy();
		},
		close: function() {
			var flash = $("#flash");
			flash.css("visibility", "hidden");
			flash.css("left", 0);
			flash.css("top", 0);
			flash.css("z-index", "auto");
			
			checkMic();
		}
	});
	$("a", "#controls").button({ disabled: true });
	$("a", "#call_container").button();
	$("a", "#guest_account").button();
});

	function testevent() {
		var evt = {
			test1: "hello",
			test2: "hallo",
			test3: "allo"
		};
		$("#flash")[0].sendevent(evt);
	}

