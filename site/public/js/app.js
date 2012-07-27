$(function(){
  setTimeout(function() { $('.alert:not(.alert-error)').fadeOut('slow') }, 5000)

  $("a").anchorScroll();
})


var flashvars = {};
flashvars.phone="88052";
flashvars.img1="http://zadarma.com/images/but/call2_green_en_free.png";
flashvars.img2="http://zadarma.com/images/but/call2_green_en_connecting.png";
flashvars.img3="http://zadarma.com/images/but/call2_green_en_reset.png";
flashvars.img4="http://zadarma.com/images/but/call2_green_en_error.png";
var params = {};
params.wmode='transparent';
var attributes = {};
swfobject.embedSWF("http://zadarma.com/pbutton.swf", "myAlternativeContent", "215", "138", "9.0.0", false, flashvars, params, attributes);
