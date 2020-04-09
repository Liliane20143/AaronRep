/**
 * author Emanuele Campese
 * @date Creation 18/12/2018
 * @version 1.0
 * @description Plc_WarehouseSolutionConsumedQtyBtc - Batch which updates field AvailableQty,OrderedQty,ConsumedQty on WarehouseSolution
 */
public with sharing class Plc_WarehouseSolutionConsumedQtyBtc extends Plc_MasterBatchable {

	public Decimal numOfDays;
	public Map<String,Boolean> workOrderConfigMap = null;//new Map<String,Boolean>();

	public Map<Id,Map<String,Plc_WarehouseProvince__c>> warehouseProvMap = null; //new Map<Id,Map<String,Double>>();
	public Map<String,Map<String,Plc_WarehouseProvince__c>> provWarehouseMap = null; //new Map<Id,Map<String,Double>>();
	public Map<String,id> lastWarehouse = null;//new Map<String,id>();
	public Map<String,Decimal> consumedForSolProv = new Map<String,Decimal> ();
	public List<Plc_WarehouseSolution__c> whSolutionUpd = new List<Plc_WarehouseSolution__c>();
	//public List<Plc_WarehouseSolution__c> whSolution2List = null;
	public Map<Id, Plc_WarehouseSolution__c> whSolution2List = null;
	public List<Plc_WarehouseSolution__c> whSolutionUpdated = null;//new List<Plc_WarehouseSolution__c>();
	public Map<String, Plc_SolutionProvince__c> solutionProvinceMap = null;//new Map<String, Plc_SolutionProvince__c>();
	public Map<String, Map<String,Plc_SolutionProvince__c>> provSolutionMap = null;
	public List<Plc_SolutionProvince__c> solutionProvinceList = null;
	public Boolean getAvlbOrderQtyDone = false;
	public Datetime executionTimestamp;
	public Datetime endTime;
	public Integer disinstalledCnt=0;
	public Integer installedCnt=0;
	public Integer queryLocatorCnt=0;
	//public Map<String, List<String>> provinceBySolution = null;
	public Integer fiscalPrinterCount = null;
	public Id outboundRecordTypeId = null;
	public Id inboundRecordTypeId = null; 

	//CRCAMPESE
	public Map<String,Integer> whSolutionSpecificQuantity = new Map<String,Integer>();
	

	/**
	 * @author Emanuele Campese
	 * @date Creation 18/12/2018
	 * @version 1.0
	 * @description implements the logic for the method defined in father class
	 *
	 * @param Nothing
	 * @return String - query to execute: Query to receive Shipment Line Item 
	 */
	override public String getDynamicQuery() {

		Plc_ProcessSettings__c PROCESS_SETTINGS = Plc_ProcessSettings__c.getInstance();		

		executionTimestamp = PROCESS_SETTINGS.Plc_CnsJobEndDate__c!=null?PROCESS_SETTINGS.Plc_CnsJobEndDate__c:Datetime.now();

		//lettura WorkOrderConfiguration per estrazione tipologie di WO abilitate al calcolo
		List<Plc_WorkOrderConfiguration__c> woConfig = [SELECT Name FROM Plc_WorkOrderConfiguration__c WHERE Plc_NeedsCalculation__c = true];
		List<String> names = new List<String>();
		for(Plc_WorkOrderConfiguration__c str : woConfig){
			names.add(str.name);
		}

		String wcFilter = String.join( names, '\',\'');

		outboundRecordTypeId = Plc_Utils.getRecordTypeId('Outbound_Shipment', 'Bit2Shop__Shipment__c');
		inboundRecordTypeId = Plc_Utils.getRecordTypeId('Inbound_Shipment', 'Bit2Shop__Shipment__c');

		//SA
		//Lettura data di ultima modifica da Plc_WarehouseSolution__c
		// MM COMMENTATO PER ESECUZIONE IN SYSPOS CON LA CURRENT DATE
		//Datetime wareHouseSolutionExecutionDate = Datetime.newInstance(1900, 1, 1, 0, 0, 0);		
		Datetime wareHouseSolutionExecutionDate = PROCESS_SETTINGS.Plc_CnsJobStartDate__c!=null?PROCESS_SETTINGS.Plc_CnsJobStartDate__c:Datetime.newInstance(2019, 03, 04, 0, 0, 0);
		// MM - FINE
		List<Plc_WarehouseSolution__c> wh_sol_date = [SELECT Id, Plc_ConsumedExecutionDate__c FROM Plc_WarehouseSolution__c ORDER BY Plc_ConsumedExecutionDate__c DESC Limit 1];
		
		if(wh_sol_date.size() > 0 ){
			if( wh_sol_date[0].Plc_ConsumedExecutionDate__c == null ){
				System.debug('Error found ! - WarehouseSolution: '+wh_sol_date[0].id+' has a null Plc_ConsumedExecutionDate__c');
				throw new Plc_Exception('WarehouseSolution: '+wh_sol_date[0].id+' has a null Plc_ConsumedExecutionDate__c');
			}
		}else{
			System.debug('Error found ! - WarehouseSolution List Is Null ');
			throw new Plc_Exception('Error found ! - WarehouseSolution List Is Null ');
		}
		wareHouseSolutionExecutionDate = wh_sol_date[0].Plc_ConsumedExecutionDate__c;

		
		
		

		String wareHouseSolutionExecutionDateString = wareHouseSolutionExecutionDate.formatGMT('yyyy-MM-dd') + 'T' + wareHouseSolutionExecutionDate.formatGMT('HH:mm:ss.SSS') + 'Z'; 
		String executionTimestampString = executionTimestamp.formatGMT('yyyy-MM-dd') + 'T' + executionTimestamp.formatGMT('HH:mm:ss.SSS') + 'Z';
		
		//String queryCnt = 'SELECT count(id) ';
		String query = ' SELECT Bit2Shop__Shipment_Id__c , Bit2Shop__Product_Stock_Id__c , ' +
					   ' RecordtypeId,Bit2Shop__Received_Quantity__c, '+
					   ' Plc_TransfertStatus__c, '+
					   ' Plc_StockSerial__r.Bit2Shop__Status__c, ' +
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c, '+
					   ' Bit2Shop__Shipment_Id__r.RecordtypeId , ' +
					   ' Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c, ' +
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.State, '+
					   //' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Bit2Shop__State_Province__c , ' +
					   //' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__r.Bit2Shop__State_Province__c , ' +
					   ' Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c, '+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__c,'+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.RecordTypeId, '+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c, '+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c, '+	
					   ' Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c, '+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__r.Plc_Tipology__c,'+
					   ' Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c ';

		String queryConditions = ' FROM Bit2Shop__Shipment_Line_Item__c ' +
		               //' WHERE  ( (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c=\'Installed\' AND Bit2Shop__Shipment_Id__r.RecordTypeId =\''+outboundRecordTypeId+'\')' +
		               ' WHERE  ( (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c=\'Installed\' AND Bit2Shop__Shipment_Id__r.RecordTypeId =\''+inboundRecordTypeId+'\')' +
					   ' OR (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__r.Plc_Tipology__c=\'Installed\' AND Bit2Shop__Shipment_Id__r.RecordTypeId =\''+inboundRecordTypeId+'\') )  ' +
		               //' AND (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Transfer_Type__c=\'Stock2OtherShop\') '+
		               ' AND (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.Status = \'Closed\') '+
		               //' AND (Bit2Shop__Date__c >= LAST_N_DAYS:'+numOfDays+') ';.
		               ' AND (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.RecordType.Name IN (\''+wcFilter+'\') )'+
		               ' AND (Plc_HandlingStatusDate__c > '+wareHouseSolutionExecutionDateString+' AND Plc_HandlingStatusDate__c <= '+executionTimestampString+') AND Plc_HandlingStatusDate__c!=null';

		query = query + queryConditions;
		System.debug('QUERY TO EXECUTE: '+query);
		//queryCnt = queryCnt + queryConditions;
		
		LogTracker.debugLog(getBatchName(), 'getDynamicQuery', query);
		//Integer queryLocatorCnt = Database.countQuery(queryCnt);
		return query;

	}

	/**
	 * @author Emanuele Campese
	 * @date Creation 18/12/2018
	 * @version 1.0
	 * @description implements the logic for the method defined in father class
	 *
	 * @param Nothing
	 * @return String - batch's name
	 */
	override public String getBatchName() {

		return Plc_WarehouseSolutionConsumedQtyBtc.class.getName();
	}

	public void initDomains(){
		System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT DOMAINS : START');
		// INIT SOLUTION+PROVINCE MAP
		
		if(solutionProvinceMap == null){
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT SOLUTIONPROVINCE : START');
			solutionProvinceMap = new Map<String,Plc_SolutionProvince__c>();
			provSolutionMap = new Map<String, Map<String,Plc_SolutionProvince__c>>();
			//provinceBySolution = new Map<String, List<String>>();
			solutionProvinceList = [SELECT Plc_Province__c, Plc_Quantity__c, Plc_Solution__c FROM Plc_SolutionProvince__c ORDER BY Plc_Province__c DESC, Plc_Solution__c DESC];
			for(Plc_SolutionProvince__c sp : solutionProvinceList){
				solutionProvinceMap.put(sp.Plc_Solution__c+'_'+sp.Plc_Province__c, sp);
				if(!provSolutionMap.containsKey(sp.Plc_Province__c)){
					provSolutionMap.put(sp.Plc_Province__c,new Map<String,Plc_SolutionProvince__c>());
				}
				provSolutionMap.get(sp.Plc_Province__c).put(sp.Plc_Solution__c,sp);
			}
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT SOLUTIONPROVINCE : END ['+solutionProvinceMap.size()+']');
		}

		// INIT WAREHOUSE+PROVINCE LIST
		// Plc_DistributionPercentage__c : 20
		// Plc_Province__c: (2) 255
		// Plc_Warehouse__c: 18
		// Total : 22 / row		
		if ( warehouseProvMap == null ) {
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT WAREHOUSEPROVINCE : START');
			warehouseProvMap = new Map<Id,Map<String,Plc_WarehouseProvince__c>>();
			provWarehouseMap = new Map<String,Map<String,Plc_WarehouseProvince__c>>();
			for(Plc_WarehouseProvince__c warehouseProvince : [SELECT Plc_DistributionPercentage__c,Plc_Province__c,Plc_Warehouse__c FROM Plc_WarehouseProvince__c]){
				String keyPrv = warehouseProvince.Plc_Province__c!=null?String.valueOf(warehouseProvince.Plc_Province__c).trim():warehouseProvince.Plc_Province__c;
				String whKey = warehouseProvince.Plc_Warehouse__c;	
				if(!warehouseProvMap.containsKey(whKey)){
					warehouseProvMap.put(whKey, new Map<String, Plc_WarehouseProvince__c>());
				}
				warehouseProvMap.get(whKey).put(keyPrv, warehouseProvince);

				if(!provWarehouseMap.containsKey(keyPrv)){
					provWarehouseMap.put(keyPrv, new Map<String, Plc_WarehouseProvince__c>());
				}
				provWarehouseMap.get(keyPrv).put(whKey, warehouseProvince);
				//warehouseProvMap.put(whKey,warehouseProvince);
			}
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT WAREHOUSEPROVINCE : END ['+warehouseProvMap.size()+']');	
		}
		System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT DOMAINS : END');

		// INIT WORKORDER CONFIG MAP
		//Plc_WorkOrderConfiguration__c
		// - Name : 80
		// - Plc_NeedsCalculation__c : 1
		// Total : 81 / row
		if ( workOrderConfigMap == null) {
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT WORKORDER CONFIG : START');
			workOrderConfigMap = new Map<String,Boolean>();			
			for(Plc_WorkOrderConfiguration__c workOrderConfiguration:[SELECT Name,Plc_NeedsCalculation__c,Plc_EligibleOperationTypes__c FROM Plc_WorkOrderConfiguration__c WHERE Plc_EligibleOperationTypes__c!='NoOperation']){
				workOrderConfigMap.put(workOrderConfiguration.Name,workOrderConfiguration.Plc_NeedsCalculation__c);
			}
			System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH INIT WORKORDER CONFIG : END ['+workOrderConfigMap.size()+']');
		}

		if(	fiscalPrinterCount == null){

		}
	}


	public void addSolutionMap(String solution, String province, Decimal value){
		String key = solution+'_'+province;
		if(!solutionProvinceMap.containsKey(key)){
			Plc_SolutionProvince__c sp = new Plc_SolutionProvince__c(
				Plc_Province__c = province, 
				Plc_Quantity__c = 0, 
				Plc_Solution__c = solution
			);
			solutionProvinceMap.put(key, sp);
		}								
		Plc_SolutionProvince__c sp = solutionProvinceMap.get(key);								
		sp.Plc_Quantity__c+=value;
	}
	/**
	 * @author Emanuele Campese
	 * @date Creation 18/12/2018
	 * @version 1.0
	 * @description implements the EXECUTION logic
	 *
	 * @param batchableContext - Database.BatchableContext
	 * @param shipmentLineItems - list of shipmentLineItems
	 * @return void - Nothing
	 */
	
	public void execute(Database.BatchableContext batchableContext, List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItems)  {

		System.debug('*|Plc_WarehouseSolutionConsumedQtyBtc|* BATCH EXECUTE !');
		System.debug('*|Query Results '+shipmentLineItems.size()+'|*');
		Plc_Utils utils = new Plc_Utils();
		String batchName = getBatchName();
		LogTracker.debugLogBegin(batchName, 'execute', '');
		String key;

		try {

			initDomains();

			LogTracker.debugLog(batchName, 'execute', 'TEST');
			
			System.debug('workOrderConfigurationMap: '+workOrderConfigMap);


			for(Bit2Shop__Shipment_Line_Item__c shipLineItem : shipmentLineItems){

					if(shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c=='Installed'
						&& shipLineItem.Bit2Shop__Shipment_Id__r.RecordTypeId == inboundRecordTypeId/*outboundRecordTypeId*/ ){

						System.debug('HERE: Type Disinstalled');
						System.debug('---------------------------------------------------------');						
				

						if( (shipLineItem.RecordtypeId==Plc_Utils.getRecordTypeId('Shipment_Line_Item_Serial', 'Bit2Shop__Shipment_Line_Item__c'))  
							/* MM NON ESISTE A CRM -- && (shipLineItem.Plc_TransfertStatus__c=='OK')*/ ){
							
								System.debug('HERE: Serial ');
								if(shipLineItem.Plc_StockSerial__r.Bit2Shop__Status__c=='Available'){
									//#CRCAMPESE Controllo se è una Stampante con lo sku corretto, dopodichè si inserisce + o - in una variabile ad-hoc, recupero della soluzione dall'external catalog item e inserimento in una variabile ad hoc
										String solution = shipLineItem.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c;
										String whProv = shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.State;
										key = solution+'_'+whProv;
										
										//CRCAMPESE
									
										if(shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c != null){
											String keyDisinstalled = shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c+'_'+solution;
											if(!whSolutionSpecificQuantity.containsKey(keyDisinstalled)){
												whSolutionSpecificQuantity.put(keyDisinstalled,0);
											}	
											whSolutionSpecificQuantity.put(keyDisinstalled,whSolutionSpecificQuantity.get(keyDisinstalled)-1);
										}else{
											addSolutionMap(solution, whProv, -1);
										}
									
									disinstalledCnt++;
									
								}
								
							
						}
						System.debug('---------------------------------------------------------');
					}

					else if(shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__r.Plc_Tipology__c=='Installed' &&
						shipLineItem.Bit2Shop__Shipment_Id__r.RecordTypeId == inboundRecordTypeId){

						System.debug('HERE: Type Installed');
						System.debug('---------------------------------------------------------');
						 

						 
						if( (shipLineItem.RecordtypeId==Plc_Utils.getRecordTypeId('Shipment_Line_Item_Serial', 'Bit2Shop__Shipment_Line_Item__c')) ){
							//#CRCAMPESE Controllo se è una Stampante con lo sku corretto, dopodichè si inserisce + o - in una variabile ad-hoc, recupero della soluzione dall'external catalog item e inserimento in una variabile ad hoc
							
							System.debug('HERE: Serial ');
							String solution = shipLineItem.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c;
							String whProv = shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__r.State;
							key = solution+'_'+whProv;							

							//CRCAMPESE
							
							if(shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c != null){
								String keyInstalled = shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Plc_WarehouseForSpecificConsumption__c+'_'+solution;
								if(!whSolutionSpecificQuantity.containsKey(keyInstalled)){
									whSolutionSpecificQuantity.put(keyInstalled,0);
								}	
								whSolutionSpecificQuantity.put(keyInstalled,whSolutionSpecificQuantity.get(keyInstalled)+1);
							}else{
								addSolutionMap(solution, whProv, 1);
							}
							

					 		installedCnt++;
							
							
						}
						System.debug('---------------------------------------------------------');

					}
				//}
				System.debug('***************************************************************************');
			}


			System.debug('MAPPA SOLUTION PROVINCE: '+solutionProvinceMap.size());
			System.debug(solutionProvinceMap);			
			System.debug('Plc_Solution__c,Plc_Province__c,Plc_Quantity__c');
			for(Plc_SolutionProvince__c sp:solutionProvinceMap.values()){				
				System.debug(sp.Plc_Solution__c+','+sp.Plc_Province__c+','+sp.Plc_Quantity__c);
			}
   			
		} catch (Exception ex) {

			String message = 'EXCEPTION Stack Trace String :'+ex.getStackTraceString()+' Line Number: '+ex.getLineNumber();
			LogTracker.debugLog(batchName, 'execute', message);
		
		    Plc_ProcessSettings__c PROCESS_SETTINGS = Plc_ProcessSettings__c.getInstance();		
			if(!PROCESS_SETTINGS.Plc_CnsJobDisableExceptionThrowing__c){
				throw new Plc_Exception(message);
			}
			
		}

		LogTracker.debugLogEnd(batchName, 'execute', '');
		
	} 

	public void ripartisciConsolidato(){
		
		//Map<String, List<Plc_WarehouseSolution__c>> whSolutions = new Map<String, List<Plc_WarehouseSolution__c>>();
		Map<String, Plc_WarehouseSolution__c> whSolExt = new Map<String, Plc_WarehouseSolution__c>();
		if(whSolution2List==null){
			whSolution2List = new Map<Id,Plc_WarehouseSolution__c>([SELECT Id,Plc_ConsumedQty__c,Plc_Solution__c,Plc_Warehouse__c ,Plc_SpecificConsumedQty__c, Plc_Warehouse__r.Plc_Alias__c  FROM Plc_WarehouseSolution__c ]);
			for(Plc_WarehouseSolution__c p:whSolution2List.values()){
					String key;
					p.Plc_ConsumedQty__c=0;
					/*if(!whSolutions.containsKey(p.Plc_Solution__c)){whSolutions.put(p.Plc_Solution__c, new List<Plc_WarehouseSolution__c>());}
					whSolutions.get(p.Plc_Solution__c).add(p);*/
					key = p.Plc_Warehouse__c+'_'+p.Plc_Solution__c;
					System.debug('@@@ WHSOL : '+key);
				
				p.Plc_ConsumedExecutionDate__c = executionTimestamp;
				whSolExt.put(key,p);
				
			}			
		}
		
		if(provSolutionMap==null || provSolutionMap.size()==0){
			provSolutionMap = new Map<String, Map<String,Plc_SolutionProvince__c>>();
			for(Plc_SolutionProvince__c sp : solutionProvinceList){
				System.debug('@@ sp : '+sp);				
				if(!provSolutionMap.containsKey(sp.Plc_Province__c)){
					provSolutionMap.put(sp.Plc_Province__c,new Map<String,Plc_SolutionProvince__c>());
					System.debug('@@ create  : '+sp.Plc_Province__c);
				}
				provSolutionMap.get(sp.Plc_Province__c).put(sp.Plc_Solution__c,sp);
				System.debug('@@ put  : '+sp.Plc_Province__c+'-'+sp.Plc_Solution__c);
			}	
		}


			
		
		// CICLO TUTTE LE PROVINCE + SOLUZIONE ordinate per PROV e SOL
		Map<String, Map<String, Map<String, ProvinceSolutionWarehouseWrapper>>> whSolPerProv = new Map<String, Map<String, Map<String, ProvinceSolutionWarehouseWrapper>>>();
		System.debug('== solutionProvinceList size : '+solutionProvinceList.size());
		for(Plc_SolutionProvince__c solProv: solutionProvinceList){					
			String province = solProv.Plc_Province__c;
			//String solution = solProv.Plc_Solution__c;		
			if(!whSolPerProv.containsKey(province)){
				whSolPerProv.put(province,new Map<String, Map<String, ProvinceSolutionWarehouseWrapper>>());
			}
			Map<String, Map<String, ProvinceSolutionWarehouseWrapper>> solsPerProv = whSolPerProv.get(province);

			System.debug('==== province  : '+province);
			//PER OGNI PROVINCIA RECUPERO TUTTE LE SOLUTION
			if(provWarehouseMap.containsKey(province)){
				Map<String,Plc_SolutionProvince__c> solPerProvince = provSolutionMap.get(province);
				Map<String,Plc_WarehouseProvince__c> whPerProvince = provWarehouseMap.get(province);	
				/*
				System.debug('==== provSolutionMap  : '+provSolutionMap);
				System.debug('==== provWarehouseMap  : '+provWarehouseMap);
				System.debug('==== solPerProvince  : '+solPerProvince);
				System.debug('==== whPerProvince  : '+whPerProvince); 
				*/
				if(solPerProvince!= null && solPerProvince.size()>0){

					
					for(String solId:solPerProvince.keySet()){
						System.debug('====== solution  : '+solId);
						if(!solsPerProv.containsKey(solId)){
							solsPerProv.put(solId, new Map<String, ProvinceSolutionWarehouseWrapper>());
						}					
						Map<String, ProvinceSolutionWarehouseWrapper> whPerProvSol = solsPerProv.get(solId);

						ProvinceSolutionWarehouseWrapper lastPsww = null;
						if(whPerProvince!=null && whPerProvince.size()>0){

							
							for(String whId:whPerProvince.keySet()){
								//System.debug('======== warehouse  : '+whId);
								String keyWhSolPerProv = whId+'_'+solId;
								if(whSolExt.containsKey(keyWhSolPerProv)){
									Plc_WarehouseSolution__c whsol = whSolExt.get(keyWhSolPerProv);
									Plc_WarehouseProvince__c whp = whPerProvince.get(whId);					
									ProvinceSolutionWarehouseWrapper psww = new ProvinceSolutionWarehouseWrapper();
									psww.province = province;
									psww.solution = solId;
									psww.warehouse = whsol.Plc_Warehouse__c;
									psww.percent = whp.Plc_DistributionPercentage__c;
									whPerProvSol.put(whsol.Plc_Warehouse__c, psww);
									

									//System.debug('========== psww  : [province:'+psww.province+'] [solution:'+psww.solution+'] [warehouse:'+psww.warehouse+'] [percent:'+psww.percent+']');

									lastPsww = psww;
								}
							}
							if(lastPsww!=null){lastPsww.isLast=true;}
						}
											
					}
				}			
				
			}
		}
		
		System.debug('## provinces  : '+whSolPerProv.size());		
		for(String province:whSolPerProv.keySet()){
			Map<String,Map<String,ProvinceSolutionWarehouseWrapper>> solutionPerProvince = whSolPerProv.get(province);
			
			//System.debug('#### province  : '+province);		
			for(String solutionId:solutionPerProvince.keySet()){
				Map<String,ProvinceSolutionWarehouseWrapper> whsPerSolutionProvince = solutionPerProvince.get(solutionId);
				String solProvKey = solutionId+'_'+province;
				Plc_SolutionProvince__c solProv  = solutionProvinceMap.get(solProvKey);
				Decimal totalSolProvQty = solProv.Plc_Quantity__c;
				Decimal partialQty = 0;

				/*
				System.debug('###### solutionId  : '+solutionId);	
				System.debug('###### totalSolProvQty  : '+totalSolProvQty);
				System.debug('###### partialQty  : '+partialQty);
				*/
				for(String whPerSolProv:whsPerSolutionProvince.keySet()){
					//System.debug('######## whPerSolProv  : '+whPerSolProv);
					ProvinceSolutionWarehouseWrapper whpsp = whsPerSolutionProvince.get(whPerSolProv);
					//System.debug('######## whpsp  : '+whpsp);	
					String whkey = whpsp.warehouse+'_'+whpsp.solution;
					//System.debug('######## whkey  : '+whkey);
					Plc_WarehouseSolution__c whsol = whSolExt.get(whkey);
					//System.debug('######## whsol  : '+whsol);
					if(whsol!=null){
						Decimal currentValue = whsol.Plc_ConsumedQty__c;
						Decimal perc = whpsp.percent;		
						Decimal value = totalSolProvQty * (perc/100);
						if(!whpsp.isLast){
							value = value.round();
							partialQty+=value;
						}else{
							value = totalSolProvQty - partialQty;
						}
						
						//System.debug('######## perc  : '+perc);	
						//System.debug('######## currentValue  : '+currentValue);	
						//System.debug('######## value  : '+value);

						whsol.Plc_ConsumedQty__c = currentValue+value;

						
						//System.debug('######## ['+whsol.Id+']whsol.Plc_ConsumedQty__c  : '+whsol.Plc_ConsumedQty__c);
					}
					
				}
			}
		}

		System.debug('== whSolExt:'+whSolExt.size());

		//CRCAMPESE
		for(Plc_WarehouseSolution__c wh : whSolExt.values()){
			System.debug('WarehouseSolution ID : '+wh.Id+' consumedSpecific : '+wh.Plc_ConsumedQty__c+' '+wh.Plc_SpecificConsumedQty__c);
			wh.Plc_ConsumedQty__c = wh.Plc_ConsumedQty__c + wh.Plc_SpecificConsumedQty__c;
		}
		
		
		
		upsert whSolExt.values();
	}

	public class ProvinceSolutionWarehouseWrapper{
		String province;
		String solution;
		String warehouse;
		Decimal percent;	
		Boolean isLast=false;	
	}

	/*
	public void ripartisciConsolidato(){
		
		// 
		if(whSolution2List==null){
			whSolution2List = [SELECT Id,Plc_ConsumedQty__c,Plc_Solution__c,Plc_Warehouse__c FROM Plc_WarehouseSolution__c order by Plc_Warehouse__c,Plc_Solution__c DESC];
		}
		String lastKey = '';
		Plc_WarehouseSolution__c lastWs = null;
		Decimal lastPartials = 0;
		Decimal lastTotal = 0;
		Integer lastCount = 0;

		whSolutionUpdated = new List<Plc_WarehouseSolution__c>();
		for(Plc_WarehouseSolution__c ws:whSolution2List){
			String currentKey=ws.Plc_Warehouse__c+'_'+ws.Plc_Solution__c;
			ws.Plc_ConsumedExecutionDate__c = executionTimestamp;
			ws.Plc_ConsumedQty__c=0;
			if(lastKey!=currentKey){
				//ROTTURA DI CHIAVE, MODIFICARE ULTIMO WS
				if(lastWs!=null && lastCount>1){
					lastWs.Plc_ConsumedQty__c=lastTotal-lastPartials;
				}
				lastKey=currentKey;
				lastWs=ws;
				lastPartials=0;
				lastTotal=0;
				lastCount=0;
			}
			System.debug('============ 1');
			System.debug('============ ws.Plc_Warehouse__c '+ws.Plc_Warehouse__c);
			System.debug('============ warehouseProvMap '+warehouseProvMap);
			if(warehouseProvMap.containsKey(ws.Plc_Warehouse__c)){
				Map<String,Plc_WarehouseProvince__c> whpMap = warehouseProvMap.get(ws.Plc_Warehouse__c);
				for(String prov:whpMap.keySet()){
					System.debug('============ 1');			
					String wsProvince = prov;// warehouseProvMap.get(ws.Plc_Warehouse__c).Plc_Province__c;				
					String solProvKey = ws.Plc_Solution__c+'_'+wsProvince;
					if(solutionProvinceMap.containsKey(solProvKey)){
						System.debug('solutionProvinceMap contains : '+solProvKey);
						Decimal totalSPQty = solutionProvinceMap.get(solProvKey).Plc_Quantity__c;
						//Decimal pPerc = provPercbyWh.get(wsProvince);
						Decimal pPerc = whpMap.get(wsProvince).Plc_DistributionPercentage__c;//warehouseProvMap.get(ws.Plc_Warehouse__c).Plc_DistributionPercentage__c;
						Decimal value = totalSPQty * (pPerc/100);
						System.debug('solutionProvinceMap totalSPQty : '+totalSPQty);
						System.debug('solutionProvinceMap pPerc : '+pPerc);
						System.debug('solutionProvinceMap value : '+value);
						value = value.round();
						lastPartials+=value;
						lastTotal=totalSPQty;
						lastCount++;
						ws.Plc_ConsumedQty__c=value;
						System.debug('solutionProvinceMap Plc_ConsumedQty__c : '+ws.Plc_ConsumedQty__c);
						whSolutionUpdated.add(ws);
					}

				}				
			}
		}
		if(lastWs!=null && lastCount>1){
			lastWs.Plc_ConsumedQty__c=lastTotal-lastPartials;
		}

		System.debug('whSolutionUpdated : '+whSolutionUpdated);
		upsert whSolution2List;

		upsert whSolutionUpdated;
	}*/

	public void finish(Database.BatchableContext batchableContext) {
        
        

   		Integer whsUpsert = 0;
		Plc_ProcessSettings__c PROCESS_SETTINGS = Plc_ProcessSettings__c.getInstance();		

        try{
        	

        	initDomains();
			
			//CRCAMPESE
			System.debug('whSolutionSpecificQuantity:'+ whSolutionSpecificQuantity);
			if(!whSolutionSpecificQuantity.isEmpty()){

				Set<String> listOfSolution = new Set<String>();
				Set<String> listOfWarehouse = new Set<String>();
				List<Plc_WarehouseSolution__c> whSolToUpdate = new List<Plc_WarehouseSolution__c>();

				for(String valueWHSOL : whSolutionSpecificQuantity.keySet() ){
					String[] addressFull = valueWHSOL.split('_');
					listOfWarehouse.add(addressFull[0]);
					listOfSolution.add(addressFull[1]);
				}

				for(Plc_WarehouseSolution__c whSol :[SELECT Id,Plc_Solution__c,Plc_Warehouse__c,Plc_SpecificConsumedQty__c FROM Plc_WarehouseSolution__c WHERE Plc_Solution__c IN: listOfSolution AND Plc_Warehouse__c IN: listOfWarehouse]){
					System.debug('whSol.Plc_Warehouse__cwhSol.Plc_Solution__c : '+whSol.Plc_Warehouse__c+'_'+whSol.Plc_Solution__c);
					whSol.Plc_SpecificConsumedQty__c = whSol.Plc_SpecificConsumedQty__c+whSolutionSpecificQuantity.get(whSol.Plc_Warehouse__c+'_'+whSol.Plc_Solution__c);
					whSolToUpdate.add(whSol);
				}
				System.debug('whSolToUpdate' + whSolToUpdate);
				update whSolToUpdate;
			}
			
        	if(!PROCESS_SETTINGS.Plc_CnsJobDisableConsolidated__c){
	        	if(solutionProvinceMap!=null && solutionProvinceMap.size()>0){
	        		solutionProvinceList=solutionProvinceMap.values();
		        	upsert solutionProvinceMap.values();
		        	whsUpsert = solutionProvinceMap.size();
		    	}
	    	}

			if(!PROCESS_SETTINGS.Plc_CnsJobDisableConsolidatePartition__c){
	    		ripartisciConsolidato();
	    	}

	    	Integer whSolution2Size = whSolution2List.size();

			//Integer whSolutionUSize = whSolutionUpdated.size();

	    	String content='Installed: ['+installedCnt+']\nDisinstalled: ['+disinstalledCnt+']\nSolution Province Updated: ['+whsUpsert+']\nWarehouse Solution Updated: ['+whSolution2Size+']';
	    	endTime = Datetime.now();
	    	Plc_Log__c log = createLog('S',executionTimestamp,executionTimestamp,endTime, content);
	    	insert log;
    	}catch(Exception e){
    		endTime = Datetime.now();
    		String content = e.getMessage();
    		Plc_Log__c log = createLog('E',executionTimestamp,executionTimestamp,endTime, content);
			System.debug('Exception '+e.getMessage()+' '+e.getStackTraceString());
    		insert log;
    		if(!PROCESS_SETTINGS.Plc_CnsJobDisableExceptionThrowing__c){
				throw new Plc_Exception(e);
			}
    	}
        
    }


    public Plc_Log__c createLog(String status, Datetime ts, Datetime startTime, Datetime endTime, String content){
    	Decimal elapsedTime = endTime.getTime() - startTime.getTime();
    	String totalExecTime = 'Init:'+String.valueOf(startTime)+'; End: '+String.valueOf(endTime)+'; TotExec: '+elapsedTime;
    	String recordId = Plc_Utils.getRecordTypeId('Plc_Batch', 'Plc_Log__c') ;
    	//Init: 2018-12-10 15:36:31; End: 2018-12-10 15:36:31; TotExec: 97
		Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
		Plc_Log__c log = new Plc_Log__c(
			 Plc_RequestType__c = 'POST'
			,Plc_ResponseStatus__c = status
			,Plc_Timestamp__c = String.valueOf(ts)
			,Plc_ProcessingTime__c = totalExecTime
			,Plc_TotalExecutionTime__c = elapsedTime
			,Plc_RequestBody__c = content
			,Plc_RequestURI__c='batch-consumed'
			,RecordTypeId=recordId
			,Plc_SchedulerName__c = batchToRetrieve.Plc_SchedulerClassName__c
		);

		return log;
    }

}