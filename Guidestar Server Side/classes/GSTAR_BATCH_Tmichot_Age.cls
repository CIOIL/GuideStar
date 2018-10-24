global class GSTAR_BATCH_Tmichot_Age implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'SELECT Id, field, field FROM obj';
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<obj> scope){
        GSTAR_TH_Tmihot.setAge(scope);
        update scope;
    }

    global void finish(Database.BatchableContext bc){
    }
}