global class GLOBAL_BATCH_Complex_Report implements Database.Batchable<SObject>, Database.Stateful{

	global List<Id> fileIds = new List<Id>();
	
	private  string title;

	private string queryStr;

	public GLOBAL_BATCH_Complex_Report(string reportTitle, string query){
		this.queryStr = query;
		this.title = reportTitle;
	}

	global List<AggregateResult> start(Database.BatchableContext bc){
    	return Database.query(queryStr);
	}

	global void execute(Database.BatchableContext bc, List<AggregateResult> scope){
		if (fileIds.size() == 0){
    		createFile(scope[0]);
		}
		writeToFile(scope);
	}

	global void finish(Database.BatchableContext bc){
	}

	private void createFile(AggregateResult result){
		string filename = title + ' - ' + String.valueOf(Date.today()) + '_part' + String.valueOf(fileIds.size()+1);
		string folderId = (string)obj.getAll().get('ReportsFolder').get('field');
		Map<string, Object> aggregateResultMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(result));
		aggregateResultMap.remove('attributes');
		string htmlBody = '<!DOCTYPE html>';
		htmlBody += '<head>';
		htmlBody += '<style>';
		htmlBody += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 8px;}';
		htmlBody += 'table, tr:nth-child(even){background-color: #bfc4d4;}';
		htmlBody += 'table, tr:nth-child(odd){background-color: #fff;}';
		htmlBody += '</style>';
		htmlBody += queryStr;
		htmlBody += '</head>';
		htmlBody += '<body>';
		htmlBody += '<table>';
		htmlBody += '<tr>';
		for (string key : aggregateResultMap.keySet()){
			htmlBody += '<th>'+key+'</th>';
		}		
		htmlBody += '</tr>';
		htmlBody += '</table>';
		htmlBody += '</body>';
		Document doc = new Document(
			Name = filename,
			Description = filename + ' ' + queryStr,
			Type = '.html',
			ContentType = 'text/html',
			FolderId = folderId,
			Body = Blob.valueOf(htmlBody)
			);
		insert doc;
		fileIds.add(doc.Id);
	}

	private void writeToFile(List<AggregateResult> results){
		Id fileId = fileIds[fileIds.size()-1];
		List<Document> docs = [SELECT Id, Body FROM Document WHERE Id = :fileId];
		System.debug('docs: ' + docs);
		if (docs.size() > 0){
			Blob fileBody = docs[0].Body;
			string htmlBody = fileBody.toString().substringBefore('</table></body>');
			for (AggregateResult result : results){
				Map<string, Object> aggregateResultMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(result));
				aggregateResultMap.remove('attributes');
				htmlBody += '<tr>';
				for (string key : aggregateResultMap.keySet()){
					htmlBody += '<td>'+ String.valueOf(aggregateResultMap.get(key)) +'</td>';
				}
				htmlBody += '</tr>';
			}
			htmlBody += '</table>';
			htmlBody += '</body>';
			docs[0].Body = Blob.valueOf(htmlBody);
			try{
				update docs;
			}
			catch(Exception e){
				System.debug('Exception caught! ' + e);
				createFile(results[0]);
				writeToFile(results);
			}
		}
	}

}