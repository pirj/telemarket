$(function() {
  var BV = new $.BigVideo();
  BV.init();
  BV.show('/lightbulb.mp4',{ambient:true});

  setTimeout(function(){
    $('#transparent').addClass('loaded');
  }, 1000);

  $('#da-slider').cslider({
    //bgincrement : 0,
    autoplay    : true,
    interval    : 15000,
    autoHover   : true
  });

  $('.btn.register').click(function(){
    $('#main').fadeOut('slow')
  });
});
