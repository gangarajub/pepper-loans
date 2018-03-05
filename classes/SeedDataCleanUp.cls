/**********************************************************************
 * Author:			Alex Humby
 * Date: 			12/9/17
 * Description:		
 * 
 * This class is only to be used if the Talend Seed Data Jobs fail and need to be rerun.
 * There are 4 Seed Data jobs that may need to be cleaned up, 
 * each method here relates to the job of the same name
 * 
 * Revisions:
 * 
 * *********************************************************************/

public class SeedDataCleanUp {

    public static void countMiscJobZ(Boolean doDelete){
        
        List<HEM__c> h = [select Id from HEM__c];
        System.debug(h.size() + ' HEM records');
        
        List<pepCmsAnswer__c> a = [select Id from pepCmsAnswer__c];
        System.debug(a.size() + ' Answer records');
        
        List<pepCmsPage__c> p = [select Id from pepCmsPage__c];
        System.debug(p.size() + ' Page records');
        
        List<pepCmsQuestion__c> q = [select Id from pepCmsQuestion__c];
        System.debug(q.size() + ' Question records');
        
        List<pepCmsSection__c> s = [select Id from pepCmsSection__c];
        System.debug(s.size() + ' Section records');
        
        
        List<Parameters_and_Interest_Mapping__c> pi = [select Id from Parameters_and_Interest_Mapping__c];
        System.debug(pi.size() + ' Param & Interest records');
        
        List<Monthly_Budget__c> mb = [select Id from Monthly_Budget__c];
        System.debug(mb.size() + ' Monthly Budget records');

        List<pepBank_API_Details__c> bad = [select Id from pepBank_API_Details__c];
        System.debug(bad.size() + ' Bank APIs records');

        List<Report_Configuration__c> rc = [select Id from Report_Configuration__c];
        System.debug(rc.size() + ' Report_Configuration__c records');
        
        List<smagicinteract__SMS_SenderId__c> smssi = [select Id from smagicinteract__SMS_SenderId__c];
        System.debug(smssi.size() + ' SMS SenderId records');
        
        List<smagicinteract__SMS_Template_Type__c> smstt = [select Id from smagicinteract__SMS_Template_Type__c];
        System.debug(smstt.size() + ' smagicinteract__SMS_Template_Type__c records');

        List<smagicinteract__SMS_Template__c> smst = [select Id from smagicinteract__SMS_Template__c];
        System.debug(smst.size() + ' smagicinteract__SMS_Template__c records');

        List<smagicworkflow__WorkflowXMLMap__c> smsxml = [select Id from smagicworkflow__WorkflowXMLMap__c];
        System.debug(smsxml.size() + ' smagicworkflow__WorkflowXMLMap__c records');
        
        List<CRM_Borrowing_Power_Living_Expense__c> bple = [select Id from CRM_Borrowing_Power_Living_Expense__c];
        System.debug(bple.size() + ' CRM_Borrowing_Power_Living_Expense__c records');

        List<CRM_Borrowing_Power_Other__c> bpo = [select Id from CRM_Borrowing_Power_Other__c];
        System.debug(bpo.size() + ' CRM_Borrowing_Power_Other__c records');

        List<CRM_Borrowing_Power_Rate__c> bpr = [select Id from CRM_Borrowing_Power_Rate__c];
        System.debug(bpr.size() + ' CRM_Borrowing_Power_Rate__c records');

        List<CRM_Tax_Rates__c> tax = [select Id from CRM_Tax_Rates__c];
        System.debug(tax.size() + ' CRM_Tax_Rates__c records');

        List<Score_Status_Configuration__c> ssc = [select Id from Score_Status_Configuration__c];
        System.debug(ssc.size() + ' Score_Status_Configuration__c records');

        List<Affordability_Configuration__c> ac = [select Id from Affordability_Configuration__c];
        System.debug(ac.size() + ' Affordability_Configuration__c records');
        
        List<loan__Investor_Tax_Configuration__c> itc = [select Id from loan__Investor_Tax_Configuration__c];
        System.debug(itc.size() + ' loan__Investor_Tax_Configuration__c records');

        List<loan__Journal__c> j = [select Id from loan__Journal__c];
        System.debug(j.size() + ' loan__Journal__c records');

        List<clcommon__Help_Info__c> hi = [select Id from clcommon__Help_Info__c];
        System.debug(hi.size() + ' clcommon__Help_Info__c records');

        List<clcommon__Party_Type__c> pt = [select Id from clcommon__Party_Type__c];
        System.debug(pt.size() + ' clcommon__Party_Type__c records');
        
        List<CRMWebClient__Interaction_Attribute__c> ia = [select Id from CRMWebClient__Interaction_Attribute__c];
        System.debug(ia.size() + ' CRMWebClient__Interaction_Attribute__c records'); //1
        
        List<Decisioning_Configuration__c> dc = [select Id from Decisioning_Configuration__c];
        System.debug(dc.size() + ' Decisioning_Configuration__c records');
        
        List<filegen__File_Metadata__c> fm = [select Id from filegen__File_Metadata__c];
        System.debug(fm.size() + ' filegen__File_Metadata__c records');
        
        List<genesis__Application_Wizard_Config__c> awc = [select Id from genesis__Application_Wizard_Config__c];
        System.debug(awc.size() + ' genesis__Application_Wizard_Config__c records');
        
        List<genesis__Conversion_Mapping__c> cm = [select Id from genesis__Conversion_Mapping__c];
        System.debug(cm.size() + ' genesis__Conversion_Mapping__c records');

        List<genesis__Transaction_Categorization__c> tc = [select Id from genesis__Transaction_Categorization__c];
        System.debug(tc.size() + ' genesis__Transaction_Categorization__c records'); //1
        
        List<loan__Business_Activity__c> ba = [select Id from loan__Business_Activity__c];
        System.debug(ba.size() + ' loan__Business_Activity__c records');
        
        List<loan__Commission_Plan__c> cp = [select Id from loan__Commission_Plan__c];
        System.debug(cp.size() + ' loan__Commission_Plan__c records');
        
        List<loan__Currency__c> cur = [select Id from loan__Currency__c];
        System.debug(cur.size() + ' loan__Currency__c records');
        
        List<loan__Loan_Payment_Spread__c> lps = [select Id from loan__Loan_Payment_Spread__c];
        System.debug(lps.size() + ' loan__Loan_Payment_Spread__c records');

        List<loan__Misc_Account__c> ma = [select Id from loan__Misc_Account__c];
        System.debug(ma.size() + ' loan__Misc_Account__c records'); //1
        
        List<loan__Transaction_Source__c> ts = [select Id from loan__Transaction_Source__c];
        System.debug(ts.size() + ' loan__Transaction_Source__c records');
        
        List<peer__Credit_Rating_Matrix__c> crm = [select Id from peer__Credit_Rating_Matrix__c];
        System.debug(crm.size() + ' peer__Credit_Rating_Matrix__c records');
        
        List<peer__Note_Type__c> nt = [select Id from peer__Note_Type__c];
        System.debug(nt.size() + ' peer__Note_Type__c records');
                
        if(doDelete){
            System.debug('Now deleting them ALL...');
          delete mb;
            delete bad;
            delete pi;
            delete s;
            delete h;
            delete a;
            delete p;
            delete q;
            //delete ga;
            delete rc;
            delete smssi;
            delete smstt;
            delete smst;
            delete smsxml;
            delete bple;
            delete bpo;
            delete bpr;
            delete tax;
            delete ssc;
            delete ac;
            delete itc;
            delete j;
            delete hi;
            delete pt;

        delete ia; //1
        delete dc;
        
        delete fm;
        delete awc;
        delete cm;
    delete tc; //1
        delete ba;
        delete cp;
        delete cur;
        //delete lps;
        delete ma; //1
        delete ts;
        delete crm;
        delete nt;

            System.debug('Deletes finished');
        }        
    }
    
    public static void countSeedJobA(Boolean doDelete){

        List<  loan__Fiscal_Year__c  >   Fisc   = [select Id from   loan__Fiscal_Year__c  ];
        List<  clcommon__Collateral_Type__c  >   Coll   = [select Id from   clcommon__Collateral_Type__c  ];
        List<  cnotify__Configuration__c  >   Conf   = [select Id from   cnotify__Configuration__c  ];
        List<  collect__Action_Code__c  >   Acti   = [select Id from   collect__Action_Code__c  ];
        List<  genesis__Branch_Location__c  >   GBra   = [select Id from   genesis__Branch_Location__c  ];
        List<  genesis__Department__c  >   Depa   = [select Id from   genesis__Department__c  ];
        List<  genesis__Scorecard__c  >   Scor   = [select Id from   genesis__Scorecard__c  ];
        List<  genesis__Task_Setup__c  >   Task   = [select Id from   genesis__Task_Setup__c  ];
        List<  loan__Branch_Location__c  >   Bran   = [select Id from   loan__Branch_Location__c  ];
        List<  loan__Loan_Purpose__c  >   LPur   = [select Id from   loan__Loan_Purpose__c  ];
        List<  loan__MF_Account_Type__c  >   MFAc   = [select Id from   loan__MF_Account_Type__c  ];
        List<  loan__Office_Type__c  >   Offi   = [select Id from   loan__Office_Type__c  ];
        List<  loan__Floating_Rate_Index__c  >   Floa   = [select Id from   loan__Floating_Rate_Index__c  ];
        List<  genesis__Credit_Rating_Matrix__c  >   Cred   = [select Id from   genesis__Credit_Rating_Matrix__c  ];
        List<  loan__Business_Event__c  >   Busi   = [select Id from   loan__Business_Event__c  ];
        List<  loan__Delinquency_Interval__c  >   Deli   = [select Id from   loan__Delinquency_Interval__c  ];
        List<  loan__Delinquency_Set__c  >   Delis   = [select Id from   loan__Delinquency_Set__c  ];
        List<  loan__Delinquency_Set_Junction__c  >   Delij   = [select Id from   loan__Delinquency_Set_Junction__c  ];
        List<  collect__Source_System__c  >   Sour   = [select Id from   collect__Source_System__c  ];
        List<  clcommon__Party_Type__c  >   Part   = [select Id from   clcommon__Party_Type__c  ];
                                
        System.debug(  Fisc.size()   + '   loan__Fiscal_Year__c   records ');    
        System.debug(  Coll.size()   + '   clcommon__Collateral_Type__c   records ');    
        System.debug(  Conf.size()   + '   cnotify__Configuration__c   records ');    
        System.debug(  Acti.size()   + '   collect__Action_Code__c   records ');    
        System.debug(  GBra.size()   + '   genesis__Branch_Location__c   records ');    
        System.debug(  Depa.size()   + '   genesis__Department__c   records ');    
        System.debug(  Scor.size()   + '   genesis__Scorecard__c   records ');    
        System.debug(  Task.size()   + '   genesis__Task_Setup__c   records ');    
        System.debug(  Bran.size()   + '   loan__Branch_Location__c   records ');    
        System.debug(  LPur.size()   + '   loan__Loan_Purpose__c   records ');    
        System.debug(  MFAc.size()   + '   loan__MF_Account_Type__c   records ');    
        System.debug(  Offi.size()   + '   loan__Office_Type__c   records ');    
        System.debug(  Floa.size()   + '   loan__Floating_Rate_Index__c   records ');    
        System.debug(  Cred.size()   + '   genesis__Credit_Rating_Matrix__c   records ');    
        System.debug(  Busi.size()   + '   loan__Business_Event__c   records ');    
        System.debug(  Deli.size()   + '   loan__Delinquency_Interval__c   records ');    
        System.debug(  Delis.size()   + '   loan__Delinquency_Set__c   records ');    
        System.debug(  Delij.size()   + '   loan__Delinquency_Set_Junction__c   records ');    
        System.debug(  Sour.size()   + '   collect__Source_System__c   records ');    
        System.debug(  Part.size()   + '   clcommon__Party_Type__c   records ');    

          
        if(doDelete){
            System.debug('Now deleting them ALL...');

            delete   Fisc  ;
            delete   Coll  ;
            delete   Conf  ;
            delete   Acti  ;
            delete   GBra  ;
            delete   Depa  ;
            delete   Scor  ;
            delete   Task  ;
            delete   Bran  ;
            delete   LPur  ;
            delete   MFAc  ;
            delete   Offi  ;
            delete   Floa  ;
            delete   Cred  ;
            delete   Busi  ;
            //delete   Deli  ;
            //delete   Delis  ;
            //delete   Delij  ;
            delete   Sour  ;
            delete   Part  ;


            System.debug('Deletes finished');
        }        
        
    }
    
    public static void countSeedJobB(Boolean doDelete){
        
        List<genesis__Document_Category__c> doccat = [select id from genesis__Document_Category__c];
        System.debug (doccat.size() + ' genesis__Document_Category__c records');
        
        List<genesis__Collateral_Document_Category_Junction__c>  coldoccat = [select id from genesis__Collateral_Document_Category_Junction__c];
        System.debug (coldoccat.size() + ' genesis__Collateral_Document_Category_Junction__c records');
        
        List<collect__Action_Code_Config__c> actconf = [select id from collect__Action_Code_Config__c];
        System.debug (actconf.size() + ' collect__Action_Code_Config__c records');
        
        List<genesis__Company__c> genco = [select id from genesis__Company__c];
        System.debug (genco.size() + ' genesis__Company__c records');

        List<collect__Collection_Configuration__c> colCon = [select id from collect__Collection_Configuration__c];
        System.debug (colcon.size() + ' collect__Collection_Configuration__c records');
        
        List<collect__Criteria__c> crit = [select id from collect__Criteria__c];
        System.debug (crit.size() + ' collect__Criteria__c records');
        
        List<collect__Collection_Configuration_Actions__c> cca = [select id from collect__Collection_Configuration_Actions__c];
        System.debug (cca.size() + ' collect__Collection_Configuration_Actions__c records');
        
        List<ScCollection_Funders_Target__c> ft = [select id from ScCollection_Funders_Target__c];
        System.debug (ft.size() + ' ScCollection_Funders_Target__c records');

        List<ScCollection_Letter_Template__c> lt = [select id from ScCollection_Letter_Template__c];
        System.debug (lt.size() + ' ScCollection_Letter_Template__c records');
        
        List<ScCollection_Paragraph_Config__c> lpc = [select id from ScCollection_Paragraph_Config__c];
        System.debug (lpc.size() + ' ScCollection_Paragraph_Config__c records');
        
        List<ScCollection_Contract_Summary__c> cs = [select id from ScCollection_Contract_Summary__c];
        System.debug (cs.size() + ' ScCollection_Contract_Summary__c records');
        

        if(doDelete){
            System.debug('Doing Delete');
            delete doccat;
            delete coldoccat;
            delete actconf;
            delete colcon;
            //delete cca;
      		delete crit;
            delete cs;
            delete genco;
            delete ft;
            delete lt;
            //delete lpc;
            
            System.debug('Done delete');
        }
        
    }
    
    public static void countSeedJobC(Boolean doDelete){
        List<loan__Accounting_Rule_Line__c> arl = [select id from loan__Accounting_Rule_Line__c];
        System.debug (arl.size() + ' loan__Accounting_Rule_Line__c records');
        
        List<loan__Fee_Junction__c>  fj = [select id from loan__Fee_Junction__c];
        System.debug (fj.size() + ' loan__Fee_Junction__c records');
        
        List<loan__Loan_Product_Accounting_Setup__c> lpas = [select id from loan__Loan_Product_Accounting_Setup__c];
        System.debug (lpas.size() + ' loan__Loan_Product_Accounting_Setup__c records');
        
        List<loan__Loan_Loss_Provisioning_Setup__c> llps = [select id from loan__Loan_Loss_Provisioning_Setup__c];
        System.debug (llps.size() + ' loan__Loan_Loss_Provisioning_Setup__c records');

        List<loan__Amortization_Setup__c> las = [select id from loan__Amortization_Setup__c];
        System.debug (las.size() + ' loan__Amortization_Setup__c records');
        
        List<loan__Recovery_Order__c> ro = [select id from loan__Recovery_Order__c];
        System.debug (ro.size() + ' loan__Recovery_Order__c records');
        
        List<loan__Branch_Loan_Product__c> blp = [select id from loan__Branch_Loan_Product__c];
        System.debug (blp.size() + ' loan__Branch_Loan_Product__c records');
        
        List<loan__Day_Process__c> dp = [select id from loan__Day_Process__c];
        System.debug (dp.size() + ' loan__Day_Process__c records');

        List<loan__Month_Process__c> mp = [select id from loan__Month_Process__c];
        System.debug (mp.size() + ' loan__Month_Process__c records');
        
        List<loan__User_Branch_Info__c> ubi = [select id from loan__User_Branch_Info__c];
        System.debug (ubi.size() + ' loan__User_Branch_Info__c records');
        
        List<loan__Fee_Set__c> fs = [select id from loan__Fee_Set__c];
        System.debug (fs.size() + ' loan__Fee_Set__c records');
        
        List<loan__Fee__c> fee = [select id from loan__Fee__c];
        System.debug (fee.size() + ' loan__Fee__c records');

        List<loan__Office_Name__c> lon = [select id from loan__Office_Name__c];
        System.debug (lon.size() + ' loan__Office_Name__c records');

        List<loan__Loan_Product__c> lp = [select id from loan__Loan_Product__c];
        System.debug (lp.size() + ' loan__Loan_Product__c records');

        List<loan__MF_Account__c> mfa = [select id from loan__MF_Account__c];
        System.debug (mfa.size() + ' loan__MF_Account__c records');

        if(doDelete){
            System.debug('Doing Delete');
            delete arl;
            delete fj;
            delete lpas;
            delete llps;
            delete las;
      delete ro;
            delete dp;
            delete blp;
            delete mp;
            delete ubi;
            delete fs;

            delete fee;
            delete lon;
            delete lp;
            delete mfa;
            
            System.debug('Done delete');
        }
        
        
    }
    
}