public without sharing class OB_Maintenance_Coba {

	public static void callSubmit ( OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba wrapper,String accountId,String salesPointId, String billingProfileId){

        OB_UtilityCallingServices.callService('callout:OB_callService/api/merchants/'+accountId+'/sales-points/'+salesPointId+'/bankAccountDetails/'+billingProfileId,
            'POST',OB_Maintenance_Serialize_Anagrafica.serializeObjectCoba(wrapper));
	
	}
}