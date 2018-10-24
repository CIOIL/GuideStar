global class GSTAR_BATCH_Donation_Age implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'SELECT Id, field, field FROM obj';
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<obj> scope){
        Decimal currentYear = Date.today().Year();
        for (obj don : scope){
            don.field = currentYear - don.field;
        }
        update scope;
    }

    global void finish(Database.BatchableContext bc){
    }
}