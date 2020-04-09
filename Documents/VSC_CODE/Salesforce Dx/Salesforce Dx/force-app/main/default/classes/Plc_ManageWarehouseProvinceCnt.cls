/**
 * ***********************************************************************************
 *     * @Author abdoulaye.diop@/webresults.it
 *     * @date  27/02/2019
 *     * @description Wizard Controller for Plc_ManageWarehouseProvince Aura Component
 * ************************************************************************************
 **/
public with sharing class Plc_ManageWarehouseProvinceCnt {

    /**
     * @Author FB
     * @date  29/03/2019
     * @description Method used in order to get some different system labels
     * @param none
     **/
    @AuraEnabled
    public static Map<String, String> retrieveTranslationsMap(){

        Map<String, String> response = new Map<String,String>();
        //Getting Serial Stock 2 labels
        Schema.DescribeSObjectResult warehouseProvinceSchema = Plc_WarehouseProvince__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> warehouseProvinceFieldsMap = warehouseProvinceSchema.fields.getMap();
        response.put('Plc_WarehouseProvince__c', warehouseProvinceSchema.getLabelPlural());
        //Getting Warehouse labels
        Schema.DescribeSObjectResult warehouseSchema = Bit2Shop__Warehouse__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> warehouseFieldsMap = warehouseSchema.fields.getMap();
        response.put('Bit2Shop__Warehouse__c', warehouseSchema.getLabel());
        response.put('WarehouseName', warehouseFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_Alias__c', warehouseFieldsMap.get('Plc_Alias__c').getDescribe().getLabel());
        return response;
    }

    /**
     * @Author abdoulaye.diop@/webresults.it
     * @date  27/02/2019
     * @description method for getting all piclist values
     * @param nameField the name of the field
     **/
    @AuraEnabled
    public static List<String> getPickListValues(String nameField){

	    List <String> allOprovince = new list <String> ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Plc_WarehouseProvince__c.getSObjectType();
     
        // Describe the Plc_WarehouseProvince__c using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
        // Get a map of fields for the Plc_WarehouseProvince__c
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
     
        // Get the list of picklist values for this field.
        list <Schema.PicklistEntry> values =
        fieldMap.get(nameField).getDescribe().getPickListValues();
     
        // Add these values to the selectProvince list.
        for (Schema.PicklistEntry a: values) {
            allOprovince.add(a.getValue());
        }
        system.debug('allOprovince ---->' + allOprovince);
        allOprovince.sort();
        return allOprovince;
	}

    /**
     * @Author abdoulaye.diop@/webresults.it
     * @date  27/02/2019
     * @description Return a Map of String(Zip Code) linked to its Name(additioning 'Name', Bit2Shop__State_Province__c)
     * @param key the name of the field
     **/
    @AuraEnabled
    public static Map<String, String> findWareHouses(String key){

        key = '%'+key+'%';
        //The map to return
        Map<String, String> result = new Map<String, String>();
	 	try{
                //retrieving WareHouse list within Dealer information
                List<Bit2Shop__Warehouse__c> b2ShopW = [SELECT Id, Name, Plc_Alias__c,Bit2Shop__Zip_Code__c, 
                                                        	Bit2Shop__State_Province__c,
                                                     		Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c
                                                     	FROM Bit2Shop__Warehouse__c
                                                     	WHERE (Plc_Alias__c Like :key
                                                     			OR Name Like :key 
                                                     			OR Bit2Shop__State_Province__c Like :key 
                                                     			OR Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c Like :key)
                                                        AND Plc_IsActive__c=true
                                                        AND Bit2Shop__Dealer_Id__r.Plc_Maintainer__c=true
                                                       ]; 
                
                //Finaly 'Message' key contains the 'SUCCESS' value
                result.put('warehouses', JSON.serialize(b2ShopW));
                result.put('error','false');
                result.put('message','SUCCESS');
            }catch(Exception e){
                //Once exception catched : 'erro' is 'true'
                result.put('error','true');
            }	
        //Returning the Map<String, String>
        return result;
    }
    
    /**
     * @Author abdoulaye.diop@/webresults.it
     * @date  27/02/2019
     * @description To save a list of WareHouse Province(List<Plc_WarehouseProvince__c>) to a selected Province
     * @param String of the json to deserialise
     **/
    @AuraEnabled
    public static Map<String, String> saveWarehouses(String jsonWareHouseProvinces){
		List<Plc_WarehouseProvince__c> wareHouseProvinces = (List<Plc_WarehouseProvince__c>)JSON.deserialize(jsonWareHouseProvinces, List<Plc_WarehouseProvince__c>.class);
        List<Plc_WarehouseProvince__c>  deletedWarehouseProvinces = new List<Plc_WarehouseProvince__c>();
        //The map to return
        Map<String, String> result = new Map<String, String>();
        Boolean exist = false;

        try {
            List<Plc_WarehouseProvince__c> existedWareHouseProvinces = [SELECT Id, Plc_Province__c, Plc_Warehouse__c,
                                                                            Plc_ExternalWarehouse__c, Plc_ViewName__c
                                                                            FROM Plc_WarehouseProvince__c
                                                                            WHERE Plc_Province__c =: wareHouseProvinces[0].Plc_Province__c
                                                                        ];

            if (!existedWareHouseProvinces.isEmpty()) {
                for (Plc_WarehouseProvince__c existedWareHouseProvince : existedWareHouseProvinces){
                    for (Plc_WarehouseProvince__c wareHouseProvince :wareHouseProvinces){
                        if (existedWareHouseProvince.Plc_Warehouse__c ==  wareHouseProvince.Plc_Warehouse__c){
                                wareHouseProvince.Id = existedWareHouseProvince.Id;
                                wareHouseProvince.Plc_ExternalWarehouse__c = existedWareHouseProvince.Plc_ExternalWarehouse__c;
                                wareHouseProvince.Plc_ViewName__c = existedWareHouseProvince.Plc_ViewName__c;
                                exist = true;
                        }
                    }
                    if (!exist) {
                        deletedWarehouseProvinces.add(existedWareHouseProvince);
                    }
                    exist = false;
                }
            }

            if (!deletedWarehouseProvinces.isEmpty()) {
                delete deletedWarehouseProvinces;
            }
            upsert wareHouseProvinces;
            result.put('message', Label.Plc_AllAllSuccessfulSavedPlural.replace('{0}', Plc_WarehouseProvince__c.SObjectType.getDescribe().getLabelPlural()));
            //'error' value is 'false'
            result.put('error','false');
        } catch (Exception e) {
            //'error' value is 'true'
            result.put('error','true');
            //Message setting to the general exception message
            result.put('message', e.getMessage());
        }
        
      	return result;
    }
    
	/**
     * @Author: abdoulaye.diop@/webresults.it
     * @date: 08/03/2019
     * @description: To get the list of Warehous Prvinces filtred by a given province
     * @param:	String, to filter the province for the select request
     **/
    @AuraEnabled
    public static Map<String, String> findWarehouseProvincesByProvince(String province){
        //To catch the satate of the request.
        Map<String, String> result = new Map<String, String>();
        //'false' is the default value of 'error' key.
        result.put('error','false');
		try{
                List<Plc_WarehouseProvince__c> warehouseProvinces = [SELECT Name, Plc_Province__c, 
                                                                     	Plc_DistributionPercentage__c, 
                                                                     	Plc_Warehouse__c,
                       													Plc_Warehouse__r.Plc_Alias__c, 
                                                                     	Plc_Warehouse__r.Name, 
                                                                     	Plc_Warehouse__r.Bit2Shop__State_Province__c,
                                                                     	Plc_Warehouse__r.Bit2Shop__Dealer_Id__r.Bit2Shop__State_Province__c
                                                                    FROM Plc_WarehouseProvince__c 
                                                                    WHERE Plc_Province__c=:province
                                                                    ];
                //put the list in the map
                result.put('warehouseProvinces',JSON.serialize(warehouseProvinces));
                //setting up the message to 'SUCCESS' value
                result.put('message', 'SUCCESS');
                
            }catch(Exception e){
                //Once exception catched : 'erro' is 'true'
                result.put('error','true');
            }
        
        //Returning the Map<String, String>
        return result;
    }

    /**
     * @Author: abdoulaye.diop@/webresults.it
     * @date: 28/03/2019
     * @description: Method used to manage the permission in the component
     **/
    @AuraEnabled
    public static String preCheck(){

        if (FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcManageWarehouseProvince)) {
            return '';
        } else {
            return Label.Plc_AllAllUserForbiddenOperation;
        }
    }
}