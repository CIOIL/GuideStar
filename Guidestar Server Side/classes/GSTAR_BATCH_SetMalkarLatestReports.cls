global class GSTAR_BATCH_SetMalkarLatestReports implements Database.Batchable<SObject>{

    string queryStr;

    global Database.QueryLocator start(Database.BatchableContext bc){
    	queryStr = 'select Id from obj where field = true ';
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<obj> malkars){
        GSTAR_TH_Reports_Approval.setMalkarLatestReports(malkars);
		update malkars;
    }
    
    global void finish(Database.BatchableContext bc){}
}