/**
 * Plc Wrappers collector
 *
 * @author Dam Kebe
 * @version 1.0
 * @description PLC Wrappers collector
 * @testedIn Plc_WrappersTst_1_0
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2017-11-22 : Dam Kebe
 */
public with sharing class Plc_Wrappers {
    
    /*BEGIN Gestione Disponibilita*/
    //_01 - verificaDisponibilita
    //_02 - prenotaDisponibilita
    public class GestioneDisponibilitaRequest {

        public List<GestioneDisponibilitaRequestBody> request {get;set;}{request = new List<GestioneDisponibilitaRequestBody>();}

    }
    public static GestioneDisponibilitaRequest gestioneDisponibilitaRequestParse(String json) {
        return (GestioneDisponibilitaRequest) System.JSON.deserialize(json, GestioneDisponibilitaRequest.class);
    }

    public class GestioneDisponibilitaRequestBody {
        public String requestType {get;set;}
        public String termId {get;set;}
        public String resourceAlias {get;set;}
        public String warehouseAlias {get;set;}
    }

    public static GestioneDisponibilitaRequestBody gestioneDisponibilitaRequestBodyParse(String json) {
        return (GestioneDisponibilitaRequestBody) System.JSON.deserialize(json, GestioneDisponibilitaRequestBody.class);
    }

    public class VerificaDisponibilitaResponseData {

        public String termId {get;set;}
        public String resourceAlias {get;set;}
        public Boolean available {get;set;}
        public String outcomeMessage {get;set;}
    }

    public class PrenotaDisponibilitaResponseData {

        public String reservationId {get;set;}
        public String termId {get;set;}
        public Boolean reserved {get;set;}
        public String outcomeMessage {get;set;}
    }
    /*END Gestione Disponibilita*/

    /*BEGIN Gestione Ordine*/
    //_03 - creaOrdine
    //_04 - aggiornaOrdine
    //_05 - bloccaRigheOrdine
    //_06 - sbloccaRigheOrdine
    //_07 - evasioneOrdine
    public class GestioneOrdineRequest {
        
        public List<GestioneOrdineRequestBody> workOrder {get;set;}{workOrder = new List<GestioneOrdineRequestBody>();}

    }
    public static GestioneOrdineRequest requestGestioneOrdineParse(String json) {
        return (GestioneOrdineRequest) System.JSON.deserialize(json, GestioneOrdineRequest.class);
    }

    public class GestioneOrdineRequestBody {
        public String workOrderLegacyId {get;set;}
        public GestioneOrdineRequestBodyDettaglioOrdine workOrderDetail {get;set;}
        public List<GestioneOrdineRequestBodyRigheOrdineDiLavoro> workOrderLineItem {get;set;}

    }
    public static GestioneOrdineRequestBody gestioneOrdineRequestBodyParse(String json) {
        return (GestioneOrdineRequestBody) System.JSON.deserialize(json, GestioneOrdineRequestBody.class);
    }

    public class GestioneOrdineRequestBodyRigheOrdineDiLavoro {
        public String workOrderLineItemLegacyId {get;set;}
        public GestioneOrdineRequestBodyCausale cause {get;set;}
        public GestioneOrdineRequestBodyDettaglioRiga workOrderLineItemDetail {get;set;}

        public GestioneOrdineRequestBodyRigheOrdineDiLavoro parse(String json) {
            return (GestioneOrdineRequestBodyRigheOrdineDiLavoro) System.JSON.deserialize(json, GestioneOrdineRequestBodyRigheOrdineDiLavoro.class);
        }
    }
    public class GestioneOrdineRequestBodyDettaglioOrdine {

        public String requestType {get;set;}
        public String status {get;set;}
        public String startDate {get;set;}
        public String endDate {get;set;}
        public String dealerAlias {get;set;}
        public String warehouseAlias {get;set;}
        public String abi {get;set;}
        public String bankDescription {get;set;}
        public String businessName {get;set;}
        public String vatNumber {get;set;}
        public String fiscalCode {get;set;}
        public String siaCode {get;set;}
        public String accountLegacyId {get;set;}
        public String shopLegacyId {get;set;}
        public String signboard {get;set;}
        public String address {get;set;}
        public String postalCode {get;set;}
        public String locality {get;set;}
        public String province {get;set;}
        public String prefix {get;set;}
        public String phone {get;set;}
        public String mail {get;set;}
        public String cti {get;set;}
        public String ctiType {get;set;}
        public String supportPhoneNumber {get;set;}
        public String openingTime {get;set;}
        public String referent {get;set;}
        public String notes {get;set;}
        
        public GestioneOrdineRequestBodyDettaglioOrdine parse(String json) {
            return (GestioneOrdineRequestBodyDettaglioOrdine) System.JSON.deserialize(json, GestioneOrdineRequestBodyDettaglioOrdine.class);
        }
    }

    public class GestioneOrdineRequestBodyDettaglioRiga {
        public String operationType {get;set;}
        public String status {get;set;}
        public String parent {get;set;}
        public String serialNumber {get;set;}
        public String reservationId {get;set;}
        public String bundleId {get;set;}
        public String termIdOld {get;set;}
        public String termId {get;set;}
        public String generationDate {get;set;}
        public String resourceAlias {get;set;}
        public String notes {get;set;}

        public GestioneOrdineRequestBodyDettaglioRiga parse(String json) {
            return (GestioneOrdineRequestBodyDettaglioRiga) System.JSON.deserialize(json, GestioneOrdineRequestBodyDettaglioRiga.class);
        }
    }

    public class GestioneOrdineRequestBodyCausale {

        public String blockCode {get;set;}
        public String blockDescription {get;set;}

        
        public GestioneOrdineRequestBodyCausale parse(String json) {
            return (GestioneOrdineRequestBodyCausale) System.JSON.deserialize(json, GestioneOrdineRequestBodyCausale.class);
        }
    }

    public class CreaEvadiOrdineResponseData {

        public String workOrderId {get;set;}
        public String workOrderLegacyId {get;set;}
        public Boolean created {get;set;}
        public String outcomeMessage {get;set;}
    }

    public class AggiornaOrdineResponseData {

        public String workOrderId {get;set;}
        public String workOrderLegacyId {get;set;}
        public Boolean updated {get;set;}
        public String outcomeMessage {get;set;}
    }

    public class BloccoSbloccoResponseData {

        public String workOrderId {get;set;}
        public String workOrderLegacyId {get;set;}
        public String termId {get;set;}
        public Boolean updated {get;set;}
        public String outcomeMessage {get;set;}
    }
    /*END Gestione Ordine*/

    /*BEGIN informazioniMatricola*/
    public class InformazioniMatricolaRequest {

        public List<InformazioniMatricolaRequestBody> request {get; set;} {request = new List<InformazioniMatricolaRequestBody>();}

    }
    public static InformazioniMatricolaRequest informazioniMatricolaRequestParse(String json) {
        return (InformazioniMatricolaRequest) System.JSON.deserialize(json, InformazioniMatricolaRequest.class);
    }

    public class InformazioniMatricolaRequestBody {
        public String termId {get; set;}

    }
    public static InformazioniMatricolaRequestBody InformazioniMatricolaRequestBodyParse(String json) {
        return (InformazioniMatricolaRequestBody) System.JSON.deserialize(json, InformazioniMatricolaRequestBody.class);
    }

    public class InformazioniMatricolaResponseData {

        public String termId {get; set;}
        public String serialNumber {get; set;}
        public String status {get; set;}
        public String warehouseAlias {get; set;}
        public String maker {get; set;}
        public String outcomeMessage {get; set;}
        public String property {get; set;}
        public String PTSCode {get; set;}
        public String ICCID {get; set;}
        public String IMEI {get; set;}
        public String PCIPEDModel {get; set;}
        public String PCIPEDLetterofApproval {get; set;}
        public String PCIPEDApprovalNr {get; set;}
        public String PCIPEDVersion {get; set;}
        public String PCIPEDExpirydate {get; set;}

    }
    /*END informazioniMatricola*/

    /*BEGIN aggiornaTermId*/
    public class AggiornaTermIdRequest {

        public List<AggiornaTermIdRequestBody> termIdList {get;set;}
    }

    public static AggiornaTermIdRequest AggiornaTermIdRequestParse(String json) {
        return (AggiornaTermIdRequest) System.JSON.deserialize(json, AggiornaTermIdRequest.class);
    }
    public class AggiornaTermIdRequestBody {

        public String oldTermId {get;set;}
        public String newTermId {get;set;}
    }

    public static AggiornaTermIdRequestBody AggiornaTermIdRequestBodyParse(String json) {
        return (AggiornaTermIdRequestBody) System.JSON.deserialize(json, AggiornaTermIdRequestBody.class);
    }

    public class AggiornaTermIdResponseData {

        public String oldTermId {get;set;}
        public String newTermId {get;set;}
        public Boolean updated {get;set;}
        public String outcomeMessage {get;set;}
    }
    /*END aggiornaTermId*/

    /*BEGIN verificaMatricolaPerEvasione*/
    public class VerificaMatricolaPerEvasioneRequest {

        public List<VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro> workOrder {get;set;}

    }
    public static VerificaMatricolaPerEvasioneRequest VerificaMatricolaPerEvasioneRequestParse(String json) {
        return (VerificaMatricolaPerEvasioneRequest) System.JSON.deserialize(json, VerificaMatricolaPerEvasioneRequest.class);
    }

    public class VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro {
        public String workOrderLegacyId {get;set;}
        public List<VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem {get;set;}

    }
    public static VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoroParse(String json) {
        return (VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro) System.JSON.deserialize(json, VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro.class);
    }

    public class VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro {
        public String workOrderLineItemLegacyId {get;set;}
        public String serialNumber {get;set;}

        public VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro parse(String json) {
            return (VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro) System.JSON.deserialize(json, VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.class);
        }
    }

    public class VerificaMatricolaPerEvasioneResponseData {

        public String workOrderLegacyId {get;set;}
        public String workOrderLineItemLegacyId {get;set;}
        public String serialNumber {get;set;}
        public Boolean usable {get;set;}
        public String outcomeMessage {get;set;}
    }
    /*END verificaMatricolaPerEvasione*/

    /*BEGIN AnnullaImpegno*/
    public class AnnullaImpegnoRequest {

        public List<AnnullaImpegnoRequestBody> workOrder {get;set;}
    }
    public static AnnullaImpegnoRequest AnnullaImpegnoRequestParse(String json) {
        return (AnnullaImpegnoRequest) System.JSON.deserialize(json, AnnullaImpegnoRequest.class);
    }

    public class AnnullaImpegnoRequestBody {
        public String termId {get;set;}
        public String reservationId {get;set;}
    }
    public static AnnullaImpegnoRequestBody AnnullaImpegnoRequestBodyParse(String json) {
        return (AnnullaImpegnoRequestBody) System.JSON.deserialize(json, AnnullaImpegnoRequestBody.class);
    }

    public class AnnullaImpegnoResponseData {
        public String termId {get;set;}
        public String reservationId {get;set;}
        public Boolean cancelled {get;set;}
        public String outcomeMessage {get;set;}
    }
    /*END AnnullaImpegno*/

    public class BloccaWorkOrderRequest {

        public List<BloccaWorkOrderRequestBody> workOrder {get;set;}
    }

    public static BloccaWorkOrderRequest BloccaWorkOrderRequestParse(String json) {
        return (BloccaWorkOrderRequest) System.JSON.deserialize(json, BloccaWorkOrderRequest.class);
    }

    public class BloccaWorkOrderRequestBody {
        public String termId {get;set;}
        public String reservationId {get;set;}
    }
    
    public static BloccaWorkOrderRequestBody BloccaWorkOrderRequestBodyParse(String json) {
        return (BloccaWorkOrderRequestBody) System.JSON.deserialize(json, BloccaWorkOrderRequestBody.class);
    }

    public class BloccaWorkOrderResponseData {
        public String workOrderId;
        public String workOrderLegacyId;
        public Boolean updated;
        public String outcomeMessage;
    }

    public class retryData {
        public String messageid;
        public String retry;
    }

    public class retryDataResponseCreate{
        public Plc_Wrappers.results results;
        public Plc_Wrappers.dataCreate data;
    }
    public class dataCreate{
        public string outcomeMessage;
        public string created;
        public string workOrderId;
        public string workOrderLegacyId;
    }
    public class retryDataResponseUpdate{
        public Plc_Wrappers.results results;
        public Plc_Wrappers.dataUpdate data;
    }
    public class dataUpdate{
        public string outcomeMessage;
        public string updated;
        public string workOrderId;
        public string workOrderLegacyId;
    }
    public class results{
        public string userFeedback;
        public string outcomeType;
        public string outcomeDescription;
        public string outcomeCode;
    }
    
}