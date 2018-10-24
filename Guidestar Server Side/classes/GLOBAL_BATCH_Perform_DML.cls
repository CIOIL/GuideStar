global class GLOBAL_BATCH_Perform_DML implements Database.Batchable<SObject>{

    string queryStr;

    public GLOBAL_BATCH_Perform_DML(string query){
        this.queryStr = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        /*for (obj ra : scope){
            ra.field = null;
        }*/
        update scope;
    }
    
    global void finish(Database.BatchableContext bc){}
}