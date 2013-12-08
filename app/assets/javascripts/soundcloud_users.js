jQuery(function(){
  $("#plays_slider").slider({
      value: 0,
      min: 0,
      max: 10000,
      step: 100,
      slide: function(event, ui) {
        $('input#alert_play_count_min').val(ui.value);
        document.getElementById('play_count').innerText = ">= " + ui.value + " Plays";
      }
  });
});

jQuery(function(){
  $("#likes_slider").slider({
      value: 0,
      min: 0,
      max: 10000,
      step: 100,
      slide: function(event, ui) {
        $('input#alert_like_count_min').val(ui.value)
        document.getElementById('like_count').innerText = ">= " + ui.value + " Likes";
      }
  });
});

jQuery(function(){
  $("#downloads_slider").slider({
      value: 0,
      min: 0,
      max: 1000,
      step: 10,
      slide: function(event, ui){
        $('input#alert_download_count_min').val(ui.value)
        document.getElementById('download_count').innerText = ">= " + ui.value + " D/Ls";
      }
  });
});

jQuery(function(){
  $("#duration_slider").slider({
      value: 0,
      min: 0,
      max: 150,
      step: 1,
      slide: function(event, ui) {
        $('input#alert_duration_min').val(ui.value)
        document.getElementById('duration').innerText = ">= " + ui.value + " Min";
      }
  });
});


$(document).ready( function(){
    $(".cb-enable").click(function(){
        var parent = $(this).parents('.switch');
        $('.cb-disable',parent).removeClass('selected');
        $(this).addClass('selected');
        $('.checkbox',parent).attr('checked', true);
    });
    $(".cb-disable").click(function(){
        var parent = $(this).parents('.switch');
        $('.cb-enable',parent).removeClass('selected');
        $(this).addClass('selected');
        $('.checkbox',parent).attr('checked', false);
    });
});

