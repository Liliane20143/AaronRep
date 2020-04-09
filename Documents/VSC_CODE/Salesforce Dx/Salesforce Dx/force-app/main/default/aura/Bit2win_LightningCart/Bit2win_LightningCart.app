<aura:application implements="force:appHostable" extends="force:slds" controller="NE.Bit2win_LightningCart_Controller" access="global">

	<aura:attribute name="accId" 			type="String" access="global" />
	<aura:attribute name="billAccId" 		type="String" access="global" />
	<aura:attribute name="servAccId" 		type="String" access="global" />
	<aura:attribute name="oppId" 			type="String" access="global" />
	<aura:attribute name="orderId" 			type="String" access="global" />
	<aura:attribute name="confCurrency" 	type="String" access="global" />
	<aura:attribute name="whatShow" 		type="String" access="global"		default="catalog" />
	<aura:attribute name="cartSize" 		type="Integer" access="global" />
	<aura:attribute name="quoteId" 			type="String"		access="global" />

    <aura:attribute name="cacheName"        type="String"       access="global" />
    <aura:attribute name="useCache"         type="String"       access="global" />
    <aura:attribute name="debuglevel"       type="String"       access="global" />

	<aura:handler name="init" value="{!this}" action="{!c.doInit}" />
	<aura:handler event="aura:waiting" action="{!c.showSpinner}" />
	<aura:handler event="aura:doneWaiting" action="{!c.hideSpinner}" />
	<aura:handler event="NE:Bit2win_Event_ChangeCatalogView" action="{!c.changeCatalogView}" />
	<aura:handler event="NE:Bit2win_Event_CategoryChanged" 		action="{!c.updateCartQty}" /> 

	 
	<div aura:id="totalAppContainer" class="slds containerApp max-width-app-vertical" style="height: 100%; /* overflow-y: hidden;margin-top:7px;*/">
		<div aura:id="spinner" class="slds-spinner_container slds-hide" style="position: fixed;">
			<div class="slds-spinner slds-spinner--large" aria-hidden="false" role="alert">
				<div class="slds-spinner__dot-a"></div>
				<div class="slds-spinner__dot-b"></div>
			</div>
		</div>
      
       	<NE:Bit2win_ConfigurationInfo oppId="{!v.oppId}" quoteId="{!v.quoteId}" orderId="{!v.orderId}" accId="{!v.accId}" billAccId="{!v.billAccId}" servAccId="{!v.servAccId}" confCurrency="{!v.confCurrency}" />
        <NE:B2WGin_Core_Engine oppId="{!v.oppId}" quoteId="{!v.quoteId}" accId="{!v.accId}" orderId="{!v.orderId}" cacheName="{!v.cacheName}" useCache="{!v.useCache}" debuglevel="{!v.debuglevel}" />  
        
		<div class='slds-grid slds-wrap' style='padding:1rem;'>
            <div class='slds-col ' style='/*border:1px solid #061C3F;*/width:70%;'>
				<NE:Bit2win_Catalog oppId="{!v.oppId}" quoteId="{!v.quoteId}" orderId="{!v.orderId}" accId="{!v.accId}" billAccId="{!v.billAccId}" servAccId="{!v.servAccId}" />
				<NE:Bit2win_Configurator oppId="{!v.oppId}" quoteId="{!v.quoteId}" orderId="{!v.orderId}" accId="{!v.accId}" billAccId="{!v.billAccId}" servAccId="{!v.servAccId}" />
            </div>
            <div class='slds-col ' style='padding-left:2rem;width:30%;'>
				<NE:Bit2win_Cart oppId="{!v.oppId}" quoteId="{!v.quoteId}" orderId="{!v.orderId}" accId="{!v.accId}" billAccId="{!v.billAccId}" servAccId="{!v.servAccId}" />
				<!--<c:verifca_prod_magazzino/>-->
            </div>
		</div> 
       
        <NE:Bit2win_BundleConfigurator />
        <NE:Bit2win_ProductDescription />       
	</div>

</aura:application>