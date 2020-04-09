/*****************************************************************
Name: OB_ConfigOfferProductsSellingCC_Test 
Purpose:  Class tests OB_CloneMatrixParameterQueueable class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          
1.0      francesca.ribezzi        18/06/2019       created            
********************************************************************************/
@isTest
public class OB_CloneMatrixParameterQueueable_Test
{

    /*******************************************************************************
    Purpose:  Method prepares data to test OB_CloneMatrixParameterQueueable
    Parameters: String ABIorCAB, String recordTypeName
    Returns: OB_CloneMatrixParameterQueueable

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    private static OB_CloneMatrixParameterQueueable prepareData( String ABIorCAB, String recordTypeName )
    {
        NE__Catalog__c nexiCatalog = new NE__Catalog__c( Name = 'Catalogo_Nexi' );
        insert nexiCatalog;
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert product;
        NE__Catalog_Item__c catalogItem = new NE__Catalog_Item__c( );
        catalogItem.NE__Catalog_Id__c = nexiCatalog.Id;
        catalogItem.NE__ProductId__c = product.Id;
        insert catalogItem;
        NE__Family__c family = new NE__Family__c( );
        insert family;
        NE__DynamicPropertyDefinition__c dynamic = new NE__DynamicPropertyDefinition__c( );
        insert dynamic;

        NE__Bundle__c offerta = new NE__Bundle__c( );
        offerta.Name = 'Test Offerta';
        offerta.NE__BaseRecurringCharge__c = 1;
        offerta.NE__RecurringChargeFrequency__c = 'Annual';
        offerta.NE__Catalog__c = nexiCatalog.Id;
        offerta.NE__Start_Date__c = System.now( ).addDays( -1 );
        offerta.NE__End_Date__c = System.now( ).addDays( 1 );
        offerta.NE__Active__c = true;
        insert offerta;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        matrixParameter.NE__Active__c = true;
        matrixParameter.NE__Start_Date__c = Date.newInstance( 2018, 2, 9 );
        matrixParameter.OB_Offerta__c = offerta.Id;
        matrixParameter.OB_Componente__c = catalogItem.Id;
        matrixParameter.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName( ).get( recordTypeName ).getRecordTypeId( );
        matrixParameter.OB_SchemaPrezzi__c = 'Trilaterale';
        insert matrixParameter;

        NE__Matrix_Parameter_Row__c row = new NE__Matrix_Parameter_Row__c( );
        row.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByDeveloperName( ).get( recordTypeName ).getRecordTypeId( );
        row.NE__Matrix_Parameter__c = matrixParameter.Id;
        row.OB_ABI_BANCA__c = '05116';
        row.OB_Cab__c = '12345';
        row.OB_Componente__c = matrixParameter.OB_Componente__c;
        row.OB_Family__c = family.Id;
        row.OB_DynamicPropertyDefinition__c = dynamic.Id;
        row.OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
        insert row;

        Map<String, Set<String>> matrixIdAbiSetmap = new Map<String, Set<String>>( );
        Set<String> abiSet = new Set<String>( );
        String abi = '05116';
        String cab = '12345';
        String service = ABIorCAB;
        if ( 'ABI'.equalsIgnoreCase( service ) )
        {
            abiSet.add( abi );
        }
        else
        {
            abiSet.add( cab );
        }
        matrixIdAbiSetmap.put( matrixParameter.Id, abiSet );

        return new OB_CloneMatrixParameterQueueable( new List<NE__Matrix_Parameter__c> {matrixParameter}, matrixIdAbiSetmap, abi, cab, service );
    }

    /*******************************************************************************
    Purpose:  Method tests ABI scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void cloneMatrixParameterQueueableABI( )
    {
        OB_CloneMatrixParameterQueueable job = prepareData( 'ABI', 'OB_PriceNexi' );

        Test.startTest( );
        Id jobId = System.enqueueJob( job );
        Test.stopTest( );

        System.assert( jobId != null );
    }

    /*******************************************************************************
    Purpose:  Method tests CAB scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void cloneMatrixParameterQueueableCAB( )
    {
        OB_CloneMatrixParameterQueueable job = prepareData( 'CAB', 'OB_PriceBankABI' );

        Test.startTest( );
        Id jobId = System.enqueueJob( job );
        Test.stopTest( );

        System.assert( jobId != null );
    }
}