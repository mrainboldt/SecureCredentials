/**
*
* @group Helper
*
* @description General helper class
*/
public class Helper {
    
    //For testing purposes, you can set the Production override by setting this static variable
    public static boolean isProductionOverride = false;
    public static boolean IsProduction() {
        if(isProductionOverride) {
            return true;
        }
        else {
            return ( UserInfo.getOrganizationId() == 'production org id' );
        }
    }

    /**
     * @description  encrypts using 256 and writes to debug logs to be put in Custom Metadatatypes 
     * @param  value string value to be encrypted
     */
    public static void encrypt(String value)
    {
        Blob encryptionKey = Crypto.generateAesKey(256);
        Blob keyChain = Crypto.generateAesKey(128);

        Blob data = Blob.valueOf(value);

        Blob encrypted = Crypto.encrypt('AES256', encryptionKey, keychain, data);

        //these lines are debugged to be able to update the API__mdt, Key__mdt, etc.
        System.debug(LoggingLevel.INFO, 'Keychain: ' +  EncodingUtil.base64encode(keyChain));
        System.debug(LoggingLevel.INFO, 'Encryption Key: ' + EncodingUtil.base64encode(encryptionKey));
        System.debug(LoggingLevel.INFO, 'Encrypted Data: ' + EncodingUtil.base64encode(encrypted));
    }

    public static String decrypt(String value, String key, String keychain)
    {
        return EncodingUtil.base64encode(Crypto.decrypt('AES256', EncodingUtil.base64decode(key), EncodingUtil.base64decode(keyChain), EncodingUtil.base64decode(value)));
    }

}