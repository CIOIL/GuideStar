global class GSTAR_SCHD_Donation_Age implements Schedulable{

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new GSTAR_BATCH_Donation_Age());
    }
}