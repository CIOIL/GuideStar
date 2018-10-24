public class GSTAR_Ctrl_Meta  extends CTRL{
    
    public final String he = 'he';
    public final String guidestarUrl = (string)obj.getAll().get('GuidestarURL').get('field'); //'https://www.guidestar.org.il'; 
    
    public GSTAR_Ctrl_Meta (){ getMeta(); }
    public GSTAR_Ctrl_Meta (CTRL ctrl){ getMeta();}
    private String anchorElement;
    public String originalUrl {set;get;}
    private String title {set;get;}
    private String description {set;get;}
    public String favicon {set;get;}
    public String canonicalUrl {set;get;}
    public boolean hasProperManagement {set;get;}
    
    public void getMeta(){
        PageReference currentPage = Apexpages.CurrentPage();
        originalUrl = Site.getOriginalUrl();
        Utils.log(originalUrl);
        String base64Url = currentPage.getParameters().get('number');
        if(String.isNotBlank(base64Url)){
            originalUrl = EncodingUtil.base64Decode(base64Url).toString();
        }
        
        system.debug(originalUrl);
        if(String.isNotBlank(base64Url) && originalUrl.indexOf(';') > -1){
            originalUrl = originalUrl.substring(0, originalUrl.indexOf(';'));
        }
        canonicalUrl = guidestarUrl;
        canonicalUrl += originalUrl != null ? originalUrl : '';
        originalUrl = String.isNotBlank(originalUrl) && originalUrl.startsWith('/') ? originalUrl.substring(1) : originalUrl;
        system.debug(originalUrl);
        
        List<String> urlParts = String.isNotBlank(originalUrl) ? originalUrl.split('/') : null;
        try{
            favicon = '';
            title = Label.Site_Title;
            description = Label.Description_Home;
            if(urlParts != null && urlParts[0] == he){
                //remove the he/ prefix from the last site 
                originalUrl = originalUrl.substring(3);
                canonicalUrl = guidestarUrl + '/' + originalUrl;
                urlParts.remove(0);
            }
            if(urlParts != null && !urlParts.isEmpty()){
                Utils.log(urlParts[0]);
                if(urlParts[0] == GSTAR_Utils.MalkarPageApp){
                    if(urlParts.size() > 1 && urlParts[1].isNumeric()){
                        Utils.log(urlParts[1]);
                        List<obj> currentMalkars = [Select Id, Name, field, field, field from obj where field =: urlParts[1] limit 1];
                        Utils.log(currentMalkars);
                        if(!currentMalkars.isEmpty()){
                        	hasProperManagement = currentMalkars[0].field;
                            title = currentMalkars[0].Name + ' | ' + Label.Site_Title;
                            description = currentMalkars[0].field;
                            if(String.isNotBlank(currentMalkars[0].field)){
                                description = Label.MalkarDescriptionPrefix + ' ';
                                if(currentMalkars[0].field.length() > 300){
                                    description += currentMalkars[0].field.substring(0,300);
                                }
                                else{
                                    description += currentMalkars[0].field;
                                }
                            }
                            
                            if(urlParts.size() > 2){
                                String part = urlParts[2]; 
                                if(part == GSTAR_Utils.MalkarInfoPage){
                                    //title = currentMalkars[0].Name + ' - ' + Label.Malkar_Info;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarInfoPage) - 1 ); // -1 for the /
                                }
                                else if(part == GSTAR_Utils.MalkarDocumentsPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Documents_and_Reports;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarDocumentsPage) + GSTAR_Utils.MalkarDocumentsPage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarGovsupportPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Government_Support;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarGovsupportPage) + GSTAR_Utils.MalkarGovsupportPage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarGovservicesPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Government_services;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarGovservicesPage) + GSTAR_Utils.MalkarGovservicesPage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarDonationsPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Donations;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarDonationsPage) + GSTAR_Utils.MalkarDonationsPage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarPeoplePage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Malkar_people;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarPeoplePage) + GSTAR_Utils.MalkarPeoplePage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarVolunteeringPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Volunteering;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarVolunteeringPage) + GSTAR_Utils.MalkarVolunteeringPage.length() );
                                }
                                else if(part == GSTAR_Utils.MalkarContactPage){
                                    title = currentMalkars[0].Name + ' - ' + Label.Contact_us;
                                    canonicalUrl = guidestarUrl + '/' + originalUrl.substring(0, originalUrl.indexOf(GSTAR_Utils.MalkarContactPage) + GSTAR_Utils.MalkarContactPage.length() );
                                }
                            }
                        }
                    }
                }
                else if(urlParts[0] == GSTAR_Utils.MalkarSearchPageApp){
                    title = Label.Site_Search_Title;
                    //save the search word
                    description = Label.Description_Search;
                    //canonicalUrl = guidestarUrl + '/' + GSTAR_Utils.MalkarSearchPageApp;
                }
                else if(urlParts[0].startsWith(GSTAR_Utils.TestSupportsPageApp)){ // startsWith because sometime it is with a "test-support;search=abcd"
                    title = Label.Site_Test_Supports_Title + ' | ' + Label.Site_Title;
                    description = Label.Description_Test_Supports;
                    
                    if(urlParts.size() > 1){
                        Utils.log(urlParts[1]);
                        String testSupportId;
                        try{
                            testSupportId = EncodingUtil.base64Decode(urlParts[1]).toString();
                        }catch(Exception e){}
                        if(String.isNotBlank(testSupportId)){
                            List<field> ts = [Select Id, field, field from field where Id =: testSupportId];
                            Utils.log(ts);
                            if(!ts.isEmpty()){
                                title = ts[0].field;
                                if(String.isNotBlank(ts[0].field)){
                                    description = Label.TestSupportDescriptionPrefix + ' ' + ts[0].field;
                                    
                                    description = Label.TestSupportDescriptionPrefix + ' ';
                                    if(ts[0].field.length() > 300){
                                        description += ts[0].field.substring(0,300);
                                    }
                                    else{
                                        description += ts[0].field;
                                    }
                                }
                            }
                        }                           
                    }
                }
                else if(urlParts[0] == GSTAR_Utils.GlobalPageApp){
                    if(urlParts.size() > 1){
                        List<field> wsContents = [Select Id, field, field, field, field, field 
                                                    From field 
                                                    Where field LIKE 'Guidestar' 
                                                    And field INCLUDES (:urlParts[1])
                                                    And field LIKE 'main'
                                                    And field = true
                                                    Order By field asc limit 1];
                        if(!wsContents.isEmpty()){
                            if(String.isNotBlank(wsContents[0].field)){
                                title = wsContents[0].field;                             
                            }
                            if(String.isNotBlank(wsContents[0].field)){
                                description = wsContents[0].field;
                            }
                        }
                    }
                }
                else if(urlParts[0] == GSTAR_Utils.ContactPageApp){
                    title = Label.Site_Contact_Title;
                    description = Label.Description_Contact;
                    return;
                }
                else if(urlParts[0] == GSTAR_Utils.HomePageApp){
                    // nothing - take default values
                    canonicalUrl = guidestarUrl;
                }
            }
        }
        catch(Exception e){
            system.debug(e);
        }
        
        Utils.log(title);
        Utils.log(description);
    } 
    
    public String getTitle(){
        return title;
    }
    
    public String getDescription(){
        return description;
    }
    
}