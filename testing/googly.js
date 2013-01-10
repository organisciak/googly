// Generated by CoffeeScript 1.4.0
(function() {
  var $, Trash, eye, trash;

  $ = jQuery;

  /* Create Trash
  */


  Trash = (function() {

    function Trash() {}

    Trash.prototype.draw = function() {
      return $("<div class='trash'>").html("This is the trash").hide().prependTo("body");
    };

    Trash.prototype.show = function() {
      return $(".trash").slideDown("fast");
    };

    Trash.prototype.hide = function() {};

    Trash.prototype["delete"] = function() {};

    return Trash;

  })();

  trash = new Trash;

  /* Create Eyeball
  */


  eye = function(parent) {
    var e, p;
    e = $("<div class='eye'>");
    p = $("<div class='pupil'>");
    e.draggable({
      stack: '.eye',
      snap: '.trash',
      snapMode: 'inner',
      start: function() {
        return trash.show();
      },
      stop: function() {
        return trash.hide();
      }
    }).click(function(e) {
      var h, offsetX, offsetY, w;
      w = $(this).outerWidth();
      h = $(this).outerHeight();
      offsetX = 10 * e.offsetX / w;
      offsetY = 10 * e.offsetY / h;
      return $(this).children(".pupil").animate({
        "margin-left": offsetX,
        "margin-top": offsetY
      });
    }).dblclick(function(e) {
      return eye($("body"));
    }).append(p).prependTo(parent);
    console.log('added eye');
  };

  $(function() {
    trash.draw();
    return eye($("body"));
    /*
    	$( ".eye" )
    		.draggable()
    */

  });

}).call(this);
