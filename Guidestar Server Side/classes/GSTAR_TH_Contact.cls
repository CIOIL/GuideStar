public class GSTAR_TH_Contact{

	public static void populateEmailListField(List<Contact> newList, Map<Id, Contact> oldMap){
		List<string> fieldList = new List<string>{'c', 'c','Email'};
		List<Contact> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
		if (relevantRecords.size() > 0){
			calculateEmailListField(relevantRecords, oldMap);
		}
	}

	private static void calculateEmailListField(List<Contact> relevantRecords, Map<Id, Contact> oldMap){
		for (Contact con : relevantRecords){
			Set<string> emailList = new Set<string>();
			if (con.Id != null && oldMap.containsKey(con.Id) && String.isNotEmpty(oldMap.get(con.Id).c)){
				emailList.addAll(oldMap.get(con.Id).c.split('\n'));
			}
			//else if (String.isNotEmpty(con.c)){
			//	emailList.addAll(con.c.split(';'));
			//}
			if (String.isNotEmpty(con.Email)){
				emailList.add(con.Email);
			}
			if (String.isNotEmpty(con.c)){
				emailList.add(con.c);
			}
			con.c = String.join(new List<string>(emailList), '\n');
		}
	}

	private static List<Contact> findRelevantModifiedRecords(List<Contact> newList, Map<Id, Contact> oldMap, List<String> relevantFields){
		Set<Contact> retSet = new Set<Contact>();
		Contact tempContact;
		for (Contact con : newList){
			tempContact = oldMap != null ? oldMap.get(con.Id) : null;
			for (String field : relevantFields){
				if ((tempContact == null && con.get(field) != null)  || (tempContact != null && con.get(field) != tempContact.get(field))){
					retSet.add(con);
				}
			}
		}
		return new List<Contact>(retSet);
	}
}