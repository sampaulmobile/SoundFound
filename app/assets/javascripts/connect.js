/* Connect With SoundCloud                      */
/* URL: http://connect.soundcloud.com/latest.js */
/* Version: 0.2.0                               */

window.SC = window.SC || {};
SC.Client = function(passedOptions){
  this.options = {
    "accessToken": passedOptions.accessToken,
    "clientId":    passedOptions.clientId,
    "site":        (passedOptions.site || "soundcloud.com")
  }

  this.get = function(path, callback) {
    SC.Helper.JSONP.get(this.buildUrl(path), callback);
  }

  this.buildUrl = function(path){
    
    var param_delimiter = path.match(/\?/) ? "&" : "?"
    if(this.options.accessToken){
      scheme = SC.Helper.scheme(true);
      pathWithParams = path + param_delimiter + "oauth_token=" + this.options.accessToken;
    }else {
      scheme = SC.Helper.scheme();
      pathWithParams = path + param_delimiter + "client_is=" + this.options.clientId;
    }
    pathWithParams += "&format=json";
    return scheme + "api." + this.options.site + pathWithParams;
  }

  /* IMPLEMENT Using CORS+Fallback */
  //function delete(path, params, callback){} // keyword collision :(
  //function post  (path, params, callback){}
  //function put   (path, params, callback){}
}

SC.Connect = {
  callbacks: {},
  client: undefined,

  open: function(options){
    SC.Connect.callbacks.success = options.success;
    SC.Connect.callbacks.error   = options.error;
    SC.Connect.callbacks.general = options.callback;
    if(options.clientId && options.redirectUri ){
      var params = {
        client_id: options.clientId,
        redirect_uri: options.redirectUri,
        response_type:  options.flow == "useragent" ? "token" : "code_and_token",
        display: "popup"
      }

      var url = "https://soundcloud.com/connect?" + SC.Helper.buildQueryString(params);
      
      var windowWidth  = 456;
      var windowHeight = 510;
      var centerWidth = (window.screen.width - windowWidth) / 2;
      var centerHeight = (window.screen.height - windowHeight) / 2;
      
      window.open(url, "connectWithSoundCloud","location=1, width=" + windowWidth + ", height=" + windowHeight + ", top="+ centerHeight +", left="+ centerWidth +", toolbar=no,scrollbars=yes");
    }else{
      throw("Either clientId and redirectUri (for user agent flow) must be passed as an option");
    }


  },

  connectCallback: function(){
    var popupWindow = window.open("", "connectWithSoundCloud");
    var params = SC.Helper.parseLocation(popupWindow.location);
    if(params.error == "redirect_uri_mismatch"){
      popupWindow.document.body.innerHTML = "<p>The redirect URI '"+ popupWindow.location.toString() +"' you specified does not match the one that is configured in your SoundCloud app.</p> You can fix this in your <a href='http://soundcloud.com/you/apps' target='_blank'>app settings on SoundCloud</a>";
      return false;
    }
    popupWindow.close();
    if(params.error){
      SC.Connect.callbacks.error && SC.Connect.callbacks.error(params.error);
    }else{
      var accessToken = params.access_token;
      SC.client = new SC.Client({'accessToken': accessToken});
      SC.Connect.callbacks.success && SC.Connect.callbacks.success();
    }
    SC.Connect.callbacks.general && SC.Connect.callbacks.general(params.error);
  }
};

SC.connect = SC.Connect.open;

SC.oEmbed = function(options){
  var callback = options.callback;
  delete options.callback;
  var element = options.element;
  delete options.element;
  if(element){
    var oldCallback = callback || function(){};
    var callback = function(data, arg2, arg3){
      element.innerHTML = data.html;
      oldCallback(data, arg2, arg3);
    };
  }

  var url = SC.Helper.scheme() + "soundcloud.com/oembed.js?" + SC.Helper.buildQueryString(options);
  SC.Helper.JSONP.get(url, callback);
}


SC.Helper = {
  attachEvent: function(element, eventName, func){ 
    if(element.attachEvent) {
      element.attachEvent("on" + eventName, func);
    }else{
      element.addEventListener(eventName, func, false);
    }
  },
  JSONP: {
    callbacks: {},
    randomCallbackName: function(){
      return "CB" + parseInt(Math.random()*999999);
    },
    get: function(url, callback){
      var callbackName = this.randomCallbackName();
      var scriptElement = document.createElement('script');
      var src = url + "&callback=SC.Helper.JSONP.callbacks." + callbackName;
      scriptElement.src = src;
      SC.Helper.attachEvent(scriptElement, "load", function(){
        document.body.removeChild(scriptElement);
      });

      SC.Helper.JSONP.callbacks[callbackName] = callback;
      document.body.appendChild(scriptElement);
    }
  },
  
  scheme: function(force){
    return (force ? "https:" : window.location.protocol) + "//";
  },
  buildUrl: function(location, params){
    return location + "?" + this.buildQueryString(params);
  },
  buildQueryString: function(params){
    var queryStringArray = [];
    for(var name in params){
      if(params.hasOwnProperty(name)){
        queryStringArray.push(name + "=" + escape(params[name]));
      }
    }
    return queryStringArray.join("&");
  },

  parseLocation: function(location){
    var splitted = (location.search + location.hash).split(/[&?#]/);
    var obj = {};
    for(var i in splitted){
      var kv = splitted[i].split("=");
      if(kv[0]){
        obj[kv[0]] = unescape(kv[1]);
      }
    }
    return obj;
  }
};

$(function(){
  $(".connect-with-soundcloud a.connect").live("click", function(event){
    event.preventDefault();
    SC.Connect.open({
      redirectEndpoint: "/soundcloud/connect",
      error: function(reason){
        console.log("SoundCloud Connect failed: "+ reason);
      },
      success: function(){
        this.client.get("/me", function(me){
          $(".connect-with-soundcloud").addClass("connected");
          $(".visible-when-logged-in").removeClass("hidden");
          
          $(".connect-with-soundcloud .username").html(me.username);
        });
      }
    });
  });
})

/*(function(){
  var scripts = document.getElementsByTagName('script');
  var selfScript = scripts[ scripts.length - 1 ];
  
  //SC.client = new SC.Client({clientId: })
})();*/
