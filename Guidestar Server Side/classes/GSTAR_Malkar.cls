public virtual class GSTAR_Malkar{

    public string Id {get;set;}
    public string Name {get;set;}
    public string regNum {get;set;}
    public Boolean hasReports {get;set;}
    public string sugHitagdut {get;set;}
    public string sugHitagdutLabel {get;set;}
    public Boolean hasProperManagement {get;set;}
    public Boolean approval46 {get; set;}
    public string orgGoal {get;set;}
    public Set<String> tchumPeilutSecondary {get;set;}
    public string city {get;set;}
    public List<String> cityNums {get;set;}
    public List<String> cities {get;set;}
    public List<String> malkarDistricts {get; set;}
	public Boolean malkarLocationIsNational {get; set;}
    public Boolean showProperManagement {get;set;}
    public Boolean showApproval46 {get;set;}
    public Boolean showReports {get;set;}
    public Boolean showDonation{get;set;}
    public Integer turnover {get;set;}
    public Decimal orgYearFounded {get;set;}

    public GSTAR_Malkar(obj malkar, string lang){
        this.Id = malkar.Id;
        this.regNum = malkar.field;
        this.sugHitagdut = malkar.field;
        this.sugHitagdutLabel = malkar.field == GSTAR_Utils.HeletzPicklistValue ? Label.HeletzPicklistLabel : malkar.field;
        if(malkar.field == true && malkar.field == GSTAR_Utils.MalkarPicklistValue){
        	this.sugHitagdutLabel = Label.New_Malkar;
        }
        this.approval46 = malkar.field;
        //this.orgGoal = malkar.field != null && malkar.field.Length() > 220 ? malkar.field.substring(0, 220) + ' ...' : malkar.field;
        this.orgGoal = malkar.field;
        //this.tchumPeilutSecondary = malkar.field;
        
        if(String.isNotBlank(malkar.field)){
	        if(malkar.field.startsWith('[')){
				this.tchumPeilutSecondary = (Set<String>) JSON.deserialize(malkar.field, Set<String>.class);
			}
			else{
				this.tchumPeilutSecondary = new Set<String>{ malkar.field };
			}
        }
        this.city = malkar.field;
        
        this.cityNums = String.isNotBlank(malkar.field) ? (List<String>)JSON.deserialize(malkar.field, List<String>.class) : null;
        this.cities = String.isNotBlank(malkar.field) ? (List<String>)JSON.deserialize(malkar.field, List<String>.class) : null;
        this.malkarDistricts = String.isNotBlank(malkar.field) ? (List<String>)JSON.deserialize(malkar.field, List<String>.class) : null;
		this.malkarLocationIsNational = malkar.field;
        this.hasReports = malkar.field ? true : false;
        this.showDonation = malkar.field;
        
		if(malkar.field != null){
			obj minTurnover = obj.getInstance('GSTAR_MinTurnover');
			if(minTurnover != null && String.isNotBlank(minTurnover.field)){
				Integer minTurnoverInt = Integer.valueOf(minTurnover.field);
				this.turnover = malkar.field.field >= minTurnoverInt ? Integer.valueOf(malkar.field.field) : null;
			}
			else{
				this.turnover = Integer.valueOf(malkar.field.field);
			}
		}
        this.hasProperManagement = malkar.field; 
        this.orgYearFounded = malkar.field;
        setName(malkar, lang);
        setFieldVisibility(malkar);
    }

    public static List<GSTAR_Malkar> createMalkarList(List<obj> malkarList, string lang){
        List<GSTAR_Malkar> returnList = new List<GSTAR_Malkar>();
        for (obj malkar : malkarList){
            returnList.add(new GSTAR_Malkar(malkar, lang));
        }
        return returnList;
    }
    
    public static Set<GSTAR_Malkar> createMalkarList(Set<obj> malkarList, string lang){
        Set<GSTAR_Malkar> returnList = new Set<GSTAR_Malkar>();
        for (obj malkar : malkarList){
            returnList.add(new GSTAR_Malkar(malkar, lang));
        }
        return returnList;
    }

    public void setName(obj malkar, string lang){
        if (lang == 'iw' && String.isNotBlank(malkar.field)){
            this.Name = malkar.field;
        }
        else if (lang == 'en_US' && String.isNotBlank(malkar.field) && malkar.field != '-'){
            this.Name = malkar.field;
        }
        else if (lang == 'ar' && String.isNotBlank(malkar.field) && malkar.field != '-'){
            this.Name = malkar.field;
        }
        else if (String.isNotBlank(malkar.field)){
            this.Name = malkar.field;
        }
        else{
            this.Name = malkar.Name;
        }
    }

    public void setFieldVisibility(obj malkar){
        if (malkar.field == 'הקדש' || malkar.field == true){
            this.showApproval46 = this.approval46;
            this.showProperManagement = this.hasProperManagement;
            this.showReports = false;//this.hasReports;
        }
        else{
            this.showApproval46 = true;
            this.showProperManagement = true;
            this.showReports = true;
        }
    }
}