global class GLOBAL_SCHD_PerformQueryReports implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GLOBAL_BATCH_PerformQueryReports(), 1);
    }
}