global class GSTAR_BATCH_SetMainClassification implements Database.Batchable<SObject>{

    string queryStr;

    global Database.QueryLocator start(Database.BatchableContext bc){
    	queryStr = 'select Id from obj';
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<obj> scope){
        for (obj ma : scope){
            ma.field = null;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext bc){}
}