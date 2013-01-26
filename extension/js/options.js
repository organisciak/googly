    $(function() {
        /*--Interface Functionality*/
      $('.menu a').click(function(ev) {
        ev.preventDefault();
        var selected = 'selected';

        $('.mainview > *').removeClass(selected);
        $('.menu li').removeClass(selected);
        setTimeout(function() {
          $('.mainview > *:not(.selected)').css('display', 'none');
        }, 100);

        $(ev.currentTarget).parent().addClass(selected);
        var currentView = $($(ev.currentTarget).attr('href'));
        currentView.css('display', 'block');
        setTimeout(function() {
          currentView.addClass(selected);
        }, 0);

        setTimeout(function() {
          $('body')[0].scrollTop = 0;
        }, 200);
      });

      $('#launch_modal').click(function(ev) {
        ev.preventDefault();
        var modal = $('.overlay').clone();
        $(modal).removeAttr('style');
        $(modal).find('button').click(function() {
            if ($(this).hasClass("delete-all-action")) {
                //Bind data wiping to 'delete all' button
                chrome.storage.local.clear(function() { 
                    $("#site-data li").slideUp();
                });
            }
          $(modal).addClass('transparent');
          setTimeout(function() {
            $(modal).remove();
          }, 1000);
        });

        $(modal).click(function() {
          $(modal).find('.page').addClass('pulse');
          $(modal).find('.page').on('webkitAnimationEnd', function() {
            $(this).removeClass('pulse');
          });
        });
        $('body').append(modal);
      });

      $('.mainview > *:not(.selected)').css('display', 'none');
      
      
    /* Extension-specific functions */
    
    //Populate list of all saved data//
    var addDataItem = function(site, count) {
        var item = $("<li>");
        $("<a href='#'><dl><dt>"
                +site+"</dt><dd>"
                +count+" eye"+ (count===1 ? "s":"")
                +"</dd></dl></a>"
            )
            .appendTo(item);
        $("<a href='#' class='delete'>delete</a>")
            .click(function(){
                var that = this;
                chrome.storage.local.remove(site, function() {
                    $(that).parent().remove();
                });
                
            })
            .appendTo(item);
                
       $("#site-data").append(item);
   }
   
       
    //Add Storage alert
    chrome.storage.local.getBytesInUse(null, function(data){
        use_percentage = 100*data/chrome.storage.local.QUOTA_BYTES;
        if (use_percentage > 1) {
            $(".storage-alert").html("<em>You are using "+Math.round(use_percentage*100)/100+"% of your super-duper eyeball storage. If you're seeing this message, you've drawn a lot of eyeballs!</em>");
        } else {
            $(".storage-alert").remove();
        }
   });

    //Read all data and enumerate it
    chrome.storage.local.get(null, function(data){
        all = data;
        for (var key in all) {
            addDataItem(key, all[key].length);
            }
    });
      
});