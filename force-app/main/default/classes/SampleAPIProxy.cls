/**
 * @description proxy provide auth details to call a sample API
 * @author M Rainboldt
 * @created NOV 2022
 */
public with sharing class SampleAPIProxy {
    public String authType {get; private set;}
    public String endpoint {get; private set;}

    private Api__mdt apiSettings;
	private Key__mdt keySettings;

    public String authToken{
        get{
            return EncodingUtil.base64Decode(Helper.decrypt(apiSettings.Key__c, keySettings.Encryption_Key__c, apiSettings.Keychain__c)).toString();
        }
        private set;
    }

	/**
	 * @description initialize the settings
	 */
	private void getSettings(String environment)
	{
		apiSettings = [SELECT Key__c
						, Keychain__c
						, Endpoint__c 
						FROM Api__mdt 
						WHERE DeveloperName = :environment
						LIMIT 1];
		keySettings = [SELECT Encryption_Key__c
						FROM Key__mdt
						WHERE Keychain__c = :apiSettings.Keychain__c
						LIMIT 1];
		
	}

    public SampleAPIProxy() {
        Sample_API_Settings__c settings = Sample_API_Settings__c.getInstance(UserInfo.getUserId());
        this.authType = 'Basic';
        //this setting tells us to call the live version of the test version of Stripe
        if(settings.Is_Live_Environment__c)
        {
            this.getSettings('API_Prod');
            //this.authToken = settings.Production_Key__c;
        	this.endpoint = settings.Production_Endpoint__c;
        }
        else
        {
            this.getSettings('API_Test');
            //this.authToken = settings.Test_Key__c;
        	this.endpoint = settings.Test_Endpoint__c;
        }
    }

    public class SampleApiProxyException extends Exception{}
}