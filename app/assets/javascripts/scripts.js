$(document).ready(function() {
  function updateCountdown() {
    var message = $('.message');
    if(message && message.val()){
    var chars = message.val().length;
    var text = message.val();
    var limit = message.attr('data-max');
    var remaining = limit - chars;
    $('.countdown').text(remaining + ' characters remaining.');
    if(chars > limit){
      var new_text = text.substr(0, limit);
      message.val(new_text);
    }
    };
  };

  var demoDataOld = {
    base_temp: 28,
    mid_temp: 26,
    summit_temp: 24,
    base_depth: 100,
    mid_depth: 120,
    new_snow: 6,
    report_time: '06:15 12-28-11'
  };

  function updatePreview(){
    var message = $('.message');
    if(message && message.val()){
    var h = Mustache.to_html(message.val(), demoDataOld);
    $('#preview-window').html(h);
    }
  };

  if($('.message')){
    updateCountdown();
    updatePreview();
    $('.message').change(updateCountdown);
    $('.message').keyup(updateCountdown);
    $('#preview').click(updatePreview);
  };

    $('div.areahome').click(function(o,t){
      $('html,body').animate({scrollTop:$('#signupform').offset().top}, 500);
      $("#shredder_email").focus()
      $("#shredder_area_id").val($(this).attr('data-area'));
    });
})
