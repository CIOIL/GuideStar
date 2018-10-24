Public Class Util_MyLabel {

    public string advanced_search { get; set; }
    public string Analytic_Info { get; set; }
    public string I_Am_Searching { get; set; }
    public string choose_area { get; set; }
    public string defaultVal { get; set; }
    
    public string Organization_Name { get; set; }
    public string Activity_Type { get; set; }
    public string Activity_Essence { get; set; }
    public string Gender { get; set; }
    public string Disability_Type { get; set; }
    public string Operation_Area { get; set; }
    
    public string Organization_Type_Examples { get; set; }
    public string Activity_Type_Examples { get; set; }
    public string Activity_Essence_Examples { get; set; }
    public string Gender_Examples { get; set; }
    public string Disability_Type_Examples { get; set; }
    public string Activity_Area_Examples { get; set; }
    
    
    Public String Annual_reports {get; set;}
    Public String Head_Office {get; set;}
    Public String Last_updated {get; set;}
    Public String Proper_Management {get; set;}
    Public String Organization_Profile {get; set;}
    
    Public String OrganizationTypelabel {get; set;}
    Public String ActivityTypelabel {get; set;}
    Public String ActivityEssencelabel {get; set;}
    Public String Genderlabel {get; set;}
    public String DisabilityTypelabel {get; set;}
    Public String OperationArealabel {get; set;}
    Public String Showingresults {get; set;}
    Public String Outof{get; set;}
    
    public string Search { get; set; }
    public string Clear { get; set; }
    public string Copyright { get; set; }
    Public String previous {get; set;}
    Public String next {get; set;}
    Public String no_Records {get; set;}
    public string forSearchTerms {get; set;}
    
    private Map<String, String> heb = new Map<String, String> {
        'advanced_search'            => 'חיפוש מתקדם',
        'Analytic_Info'              => 'מידע אנליטי',  
        'I_Am_Searching'             => 'אני מחפש/ת',
        'choose_area'                => 'בחרו ערך',
        'Organization_Name'          => 'סוג הארגון',
        'Activity_Type'              => 'סוג הפעילות',
        'Activity_Essence'           => 'מהות פעילות',
        'Gender'                     => 'מגדר',
        'Disability_Type'            => 'מוגבלות',
        'Operation_Area'             => 'מחוז (כתובת הרשומה)',
        'Organization_Type_Examples' => '(עמותה, חל״צ, הקדש)',
        'Activity_Type_Examples'     => '(רווחה, דת, חינוך ומחקר, בריאות וכו׳)',
        'Activity_Essence_Examples'  => '(בית כנסת, מרכז יום וכו׳)',
        'Gender_Examples'            => '(זכר, נקבה)',
        'Disability_Type_Examples'   => '(סרטן, בריאות הנפש וכו׳)',
        'Activity_Area_Examples'     => '(ירושלים, חיפה וכו׳)',
        'Search'                     => 'חפש',
        'Clear'                      => 'נקה',
        'Copyright'                  => 'זכויות יוצרים',
        'Annual_reports'             => 'דוחות שנתיים',
        'Head_Office'                => 'משרד ראשי',
        'Last_updated'               => 'עודכנו לאחרונה',
        'Proper_Management'          => 'ניהול תקין',
        'Organization_Profile'       => 'לפרופיל ארגון',
        'OrganizationTypelabel'      => 'סוג הארגון',
        'ActivityTypelabel'          => 'סוג הפעילות',
        'ActivityEssencelabel'       => 'מהות הפעילות',
        'Genderlabel'                => 'מגדר',
        'DisabilityTypelabel'        => 'מוגבלות',
        'OperationArealabel'         => 'מחוז',
        'previous'                   => 'קודם',
        'next'                       => 'הבא',
        'Showingresults'             => 'מציג תוצאות',
        'Outof'                      => 'מתוך',
        'no_Records'                 => 'לא נמצא רשומות',
        'forSearchTerms'             => 'עבור',
        'defaultVal'                    => 'אין קריטריוני חיפוש מוצגות 500 רשומות ברירת מחדל'
    };
    
    private Map<String, String> eng = new Map<String, String> {
        'advanced_search'            => 'Advanced Search',
        'Analytic_Info'              => 'Analytic Info', 
        'I_Am_Searching'             => 'I Am Searching For',
        'choose_area'                => 'Choose Value',
        'Organization_Name'          => 'Organization Name',
        'Activity_Type'              => 'Activity Type',
        'Activity_Essence'           => 'Activity Essence',
        'Gender'                     => 'Gender',
        'Disability_Type'            => 'Disability Type',
        'Operation_Area'             => 'Operation Area',
        'Organization_Type_Examples' => 'Organization Type Examples',
        'Activity_Area_Examples'     => 'Activity Area Examples',
        'Activity_Type_Examples'     => 'Activity Type Examples',
        'Activity_Essence_Examples'  => 'Activity Essence Examples',
        'Gender_Examples'            => 'Gender Examples',
        'Disability_Type_Examples'   => 'Disability Type Examples',
        'Search'                     => 'Search',
        'Clear'                      => 'Clear',
        'Copyright'                  => 'Copyright',
        'Annual_reports'             => 'Annual reports',
        'Head_Office'                => 'Head Office',
        'Last_updated'               => 'Last updated',
        'Proper_Management'          => 'Proper Management ',
        'Organization_Profile'       => 'To Organization Profile',
        'OrganizationTypelabel'      => 'Organization Type label',
        'ActivityTypelabel'          => 'Activity Type label',
        'ActivityEssencelabel'       => 'Activity Essence label',
        'Genderlabel'                => 'Gender label',
        'DisabilityTypelabel'        => 'Disability Type label',
        'OperationArealabel'         => 'Operation Area label',
        'previous'                   => 'Previous',
        'next'                       => 'Next',
        'Showingresults'             => 'Showing results',
        'Outof'                      => 'out of',
        'no_Records'                 => 'No Records Found',
        'forSearchTerms'             => 'for',
        'defaultVal'                    => 'No search criteria displaying 500 default records'
    };
    
    
    public void populate (String lang) {
    
        Map<String, String> myMap = lang == null || lang == 'heb' ? this.heb : this.eng ;
        this.advanced_search = myMap.get('advanced_search');
        this.Analytic_Info = myMap.get('Analytic_Info');
        this.I_Am_Searching = myMap.get('I_Am_Searching');
        this.choose_area = myMap.get('choose_area');
        this.Organization_Name = myMap.get('Organization_Name');
        this.Activity_Type = myMap.get('Activity_Type');
        this.Activity_Essence = myMap.get('Activity_Essence');
        this.Gender = myMap.get('Gender');
        this.Disability_Type = myMap.get('Disability_Type');
        this.Operation_Area = myMap.get('Operation_Area');
        this.Annual_reports = myMap.get('Annual_reports');
        this.Head_Office = myMap.get('Head_Office');
        this.Last_updated  = myMap.get('Last_updated');
        this.Proper_Management = myMap.get('Proper_Management');
        this.Organization_Profile = myMap.get('Organization_Profile');
        this.defaultVal = myMap.get('defaultVal');
        this.OrganizationTypelabel = myMap.get('OrganizationTypelabel');
        this.ActivityTypelabel = myMap.get('ActivityTypelabel');
        this.ActivityEssencelabel = myMap.get('ActivityEssencelabel');
        this.Genderlabel = myMap.get('Genderlabel');
        this.DisabilityTypelabel = myMap.get('DisabilityTypelabel');
        this.OperationArealabel = myMap.get('OperationArealabel');
        this.no_Records = myMap.get('no_Records');
        
        this.Showingresults = myMap.get('Showingresults');
        this.Outof = myMap.get('Outof');
        
        this.previous = myMap.get('previous');
        this.next = myMap.get('next');
        
        this.Organization_Type_Examples = myMap.get('Organization_Type_Examples');
        this.Activity_Type_Examples = myMap.get('Activity_Type_Examples');
        this.Activity_Essence_Examples = myMap.get('Activity_Essence_Examples');
        this.Gender_Examples = myMap.get('Gender_Examples');
        this.Disability_Type_Examples = myMap.get('Disability_Type_Examples');
        this.Activity_Area_Examples = myMap.get('Activity_Area_Examples');
        
        this.Copyright = myMap.get('Copyright');
        this.forSearchTerms = myMap.get('forSearchTerms');
    }
    
    
}