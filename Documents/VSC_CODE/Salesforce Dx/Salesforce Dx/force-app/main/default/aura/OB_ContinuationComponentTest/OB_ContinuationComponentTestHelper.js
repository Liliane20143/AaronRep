({
	getUniqueId : function() {
		return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    		var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    		return v.toString(16);
  		});
  },
  
getUrl: function() {
    	var hostname = window.location.hostname;
        var position = hostname.indexOf('--c');
        var mydomain='';
         var endUrl = '';
        if(position!=-1){
         	mydomain = hostname.substr(0, position);
             endUrl = '.lightning.force.com';
        } else {
            mydomain = hostname;
        }
        return 'https://' + mydomain + endUrl;         
	},    
    
  setIframeLocation: function(element, value) {
    if (element.contentWindow !== undefined) {
        console.log('Content Window presente');
        element.contentWindow.postMessage(obj, vfBaseURL);
    }
    else {
        console.log('Entrato nel Set timeout');
        setTimeout(this.setIframeLocation.bind(this, element, value), 100); 
    }
  }
})