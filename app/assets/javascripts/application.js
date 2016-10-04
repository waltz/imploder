//= require jquery
//= require jquery_ujs
//= require_tree .

var video_id;
var ready = false;

$(function() {
  var video_fetcher = $("#video-fetcher");

  if (video_fetcher.length > 0) {
    $("#video-player").hide();
    video_id = video_fetcher.data("video-id");
    poll(video_id);
  }
});

function videoUrl() {
  return "/videos/" + video_id + ".mp4";
}

function showVideo() {
  $("#video-fetcher").hide();
  $("#video-player").show();

  var video_player = document.getElementById("video-player");
  var source = document.createElement("source");
  source.setAttribute("src", "/videos/" + video_id + ".mp4");
  source.setAttribute("type", "video/mp4");
  video_player.appendChild(source);
  video_player.load();
  video_player.play();
}

function poll() {
  $.ajax({
    url: '/videos/' + video_id + '/status',
    type: "GET",
    success: function(data) {
      if (data.status === "ready") {
        ready = true;
        showVideo();
      }
    },
    dataType: "json",
    complete: setTimeout(function() {
      if (!ready) {
        poll();
      }
    }, 5000),
    timeout: 2000
  });
}
