/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC Wrappers.
 */
@isTest
public class Plc_WrappersTest {

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method gestioneDisponibilitaRequestParse.
    * @param: Json (String)
    * @return type: Plc_Wrappers.GestioneDisponibilitaRequest
    */
    @isTest static void gestioneDisponibilitaRequestParseTest(){

    Plc_Wrappers.GestioneDisponibilitaRequestBody gestioneDisponibilitaRequestBody= Plc_WsTestFactory.createGestioneDisponibilitaRequestBody('','','','');
  
    Plc_Wrappers.AggiornaTermIdRequestBody aggiornaTermIdRequestBody=new Plc_Wrappers.AggiornaTermIdRequestBody();
    Plc_Wrappers.AggiornaTermIdRequest aggiornaTermIdRequest=new Plc_Wrappers.AggiornaTermIdRequest();
    aggiornaTermIdRequest.termIdList= new List<Plc_Wrappers.AggiornaTermIdRequestBody>{aggiornaTermIdRequestBody}; 
       
    Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();    
    gestioneDisponibilitaRequest.request.add(gestioneDisponibilitaRequestBody);
        
    Test.startTest();
    Plc_Wrappers.GestioneDisponibilitaRequest response= Plc_Wrappers.gestioneDisponibilitaRequestParse(JSON.serialize(gestioneDisponibilitaRequest));
    Test.stopTest();
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method gestioneDisponibilitaRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneDisponibilitaRequestBody
    */
    @isTest static void gestioneDisponibilitaRequestBodyParseTest(){

    Plc_Wrappers.VerificaDisponibilitaResponseData verificaDisponibilitaResponseData=new Plc_Wrappers.VerificaDisponibilitaResponseData();
    verificaDisponibilitaResponseData.termId='';
    verificaDisponibilitaResponseData.resourceAlias='';
    verificaDisponibilitaResponseData.available=true;
    verificaDisponibilitaResponseData.outcomeMessage='';
        
    Plc_Wrappers.PrenotaDisponibilitaResponseData prenotaDisponibilitaResponseData=new Plc_Wrappers.PrenotaDisponibilitaResponseData();
    prenotaDisponibilitaResponseData.reservationId='';
    prenotaDisponibilitaResponseData.termId='';
    prenotaDisponibilitaResponseData.reserved=true;
    prenotaDisponibilitaResponseData.outcomeMessage='';

    Plc_Wrappers.GestioneDisponibilitaRequestBody gestioneDisponibilitaRequestBody= Plc_WsTestFactory.createGestioneDisponibilitaRequestBody('','','','');

 
    Test.startTest();
    Plc_Wrappers.GestioneDisponibilitaRequestBody response= Plc_Wrappers.gestioneDisponibilitaRequestBodyParse(JSON.serialize(gestioneDisponibilitaRequestBody));
    Test.stopTest();
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method requestGestioneOrdineParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneOrdineRequest
    */
    @isTest
    static void gestioneOrdineRequestTest(){
        
    Plc_Wrappers.GestioneOrdineRequest gestorrdReq= new Plc_Wrappers.GestioneOrdineRequest();
        
    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequest response= Plc_Wrappers.requestGestioneOrdineParse(JSON.serialize(gestorrdReq));
    Test.stopTest();
        
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro
    */ 
    @isTest static void parseTestReturningGestioneOrdineRequestBodyRigheOrdineDiLavoro(){

    Plc_Wrappers.CreaEvadiOrdineResponseData creaEvadiOrdineResponseData=new Plc_Wrappers.CreaEvadiOrdineResponseData();   
    creaEvadiOrdineResponseData.workOrderId='';
    creaEvadiOrdineResponseData.workOrderLegacyId='';
    creaEvadiOrdineResponseData.created=true;
    creaEvadiOrdineResponseData.outcomeMessage='';
        
    Plc_Wrappers.AggiornaOrdineResponseData aggiornaOrdineResponseData=new Plc_Wrappers.AggiornaOrdineResponseData();   
    aggiornaOrdineResponseData.workOrderId='';
    aggiornaOrdineResponseData.workOrderLegacyId='';
    aggiornaOrdineResponseData.updated=true;
    aggiornaOrdineResponseData.outcomeMessage='';

    Plc_Wrappers.BloccoSbloccoResponseData bloccoSbloccoResponseData=new Plc_Wrappers.BloccoSbloccoResponseData();   
    bloccoSbloccoResponseData.workOrderId='';
    bloccoSbloccoResponseData.workOrderLegacyId='';
    bloccoSbloccoResponseData.updated=true;
    bloccoSbloccoResponseData.termId='';
    bloccoSbloccoResponseData.outcomeMessage='';    
        
    Plc_Wrappers.InformazioniMatricolaRequestBody informazioniMatricolaRequestBody=new Plc_Wrappers.InformazioniMatricolaRequestBody();
    informazioniMatricolaRequestBody.termId='';
    
    Plc_Wrappers.InformazioniMatricolaRequest informazioniMatricolaRequest=new Plc_Wrappers.InformazioniMatricolaRequest();
	informazioniMatricolaRequest.request.add(informazioniMatricolaRequestBody);
              
    Plc_Wrappers.AggiornaTermIdRequestBody aggiornaTermIdRequestBody=new Plc_Wrappers.AggiornaTermIdRequestBody();
    aggiornaTermIdRequestBody.oldTermId='';
    aggiornaTermIdRequestBody.newTermId=''; 
              
    Plc_Wrappers.AnnullaImpegnoResponseData annullaImpegnoResponseData=new Plc_Wrappers.AnnullaImpegnoResponseData();   
    annullaImpegnoResponseData.termId='';
    annullaImpegnoResponseData.reservationId='';
    annullaImpegnoResponseData.cancelled=true;
    annullaImpegnoResponseData.outcomeMessage='';
        
    Plc_Wrappers.AggiornaTermIdResponseData aggiornaTermIdResponseData=new Plc_Wrappers.AggiornaTermIdResponseData();   
    aggiornaTermIdResponseData.oldTermId='';
    aggiornaTermIdResponseData.newTermId='';
    aggiornaTermIdResponseData.updated=true;
    aggiornaTermIdResponseData.outcomeMessage='';    

    Plc_Wrappers.AnnullaImpegnoRequest annullaImpegnoRequest= new Plc_Wrappers.AnnullaImpegnoRequest();     
    Plc_Wrappers.AnnullaImpegnoRequestBody annullaImpegnoRequestBody=new Plc_Wrappers.AnnullaImpegnoRequestBody();
    annullaImpegnoRequestBody.termId='';
    annullaImpegnoRequestBody.reservationId='';  

    annullaImpegnoRequest.workOrder=new List<Plc_Wrappers.AnnullaImpegnoRequestBody>{annullaImpegnoRequestBody};
       
    Plc_Wrappers.InformazioniMatricolaResponseData informazioniMatricolaResponseData=new Plc_Wrappers.InformazioniMatricolaResponseData();   
    informazioniMatricolaResponseData.termId='';
    informazioniMatricolaResponseData.serialNumber='';
    informazioniMatricolaResponseData.status='';
    informazioniMatricolaResponseData.warehouseAlias='';
    informazioniMatricolaResponseData.maker='';
    informazioniMatricolaResponseData.outcomeMessage='';
    informazioniMatricolaResponseData.property='';
    informazioniMatricolaResponseData.PTSCode='';
    informazioniMatricolaResponseData.ICCID='';
    informazioniMatricolaResponseData.IMEI='';
    informazioniMatricolaResponseData.PCIPEDModel='';
    informazioniMatricolaResponseData.PCIPEDLetterofApproval='';
    informazioniMatricolaResponseData.PCIPEDApprovalNr='';
    informazioniMatricolaResponseData.PCIPEDVersion='';
    informazioniMatricolaResponseData.PCIPEDExpirydate='';    

    Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData verificaMatricolaPerEvasioneResponseData = new Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData();
    verificaMatricolaPerEvasioneResponseData.workOrderLegacyId = '';
    verificaMatricolaPerEvasioneResponseData.workOrderLineItemLegacyId = '';
    verificaMatricolaPerEvasioneResponseData.serialNumber = '';
    verificaMatricolaPerEvasioneResponseData.usable = true;
    verificaMatricolaPerEvasioneResponseData.outcomeMessage = '';
    
                      
    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestioneOrdineRequestBodyDettaglioRiga=new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
   	gestioneOrdineRequestBodyDettaglioRiga.operationType='';
    gestioneOrdineRequestBodyDettaglioRiga.status='';
    gestioneOrdineRequestBodyDettaglioRiga.serialNumber='';
    gestioneOrdineRequestBodyDettaglioRiga.reservationId='';
    gestioneOrdineRequestBodyDettaglioRiga.bundleId='';
    gestioneOrdineRequestBodyDettaglioRiga.termId='';
    gestioneOrdineRequestBodyDettaglioRiga.generationDate='';
    gestioneOrdineRequestBodyDettaglioRiga.resourceAlias='';
    gestioneOrdineRequestBodyDettaglioRiga.notes='';
    gestioneOrdineRequestBodyDettaglioRiga.parent='';    
      
    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','postalCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
    
             
    Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestordineReqBody=new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();   

    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro response= gestordineReqBody.parse(JSON.serialize(gestordineReqBody));
    Test.stopTest();
        
   }
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method gestioneOrdineRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneOrdineRequestBody
    */
    @isTest static void gestioneOrdineRequestBodyParseTest(){
     
    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','postalCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
   
    Plc_Wrappers.GestioneOrdineRequestBodyCausale gestioneOrdineRequestBodyCausale=new Plc_Wrappers.GestioneOrdineRequestBodyCausale();   
    gestioneOrdineRequestBodyCausale.blockCode='';
    gestioneOrdineRequestBodyCausale.blockDescription='';

    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestioneOrdineRequestBodyDettaglioRiga=new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga() ;
    
    Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestioneOrdineRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
    gestioneOrdineRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='';
    gestioneOrdineRequestBodyRigheOrdineDiLavoro.cause=gestioneOrdineRequestBodyCausale;
    gestioneOrdineRequestBodyRigheOrdineDiLavoro.workOrderLineItemDetail=gestioneOrdineRequestBodyDettaglioRiga;
        
 	Plc_Wrappers.GestioneOrdineRequest gestioneOrdineRequest=new Plc_Wrappers.GestioneOrdineRequest();
    Plc_Wrappers.GestioneOrdineRequestBody gestioneOrdineRequestBody=new Plc_Wrappers.GestioneOrdineRequestBody();
    gestioneOrdineRequest.workOrder= new List<Plc_Wrappers.GestioneOrdineRequestBody>{gestioneOrdineRequestBody};
        
    gestioneOrdineRequestBody.workOrderLegacyId='';
    gestioneOrdineRequestBody.workOrderDetail=gestOrdReqDetOrd;
    gestioneOrdineRequestBody.workOrderLineItem=new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>{gestioneOrdineRequestBodyRigheOrdineDiLavoro};
        
    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequestBody response= Plc_Wrappers.gestioneOrdineRequestBodyParse(JSON.serialize(gestioneOrdineRequestBody));
    Test.stopTest();
        
   }
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method InformazioniMatricolaRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.InformazioniMatricolaRequestBody
    */
    @isTest static void InformazioniMatricolaRequestBodyParseTest(){
        
    Plc_Wrappers.InformazioniMatricolaRequestBody informazioniMatricolaRequestBody=new Plc_Wrappers.InformazioniMatricolaRequestBody();
    informazioniMatricolaRequestBody.termId='';
        
    Test.startTest();
    Plc_Wrappers.InformazioniMatricolaRequestBody response= Plc_Wrappers.InformazioniMatricolaRequestBodyParse(JSON.serialize(informazioniMatricolaRequestBody));
    Test.stopTest();
        
   } 
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/05/2019
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro
    */
    
	@isTest
    static void parseTestReturningVerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro(){

    Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequest verificaMatricolaPerEvasioneRequest=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequest();   
    verificaMatricolaPerEvasioneRequest.workOrder=new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro>{verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro};
    
    Test.startTest();
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro response= Plc_Wrappers.verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoroParse(JSON.serialize(verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro));
    Test.stopTest();
        
   }
   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro
    */
	@isTest
    static void parseTestReturningVerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro(){

    Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
    verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='';
    verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='';
        
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
    verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro.workOrderLineItem=new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>{verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro};
    verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro.workOrderLegacyId='';        
 
    Test.startTest();
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro response= verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.parse(JSON.serialize(verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro));
    Test.stopTest();
        
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method AnnullaImpegnoRequestParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.AnnullaImpegnoRequest
    */
	@isTest 
    static void AnnullaImpegnoRequestParseTest(){
        
    Plc_Wrappers.AnnullaImpegnoRequest annullaImpegnoRequest= new Plc_Wrappers.AnnullaImpegnoRequest(); 
        
    Test.startTest();
    Plc_Wrappers.AnnullaImpegnoRequest response= Plc_Wrappers.AnnullaImpegnoRequestParse(JSON.serialize(annullaImpegnoRequest));
    Test.stopTest();
        
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine
    */
	@isTest 
    static void parseTestWithGestioneOrdineRequestBodyDettaglioOrdine(){

    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestordineReqBody=new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine();   
    
    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine response= gestordineReqBody.parse(JSON.serialize(gestordineReqBody));
    Test.stopTest();
        
   }
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga
    */
   	@isTest 
    static void parseTestReturningGestioneOrdineRequestBodyDettaglioRiga(){

    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestordineReqBody=new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();   
    
    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga response= gestordineReqBody.parse(JSON.serialize(gestordineReqBody));
    Test.stopTest();
        
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    */
   	@isTest 
    static void parseTestReturningGestioneOrdineRequestBodyCausale(){

    Plc_Wrappers.GestioneOrdineRequestBodyCausale gestordineReqBody=new Plc_Wrappers.GestioneOrdineRequestBodyCausale();   
    
    Test.startTest();
    Plc_Wrappers.GestioneOrdineRequestBodyCausale response= gestordineReqBody.parse(JSON.serialize(gestordineReqBody));
    Test.stopTest();
        
   }
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method VerificaMatricolaPerEvasioneRequestParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.VerificaMatricolaPerEvasioneRequest
    */
    @isTest static void VerificaMatricolaPerEvasioneRequestParseTest(){
    
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequest verificaMatricolaPerEvasioneRequest=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequest();   
    
    Test.startTest();
    Plc_Wrappers.VerificaMatricolaPerEvasioneRequest response= Plc_Wrappers.VerificaMatricolaPerEvasioneRequestParse(JSON.serialize(verificaMatricolaPerEvasioneRequest));
    Test.stopTest();
        
   } 
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method parse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.AggiornaTermIdRequestBody
    */
    @isTest static void parseTestReturningAggiornaTermIdRequestBody(){

    Plc_Wrappers.AggiornaTermIdRequestBody aggiornaTermIdRequestBody=new Plc_Wrappers.AggiornaTermIdRequestBody();

    Test.startTest();
    Plc_Wrappers.AggiornaTermIdRequestBody response= Plc_Wrappers.AggiornaTermIdRequestBodyParse(JSON.serialize(aggiornaTermIdRequestBody));
    Test.stopTest();
        
   }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method AggiornaTermIdRequestParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.AggiornaTermIdRequest
    */
    @isTest static void AggiornaTermIdRequestParseTest(){
    
    Plc_Wrappers.AggiornaTermIdRequestBody aggiornaTermIdRequestBody=new Plc_Wrappers.AggiornaTermIdRequestBody();

    Test.startTest();
    Plc_Wrappers.AggiornaTermIdRequest response= Plc_Wrappers.AggiornaTermIdRequestParse(JSON.serialize(aggiornaTermIdRequestBody));
    Test.stopTest();
        
   } 
        
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 26/12/2018
    * @version 1.0
    * @description Test of the method informazioniMatricolaRequestParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.InformazioniMatricolaRequest
    */
    @isTest static void informazioniMatricolaRequestParseTest(){
    Plc_Wrappers.InformazioniMatricolaResponseData informazioniMatricolaResponseData=new Plc_Wrappers.InformazioniMatricolaResponseData();   
    informazioniMatricolaResponseData.termId='';
    informazioniMatricolaResponseData.serialNumber='';
    informazioniMatricolaResponseData.status='';
    informazioniMatricolaResponseData.warehouseAlias='';
    informazioniMatricolaResponseData.maker='';
    informazioniMatricolaResponseData.outcomeMessage='';
    informazioniMatricolaResponseData.property='';
    informazioniMatricolaResponseData.PTSCode='';
    informazioniMatricolaResponseData.ICCID='';
    informazioniMatricolaResponseData.IMEI='';
    informazioniMatricolaResponseData.PCIPEDModel='';
    informazioniMatricolaResponseData.PCIPEDLetterofApproval='';
    informazioniMatricolaResponseData.PCIPEDApprovalNr='';
    informazioniMatricolaResponseData.PCIPEDVersion='';
    informazioniMatricolaResponseData.PCIPEDExpirydate='';    
                      
    Test.startTest();
    Plc_Wrappers.InformazioniMatricolaRequest response= Plc_Wrappers.informazioniMatricolaRequestParse(JSON.serialize(informazioniMatricolaResponseData));
    Test.stopTest();
        
   }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/01/2019
    * @version 1.0
    * @description Test of the method AnnullaImpegnoRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.AnnullaImpegnoRequestBody
    */
    @isTest
    static void annullaImpegnoRequestBodyParseTest() {

    Plc_Wrappers.AnnullaImpegnoRequestBody annullaImpegnoRequestBody=new Plc_Wrappers.AnnullaImpegnoRequestBody();
    annullaImpegnoRequestBody.termId='';
    annullaImpegnoRequestBody.reservationId=''; 

    Test.startTest();
    Plc_Wrappers.AnnullaImpegnoRequestBody response= Plc_Wrappers.AnnullaImpegnoRequestBodyParse(JSON.serialize(annullaImpegnoRequestBody));
    Test.stopTest();

    }


    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/01/2019
    * @version 1.0
    * @description Test of the method BloccaWorkOrderRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.BloccaWorkOrderRequest
    */
    @isTest
    static void bloccaWorkOrderRequestParseTest() {

    Plc_Wrappers.BloccaWorkOrderRequestBody bloccaWorkOrderRequestBody=new Plc_Wrappers.BloccaWorkOrderRequestBody();
    bloccaWorkOrderRequestBody.termId='';
    bloccaWorkOrderRequestBody.reservationId=''; 

    Plc_Wrappers.BloccaWorkOrderRequest bloccaWorkOrderRequest = new Plc_Wrappers.BloccaWorkOrderRequest();
    bloccaWorkOrderRequest.workOrder=new List<Plc_Wrappers.BloccaWorkOrderRequestBody>{bloccaWorkOrderRequestBody};

    Test.startTest();
    Plc_Wrappers.BloccaWorkOrderRequest response= Plc_Wrappers.BloccaWorkOrderRequestParse(JSON.serialize(bloccaWorkOrderRequest));
    Test.stopTest();
        
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/01/2019
    * @version 1.0
    * @description Test of the method BloccaWorkOrderRequestBodyParse.
    * @param: Json (String)
    * @return type : Plc_Wrappers.BloccaWorkOrderRequestBody
    */
    @isTest
    static void bloccaWorkOrderRequestBodyParseTest() {

    Plc_Wrappers.BloccaWorkOrderRequestBody bloccaWorkOrderRequestBody=new Plc_Wrappers.BloccaWorkOrderRequestBody();
    bloccaWorkOrderRequestBody.termId='';
    bloccaWorkOrderRequestBody.reservationId=''; 

    Test.startTest();
    Plc_Wrappers.BloccaWorkOrderRequestBody response= Plc_Wrappers.BloccaWorkOrderRequestBodyParse(JSON.serialize(bloccaWorkOrderRequestBody));
    Test.stopTest();
        
    }


}