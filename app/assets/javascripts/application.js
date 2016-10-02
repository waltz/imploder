//= require jquery
//= require jquery_ujs
//= require_tree .

var video_id;
var ready = false;

$(function() {
  var video_fetcher = $("#video-fetcher");

  if (video_fetcher != null) {
    video_id = video_fetcher.data("video-id");
    poll(video_id);
  }
});

function showVideo() {
  $("#video-player").show();
}

function poll() {
  $.ajax({
    url: '/videos/' + video_id + '/status',
    type: "GET",
    success: function(data) {
      console.log(data);

      if (data.status === "ready") {
        ready = true;
        console.log('redddy');
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
