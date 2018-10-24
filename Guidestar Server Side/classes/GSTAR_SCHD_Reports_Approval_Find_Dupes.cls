global class GSTAR_SCHD_Reports_Approval_Find_Dupes implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GSTAR_BATCH_Reports_Approval_Find_Dupes());
    }
}