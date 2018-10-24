global class GSTAR_BATCH_Reports_Approval_Find_Dupes implements Database.Batchable<SObject>, Database.Stateful{

	global List<Id> fileIds = new List<Id>();

    global List<AggregateResult> start(Database.BatchableContext bc){
    	//string query = 'SELECT count(Id) idCount, field, max(field) FROM obj GROUP BY field HAVING count(Id) > 1 AND max(field) > 2013 order by max(field) desc';
    	//string query = 'SELECT count(Id) idCount, field, max(field) FROM obj GROUP BY field HAVING count(Id) > 1 AND max(field) > 2013 AND max(RecordType.DeveloperName) != 'annual_takin_letter' order by max(field) desc';
        
        Map<String, obj> globalSettings = obj.getAll();
        string query = (string) globalSettings.get('GstarDuplicateReportsQuery_1').get('field');
        if(globalSettings.get('GstarDuplicateReportsQuery_2') != null){
        	query += ' ' + (string) globalSettings.get('GstarDuplicateReportsQuery_2').get('field');
        }
        System.debug(query);
    	return Database.query(query);
	}

    global void execute(Database.BatchableContext bc, List<AggregateResult> scope){
    	List<string> extIds = getExtIdList(scope);
    	if (extIds.size() == 0){
    		return;
    	}
    	List<obj> reportsApprovalList = [SELECT Id, field, field, field, 
    														field, objr.field, objr.Name, field
    													FROM obj
    													WHERE field IN :extIds
    													ORDER BY field, field];
    	if (fileIds.size() == 0){
    		createFile();
		}
		writeToFile(reportsApprovalList);
	}

    global void finish(Database.BatchableContext bc){
    	if (fileIds.size() > 0){
    		sendEmails();
    	}
	}

	private List<string> getExtIdList(List<AggregateResult> scope){
		Set<string> extIds = new Set<string>();
    	for (AggregateResult ar : scope){
    		if ((Integer)ar.get('idCount') > 1 ){
        		extIds.add((string)ar.get('field'));
    		}
    	}
    	return new List<string>(extIds);
	}

	private void createFile(){
		string filename = 'Duplicate Reports Approvals - '+ String.valueOf(Date.today()) + '_part' + String.valueOf(fileIds.size()+1);
		string folderId = (string)obj.getAll().get('GstarDuplicateReports').get('field');
		string htmlBody = '<!DOCTYPE html>';
		htmlBody += '<head>';
		htmlBody += '<style>';
		htmlBody += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 8px;}';
		htmlBody += 'table, tr:nth-child(even){background-color: #bfc4d4;}';
		htmlBody += 'table, tr:nth-child(odd){background-color: #fff;}';
		htmlBody += '</style>';
		htmlBody += '</head>';
		htmlBody += '<body>';
		htmlBody += '<table>';
		htmlBody += '<tr>';
		htmlBody += '<th>ExtId</th>';
		htmlBody += '<th>Organiztion Name</th>';
		htmlBody += '<th>Organiztion Number</th>';
		htmlBody += '<th>DocCenter Id</th>';
		htmlBody += '<th>Repo Id</th>';
		htmlBody += '</tr>';
		htmlBody += '</table>';
		htmlBody += '</body>';
		Document doc = new Document(
			Name = filename,
			Description = filename,
			Type = '.html',
			ContentType = 'text/html',
			FolderId = folderId,
			Body = Blob.valueOf(htmlBody)
			);
		insert doc;
		fileIds.add(doc.Id);
	}

	private void writeToFile(List<obj> reportsApprovalList){
		string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		Id fileId = fileIds[fileIds.size()-1];
		List<Document> docs = [SELECT Id, Body FROM Document WHERE Id = :fileId];
		if (docs.size() > 0){
			Blob fileBody = docs[0].Body;
			string htmlBody = fileBody.toString().substringBefore('</table></body>');
			for (obj ra : reportsApprovalList){
				htmlBody += '<tr>';
				htmlBody += '<td><a href="' + baseUrl + '/' + ra.Id + '">' + ra.field + '</a></td>';
				htmlBody += '<td>' + ra.objr.Name + '</td>';
				htmlBody += '<td><a href="' + baseUrl + '/' + ra.field + '">' + ra.objr.field + '</a></td>';
				htmlBody += '<td>' + ra.field + '</td>';
				htmlBody += '<td>' + ra.field + '</td>';
				htmlBody += '</tr>';
			}
			htmlBody += '</table>';
			htmlBody += '</body>';
			docs[0].Body = Blob.valueOf(htmlBody);
			try{
				update docs;
			}
			catch(Exception e){
				createFile();
				writeToFile(reportsApprovalList);
			}
		}
	}

	private void sendEmails(){
		string baseUrl = 'https://c.';
		baseUrl += URL.getSalesforceBaseUrl().getHost().substringBefore('.');
		baseUrl += '.content.force.com/servlet/servlet.FileDownload?file=';
		string toAddresses = (string)obj.getAll().get('GstarDuplicateReportsEmails').get('field');
		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
		msg.setSubject('Reports Approval duplicates found -' + String.valueOf(Datetime.now()));
		string htmlBody = 'Duplicate values for Reports Approvals were found. See attached or download ';
		Integer i=0;
		for (Id fileId : fileIds){
			htmlBody += '<a href="' + baseUrl + fileId + '">';
			htmlBody += 'file'+String.valueOf(i++);
			htmlBody += '</a> ';
		}
		msg.setHtmlBody(htmlBody);
		msg.setToAddresses(toAddresses.split(';'));
		msg.setFileAttachments(getAttachments());
		Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
	}

	private List<Messaging.EmailFileAttachment> getAttachments(){
		List<Messaging.EmailFileAttachment> returnList = new List<Messaging.EmailFileAttachment>();
		for (Document doc : [SELECT Id, Body, Type, Name FROM Document WHERE Id IN :fileIds]){
			Messaging.EmailFileAttachment eAttachment = new Messaging.EmailFileAttachment();
			eAttachment.setBody(doc.body);
    		eAttachment.setFileName(doc.Name + doc.Type);
    		returnList.add(eAttachment);
    	}
    	return returnList;
	}
}