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
});
