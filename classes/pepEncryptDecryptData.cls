public class pepEncryptDecryptData
{
    public static string EncryptData(string datastring)
    {
        Blob data = Blob.valueOf(datastring);
        String cryptoKeystring = Label.key;
        Blob cryptoKey = EncodingUtil.base64Decode(cryptoKeystring);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        return EncodingUtil.base64Encode(encryptedData);
    }
    
    public static string DecryptData(string datastring)
    {
        Blob data = EncodingUtil.base64Decode(datastring);
        String cryptoKeystring = Label.key;
        Blob cryptoKey = EncodingUtil.base64Decode(cryptoKeystring);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, data);
        return decryptedData.Tostring();
    }
}