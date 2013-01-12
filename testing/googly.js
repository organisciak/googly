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

    Trash.prototype.hide = function() {
      return $(".trash").slideUp();
    };

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
      var esize, offsetX, offsetY, psizeDiff;
      console.log("MOUSE OFFSETY " + e.offsetY);
      esize = $(this).outerWidth();
      console.log("ESIZE " + esize);
      psizeDiff = $(this).innerWidth() - $(this).children(".pupil").outerWidth();
      console.log("PSIZE " + psizeDiff);
      offsetX = psizeDiff * e.offsetX / esize;
      offsetY = psizeDiff * e.offsetY / esize;
      console.log("PUPIL OFFSETY " + offsetY);
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