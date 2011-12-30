$(document).ready(function() {
  function updateCountdown() {
    var message = $('.message');
    var chars = message.val().length;
    var text = message.val();
    var limit = 130;
    var remaining = limit - chars;
    $('.countdown').text(remaining + ' characters remaining.');
    if(chars > limit){
      var new_text = text.substr(0, limit);
      message.val(new_text);
    }
  };

  function updatePreview(){
    var message = $('.message');
    var h = Mustache.to_html(message.val(), demoData);
    $('#preview-window').html(h);
  };

  var demoData = {
    base_temp: 28,
    mid_temp: 26,
    summit_temp: 24,
    base_depth: 100,
    mid_depth: 120,
    new_snow: 6,
    report_time: '06:15 12-28-11'
  };

  if($('.message')){
    updateCountdown();
    updatePreview();
    $('.message').change(updateCountdown);
    $('.message').keyup(updateCountdown);
    $('#preview').click(updatePreview);
  };
})
