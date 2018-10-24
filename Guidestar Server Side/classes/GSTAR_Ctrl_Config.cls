public class GSTAR_Ctrl_Config extends CTRL{
    public GSTAR_Ctrl_Config (){}
    public GSTAR_Ctrl_Config (CTRL ctrl){}
    public static final Decimal maxNumberSoql = 2000000000; //2,000,000,000
    
    @RemoteAction
    public static ConfigSearchFilter getSearchFilter(){
    	ConfigSearchFilter csf = new ConfigSearchFilter();
    	csf.title = Label.Filter_Result;
    	csf.reset = Label.Reset;
    	csf.checkboxes = getSearchFilterFields();
    	csf.sliders = getSearchFilterSliders();
    	csf.dropdowns = getSearchFilterDropdowns();
    	csf.searchBoxes = getSearchFilterAutoCompletes();
    	return csf;
    }
    
    @RemoteAction
    public static List<GSTAR_Utils.ConfigField> getSearchSort(){
    	List<GSTAR_Utils.ConfigField> csf = new List<GSTAR_Utils.ConfigField>();
    	//csf.add(new GSTAR_Utils.ConfigSort('', Label.Relevance, null, 'relevance'));
    	csf.add(new GSTAR_Utils.ConfigSort('Name', Label.MalkarName, null, 'Name'));
    	csf.add(new GSTAR_Utils.ConfigSort('field', Label.Turnover, null, 'turnover'));
    	csf.add(new GSTAR_Utils.ConfigSort('field', Label.FoundedYear, null, 'orgYearFounded'));
    	return csf;
    }
    
    @RemoteAction
    public static ConfigSearchFilter getTestSupportSearchFilter(){
    	ConfigSearchFilter csf = new ConfigSearchFilter();
    	csf.title = Label.Filter_Result;
    	csf.reset = Label.Reset;
    	csf.dropdowns = getTestSupportSearchFilterDropdowns();
    	return csf;
    }
    
    @RemoteAction
    public static List<GSTAR_Utils.ConfigField> getTestSupportSearchSort(){
    	List<GSTAR_Utils.ConfigField> csf = new List<GSTAR_Utils.ConfigField>();
    	csf.add(new GSTAR_Utils.ConfigSort('DateCreated', Label.Date_published, null, 'DateCreated'));
    	csf.add(new GSTAR_Utils.ConfigSort('OrganType', Label.Gov_Office, null, 'OrganType'));
    	csf.add(new GSTAR_Utils.ConfigSort('SupportName', Label.Test_title, null, 'SupportName'));
    	return csf;
    }
    
    @RemoteAction
    @readonly
    public static GSTAR_Utils.ConfigDropdown getMainClassificationsRemote(){
    	return new GSTAR_Utils.ConfigDropdown('CLSS_Main_Classification_Num', Label.MainClassification, Label.Tooltip_MainClassification, getMainClassifications());
    }
    
    public class ConfigSearchFilter{
    	public List<GSTAR_Utils.ConfigField> checkboxes;
    	public List<GSTAR_Utils.ConfigSlider> sliders;
    	public List<GSTAR_Utils.ConfigDropdown> dropdowns;
    	public List<GSTAR_Utils.ConfigAutoComplete> searchBoxes;
    	public String title;
    	public String reset;
    }
    
    public static List<GSTAR_Utils.ConfigField> getSearchFilterFields(){
    	List<GSTAR_Utils.ConfigField> configLst = new List<GSTAR_Utils.ConfigField>();
    	configLst.add(new GSTAR_Utils.ConfigField('CurrentNihulTakinActive', Label.CurrentNihulTakinActive, Label.Tooltip_CurrentNihulTakinActive));
    	configLst.add(new GSTAR_Utils.ConfigField('Reported_Last_3_Years', Label.AnnualReports, Label.Tooltip_AnnualReports));
    	configLst.add(new GSTAR_Utils.ConfigField('ADMN_GovSupportSum', Label.GovSupport, Label.Tooltip_GovSupport));
    	configLst.add(new GSTAR_Utils.ConfigField('ADMN_Gov_Connection_Sum', Label.GovConnection, Label.Tooltip_GovConnection));
    	configLst.add(new GSTAR_Utils.ConfigField('ADMN_Foreign_Entity_Donation_Sum', Label.ForeignEntityDonation, Label.Tooltip_ForeignEntityDonation));
    	return configLst;
    }
    /*
    public static List<GSTAR_Utils.ConfigSlider> getSearchFilterSliders(){
    	List<GSTAR_Utils.ConfigSlider> configLst = new List<GSTAR_Utils.ConfigSlider>();
    	List<obj> maxTurnovers = GSTAR_DAL.getMaxTurnover();
    	if(!maxTurnovers.isEmpty() && maxTurnovers[0].field != null && maxTurnovers[0].field.field > 0 ){
    		Decimal minTurnover = Math.min(maxNumberSoql, maxTurnovers[0].field.field);
    		configLst.add(new GSTAR_Utils.ConfigSlider('Turnover', Label.Turnover, Label.Tooltip_Turnover, 0, minTurnover));
    	}
    	configLst.add(new GSTAR_Utils.ConfigSlider('Employees', Label.Employees, Label.Tooltip_Employees, 0, 500));
    	return configLst;
    }
    */
    public static List<GSTAR_Utils.ConfigSlider> getSearchFilterSliders(){
    	List<GSTAR_Utils.ConfigSlider> configLst = new List<GSTAR_Utils.ConfigSlider>();
    	
    	List<> sliderScopesTurnover = GSTAR_DAL.getSliderScope('Turnover');
    	configLst.add(new GSTAR_Utils.ConfigSlider('Turnover', Label.Turnover, Label.Tooltip_Turnover, Utils.getListLabelValueSlider(sliderScopesTurnover)));
    	
    	List<> sliderScopesEmployee = GSTAR_DAL.getSliderScope('Employee');	
    	configLst.add(new GSTAR_Utils.ConfigSlider('Employees', Label.Employees, Label.Tooltip_Employees, Utils.getListLabelValueSlider(sliderScopesEmployee)));
    	return configLst;
    }
    
    public static List<GSTAR_Utils.ConfigDropdown> getSearchFilterDropdowns(){
    	List<GSTAR_Utils.ConfigDropdown> configLst = new List<GSTAR_Utils.ConfigDropdown>();
    	
    	configLst.add(new GSTAR_Utils.ConfigDropdown('Sug_Hitagdut', Label.MalkarType, Label.Tooltip_MalkarType, getSugHitagduts()));
    	configLst.add(new GSTAR_Utils.ConfigDropdown('CLSS_Main_Classification_Num', Label.MainClassification, Label.Tooltip_MainClassification, getMainClassifications()));
    	configLst.add(new GSTAR_Utils.ConfigDropdown('CLSS_Secondary_Classification_Num', Label.SecondaryClassification, Label.Tooltip_SecondaryClassification, getSecondClassifications()));
    	return configLst;
    }
    
   	public static List<GSTAR_Utils.ConfigDropdown> getTestSupportSearchFilterDropdowns(){
    	List<GSTAR_Utils.ConfigDropdown> configLst = new List<GSTAR_Utils.ConfigDropdown>();
    	configLst.add(new GSTAR_Utils.ConfigDropdown('OrganType', Label.Gov_Office, Label.Tooltip_Gov_Office, getTestSupportGovOffices()));
    	configLst.add(new GSTAR_Utils.ConfigDropdown('YearCreated', Label.Year_published, Label.Tooltip_Year_published, getTestSupportYearPublished()));
    	return configLst;
    }
    
    public static List<Utils.LabelValue> getTestSupportGovOffices(){
    	return Utils.getListLabelValue(GSTAR_DAL.getTestSupportsAllGovNames(), 'field', 'field');
    }
    
    public static List<Utils.LabelValue> getTestSupportYearPublished(){
    	return Utils.getListLabelValue(GSTAR_DAL.getTestSupportsAllPublichedYear(), 'yearCreated', 'yearCreated');
    }
    
    public static List<Utils.LabelValue> getSugHitagduts(){
    	List<Utils.LabelValue> result = Utils.getListLabelValue(obj.field.getDescribe().getPicklistValues());
    	for(Utils.LabelValue lv : result){
    		if(lv.value == GSTAR_Utils.HeletzPicklistValue){
    			lv.label = Label.HeletzPicklistLabel;
    		}
    	}
        return result;
    }
    
    public static List<Utils.LabelValue> getMainClassifications(){
        return Utils.getListLabelValue(GSTAR_DAL.getMainClassifications(), 'field', 'field');
    	//return Utils.getListLabelValue(field.getAll().values(), 'field', 'field');
    }
    
    public static List<Utils.LabelValue> getSecondClassifications(){
        return Utils.getListLabelValue(GSTAR_DAL.getSecondaryClassifications(), 'field', 'field', 'field', false);
    	//return Utils.getListLabelValue(field.getAll().values(), 'field', 'field', 'field');
    }
    
    public static List<GSTAR_Utils.ConfigAutoComplete> getSearchFilterAutoCompletes(){
    	List<GSTAR_Utils.ConfigAutoComplete> configLst = new List<GSTAR_Utils.ConfigAutoComplete>();
    	configLst.add(new GSTAR_Utils.ConfigAutoComplete('MalkarLocation', Label.LocationAddress, Label.Tooltip_LocationAddress, 'Utils_RemoteAction.searchCityAC', 'Utils_RemoteAction.searchCityCodeAC'));
    	return configLst;
    }
}