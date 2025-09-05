import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


// window.replaceAll = function(str, find, replace) {
// 	return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
// }

window.escapeRegExp = function(str) {
	return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

window.showHideMapProperties = function() {	
    if($('#sidebar').hasClass('open')) {
      $('#sidebar').removeClass('col-md-4');
      $('#sidebar').removeClass('open');
      $('#sidebar').addClass('hidden');
      $("#map").css("width", "100%");
      $('#map').addClass('col-md-12');
      $('#map').removeClass('col-md-8');
      //reloadMap();
      $("#collapse").attr("title", "Reduzir mapa");
      $("#collapse").attr("src", "/images/collapse-left.png");
    } else {
        $('#sidebar').addClass('col-md-4');
      $('#sidebar').addClass('open');
      $('#sidebar').removeClass('hidden');
      $("#map").css("width", "75%");
      $('#map').removeClass('col-md-12');
      $('#map').addClass('col-md-8');
    //   reloadMap();
      $("#collapse").attr("title", "Ampliar mapa");
      $("#collapse").attr("src", "/images/collapse-right.png");
    }
  }

