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

function showVideo() {
  $("#video-fetcher").hide();
  $("#video-player").show();
  $("#video-player video")[0].play();
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
