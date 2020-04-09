/*------------------------------------------------------------
    Author:         Elena Preteni
    Company:        Accenture Tecnology
    Description:    create JSON for Maintenance Merchant,Service Point e COBA
    Date:           29/04/2019
 ------------------------------------------------------------*/

global without sharing class OB_Maintenance_Serialize_Anagrafica {


    global class SerializeWrapperMerchant{
        global String requestId;
        global List<CompanyCodes> companyCodes;
        global CompanyChanges companyChanges;
        global SerializeWrapperMerchant(){  
            requestId ='';
            companyCodes = new List<CompanyCodes>();
            companyChanges = new CompanyChanges();
        }
    }
    global class CompanyCodes{
        global String source;
        global String code;
        global String pvCode;
        global CompanyCodes(){
            source='';
            code='';
            pvCode='';
        }
    }

    global class CompanyChanges{
        global String name;
        global String legalForm;
        global String vatNumber;
        global String taxCode;
        global String email;
        global String PEC;
        global String companyRegistrationNumber;
        global String provinceChamberOfCommerce;
        global String commoditySectorCodeSAE;
        // NEXI-119 Michal Targiel<michal.targiel@accenture.com>, 11/07/2019 START
        global String atecoCode
        {
            get
            {
                return atecoCode;
            }
            set
            {
                atecoCode = OB_UtilityConstants.ATECO_0000.equals( value ) ? null : value;
            }
        }
        // NEXI-119 Michal Targiel<michal.targiel@accenture.com>, 11/07/2019 STOP
        global String employeesNumber;
        global String annualRevenue;
        global String ONLUSType;
        global String beneficiariesType;
        global String beneficiariesDescription;
        global Address registeredOfficeAddress;
        global Address administrativeOfficeAddress;
        global List<Phones> phones;
        global List<ContactExecutor> contacts;

        global CompanyChanges(){
            name=null;
            legalForm=null;
            vatNumber=null;
            taxCode=null;
            email=null;
            PEC=null;
            companyRegistrationNumber=null;
            provinceChamberOfCommerce=null;
            commoditySectorCodeSAE=null;
            atecoCode=null;
            employeesNumber=null;
            annualRevenue=null;
            ONLUSType=null;
            beneficiariesType=null;
            beneficiariesDescription=null;
            registeredOfficeAddress = new Address();
            administrativeOfficeAddress = new Address();
            phones = new List<Phones>(); 
            contacts = new List<ContactExecutor>();
        }
    }

    global class Address{
        global String street;
        global String civicNumber;
        global String careOf;
        global String postalCode;
        global String city;
        global String province;
        global String country;
        global Address(){
            street=null;
            civicNumber=null;
            careOf=null;
            postalCode=null;
            city=null;
            province=null;
            country=null;
        }
    } 

    global class Phones{
        global String modality;
        global String phoneNumber;
        global Phones(){
            modality=null;
            phoneNumber=null;
        }
    }

    global class ContactExecutor{
        global String action;
        global String role;
        global String firstName;
        global String lastName;
        global Date birthDate;
        global String birthCity;
        global String birthProvince;
        global String birthCountry;
        global String fiscalCode;
        global String gender;
        global String email;
        global String citizenship;
        global Boolean flagPEP;
        global Phones phones;
        global Address ResidenceAddress;
        global PersonalDocuments personalDocument;
        global ContactExecutor(){
            action =null;
            role =null;
            firstName=null;
            lastName=null;
            birthDate=null;
            birthCity=null;
            birthProvince=null;
            birthCountry=null;
            fiscalCode=null;
            gender=null;
            email=null;
            citizenship=null;
            flagPEP=null;
            phones=null;
            ResidenceAddress=new Address();
            personalDocument=new PersonalDocuments();
        }
    }

    global class PersonalDocuments{
        global String documentType;
        global String documentNumber;
        global Date releaseDate;
        global Date expirationDate;
        global String releaseAuthority;
        global String releaseCity;
        global String releaseProvince;
        global String releaseCountry;
        global PersonalDocuments(){
            documentType=null;
            documentNumber=null;
            releaseDate=null;
            expirationDate=null;
            releaseAuthority=null;
            releaseCity=null;
            releaseProvince=null;
            releaseCountry=null;
        }
    }

    global static String serializeObjectMerchant(SerializeWrapperMerchant wrapper){
        String returnValue = JSON.serialize(wrapper);
        return returnValue;
    }
    //START - elena.preteni wn-152,wn-161
    global class SerializeWrapperServicePoint{
        global String requestId;
        //START - elena.preteni change interface agreement 04/09/2019
        global List<SalesPointChanges> salesPointChanges;
       
        global SerializeWrapperServicePoint(){  
            requestId ='';
            salesPointChanges = new List<SalesPointChanges>();
             
        }
        //END - elena.preteni change interface agreement 04/09/2019
    }
     global class SalesPointCodes{
         global String source;
         global String companyCode;
         global String pvCode;
         global SalesPointCodes(){
             source='';
             companyCode='';
             pvCode='';
         }
     }
    global class SalesPointChanges{
        //START - elena.preteni change interface agreement 04/09/2019
        global String source;
        global String companyCode;
        global String pvCode;
        //END - elena.preteni change interface agreement 04/09/2019
        global String shopName;
        global String receiptHeader;
        global String receiptLocation; 
        global String merchantCategoryCode;
        global String email;
        global String PEC;
        global String flagPrivacyC3;
        global String flagPrivacyC4;
        global String flagPrivacyC5;
        global List<Phones> phones;
        global Address address;
        global OpeningTimes openingTimes;
        // NEXI-267 Marta Stempien <marta.stempien@accenture.com> 09/08/2019, Change defalut value of variables for null instead of '', Start
        global SalesPointChanges(){
            source='';
            companyCode='';
            pvCode='';
            shopName = null;
            receiptHeader = null;
            receiptLocation = null;
            merchantCategoryCode = null;
            email = null;
            PEC = null;
            flagPrivacyC3 = null;
            flagPrivacyC4 = null;
            flagPrivacyC5 = null;
            phones = new List<Phones>();
            address = new Address();
            openingTimes = new OpeningTimes();
        }
        // NEXI-267 Marta Stempien <marta.stempien@accenture.com> 09/08/2019, Stop
    }
    //END - elena.preteni wn-152,wn-161
    global class OpeningTimes{
        global String openingHour;
        global String closingHour;
        global String startBreak;
        global String endBreak;
        global String startSeasonalActivity;
        global String endSeasonalActivity;
        global OpeningDays openingDays;

        global OpeningTimes(){
            openingHour= null;
            closingHour= null;
            startBreak= null;
            endBreak= null;
            startSeasonalActivity= null;
            endSeasonalActivity= null;
        }
    }

    global class OpeningDays{
        global String mondayMorning;
        global String mondayAfternoon;
        global String tuesdayMorning;
        global String tuesdayAfternoon;
        global String wednesdayMorning;
        global String wednesdayAfternoon;
        global String thursdayMorning;
        global String thursdayAfternoon;
        global String fridayMorning;
        global String fridayAfternoon;
        global String saturdayMorning;
        global String saturdayAfternoon;
        global String sundayMorning;
        global String sundayAfternoon;

        global OpeningDays(){
            mondayMorning = null;
            mondayAfternoon= null;
            tuesdayMorning= null;
            tuesdayAfternoon= null;
            wednesdayMorning= null;
            wednesdayAfternoon= null;
            thursdayMorning= null;
            thursdayAfternoon= null;
            fridayMorning= null;
            fridayAfternoon= null;
            saturdayMorning= null;
            saturdayAfternoon= null;
            sundayMorning= null;
            sundayAfternoon= null;
        }
    }

    global static String serializeObjectServicePoint(SerializeWrapperServicePoint wrapper){
        String returnValue = JSON.serialize(wrapper);
        return returnValue;
    }

    global class SerializeWrapperCoba{
        global String requestId;
        global List<CobaCodes> cobaCodes;
        global List<BankAccountDetails> bankAccountDetails;
         global SerializeWrapperCoba(){
            requestId='';
            cobaCodes = new List<CobaCodes>();
            bankAccountDetails = new List<BankAccountDetails>();
         }
    }

    global class CobaCodes{
        global String source; //EQUENS or SIA or MONETICA
        global String code; //PVCode for source=EQUENS/SIA, Terminal ID for source=MONETICA
        global String proposerABI; //has value only for EQUENS,not changed in maintenance
        global String salesPointCode; //has value only for EQUENS, not changed in maintenance
        global CobaCodes(){
            source =null;
            code =null;
            proposerABI =null;
            salesPointCode =null;
        }
    }

    global class BankAccountDetails{
        global String accountType;
        global String accountHolder;
        global String fiscalCode;
        global String subscriber;
        global String payee;
        global String iban;
        global String countryCode;
        global String checkNumber;
        global String CIN;
        global String ABI;
        global String CAB;
        global String bankAccountNumber;
        global BankAccountDetails(){
            accountType = null;
            accountHolder= null;
            fiscalCode= null;
            subscriber= null;
            payee= null;
            iban= null;
            countryCode= null;
            checkNumber= null;
            CIN= null;
            ABI= null;
            CAB= null;
            bankAccountNumber= null;
        }
    }

    global static String serializeObjectCoba(SerializeWrapperCoba wrapper){
        String returnValue = JSON.serialize(wrapper);
        return returnValue;
    }
}