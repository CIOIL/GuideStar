public class OLD_GSTAR {
	
	public class FilterGuidestar{
        public String Search;
        public String isSearchByNameFinished;
        public String ShowMalkarNihulTakinOnly;
        public String ShowMalkar46Only;
        public String ShowMalkarSubmittedReportOnly;
        public String SugHitagdut;
        public String TchumPeilutMain;
        public String TchumPeilutSec;
        public String PeilutArea;
        public String pageNumber; 
        
        public FilterGuidestar(){
        	this.pageNumber = '0';
        }
    }
    
    public class MalkarResult extends ApiResult{
        
        public MalkarResult(Boolean success, String errorMsg, Object data) {
            super(success, errorMsg, data);
        }
        public MalkarResult(Boolean success, String errorMsg, Boolean isLast, Object data) {
            super(success, errorMsg, isLast, data);
        }
        //public MalkarResult(Boolean success, String errorMsg, Boolean isLast, Object data, Datetime lastModifiedDate, Id lastId) {
        //    super(success, errorMsg, isLast, data, lastModifiedDate, lastId);
        //}
        public MalkarResult(Boolean success, String errorMsg, Boolean isLast, Object data, Datetime lastModifiedDate, Id lastId, FilterGuidestar myFilter) {
            super(success, errorMsg, isLast, data, lastModifiedDate, lastId);
            this.filter = myFilter;
        }
        
        public FilterGuidestar filter;
    }
    
    public static final Integer CHUNK_SIZE = 50;
    public class MyException extends Exception{}
    
    public static List<c> getAllMalkars() {
        String queryStr = 'select ' + getMalkarFields() + ' from c ';
        queryStr += ' LIMIT 1000 ';
        return (List<c>)Database.query(queryStr);
    }

    public static List<c> getMalkarsByChunk(Datetime lastModifiedDate, Id lastId){
        return getMalkarsByChunk(lastModifiedDate, lastId, null);
    }
    
    public static List<c> getMalkarsByChunk(Datetime lastModifiedDate, Id lastId, OLD_GSTAR.FilterGuidestar myFilter){
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	return searchMalkarsByChunk(myFilter);
        }
        return selectMalkarsByChunk(lastModifiedDate, lastId, myFilter);
    }
    
    public static List<c> searchMalkarsByName(OLD_GSTAR.FilterGuidestar myFilter){
        String malkarFields = getMalkarFields();
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	//Integer offset = String.isNotBlank(myFilter.pageNumber) ? Integer.valueOf(myFilter.pageNumber) * CHUNK_SIZE : 0;
        	String queryStr = 'FIND \'' + myFilter.Search + '*\'IN Name FIELDS RETURNING c(' + malkarFields;
	        queryStr += ' Where Id != null ';
	        queryStr += getConditionClause(myFilter, true);
	        queryStr += ' LIMIT 20 ';
	        //queryStr += ' OFFSET :offset ) ';
	        queryStr += ' ) ';
	        
	        Utils.log('queryStr');
    		Utils.log(queryStr);
	        return (List<c>)search.query(queryStr)[0];
        }
        throw new MyException('searchMalkarsByChunk error');
    }
    
    public static List<c> searchMalkarsByChunk(OLD_GSTAR.FilterGuidestar myFilter){
        String malkarFields = getMalkarFields();
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	Integer offset = String.isNotBlank(myFilter.pageNumber) ? Integer.valueOf(myFilter.pageNumber) * CHUNK_SIZE : 0;
        	String queryStr = 'FIND \'' + myFilter.Search + '*\'IN ALL FIELDS RETURNING c(' + malkarFields;
	        queryStr += ' Where Id != null ';
	        queryStr += getConditionClause(myFilter, true);
	        queryStr += ' LIMIT :CHUNK_SIZE ';
	        queryStr += ' OFFSET :offset ) ';
	        
	        Utils.log('queryStr');
    		Utils.log(queryStr);
	        return (List<c>)search.query(queryStr)[0];
        }
        throw new MyException('searchMalkarsByChunk error');
    }
    
    public static List<c> selectMalkarsByChunk(Datetime lastModifiedDate, Id lastId, OLD_GSTAR.FilterGuidestar myFilter){
        String malkarFields = getMalkarFields();
        String queryStr = 'select ' + malkarFields + ' from c ';
        queryStr += ' Where (lastModifiedDate < :lastModifiedDate or (lastModifiedDate = :lastModifiedDate and Id > :lastId )) ';
        if(myFilter != null && !String.isEmpty(myFilter.Search)){
        	queryStr += ' AND Name Like \'%' + myFilter.Search + '%\' '; 
        }
        queryStr += getConditionClause(myFilter, true);
        queryStr += ' order by lastModifiedDate desc, Id ';
        queryStr += ' LIMIT :CHUNK_SIZE';
        Utils.log('queryStr');
		Utils.log(queryStr);
        return (List<c>)Database.query(queryStr);
    }
    
    public static Integer getMalkarCount(OLD_GSTAR.FilterGuidestar myFilter){
        String malkarFields = getMalkarFields();
        String queryStr = 'select count(id) countmalkar  from c ';
        queryStr += ' group by c, c, c, c, c, c,  c, c, c, r.c , c ';
        queryStr += ' HAVING c = true ';
        queryStr += getConditionClause(myFilter, true, true);
        List<AggregateResult> ars = (List<AggregateResult>)Database.query(queryStr);
        Integer countmalkar = 0;
        if(!ars.isEmpty()){
        	for(AggregateResult ar: ars){
	        	countmalkar += Integer.valueOf(ar.get('countmalkar'));
        	}
        }
        return countmalkar;
    }
    
    public static String getConditionClause(OLD_GSTAR.FilterGuidestar myFilter, Boolean isStatusActive){
    	return getConditionClause(myFilter, true, false);
    }
    
    public static String getConditionClause(OLD_GSTAR.FilterGuidestar myFilter, Boolean isStatusActive, Boolean forAggregateFunction){
    	String conditionClause = '';
    	conditionClause += isStatusActive ? ' AND c = true ' : '';
        if(myFilter != null){
            Datetime now = Datetime.now();
            String year = String.valueof(now.year());
            
            if(!String.isEmpty(myFilter.ShowMalkarNihulTakinOnly) && myFilter.ShowMalkarNihulTakinOnly.toLowerCase() == 'on'){
                if(forAggregateFunction){
                	conditionClause += ' AND  (c = \'הקדש\'  OR ( max(c) = \'' + year + '\' AND r.c = true ) )';
                }
                else{
                	conditionClause += ' AND  (c = \'הקדש\'  OR (c = \'' + year + '\' AND r.c = true ) )';
                }
            }
            if(!String.isEmpty(myFilter.ShowMalkar46Only) && myFilter.ShowMalkar46Only.toLowerCase() == 'on'){
                conditionClause += ' AND  (c = \'הקדש\'  OR c = true )';
            }
            if(!String.isEmpty(myFilter.ShowMalkarSubmittedReportOnly) && myFilter.ShowMalkarSubmittedReportOnly.toLowerCase() == 'on'){
                conditionClause += ' AND  (c = \'הקדש\'  OR c = true )';
            }
            if(!String.isEmpty(myFilter.SugHitagdut) && myFilter.SugHitagdut != '0'){
                conditionClause += ' AND  c = \'' +  myFilter.SugHitagdut + '\''; 
            }
            if(!String.isEmpty(myFilter.TchumPeilutMain) && myFilter.TchumPeilutMain != '0'){
            	conditionClause += ' AND ( c LIKE \'%"' + myFilter.TchumPeilutMain + '"%\' )  ';
            }
            if(!String.isEmpty(myFilter.TchumPeilutSec) && myFilter.TchumPeilutSec != '0'){
                conditionClause += ' AND  c = \'' +  myFilter.TchumPeilutSec + '\''; 
            }
            if(!String.isEmpty(myFilter.PeilutArea) && myFilter.PeilutArea!= '0'){
                conditionClause += ' AND  ( c = \'' +  myFilter.PeilutArea + '\' OR  c like \'%'+ myFilter.PeilutArea +'%\')'; 
            }
        }
        
        return conditionClause;
    }
    
    public static String getMalkarFields() {
         return 'Id, Name, c, c, c, c, lastModifiedDate, c, '+
         		' c,  c, ' +
                'c, c, c, c, c, c, '+
                'c, c, c, c, c, c, '+
                'c, c, c, r.c, ' +
                'c, c ';
    }

    public static c getMalkarById(String malkarId){ 
        List<c> malkars = getMalkarsByIds(new Set<Id>{malkarId});
        return malkars != null && !malkars.isEmpty() ? malkars[0] : null; 
    }

    public static List<c> getMalkarsByIds(Set<Id> idSet){ 
        return getMalkarsByIds(new Set<String>(getMalkarFields().split(',')), idSet); 
    }
    
    public static List<c> getMalkarsByIds(Set<String> fieldNames, Set<Id> idSet){ 
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ', ');
        queryStr += ' FROM c ';
        queryStr += ' WHERE Id IN :idSet';
        return Database.query(queryStr);    
    }

    public class GSTAR_Malkar{

	    public string Id {get;set;}
	    public string Name {get;set;}
	    public string regNum {get;set;}
	    public Boolean hasReports {get;set;}
	    public string sugHitagdut {get;set;}
	    public Boolean hasProperManagement {get;set;}
	    public Boolean approval46 {get; set;}
	    public string orgGoal {get;set;}
	    public string tchumPeilutMain {get;set;}
	    public string tchumPeilutSecondary {get;set;}
	    public string machoz {get;set;}
	    public string city {get;set;}
	    public Datetime lastModifiedDate {get; set;}
	    public Boolean showProperManagement {get;set;}
	    public Boolean showApproval46 {get;set;}
	    public Boolean showReports {get;set;}
	    public string logoUrl{get;set;}
	    public Boolean showDonation{get;set;}
	
	    public GSTAR_Malkar(c malkar, string lang){
	        this.Id = malkar.Id;
	        this.regNum = malkar.c;
	        this.sugHitagdut = malkar.c;
	        this.approval46 = malkar.c;
	        this.orgGoal = malkar.c != null && malkar.c.Length() > 220 ? malkar.c.substring(0, 220) + ' ...' : malkar.c;
	        this.tchumPeilutMain = malkar.c;
	        this.tchumPeilutSecondary = malkar.c;
	        this.machoz = malkar.c;
	        this.city = malkar.c;
	        this.lastModifiedDate = malkar.lastModifiedDate;
	        this.hasReports = malkar.c ? true : false;
	        if (String.isBlank(malkar.c)){
	            this.logoUrl = null;
	        }
	        else{
	            this.logoUrl = (Site.getbaseUrl()!=''? Site.getbaseUrl() : url.getSalesforceBaseUrl().toExternalForm() +'/apex')+malkar.c;
	        }
	        this.showDonation = malkar.c > 0 ? true : false;
	        System.debug('showDonation '+showDonation);
	        setName(malkar, lang);
	        setProperManagement(malkar);
	        setFieldVisibility(malkar);
	    }
	
	    public void setName(c malkar, string lang){
	        if (lang == 'iw' && String.isNotBlank(malkar.c)){
	            this.Name = malkar.c;
	        }
	        else if (lang == 'en_US' && String.isNotBlank(malkar.c) && malkar.c != '-'){
	            this.Name = malkar.c;
	        }
	        else if (lang == 'ar' && String.isNotBlank(malkar.c) && malkar.c != '-'){
	            this.Name = malkar.c;
	        }
	        else if (String.isNotBlank(malkar.c)){
	            this.Name = malkar.c;
	        }
	        else{
	            this.Name = malkar.Name;
	        }
	    }
	
	    public void setProperManagement(c malkar){
	        if (malkar.c != null && malkar.c == String.valueOf(Date.today().Year()) && malkar.r.c == true){
	            this.hasProperManagement = true;
	        }
	        else{
	            this.hasProperManagement = false;
	        }
	    }
	
	    public void setFieldVisibility(c malkar){
	        if (malkar.c == 'הקדש'){
	            this.showApproval46 = this.approval46;
	            this.showProperManagement = this.hasProperManagement;
	            this.showReports = this.hasReports;
	        }
	        else{
	            this.showApproval46 = true;
	            this.showProperManagement = true;
	            this.showReports = true;
	        }
	    }
	}
	public static List<OLD_GSTAR.GSTAR_Malkar> createMalkarList(List<c> malkarList, string lang){
        List<OLD_GSTAR.GSTAR_Malkar> returnList = new List<OLD_GSTAR.GSTAR_Malkar>();
        for (c malkar : malkarList){
            returnList.add(new OLD_GSTAR.GSTAR_Malkar(malkar, lang));
        }
        return returnList;
    }
}