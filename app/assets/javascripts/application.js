import $ from 'jquery'

export default class Fetcher {
  constructor() {
    this.ready = false

    $(() => {
      const video_fetcher = $("#video-fetcher");

      if (video_fetcher.length > 0) {
        $("#video-player").hide();
        this.video_id = video_fetcher.data("video-id");
        this.poll();
      }
    });
  }

  showVideo(data) {
    $("#video-fetcher").hide();
    $("#video-player").show();

    var video_player = document.getElementById("video-player");
    var source = document.createElement("source");
    source.setAttribute("src", data.clip_url);
    source.setAttribute("type", "video/mp4");
    video_player.appendChild(source);
    video_player.load();
    video_player.play();
  }

  poll() {
    $.ajax({
      url: '/videos/' + this.video_id,
      type: "GET",
      success: data => {
        if (data.status === "ready") {
          this.ready = true
          this.showVideo(data);
        }
      },
      dataType: "json",
      complete: setTimeout(() => {
        if (!this.ready) {
          this.poll();
        }
      }, 5000),
      timeout: 2000
    });
  }
}
