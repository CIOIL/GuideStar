@RestResource(urlMapping='/delegated-sso/*')
global class WS_DelegatedSSO {
    @HttpPost
    global static void authenticate(){
        
        RestRequest request = RestContext.request;
        Utils.log(RestContext.request.requestBody.tostring());
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/xml');
        String myData; 
        User myUser;
        boolean isValidated = false;
        try{
            myData = RestContext.request.requestBody.tostring();
            RequestBody requestBody = new RequestBody(myData);
            Utils.log(json.serialize(requestBody));
            string providerName = getProviderNameFromUsername(requestBody.username);
            if(providerName != null){
                if(providerName.toLowerCase() == 'chatter'){
                    myUser = Utils_DAL.getUserByUsername(requestBody.username);
                }
            }
            
            if(myUser != null){
                isValidated = true;
            }
        }catch(Exception e){}
        
        response.statusCode = 200;
        string res = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><AuthenticateResult xmlns="urn:authentication.soap.sforce.com"><Authenticated>'+isValidated+'</Authenticated></AuthenticateResult></soapenv:Body></soapenv:Envelope>';
        response.responseBody = Blob.valueOf(res);
    }
    
    global static string getProviderNameFromUsername(String username){
        try{
            if(username == null){return null;}
            if(username.contains('@') && username.contains('.com')){
                return username.substring(username.indexOf('@') +1 , username.lastIndexOf('.com'));
            }
            return null;
        }
        catch(Exception e){return null;}
    }
    
    global static string getProviderUserIdFromUsername(String username){
        try{
            if(username == null){return null;}
            if(username.contains('@')){
                return username.substring(0, username.indexOf('@'));
            }
            return null;
        }
        catch(Exception e){return null;}
    }
    
    public class RequestBody{
        public string username {get;set;}
        public string password {get;set;}

        public requestBody(string requestBody){
            if(requestBody != null){
                Dom.Document doc = new Dom.Document();
                doc.load(requestBody);
                Dom.XMLNode loginResult = doc.getRootElement().getChildElements()[0].getChildElements()[0];
                for(Dom.XMLNode child : loginResult.getChildElements()) {
                    if(child.getName() == 'username'){
                        username = child.getText();
                    }
                    else if(child.getName() == 'password'){
                        password = child.getText();
                    }
                }
            }
        }
    }
    
    
}