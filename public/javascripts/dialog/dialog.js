/*
 * Dialog
 *
 * This script setups the dialog jqueryui element with predefined settings
 * so you dont have to call all the options when you just open a dialog
 *
 * @name Dialog
 * @author Sebastian Pape <email@sebastianpape.com>
*/

$(document).ready(function(){
    // positioning of all dialogs (centering) when window is resized or scrolled
    $(window).bind("resize scroll", function() {
        $(".ui-dialog ").position({of: $(window), at: "center center"});
    });
});

var Dialog = new Dialog();

function Dialog() {
    
    this.add = function(_params) {
        var _dialog = $(document.createElement("div")).addClass("dialog").html(_params.content);
        $("body").append(_dialog);
        $(_dialog).data("startLeft", ($(_params.trigger).offset().left + $(_params.trigger).width()/2));
        $(_dialog).data("startTop", ($(_params.trigger).offset().top + $(_params.trigger).height()/2));
        $(_dialog).data("callback", _params.callback);
        Dialog.setup(_dialog);
        _dialog.dialog(_params);
    }
    
    this.setup = function(_dialog) {
        $(_dialog).bind("dialogcreate", function(event, ui) {
            $(this).dialog("option", "modal", true);
            $(this).dialog("option", "draggable", false);
            $(this).dialog("option", "resizable", false);
            $(this).parent().css({opacity: 0});
        });
        
        $(_dialog).bind("dialogopen", function(event, ui) {
            // bind click on overlay to close dialog 
            $(".ui-widget-overlay").bind("click", function(){
                $(_dialog).dialog("close");
            });
            
            // popup animation
            $(this).parent().offset({left: ( $(this).data("startLeft") - ( $(this).parent().width()/2 )), top: ( $(this).data("startTop") - $(this).parent().height()/2)});
            
             if ($("#main").height() < $(window).height()/2) {
                // when main section is realy small then animate to the center of main section and not window
                var _top = ( ( $("#main").height()/2 ) - ( $(this).parent().height()/2 ) + $("#main").offset().top );
                var _left = ( ( $("#main").width()/2 ) - ( $(this).parent().width()/2 ) + $("#main").offset().left );
            } else {
                var _top = ( ( $(window).height()/2 ) - ( $(this).parent().height()/2 ) );
                var _left = ( ( $(window).width()/2 ) - ( $(this).parent().width()/2 ) );
            }
            
            $(this).parent().stop().hide().fadeIn().animate({
                top: _top,
                left: _left,
                opacity: 1
            }, {queue: false});
        });
        
        $(_dialog).bind("dialogclose", function(event, ui) {
            if ($(this).data("callback")) $(this).data("callback").apply();
            
            // remove dialog on close
            $(this).remove();
        });
    }
    
}