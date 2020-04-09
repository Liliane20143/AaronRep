({	
    chooseUrl: function(component, event,field){
        var url;
        if(field == 'provincia'){
            url = 'callout:OB_Postel_Autocomplete/province';
        }else if (field == 'comune'){
            var inp = document.getElementById("provincia").value;
            var idProv;
            url = 'callout:OB_Postel_Autocomplete/comuni?in='+inp+'&prov='+idProv;
        }
        return url;
    },
    province : function(component, event , helper){
        var provs = component.get("v.response");
        //var item = xml.getElementsByTagName('item')[0];
        console.log(JSON.stringify(provs));
        var listaProvince = [];
        var j$ = jQuery.noConflict();
        for (var key in provs) {
            listaProvince.push(provs[key]);
        }
        component.set('v.provinceList',listaProvince.sort());
        console.log(component.get('v.provinceList'));
        console.log(listaProvince);     
        j$('[id$="provincia"]').autocomplete({
            //GET ARRAY 
            source: listaProvince
        }); 
    },
    city : function(component, event , helper){
        var coms = component.get("v.response");
        //var item = xml.getElementsByTagName('item')[0];
        console.log(JSON.stringify(coms));
        var listaComuni = [];
        var j$ = jQuery.noConflict();
        for (var key in coms) {
            listaComuni.push(coms[key]);
        }
        component.set('v.comuniList',listaComuni.sort());
        //console.log('comuni'+component.get('v.comuni'));
        console.log(listaComuni);     
        j$('[id$="comune"]').autocomplete({
            //GET ARRAY 
            source: listaComuni
        }); 
    }

    
})