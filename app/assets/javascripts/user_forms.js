$(document).ready(function() {
  $('.signup-button').on('click', function(e){
    e.preventDefault();
    $('.signin-form').hide();
    $('.signup-form').slideToggle();
  });

  $('.signin-button').on('click', function(e){
    e.preventDefault();
    $('.signup-form').hide();
    $('.signin-form').slideToggle();
  });

  if ($('.signup-form ul.errors li').length > 0) $('.signup-form').show();
  if ($('.signin-form ul.errors li').length > 0) $('.signin-form').show();
});
