/**
 * PLC Test Factory to create Web services objects for test classes
 *
 * @author FB
 * @version 1.0
 * @description Used to create Web services object for test classes
 * @testedIn Plc_TestFactoryWsTest
 * @errorcode [ERR:CL-000YYZZ]
 */
public class Plc_WsTestFactory {

	public final static String siteUrl = 'https://nexi-payments--devpos.cs102.my.salesforce.com/services/apexrest';

	/**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 27/11/2018
     * @version 1.0
     * @description Build the RestRequest
     * @param String uri This parameter is Uri of ths source.
     * @param String urlMapping This parameter is the name of the url Mapping.
     * @param String httpMethod This parameter is the name of the Http method
     * @return RestRequest.
     */
    public static RestRequest createRestRequest(String uri, String urlMapping, String httpMethod){
       
        Datetime dt = DateTime.newInstanceGMT(System.now().year(),System.now().month(),System.now().day(), System.now().hour(),System.now().minute(),System.now().second());
       // Build rest request
        RestRequest restRequest = new RestRequest();
        restRequest.requestURI  = siteUrl + urlMapping+ uri;
        restRequest.httpMethod = httpMethod;
        restRequest.params.put('timestamp',String.valueOf(dt.addDays(-1).getTime()));

        return restRequest;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 27/11/2018
     * @version 1.0
     * @description generate a GestioneDisponibilitaRequestBody
     * @param String requestType This parameter is the type of the GestioneDisponibilitaRequestBody.
     * @param String resourceAlias This parameter is the resource alias.
     * @param String termId this parameter the Id of the term
     * @param String solutionAlias This parameter is the solution alias.
     * @param String warehouseAlias This parameter is the warehouse alias.
     * @param String logisticsDivision This parameter is the logitics division.
     * @return Plc_Wrappers.GestioneDisponibilitaRequestBody.
     */
    public static Plc_Wrappers.GestioneDisponibilitaRequestBody 
        createGestioneDisponibilitaRequestBody(String requestType, String resourceAlias, 
                                            String termId,  String solutionAlias,
                                            String warehouseAlias, String logisticsDivision){
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestioneDisponibilitaRequestBody = new Plc_Wrappers.GestioneDisponibilitaRequestBody();
        gestioneDisponibilitaRequestBody.requestType = requestType;
        gestioneDisponibilitaRequestBody.resourceAlias = resourceAlias;
        gestioneDisponibilitaRequestBody.termId = termId;
        //gestioneDisponibilitaRequestBody.solutionAlias = solutionAlias;
        gestioneDisponibilitaRequestBody.warehouseAlias = warehouseAlias;
        //gestioneDisponibilitaRequestBody.logisticsDivision = logisticsDivision;

        return gestioneDisponibilitaRequestBody;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 27/11/2018
     * @version 1.0
     * @description generate a GestioneDisponibilitaRequestBody
     * @param String requestType This parameter is the type of the GestioneDisponibilitaRequestBody.
     * @param String resourceAlias This parameter is the resource alias.
     * @param String termId this parameter the Id of the term
     * @param String solutionAlias This parameter is the solution alias.
     * @param String warehouseAlias This parameter is the warehouse alias.
     * @return Plc_Wrappers.GestioneDisponibilitaRequestBody.
     */
    public static Plc_Wrappers.GestioneDisponibilitaRequestBody 
        createGestioneDisponibilitaRequestBody(String requestType, String resourceAlias, 
                                            String termId, String warehouseAlias){
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestioneDisponibilitaRequestBody = new Plc_Wrappers.GestioneDisponibilitaRequestBody();
        gestioneDisponibilitaRequestBody.requestType = requestType;
        gestioneDisponibilitaRequestBody.resourceAlias = resourceAlias;
        gestioneDisponibilitaRequestBody.termId = termId;
        //gestioneDisponibilitaRequestBody.solutionAlias = solutionAlias;
        gestioneDisponibilitaRequestBody.warehouseAlias = warehouseAlias;
        //gestioneDisponibilitaRequestBody.logisticsDivision = logisticsDivision;

        return gestioneDisponibilitaRequestBody;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 27/11/2018
     * @version 1.0
     * @description generate a GestioneOrdineRequestBody
     * @param String workOrderLegacyId This parameter is the workOrderLegacyId.
     * @param GestioneOrdineRequestBodyDettaglioOrdine workOrderDetail This parameter is the workOrder Detail.
     * @param GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem this parameter the workOrder LineItem
     * @return Plc_Wrappers.GestioneOrdineRequestBody.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBody createGestioneOrdineRequestBody(String workOrderLegacyId,
                                                                                     Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine workOrderDetail, 
                                                                                     List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> workOrderLineItem){
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = new Plc_Wrappers.GestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = workOrderLegacyId;
        gestOrdReqBody.workOrderDetail = workOrderDetail;
        gestOrdReqBody.workOrderLineItem = workOrderLineItem;

        return gestOrdReqBody;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 28/11/2018
     * @version 1.0
     * @description create an instance of GestioneOrdineRequestBodyRigheOrdineDiLavoro
     * @param String workOrderLineItemLegacyId This parameter is the name of WorkOrderLineItemLegacyId.
     * @param Plc_Wrappers.GestioneOrdineRequestBodyCausale cause This parameter is the object GestioneOrdineRequestBodyCausale.
     * @param Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga workOrderLineItemDetail is the object GestioneOrdineRequestBodyDettaglioRiga
     
     * @return Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro createGestioneOrdineRequestBodyRigheOrdineDiLavoro(String workOrderLineItemLegacyId, 
                                                                                                                            Plc_Wrappers.GestioneOrdineRequestBodyCausale cause,
                                                                                                                            Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga workOrderLineItemDetail){
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLav = new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
        
        gestOrdReqBodyRigOrdLav.workOrderLineItemLegacyId = workOrderLineItemLegacyId;
        gestOrdReqBodyRigOrdLav.cause = cause;
        gestOrdReqBodyRigOrdLav.workOrderLineItemDetail = workOrderLineItemDetail;
        return gestOrdReqBodyRigOrdLav;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 28/11/2018
     * @version 1.0
     * @description create an instance of getGestioneOrdineRequestBodyDettaglioRiga
     * @param String resourceAlias This parameter is the resource Alias.
     * @return Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga createGestioneOrdineRequestBodyDettaglioRiga(String resourceAlias) {

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRig = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRig.resourceAlias = resourceAlias;
        return gestOrdReqBodyDetRig;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 20/12/2018
     * @version 1.0
     * @description create an instance of getGestioneOrdineRequestBodyDettaglioRiga
     * @param String resourceAlias This parameter is the resource Alias.
     * @return Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga createGestioneOrdineRequestBodyDettaglioRiga(String operationType, String resourceAlias, String status) {

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRig = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRig.operationType = operationType;
        gestOrdReqBodyDetRig.resourceAlias = resourceAlias;
        gestOrdReqBodyDetRig.status = status;
        return gestOrdReqBodyDetRig;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 28/11/2018
     * @version 1.0
     * @description create an instance of InformazioniMatricolaRequestBody
     * @param String termId This parameter is the termId.
     * @return Plc_Wrappers.InformazioniMatricolaRequestBody.
     */
    public static Plc_Wrappers.InformazioniMatricolaRequestBody createInformazioniMatricolaRequestBody(String termId) {
        
        Plc_Wrappers.InformazioniMatricolaRequestBody informazioniMatricolaRequestBody = new Plc_Wrappers.InformazioniMatricolaRequestBody();
        informazioniMatricolaRequestBody.termId=termId;
        return informazioniMatricolaRequestBody;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 10/12/2018
     * @version 1.0
     * @description build an instance of GestioneOrdineRequestBodyDettaglioOrdine
     * @param String warehouseAlias This parameter is the alias of the warehous.
     * @param String requestType This parameter is the requestype alias.
     * @return Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine createGestioneOrdineRequestBodyDettaglioOrdine(String warehouseAlias, String requestType,  
                                                                                                                    String abi, String accountLegacyId, 
                                                                                                                    String address, String bankDescription,
                                                                                                                    String businessName, String status, 
                                                                                                                    String startDate, String endDate, String cti,
                                                                                                                    String category, String ctiType,
                                                                                                                    String dealerAlias, String province,
                                                                                                                    String vatNumber, String fiscalCode,
                                                                                                                    String siaCode, String shopLegacyId,
                                                                                                                    String signboard, String postalCode,
                                                                                                                    String locality,String prefix,
                                                                                                                    String phone,String mail, 
                                                                                                                    String supportPhoneNumber,String openingTime,
                                                                                                                    String referent,String notes){
                                                                                                              
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine();
        gestOrdReqDetOrd.warehouseAlias = warehouseAlias;
        gestOrdReqDetOrd.requestType = requestType;
        gestOrdReqDetOrd.abi = abi;
        gestOrdReqDetOrd.accountLegacyId = accountLegacyId;
        gestOrdReqDetOrd.address = address;
        gestOrdReqDetOrd.bankDescription = bankDescription;
        gestOrdReqDetOrd.businessName = businessName;
        //gestOrdReqDetOrd.category = category ;
        gestOrdReqDetOrd.cti = cti;
        gestOrdReqDetOrd.ctiType = ctiType;
        gestOrdReqDetOrd.dealerAlias = dealerAlias;
        gestOrdReqDetOrd.endDate = endDate;
        gestOrdReqDetOrd.startDate = startDate; 
        gestOrdReqDetOrd.status= status;
        gestOrdReqDetOrd.vatNumber=vatNumber ;
        gestOrdReqDetOrd.fiscalCode=fiscalCode ;
        gestOrdReqDetOrd.siaCode =siaCode;
        gestOrdReqDetOrd.shopLegacyId =shopLegacyId;
        gestOrdReqDetOrd.signboard =signboard;
        gestOrdReqDetOrd.postalCode =postalCode;
        gestOrdReqDetOrd.locality =locality;
        gestOrdReqDetOrd.province =province;
        gestOrdReqDetOrd.prefix =prefix;
        gestOrdReqDetOrd.phone =phone;
        gestOrdReqDetOrd.mail =mail;
        gestOrdReqDetOrd.supportPhoneNumber =supportPhoneNumber;
        gestOrdReqDetOrd.openingTime =openingTime;
        gestOrdReqDetOrd.referent =referent;
        gestOrdReqDetOrd.notes =notes;

        return gestOrdReqDetOrd;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 10/12/2018
     * @version 1.0
     * @description build an instance of GestioneOrdineRequestBodyCausale
     * @param String blockCode This parameter is the blockCode.
     * @param String requestType This parameter is the blockDescription.
     * @return Plc_Wrappers.GestioneOrdineRequestBodyCausale.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyCausale createGestioneOrdineRequestBodyCausale(String blockCode, String blockDescription){

        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = new Plc_Wrappers.GestioneOrdineRequestBodyCausale();
        gestOrdReqBodCause.blockCode = blockCode;
        gestOrdReqBodCause.blockDescription = blockDescription;
        return gestOrdReqBodCause;
    }

    public static Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga createGestioneOrdineRequestBodyDettaglioRiga(String operationType, String status, String serialNumber,
                                                                                                              String reservationId, String bundleId, String termId,
                                                                                                              String generationDate, String resourceAlias, String notes) {
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRig = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRig.operationType = operationType;
        gestOrdReqBodyDetRig.status = status;
        gestOrdReqBodyDetRig.serialNumber = serialNumber;
        gestOrdReqBodyDetRig.reservationId = reservationId;
        gestOrdReqBodyDetRig.bundleId = bundleId;
        gestOrdReqBodyDetRig.termId = termId;
        gestOrdReqBodyDetRig.generationDate = generationDate;
        gestOrdReqBodyDetRig.resourceAlias = resourceAlias;
        gestOrdReqBodyDetRig.notes = notes;

        return gestOrdReqBodyDetRig;
    }
    
    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 18/12/2018
     * @version 1.0
     * @description create an instance of getGestioneOrdineRequestBodyDettaglioRiga
     * @param String resourceAlias This parameter is the resource Alias.
     * @return Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga.
     */
    public static Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga createGestioneOrdineRequestBodyDettaglioRiga(String resourceAlias, 
                                                                            String operationType, String status, String generationDate,
                                                                            String notes) {

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRig = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRig.resourceAlias = resourceAlias;
        gestOrdReqBodyDetRig.operationType = operationType;
        gestOrdReqBodyDetRig.status = status;
        gestOrdReqBodyDetRig.generationDate = generationDate;
        gestOrdReqBodyDetRig.notes = notes;
        return gestOrdReqBodyDetRig;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 05/02/2019
     * @version 1.0
     * @description return an instance of GestioneOrdineRequest
     */
    public static Plc_Wrappers.GestioneOrdineRequest createGestioneOrdineRequest( ){

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('123456789');
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';

        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('123456789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', cause, gestOrdReqBodyDetRiga);

        //workOrderLineItem
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
      
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;

        return gestOrdReq;
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 05/02/2019
     * @version 1.0
     * @description return an instance of Plc_Wrappers.GestioneOrdineRequestBody
     */
    public static Plc_Wrappers.GestioneOrdineRequestBody createGestioneOrdineRequestBody() {

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('123456789');
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';

        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('123456789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'Assigned', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', cause, gestOrdReqBodyDetRiga);

        //workOrderLineItem
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
      
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);

        return gestOrdReqBody;
    }
}