public class GSTAR_ReportsApprovals_Invocable_DelAtt{

    @InvocableMethod
    public static void deleteReportApprovalAttachments(List<Id> recordIds){
        List<Attachment> toDelete = new List<Attachment>();
        for (obj ra : [SELECT Id, (SELECT Id FROM Attachments) FROM obj WHERE Id IN :recordIds]){
            toDelete.addAll(ra.Attachments);
            Utils.log(ra);
        }
        delete toDelete;
    }
}