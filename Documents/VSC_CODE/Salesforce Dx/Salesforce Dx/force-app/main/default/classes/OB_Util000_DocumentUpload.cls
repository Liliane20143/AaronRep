/**
 * Created by wojciech.kucharek@accenture.com on 19.07.2019.
 */
public with sharing class OB_Util000_DocumentUpload
{
    public static final List<String> DOCUMENT_CONSISTENZA = new List<String> {'Codice Fiscale legale rappresentante e titolari effettivi', 'Copia documento d’identità del Rappresentante/esecutore, di eventuali titolari e', 'Visura camerale', 'Copia documento Agenzia delle Entrate di rilascio P.IVA (riportante Codice Ateco'};
    public static final List<String> DOCUMENT_CONSISTENZA_DESCRIPTIONS = new List<String> {'CARTA REGIONALE SERVIZI', 'DOCUMENTO DI IDENTITA', 'VISURA', 'CERTIFICATO PIVA'};

    public static final List<String> DOCUMENT_VR = new List<String> {'Scheda di valutazione'};
    public static final List<String> DOCUMENT_VR_DESCRIPTION = new List<String> {'VALUTAZIONE RISCHIO'};

    public static final String VISURA = 'Visura camerale';
    public static final String DOCUMENTO_DI_IDENTITA = 'Copia documento Agenzia delle Entrate di rilascio P.IVA (riportante Codice Ateco)';

    public static final String LAV_AUTONOMO = 'LAV_AUTONOMO';
    /*******************************************************************************
    Purpose:    Method set selected documents to upload when condition from
                OB_Utility.detectSpecialCategory is true
    Parameters: String orderHeaderId
    Returns:    Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	25/07/2019      Created         NEXI-211
    ********************************************************************************/
    public static Map<String, String> documentsWhenSpecialCategory( String orderHeaderId )
    {
        Map<String, String> documentToUpload = new Map<String, String>( );
        try
        {
            ID oHeaderId = Id.valueOf( orderHeaderId );

            Map<Id, List<String>> orderHeaderSpecialCategories = OB_Util009_SpecialCategory.detectSpecialCategory( new List<Id> {oHeaderId} );

            if ( orderHeaderSpecialCategories.get( oHeaderId ).isEmpty( ) )
            {
                return documentToUpload;
            }

            documentToUpload = setDocumentsToUpload( DOCUMENT_CONSISTENZA, DOCUMENT_CONSISTENZA_DESCRIPTIONS );
            if ( documentToUpload.isEmpty( ) )
            {
                return documentToUpload;
            }

            List<NE__Order_Header__c> oOrderHeader = [ SELECT Id, NE__AccountId__c FROM NE__Order_Header__c WHERE Id = :oHeaderId ];
            if ( oOrderHeader.isEmpty( ) )
            {
                return documentToUpload;
            }

            List<Account> accountsList = [ SELECT ID, OB_Legal_Form_Code__c FROM Account WHERE ID = :oOrderHeader.get( 0 ).NE__AccountId__c ];

            if ( !accountsList.isEmpty( ) )
            {
                String legalFormCode = accountsList.get( 0 ).OB_Legal_Form_Code__c;
                if ( String.isNotBlank( legalFormCode ) && LAV_AUTONOMO.equalsIgnoreCase( legalFormCode ) )
                {
                    documentToUpload.remove( VISURA );
                }
                else
                {
                    documentToUpload.remove( DOCUMENTO_DI_IDENTITA );
                }

            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return new Map<String, String>( );
        }
        return documentToUpload;
    }

    /*******************************************************************************
    Purpose:  Method set selected documents to upload
    Parameters: List<String> documentsName, List<String> documentsTypology
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek      	25/07/2019      Created         NEXI-211
    ********************************************************************************/
    public static Map<String, String> setDocumentsToUpload( List<String> documentsName, List<String> documentsTypology )
    {
        if (documentsName == null || documentsTypology == null || documentsName.isEmpty( ) || documentsTypology.isEmpty( ) )
        {
            return new Map<String, String>( );
        }

        Map<String, List<OB_Product_Document__c>> documentsByNames = OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames( documentsName, documentsTypology );
        if ( documentsByNames.isEmpty( ) )
        {
            return new Map<String, String>( );
        }

        Map<String, String> documentToUpload = new Map<String, String>( );
        for ( String loopDocumentsName : documentsName )
        {
            for ( OB_Product_Document__c loopProductDocument : documentsByNames.get( loopDocumentsName ) )
            {
                documentToUpload.put( loopProductDocument.OB_Description__c, loopProductDocument.OB_Document_Typology__c + ':' + loopProductDocument.OB_Multiple_upload__c );

            }
        }
        return documentToUpload;
    }
}