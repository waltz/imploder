$(function() {
  var composer = $("#composer");

  if (composer.length > 0) {
    $("#gif-url").keypress(setGif);
    $("#gif-url").blur(setGif);

    var setGif = function(event) {
      $("#gif").attr("src", event.target.value);
    }

    console.log('loaded composer');
  }
});
