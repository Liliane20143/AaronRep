/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC Utils Rest WebService.
 */
@isTest
public class Plc_UtilsTest {

    @TestSetup
    static void makeData(){

        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');

        Bit2Shop__Dealer__c bit2ShopDealerParent = Plc_TestFactory.createDealer('dealerParent', account, '781234567809');
        bit2ShopDealerParent.Plc_Repairer__c = true;
        insert bit2ShopDealerParent;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('dealer', account, '1234567809', bit2ShopDealerParent);
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '000001NEXI', bit2ShopDealer);
        bit2ShopWarehouse.Plc_UniqueKey__c = 'key1';
        insert bit2ShopWarehouse;


        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'Test', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '123456789';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 15;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;



        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse, 'New');

        bit2ShopStockSerials.Bit2Shop__Serial_Number__c = 'bit2ShopSerialNumber';
        bit2ShopStockSerials.Plc_TermId__c = plcTermId.Id;
        bit2ShopStockSerials.Plc_Property__c = 'Nexi';
        bit2ShopStockSerials.Plc_PTSCode__c='ptccode';
        bit2ShopStockSerials.Bit2Shop__ICCID__c='bit2ShopICCID';
        bit2ShopStockSerials.Bit2Shop__IMEI__c='bit2ShopIMEI';
        bit2ShopStockSerials.Plc_PcipedModel__c='plc_PcipedModel';
        bit2ShopStockSerials.Plc_PcipedLetterOfApproval__c='plcPcipedLetterOfApproval';
        bit2ShopStockSerials.Plc_PcipedApprovalNumber__c='plcPcipedApprovalNumber';
        bit2ShopStockSerials.Plc_PcipedVersion__c='plcPcipedVersion';
        bit2ShopStockSerials.Plc_PcipedExpiryDate__c= Date.newInstance(System.now().year(),System.now().month(),System.now().day());

        bit2ShopStockSerials.Plc_ManufacturerSerialNumber__c = 'value1';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = 'Test';
        bit2ShopStockSerials.Plc_Property__c='N';
        bit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Available';

        insert bit2ShopStockSerials;   
       
         Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
             	Bit2Shop__Transfer_Type__c= 'Stock2Stock',
                Bit2Shop__Code__c   = 'ACTION1',
                Plc_Alias__c        = 'TD001'
        );

        insert transfDetail1;
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
            	Bit2Shop__Transfer_Type__c					= transfDetail1.Bit2Shop__Transfer_Type__c,
                Plc_TransferDetail__c                       = transfDetail1.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Point_Of_Sales_Id__c              = bit2ShopDealer.Id,
                Bit2Shop__Holding_Id__c                     = account.Id,
                Bit2Shop__Warehouse_Id__c                   = bit2ShopWarehouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = bit2ShopDealer.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = bit2ShopWarehouse.Id
        );
        insert stockOrder;
        
        NE__Order__c neOrder = new NE__Order__c();
        insert neOrder;
      
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 06/12/2018
     * @version 1.0
     * @description Test of the method getSObjectTypeRecordTypeMap.
     */
    @isTest
    static void getSObjectTypeRecordTypeMapTest(){
        
      Test.startTest();
      Map<String, Schema.RecordTypeInfo> recordTypeMap = Plc_Utils.getSObjectTypeRecordTypeMap('RecordType');
      Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method getSObjectTypeRecordTypeMap.
     */
    @isTest
    static void getRecordTypeIdTest(){
        
      Test.startTest();
      //Id returnedId = Plc_Utils.getRecordTypeId('Bundle','Bit2Archetypes__Archetype__c');
      Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');
      Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 25/01/2019
     * @version 1.0
     * @description Test of the method getRecordTypeNameById.
     */
    @isTest
    static void getRecordTypeNameByIdTest(){
        //String sObjectType, String recordTypeId
        Plc_Utils utils = new Plc_Utils();
        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');
        Test.startTest();
        String sObjectType = utils.getRecordTypeNameById('Bit2Shop__Dealer__c', b2ShopDealRecType);
        Test.stopTest();
        System.assertEquals('Child Dealer', sObjectType);
    }
                
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method isValid.
     */
    @isTest
    static void isValidTest(){
      
      	List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
    
      	Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        //Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        
        //workOrderLineItem
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','posta','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody2 = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', null, gestOrdReqBodyRigOrdLavs);
         
        
      	Test.startTest();
        
      	String response1 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
        // if a field is empty or null
      	String response2 = Plc_Utils.isValid(gestOrdReqBody2, fieldList);
        
        //innerPayloadMap is empty '' or null
        gestOrdReqBody.workOrderDetail.warehouseAlias = '';
        String response3 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
        // when the length of innerField > to max
        gestOrdReqBody.workOrderDetail.abi = 'abiabia';
        gestOrdReqBody.workOrderDetail.warehouseAlias = '4562135';
        String response4 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
        /** if field is a list */
        // when an innerPayloadMap is empty 
        gestOrdReqBody.workOrderDetail.abi = 'abi';       
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId ='';
        String response5 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
		// if a field in innerObject is empty
		gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId ='145623';
		gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = '';        
        String response6 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
        // fieldLengthMap.get(innerListObjectField) > to Max
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = '11111111111111111111';
        String response7 = Plc_Utils.isValid(gestOrdReqBody, fieldList);        
        
        // if an innerObject is empty or null line 411
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail = null;        
        String response8 = Plc_Utils.isValid(gestOrdReqBody, fieldList);

        gestOrdReqBody.workOrderLineItem = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        String response10 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
        
        //** if field is of simple type */
        // when length fieldLengthMap superior to max
        fieldList = new List<String> {'abi'};
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd2 = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abiabiabi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                	'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                	'shopLegacyId','signboard','posta','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        String response11 = Plc_Utils.isValid(gestOrdReqDetOrd2, fieldList);
        
        gestOrdReqDetOrd2.abi = '';
        String response12 = Plc_Utils.isValid(gestOrdReqDetOrd2, fieldList);
      	Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 28/01/2019
     * @version 1.0
     * @description Test of the method updateProductStockQuantities.
     */
    @isTest
    static void updateProductStockQuantitiesTest(){

      Map<String, Bit2Shop__Stock_Serials2__c> oldStockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c> ();
      List<Bit2Shop__Stock_Serials2__c> oldStockSerials = [SELECT Id, Bit2Shop__Product_Stock_Id__c, Bit2Shop__Status__c FROM Bit2Shop__Stock_Serials2__c];
      for (Bit2Shop__Stock_Serials2__c oldStockSerial : oldStockSerials) {
         oldStockSerialsMap.put(oldStockSerial.Bit2Shop__Product_Stock_Id__c, oldStockSerial);
      }

      Bit2Shop__Stock_Serials2__c newBit2ShopStockSerials = new Bit2Shop__Stock_Serials2__c();
      newBit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = oldStockSerials[0].Bit2Shop__Product_Stock_Id__c;
      Map<String, Bit2Shop__Stock_Serials2__c> newStockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
      newStockSerialsMap.put(newBit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c, newBit2ShopStockSerials);

      Test.startTest();
      Map<String, List<String>> stockSerialIdToErrorsMap1 = Plc_Utils.productStockQties.updateProductStockQuantities(oldStockSerialsMap, newStockSerialsMap);
      
      List<Bit2Shop__Stock_Serials2__c> oldStockSerials2 = oldStockSerials;
      oldStockSerials2[0].Bit2Shop__Status__c = 'Withdrawn';
      Map<String, Bit2Shop__Stock_Serials2__c> oldStockSerialsMap2 = oldStockSerialsMap;
      oldStockSerialsMap2.put(oldStockSerials2[0].Bit2Shop__Product_Stock_Id__c, oldStockSerials2[0]);
      Map<String, List<String>> stockSerialIdToErrorsMap2 = Plc_Utils.productStockQties.updateProductStockQuantities(oldStockSerialsMap2, newStockSerialsMap);
      Test.stopTest();
    }

	/************************************************/
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method isValid.
     */
    //@isTest
    static void isValidListFieldListMapTest(){      
      	List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderLineItem'};
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', null, null);
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga(null); //1234567980
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','posta','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        
      	Test.startTest();
      	String message = Plc_Utils.isValid(gestOrdReqBody, fieldList);

        gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', null, gestOrdReqBodyRigOrdLavs);
        String message2 = Plc_Utils.isValid(gestOrdReqBody, fieldList);
      	Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 02/01/2018
     * @version 1.0
     * @description Test of the method isValid when an innerField is null.
     */
    //@isTest
    static void isValidWhenobjectFieldListMapTest(){
      
      	List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
        
      	Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail posta
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
      	Test.startTest();
      	String returnedString = Plc_Utils.isValid(gestOrdReqBody, fieldList);
      	Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 02/01/2018
     * @version 1.0
     * @description Test of the method isValid when the length of a field > max.
     */
    //@isTest
    static void isValidWhenFieldLengthMapTest(){
      
      	List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
        
      	Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        //Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga(null);
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','postalCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
      	Test.startTest();
      	String returnedString = Plc_Utils.isValid(gestOrdReqBody, fieldList);
      	Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method isValid.
     */
    //@isTest
    static void isValidWhenObjectFieldListIsMapNullTest(){
      
      //Plc_Utils.objectFieldListMap = null;
      //Plc_Utils.listFieldListMap = null;
      
      List<String> fieldList = new List<String> {'resourceAlias', 'warehouseAlias', 'termId', 'requestType'};
      Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
           'Installation', '00541237896541230', '1234567980', '');
        
      Test.startTest();
      String message = Plc_Utils.isValid(gestionDisponibilita, fieldList);
        
      gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
           'Installation1234567980', '00541237896541230', '1234567980', '1526655');
      
      String message2 = Plc_Utils.isValid(gestionDisponibilita, fieldList);
      Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method parseFieldMapList.
     */
    //@isTest
    static void parseFieldMapListTest(){
     
       Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
           'Installation', '00541237896541230', '1234567980', '00789654123654789');
        
      Test.startTest();
      Plc_Utils.FieldMapList returnedString = Plc_Utils.parseFieldMapList(JSON.serialize(gestionDisponibilita));
      Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 12/03/2019
     * @version 1.0
     * @description Test of the method checkCrudObjcetPermission.
     */
    @isTest
    static void checkCrudObjectPermissionTest(){
        
        String salesforceObject='Bit2Shop__Dealer__c';
		
         Test.startTest();
         //if typology='SOQL'
     	 Boolean result = Plc_Utils.checkCrudObjectPermission(salesforceObject, 'SOQL');
         //if typology='DELETE'
     	 Boolean result2 = Plc_Utils.checkCrudObjectPermission(salesforceObject, 'DELETE');
		 //if typology='UPDATE'
     	 Boolean result3 = Plc_Utils.checkCrudObjectPermission(salesforceObject, 'UPDATE');
	  	 //if typology='INSERT'
     	 Boolean result4 = Plc_Utils.checkCrudObjectPermission(salesforceObject, 'INSERT');
         //when else typology
     	 Boolean result5 = Plc_Utils.checkCrudObjectPermission(salesforceObject, 'test');
	  	 Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 12/03/2019
     * @version 1.0
     * @description Test of the method createProductSerialStructure.
     */
    @isTest
    static void createProductSerialStructureTest(){
        
        Plc_Utils.Plc_ShipmentsUtils shipmentsUtils= new Plc_Utils.Plc_ShipmentsUtils();
        List<Bit2Shop__Stock_Serials2__c> selectedProductSerial = [SELECT Id,Bit2Shop__Product_Stock_Id__r.Name,
                                                                   Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c
                                                                   FROM Bit2Shop__Stock_Serials2__c];
        NE__Order__c configurationToCreate = [SELECT Id FROM NE__Order__c LIMIT 1];
        Bit2Shop__StockOrder__c stockOrderToCreate = [SELECT Id,Bit2Shop__Holding_Id__c,OwnerId,Bit2Shop__Destination_Warehouse_Id__c,
                                                      Plc_TransferDetail__c
                                                      FROM Bit2Shop__StockOrder__c LIMIT 1];
      
        Test.startTest();
        shipmentsUtils.createProductSerialStructure(selectedProductSerial,configurationToCreate,stockOrderToCreate,false);
        Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 13/03/2019
     * @version 1.0
     * @description Test of the method createProductQuantityStructure.
     */
    @isTest
    static void createProductQuantityStructureTest(){
        Plc_Utils.Plc_ShipmentsUtils shipmentsUtils= new Plc_Utils.Plc_ShipmentsUtils();
        
		List<Bit2Shop__Product_Stock__c> selectedProductQuantity=[SELECT Id,Name,Bit2Shop__Shipped_Qty__c,Bit2Shop__External_Catalog_Item_Id__c
                                                                  FROM Bit2Shop__Product_Stock__c];
        NE__Order__c configurationToCreate=[SELECT Id FROM NE__Order__c LIMIT 1];
        Bit2Shop__StockOrder__c stockOrderToCreate=[SELECT Id,Bit2Shop__Holding_Id__c,OwnerId,Bit2Shop__Destination_Warehouse_Id__c,Plc_TransferDetail__c
                                                    FROM Bit2Shop__StockOrder__c LIMIT 1];
        Test.startTest();
        shipmentsUtils.createProductQuantityStructure(selectedProductQuantity,configurationToCreate,stockOrderToCreate,false);
        Test.stopTest();
    }

    /**
     * @author FB
     * @date Creation 15/03/2019
     * @version 1.0
     * @description Test of the method createProductQuantityStructure.
     */
    /*
    @isTest
    static void retrieveAboveRolesTest() {

      UserRole childUserRole = [SELECT Id, Name, ParentRoleId 
                                FROM UserRole 
                                WHERE Name = 'SDM User AGT'
                                LIMIT 1];

      User u = Plc_WsTestFactory.createUser('ma', 'Magazziniere');
      u.UserRoleId = childUserRole.Id;

      Test.startTest();
      System.runAs(u) {
        Plc_Utils.retrieveAboveRoles(new Set<Id>{UserInfo.getUserRoleId()});
      }
      Test.stopTest();
    }
    */

    /**
     * @author FB
     * @date Creation 15/03/2019
     * @version 1.0
     * @description Test of the method createProductQuantityStructure.
     */
    @isTest
    static void isCurrentUserDealerGroupMemberTest() {

      Bit2Shop__Dealer__c dealer = [SELECT Id 
                                    FROM Bit2Shop__Dealer__c 
                                    LIMIT 1];

      Group g = [SELECT Id FROM Group LIMIT 1];
      dealer.Bit2Shop__Group_Id__c = g.Id;
      update dealer;

      Test.startTest();
      Plc_Utils.isCurrentUserDealerGroupMember('' + dealer.Id);
      Test.stopTest();
    }
    
}