@isTest public class crmCalculatingBorrowingPower_Tracker{
    
    @isTest static void Test0(){
        
        Lead objLead = new Lead();
        objLead.lastname = 'test';
        objLead.Company = 'comp';
        objLead.CRM_Lead_Channel__c = 'Digital';
        objLead.CRM_Lead_Channel_Level_2__c='Email';
        objLead.CRM_Est_Rent_Income__c = 200000;
        objLead.CRM_Gross_Income_Borrower_1__c  = 20000000;
        objLead.CRM_Borrower_Count__c = 2;
        objLead.CRM_Loan_Purpose__c ='Purchase' ;
        
        insert objLead;
        
        Party__c part = new party__c();
        part.CRM_Name__c='ConName' ;
        part.CRM_Email__c = 'test@email.com' ;
        part.CRM_Phone__c = '1';
        part.CRM_Type__c = 'Co Borrower';
        part.CRM_Company__c = 'testAccount';
        part.Lead__c = objLead.id;
        part.CRM_Credit_Impairment__c = true;
        part.CRM_Months_Self_Employed__c ='2';
        part.CRM_Years_Self_Employed__c ='1';
        part.CRM_Gross_Income__c = 20000000;
        part.CRM_Gross_Income_Frequency__c = '200000';
        
        insert part;
        
        CRM_Borrowing_Power_Other__c borrTax = new CRM_Borrowing_Power_Other__c();
        borrTax.CRM_Term_Years__c =30;
        borrTax.CRM_Credit_Card_Multiplier__c =0.0300;
        borrTax.CRM_NSR__c=1;
        borrTax.CRM_Rent_Rate__c=0.0800;
        borrTax.CRM_Start_Date__c=System.Today()-455;
        borrTax.CRM_Mortgage_Debt_Rate__c=0.2000;
        
        insert borrTax;
        
        List<CRM_Tax_Rates__c> lstTax = new List<CRM_Tax_Rates__c>();
        CRM_Tax_Rates__c taxRate = new CRM_Tax_Rates__c();
        taxRate.CRM_Type__c = 1;
        taxRate.CRM_Type_Description__c = 'PAYG';
        taxRate.CRM_Bracket_Min__c = 180001.00 ;
        taxRate.CRM_Bracket_Rate__c = 0.4500;
        taxRate.CRM_Start_Date__c = System.Today()-455;
        lstTax.add(taxRate);
        
        CRM_Tax_Rates__c taxRate1 = new CRM_Tax_Rates__c();
        taxRate1.CRM_Type__c = 1;
        taxRate1.CRM_Type_Description__c = 'PAYG';
        taxRate1.CRM_Bracket_Min__c = 37001.00 ;
        taxRate1.CRM_Bracket_Max__c = 80000.00;
        taxRate1.CRM_Bracket_Rate__c = 0.3250;
        taxRate1.CRM_Bracket_Amount__c = 13975.00;
        taxRate1.CRM_Start_Date__c = System.Today()-455;
        lstTax.add(taxRate1);
        
        CRM_Tax_Rates__c taxRate2 = new CRM_Tax_Rates__c();
        taxRate2.CRM_Type__c = 3;
        taxRate2.CRM_Type_Description__c = 'Medicare Levy';
        taxRate2.CRM_Bracket_Min__c = 20542.00 ;
        taxRate2.CRM_Bracket_Max__c = 24166.00;
        taxRate2.CRM_Bracket_Rate__c = 0.1000;
        taxRate2.CRM_Bracket_Amount__c = 362.50;
        taxRate2.CRM_Start_Date__c = System.Today()-455;
        lstTax.add(taxRate2);
        
        CRM_Tax_Rates__c taxRate3 = new CRM_Tax_Rates__c();
        taxRate3.CRM_Type__c = 1;
        taxRate3.CRM_Type_Description__c = 'PAYG';
        taxRate3.CRM_Bracket_Min__c = 0.00;
        taxRate3.CRM_Bracket_Max__c = 20541.00;
        taxRate3.CRM_Bracket_Rate__c = 0.0000;
        taxRate3.CRM_Bracket_Amount__c = 0.00;
        taxRate3.CRM_Start_Date__c = System.Today()-455;
        lstTax.add(taxRate3);
        
        insert lstTax;
        
        List<CRM_Borrowing_Power_Rate__c> lstBorrRate = new List<CRM_Borrowing_Power_Rate__c>();
        CRM_Borrowing_Power_Rate__c powRate = new CRM_Borrowing_Power_Rate__c();
        powRate.CRM_Type_Detail__c = 'Prime Full Doc';
        powRate.CRM_Type__c = 'PFD';
        powRate.CRM_Credit_Impairment__c = false;
        powRate.CRM_Self_Employed__c = false;
        powRate.CRM_Rate__c = 0.0720;
        powRate.CRM_Start_Date__c = System.Today()-455 ;
        powRate.CRM_Self_Employed_Months__c = 0;
        lstBorrRate.add(powRate);
        
        CRM_Borrowing_Power_Rate__c powRate1 = new CRM_Borrowing_Power_Rate__c();
        powRate1.CRM_Type_Detail__c = 'Non-Conforming Low Doc';
        powRate1.CRM_Type__c = 'NCLD';
        powRate1.CRM_Credit_Impairment__c = true;
        powRate1.CRM_Self_Employed__c = true;
        powRate1.CRM_Rate__c = 0.0804;
        powRate1.CRM_Start_Date__c = System.Today()-455 ;
        powRate1.CRM_Self_Employed_Months__c = 0;
        lstBorrRate.add(powRate1);
        
        CRM_Borrowing_Power_Rate__c powRate2 = new CRM_Borrowing_Power_Rate__c();
        powRate2.CRM_Type_Detail__c = 'Non-Conforming Full Doc';
        powRate2.CRM_Type__c = 'NCFD';
        powRate2.CRM_Credit_Impairment__c = true;
        powRate2.CRM_Self_Employed__c = false;
        powRate2.CRM_Rate__c = 0.0799;
        powRate2.CRM_Start_Date__c = System.Today()-455 ;
        powRate2.CRM_Self_Employed_Months__c = 0;
        lstBorrRate.add(powRate2);
        
        CRM_Borrowing_Power_Rate__c powRate3 = new CRM_Borrowing_Power_Rate__c();
        powRate3.CRM_Type_Detail__c = 'Prime Low Doc';
        powRate3.CRM_Type__c = 'PLD';
        powRate3.CRM_Credit_Impairment__c = false;
        powRate3.CRM_Self_Employed__c = true;
        powRate3.CRM_Rate__c = 0.0720;
        powRate3.CRM_Start_Date__c = System.Today()-455 ;
        powRate3.CRM_Self_Employed_Months__c = 24;
        lstBorrRate.add(powRate3);
        
        insert lstBorrRate;
        
        CRM_Borrowing_Power_Living_Expense__c objLiving = new CRM_Borrowing_Power_Living_Expense__c();
        objLiving.CRM_Lower_Threshold__c = 600000.00;
        objLiving.CRM_Single_Adult_Increment__c = 5.00;
        objLiving.CRM_Single_Adult_Base__c = 15564.00;
        objLiving.CRM_Couple_Base__c = 26724.00;
        objLiving.CRM_Couple_Increment__c = 10.00;
        objLiving.CRM_Dependant_Base__c = 5520.00;
        objLiving.CRM_Couple_Increment__c = 3.00;
        objLiving.CRM_Start_Date__c = System.Today()-455;
        
        insert objLiving;
        
     /*   
        crmCalculatingBorrowingPower objClass = new crmCalculatingBorrowingPower();
        crmCalculatingBorrowingPower.fetchBorrowingPower(objLead.id,part.id);
     */   
        CRMLeadRest obj = new CRMLeadRest();
        CRMLeadRest.getBorrPowerFromLeadID(objLead.id,part.id);
        CRMLeadRest.getBorrPowerFromLeadID(objLead.id,null);
        CRMLeadRest.getBorrPowerFromLeadID(part.id,null);
    }
    
    
    
}