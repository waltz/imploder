$(function() {
  var composer = $("#composer");

  if (composer.length > 0) {
    var setGif = function(event) {
      $("#gif").attr("src", event.target.value);
    }

    var setVideo = function(event) {
      var youtube_matcher = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i;
      var matches = event.target.value.match(youtube_matcher);
      var video_id = matches[1];
      var embed_url = "https://www.youtube.com/embed/" + video_id + "?autoplay=1";

      $("#youtube-video").attr("src", embed_url);
    });

    var gif_url = $("#video_gif_url");
    gif_url.bind('onload input', setGif);

    var youtube_url = $("#video_youtube_url");
    youtube_url.bind('onload input', setVideo);
  }
});
