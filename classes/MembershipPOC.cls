public class MembershipPOC
{
    public void getUserInfo()
    {
        Membership_tempuriOrg.BasicHttpBinding_IAccountService m = new Membership_tempuriOrg.BasicHttpBinding_IAccountService();
        Membership_schemasDatacontractOrg.PepperUserModel test = new Membership_schemasDatacontractOrg.PepperUserModel();

        test = m.GetUser('aussieone');
        system.debug(test);
    }
    
    //This one works!
    public void getCertUserInfo()
    {
        cert_tempuriOrg.BasicHttpBinding_IAccountService m = new cert_tempuriOrg.BasicHttpBinding_IAccountService();
        cert_schemasDatacontractOrg.PepperUserModel test = new cert_schemasDatacontractOrg.PepperUserModel();

        test = m.GetUser('aussieone');
        system.debug(test);
    }
    
    
    public void getProdUserInfo()
    {
        Prod_tempuriOrg.BasicHttpBinding_IAccountService m = new Prod_tempuriOrg.BasicHttpBinding_IAccountService();
        Prod_schemasDatacontractOrg.PepperUserModel test = new Prod_schemasDatacontractOrg.PepperUserModel();

        test = m.GetUser('pepperone');
        system.debug(test);
    }
    
    public void getAsiaUserInfo()
    {
        asia_tempuriOrg.BasicHttpBinding_IAccountService m = new asia_tempuriOrg.BasicHttpBinding_IAccountService();
        asia_schemasDatacontractOrg200407Pepperm.PepperUserModel test = new asia_schemasDatacontractOrg200407Pepperm.PepperUserModel();

        test = m.GetUser('pepperone');
        system.debug(test);
    }
}