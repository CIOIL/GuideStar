public class GSTAR_DAL{    
    
    public static final Integer CHUNK_SIZE = 50;
    public class MyException extends Exception{} 
    
    public static User getUserInfo(Id userId){
    	return [select Id, Profile.Name, Name, FirstName, LastName, Email, Phone from User where Id =: userId];
    }
    
    public static List<obj> getAllMalkars() {
        String queryStr = 'select ' + getMalkarFields() + ' from obj ';
        queryStr += ' LIMIT 1000 ';
        return (List<obj>)Database.query(queryStr);
    }

    public static List<obj> getMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId){
        return getMalkarsByChunk(fieldName, value, isDesc, lastId, null);
    }
    
    public static List<obj> getMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter){
        return getMalkarsByChunk(fieldName, value, isDesc, lastId, myFilter, CHUNK_SIZE, getMalkarFields());
    }

    public static List<obj> getMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult, String selectedFields){
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
            return searchMalkarsByChunk(fieldName, value , isDesc , lastId, myFilter, numOfResult, selectedFields);
        }
        return selectMalkarsByChunk(fieldName, value , isDesc , lastId, myFilter, numOfResult, selectedFields);
    }
    
    public static List<obj> selectMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter){
        return selectMalkarsByChunk(fieldName, value, isDesc, lastId, myFilter, CHUNK_SIZE);
    }
    public static List<obj> selectMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult){
        return selectMalkarsByChunk(fieldName, value, isDesc, lastId, myFilter, numOfResult, getMalkarFields());
    }
    public static List<obj> selectMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult, String selectedFields){
        String queryStr = 'select ' + selectedFields + ' from obj ';
        if(!String.isBlank(fieldName) && value != null){
        	if(isDesc)
        		queryStr += ' Where ( ' + fieldName + ' < :value or (' + fieldName + ' = :value and Id > :lastId )) ';
        	else
        		queryStr += ' Where ( ' + fieldName + ' > :value or (' + fieldName + ' = :value and Id > :lastId )) ';
        }
        else{
        	queryStr += ' Where  Id > :lastId ';
        }
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	queryStr += ' AND Name Like \'%' + myFilter.Search + '%\' '; 
        	//queryStr += ' AND field = true ';
        }
        queryStr += getNewConditionClause(myFilter);
        
        //order by
        if(!String.isBlank(fieldName)){
        	queryStr += ' order by '+ fieldName;
	        if(isDesc){
	        	queryStr += ' desc NULLS LAST, Id ';
	        }
	        else{
	        	queryStr += ' asc NULLS LAST, Id ';
	        }
        }
        else{
        	queryStr += ' order by Id ';
        }
        
        if(numOfResult != null){
        	queryStr += ' LIMIT :numOfResult';
        }
        Utils.log('queryStr');
		Utils.log(queryStr);
		Utils.log(String.format('fieldName :{0}, value: {1}, lastId: {2}', new List<String> {fieldName, String.valueOf(value), lastId}));
        if (myFilter != null){
            Utils.log('searchWord');
            Utils.log( myFilter.Search);
        }
        
        List<obj> LmLKr = (List<obj>)Database.query(queryStr);
        return LmLKr;
    }
    
    public static List<obj> searchMalkarsByName(GSTAR_Utils.FilterWrapper myFilter){
        return searchMalkarsByName(myFilter, 20);
    }
    
    public static List<obj> searchMalkarsByName(GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult){
        String malkarFields = getMalkarFields();
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	String queryStr = 'FIND \'' + myFilter.Search + '*\' IN Name FIELDS RETURNING obj(' + malkarFields;
	        queryStr += ' Where Id != null ';
	        queryStr += getNewConditionClause(myFilter);
	        queryStr += ' AND field = true ';
	        queryStr += ' LIMIT :numOfResult ';
	        queryStr += ' ) ';
	        
	        Utils.log('queryStr');
    		Utils.log(queryStr);
	        return (List<obj>)search.query(queryStr)[0];
        }
        throw new MyException('searchMalkarsByChunk error');
    }
    
    public static List<obj> searchMalkarsByChunk(GSTAR_Utils.FilterWrapper myFilter){
        return searchMalkarsByChunk(null, null, null, null, myFilter);
    }
    
    public static List<obj> searchMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter){
        return searchMalkarsByChunk(fieldName, value , isDesc , lastId, myFilter, CHUNK_SIZE);
    }
    
    public static List<obj> searchMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult){
        return searchMalkarsByChunk(fieldName, value , isDesc , lastId, myFilter, numOfResult, getMalkarFields());
    }
    
    public static List<obj> searchMalkarsByChunk(string fieldName, object value, boolean isDesc, Id lastId, GSTAR_Utils.FilterWrapper myFilter, Integer numOfResult, String selectedFields){
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	Integer offset = myFilter.pageNumber != null && numOfResult != null ? myFilter.pageNumber * numOfResult : 0;
            if (offset >=2000){
                return new List<obj>();
            }
            else{
            	String queryStr = 'FIND \'' + myFilter.Search + '*\' IN ALL FIELDS RETURNING obj(' + selectedFields;
    	        queryStr += ' Where Id != null ';
    	        queryStr += getNewConditionClause(myFilter);
    	        //order by
    	        if(String.isNotBlank(fieldName)){
    	        	queryStr += ' order by '+ fieldName;
    		        if(isDesc){
    		        	queryStr += ' desc ';
    		        }
    		        else{
    		        	queryStr += ' asc ';
    		        }
    	        }
    	        else{
    	        	queryStr += ' order by field desc ';
    	        }
    	        
    	        if(numOfResult != null){
    	        	queryStr += ' LIMIT :numOfResult ';
    	        }
    	        queryStr += ' OFFSET :offset ) ';
    	        
    	        Utils.log('queryStr');
        		Utils.log(queryStr);
        		Utils.log(String.format('offset :{0}, numOfResult: {1}' , new List<String> {String.valueOf(offset), String.valueOf(numOfResult)}));
            
    	        return (List<obj>)search.query(queryStr)[0];
            }
        }
        throw new MyException('searchMalkarsByChunk error');
    }
    
    public static Integer getMalkarCount(GSTAR_Utils.FilterWrapper myFilter){
        String malkarFields = getMalkarFields();
        String queryStr = 'select count(id) countmalkar  ';
        //queryStr += ' field, field, field, field,  ';
        // queryStr += ' field, field, field, field,  ';
        // queryStr += ' field,  ';
        // queryStr += ' sum(field), sum(field), sum(field), min(field), min(field)  ';
        queryStr += ' from obj ';
        queryStr += ' group by field ';


        if((myFilter.Sug_Hitagdut != null && !myFilter.Sug_Hitagdut.isEmpty()) 
        		|| myFilter.CurrentNihulTakinActive == true 
			 	|| myFilter.Approval46 == true
			  	|| myFilter.Reported_Last_3_Years == true
			  	|| String.isNotBlank(myFilter.MalkarLocation)){
			  		
        	queryStr += ' , field ';
        }
        if(myFilter.CurrentNihulTakinActive == true){
        	queryStr += ' , field ';
        }
        if(myFilter.Approval46 == true){
        	queryStr += ' , field ';
        }
        if(myFilter.Reported_Last_3_Years == true){
        	queryStr += ' , field ';
        }
        if(myFilter.ADMN_GovSupportSum == true){
        	queryStr += ' , field ';	
        }
        if(myFilter.ADMN_Gov_Connection_Sum == true){
        	queryStr += ' , field ';	
        }
        if(myFilter.ADMN_Foreign_Entity_Donation_Sum == true){
        	queryStr += ' , field ';	
        }
        //Turnover
        if(myFilter.Turnover != null && !myFilter.Turnover.isEmpty()){
        	/*if(myFilter.Turnover[0] != null && myFilter.Turnover[0] > 0){
        		queryStr += ' , field ';	
        	}
        	if(myFilter.Turnover.size() > 1 && myFilter.Turnover[1] != null && myFilter.Turnover[1] > 0){
        		queryStr += ' , field ';	
        	}*/
        	//queryStr += ' , field ';
        } 
        if(myFilter.CLSS_Main_Classification_Num != null && !myFilter.CLSS_Main_Classification_Num.isEmpty()){
        	queryStr += ' , field ';
        }
        if(myFilter.CLSS_Secondary_Classification_Num != null && !myFilter.CLSS_Secondary_Classification_Num.isEmpty()){
        	queryStr += ' , field ';
        }
        if(!String.isEmpty(myFilter.MalkarLocation)){
        	if(myFilter.MalkarLocation.startsWithIgnoreCase(Utils_RemoteAction.DISTRICT_LABEL_CODE)){
        		queryStr += ' ,  field ';
        	}
        	else if(myFilter.MalkarLocation.equalsIgnoreCase(Utils_RemoteAction.National_Similar_Type)){
        		queryStr += ' ,  field ';
        	}
            else{
            	queryStr += ' ,  field ';
            }
        }

        queryStr += ' HAVING field = true ';
        queryStr += getNewConditionClause(myFilter, true, true);
        system.debug('queryStr: '+queryStr);
        List<AggregateResult> ars = (List<AggregateResult>)Database.query(queryStr);
        Integer countmalkar = 0;
        if(!ars.isEmpty()){
        	for(AggregateResult ar: ars){
	        	countmalkar += Integer.valueOf(ar.get('countmalkar'));
        	}
        }
        system.debug('Count getMalkarCount: '+countmalkar);
        return countmalkar;
    }
    
    public static String getNewConditionClause(GSTAR_Utils.FilterWrapper myFilter){
    	return getNewConditionClause(myFilter, true, false);
    }
    
    public static String getNewConditionClause(GSTAR_Utils.FilterWrapper myFilter, Boolean isStatusActive, Boolean forAggregateFunction){
    	String conditionClause = '';
    	conditionClause += isStatusActive ? ' AND field = true ' : '';
        if(myFilter != null){
            Datetime now = Datetime.now();
            String year = String.valueof(now.year());
            String hekdesh = 'הקדש';

            if(myFilter.CurrentNihulTakinActive == true){
            	//conditionClause += ' AND  (field =  \'' + hekdesh + '\'   OR field = true )';
            	conditionClause += ' AND  ( field = true )';
            }
            if(myFilter.Approval46 == true){
                //conditionClause += ' AND  (field =  \'' + hekdesh + '\'   OR field = true )';
                conditionClause += ' AND  ( field = true )';
            }
            if(myFilter.Reported_Last_3_Years == true){
                //conditionClause += ' AND  (field =  \'' + hekdesh + '\'   OR field = true )';
                conditionClause += ' AND  ( field = true ) ';
            }
            if(myFilter.ADMN_GovSupportSum == true){
            	conditionClause += ' AND  field = true ';	
            }
            if(myFilter.ADMN_Gov_Connection_Sum == true){
            	conditionClause += ' AND  field = true ';	
            }
            if(myFilter.ADMN_Foreign_Entity_Donation_Sum == true){
            	conditionClause += ' AND  field = true ';	
            }

            //Turnover
            if(myFilter.Turnover != null && !myFilter.Turnover.isEmpty()){
            	if(myFilter.Turnover[0] != null && myFilter.Turnover[0] > 0){
            		if(forAggregateFunction){
	                	//conditionClause += ' AND  min(field) >= ' + myFilter.Turnover[0];
	                }
	                else{
	                	conditionClause += ' AND  field >= ' + myFilter.Turnover[0];	
	                }
            	}
            	if(myFilter.Turnover.size() > 1 && myFilter.Turnover[1] != null && myFilter.Turnover[1] > 0){
            		if(forAggregateFunction){
	                	//conditionClause += ' AND max(field) <= ' + myFilter.Turnover[1];
	                }
	                else{
	                	conditionClause += ' AND  field <= ' + myFilter.Turnover[1];
	                }
            	}
            } 
            //Employees
            if(myFilter.Employees != null && !myFilter.Employees.isEmpty()){
            	if(myFilter.Employees[0] != null && myFilter.Employees[0] > 0){
            		if(forAggregateFunction){
	                	//conditionClause += ' AND  min(field) >= ' + myFilter.Employees[0];
	                }
	                else{
	                	conditionClause += ' AND  field >= ' + myFilter.Employees[0];	
	                }
            	}
            	if(myFilter.Employees.size() > 1 && myFilter.Employees[1] != null && myFilter.Employees[1] > 0){
            		if(forAggregateFunction){
	                	//conditionClause += ' AND MAX( field) <= ' + myFilter.Employees[1];
	                }
	                else{
	                	conditionClause += ' AND  field <= ' + myFilter.Employees[1];
	                }
            	}
            }

            if(myFilter.Sug_Hitagdut != null && !myFilter.Sug_Hitagdut.isEmpty()){
                conditionClause += ' AND  field IN ' + getListOfStringFormatedSoql(myFilter.Sug_Hitagdut) ; 
            }
            if(myFilter.CLSS_Main_Classification_Num != null && !myFilter.CLSS_Main_Classification_Num.isEmpty()){
            	conditionClause += ' AND ( ';
            	for(String classNum : myFilter.CLSS_Main_Classification_Num){
            		conditionClause += '( field LIKE \'%"' + classNum + '"%\' ) OR ';
            	}
            	conditionClause += ' (field = \'\' AND field != \'\')  ) '; //FALSE
            }
            if(myFilter.CLSS_Secondary_Classification_Num != null && !myFilter.CLSS_Secondary_Classification_Num.isEmpty()){
                //conditionClause += ' AND  field IN ' + getListOfStringFormatedSoql(myFilter.CLSS_Secondary_Classification_Num) ;
                
                conditionClause += ' AND ( ';
            	for(String classNum : myFilter.CLSS_Secondary_Classification_Num){
            		conditionClause += '( field LIKE \'%"' + classNum + '"%\' ) OR ';
            	}
            	conditionClause += ' ( field IN ' + getListOfStringFormatedSoql(myFilter.CLSS_Secondary_Classification_Num) + ' ) ) ' ;
            }
			
            if(!String.isEmpty(myFilter.MalkarLocation)){
            	conditionClause += ' AND  (field =  \'' + hekdesh + '\'   OR ';
            	if(myFilter.MalkarLocation.startsWithIgnoreCase(Utils_RemoteAction.DISTRICT_LABEL_CODE)){
            		String districNum = myFilter.MalkarLocation.substring(Utils_RemoteAction.DISTRICT_LABEL_CODE.length());
            		conditionClause += '  ( field like \'%"' + districNum + '"%\') ) ';
            	}
            	else if(myFilter.MalkarLocation.equalsIgnoreCase(Utils_RemoteAction.National_Similar_Type)){
            		conditionClause += '  field = true ) ';
            	}
                else{
                	conditionClause += '  ( field like \'%"' + myFilter.MalkarLocation + '"%\') ) ';
                }
            }
        }
        
        return conditionClause;
    }
    
    public static String getMalkarFields() {
         return 'Id, Name, ' + getMalkarFieldsWithoutIdName();
    }
    
    public static String getMalkarFieldsWithoutIdName() {
         return ' field, field, field, field, field, field,   '+
         		' field, field.field, field, field,' +
         		' field, field, field, field,  ' +
                ' field, field, field, field, lastModifiedDate, field ';
    }

    public static String getMalkarReportFields(){
        return 'Id, Name, ' + getMalkarReportFieldsWithoutIdName();
    }
    public static String getMalkarReportFieldsWithoutIdName(){
        return ' field, field, field, field, field, field, field, '+
                ' field, field.field, ' +
                ' field, field, field.field, '+
                ' field, field, field, field, ' +
                ' field, field, field, field, '+
                ' field.field, field, field.field, '+
                ' field, field.field, field.field, field, '+
                ' field, field, field, field.field';
    }
    
    public static String getFullMalkarFields() {
         return 'Id, Name, field, field, field, field, field, lastModifiedDate, field, '+
         		' field, field, field, field, field,' +
                'field, field, field, field, field, field, field, '+
                'field, field, field, field, field, field, '+
                'field, field, field, field.field, ' +
                'field, field, field, field, field, field.field, field.field, '+
                'field, field.field, field, field, field, '+
                'field, field, field, field, '+
                'field, field, field, field, field, field, ' + 
                's, s, field, field, field, ' +
                ' field.field, field.field, field.field, '+
                ' field.field, field.field, field.field, field.field, field.field, '+
                ' field.field, field.field, field.field, field.field, field.field, field.field, '+
                ' field, field, field, field, ' +
                ' (select Id, Name, field, field, obj, field.field, field.s, field.s from field Where field != null limit 200) ';
    }
    
    public static String getTestSupportFields(){
    	return 	' Id, field, field, field, field, field, field, field, field, field, ' + 
    			' field, field, field, field, field ';
    }
    
    public static String getListOfStringFormatedSoql(List<String> strLst){
    	return '(\'' + string.join(strLst ,'\',\'') + '\')';
    } 

    public static obj getMalkarById(String malkarId){ 
        List<obj> malkars = getMalkarsByIds(new Set<Id>{malkarId});
        return malkars != null && !malkars.isEmpty() ? malkars[0] : null; 
    }

    public static List<obj> getMalkarsByIds(Set<Id> idSet){ 
        return getMalkarsByIds(new Set<String>(getFullMalkarFields().split(',')), idSet); 
    }
    
    public static List<obj> getMalkarsByIds(Set<String> fieldNames, Set<Id> idSet){ 
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ', ');
        queryStr += ' FROM obj ';
        queryStr += ' WHERE Id IN :idSet';
        return Database.query(queryStr);    
    }
    
    public static obj getMalkarByNum(String malkarNum){ 
        List<obj> malkars = getMalkarsByNums(new Set<String>{malkarNum});
        return malkars != null && !malkars.isEmpty() ? malkars[0] : null; 
    }
    
    public static List<obj> getMalkarsByNums(Set<String> numSet){ 
        string queryStr = 'SELECT ';
        queryStr += getFullMalkarFields();
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field IN :numSet';
        return Database.query(queryStr);
    }
    
    public static String getLastAdditionalDataByMalkarNum(String malkarNum){ 
        string queryStr = 'SELECT Id, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field = :malkarNum';
        List<obj> malkars =  Database.query(queryStr);
        if(!malkars.isEmpty()){
        	return malkars[0].field;
        }
        return null;
    }
    
    public static List<RecordType> getRecordTypeInfo(string type){
        string queryStr = 'SELECT Id, Name, DeveloperName, SObjectType ';
        queryStr += ' FROM RecordType ';
        queryStr += ' WHERE SObjectType = :type';
        return Database.query(queryStr);
    }

    public static List<obj> getReportsApprovalsByMojIdRepo(Set<string> fieldNames, List<string> mojIdList){
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ' , ');
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field IN :mojIdList  AND field = true AND field = false AND field = false ';
        return Database.query(queryStr);
    }
    
    public static List<obj> getReportsApprovalsByMalkarNum(String malkarNum, String moreConditionClause){
        return getReportsApprovalsByMalkarNum(malkarNum, moreConditionClause, 200);
    }
    
    public static List<obj> getReportsApprovalsByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, field, RecordType.Name, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE objr.field = :malkarNum AND field = false AND field = false ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field desc, RecordType.Name desc, field desc limit :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<field> getGreenDocumentsByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, field, field, field ';
        queryStr += ' FROM field ';
        queryStr += ' WHERE field.objr.field = :malkarNum AND field != null ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by field asc limit :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getActiveReportsApprovalsByMalkarNums(Set<Id> malkarNums, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, RecordType.DeveloperName, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field IN : malkarNums AND field = true AND field = false AND field = false ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field, RecordType.DeveloperName, field desc limit :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<AggregateResult> getWageEarnersByYearByMalkarNum(String malkarNum, String moreConditionClause){
        string queryStr = 'SELECT count(Id) Sum , CALENDAR_YEAR(field) Label ';
        queryStr += ' FROM field ';
        queryStr += ' GROUP BY CALENDAR_YEAR(field), objr.field ';
        queryStr += ' HAVING objr.field = :malkarNum ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  CALENDAR_YEAR(field) desc ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getSupportsByMalkarNum(String malkarNum, String moreConditionClause){
        return getSupportsByMalkarNum(malkarNum, moreConditionClause, 500);
    }
    
    public static List<obj> getSupportsByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, field, field, field, field, field, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field.field = :malkarNum AND  field!=null AND field > 2012 ';
        queryStr += ' AND (field > 0) '; // OR (field = \''+ GSTAR_Utils.TmihotNationalInsuranceType +'\' AND field = true )) ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        //queryStr += ' Order by  field desc, field desc limit : numOfResult ';
        queryStr += ' Order by  field desc, field desc limit : numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getGovConnectionsByMalkarNum(String malkarNum, String moreConditionClause){
        return getGovConnectionsByMalkarNum(malkarNum, moreConditionClause, 500);
    }
    
    public static List<obj> getGovConnectionsByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' Id, field, field, field, field, field, field  ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE objr.field =: malkarNum ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' ORDER BY field desc, field desc, field asc, field desc limit :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getDonationsByMalkarNum(String malkarNum, String moreConditionClause){
        return getDonationsByMalkarNum(malkarNum, moreConditionClause, 500);
    }
    
    public static List<obj> getDonationsByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, field, field, field, field, field, field, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE objr.field = :malkarNum AND field > 0 AND  field != null ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field desc, field desc, field desc limit  :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getPeoplesByMalkarNum(String malkarNum, String moreConditionClause){
        string queryStr = 'SELECT ';
        queryStr += ' Id, field, field, field, field, field, field.Name ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE objr.field = :malkarNum AND field.Name != null ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field, field.Name limit 500';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getConnectedByContactsMalkarNum(String malkarNum, String lastAddData){
        map<Id, Contact> contacts = new map<Id, Contact>([select id , name from Contact where id in (select field from obj where obj =:lastAddData AND objr.field =: malkarNum)]);
        Set<Id> contactsKeyset = contacts.keySet();
        string queryStr = 'SELECT ';
        queryStr += ' name, field ';
        queryStr += ' FROM obj ';
        queryStr += ' where Id in (SELECT obj FROM obj WHERE field IN :contactsKeyset AND field = true) AND field != :malkarNum ';
        queryStr += ' Order by  Name limit 500';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getConnectedFromMalkarNum(String malkarNum, String lastAddData){
        string queryStr = 'SELECT ';
        queryStr += ' name, field ';
        queryStr += ' FROM obj ';
        queryStr += ' where Id in (select field from obj where obj =:lastAddData AND field.field =: malkarNum )  AND field != :malkarNum ';
        queryStr += ' Order by  Name limit 500';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getConnectedToMalkarNum(String malkarNum, String lastAddData){
        string queryStr = 'SELECT ';
        queryStr += ' name, field ';
        queryStr += ' FROM obj ';
        queryStr += ' where Id in (select field from obj where obj =:lastAddData AND field.field =: malkarNum )  AND field != :malkarNum ';
        queryStr += ' Order by  Name limit 500';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<field> getWageEarnersByMalkarNum(String malkarNum, String moreConditionClause){
        return getWageEarnersByMalkarNum(malkarNum, moreConditionClause, 500);
    }
    
    public static List<field> getWageEarnersByMalkarNum(String malkarNum, String moreConditionClause, Integer numOfResult){
        string queryStr = 'SELECT ';
        queryStr += ' field, field, field, field, field, field ';
        queryStr += ' FROM field ';
        queryStr += ' WHERE objr.field = :malkarNum AND field != null ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field desc, field desc limit  :numOfResult ';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<obj> getReportTotals(String moreConditionClause){
        string queryStr = 'SELECT ';
        queryStr += ' Name, field, field, field, field, field, field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE Id != null ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Order by  field, field asc';
        Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<AggregateResult> getReportResult(String queryStr){
    	Utils.log(queryStr);
        return Database.query(queryStr);
    }
    
    public static List<field> getCitiesByIds(Set<String> fieldNames, Set<Id> idSet){ 
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ', ');
        queryStr += ' FROM field ';
        queryStr += ' WHERE Id IN :idSet';
        Utils.log(queryStr);
        return Database.query(queryStr);    
    }

    public static List<objr> getMalkarCitiesByParentIds(Set<String> fieldNames, Set<Id> idSet){ 
        return getMalkarCitiesByParentIds(fieldNames, idSet, null);
    }
    
    public static List<objr> getMalkarCitiesByParentIds(Set<String> fieldNames, Set<Id> idSet, String moreConditionClause){ 
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ', ');
        queryStr += ' FROM objr ';
        queryStr += ' WHERE obj IN :idSet';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        Utils.log(queryStr);
        return Database.query(queryStr);    
    }
    
    public static List<field> getAllTestSupports(){ 
        string queryStr = 'SELECT ';
        queryStr += getTestSupportFields();
        queryStr += ' FROM field ';
        queryStr += ' Limit 2000 ';
        return Database.query(queryStr);    
    }
    
    public static List<field> getTestSupportById(String testSupportId){ 
        string queryStr = 'SELECT ';
        queryStr += getTestSupportFields();
        queryStr += ' FROM field ';
        queryStr += ' Where Id = : testSupportId ';
        return Database.query(queryStr);    
    }
    
    public static List<field> getTestSupportsByGovName(String testSupportGovName){ 
        return getTestSupportsByGovName(testSupportGovName, null);    
    }
    
    public static List<field> getTestSupportsByGovName(String testSupportGovName, String moreConditionClause){ 
        string queryStr = 'SELECT Id, field ';
        queryStr += ' FROM field ';
        queryStr += ' Where field like :testSupportGovName ';
        queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
        queryStr += ' Limit 4 ';
        Utils.log(queryStr);
        return Database.query(queryStr);    
    }
    
    public static List<field> getTestSupportsAllGovNames(){ 
        string queryStr = 'SELECT field ';
        queryStr += ' FROM field ';
        queryStr += ' group by field ';
        queryStr += ' order by field ';
        return Database.query(queryStr);    
    }
    
    public static List<field> getTestSupportsAllPublichedYear(){ 
        string queryStr = 'SELECT max(field) yearCreated ';
        queryStr += ' FROM field ';
        queryStr += ' group by CALENDAR_YEAR(field) ';
        queryStr += ' order by CALENDAR_YEAR(field) desc ';
        return Database.query(queryStr);    
    }
    
    public static List<obj> getMaxTurnover(){ 
        string queryStr = 'SELECT field.field ';
        queryStr += ' FROM obj ';
        queryStr += ' WHERE field.field != null  ';
        queryStr += ' AND field = true ';
        queryStr += ' ORDER BY field.field desc ';
        queryStr += ' limit 1 ';
        return Database.query(queryStr);    
    }
    
    public static List<> getSliderScope(String sliderType){ 
        string queryStr = 'SELECT Id, MasterLabel, field, field, field ';
        queryStr += ' FROM  ';
        queryStr += ' WHERE field like :sliderType ';
        queryStr += ' ORDER BY field asc ';
        return Database.query(queryStr);    
    }

    public static List<field> getMainClassifications(){
        string queryStr = 'SELECT Id, Name, field, field ';
        queryStr += ' FROM field ';
        queryStr += ' ORDER BY field ASC Limit 2000';
        return Database.query(queryStr);
    }

    public static List<field> getSecondaryClassifications(){
        string queryStr = 'SELECT Id, Name, field, field, field ';
        queryStr += ' FROM field ';
        queryStr += ' ORDER BY field ASC';
        return Database.query(queryStr);
    }
    
    public static Map<Id, obj> getMalkarParentMap(Set<Id> malkarIdsSet, Set<String> fieldNamesAdd){
		Set<String> fieldNames = new Set<String>{'Id','field'};
		if(fieldNamesAdd != null && !fieldNamesAdd.isEmpty()){
			fieldNames.AddAll(fieldNamesAdd);			
		}
		return new Map<Id, obj>(getMalkarsByIds(fieldNames, malkarIdsSet));
	}
	
    public static Map<Id, obj> getMalkarParentMap(Set<Id> malkarIdsSet){
		return getMalkarParentMap(malkarIdsSet, null);
	}
	
	public static List<> getHekdeshClassifications(){
        string queryStr = 'SELECT Id, MasterLabel, field, field, field, field, ';
        queryStr += ' field, field,  ';
        queryStr += ' field, field, field  ';
        queryStr += ' FROM  ';
        //queryStr += ' ORDER BY field ASC';
        return Database.query(queryStr);
    }

    public static List<> getReportColumns(string objType, string lang){
        string queryStr = 'SELECT Id, MasterLabel, field, field ';
        queryStr += ' FROM  ';
        queryStr += ' WHERE field = :objType AND field = :lang ';
        queryStr += ' ORDER BY field ASC';
        return Database.query(queryStr);
    }
}