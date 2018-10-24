public class CTRL_View_File{

	public obj reportApproval {get;set;}
	public Attachment file {get;set;}
	public string docName {get;set;}
	public string guid {get;set;}
	public boolean hasFile {get;set;}
	public string bufferString64 {get;set;}
	public string mojConfigId {get;set;}
	public string fileLink {get;set;}

	public CTRL_View_File(){
		if (ApexPages.currentPage().getParameters().containsKey('guid')){
			guid = ApexPages.currentPage().getParameters().get('guid');
		}
	}
	
	public String getTitle(){
		return docName != null ? docName : Label.VF_View_File_Title;
	}

	public PageReference findReportsApproval(){
		obj globalConfigId = obj.getValues('MojConfigId');
		if(globalConfigId != null && !String.isEmpty(globalConfigId.field)){
			mojConfigId = globalConfigId.field;
		}
		else{
			mojConfigId = '0375-0001';
		}
		List<obj> reportsList = [SELECT Id, Name, c, c, c, c, RecordType.Name, 
													RecordType.DeveloperName, c, c, objr.Name, c, objr.c,
													(SELECT Id, Name, Description, ContentType FROM Attachments)
													FROM obj 
													WHERE c = :guid];
		if (reportsList.size() > 0){
			reportApproval = reportsList[0];
			setDocName();
			if(reportApproval.c == false){
				if (reportApproval.Attachments == null || reportApproval.Attachments.size() == 0){
					bufferString64 = getBase64String();
					createAttachment();
				}
				else{
					file = reportApproval.Attachments[0];
				}	
			}
			updateReportsApproval();
			fileLink = getFileLink();
			if(reportApproval.c == true){
				return new PageReference(fileLink);
			}
		}
		return null;
	}
	
	private void setDocName(){
		if(reportApproval != null){
			if(reportApproval.RecordType.DeveloperName == 'annual_takin_letter'){
				docName = String.format('{0} {1} - {2}.pdf', new List<String>{reportApproval.objr.c ? Label.Approval_Submission_Documents : reportApproval.RecordType.Name, reportApproval.c, reportApproval.objr.Name});
			}
			else{
				docName = String.format('{0} {1} - {2}.pdf', new List<String>{reportApproval.RecordType.Name, reportApproval.c, reportApproval.objr.Name});				
			}
		}
	}

	private void createAttachment(){
		if (String.isBlank(bufferString64) || String.isBlank(docName) || reportApproval == null){
			return;
		}
		Attachment att = new Attachment(
			Name = docName,
			Body = EncodingUtil.base64Decode(bufferString64),
			ParentId = reportApproval.Id);
		insert att;
		file = att;
	}

	public string getFileLink(){
		if (file != null && String.isNotBlank(file.Id)){
			hasFile = true;
			string baseUrl = Site.getbaseUrl()!=''? Site.getbaseUrl() : '';
			baseUrl += '/servlet/servlet.FileDownload?file=';
			return baseUrl + file.Id;
		}
		else if(reportApproval != null && reportApproval.c == true){
			obj bigFileBaseUrl = obj.getValues('GstarBigFiles_BaseUrl');
			if(bigFileBaseUrl != null && !String.isEmpty(bigFileBaseUrl.field)){
				hasFile = true;
				return String.format('{0}/{1}.pdf', new List<String>{bigFileBaseUrl.field, reportApproval.c});
			}
		}
		return '';
	}

	private string getBase64String(){
		string str = sendWebserviceRequest();
		return str;
	}

	private void updateReportsApproval(){
		if (reportApproval != null){
			reportApproval.c = Datetime.now();
			update reportApproval;
		}
	}

	public string sendWebserviceRequest(){
		DocumentumSearch_API.BasicHttpBinding_IServices docx = new DocumentumSearch_API.BasicHttpBinding_IServices();
		DocumentumSearch_Data.OPMojId mojDoc = new DocumentumSearch_Data.OPMojId();
		mojDoc.ConfigId = mojConfigId;
		mojDoc.MojID = reportApproval.c;
		string returnStr = '';
		try{
			returnStr = docx.GetDocument(mojDoc).BufferString64;
		}
		catch(Exception e){
			sendErrorEmail(e, mojDoc);
		}
		finally{
			if (Test.isRunningTest()){
				returnStr = Blob.valueOf('String o').toString();
			}
			return returnStr;
		}
		return returnStr;
	}

	public void sendErrorEmail(Exception e, DocumentumSearch_Data.OPMojId mojDoc){
		string toAddresses = (string)obj.getAll().get('GstarAdminEmails').get('field');
		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
		msg.setSubject('An error has occurred while retrieving a document from Documentum-' + String.valueOf(Datetime.now()));
		string plainTextBody = e.getMessage() + '\n';
		plainTextBody += e.getCause() + '\n';
		plainTextBody += e.getLineNumber() + '\n';
		plainTextBody += e.getStackTraceString() + '\n';
		plainTextBody += JSON.serialize(mojDoc);
		msg.setPlainTextBody(plainTextBody);
		msg.setToAddresses(toAddresses.split(';'));
		Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
	}
    
}