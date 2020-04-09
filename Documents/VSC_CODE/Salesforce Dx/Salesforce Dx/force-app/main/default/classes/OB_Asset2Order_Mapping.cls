public virtual class OB_Asset2Order_Mapping {

    Set<String> assetFields = new Set<String>{  'NE__billing_account__c',
                                                'NE__Order_Config__r.NE__billingprofid__c',
                                                'NE__Order_Config__r.NE__commercialmodelid__c',
                                                'NE__Order_Config__r.NE__optyid__c',
                                                'NE__Order_Config__r.NE__quote__c',
                                                'NE__Order_Config__r.NE__totalrecurringfrequency__c',
                                                'NE__service_account__c',
                                                'NE__Order_Config__r.NE__type__c',
                                                'accountid','NE__catalog__c',
                                                'ob_bankaccount_debit_acquiring__c',
                                                'NE__service_point__c',
                                                'ob_mccl2__c',
                                                'ob_mcc__c',
                                                'NE__catalogitem__c',
                                                'quantity',
                                                'NE__prodid__c',
                                                'NE__parent_order_item__c',
                                                'NE__root_order_item__c',
                                                'id',
                                                'NE__startdate__c',
                                                'NE__description__c',
                                                'NE__discountid__c',
                                                'NE__enddate__c',
                                                'NE__ispromo__c',
                                                'NE__multiply_asset__c',
                                                'NE__onetimefeeov__c',
                                                'NE__promotionid__c',
                                                'NE__recurringchargefrequency__c',
                                                'NE__recurringchargeov__c',
                                                'NE__serialnum__c',
                                                'NE__status__c',
                                                'NE__action__c',
                                                'NE__commitment__c',
                                                'NE__commitment_expiration_date__c',
                                                'NE__penalty_fee__c',
                                                'NE__penalty_type__c',
                                                'NE__penalty__c',
                                                'NE__activation_date__c',
                                                'NE__commitment_uom__c',
                                                'NE__commitment_period__c',
                                                'NE__asset_item_account__c',
                                                'NE__assetpromoid__c',
                                                'NE__billing_account_asset_item__c',
                                                'NE__billingprof__c',
                                                'NE__one_time_tax_free__c',
                                                'NE__recurring_charge_tax_free__c',
                                                'NE__tax_models_applied__c',
                                                'NE__tax_for_canal__c',
                                                'NE__baseonetimefee__c',
                                                'NE__baserecurringcharge__c',
                                                'NE__hidden_in_cart__c',
                                                'NE__sourcelineitemid__c',
                                                'NE__item_code__c',
                                                'NE__bundle__c',
                                                'NE__bundle_element__c',
                                                'NE__bundle_configuration__c',
                                                'NE__parent_logic__c',
                                                'ob_termid__c',
                                                'ob_model__c',
                                                'ob_release__c',
                                                'ob_linktype__c',
                                                'ob_modeldescription__c',
                                                'ob_releasedescription__c',
                                                'ob_linkdescription__c',
                                                'ob_companycode__c',
                                                'ob_customercode__c',
                                                'ob_debitprofid__c',
                                                'ob_processor__c',
                                                'ob_shopcode__c',
                                                'ob_commercialname__c',
                                                'ob_servicepointcode__c',
                                                'ob_servicepointtype__c',
                                                'ob_gt__c',
                                                'ob_mcc_description__c',
                                                'mig_batch_id__c',
                                                'mig_external_id__c',
                                                'mig_level_id__c',
                                                'mig_run_id__c',
                                                'ob_description__c',
                                                'ob_enablement__c',
                                                'ob_ro__c',
                                                'ob_visible__c',
                                                'ob_proposerabi__c',
                                                'ob_receiptcity__c',
                                                'ob_receiptheader__c',
                                                'ob_report_type__c',
                                                'ob_settlementmethod__c',
                                                'ob_settlementtype__c',
                                                'ob_shopsign__c',
                                                'ob_sequence__c',
                                                'ob_conventioncode__c',
                                                'ob_billing_profile_credit_acquiring__c',
                                                'ob_internationalsettlementmethod__c',
                                                'ob_pbsettlementmethod__c',
                                                'ob_rac_sia__c',
                                                'ob_startvalidationdate__c',
                                                'NE__ProdId__r.RecordType.DeveloperName',
                                                'NE__Order_Config__r.RecordTypeId',
                                                'NE__Order_Config__r.NE__AccountId__c',
                                                'NE__Order_Config__r.NE__BillAccId__c',
                                                'NE__Order_Config__r.NE__ServAccId__c',
                                                'NE__Order_Config__r.OB_GT__c',
                                                'NE__Order_Config__r.OB_MCCL2__c',
                                                'NE__Order_Config__r.OB_MCC__c',
                                                'NE__Order_Config__r.OB_CTI_Code__c',
                                                'NE__Order_Config__r.OB_Service_Point__r.Name',
                                                'NE__Order_Config__r.OB_ReceiptHeader__c',
                                                'NE__Order_Config__r.NE__City__c',
                                                'OB_ProposerABI__r.OB_ABI__c',
												'OB_NDG__c',
												'OB_Sfdc_code_override__c', //gianluigi.virga 23/10/2019 - override sfdc code
                                                'NE__AssetItemEnterpriseId__c',
												'NE__Order_Config__r.NE__Order_Header__r.OB_PreliminaryVerificationCode__c',
												'NE__Order_Config__r.OB_InternationalSettlementMethod__c',
												'OB_B2W_Session__c'}; //enrico.purificato 23/10/2109 adde OB_B2W_Session__c
												//francesca.ribezzi 06/09/19 - WN-368- adding OB_PreliminaryVerificationCode__c and OB_InternationalSettlementMethod__c

    Set<String> assetAttributeFields = new Set<String>{	'name',
													'id',
													'NE__fampropid__c',
													'NE__value__c',
													'NE__asset__c',
													'NE__fampropextid__c',
													'ob_attribute_code__c',
													'ob_massimale__c',
													'ob_max_absolute__c',
													'ob_max_threshold__c',
													'ob_min_threshold__c',
													'ob_min_absolute__c',
													'NE__action__c',
													'ob_readonly__c',
													'ob_maxthresholdl2__c',
													'ob_maxthresholdl3__c',
													'ob_minthresholdl2__c',
													'ob_minthresholdl3__c',
													'ob_hidden__c',
                                                    'NE__AttrEnterpriseId__c'};
    public Set<String> getAssetFields(){
        return assetFields;
    }

    public Set<String> getAssetAttributeFields(){
        return assetAttributeFields;
    }

    public NE__Order_Header__c mapAsset2OrderHeader(Asset a){
        NE__Order_Header__c oh = new NE__Order_Header__c();
            
            oh.NE__AccountId__c     				= a.AccountId;
			oh.NE__BillAccId__c     				= a.NE__Billing_Account__c;
			oh.NE__ServAccId__c     				= a.NE__Service_Account__c;
            oh.OB_NDG__c	        				= a.OB_NDG__c;
			oh.OB_ABI__c		    				= a.OB_ProposerABI__r.OB_ABI__c;
			oh.NE__OrderStatus__c   				= 'Pending';
			oh.OB_Main_Process__c   				= 'Maintenance';
			//francesca.ribezzi 06/09/19 - WN-368- adding OB_PreliminaryVerificationCode__c
			oh.OB_PreliminaryVerificationCode__c 	= a.NE__Order_Config__r.NE__Order_Header__r.OB_PreliminaryVerificationCode__c;

        return oh;
    }

    public NE__order__c mapAsset2Order(Asset a){
        NE__order__c o = new NE__order__c();
        o.ob_mcc__c                          = a.ob_mcc__c;
        o.ob_mccl2__c                        = a.ob_mccl2__c;
        o.ob_service_point__c                = a.NE__service_point__c;
        o.ob_bankaccount_acquiring__c        = a.ob_bankaccount_debit_acquiring__c;
        o.NE__catalogid__c                   = a.NE__catalog__c;
        o.NE__accountid__c                   = a.accountid;
        o.NE__type__c                        = a.NE__Order_Config__r.NE__type__c;
        o.NE__servaccid__c                   = a.NE__service_account__c;
        o.NE__totalrecurringfrequency__c     = a.NE__Order_Config__r.NE__totalrecurringfrequency__c;
        o.NE__quote__c                       = a.NE__Order_Config__r.NE__quote__c;
        o.NE__optyid__c                      = a.NE__Order_Config__r.NE__optyid__c;
        o.NE__commercialmodelid__c           = a.NE__Order_Config__r.NE__commercialmodelid__c;
        o.NE__billingprofid__c               = a.NE__Order_Config__r.NE__billingprofid__c;
        o.NE__billaccid__c                   = a.NE__billing_account__c;
        o.OB_ShopSign__c 					 = a.OB_ShopSign__c;
        o.RecordTypeId                       = a.NE__Order_Config__r.RecordTypeId;   			
		o.OB_GT__c 							 = a.NE__Order_Config__r.OB_GT__c; //ET 28-12-18 added GT
      	o.NE__BillingProfId__c 				 = a.NE__Order_Config__r.NE__BillingProfId__c;
        o.OB_CTI_Code__c 					 = a.NE__Order_Config__r.OB_CTI_Code__c;

        o.NE__configuration_subtype__c		 = 'Standard';
        o.NE__orderstatus__c				 = 'Pending';
        o.NE__Configuration_Type__c          = 'Change';
	    o.NE__Type__c                        = 'ChangeOrder';
        return o;
    }
    public NE__orderitem__c mapAsset2OrderItem(Asset a){
        NE__orderitem__c oi = new NE__orderitem__c();
        
        oi.NE__account__c                           = 	a.accountid;
		oi.NE__catalogitem__c                       = 	a.NE__catalogitem__c;
		oi.NE__qty__c                               = 	a.quantity;
		oi.NE__prodid__c                            = 	a.NE__prodid__c;
		oi.NE__parent_order_item__c                 = 	a.NE__parent_order_item__c;
		oi.NE__root_order_item__c                   = 	a.NE__root_order_item__c;
		oi.NE__catalog__c                           = 	a.NE__catalog__c;
		oi.NE__assetitementerpriseid__c             = 	a.id;
		oi.NE__billing_account__c                   = 	a.NE__billing_account__c;
		oi.NE__startdate__c                         = 	a.NE__startdate__c;
		oi.NE__description__c                       = 	a.NE__description__c;
		oi.NE__discountid__c                        = 	a.NE__discountid__c;
		oi.NE__enddate__c                           = 	a.NE__enddate__c;
		oi.NE__ispromo__c                           = 	a.NE__ispromo__c;
		oi.NE__multiply_configuration_item__c       = 	a.NE__multiply_asset__c;
		oi.NE__onetimefeeov__c                      = 	a.NE__onetimefeeov__c;
		oi.NE__promotionid__c                       = 	a.NE__promotionid__c;
		oi.NE__recurringchargefrequency__c          = 	a.NE__recurringchargefrequency__c;
		oi.NE__recurringchargeov__c                 = 	a.NE__recurringchargeov__c;
		oi.NE__serialnum__c                         = 	a.NE__serialnum__c;
		oi.NE__service_account__c                   = 	a.NE__service_account__c;
		oi.NE__status__c                            = 	a.NE__status__c;
		oi.NE__action__c                            = 	a.NE__action__c;
		oi.NE__commitment__c                        = 	a.NE__commitment__c;
		oi.NE__commitment_expiration_date__c        = 	a.NE__commitment_expiration_date__c;
		oi.NE__penalty_fee__c                       = 	a.NE__penalty_fee__c;
		oi.NE__penalty_type__c                      = 	a.NE__penalty_type__c;
		oi.NE__penalty__c                           = 	a.NE__penalty__c;
		oi.NE__activation_date__c                   = 	a.NE__activation_date__c;
		oi.NE__commitment_uom__c                    = 	a.NE__commitment_uom__c;
		oi.NE__commitment_period__c                 = 	a.NE__commitment_period__c;
		oi.NE__asset_item_account__c                = 	a.NE__asset_item_account__c;
		oi.NE__orderitempromoid__c                  = 	a.NE__assetpromoid__c;
		oi.NE__billing_account_asset_item__c        = 	a.NE__billing_account_asset_item__c;
		oi.NE__billingprofid__c                     = 	a.NE__billingprof__c;
		oi.NE__one_time_tax_free__c                 = 	a.NE__one_time_tax_free__c;
		oi.NE__recurring_charge_tax_free__c         = 	a.NE__recurring_charge_tax_free__c;
		oi.NE__tax_models_applied__c                = 	a.NE__tax_models_applied__c;
		oi.NE__tax_for_canal__c                     = 	a.NE__tax_for_canal__c;
		oi.NE__baseonetimefee__c                    = 	a.NE__baseonetimefee__c;
		oi.NE__baserecurringcharge__c               = 	a.NE__baserecurringcharge__c;
		oi.NE__hidden_in_cart__c                    = 	a.NE__hidden_in_cart__c;
		oi.NE__sourcelineitemid__c                  = 	a.NE__sourcelineitemid__c;
		oi.NE__bundle_configuration__c              = 	a.NE__bundle_configuration__c;
		oi.NE__item_code__c                         = 	a.NE__item_code__c;
		oi.NE__bundle__c                            = 	a.NE__bundle__c;
		oi.NE__bundle_element__c                    = 	a.NE__bundle_element__c;
		oi.NE__parent_logic__c                      = 	a.NE__parent_logic__c;
		oi.ob_termid__c                             = 	a.ob_termid__c;
		oi.ob_model__c                              = 	a.ob_model__c;
		oi.ob_release__c                            = 	a.ob_release__c;
		oi.ob_linktype__c                           = 	a.ob_linktype__c;
		oi.ob_modeldescription__c                   = 	a.ob_modeldescription__c;
		oi.ob_releasedescription__c                 = 	a.ob_releasedescription__c;
		oi.ob_linkdescription__c                    = 	a.ob_linkdescription__c;
		oi.ob_companycode__c                        = 	a.ob_companycode__c;
		oi.ob_customercode__c                       = 	a.ob_customercode__c;
		oi.ob_debitprofid__c                        = 	a.ob_debitprofid__c;
		oi.ob_processor__c                          = 	a.ob_processor__c;
		oi.NE__service_point__c                     = 	a.NE__service_point__c;
		oi.ob_servicepointcode__c                   = 	a.ob_servicepointcode__c;
		oi.ob_servicepointtype__c                   = 	a.ob_servicepointtype__c;
		oi.ob_shopcode__c                           = 	a.ob_shopcode__c;
		oi.ob_commercialname__c                     = 	a.ob_commercialname__c;
		oi.ob_gt__c                                 = 	a.ob_gt__c;
		oi.ob_mcc_description__c                    = 	a.ob_mcc_description__c;
		oi.ob_mccl2__c                              = 	a.ob_mccl2__c;
		oi.ob_mcc__c                                = 	a.ob_mcc__c;
		oi.mig_batch_id__c                          = 	a.mig_batch_id__c;
		oi.mig_external_id__c                       = 	a.mig_external_id__c;
		oi.mig_level_id__c                          = 	a.mig_level_id__c;
		oi.mig_run_id__c                            = 	a.mig_run_id__c;
		oi.ob_description__c                        = 	a.ob_description__c;
		oi.ob_old_enablement__c                     = 	a.ob_enablement__c;
		oi.ob_ro__c                                 = 	a.ob_ro__c;
		oi.ob_visible__c                            = 	a.ob_visible__c;
		oi.ob_proposerabi__c                        = 	a.ob_proposerabi__c;
		oi.ob_receiptcity__c                        = 	a.ob_receiptcity__c;
		oi.ob_receiptheader__c                      = 	a.ob_receiptheader__c;
		oi.ob_report_type__c                        = 	a.ob_report_type__c;
		oi.ob_settlementmethod__c                   = 	a.ob_settlementmethod__c;
		oi.ob_settlementtype__c                     = 	a.ob_settlementtype__c;
		oi.ob_shopsign__c                           = 	a.ob_shopsign__c;
		oi.ob_sequence__c                           = 	a.ob_sequence__c;
		oi.ob_conventioncode__c                     = 	a.ob_conventioncode__c;
		oi.ob_enablement__c                         = 	a.ob_enablement__c;
		oi.ob_billing_profile_credit_acquiring__c   = 	a.ob_billing_profile_credit_acquiring__c;
		oi.ob_bankaccount_debit_acquiring__c        = 	a.ob_bankaccount_debit_acquiring__c;
		oi.ob_internationalsettlementmethod__c      = 	a.ob_internationalsettlementmethod__c;
		oi.ob_pbsettlementmethod__c                 = 	a.ob_pbsettlementmethod__c;
		oi.NE__qty__c                               = 	a.quantity;
		oi.NE__bundle_configuration__c              = 	a.NE__bundle_configuration__c;
		oi.NE__prodid__c                            = 	a.NE__prodid__c;
		oi.NE__parent_order_item__c                 = 	a.NE__parent_order_item__c;
		oi.NE__account__c                           = 	a.accountid;
		oi.NE__action__c                            = 	a.NE__action__c;
		oi.NE__activation_date__c                   = 	a.NE__activation_date__c;
		oi.NE__asset_item_account__c                = 	a.NE__asset_item_account__c;
		oi.NE__assetitementerpriseid__c             = 	a.id;
		oi.NE__billing_account__c                   = 	a.NE__billing_account__c;
		oi.NE__billing_account_asset_item__c        = 	a.NE__billing_account_asset_item__c;
		oi.NE__billingprofid__c                     = 	a.NE__billingprof__c;
		oi.NE__catalog__c                           = 	a.NE__catalog__c;
		oi.NE__catalogitem__c                       = 	a.NE__catalogitem__c;
		oi.NE__commitment__c                        = 	a.NE__commitment__c;
		oi.NE__commitment_expiration_date__c        = 	a.NE__commitment_expiration_date__c;
		oi.NE__commitment_period__c                 = 	a.NE__commitment_period__c;
		oi.NE__commitment_uom__c                    = 	a.NE__commitment_uom__c;
		oi.NE__description__c                       = 	a.NE__description__c;
		oi.NE__enddate__c                           = 	a.NE__enddate__c;
		oi.NE__ispromo__c                           = 	a.NE__ispromo__c;
		oi.NE__multiply_configuration_item__c       = 	a.NE__multiply_asset__c;
		oi.NE__onetimefeeov__c                      = 	a.NE__onetimefeeov__c;
		oi.NE__one_time_tax_free__c                 = 	a.NE__one_time_tax_free__c;
		oi.NE__orderitempromoid__c                  = 	a.NE__assetpromoid__c;
		oi.NE__penalty__c                           = 	a.NE__penalty__c;
		oi.NE__penalty_fee__c                       = 	a.NE__penalty_fee__c;
		oi.NE__penalty_type__c                      = 	a.NE__penalty_type__c;
		oi.NE__promotionid__c                       = 	a.NE__promotionid__c;
		oi.NE__recurringchargefrequency__c          = 	a.NE__recurringchargefrequency__c;
		oi.NE__recurringchargeov__c                 = 	a.NE__recurringchargeov__c;
		oi.NE__recurring_charge_tax_free__c         = 	a.NE__recurring_charge_tax_free__c;
		oi.NE__serialnum__c                         = 	a.NE__serialnum__c;
		oi.NE__service_account__c                   = 	a.NE__service_account__c;
		oi.NE__startdate__c                         = 	a.NE__startdate__c;
		oi.NE__status__c                            = 	a.NE__status__c;
		oi.NE__tax_for_canal__c                     = 	a.NE__tax_for_canal__c;
		oi.NE__tax_models_applied__c                = 	a.NE__tax_models_applied__c;
		oi.NE__baseonetimefee__c                    = 	a.NE__baseonetimefee__c;
		oi.NE__baserecurringcharge__c               = 	a.NE__baserecurringcharge__c;
		oi.NE__sourcelineitemid__c                  = 	a.NE__sourcelineitemid__c;
		oi.NE__hidden_in_cart__c                    = 	a.NE__hidden_in_cart__c;
		oi.NE__item_code__c                         = 	a.NE__item_code__c;
		oi.NE__bundle__c                            = 	a.NE__bundle__c;
		oi.ob_model__c                              = 	a.ob_model__c;
		oi.NE__bundle_element__c                    = 	a.NE__bundle_element__c;
		oi.NE__parent_logic__c                      = 	a.NE__parent_logic__c;
		oi.ob_termid__c                             = 	a.ob_termid__c;
		oi.ob_release__c                            = 	a.ob_release__c;
		oi.ob_linktype__c                           = 	a.ob_linktype__c;
		oi.ob_modeldescription__c                   = 	a.ob_modeldescription__c;
		oi.ob_releasedescription__c                 = 	a.ob_releasedescription__c;
		oi.ob_linkdescription__c                    = 	a.ob_linkdescription__c;
		oi.ob_companycode__c                        = 	a.ob_companycode__c;
		oi.ob_customercode__c                       = 	a.ob_customercode__c;
		oi.ob_debitprofid__c                        = 	a.ob_debitprofid__c;
		oi.ob_processor__c                          = 	a.ob_processor__c;
		oi.NE__service_point__c                     = 	a.NE__service_point__c;
		oi.ob_servicepointcode__c                   = 	a.ob_servicepointcode__c;
		oi.ob_servicepointtype__c                   = 	a.ob_servicepointtype__c;
		oi.ob_shopcode__c                           = 	a.ob_shopcode__c;
		oi.ob_commercialname__c                     = 	a.ob_commercialname__c;
		oi.ob_gt__c                                 = 	a.ob_gt__c;
		oi.ob_mcc_description__c                    = 	a.ob_mcc_description__c;
		oi.ob_mccl2__c                              = 	a.ob_mccl2__c;
		oi.ob_mcc__c                                = 	a.ob_mcc__c;
		oi.mig_batch_id__c                          = 	a.mig_batch_id__c;
		oi.mig_external_id__c                       = 	a.mig_external_id__c;
		oi.mig_level_id__c                          = 	a.mig_level_id__c;
		oi.mig_run_id__c                            = 	a.mig_run_id__c;
		oi.ob_description__c                        = 	a.ob_description__c;
		oi.ob_old_enablement__c                     = 	a.ob_enablement__c;
		oi.ob_ro__c                                 = 	a.ob_ro__c;
		oi.ob_visible__c                            = 	a.ob_visible__c;
		oi.ob_report_type__c                        = 	a.ob_report_type__c;
		oi.ob_proposerabi__c                        = 	a.ob_proposerabi__c;
		oi.ob_receiptcity__c                        = 	a.ob_receiptcity__c;
		oi.ob_receiptheader__c                      = 	a.ob_receiptheader__c;
		oi.ob_settlementmethod__c                   = 	a.ob_settlementmethod__c;
		oi.ob_settlementtype__c                     = 	a.ob_settlementtype__c;
		oi.ob_shopsign__c                           = 	a.ob_shopsign__c;
		oi.ob_sequence__c                           = 	a.ob_sequence__c;
		oi.NE__root_order_item__c                   = 	a.NE__root_order_item__c;
		oi.ob_conventioncode__c                     = 	a.ob_conventioncode__c;
		oi.ob_bankaccount_debit_acquiring__c        = 	a.ob_bankaccount_debit_acquiring__c;
		oi.ob_billing_profile_credit_acquiring__c   = 	a.ob_billing_profile_credit_acquiring__c;
		oi.ob_enablement__c                         = 	a.ob_enablement__c;
		oi.ob_internationalsettlementmethod__c      = 	a.ob_internationalsettlementmethod__c;
		oi.ob_pbsettlementmethod__c                 = 	a.ob_pbsettlementmethod__c;
		oi.OB_Sfdc_code_override__c					=	a.OB_Sfdc_code_override__c; //gianluigi.virga 23/10/2019		        
        return oi;
    }

    public NE__order_item_attribute__c mapAssetAttribute2OrderItemAttribute(NE__assetitemattribute__c a){
        NE__order_item_attribute__c ia = new NE__order_item_attribute__c();

        ia.NE__fampropid__c 		= a.NE__fampropid__c;
        ia.NE__AttrEnterpriseId__c 	= a.Id;// enrico.purificato - 18/7/2019 - F2WAVE2-157
        ia.NE__value__c				= a.NE__value__c;
        ia.NE__Old_Value__c 		= a.NE__value__c;
        ia.NE__fampropextid__c 		= a.NE__fampropextid__c;
        ia.ob_attribute_code__c 	= a.ob_attribute_code__c;
        ia.ob_massimale__c			= a.ob_massimale__c;
        ia.ob_max_absolute__c		= a.ob_max_absolute__c;
        ia.ob_max_threshold__c		= a.ob_max_threshold__c;
        ia.ob_min_threshold__c		= a.ob_min_threshold__c;
        ia.ob_min_absolute__c		= a.ob_min_absolute__c;
        ia.NE__action__c 			= 'None';
        ia.ob_readonly__c			= a.ob_readonly__c;
        ia.ob_hidden__c				= a.ob_hidden__c;
        ia.Name   					= a.Name;//Simone Misani 15/07/2019 F2-WAVE2-126

        return ia;
    }
}