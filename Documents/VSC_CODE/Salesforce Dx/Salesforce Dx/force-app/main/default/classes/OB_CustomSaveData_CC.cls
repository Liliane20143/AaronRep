global with sharing class OB_CustomSaveData_CC implements bit2flow.dynWizardsIFExt {
    
    
    global  bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        if(method == 'createConfiguration'){
            response = createConfiguration( step, data, stepsDefinition, targetObjectKey, method,
                                           dynamicWizardWrapper);
        }else{
            response.result = '666';
            response.description = 'something has not validated properly in executeMethod';
            response.dynamicWizardWrapper = dynamicWizardWrapper;
        }
        
        if(method == 'createEsecutore'){
            System.debug('call esecutore method');
            response = createEsecutore( step, data, stepsDefinition, targetObjectKey, method,
                                       dynamicWizardWrapper);
        }else{
            response.result = '666';
            response.description = 'something has not validated properly in executeMethod';
            response.dynamicWizardWrapper = dynamicWizardWrapper;
        }
        
        
        System.debug('Ho eseguito l\'execute Method! ');
        
        // response.stepToGo=4;
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        //response.data=data;
        
        return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data=data;
        return response;
    }
    
    global static bit2flow.DynamicWizardStepWrapper createConfiguration (String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        //DynamicWizardStepWrapper response = new DynamicWizardStepWrapper();
        
        System.debug('dati complessi nel createConfiguration method cmp code ' + data);
        
        Object dataComplex = data.get('Object'); 
        Map<String,Object> mapFromObj = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataComplex));
        //String dataComplex = JSON.serialize(data.get('Object'));
        System.debug(' dataComplex is : '+ dataComplex);
        String accString =JSON.serialize(mapFromObj.get('merchant'));
        System.debug(' Account string :' + accString);
        Account acc = (Account)JSON.deserialize(accString, Account.class);
        System.debug(' Account dataMap :' + acc);
        
        String pvString =JSON.serialize(mapFromObj.get('pv'));
        NE__Service_Point__c newPv = (NE__Service_Point__c)JSON.deserialize(pvString, NE__Service_Point__c.class);
        
        
        /**************** Creazione dell'order *************************/
        //Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        String orderString = JSON.serialize(mapFromObj.get('OrderHeader'));
        System.debug(' orderString string :' + orderString);
        NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);
        
        /******************Creazione della configuation ****************/
        String configurationString = JSON.serialize(mapFromObj.get('Configuration'));
        System.debug(' CONFIGURATION string :' + configurationString);
        NE__Order__c configuration =(NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);
        
        try{
            if(String.isEmpty(acc.Id) ){
                acc.Id= null;
                insert acc;
                System.debug('Account Id ' + acc.Id);
                
                if(String.isBlank(newPv.Id)){
                    newPv.Id= null;
                    newPv.NE__Account__c = acc.Id;
                    //bit2flow.B2FUtils.setJSONValue(data, 'pv', 'NE__Account__c', acc.Id);
                    
                    insert newPv;
                    System.debug('ServicePoint Id ' + newPv.Id);
                }else{
                    newPv.NE__Account__c = acc.Id;
                    update newPv;
                }
                bit2flow.B2FUtils.setJSONValue(mapFromObj, 'merchant', 'Id', acc.Id);
                
            }else{
                System.debug('Sono nel Update del merchant');
                update acc;
                System.debug('Account update Id ' + acc.Id);
                if(String.isBlank(newPv.Id)){
                    system.debug('sono nel new pv');
                    newPv.NE__Account__c = acc.Id;
                    
                    //bit2flow.B2FUtils.setJSONValue(data, 'pv', 'NE__Account__c', acc.Id);
                    insert newPv;
                }else{
                    system.debug('sono nel update pv');
                    
                    update newPv;
                    system.debug('sono nel update pv con opening ' + newPv.Id);
                    
                }
                
            }
            
            System.debug('inizia insert della configuration');
            
            configuration.Id = null;
            // sarà da cambiare , era solo per fare un test. Sarà camblato l'id in modo dinamico
            List<RecordType> configurationType =[Select id,SobjectType,DeveloperName from RecordType where SobjectType='NE__Order__c' and DeveloperName ='Order' limit 1];
            configuration.RecordTypeId = configurationType[0].Id;
            configuration.NE__AccountId__c = acc.Id;
            //configuration.NE__Asset_Account__c = acc.Id;
            //configuration.NE__Billing_Account_Asset__c = acc.Id;
            //configuration.NE__BillAccId__c = acc.Id;
            insert configuration;
            System.debug('configurtion inserita con id :' + configuration.Id);
            
            orderHeader.Id =null;
            orderHeader.NE__AccountId__c = acc.Id;
            orderHeader.NE__BillAccId__c=acc.Id;
            orderHeader.NE__OrderId__c = configuration.Id;
            insert orderHeader;
            
            configuration.NE__Order_Header__c = orderHeader.Id;
            update configuration;
            
            bit2flow.B2FUtils.setJSONValue(mapFromObj, 'OrderHeader', 'Id', orderHeader.Id);
            bit2flow.B2FUtils.setJSONValue(mapFromObj, 'Configuration', 'Id', configuration.Id);
            
            
        }catch(DmlException e){
            System.debug('Error nel inserimento dei dati: '+e.getMessage());
        }
        
        System.debug('Ho eseguito l\'execute Method! ');
        //response.stepToGo=4;
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        data=mapFromObj;
        response.data=data;
        System.debug('dati complessi dopo il createConfiguration method cmp code ' + data);
        return response;
        
    }
    
    global static bit2flow.DynamicWizardStepWrapper createEsecutore (String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        //DynamicWizardStepWrapper response = new DynamicWizardStepWrapper();
        
        List<RecordType> EsecutoreType =[Select id,SobjectType,DeveloperName from RecordType where SobjectType='Contact' and DeveloperName ='Esecutore' limit 1];
        System.debug('dati complessi nel createEsecutore method cmp code ' + data);
        
        Object dataComplex = data.get('Object'); 
        Map<String,Object> mapFromObj = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataComplex));
        //String dataComplex = JSON.serialize(data.get('Object'));
        System.debug(' dataComplex is : '+ dataComplex);
        
        // Recupero Merchant Creato
        String accString =JSON.serialize(mapFromObj.get('merchant'));
        System.debug(' Account string :' + accString);
        Account acc = (Account)JSON.deserialize(accString, Account.class);
        System.debug(' Account dataMap :' + acc);
        
        //Recupero OrderHeader Creato
        String orderHeaderString =JSON.serialize(mapFromObj.get('OrderHeader'));
        System.debug(' orderHeaderString string :' + orderHeaderString);
        NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderHeaderString, NE__Order_Header__c.class);
        System.debug(' NE__Order_Header__c dataMap :' + orderHeader);
        
        String ContactString =JSON.serialize(mapFromObj.get('legale_rappresentante'));
        System.debug(' ContactString string :' + ContactString);
        Contact esecutore = (Contact)JSON.deserialize(ContactString, Contact.class);
        System.debug(' esecutore dataMap :' + esecutore);
        
        try{
            if(String.isEmpty(esecutore.Id) ){
                esecutore.Id= null;
                esecutore.AccountId = acc.Id;
                esecutore.RecordTypeId = EsecutoreType[0].Id;
                insert esecutore;
                System.debug('ContactString Id ' + esecutore.Id);
                
                bit2flow.B2FUtils.setJSONValue(mapFromObj, 'legale_rappresentante', 'Id', esecutore.Id);
                
            }else{
                System.debug('Sono nel Update del legale_rappresentante');
                update esecutore;
                System.debug('esecutore update Id ' + esecutore.Id);
                
            }
            
            //Inserimento nell'oggetto di junction
            /*OB_OrderHeaderContactRelation__c junctionOrderContact = new OB_OrderHeaderContactRelation__c();
            junctionOrderContact.OB_Contact__c = esecutore.Id;
            junctionOrderContact.OB_Order_Header__c =orderHeader.Id;
            
            insert junctionOrderContact;*/
            
        }catch(DmlException e){
            System.debug('Error nel inserimento dei dati');
        }
        
        bit2flow.B2FUtils.setJSONValue(mapFromObj, 'legale_rappresentante', 'Id', esecutore.Id);
        System.debug('Ho eseguito l\'inserimento di esecutore Method! ');
        //response.stepToGo=4;
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        data=mapFromObj;
        response.data=data;
        System.debug('dati complessi dopo il createConfiguration method cmp code ' + data);
        return response;
        
    }
    
    
    global bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        system.debug('Sono nel Validate Method');
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data=data;
        
        return response;
        
    }
    
    global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        
        NE__Order_Header__c orderHeader = (NE__Order_Header__c)(sObjMap.get('OrderHeader'));	
        System.debug(' NE__Order_Header__c dataMap :' + orderHeader);
        //Recupero legale_rappresentante
        Contact esecutore = (Contact)(sObjMap.get('legale_rappresentante'));
        
        System.debug('Dati totali nel save ' + data);
        Contact[] contacts = new Contact[]{}; 
            //Contact[] contacts = new List<Contact>();
            System.debug('Dati totali nel save ' + data);
        Account merchant = (Account)(sObjMap.get('merchant'));
        for (integer i = 1; i <= 6 ; i++){
            Contact c =  (Contact)(sObjMap.get('contact'+i));
            System.debug('LastName: '+c.LastName);
            if (c.LastName != 'ko' && c.LastName != '' && c.LastName != null && c.LastName != 'null'){
                c.AccountId = merchant.Id;
                contacts.add(c);
                System.debug('LastName: '+c.LastName + 'AccountId: '+c.AccountID);
            }else{
                break;
            }
        }
        system.debug('Numero dei contatti prima del try: ' + contacts.size());
        system.debug('contatti nella lista: ' + contacts[0]);
        try{
            upsert contacts;
            system.debug('Numero dei contatti inseriti: ' + contacts.size());
        } catch (DMLException e){  
            system.debug('There was a problem upserting the contacts:' + e.getStackTraceString());
        }
        Account acc = (Account)(sObjMap.get('merchant'));
        NE__Billing_Profile__c  bp = (NE__Billing_Profile__c)(sObjMap.get('NE__Account__c'));
        System.debug('il billing profile è: ' + bp);
        
        if(!String.isBlank(acc.Id)){
            upsert acc;
            system.debug('Aggiornamento di un account già esistente');
            //system.debug('oggetto billingProfile: ' + bp);
        }
        else{
            insert acc;
        }
        
        if(!String.isBlank(esecutore.Id)){
            upsert esecutore;
            system.debug('Aggiornamento di un esecutore già esistente');
            //system.debug('oggetto billingProfile: ' + bp);
        }
        else{
            insert esecutore;
        }
        
      /*  OB_OrderHeaderContactRelation__c junctionOrderContact = new OB_OrderHeaderContactRelation__c();
        List<OB_OrderHeaderContactRelation__c> listjunction = new List<OB_OrderHeaderContactRelation__c>();
        
        for(integer i=0;i<contacts.size();i++){
            junctionOrderContact.OB_Contact__c = contacts[i].Id;
            junctionOrderContact.OB_Order_Header__c =orderHeader.Id;
            listjunction.add(junctionOrderContact);
            
        }
        
        upsert listjunction;*/
        
        System.debug('Ho eseguito il save method');
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data=data;
        //response.stepToGo=5;
        return response;
        
    }
}