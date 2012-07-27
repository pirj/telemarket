(function($){
  $.fn.anchorScroll = function(options) {

  return this.each(function(){
    var element = this
      $(element).click(function(e) { 
        var locationHref = window.location.href
        var elementClick = $(element).attr("href")
        var destination = $(elementClick).offset().top
        $("html,body").animate({ scrollTop: destination})
        e.preventDefault()
        return false
    })
  })
}

})(jQuery)
