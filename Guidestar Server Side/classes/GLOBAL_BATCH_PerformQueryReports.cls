global class GLOBAL_BATCH_PerformQueryReports implements Database.Batchable<SObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, field, field FROM obj');
    }
    
    global void execute(Database.BatchableContext bc, List<obj> reportsData){
    	List<obj> toUpdate = new List<obj>();
        for (obj rd : reportsData){
            if(rd != null){
            	Decimal total = getTotal(rd.field);
            	system.debug('total');
            	system.debug(total);
            	if(total != null){
            		rd.field = total;
            		toUpdate.add(rd);
            	}
            }
        }
        
        if(!toUpdate.isEmpty()){
        	update toUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){}
    
    global static Decimal getTotal(String queryStr){
    	Decimal total = 0;
    	List<AggregateResult> result = Database.query(queryStr);
    	for(AggregateResult ar :result){
    		total += (Decimal) ar.get('Sum');
    	}
    	return total;
    }
}