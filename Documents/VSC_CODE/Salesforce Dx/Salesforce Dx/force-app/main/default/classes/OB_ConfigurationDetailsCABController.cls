public with sharing class OB_ConfigurationDetailsCABController
{

    @AuraEnabled
    public static User getUserABIServer( Id userId )
    {
        return
        [
                SELECT id, OB_Abi__c, ob_cab__c
                FROM User
                WHERE id = :userId
        ];
    }

    /**
    * @author ?
    * @date ?
    * @description ?
    * @params String offerName, String abi, NE__Matrix_Parameter__c matrixParameter
    * @return List<NE__Matrix_Parameter_Row__c>
    * @history Nex-005 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 26/03/2019 Add 4 fields to select
    *           OB_MinThresholdL2__c,OB_MaxThresholdL2__c,OB_MinThresholdL3__c and OB_MaxThresholdL3__c
    */
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> getRowsByMatrixParameterId( NE__Matrix_Parameter__c matrixParameter, String abi, String offerName, String cab )
    {
        return
        [
                SELECT OB_Read_Only_CAB__c,
                        OB_Codici__c,
                        NE__Active__c,
                        OB_DynamicPropertyDefinition__c,
                        OB_DynamicPropertyDefinition__r.Name,
                        OB_DynamicPropertyDefinition__r.NE__Description__c,
                        OB_Family__c,
                        OB_Family__r.Name,
                        OB_ReadOnly__c,
                        OB_Read_Only_banca__c,
                        OB_SelfLookup__c,
                        OB_Sequence__c,
                        id,
                        Name,
                        OB_Componente__r.Ne__product_name__c,
                        OB_Componente__r.Ne__productId__c,
                        OB_Componente__r.Ne__productId__r.Ne__description__c,
                        NE__Matrix_Parameter__r.Name,
                        NE__Matrix_Parameter__r.NE__Start_Date__c,
                        NE__Matrix_Parameter__r.NE__End_Date__c,
                        NE__End_Date__c,
                        NE__Start_Date__c,
                        OB_Product__c,
                        OB_Product__r.name,
                        OB_Product__r.NE__Description__c,
                        OB_Componente__c,
                        OB_Massimale__c,
                        OB_Massimo__c,
                        OB_Minimo__c,
                        OB_Soglia_Max_Approvazione__c,
                        OB_Soglia_Min_Approvazione__c,
                        OB_Valore_Default__c,
                        OB_MinThresholdL2__c,
                        OB_MaxThresholdL2__c,
                        OB_MinThresholdL3__c,
                        OB_MaxThresholdL3__c
                FROM NE__Matrix_Parameter_Row__c
                WHERE NE__Matrix_Parameter__r.OB_Offerta__r.Name = :offerName
                AND NE__Matrix_Parameter__c = :matrixParameter.Id
                AND OB_ABI_BANCA__c = :abi
                AND OB_CAB__c = :cab
                AND recordType.DeveloperName = 'OB_PriceBankCAB'
                ORDER BY OB_SelfLookup__c ASC, OB_Sequence__c, OB_Product__r.Name
        ];//31/07/19 francesca.ribezzi order rows by sequence and OB_Product__r.Name
    }

    @AuraEnabled
    public static Date calculateDate( String startDate )
    {
        Date newDate = Date.valueof( startDate );
        Date endDateParent = newDate.addDays( -1 );
        return endDateParent;
    }

    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> insertCloneRow( NE__Matrix_Parameter_Row__c rowParent, List<NE__Matrix_Parameter_Row__c> rowChildren )
    {
        //Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/03/2019 Start
        if ( rowParent == null )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception in OB_ConfigurationDetailsController.insertCloneRow rowParent in null' );
            return new List<NE__Matrix_Parameter_Row__c>( );
        }
        //Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/03/2019 End
        List<NE__Matrix_Parameter_Row__c> rowsToUpsert = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c newRowParent = rowParent.clone( false, true, false, false );
        Date parentStartDate = rowParent.NE__Start_Date__c;
        newRowParent.NE__Start_Date__c = parentStartDate.addDays( +1 );
        newRowParent.NE__End_Date__c = null;
        Id newId;
        try
        {
            Database.SaveResult sr = Database.insert( newRowParent );
            newId = sr.getId( );
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }

        for ( Integer i = 0; i < rowChildren.size( ); i++ )
        {
            if ( rowChildren[ i ] != null )//Nex-005 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/03/2019 add null chekc
            {
                NE__Matrix_Parameter_Row__c newRowChild = new NE__Matrix_Parameter_Row__c( );
                //cloning rowChildren[i]
                newRowChild = rowChildren[ i ].clone( false, true, false, false );
                newRowChild.NE__Start_Date__c = parentStartDate.addDays( +1 );
                newRowChild.NE__End_Date__c = null;
                newRowChild.OB_SelfLookup__c = newId;
                rowsToUpsert.add( newRowChild );
            }
        }
        try
        {
            upsert rowsToUpsert;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }
        rowsToUpsert.add( newRowParent );
        return rowsToUpsert;
    }

    public static List<NE__Catalog_Item__c> getChildCatalogItems( String productId )
    {    //id prodotto -> es: figli del pos
        return
        [
                select Id, NE__Product_Name__c
                from NE__Catalog_Item__c
                where NE__Root_Catalog_Item__c = :productId
                and NE__Type__c = 'Product' //and NE__Root_Catalog_Item__c in :posId
        ];
    }

    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> updateRows( List<NE__Matrix_Parameter_Row__c> rowList )
    {
        System.debug( 'into updateRows...' );
        if ( rowList.size( ) > 0 )
        {
            try
            {
                update rowList;
            } catch ( DmlException e )
            {
                System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
            }
        }
        return rowList;
    }

    @AuraEnabled
    public static NE__Matrix_Parameter_Row__c insertNewRowServer( NE__Matrix_Parameter_Row__c newRow, String componente, NE__Matrix_Parameter__c matrixParameter )
    {
        newRow.NE__Matrix_Parameter__c = matrixParameter.Id;
        newRow.OB_Componente__c = componente;
        System.debug( 'newRow apex: ' + newRow );
        try
        {
            insert newRow;
            return newRow;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
            return null;
        }
    }

    @AuraEnabled
    public static void deleteSelectedRow( List<NE__Matrix_Parameter_Row__c> listToDelete )
    {
        try
        {
            delete listToDelete;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred into insertNewRowsServer: ' + e.getMessage( ) );
        }
    }
}