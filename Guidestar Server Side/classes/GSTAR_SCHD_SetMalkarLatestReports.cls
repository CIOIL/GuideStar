global with sharing class GSTAR_SCHD_SetMalkarLatestReports  implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GSTAR_BATCH_SetMalkarLatestReports(), 10);
    }
}