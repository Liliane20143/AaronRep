public class OB_ServicePointFromJSON{
	public String id;	//insegna
	public String shopName;	//insegna
	public String receiptHeader;	//insegnascontrino
	public String receiptLocation;	//indirizzoscontrino
	public String type;	//FISICO
	public String merchantCategoryCode;	//78945
	public cls_address address;
	public cls_acquiringDetails[] acquiringDetails;
	public cls_posDetails[] posDetails;
	public class cls_address {
		public String street;	//VIAIVNOVEMBRE
		public String civicNumber;	//4
		public String careOf;	//centrocommercialeItalMark
		public String postalCode;	//14100
		public String city;	//Assago
		public String province;	//MI
		public String country;	//ITA
	}
	public class cls_acquiringDetails {
		public String acquiringCode;	//5555
		public String companyCode;	//3333
		public boolean moto;
		public String processor;	//EQUENS
		public String activityStartDate;	//2018-06-25
		public String updatedDate;	//2018-06-25
		public String pricingType;	//STANDARD
		public String eCommerceType;	//1CLICK
		public cls_distinctiveServices distinctiveServices;
		public cls_settlementMethods[] settlementMethods;
		public list<String> abiCondi;
	} 
	public class cls_distinctiveServices {
		public boolean isCarRental;
		public boolean isHotel;
	}
	public class cls_settlementMethods {
		public String mode;	//NETTO
		public String schema;	//00
	}
	public class cls_posDetails {
		public String gtCompanyCode;	//3334
		public String gtSalePointCode;	//2222
		public String gtCode;	//NEXI
		public cls_agreementCodes[] agreementCodes;
	}
	public class cls_agreementCodes {
		public String code;	//AMEX
		public String processor;	//EQUENS
	}
	public static OB_ServicePointFromJSON parse(String json){
		return (OB_ServicePointFromJSON) System.JSON.deserialize(json, OB_ServicePointFromJSON.class);
	}

}