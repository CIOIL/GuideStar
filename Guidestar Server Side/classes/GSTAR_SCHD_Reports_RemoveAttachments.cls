global with sharing class GSTAR_SCHD_Reports_RemoveAttachments  implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GSTAR_BATCH_Reports_RemoveAttachments());
    }
}