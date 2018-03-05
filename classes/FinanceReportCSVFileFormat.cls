Public Class FinanceReportCSVFileFormat{
    
    public String DOCID;
    public String DREF1;
    public String DSOURCE;
    public String DPERIOD;
    public String DTYPE;
    public String DCLRENTITY;
    public String DENTITYE;
    public String LINEID;
    public String LNEDETAILTYPE;
    public String LLDGCODE;
    public String LACCNBR;
    public String LAMOUNT1;
    public String LNARR1;
    public String LNARR2;
    public String LNARR3;
    public String BIMPNAME;
    public String BNAME;
    public String BGROUP;
    public String BDESCR;
    public String BNARR1;
    public String BNARR2;
    public String BNARR3;
    public String BFORMAT;
    public String BDOCTYPE;
    public String BPERIOD;
    public String BPROGRP;
    public String BSUSPLDGCODE;
    public String BSUSPACCNBRI;
    public String BBALLDG;
    public String BBALACCNBR;
    public String BDATE;
    public String BCLRENTITY;
    public String BSTATUS;
    public String LGSTTYPE;
    public String LGSTRATECODE;
    
    public FinanceReportCSVFileFormat(String docId,
                            String dref1,
                            String dperiod,
                            String lineId,
                            String laccnbr,
                            String lamount,
                            String lnarr1,
                            String lnarr2,
                            Date entryDate,
                            String strateCode){
        
        String bDate = String.valueOf(entryDate.addMonths(1).toStartOfMonth().addDays(-1));
        
        this.DOCID = docId;
        this.DREF1 = dref1;
        this.DSOURCE = 'GL';
        this.DPERIOD = dperiod;
        this.DTYPE = '$JOURNAL';
        this.DCLRENTITY = '1000';
        this.DENTITYE = 'S';
        this.LINEID = lineId;
        this.LNEDETAILTYPE = 'L';
        this.LLDGCODE = 'GL';
        this.LACCNBR = laccnbr;
        this.LAMOUNT1 = lamount;
        this.LNARR1 = lnarr1;
        this.LNARR2 = lnarr2;
        this.LNARR3 = '';
        this.BIMPNAME = 'SALESFOR';
        this.BNAME = '';
        this.BGROUP = '$DEFAULT';
        this.BDESCR = 'SALESFORCE IMPORT';
        this.BNARR1 = '';
        this.BNARR2 = '';
        this.BNARR3 = '';
        this.BFORMAT = '';
        this.BDOCTYPE = '';
        this.BPERIOD = '';
        this.BPROGRP = '';
        this.BSUSPLDGCODE = '';
        this.BSUSPACCNBRI = '';
        this.BBALLDG = '';
        this.BBALACCNBR = '';
        this.BDATE = bDate;
        this.BCLRENTITY = '';
        this.BSTATUS = '';
        this.LGSTTYPE = 'I';
        this.LGSTRATECODE = strateCode;
    }
    
    public String getEntry(){
        String row = '';
        List<String> entryRecord = new List<String>();
        entryRecord.add(this.DOCID);
        entryRecord.add(this.DREF1);
        entryRecord.add(this.DSOURCE);
        entryRecord.add(this.DPERIOD);
        entryRecord.add(this.DTYPE);
        entryRecord.add(this.DCLRENTITY);
        entryRecord.add(this.DENTITYE);
        entryRecord.add(this.LINEID);
        entryRecord.add(this.LNEDETAILTYPE);
        entryRecord.add(this.LLDGCODE);
        entryRecord.add(this.LACCNBR);
        entryRecord.add(this.LAMOUNT1);
        entryRecord.add(this.LNARR1);
        entryRecord.add(this.LNARR2);
        entryRecord.add(this.LNARR3);
        entryRecord.add(this.BIMPNAME);
        entryRecord.add(this.BNAME);
        entryRecord.add(this.BGROUP);
        entryRecord.add(this.BDESCR);
        entryRecord.add(this.BNARR1);
        entryRecord.add(this.BNARR2);
        entryRecord.add(this.BNARR3);
        entryRecord.add(this.BFORMAT);
        entryRecord.add(this.BDOCTYPE);
        entryRecord.add(this.BPERIOD);
        entryRecord.add(this.BPROGRP);
        entryRecord.add(this.BSUSPLDGCODE);
        entryRecord.add(this.BSUSPACCNBRI);
        entryRecord.add(this.BBALLDG);
        entryRecord.add(this.BBALACCNBR);
        entryRecord.add(this.BDATE);
        entryRecord.add(this.BCLRENTITY);
        entryRecord.add(this.BSTATUS); 
        entryRecord.add(this.LGSTTYPE); 
        entryRecord.add(this.LGSTRATECODE); 
        
        for(String entry : entryRecord){
            row += entry + ',';
        }
        row = row.removeEnd(',');
        row += '\r\n';
        
        return row;
    }
    
    public String getAmountValue(){
        return this.LAMOUNT1;
    }
    
    public void setAmountValue(Decimal amtVal){
        this.LAMOUNT1 = String.valueOf(amtVal);
    }    
}