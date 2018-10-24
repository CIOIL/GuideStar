public class GSTAR_TH_Malkar{

	public static void renameHeletz(List<obj> newList){
		for (obj malkar : newlist){
			if (String.isNotBlank(malkar.c) && malkar.c == 'חל"ץ'){
				malkar.c = GSTAR_Utils.HeletzPicklistValue;
			}
		}
	}

	public static void populateSecondaryClassification(List<obj> newList, Map<Id, obj> oldMap){
		if (oldMap != null && oldMap.size() > 0){
			List<string> fieldList = new List<string>{
				'c', 'c','c', 'c',
				'c', 'c', 'c', 'c',
				'c', 'c', 'c', 'c'
			};
			Set<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
			for (obj malkar : newList){
				if ((String.isBlank(malkar.c) || String.isBlank(malkar.c) ||
					 String.isBlank(malkar.c) || String.isBlank(malkar.c) ||
					 String.isBlank(malkar.c) || malkar.c == null) &&
					 malkar.c != null && malkar.c != '21'){
					relevantRecords.add(malkar);
				}
			}
			if (relevantRecords.size() > 0){
				populateSecondaryClassification(new List<obj>(relevantRecords));
			}
		}
	}

	public static void populateSecondaryClassification(List<obj> newList){
		for (obj malkar : newlist){
			
			Decimal addDataSecClassNum = 0;
			if(String.isNotBlank(malkar.c)){
				try{
					addDataSecClassNum = Decimal.valueOf(malkar.c);
				}
				catch(Exception e){
					Utils.log(e.getMessage());
				}
			}
			
			if(String.isNotBlank(malkar.c)){
				//the manager must enter a reason if he change the classification
				if(String.isBlank(malkar.c)){
					malkar.addError(Label.GSTAR_ERROR_CLSS_ManagerReasonMisssing);
				}
				writeFieldSecondarySetting(malkar, 'c', 'c');
				writeTextFields(malkar);
				checkMainCustomSetting(malkar);
			}
			else if (String.isNotBlank(malkar.c) && addDataSecClassNum > 24 && String.isNotBlank(malkar.c)){
				malkar.c = malkar.c;
				malkar.c = malkar.c;
				writeTextFields(malkar);
				checkMainCustomSetting(malkar);
			}
			else if(String.isNotBlank(malkar.c)){
				writeFieldSecondarySetting(malkar, 'c', 'c');
				writeTextFields(malkar);
				checkMainCustomSetting(malkar);
			}
			else if(String.isNotBlank(malkar.c)){
				writeTchumPeilutSecondarySetting(malkar);
				writeTextFields(malkar);
				checkMainCustomSetting(malkar);
				writeHalamasSecondarySetting(malkar);
			}
			else if(String.isNotBlank(malkar.c)){
				writeHalamasSecondarySetting(malkar);
				writeTextFields(malkar);
				checkMainCustomSetting(malkar);
			}
			else{
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
				malkar.c = '';
			}
		}
	}

	public static void updateMalkarLocation(List<obj> newList,  Map<Id, obj> oldMap){
		//List<string> fieldList = new List<string>{'c'};
		//List<obj> relevantRecords = new List<obj>(findRelevantModifiedRecords(newlist, oldMap, fieldList));
		if (newList.size() > 0){
    		obj NumDistricts = obj.getValues('NumDistricts');
    		Integer maxDistricts = 999;
    		if(NumDistricts != null && !String.isEmpty(NumDistricts.field)){
    			maxDistricts = Integer.valueOf(NumDistricts.field);
    		}
    		for (obj malkar : newList){
    			if(String.isNotBlank(malkar.c)){
    				Set<string> districts = (Set<string>) JSON.deserialize(malkar.c, Set<string>.class);
    				malkar.c = districts.size() <= maxDistricts ? false : true;
    			}
    			else{
    				malkar.c = false;
    			}
    		}
		}
	}

	public static void pretifyLastLocation(List<obj> newList){
		for (obj malkar : newList){
			if (String.isNotEmpty(malkar.c)){
				malkar.c = malkar.c.replace(',', ', ').normalizeSpace();
			}
		}
	}

	public static void setLocationChanged(List<obj> newList, Map<Id, obj> oldMap){
		List<String> relevantFields = new List<String>{'c', 'c', 'c' , 'c' };
		Set<obj> relevantRecords = findRelevantModifiedRecords(newList, oldMap, relevantFields);
		if (relevantRecords.size() > 0){
			for (obj m : relevantRecords){
				m.c = true;
			}
		}
	}

	private static Set<obj> findRelevantModifiedRecords(List<obj> newList, Map<Id, obj> oldMap, List<String> relevantFields){
		Set<obj> retSet = new Set<obj>();
		obj tempMalkar;
		for (obj m : newList){
			tempMalkar = oldMap != null ? oldMap.get(m.Id) : null;
			for (String field : relevantFields){
				if ((tempMalkar == null && m.get(field) != null)  || (tempMalkar != null && m.get(field) != tempMalkar.get(field))){
					retSet.add(m);
				}
			}
		}
		return retSet;
	}

	private static void writeTextFields(obj malkar){
		Map<string, c> settingsMap = c.getAll();
		if (String.isBlank(malkar.c)){
			malkar.c = '';
		}
		if (String.isBlank(malkar.c)){
			malkar.c = '';
		}
		if (String.isBlank(malkar.c)){
			malkar.c = '';
		}
		if (String.isBlank(malkar.c)){
			malkar.c = '';
		}
		for (c setting : settingsMap.values()){
			if (String.isNotBlank(setting.c) && malkar.c == setting.c){
				malkar.c = setting.c;
			}
			if (String.isNotBlank(setting.c) && malkar.c == setting.c){
				malkar.c = setting.c;
			}
			if (String.isNotBlank(setting.c) && malkar.c == setting.c){
				malkar.c = setting.c;
			}
			if (String.isNotBlank(setting.c) && malkar.c == setting.c){
				malkar.c = setting.c;
			}
		}
	}

	private static void writeSecondaryClass(obj malkar, c setting){
		malkar.c = setting.c;
		malkar.c = setting.c;
	}

	private static void writeTchumPeilutSecondarySetting(obj malkar){
		//Is it 21 or 99? get from halamas
		if (malkar.c == '21' || malkar.c == '99'){
			malkar.c = '';
			return;
		}
		Map<string, c> settingsMap = c.getAll();
		for (c setting : settingsMap.values()){
			if (String.isNotBlank(setting.c) && malkar.c == setting.c){
				writeSecondaryClass(malkar, setting);
			}
		}
	}

	private static void writeFieldSecondarySetting(obj malkar, string textField, string numField){
		//Is it 21 or 99? get from halamas
		String fieldNum = (String)malkar.get(numField);
		if (fieldNum == '21' || fieldNum == '99'){
			malkar.put(numField, '');
			return;
		}
		Map<string, c> settingsMap = c.getAll();
		Set<string> secondText = new Set<string>();
		Set<string> secondNum = new Set<string>();
		
		Set<String> tchumPeilutSecondary;
		if(String.isNotBlank(fieldNum)){
	        if(fieldNum.startsWith('[')){
				tchumPeilutSecondary = (Set<String>) JSON.deserialize(fieldNum, Set<String>.class);
			}
			else{
				tchumPeilutSecondary = new Set<String>{ fieldNum };
			}
        }
		
		for (c setting : settingsMap.values()){
			if (String.isNotBlank(setting.c) && tchumPeilutSecondary != null && tchumPeilutSecondary.contains(setting.c)){
				secondText.add(setting.c);
				secondNum.add(setting.c);
			}
		}

		if (secondText.size() > 0 || secondNum.size() > 0){
			malkar.put(textField, JSON.serialize(secondText));
			malkar.c = JSON.serialize(secondText);
			malkar.c = JSON.serialize(secondNum);
		}
	}

	private static void writeHalamasSecondarySetting(obj malkar){
		Map<string, c> settingsMap = c.getAll();
		if (String.isBlank(malkar.c)||
			String.isBlank(malkar.c)){
			for (c setting : settingsMap.values()){
				if (String.isNotBlank(setting.c) && malkar.c == setting.c &&
					String.isBlank(setting.c)){
					writeSecondaryClass(malkar, setting);
				}
			}
		}
		else{
			Set<string> mainNum = (Set<string>) JSON.deserialize(malkar.c, Set<string>.class); //new Set<string>(malkar.c.split(';'));
			for (c setting : settingsMap.values()){
				if(String.isNotBlank(setting.c) && malkar.c == setting.c &&
					malkar.c.contains('אחר')){
					if(mainNum.contains(setting.c) && !setting.c){
						writeSecondaryClass(malkar, setting);
					}
				}
			}
		}
	}

	private static void checkMainCustomSetting(obj malkar){
		Map<string, c> settingsMap = c.getAll();
		Set<string> mainText = new Set<string>();
		Set<string> mainNum = new Set<string>();
		String mainTextReports, mainNumReports;
		
		Set<String> tchumPeilutSecondary;
		if(String.isNotBlank(malkar.c)){
	        if(malkar.c.startsWith('[')){
				tchumPeilutSecondary = (Set<String>) JSON.deserialize(malkar.c, Set<String>.class);
			}
			else{
				tchumPeilutSecondary = new Set<String>{ malkar.c };
			}
        }
		
		for (c setting : settingsMap.values()){
			if (tchumPeilutSecondary != null && tchumPeilutSecondary.contains(setting.c)){
				mainText.add(setting.c);
				mainNum.add(setting.c);
				
				mainTextReports = setting.c;
				mainNumReports = setting.c;
			}
		}

		if (mainText.size() > 0 || mainNum.size() > 0){
			malkar.c = JSON.serialize(mainText);
			malkar.c = JSON.serialize(mainNum);
		}
		else{
			malkar.c = '';
			malkar.c = '';
		}
		
		malkar.c = String.isNotBlank(mainTextReports) ? mainTextReports : '';
		malkar.c = String.isNotBlank(mainNumReports) ? mainNumReports : '';
	}
}