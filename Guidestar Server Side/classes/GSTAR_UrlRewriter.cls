global class GSTAR_UrlRewriter implements Site.UrlRewriter {
    String NEW_GUIDESTAR_PREFIX = '/VF_Guidestar';
    String OLD_GUIDESTAR_MalkarPage = '/GS_Malkar';
    String NEW_GSTAR_HomePage = '/home';
    String NEW_GSTAR_MalkarPage = '/organization';
    String OLD_GSTAR_MalkarPage = '/he/organization';
    String NEW_GSTAR_TestSupportsPage = '/test-support';
	String NEW_GSTAR_MalkarSearchPage = '/search';
	String NEW_GSTAR_GlobalPage = '/page';
	String NEW_GSTAR_ContactPage = '/contact';

 
    global PageReference mapRequestUrl(PageReference myFriendlyUrl){
        String url = myFriendlyUrl.getUrl();
        if(url.startsWith(NEW_GSTAR_HomePage) || 
        	url.startsWith(NEW_GSTAR_MalkarPage) || 
        	url.startsWith(NEW_GSTAR_TestSupportsPage)  || 
        	url.startsWith(NEW_GSTAR_MalkarSearchPage) || 
        	url.startsWith(NEW_GSTAR_GlobalPage) || 
        	url.startsWith(NEW_GSTAR_ContactPage))
		{
        	String base64Url = EncodingUtil.base64Encode(Blob.valueOf(url));
	        PageReference p = Page.VF_Guidestar; 
	        p.getParameters().put('number', base64Url);
	        return p;  
        }
        if(url.startsWith(OLD_GSTAR_MalkarPage))
		{
			//url = url.replace(OLD_GSTAR_MalkarPage, NEW_GSTAR_MalkarPage);
        	String base64Url = EncodingUtil.base64Encode(Blob.valueOf(url));
	        PageReference p = Page.VF_Guidestar; 
	        p.getParameters().put('number', base64Url);
	        return p;  
        }
        
        if(url.startsWith(OLD_GUIDESTAR_MalkarPage))
		{
			String base64Url = EncodingUtil.base64Encode(Blob.valueOf('/home'));
	        PageReference p = Page.VF_Guidestar; 
	        p.getParameters().put('number', base64Url);
	        return p;  
        }
        return myFriendlyUrl;
    }
    
    global List<PageReference> generateUrlFor(PageReference[] mySalesforceUrls){
    	List<PageReference> myFriendlyUrls = new List<PageReference>();
        for(PageReference mySalesforceUrl : mySalesforceUrls){
            String sfUrl = mySalesforceUrl.getUrl();
            if( sfUrl.startsWith(NEW_GUIDESTAR_PREFIX) && mySalesforceUrl.getParameters().get('number') != null){
            	String base64Url = mySalesforceUrl.getParameters().get('number');
            	String url;
            	if(String.isNotBlank(base64Url)){
            		try{
            			url = EncodingUtil.base64Decode(base64Url).toString();	
            		}
            		catch(Exception e){
            			url = '/home';
            		}
            	}
            	else{
            		url = '/home';
            	}
            	
            	myFriendlyUrls.add(new PageReference(url));
            }
            else{
            	myFriendlyUrls.add(mySalesforceUrl);
            }
        }
        return myFriendlyUrls;
    }
}