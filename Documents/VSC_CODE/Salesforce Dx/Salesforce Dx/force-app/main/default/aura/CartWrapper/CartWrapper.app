<!--
<aura:application extends="ltng:outApp">

    <NE:Bit2win_Cart />
    <NE:Bit2win_Messages />
    <NE:Bit2win_CoreEngine />
    <NE:Bit2win_Search />
    <NE:Bit2win_CategoriesNavigator />
    <NE:Bit2win_Catalog />
    <NE:Bit2win_CartInfo />
    <NE:Bit2win_CatalogsNavigator />
    <NE:Bit2win_ConfigurationInfo />
    <NE:Bit2win_Bundle />
    <NE:Bit2win_Configurator />
    <NE:Bit2win_BundleConfigurator />  controller="NE.Bit2win_LightningCart_Controller" 
  
</aura:application>
-->
<aura:application implements="force:appHostable" extends="ltng:outApp" controller="NE.Bit2win_LightningCart_Controller" access="global">

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
    <aura:handler event="NE:Bit2win_Event_CartEvent" action="{!c.afterCheckout}" />
    

	 
	<div aura:id="totalAppContainer" class="slds containerApp max-width-app-vertical" style="height: 100%; /* overflow-y: hidden;margin-top:7px;*/">
   	
	</div>

</aura:application>