public class BT_MailManager {

	public static final String TEMPLATE_REFERRAL_SIMPLIFIED = 'BT_OfferVariationReferralSimplified';
	public static final String TEMPLATE_REFERRAL_FULL = 'BT_OfferVariationReferralFull';
	public static final String TEMPLATE_LICENSING = 'BT_OfferVariationLicensing';
	public static final String ATTACHMENT_NAME = 'BT_SimulationDocument.pdf';
	
	@AuraEnabled
	public static Outcome sendOfferVariationEmail(Id simulationId, Boolean addCurrentUserCC, Id contactIdOverride, Boolean includeAttachment, Boolean referralSimplified) {
		Outcome result = new Outcome();
		if (simulationId == null) {
			result.setError(Label.BT_GenericError);
			System.debug(Logginglevel.ERROR, 'No simulation id in the call');
		} else {
			Id currentUserId = UserInfo.getUserId();
			try {
			//Query on config
				BT_Simulation__c simCheckReferral = [SELECT BT_Account__r.BT_IsReferral__c FROM BT_Simulation__c WHERE Id = :simulationId];
				System.debug('Simulation found - simCheckReferral: '+simCheckReferral);
			//Query on user
				User currentUser = [SELECT Email, BT_OfferVariationEmail__c, ContactId FROM User WHERE Id = :currentUserId]; //We've this record
				Id contactId = (contactIdOverride != null) ? contactIdOverride : currentUser.ContactId;
			//Query on template
				String templateEmail = simCheckReferral.BT_Account__r.BT_IsReferral__c ? (referralSimplified ? TEMPLATE_REFERRAL_SIMPLIFIED : TEMPLATE_REFERRAL_FULL) : TEMPLATE_LICENSING;
				EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :templateEmail];
				System.debug('Email template et: '+et);
			//Email sending
				Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
				message.setSaveAsActivity(false);
				message.setTargetObjectId(contactId); //Contact in order to populate WhatId (user doesn't work)
				message.setTemplateId(et.Id);
				message.setWhatId(simulationId);
				message.setTreatTargetObjectAsRecipient(false);
				message.setToAddresses(new List<String>{currentUser.BT_OfferVariationEmail__c});
				if (addCurrentUserCC)  {
					message.setCcAddresses(new List<String>{currentUser.Email});
				}
				if (includeAttachment) {
					message.setFileAttachments(new List<Messaging.EmailFileAttachment>{getOfferPageAsAttachment(simulationId)});
				}
				Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
				if (!Test.isRunningTest()) {
					Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
					if (!results[0].success) {
						String errMessage = results[0].errors[0].message;
						System.debug(Logginglevel.ERROR, 'Email not sent: '+errMessage);
					    result.setError(Label.BT_GenericError+'. '+errMessage);
					}
				}

				BT_Simulation__c sim = new BT_Simulation__c(Id = simulationId, BT_RichiestaDerogaFull__c = !referralSimplified, BT_RichiestaDeroga__c = referralSimplified);
				update sim;
			} catch (Exception ex) {
				String error = ex.getMessage()+' - '+ex.getStackTraceString();
				result.setError(Label.BT_GenericError+'. '+error);
				System.debug(Logginglevel.ERROR, 'Generic error: '+error);
			}
		}

		System.debug('result: '+result);
		return result;
	}

	@TestVisible
	private static Messaging.EmailFileAttachment getOfferPageAsAttachment(Id simulationId) {
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		if (simulationId != null) {
		//Getting page content
			PageReference offerPage = Page.BT_SimulationDocument;
			offerPage.getParameters().put('id',simulationId);
        	Blob b;
        	if (!Test.isRunningTest()) { b = offerPage.getContent(); }
        	else { b = Blob.valueOf('blobTest'); }
	        
        //Pupulating attachment
			attach.setFileName(ATTACHMENT_NAME);
			attach.setBody(b);
		}
		return attach;
	}

	public class Outcome {
		@AuraEnabled
		public Boolean success;
		@AuraEnabled
		public String message;

		public Outcome() {
			this.success = true;
			this.message = Label.BT_EmailOK;
		}

		public void setError(String message) {
			this.success = false;
			this.message = message;
		}
	}
}