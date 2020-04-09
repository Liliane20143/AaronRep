public without sharing class OB_ContactTriggerHandler { 
	
	String space = ' ';
 	String quote =  '\'';
 	
 	//OB_UtilityConstants.ODDVALUESOFFISCALCODE
 	//OB_UtilityConstants.EVENVALUESOFFISCALCODE
  	//	START 	micol.ferrari 23/11/2018
	//public String userId = Userinfo.getuserid();
	//public list<User> listOfUsers = [SELECT id, contactId , contact.accountId, Profile.UserLicense.Name, OB_CAB__C, OB_ABI__c
	//						FROM User
	//						WHERE Id =: userId
	//						LIMIT 1];
	//	END 	micol.ferrari 23/11/2018
		                           

	public String acceptedSpecialChar = OB_UtilityConstants.ACCEPTEDSPECIALCHAR;
 	
	/* ------------------------------------------------------------------------------------------------------------------------------ 		*/
	/*USER COULD INSERT THESE SPECIAL CHAR : (	)	”	?	!	&	% 	$	£  	=	^ 	°	\ 	/	AlphabeticChars and Numeric Chars    	*/
	/* -----------------------------------------------------------------------------------------------------------------------------	 	*/
	
	String regEx = '^([A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1})|([0-9]{11})$';											    
	String Jan = 'A';
	String Feb = 'B';
	String Mar = 'C';
	String Apr = 'D';
	String May = 'E';
	String Jun = 'H';
	String Lug = 'L';
	String Ago = 'M';
	String Sep = 'P';
	String Oct = 'R';
	String Nov = 'S';
	String Dec = 'T';
	
	String[] letters = new String[] {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L','M','N', 'O','P', 'Q','R', 'S', 'T', 'U', 'V', 'Z'};
	 
	public static String extractVowels(String p){
		String ris='';
		for(Integer i=0;i<p.length();i++){ 
			String ss=p.subString(i,i+1);
			if(ss.equalsIgnoreCase('A') || ss.equalsIgnoreCase('E') || ss.equalsIgnoreCase('I') || ss.equalsIgnoreCase('O') || ss.equalsIgnoreCase('U'))
				ris+=ss;
		}
		return ris;
	}
	
	public static String stringNormalizer (String input){
		try{
			String acc = 'ÀÂÄÇÉÈÊËÎÏÌÛÜÙÔÖÒÑ' + '°()§<>%^¨*$€£`#,;./?!+=_@"' + '\'Œ&Æ';        // et Œ, Æ, &;
			String maj = 'AAACEEEEIIIUUUOOON' + '                          ' + '    ';
			String out = '';
			for (Integer i = 0 ; i < input.length() ; i++) {
				String car = input.substring(i, i+1);
				Integer idx = acc.indexOf(car);
				if (idx != -1){
					out += maj.substring(idx, idx+1);
				}
				else {
					out += car;
				}
			}

			return out.replaceAll(' ','');
		}
		catch(Exception ecc){
			System.debug('pulisci stringa: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			return '';
		}
	}
	
	public static String extractConsonants(String p){
		String ris='';
		for(Integer i=0;i<p.length();i++){
			String ss=p.subString(i,i+1);
			if(!ss.equalsIgnoreCase('A') && !ss.equalsIgnoreCase('E') && !ss.equalsIgnoreCase('I') && !ss.equalsIgnoreCase('O') && !ss.equalsIgnoreCase('U'))
				ris+=ss;
		}
		return ris;
	} 
	 										    
	public static String checkNameSurnameCF(String nome, String cognome, String cf, String birthDate, String gender){
			nome= stringNormalizer(nome.replaceAll(' ','').replaceAll('\'','').toUpperCase());
			cognome=stringNormalizer(cognome.replaceAll(' ','').replaceAll('\'','').toUpperCase());
			cf=cf.toUpperCase();
			String check=null;
			String nc= extractConsonants(nome);
			if(nc.length()>3)
				nc=nc.subString(0,1)+nc.subString(2,3)+nc.subString(3,4);
			else{
				String nv=extractVowels(nome);
				Integer i=0;
				while(nc.length()<3){
					try{nc+=nv.subString(i,i+1);}
					catch(Exception ecc){nc+='X';}
					i++;
				}
			}
			String cc=extractConsonants(cognome);
			if(cc.length()>=3)
				cc=cc.subString(0,3);
			else{
				String cv=extractVowels(cognome);
				Integer i=0;
				while(cc.length()<3){
					try{cc+=cv.subString(i,i+1);}
					catch(Exception ecc){cc+='X';}
					i++;
				}
			}
			String dataCheck = cf.subString(6,11);
			String pn=cf.subString(3,6);
			String pc=cf.subString(0,3);
			System.debug('controllo CF nome: '+nome+' cognome: '+cognome+' parteNomeCF: '+pn+' calcolato nome: '+nc+' parteCognomeCF: '+pc+' calcolato cognome: '+cc);
			
			
			String dd = birthDate.substring(8, 10);
			String mm = birthDate.substring(5, 7);
			String yy = birthDate.substring(2, 4);
			if (gender == 'F'){
				Integer ddInt= Integer.valueOf(dd);
				ddInt+=40;
				dd = String.valueOf(ddInt);
			}
			Map <String,String> mmCode = new Map <String,String> {'01' => 'A', '02'=> 'B', '03'=> 'C', '04'=> 'D', '05'=> 'E', '06'=> 'H', '07'=> 'L', '08'=> 'M', '09'=> 'P', '10'=> 'R', '11'=> 'S', '12'=> 'T'};
			String dateCode = yy + mmCode.get(mm) + dd;
			system.debug('dateCode:: '+dateCode+' == '+dataCheck);
			if(!pn.equalsIgnoreCase(nc)){
				check='errorName';
			} else if (!pc.equalsIgnoreCase(cc)){
				check='errorSurname';
			}else if(gender == 'F' && Integer.valueOf(dataCheck.substring(3,5))-40 <0){
				check='errorGender';
			}else if(gender == 'M' && Integer.valueOf(dataCheck.substring(3,5))-40 >0){
				check='errorGender';
			}else if(dateCode != dataCheck){
				check='errorData';
			} 
			//else
			return (check); // && controllaCheckDigit(cf)
		}
	
	
	
	public void testFiscalCode(List<Contact> conts, List<Contact> oldConts){ 

		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!conts.isEmpty())
		{
			userSkipValidation = conts.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018	
		if (!userSkipValidation)
		{

			Map<Id, Contact> mapOfOldCons= new Map<Id, Contact>();
			System.debug('@@@@ I AM IN MY METHOD!!!!!');
	    	//if(listOfUsers.isEmpty() || (!listOfUsers.isEmpty() && listOfUsers.get(0).OB_CAB__c != 'SKIP')){
	    		
	    		if (null!=oldConts && !oldConts.isEmpty()) {
		    		for(Contact oldCont : oldConts){
		    			mapOfOldCons.put(oldCont.Id, oldCont);
		    			System.debug('mapOfOldCons is ' + mapOfOldCons);
		    		}
	    		}
	    	//}
		 	for(Contact cont : conts){
		 		if(cont.OB_BypassValidation__c == false ) {
		 			Boolean enableValidation 	= !mapOfOldCons.containsKey(cont.Id) || (mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_BypassValidation__c==cont.OB_BypassValidation__c);
			 		
			 		if (enableValidation)
			 		{
				 		try {
				 			String contName = cont.FirstName;
				 			String contLastName = cont.LastName;
				 			String fiscalCode = cont.OB_Fiscal_Code__c;
				 			Date birthDate = cont.OB_Birth_Date__c;
				 			String gender = cont.OB_Sex__c;
							String countryList = cont.OB_Country_Birth__c;
							List<NE__Lov__c> lovCadastralCode = [SELECT Id, NE__Value2__c, Name FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name = : countryList];
							Map<String, String> mapCountryCad = new Map<String, String>();
							
							for(NE__Lov__c lov:lovCadastralCode){
								mapCountryCad.put(lov.Name, lov.NE__Value2__c);
							}

				 			if(fiscalCode != null) {
					 			if(fiscalCode.length() == 16){
						 			String errorCFType = OB_FlowControlUtility.checkNameSurnameCF(contName, contLastName, fiscalCode, String.valueOf(birthDate), gender, cont.OB_Cadastral_Code__c, cont.OB_SkipCadastralCodeCheck__c);
									if(errorCFType == 'errorName'){
									cont.OB_Fiscal_Code__c.addError(Label.OB_InconsistentFiscalCode); 
									//mandatoryValidationCheck.put('input:legale_rappresentante:OB_Fiscal_Code__c',Label.OB_InconsistentFiscalCode); 
									} else if(errorCFType == 'errorData'){
									//mandatoryValidationCheck.put('input:legale_rappresentante:OB_Fiscal_Code__c',Label.OB_InvalidFiscalCodeBirthDate); 
									cont.OB_Fiscal_Code__c.addError(Label.OB_InvalidFiscalCodeBirthDate); 
									}else if(errorCFType  == 'errorSurname'){
									cont.OB_Fiscal_Code__c.addError(Label.OB_InvalidFiscalCodeSurname); 
									} else if(errorCFType  == 'errorGender'){
									cont.OB_Fiscal_Code__c.addError(Label.OB_InvalidFiscalCodeGender);
									} else if(errorCFType == 'errorLastChar') {
										cont.OB_Fiscal_Code__c.addError(Label.OB_InvalidFiscalCode);
									}
					 			} else {
					 				cont.OB_Fiscal_Code__c.addError(Label.OB_InvalidFiscalCode);
					 			}
				 			}
				 			if((mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_Country_Birth__c!=cont.OB_Country_Birth__c) || (mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_Birth_City__c!=cont.OB_Birth_City__c)){
				 				cont.OB_Cadastral_Code__c=null;
				 			}
				 			
				 		} catch (Exception exc	) {
				 			System.debug('[EXCE] OB_ContactTriggerHandler.testFiscalCode - The following exception has occurred: ' + exc.getMessage());
						}
					}
		 		}
		 	}
		} 	
	}
		
	public void testCoerencyDocumentNumber(List<Contact> conts, List<Contact> oldConts){ 
		//	START 	micol.ferrari 23/11/2018
		Boolean userSkipValidation = false;
		if (!conts.isEmpty())
		{
			userSkipValidation = conts.get(0).OB_UserSkipValidation__c;
		}
		//	END 	micol.ferrari 23/11/2018	
		if (!userSkipValidation)
		{

			Map<Id, Contact> mapOfOldCons= new Map<Id, Contact>();
			//if(listOfUsers.isEmpty() || (!listOfUsers.isEmpty() && listOfUsers.get(0).OB_CAB__c != 'SKIP')){
	    		
	    		if (null!=oldConts && !oldConts.isEmpty()) {
		    		for(Contact oldCont : oldConts){
		    			mapOfOldCons.put(oldCont.Id, oldCont);
		    			System.debug('mapOfOldCons is ' + mapOfOldCons);
		    		}
		    	}
		    //}
		    for(Contact cont : conts){
		 		if(cont.OB_BypassValidation__c == false ) { 
		 			Boolean enableValidation 	= !mapOfOldCons.containsKey(cont.Id) || (mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_BypassValidation__c==cont.OB_BypassValidation__c);
		 			if (enableValidation)
				 	{
				 		try {
				 			String documentNumber = cont.OB_Document_Number__c;
							 /* ANDREA MORITTU START 26-Nov-2019 - PRODOB_552 - FIX PRODOB_522_FIX */
							String docType = cont.OB_Document_Type__c;
							/* ANDREA MORITTU END 26-Nov-2019 - PRODOB_552 - FIX PRODOB_522_FIX */
				 			if(documentNumber != null){
				 				documentNumber = documentNumber.toLowerCase();
								/* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
									if(docType == OB_UtilityConstants.CARTA_DI_IDENTITA  ) { 
										if ( cont.OB_Document_Release_Country_Code__c == 'ITA' && (!(documentNumber).isAlphanumeric() ||  (documentNumber.length() < 8 || documentNumber.length() > 9 )  )) {
											cont.OB_Document_Number__c.addError(Label.OB_InvalidDocumentNumber);
										}
									} else {
										if(documentNumber.length() < 9 || !(documentNumber.containsOnly(acceptedSpecialChar)) || documentNumber.length() > 10 ){
											cont.OB_Document_Number__c.addError(Label.OB_InvalidDocumentNumber);
										} 
									}
									/* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
					 			
				 			}
				 		}catch(Exception exc){
					 		System.debug('[EXCE] OB_ContactTriggerHandler.testFiscalCode - The following exception has occurred: ' + exc.getMessage());
				 		}
				 	}
		 		}
		    }	
		    		
		    		// IT CHECKS IF THERE ARE DUPLICATES IN THAT INPUT
		    		/*} else if(documentNumber.length() == 3 || documentNumber.length() == 4) {
			 				
			 				String name= documentNumber;
						    String newName='';
						    Integer i=0;
						    Integer l=documentNumber.length(); 
						    for(i=0;i<l;i++)
						        {
						           String ch1=name.substring(i);
						            if(!(newName.indexOf(ch1)>-1))
						                {
						                	cont.OB_Document_Number__c.addError('No duplicates!!!');
						                    newName=newName + ch1;
						                }
						        }
						    System.debug('Output:'+newName);
						}*/
		}
	}
	
	
	public void testCoerencyDocumentExpirationDate(List<Contact> conts, List<Contact> oldConts){
		//	START 	micol.ferrari 23/11/2018
		
        try{
            
		System.debug ('in testCoerencyDocumentExpirationDate');
        System.debug ('conts: '+conts);
        System.debug ('oldConts: '+oldConts);
		Boolean userSkipValidation = false;
		if (!conts.isEmpty())
		{
			userSkipValidation = conts.get(0).OB_UserSkipValidation__c;
            System.debug('@@@userSkipValidation : '+userSkipValidation);
		}
        System.debug('@@@userSkipValidation : '+userSkipValidation);
		//	END 	micol.ferrari 23/11/2018	
		if (!userSkipValidation)
		{
			Map<Id, Contact> mapOfOldCons= new Map<Id, Contact>();
			//if(listOfUsers.isEmpty() || (!listOfUsers.isEmpty() && listOfUsers.get(0).OB_CAB__c != 'SKIP')){
				
				if (null!=oldConts && !oldConts.isEmpty()) {
		    		for(Contact oldCont : oldConts){
		    			mapOfOldCons.put(oldCont.Id, oldCont);
		    			System.debug('mapOfOldCons is ' + mapOfOldCons);
		    		}
				}
			//}
	    		System.debug('@@@mapOfOldCons : '+mapOfOldCons);
            
			 	for(Contact cont : conts){
                    
                    System.debug('@@@cont.OB_BypassValidation__c : '+cont.OB_BypassValidation__c);
			 		if(cont.OB_BypassValidation__c == false ) {

			 			Boolean enableValidation 	= !mapOfOldCons.containsKey(cont.Id) || (mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_BypassValidation__c==cont.OB_BypassValidation__c);
                        System.debug('@@@enableValidation : '+enableValidation);
                        if (enableValidation)
			 			{
					 		try {
					 			/*Variables for expiration and release date*/
					 			String documentReleaseAut = cont.OB_Document_Release_Authority__c;
					 			String documentType = cont.OB_Document_Type__c;
					 			Date documentExpirationDate = cont.OB_Document_Expiration_Date__c;
					 			Date documentReleaseDate = cont.OB_Document_Release_Date__c;
					 			/*Dates for check coerency*/
					 			Date checkDate = Date.newInstance(2012, 2, 10);
					 			
								/*Variables for info contact*/
								Date contBirthDate = cont.OB_Birth_Date__c;
								
								
								String passaporto = 'Passaporto';
								String patente    = 'Patente';
								String cdi        = 'Carta di Identità';
			
								String comune     = 'Comune';
								String questura   = 'Questura';
								String prefettura = 'Prefettura';
								String motorizzazione = 'Motorizzazione';
								String uco   = 'UCO';
								if(cont.OB_Document_Release_Country_Code__c == 'ITA'){ //gianluigi.virga 29/11/2019
									if(String.isNotBlank( documentReleaseAut) && String.isNotBlank( documentType) )
									{
										if( documentReleaseAut.equalsIgnoreCase(comune) && documentType.equalsIgnoreCase(cdi))
										{
											// IF BEFORE 2012
											if(documentReleaseDate < checkDate
												|| documentExpirationDate < documentReleaseDate
												|| documentReleaseDate == checkDate){
												
												if(documentExpirationDate < system.today() ){
													cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
													cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
												// michele.lubrano 29/04/2019 PRODOB-67 add check if expiration day is not the same with release day START
												} else if( (documentExpirationDate != (documentReleaseDate.addYears(10).addDays(- 1))) &&
													(documentExpirationDate != documentReleaseDate.addYears(10))){
													cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
													cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
												} else if(documentExpirationDate < documentReleaseDate ){
													// michele.lubrano 29/04/2019 PRODOB-67 END
													cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
													cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
												}
												// IF AFTER 2012
											} else if(documentReleaseDate > checkDate){
												System.debug('documentReleaseDate > checkDate');
												// IF BIRTHMONTH < RELEASEMONTH || 
												if(documentExpirationDate < system.today() ){
													cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
													cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
												} 
												// else if( documentExpirationDate != documentReleaseDate.addYears(10)){
												// 	cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
												// 	cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
												// } 
												else {
													// if(documentExpirationDate < system.today()){
													// cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
													// cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
													// } else
													if(((contBirthDate.month() < documentReleaseDate.month()) 
													|| (contBirthDate.month() == documentReleaseDate.month() 
													&& contBirthDate.day() < documentReleaseDate.day()))
													&& documentExpirationDate != Date.newInstance(documentReleaseDate.addYears(11).year(), contBirthDate.month(), contBirthDate.day())){
														cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
														cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
													}else if(((contBirthDate.month() > documentReleaseDate.month()) 
													|| (contBirthDate.month() == documentReleaseDate.month() 
													&& contBirthDate.day() >= documentReleaseDate.day())) 
													&& documentExpirationDate != Date.newInstance(documentReleaseDate.addYears(10).year(), contBirthDate.month(), contBirthDate.day())){
														cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
														cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate);
													}
												}
											}
										}	
										else if(documentReleaseAut.equalsIgnoreCase(comune) && !documentType.equalsIgnoreCase(cdi)){
												cont.OB_Document_Release_Authority__c.addError(Label.OB_InvalidReleaseAuthority); 
					
										}
										else if(documentReleaseAut.equalsIgnoreCase(questura) && !documentType.equalsIgnoreCase(passaporto)){
												cont.OB_Document_Release_Authority__c.addError(Label.OB_InvalidReleaseAuthority); 
					
										}
										else if((documentReleaseAut.equalsIgnoreCase(prefettura) 
												|| documentReleaseAut.equalsIgnoreCase(uco) 
												|| documentReleaseAut.equalsIgnoreCase(motorizzazione)) && !documentType.equalsIgnoreCase(patente)){
					
											cont.OB_Document_Release_Authority__c.addError(Label.OB_InvalidReleaseAuthority);
										}
					
										//****** 30-10- 2018 ***  END *******//	
										//data di scadenza deve essere pari alla data di rilascio più dieci anni meno un giorno
										else if(documentType.equalsIgnoreCase(passaporto)){
											System.debug('@@@@@@@ SONO NEL PASSAPORTO');
											if(documentExpirationDate.year() != documentReleaseDate.addYears(10).year() ||  (documentExpirationDate != documentReleaseDate.addYears(10).addDays(-1) && documentExpirationDate != documentReleaseDate.addYears(10)) || documentExpirationDate < system.today() ){
												cont.OB_Document_Release_Date__c.addError(Label.OB_Document_Release_Date);
												cont.OB_Document_Expiration_Date__c.addError(Label.OB_InvalidDocumentExpirationDate); 
											}
										} else if(documentType.equalsIgnoreCase(patente)) {
										}
									}
							 	}
					 		} catch(Exception exc){
					 		System.debug('[EXCE] OB_ContactTriggerHandler.testCoerencyDocumentExpirationDate - The following exception has occurred: ' + exc.getMessage() + ' at line: ' + exc.getLineNumber());	
					 		}	
					 	}
					}
			 	}
			} 
			
			/*public void testContactBlankCadastralCode(List<Contact> conts, List<Contact> oldConts){
				Map<Id, Contact> mapOfOldCons= new Map<Id, Contact>();
				if (null!=oldConts && !oldConts.isEmpty()) {
		    		for(Contact oldCont : oldConts){
		    			mapOfOldCons.put(oldCont.Id, oldCont);
		    			System.debug('mapOfOldCons is ' + mapOfOldCons);
		    		}
	    		}
	    		
				List<Contact> listContactsBlankCadastralCode = new List<Contact>();
	    		for(Contact cont : conts){
		 			if((mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_Country_Birth__c!=cont.OB_Country_Birth__c) || (mapOfOldCons.containsKey(cont.Id) && mapOfOldCons.get(cont.Id).OB_Birth_City__c!=cont.OB_Birth_City__c)){
		 				listContactsBlankCadastralCode.add(cont);
		 			}
		 			system.debug('listContactsBlankCadastralCode: '+listContactsBlankCadastralCode);
	    		}
			 	update listContactsBlankCadastralCode;
			}*/
        }
        catch(Exception e){
            System.debug('@@@Error: '+e.getLineNumber());
        }
		}

		//Start antonio.vatrano 03/06/2019 share contacts when Operation CREATE Contacts r1f2-183
		public void shareContact(List<Contact> conts, List<Contact> oldConts)
		{
            System.debug('new: '+conts);
            System.debug('Old: '+oldConts);
			Set<Id> setBanks = new Set<Id>();
			List<Id> listBanks = new List<Id>();
			List<Id> listContactsId = new List<Id>();
			List<Group> grp 		= new List<Group>();
			if(!conts.isEmpty()){
				for(Contact c : conts){
                    if(c.OB_Bank__c != null){
                        setBanks.add(c.OB_Bank__c);
                        listContactsId.add(c.Id);
                    }
				}
				listBanks.addAll(setBanks);
                System.debug('listBank: '+listBanks);
                System.debug('listContactsId: '+listContactsId);
				if(!listBanks.isEmpty()){
					Map<Contact, Group> mapContactGroup = retrieveMapContactGroup(listBanks, conts);
					System.debug('mapContactGroup '+mapContactGroup);
					if(!listContactsId.isEmpty()){
						Map<String,List<String>> mapOfContactShare =retrieveShareContact(listContactsId);
						System.debug('listOfContactsShares '+ mapOfContactShare );
						if (!mapOfContactShare.isEmpty() && !mapContactGroup.isEmpty()){
							Map<Contact, Group> mapContactGroupToInsert = new Map<Contact, Group>();
							for(Contact c : conts){
								if(mapContactGroup.containsKey(c) && mapOfContactShare.containsKey(String.ValueOf(c.Id))){
									Group gr = mapContactGroup.get(c);
									List<String> userOrGroupIds = mapOfContactShare.get(c.Id);
									if(!userOrGroupIds.contains(gr.Id)){
										mapContactGroupToInsert.put(c, gr);
									}
								}
							}

							System.debug('mapContactGroupToInsert '+mapContactGroupToInsert);
							insertContactShare(mapContactGroupToInsert);
						}
					}
				}
			}
		}
		//antonio.vatrano method to retrieve a map key: contactId value: lisf of  UserOrGroupId
		public static Map<String,List<String>> retrieveShareContact(List<Id> listContactsId){
			List<ContactShare> listOfContactsShares = [SELECT 	Id, ContactId, UserOrGroupId
														FROM 	ContactShare
														WHERE 	ContactId in :listContactsId ];
			Map<String,List<String>> toReturn = new Map<String,List<String>>();
			if(!listOfContactsShares.isEmpty()){
				for (ContactShare cShare : listOfContactsShares){
					if(toReturn.containsKey(String.valueOf(cShare.ContactId))){
						List<String> listToAdd = toReturn.get(String.valueOf(cShare.ContactId));
						listToAdd.add(String.valueOf(cShare.UserOrGroupId));
						toReturn.put(String.valueOf(cShare.ContactId),listToAdd);
					}
					else{
						List<String> listToAddElse = new List<String>();
						listToAddElse.add(String.valueOf(cShare.UserOrGroupId));
						toReturn.put(String.valueOf(cShare.ContactId),listToAddElse);
					}
				}
			}
			return toReturn;
		}
		//antonio.vatrano method to retrieve a map key: contactId value: Group from ob_Bank__c
		public static Map<Contact, Group> retrieveMapContactGroup (List<Id> listBanks, List<Contact> conts){
			// NEXI-127 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 26/06/2019 START
			Set<Id> contactIds = ( new Map<Id, Contact>( conts ) ).keySet( );
			Map<Id, Contact> contactWithBanks = new Map<Id, Contact>( [ SELECT OB_Bank__r.Name FROM Contact WHERE Id IN :contactIds ] );
			// NEXI-127 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 26/06/2019 STOP
			Map<Contact, Group> toReturn = new Map<Contact, Group>();
			List<Group> grp = new List<Group>();
			List<UserRole> listUserRoles 	= [SELECT Id,Name FROM UserRole WHERE PortalAccountId in :listBanks];
            System.debug('listUserRoles: '+listUserRoles);
			Set<Id> setUserRoles = new Set<Id>();
			for (UserRole us : listUserRoles){
				setUserRoles.add(us.Id);
			}
			List<Id> userRoles = new List<Id>();
			userRoles.addAll(setUserRoles);
            System.debug('userRoles: '+userRoles);
			if (!userRoles.isEmpty()){
				grp = [SELECT 	Id,Name,RelatedId,Type, Related.Name
						FROM 	Group 
						WHERE 	RelatedId in :userRoles
						AND 	Type='RoleAndSubordinates'];
			}
            System.debug('Group: '+grp);
			if(!grp.isEmpty()){
				for (Contact cont : conts){
					// NEXI-127 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 26/06/2019 START
					String bankName = contactWithBanks.get( cont.Id ) != null ? contactWithBanks.get( cont.Id ).OB_Bank__r.Name : ''; //
					String userRoleName = bankName + ' Partner User';
					// NEXI-127 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 26/06/2019 STOP
					System.debug('userRoleName: '+userRoleName);
					for(Group gr : grp){
						if (userRoleName == gr.Related.Name){
							toReturn.put(cont, gr);
						}
					}
				}
				System.debug('mapContactGroup: '+toReturn);
			}
			return toReturn;
		}
		//antonio.vatrano method to insert new contactShare
		public static void insertContactShare(Map<Contact, Group> mapToInsert ){
            System.debug(mapToInsert);
			List<ContactShare> toInsert = new List<ContactShare>();
			if(!mapToInsert.isEmpty()){
				for(contact c : mapToInsert.keySet()){
					Group gr = mapToInsert.get(c);
					ContactShare contextContactShare = new ContactShare();
					contextContactShare.ContactId = c.Id;
					contextContactShare.UserOrGroupId = gr.Id;
					contextContactShare.ContactAccessLevel = 'Edit';
					toInsert.add(contextContactShare);
				}
				insert toInsert;
			}
		}	
 		//End antonio.vatrano 03/06/2019 share contacts when Operation CREATE Contacts r1f2-183

		/*
		* Author : Giovanni Spinelli
		* Date : 23/07/2019
		* Description : Method to convert some fields to uppercase.
		*   Input : list new objects and old object
		*   Output : -
		*   Note: 	this method is called from triggers class
		*/
		public  void uppercaseFieldsConversion(List<Contact> newConts, List<Contact> oldConts ,String status){
			try{
				System.debug('uppercaseFieldsConversion');
				System.debug('status: ' + status);
				System.debug('newConts: ' + newConts);
				System.debug('oldConts: ' + oldConts);
				/*
				create two list to copy the trigger.new and trigger.old
				because I can't remove record from these
				*/
				List<Contact> newContsCopy = new List<Contact> ();
				List<Contact> oldContsCopy = new List<Contact> ();
				/*
				creation of a method that takes only the recordtypes of some objects on which to do uppercase
				*/
				Map<String , String> developerNameMap = new Map<String , String>();
				/*
				list of developer name used to check records
				*/
				List<String> availabeDeveloperName = new List<String>{
																		OB_UtilityConstants.ESECUTORE , 
																		OB_UtilityConstants.REFERENTE_PUNTO_VENDITA , 
																		OB_UtilityConstants.REFERENTE_TECNICO , 
																		OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ,
																		OB_UtilityConstants.TITOLARE_EFFETTIVO
																	};
				/*
				list of recordtypeId from previous list
				*/
				List<RecordType> recordTypeList = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName IN:availabeDeveloperName AND SobjectType ='Contact'];
				System.debug('recordTypeList: ' + recordTypeList);
				for(RecordType rt : recordTypeList){
					developerNameMap.put(String.valueOf(rt.Id) , rt.DeveloperName );
				}
				System.debug('developerNameMap: ' + developerNameMap);
				for(Integer i=0; i<newConts.size(); i++){
					Contact  singleCntNew = newConts.get(i);
					Contact  singleCntOld = new Contact();
					if(status == 'isUpdate'){
						oldConts.get(i);
					}
					
					System.debug('singleCntNew: ' + singleCntNew);
					String recordtypeId = singleCntNew.RecordTypeId;
					if(developerNameMap.containsKey(recordtypeId)){
						/*
						add  records that  have the appropriate recordtype from both the old and the new list
						*/
						newContsCopy.add(singleCntNew);
						if(status == 'isUpdate'){
							oldContsCopy.add(singleCntOld);
						}
					}
				}
				System.debug('newAccCopy after add: ' + newContsCopy);
				System.debug('oldAccCopy after add: ' + oldContsCopy);
				/*
				skip validations by reading a field on the object that depends on who is doing inserts and updates (migration or other)
				*/
				Boolean userSkipValidation = false;
				if (!newContsCopy.isEmpty())
				{
					userSkipValidation = newContsCopy.get(0).OB_UserSkipValidation__c;
				}
				if(!userSkipValidation){
					List<String> fieldsListToUppercase = new List<String>{'LastName' , 'FirstName' , 'OB_Document_Number__c','OB_Fiscal_Code__c','OB_Address_Street_Number__c'};
					if(status=='isUpdate'){
						System.debug('into update method uppercase');
						OB_Utility.toUppercaseUpdate(newContsCopy , oldContsCopy , fieldsListToUppercase);
					}
					if(status=='isInsert'){
						System.debug('into insert method uppercase');
						OB_Utility.toUppercaseInsert(newContsCopy , fieldsListToUppercase);
					}
				}
			}catch(Exception ecc){
				System.debug(logginglevel.ERROR , 'Generic Error validate: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}
		}
}