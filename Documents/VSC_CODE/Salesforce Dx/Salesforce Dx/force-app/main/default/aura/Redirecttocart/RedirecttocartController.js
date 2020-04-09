({
	doInit : function(cmp,evt)
	{
		//sessionStorage.clear();
	},

	showSpinner : function(cmp)
	{
		var spinner 			=	cmp.find('spinner');
		var container 			=	cmp.find('container');
		$A.util.removeClass(spinner,'slds-hide');
	},

	hideSpinner : function(cmp){
		var cartSize 	= cmp.get('v.cartSize');
		var openCart 	= cmp.find('openCart');
		var what 		= cmp.get('v.whatShow');
		if( cartSize != null && cartSize > 0 && what == 'catalog' )
		{
			$A.util.removeClass(openCart,'slds-hide');
		}
		else
		{
			$A.util.addClass(openCart,'slds-hide');
		}

		var spinner 	=	cmp.find('spinner');
		var container 	=	cmp.find('container');
		$A.util.addClass(spinner,'slds-hide');    	
	},

	hideCartCatalogButtons : function(cmp,evt)
	{
		var what 		=	evt.getParam('whatShow');
		if(what == 'configurator')
		{
			var openCart 		=	cmp.find('openCart');
			var openCatalog 	=	cmp.find('openCatalog');
			$A.util.addClass(openCatalog,'slds-hide');
			$A.util.addClass(openCart,'slds-hide');
		}
	},

	updateCartQty : function (cmp,evt)
	{

	},

	changeCatalogView : function(cmp,evt)
	{
		var itemView 	= evt.getParam('view');
		var container 	= cmp.find('totalAppContainer');
		if(itemView == 'singleAdd')
		{
			$A.util.removeClass(container, 'max-width-app-horizontal');
			$A.util.addClass(container, 'max-width-app-vertical');
		}
		else if(itemView == 'multiAdd')
		{
			$A.util.addClass(container, 'max-width-app-horizontal');
			$A.util.removeClass(container, 'max-width-app-vertical');
		}
	}
})