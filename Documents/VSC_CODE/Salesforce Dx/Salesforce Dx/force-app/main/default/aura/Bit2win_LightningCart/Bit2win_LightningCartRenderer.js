({
	render: function(cmp)
	{
		var res 			= this.superRender();
		var openCart        =   cmp.find('openCart');
		var openCatalog     =   cmp.find('openCatalog');
		$A.util.removeClass(openCart,'uiButton--default');
		$A.util.removeClass(openCatalog,'uiButton--default');

		return res;
	}
})