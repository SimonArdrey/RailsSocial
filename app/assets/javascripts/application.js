// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_directory .
//= require_directory ./channels

function smoothFadeOut(el, callback) {
  var $el = $(el);

  $el.animate({
    opacity: 0
  }, 150, function () {
    $el.animate({
      height: 0,
      padding: 0,
    }, 150, function () {
      $el.remove();

      if (callback) {
        callback();
      }
    });
  });
}

$(function () {
  $('body').on('click', '.js-flash .delete', function (event) {
    var flashEl = $(event.target).closest('.js-flash');
    smoothFadeOut(flashEl);
  });
});

$(function () {
  $('body').on('click', '.has-dropdown', function (event) {
    // TODO: Get around to this.
  });
});

$(document).ready(function() {
  $('a[disabled=disabled]').click(function(event){
    event.preventDefault(); // Prevent link from following its href
  });
});
