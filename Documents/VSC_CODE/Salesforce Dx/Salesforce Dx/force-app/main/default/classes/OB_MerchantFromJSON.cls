public class OB_MerchantFromJSON{
	public String pgId;	//425080
	public String fiscalCode;	//05218600962
	public String vatCode;	//05218600962
	public String name;	//STRADIVARIUS ITALIA SRL
	public String legalForm;
	public String PEC;
	public String yearConstitutionCompany;
	public String companyRegistrationNumber;
	public String provinceChamberOfCommerce;
	public String commoditySectorCodeSAE;
	public String atecoCode;
	public cls_RegisteredOfficeAddress RegisteredOfficeAddress;
	public cls_InvoicingAddress InvoicingAddress; 
	public cls_AdmistrativeAddress AdmistrativeAddress {get; set;}
	public cls_Acquiring[] Acquiring;
	public cls_POS[] POS;
	public Integer result;	//0
	
	public class cls_RegisteredOfficeAddress {
		public String street;	//VIA MORIMONDO 26
		public String civicNumber;	//
		public String careOf;
		public String postalCode;	//20143
		public String city;	//MILANO
		public String province;	//MI
		public String country;	//ITA
	}
	
	public class cls_InvoicingAddress {
		public String street;
		public String civicNumber;
		public String careOf;
		public String postalCode;
		public String city;
		public String province;
		public String country;
	}
	
	public class cls_AdmistrativeAddress {
		public String street; //VIA MORIMONDO 26
		public String civicNumber;	//
		public String careOf;
		public String postalCode;	//20143
		public String city; 		//MILANO
		public String province;	//MI
		public String country;	//ITA
	}
	
	public class cls_POS {
		public String clientId;	//425080
		public String gt;	//NEXI
		public String updatedDate;	//2010-09-07
	}

	public class cls_Acquiring {
		public String socId;
		public String processor;
		public String activityStartDate;
		public String updatedDate;
		public String pricingType;
		public String typeOfAccountStatement;
	}

	public static OB_MerchantFromJSON parse(String json){
		return (OB_MerchantFromJSON) System.JSON.deserialize(json, OB_MerchantFromJSON.class);
	}

}