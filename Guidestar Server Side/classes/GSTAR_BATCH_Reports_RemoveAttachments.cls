global class GSTAR_BATCH_Reports_RemoveAttachments implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext bc){
		DateTime yesterday = DateTime.now().addHours(-1);
		String reportsType = 'obj';
		if(Test.isRunningTest()){
			yesterday = DateTime.now().addHours(24);
		}
		string query = 'SELECT Id FROM Attachment WHERE Parent.Type = : reportsType AND CreatedDate < :yesterday';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<Attachment> scope){
		delete scope;
	}

	global void finish(Database.BatchableContext bc){
	}
}