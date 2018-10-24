global class GSTAR_BATCH_Nihul_Takin_New_Year implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext bc){
		Decimal currentYear = Date.today().Year();
		string query = 'SELECT Id, field FROM obj WHERE field >= :currentYear order by field, field ';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<obj> scope){
		update scope;
	}

	global void finish(Database.BatchableContext bc){
	}
}