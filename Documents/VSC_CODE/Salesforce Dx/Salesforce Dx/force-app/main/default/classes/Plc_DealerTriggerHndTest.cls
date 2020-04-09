@IsTest
private class Plc_DealerTriggerHndTest {
    
    @IsTest
    static void updateDealerOwnerId() {
        
        Account acc = Plc_TestFactory.createAccountSupplier('test');
        insert acc;
        
        User costr = Plc_TestFactory.createUser('ad', 'Costruttore');
        insert costr;
        
        User costr2 = Plc_TestFactory.createUser('test_', 'Costruttore');
        insert costr2;
        
        Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('parent', acc, 'TD001');
        insert dealerParent;
        
        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealerChild('child', acc,'TD002' ,dealerParent);
        dealer.OwnerId = costr.Id;
        insert dealer;
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c();
        stockOrder.Bit2Shop__Status__c = 'Generated';
        stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = dealer.Id;
        insert stockOrder;
        
        dealer.OwnerId = costr2.Id;
        update dealer;
        
        System.assertEquals(dealer.OwnerId, costr2.Id);
        //start modified 25/03/2019 by mame Diarra
        Database.delete(dealer.Id);
        Database.undelete(dealer.Id);
        //end modified 25/03/2019 by mame Diarra
    }
}