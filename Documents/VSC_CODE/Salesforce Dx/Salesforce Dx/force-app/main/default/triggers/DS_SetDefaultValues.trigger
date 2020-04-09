trigger DS_SetDefaultValues on Case (before insert, before update) {

    Map<ID, RecordType> caseRTMap = New Map<ID, RecordType>([Select ID, Name From RecordType Where sObjectType = 'Case']);

    for (Case obj: trigger.new){
        if(!caseRTMap.get(obj.recordTypeID).name.containsIgnoreCase('Offer Variation'))
            continue;
        
        //Map<ID, RecordType> productRTMap= New Map<ID, RecordType>([Select ID, Name From RecordType Where sObjectType = 'Account']);
        //Verifico se ci sono altri token -- da fare online per sharing token
        if (obj.Status == 'Autorizzata')
        {          
            List<RecordType> productsRT = [SELECT ID From RecordType where Name = 'Offer Variation Token' AND sObjectType = 'Account' LIMIT 1];
            List<Account> l = 
                    [SELECT Id, 
                            DS_Token_Totali__c,
                            DS_Token_Usati__c,
                            DS_Token_Disponibili__c
                     FROM Account
                     WHERE Id = :obj.DS_Token__c
                     AND recordTypeID = :productsRT[0].Id
                     LIMIT 1];
            if (l[0].DS_Token_Disponibili__c <= 0)
                obj.addError('Il venditore non ha più gettoni disponibili');
                //throw new Exception('Il venditore non ha più gettoni disponibili');
        }
    
        DS_TokenSettings__mdt[] defMixTransato = 
                    [SELECT MasterLabel, 
                            DS_Mix_Riferimento_CD__c, 
                            DS_Mix_Riferimento_COMMERCIAL__c,
                            DS_Mix_Riferimento_PB__c,
                            DS_Mix_Riferimento_EEA__c
                    FROM DS_TokenSettings__mdt
                    WHERE MasterLabel = :obj.DS_DefCatMercMix__c
                    LIMIT 1
                    ];
                    
        obj.DS_MailingList__c = obj.DS_Email_Banca__c;
        
        // Fill Mix transato fields based on Settore merceologico e Negoziato annuo
        Double cd = 0, comm = 0, pb = 0, eea = 0;
        obj.DS_Mix_Riferimento_CD_RO__c = cd;
        obj.DS_Mix_Riferimento_COMM_RO__c = comm;
        obj.DS_Mix_Riferimento_PB_RO__c = pb;
        obj.DS_Mix_Riferimento_EEA_RO__c = eea;
            
        if (defMixTransato.size() > 0) {
            obj.DS_Mix_Riferimento_CD_RO__c = defMixTransato[0].DS_Mix_Riferimento_CD__c;
            obj.DS_Mix_Riferimento_COMM_RO__c = defMixTransato[0].DS_Mix_Riferimento_COMMERCIAL__c;
            obj.DS_Mix_Riferimento_PB_RO__c = defMixTransato[0].DS_Mix_Riferimento_PB__c;
            obj.DS_Mix_Riferimento_EEA_RO__c = defMixTransato[0].DS_Mix_Riferimento_EEA__c;
        }
        
        defMixTransato.clear();
        defMixTransato = 
                    [SELECT MasterLabel, 
                            DS_Mix_Riferimento_CD__c, 
                            DS_Mix_Riferimento_COMMERCIAL__c,
                            DS_Mix_Riferimento_PB__c,
                            DS_Mix_Riferimento_EEA__c
                    FROM DS_TokenSettings__mdt
                    WHERE MasterLabel = :obj.DS_Tipo_Offerta_F__c
                    LIMIT 1
                    ];
        
        obj.DS_Riferimento_CD_RO__c = cd;
        obj.DS_Riferimento_Commercial_RO__c = comm;
        obj.DS_Riferimento_PagoBancomat_RO__c = pb;
        obj.DS_Riferimento_Extra_EEA_RO__c = eea;
        if (defMixTransato.size() > 0) {
            obj.DS_Riferimento_CD_RO__c = defMixTransato[0].DS_Mix_Riferimento_CD__c;
            obj.DS_Riferimento_Commercial_RO__c = defMixTransato[0].DS_Mix_Riferimento_COMMERCIAL__c;
            obj.DS_Riferimento_PagoBancomat_RO__c = defMixTransato[0].DS_Mix_Riferimento_PB__c;
            obj.DS_Riferimento_Extra_EEA_RO__c = defMixTransato[0].DS_Mix_Riferimento_EEA__c;
        }        
        
        Integer total = 0;
        if (obj.DS_Mix_Transato_CD__c != NULL && obj.DS_Mix_Transato_COMM__c != NULL && obj.DS_Mix_Transato_PB__c != NULL && obj.DS_Mix_Transato_EEA__c != NULL)
        	total = Integer.valueOf(obj.DS_Mix_Transato_CD__c + obj.DS_Mix_Transato_COMM__c + obj.DS_Mix_Transato_PB__c + obj.DS_Mix_Transato_EEA__c);
        
        if (total <> 100){
            obj.DS_Merchant_Fee_Lorda__c = 
            ((obj.DS_Mix_Riferimento_CD_RO__c *  obj.DS_Custom_CD__c / 100) + 
            (obj.DS_Mix_Riferimento_COMM_RO__c *   obj.DS_Custom_Commercial__c / 100) + 
            (obj.DS_Mix_Riferimento_PB_RO__c *   obj.DS_Custom_PagoBancomat__c / 100) + 
            (obj.DS_Mix_Riferimento_EEA_RO__c  *   obj.DS_Custom_Extra_EEA__c / 100));
        }
        else {
            obj.DS_Merchant_Fee_Lorda__c = 
            ((obj.DS_Mix_Transato_CD__c *  obj.DS_Custom_CD__c / 100) + 
            (obj.DS_Mix_Transato_COMM__c *   obj.DS_Custom_Commercial__c / 100) + 
            (obj.DS_Mix_Transato_PB__c *  obj.DS_Custom_PagoBancomat__c / 100) + 
            (obj.DS_Mix_Transato_EEA__c  *   obj.DS_Custom_Extra_EEA__c / 100));
        }

        //Maggiorazioni        
        obj.DS_Magg_EEA_vs_CeditoDebito__c= 0;
        if (obj.DS_Custom_Extra_EEA__c - obj.DS_Custom_CD__c >= 0){
            obj.DS_Magg_EEA_vs_CeditoDebito__c= obj.DS_Custom_Extra_EEA__c - obj.DS_Custom_CD__c;
        }
        
        obj.DS_Magg_EEA_vs_Commercial__c= 0;
        if (obj.DS_Custom_Extra_EEA__c - obj.DS_Custom_Commercial__c>= 0){
            obj.DS_Magg_EEA_vs_Commercial__c= obj.DS_Custom_Extra_EEA__c - obj.DS_Custom_Commercial__c;
        }
        
        // Riferimenti maggiorazioni
        obj.DS_Rifermento_Magg_EEA_vs_CreditoDebito__c = 0;
        if (obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Riferimento_CD_RO__c >= 0){
            obj.DS_Rifermento_Magg_EEA_vs_CreditoDebito__c = obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Riferimento_CD_RO__c ;
        }

        obj.DS_Riferimento_Magg_EEA_vs_Commercial__c = 0;        
        if (obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Riferimento_Commercial_RO__c >= 0){
            obj.DS_Riferimento_Magg_EEA_vs_Commercial__c = obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Riferimento_Commercial_RO__c ;
        }
        
        // Descrizione Margine
        if (total <> 100){
            obj.DS_Margine__c = (
            (obj.DS_Mix_Riferimento_CD_RO__c * (obj.DS_Custom_CD__c - obj.DS_Costi_CD__c)) + 
            (obj.DS_Mix_Riferimento_COMM_RO__c * (obj.DS_Custom_Commercial__c - obj.DS_Costi_Commercial__c)) + 
            (obj.DS_Mix_Riferimento_PB_RO__c * (obj.DS_Custom_PagoBancomat__c - obj.DS_Costi_PagoBancomat__c)) + 
            (obj.DS_Mix_Riferimento_EEA_RO__c * (obj.DS_Custom_Extra_EEA__c - obj.DS_Costi_Extra_EEA__c))
            ) / 100;
            obj.DS_Riferimento_Margine__c =(
            (obj.DS_Mix_Riferimento_CD_RO__c * (obj.DS_Riferimento_CD_RO__c - obj.DS_Costi_CD__c)) + 
            (obj.DS_Mix_Riferimento_COMM_RO__c * (obj.DS_Riferimento_Commercial_RO__c - obj.DS_Costi_Commercial__c)) + 
            (obj.DS_Mix_Riferimento_PB_RO__c * (obj.DS_Riferimento_PagoBancomat_RO__c - obj.DS_Costi_PagoBancomat__c)) + 
            (obj.DS_Mix_Riferimento_EEA_RO__c * (obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Costi_Extra_EEA__c))
            ) / 100;
        }
        else{
            obj.DS_Margine__c = (
            (obj.DS_Mix_Transato_CD__c * (obj.DS_Custom_CD__c - obj.DS_Costi_CD__c)) + 
            (obj.DS_Mix_Transato_COMM__c * (obj.DS_Custom_Commercial__c - obj.DS_Costi_Commercial__c)) + 
            (obj.DS_Mix_Transato_PB__c * (obj.DS_Custom_PagoBancomat__c - obj.DS_Costi_PagoBancomat__c)) + 
            (obj.DS_Mix_Transato_EEA__c * (obj.DS_Custom_Extra_EEA__c - obj.DS_Costi_Extra_EEA__c))
            ) / 100;
            obj.DS_Riferimento_Margine__c =(
            (obj.DS_Mix_Transato_CD__c * (obj.DS_Riferimento_CD_RO__c - obj.DS_Costi_CD__c)) + 
            (obj.DS_Mix_Transato_COMM__c * (obj.DS_Riferimento_Commercial_RO__c - obj.DS_Costi_Commercial__c)) + 
            (obj.DS_Mix_Transato_PB__c * (obj.DS_Riferimento_PagoBancomat_RO__c - obj.DS_Costi_PagoBancomat__c)) + 
            (obj.DS_Mix_Transato_EEA__c * (obj.DS_Riferimento_Extra_EEA_RO__c - obj.DS_Costi_Extra_EEA__c))
            ) / 100;
        }
       
       if (obj.DS_Margine__c < 0) obj.DS_Margine__c = 0;

       obj.DS_Descrizione_Margine__c = 'Offerta a marginalità approvata: puoi procedere con l\'autorizzazione diretta!';            
       if( obj.DS_Margine__c < 0.30){
           obj.DS_Descrizione_Margine__c = 'ATTENZIONE: sotto 0,30% di MARGINALITA\' devi richiedere approvazione tramite deroga full';
       }
       
       defMixTransato.clear();
       defMixTransato = 
                    [SELECT DS_Note_Offerta__c
                    FROM DS_TokenSettings__mdt
                    WHERE DS_Tipo_Offerta__c = :obj.DS_TipoOfferta__c
                     AND  DS_Bank__c = :obj.DS_BankSelected__c
                    LIMIT 1
                    ];
       
       
       obj.DS_Note_Offerta__c = defMixTransato[0].DS_Note_Offerta__c;
       
       defMixTransato.clear();
       defMixTransato = 
                    [SELECT DS_CodAgenzia__c
                    FROM DS_TokenSettings__mdt
                    WHERE DS_IsCodiciAgenzie__c = true
                     AND  DS_Bank__c = :obj.DS_BankSelected__c
                    LIMIT 1
                    ];
                    
       obj.DS_Descrizione_Agenzia__c = 'Codice agenzia non trovato';                    
       List<String> agenzie = defMixTransato[0].DS_CodAgenzia__c.split(';');
       for (string agenzia : agenzie){
            List<String> codDescAgenzia = agenzia.split('-');
            if (codDescAgenzia[0]==obj.DS_Codice_Agenzia__c)
            {
                string v = codDescAgenzia[0] + '-';
                obj.DS_Descrizione_Agenzia__c = agenzia.replace(v, '');
                break;
            }
       }
       agenzie.clear();
       
       /*
       switch on obj.DS_TipoOfferta__c { 
         when '29 - ISPIRATA A CLASSIC+ BASE' { 
            DS_BankSelected__c
            obj.DS_Note_Offerta__c = 'Per punto vendita che non vuole l’importo commissionale minimo: prevede il listino POS base'; 
         }     
         when '26 - ISPIRATA A CLASSIC+ SPECIAL' { 
            obj.DS_Note_Offerta__c = 'Per punto vendita di cliente SME che NON ha quota rilevante di clientela EEA : prevede listino POS SPECIAL e l’importo commissionale minimo'; 
         }
         when '27 - ISPIRATA A MONDO+ SPECIAL' { 
            obj.DS_Note_Offerta__c = 'Per punto vendita  con quota rilevante di clientela EEA: prevede il listino POS SPECIAL, l’importo commissionale minimo e il Servizio DCC con retrocessione al merchant dello 0,90%'; 
         }
       }
       */
       
     }
}