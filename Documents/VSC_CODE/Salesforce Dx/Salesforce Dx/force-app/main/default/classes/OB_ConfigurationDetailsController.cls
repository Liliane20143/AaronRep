public with sharing class OB_ConfigurationDetailsController
{
    /**
     * @author ?
     * @date ?
     * @description ?
     * @params String offerName, String abi, NE__Matrix_Parameter__c matrixParameter
     * @return List<NE__Matrix_Parameter_Row__c>
     * @history Nex-005 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 27/03/2019 Add 4 fields to select
     *           OB_MinThresholdL2__c,OB_MaxThresholdL2__c,OB_MinThresholdL3__c and OB_MaxThresholdL3__c
     */
    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> getRowsByMatrixParameterId( String offerName, NE__Matrix_Parameter__c matrixParameter )
    {
        return
        [
                SELECT OB_ModelloAcquiring__c,
                        OB_Schema_Prezzi__c,
                        NE__Active__c,
                        OB_Codici__c,
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
                        OB_Componente__r.Ne__productId__r.recordType.DeveloperName,
                        OB_Componente__r.Ne__productId__r.Ne__description__c,
                        NE__Matrix_Parameter__r.Name,
                        NE__Matrix_Parameter__r.NE__Start_Date__c,
                        NE__Matrix_Parameter__r.OB_Componente__r.NE__Item_Header__c,
                        NE__Matrix_Parameter__r.OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c,
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
                AND OB_ABI_BANCA__c = null
                AND recordType.DeveloperName = 'OB_PriceNexi'
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

    @AuraEnabled //da utilizzare con il NEW
    public static List<NE__Catalog_Item__c> getCatalogItems( String searchText, String itemHeader )
    {
        searchText = '%' + searchText + '%';
        String catalogName = OB_offerCatalogController.catalogName;
        List<NE__Catalog_Item__c> catalogItems =
        [
                SELECT id,
                        NE__product_Name__c,
                        NE__ProductId__r.NE__Description__c,
                        NE__ProductId__c, NE__ProductId__r.Name
                FROM NE__Catalog_Item__c
                WHERE NE__Item_Header__c = :itemHeader
                AND NE__Type__c = 'Child-Product'
                AND NE__Product_Name__c LIKE :searchText
                AND NE__Catalog_Id__r.Name = :catalogName
        ];
        return catalogItems;
    }

    public static List<NE__Catalog_Item__c> getChildCatalogItems( String rootCatalogItem )
    { //id prodotto -> es: figli del pos
        return
        [
                SELECT Id,
                        NE__Product_Name__c
                FROM NE__Catalog_Item__c
                WHERE NE__Root_Catalog_Item__c = :rootCatalogItem
                AND NE__Type__c = 'Product'
        ];
    }

    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> updateRows( List<NE__Matrix_Parameter_Row__c> rowList, String itemHeader )
    {
        //method called to save all the matrix parameter row for all the products
        System.debug( 'into updateRows...' );
        System.debug( '@@@itemHeader...' + itemHeader );

        itemHeader = itemHeader.replaceAll( '"', '\'' );
        system.debug( '@@@itemHeader? ' + itemHeader );
        String query = 'select id, NE__Item_Header__c,Name, NE__Catalog_Id__c, NE__Catalog_Id__r.Name, NE__Parent_Catalog_Item__c ,NE__Type__c,NE__Product_Category_Name__c,NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c, NE__ProductId__c,NE__Root_Catalog_Item__c,NE__StructureId__c' +
                ' from NE__Catalog_Item__c' +
                ' where (( NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c =\'COMPONENTI DI PREZZO\' AND NE__Type__c = \'Child-Product\') OR (NE__Product_Category_Name__c = \'COMPONENTI DI PREZZO\' AND NE__Type__c =\'Category\'))' +
                ' and  NE__Item_Header__c =\'' + itemHeader + '\'';
        system.debug( '@@@query? ' + query );
        List<NE__Catalog_Item__c> catalogItems = Database.query( query );

        NE__Catalog_Item__c catalogCategory = new NE__Catalog_Item__c( );
        List<NE__Catalog_Item__c> itemsToInsert = new List<NE__Catalog_Item__c>( );
        Map<String, String> mapChildProductIdItemId = new Map<String, String>( );
        System.debug( 'catalogItems size: ' + catalogItems.size( ) );
        Id recordTypePricing = Schema.SObjectType.NE__Catalog_Item__c.getRecordTypeInfosByName( ).get( 'Pricing' ).getRecordTypeId( );
        //creating map childProduct catalogItemId
        for ( NE__Catalog_Item__c catalog : catalogItems )
        {
            if ( catalog.NE__Type__c == 'Child-Product' )
            {
                System.debug( 'catalog s type is childProduct..creating mapChildProductIdItemId map..' );
                mapChildProductIdItemId.put( catalog.NE__ProductId__c, catalog.Id );
            }
            if ( catalog.NE__Type__c == 'Category' )
            {
                catalogCategory = catalog;

            }
        }
        System.debug( 'mapChildProductIdItemId: ' + mapChildProductIdItemId );
        Map<String, List<NE__Matrix_Parameter_Row__c>> mapProductIdRows = new Map<String, List<NE__Matrix_Parameter_Row__c>>( );
        List<NE__Matrix_Parameter_Row__c> rowToUpdate = new List<NE__Matrix_Parameter_Row__c>( );
        for ( NE__Matrix_Parameter_Row__c row : rowList )
        {
            //creating a temp row list:
            List<NE__Matrix_Parameter_Row__c> tmpRows = new List<NE__Matrix_Parameter_Row__c>( );
            if ( mapProductIdRows.containsKey( row.OB_product__c ) )
            {
                tmpRows = mapProductIdRows.get( row.OB_product__c );
            }
            System.debug( '@@@tmpRows: ' + JSON.serialize( tmpRows ) );
            if ( row.NE__Active__c == true && row.OB_Componente__c == null )
            {
                System.debug( 'row is active and ob_componente is null!!' );
                if ( mapChildProductIdItemId.containsKey( row.OB_product__c ) )
                {
                    row.OB_Componente__c = mapChildProductIdItemId.get( row.OB_product__c );
                    rowToUpdate.add( row );
                }
                else if ( row.OB_SelfLookup__c == null )
                {
                    System.debug( 'creating a new catalog item..' );
                    System.debug( '@@@catalogCategory ' + catalogCategory );
                    //creating a new catalog item 
                    NE__Catalog_Item__c newCatalog = new NE__Catalog_Item__c( );
                    newCatalog.NE__Catalog_Id__c = catalogCategory.NE__Catalog_Id__c;
                    newCatalog.NE__Item_Header__c = catalogCategory.NE__Item_Header__c;
                    newCatalog.NE__Parent_Catalog_Item__c = catalogCategory.Id;
                    newCatalog.NE__ProductId__c = row.OB_product__c;
                    newCatalog.NE__Root_Catalog_Item__c = catalogCategory.NE__Root_Catalog_Item__c;
                    newCatalog.NE__StructureId__c = catalogCategory.NE__StructureId__c;
                    newCatalog.NE__Type__c = 'Child-Product';
                    newCatalog.RecordTypeId = recordTypePricing;
                    //adding the new catalog item to the list to insert:
                    itemsToInsert.add( newCatalog );
                }
            }
            tmpRows.add( row );
            //creating a map for rows to update:
            mapProductIdRows.put( row.OB_product__c, tmpRows );
        }

        try
        {
            System.debug( '@@@catalog items to insert: ' + JSON.serialize( itemsToInsert ) );
            insert itemsToInsert;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }
        System.debug( 'itemsToInsert: ' + itemsToInsert );

        for ( NE__Catalog_Item__c newCatalogItem : itemsToInsert )
        {
            for ( NE__Matrix_Parameter_Row__c row : mapProductIdRows.get( newCatalogItem.NE__ProductId__c ) )
            {
                System.debug( 'row Id: ' + row.Id );
                if ( row.OB_Componente__c == null )
                {
                    row.OB_Componente__c = newCatalogItem.Id;
                    rowToUpdate.add( row );
                }
            }
        }
        System.debug( 'rowToUpdate.size: ' + rowToUpdate.size( ) );
        try
        {
            update rowToUpdate;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }

        if ( rowToUpdate.size( ) < 1 )
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
    public static List<NE__Matrix_Parameter_Row__c> insertNewRowsServer( List<NE__Matrix_Parameter_Row__c> newRows, NE__Matrix_Parameter_Row__c newRow, String matrixParameterId, NE__Matrix_Parameter__c matrixParameter )
    {
        //method called to save single matrix parameter row by product
        //davide.franzini - WN-47 - 15/07/2019 - START
        List<OB_MPRCode__c> mprCodeList = OB_MPRCode__c.getall().values();
        Map<String,String> mprCodeMap = new Map<String,String>();
        for(OB_MPRCode__c mprCode : mprCodeList){
            mprCodeMap.put(mprCode.OB_FamilyName__c+'_'+mprCode.OB_DynamicPropertyName__c, mprCode.OB_Codici__c);
        }
        //davide.franzini - WN-47 - 15/07/2019 - END
        System.debug( 'insertNewRowsServer...' );
        Id newId;
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName( ).get( 'OB_PriceNexi' ).getRecordTypeId( );
        newRow.RecordTypeId = recordTypeId;
        newRow.NE__Matrix_Parameter__c = matrixParameterId;
        newRow.OB_ModelloAcquiring__c = matrixParameter.OB_ModelloAcquiring__c;
        newRow.OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
        //checking if newRows is not empty
        if ( newRows.size( ) > 0 )
        {
            newRow.OB_DynamicPropertyDefinition__c = newRows[ 0 ].OB_DynamicPropertyDefinition__c;
            newRow.OB_Family__c = newRows[ 0 ].OB_Family__c;
        }
        newRow.NE__Active__c = true;

        System.debug( 'newRow before insert: ' + newRow );
        try
        {
            //inserting parent row to get its ID and setting it as its children selflookup:
            Database.SaveResult sr = Database.insert( newRow );
            newId = sr.getId( );
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred into insertNewRowsServer: ' + e.getMessage( ) );
            return null;
        }
        System.debug( 'ID newRow after insert: ' + newId );

        for ( Integer i = 0; i < newRows.size( ); i++ )
        {
            newRows[ i ].OB_SelfLookup__c = newId;
            newRows[ i ].NE__Start_Date__c = newRow.NE__Start_Date__c;
            newRows[ i ].NE__Matrix_Parameter__c = matrixParameterId;
            newRows[ i ].RecordTypeId = newRow.RecordTypeId;
            newRows[ i ].NE__Active__c = true;
            newRows[ i ].OB_ModelloAcquiring__c = matrixParameter.OB_ModelloAcquiring__c;
            newRows[ i ].OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
            //davide.franzini - WN-47 - 15/07/2019 - START
            newRows[ i ].OB_Sequence__c = newRow.OB_Sequence__c;
            newRows[ i ].OB_Codici__c = mprCodeMap.get(newRow.OB_Family__r.Name+'_'+newRow.OB_DynamicPropertyDefinition__r.Name);
            newRows[ i ].OB_Minimo__c = 0;
            newRows[ i ].OB_MinThresholdL3__c = 0;
            newRows[ i ].OB_MinThresholdL2__c = 0;
            newRows[ i ].OB_Soglia_Min_Approvazione__c = 0;
            newRows[ i ].OB_Valore_Default__c = 0;
            newRows[ i ].OB_Soglia_Max_Approvazione__c = 0;
            newRows[ i ].OB_MaxThresholdL2__c = 0;
            newRows[ i ].OB_MaxThresholdL3__c = 0;
            newRows[ i ].OB_Massimo__c = 0;
            newRows[ i ].OB_Massimale__c = 0;
            //davide.franzini - WN-47 - 15/07/2019 - END
        }
        System.debug( 'list newRows before insert: ' + newRows );
        try
        {
            insert newRows;
            return newRows;
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred into insertNewRowsServer: ' + e.getMessage( ) );
            return null;
        }
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
    public static List< NE__ProductFamily__c> getFamiliesServer( String productId )
    {
        return
        [
                SELECT id,
                        NE__FamilyId__c,
                        NE__FamilyId__r.Name,
                        NE__FamilyId__r.NE__Hidden__c,
                        NE__FamilyId__r.NE__Number_of_attributes__c,
                        name
                FROM NE__ProductFamily__c
                WHERE NE__ProdId__c = :productId
                ORDER BY NE__FamilyId__r.Name
        ];
    }
    @AuraEnabled
    public static List<NE__ProductFamily__c> getFamiliesForChildrenRowsServer( List<NE__Product__c> products )
    {
        List< NE__ProductFamily__c> families =
        [
                SELECT id,
                        NE__FamilyId__c,
                        NE__ProdId__c,
                        NE__ProdId__r.Name,
                        NE__FamilyId__r.Name,
                        NE__FamilyId__r.NE__Hidden__c,
                        NE__FamilyId__r.NE__Number_of_attributes__c,
                        name
                FROM NE__ProductFamily__c
                WHERE NE__ProdId__c IN :products
                ORDER BY NE__FamilyId__r.Name
        ];
        List<NE__ProductFamily__c> listToReturn = new List<NE__ProductFamily__c>( );

        Set<String> myset = new Set<String>( );
        for ( NE__ProductFamily__c f : families )
        {
            if ( myset.add( f.NE__FamilyId__r.Name ) )
            {
                listToReturn.add( f );
            }
        }
        return listToReturn;
    }

    @AuraEnabled
    public static List<NE__ProductFamilyProperty__c> retrieveAttributesFromFamilies( List<NE__family__c> families )
    {
        return
        [
                SELECT Name,
                        NE__DefaultValue__c,
                        NE__FamilyId__c,
                        NE__FamilyId__r.Name,
                        NE__Hidden__c,
                        NE__PropId__c,
                        NE__PropId__r.Name,
                        NE__PropId__r.NE__Description__c
                FROM NE__ProductFamilyProperty__c
                WHERE NE__FamilyId__c IN :families
                ORDER BY NE__FamilyId__r.Name
        ];
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