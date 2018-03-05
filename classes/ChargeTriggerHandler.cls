public class ChargeTriggerHandler {

    public static Boolean updateLoans = true;
    // Added the following boolean to turn this trigger into a no-op
    // By default the trigger is operational
    public static Boolean skipTrigger = false;
    private static clcommon.PlatformLog logInstance = clcommon.PlatformLog.getLogger();

    Set<ID> feeIds = new Set<ID>();
    Map<Id, loan__Fee__c> fees;

    Set<ID> loanIds = new Set<ID>();
    Map<Id, loan__Loan_Account__c> loanIdMap;

    private List<loan__Charge__c> charges;
    private Map<Id, loan__Charge__c> oldMap;



    public ChargeTriggerHandler(List<loan__Charge__c> newList,
                                    Map<Id, loan__Charge__c> oldMap) {
        Map<Id, loan__Office_Name__c> selectedBranches =
                                    new Map<Id, loan__Office_Name__c>(
                                                [SELECT ID,
                                                 Name,
                                                 loan__Current_System_Date__c,
                                                 loan__Is_Branch__c,
                                                 loan__Mark_Suspended_After_Days__c,
                                                 loan__Parent_Office__c
                                                 FROM
                                                 loan__Office_Name__c]);
        Set<loan__Office_Name__c> branches = new Set<loan__Office_Name__c>(selectedBranches.values());
        Set<Id> branchIds = new Set<Id>();
        for(loan__Office_Name__c b : branches)
                branchIds.add(b.Id);
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date sodDate = util.getCurrentSystemDate().addDays(1);
        List<loan__Day_Process__c> dayPList = [select ID,
                                loan__SOD_Process_Started__c
                                FROM loan__Day_Process__c
                                WHERE loan__Date__c = :sodDate
                                AND loan__Branch__c in :branchIds And loan__SOD_Process_Started__c = true AND loan__Accounts_Accrured__c = false];

        if(dayPList.size()>0){
            updateLoans = false;
        }
        
        
        this.charges = newList;
        this.oldMap = oldMap;

        for (loan__Charge__c charge : charges) {
            if (charge.loan__Fee__c != null) {
                feeIds.add(charge.loan__Fee__c);
            }
            loanIds.add(charge.loan__Loan_Account__c);
        }
        fees = new Map<Id, loan__Fee__c>([SELECT Id,
                                           Name,
                                           loan__Amount__c,
                                           loan__Minimum_Amount__c,
                                           loan__Maximum_Amount__c,
                                           loan__Fee_Calculation_Method__c,
                                           loan__Recurrent_Charge_Minimum_Days__c,
                                           loan__Time_of_charge__c,
                                           loan__Is_Fee_Capitalized__c
                                    FROM loan__Fee__c
                                    WHERE Id IN :feeIds
                                   ]);
        loanIdMap = new Map<Id, loan__Loan_Account__c>([SELECT Id,
                                                     Name,
                                                     loan__Total_Due_Charges__c,
                                                     loan__Fees_Paid__c,
                                                     loan__Term_Cur__c,
                                                     loan__Principal_Remaining__c,
                                                     loan__Loan_Amount__c,
                                                     loan__Last_Disbursal_Amount__c,
                                                     loan__Interest_Rate__c,
                                                     loan__Number_Of_Installments__c,
                                                     loan__Interest_Calculation_Method__c,
                                                     loan__Repayment_Tied_to_Meeting_Schedule__c,
                                                     loan__Frequency_of_Loan_Payment__c,
                                                     loan__Payment_Frequency_Cycle__c,
                                                     loan__Principal_Adjustment__c,
                                                     loan__Principal_Adjustment_Subtract__c,
                                                     loan__Pay_Off_Amount_As_Of_Today__c,
                                                     loan__Accrual_Stop_Indicator__c,
                                                     loan__Fees_Remaining__c,
                                                     loan__Capitalized_Fee__c,
                                                     loan__Interest_Remaining__c,
                                                     loan__Product_Type__c,
                                                     loan__Last_Accrual_Date__c,
                                                     loan__Time_Counting_Method__c,
                                                     loan__Capitalized_Interest__c,
                                                     loan__Loan_Balance__c,
                                                     loan__Interest_Posted__c,
                                                     loan__Interest_Accrued_Not_Due__c, 
                                                     loan__Interest_Posting_Day__c, 
                                                     loan__Next_Capitalization_Date__c,
                                                     loan__Interest_Posting_Frequency__c, 
                                                     loan__Is_Capitalization_Enabled__c, 
                                                     loan__Is_Interest_Posting_Enabled__c,
                                                     loan__Next_Interest_Posting_Date__c,
                                                     (select id,Name,
                                                     loan__Balance__c,
                                                     loan__Capitalization_Date__c,
                                                     loan__Interest_Posted__c,
                                                     loan__Transaction_Creation_Date__c,
                                                     loan__Transaction_Posting_Date__c,
                                                     loan__Interest_Rate__c
                                                     from loan__Interest_Posting_Transactions__r
                                                     where loan__Is_Capitalized__c=true and Adjustment_Transaction__c = false
                                                     order by loan__Capitalization_Date__c asc),
                                                     (select id,Name,
                                                     loan__Transaction_Type__c,
                                                     loan__Txn_Date__c,
                                                     loan__New_Interest_Rate__c,
                                                     loan__Interest_Rate__c
                                                     from loan__Other_Loan_Transactions__r
                                                     where loan__Transaction_Type__c=:loan.LoanConstants.LOAN_TRANSACTION_RATE_CHANGE),
                                                     (SELECT Id,
                                                             Name,
                                                             loan__Loan_Account__c,
                                                             loan__Block_Code__c,
                                                             loan__Block_Code_Applied_On__c,
                                                             loan__Block_Code_Expires_On__c,
                                                             loan__Block_Code_Revoked__c,
                                                             loan__Block_Code_Revoked_On__c,
                                                             loan__Minutes_To_Expire_Code__c,
                                                             loan__Suspend_ACH__c,
                                                             loan__Suspend_Charges__c,
                                                             loan__Suspend_Communication__c,
                                                             loan__Stop_Accruals__c,
                                                             loan__Suspend_Disbursals__c,
                                                             loan__Block_Code_Expiry_Processed__c
                                                      FROM loan__Loan_Block_Codes__r
                                                      WHERE loan__Suspend_Charges__c = true
                                                          AND loan__Block_Code_Revoked__c = false
                                                          AND loan__Block_Code_Expiry_Processed__c = false
                                                     ),
                                                     (Select Id,
                                                             Name,
                                                             loan__Date__c,
                                                             loan__Fee__c,
                                                             loan__Waive__c
                                                      FROM loan__Charges__r
                                                      WHERE loan__Fee__c IN :feeIds
                                                          AND loan__Waive__c = false
                                                          AND loan__Fee__r.loan__Recurrent_Charge_Minimum_Days__c != null
                                                          AND loan__Fee__r.loan__Recurrent_Charge_Minimum_Days__c != 0
                                                      ORDER BY loan__Date__c DESC
                                                     )
                                              FROM loan__Loan_Account__c
                                              WHERE ID in :loanIds
                                             ]
                                            );
        initNullsToZeroes();

    }

    private void initNullsToZeroes() {
        for (loan__Loan_Account__c l : loanIdMap.values()) {
            if (l.loan__Total_Due_Charges__c == null) {
                l.loan__Total_Due_Charges__c = 0;
            }
        }
    }

    // The update handler is designed to only update the loan if the charge went from
    // waived to not waived, or from not waived to waived.
    public void beforeUpdateHandler() {
        
        for (loan__Charge__c charge : charges) {
            loan__Loan_Account__c relatedLoan = loanIdMap.get(charge.loan__Loan_Account__c);
            loan__Fee__c  fee = fees.get(charge.loan__Fee__c);

            if(relatedLoan == null) {
                continue;
            }
            /* Simran - Commented the following code because the charge waiver has been moved
               to Charge Waive/Unwaive action class */
            /* UPDATE: Simran commented the code above but that made the charge waiving functionality
               non-scaleable and work only for the one charge. So the following has been uncommented but not invoked from the
               Charge Waive-Unwaive controller
            */
            if (!skipTrigger) {
                //if charges are waived, we wold uncapitalize it, if charges are unwaived, we would capitalize it
               if (charge.loan__Waive__c && !oldMap.get(charge.Id).loan__Waive__c && updateLoans) {
                    // this means the charge was waived
                    Decimal amount = charge.loan__Principal_Due__c + charge.loan__Interest_Due__c + charge.loan__Calculated_Interest3__c;
                    if(fee.loan__Is_Fee_Capitalized__c) {
                        //AHR: TODO - waiver logic for capitalizatipn
                        ChargeUtil.updateLoanUnCapitalizeCharge(charge,relatedLoan, amount,charge.loan__Date__c);
                    }
                    else {
                       ChargeUtil.updateLoanRemoveCharge(relatedLoan, amount);
                    }
                    
                    charge.loan__Waived_Principal__c = (charge.loan__Waived_Principal__c == null) ? 0 : charge.loan__Waived_Principal__c;
                    charge.loan__Waived_Interest__c = (charge.loan__Waived_Interest__c == null) ? 0 : charge.loan__Waived_Interest__c;
                    
                    //[Utk]-If Waived Principal/Interest is not set. Set charge`s principal/interest due as waived values.
                    charge.loan__Waived_Principal__c = (charge.loan__Waived_Principal__c == 0) ? charge.loan__Principal_Due__c : charge.loan__Waived_Principal__c;
                    charge.loan__Waived_Interest__c  = (charge.loan__Waived_Interest__c  == 0) ? charge.loan__Interest_Due__c  : charge.loan__Waived_Interest__c;
                    
                    //[Snehal]:Defect D-0043 - Propel
                    charge.loan__Principal_Due__c = 0;
                    charge.loan__Interest_Due__c = 0;
                    charge.loan__Calculated_Interest3__c = 0;
                    charge.loan__Last_Accrual_Date__c = null;
                    continue;
                }
                if (!charge.loan__Waive__c && oldMap.get(charge.Id).loan__Waive__c && updateLoans) {
                    // this means the charge was un-waived
                    //[Snehal]:Defect D-0043 - Propel - TODO
                    //What happens to Principal Due and Interest Due fields when you un-waive a charge
                    charge.loan__Principal_Due__c = charge.loan__Original_Amount__c;
                    if (charge.loan__Interest_Bearing__c) {
                        charge.loan__Last_Accrual_Date__c = charge.loan__Date__c;
                    }

                    Decimal amount = charge.loan__Principal_Due__c + charge.loan__Interest_Due__c + charge.loan__Calculated_Interest3__c;
                    if(fee.loan__Is_Fee_Capitalized__c) {
                        //AHR: TODO - waiver logic for capitalizatipn
                        //ChargeUtil.updateLoanCapitalizeCharge(relatedLoan, amount);
                    }
                    else {
                       ChargeUtil.updateLoanRemoveCharge(relatedLoan, amount);
                   }
                    continue;
                }
            }

            if (charge.loan__Original_Amount__c == null) {
                if (charge.loan__Fee__c != null) {
                    charge.loan__Original_Amount__c = loan.FeeUtil.computeFee(
                                        fees.get(charge.loan__Fee__c), loanIdMap.get(charge.loan__Loan_Account__c));
                } else {
                    charge.loan__Original_Amount__c = 0.0;
                }
            }
            if (updateLoans) {
                if(fee.loan__Is_Fee_Capitalized__c) {
                    //AHR: TODO - updated charges need to be revisited wrt capitalization
                    //ChargeUtil.updateLoanUnCapitalizeCharge(relatedLoan, oldMap.get(charge.Id).Total_Due_Amount__c);
                    //ChargeUtil.updateLoanCapitalizeCharge(relatedLoan, charge.Total_Due_Amount__c);
                }
                else {
                    ChargeUtil.updateLoanRemoveCharge(relatedLoan, oldMap.get(charge.Id).loan__Total_Due_Amount__c);
                    ChargeUtil.updateLoanAddCharge(relatedLoan, charge.loan__Total_Due_Amount__c);
                }
                relatedLoan.loan__Fees_Paid__c -= oldMap.get(charge.Id).loan__Paid_Amount__c;
                relatedLoan.loan__Fees_Paid__c += charge.loan__Paid_Amount__c;
            }
        }
        if (updateLoans) {
            update loanIdMap.values();
        }
       
    }

    /**
     * @description : It is possible that multiple charges of same fee-type are attempted to be
     *                applied on same loan. These charges should also be checked that they are not breaking
     *                min-recurring-days constrain for that fee-type
     */
    private List<String> findSameChargeAppliedWithinMinimumDays() {

        List<String> errorMsgList = new List<String>();
        Map<Id, Map<Id, List<ChargeComparableByDate>>> loanIdCharges;

        loanIdCharges = new Map<Id, Map<Id, List<ChargeComparableByDate>>>();

        for(loan__Charge__c charge : charges) {
            Map<Id, List<ChargeComparableByDate>> feeIdChargesMap;
            feeIdChargesMap = loanIdCharges.get(charge.loan__Loan_Account__c);
            if(feeIdChargesMap == null) {
                feeIdChargesMap = new Map<Id, List<ChargeComparableByDate>>();
                loanIdCharges.put(charge.loan__Loan_Account__c, feeIdChargesMap);
            }

            List<ChargeComparableByDate> chargeList = feeIdChargesMap.get(charge.loan__Fee__c);
            if(chargeList == null) {
                chargeList = new List<ChargeComparableByDate>();
                feeIdChargesMap.put(charge.loan__Fee__c, chargeList);
            }
            chargeList.add(new ChargeComparableByDate(charge));
        }

        for(Id loanId : loanIds ) {
            loan__Loan_Account__c loanAcc = loanIdMap.get(loanId);
            Map<Id, List<ChargeComparableByDate>> feeIdChargesMap = loanIdCharges.get(loanId);

            for(Id feeId : feeIdChargesMap.keySet()) {

                loan__Fee__c fee = fees.get(feeId);
                if(fee.loan__Recurrent_Charge_Minimum_Days__c == null) {
                    fee.loan__Recurrent_Charge_Minimum_Days__c = 0;
                }

                List<ChargeComparableByDate> chargeList = feeIdChargesMap.get(feeId);
                chargeList.sort();

                ChargeComparableByDate oCharge = chargeList.get(0);
                ChargeComparableByDate nCharge;

                for(Integer index = 1; index < chargeList.size();  index++) {
                    nCharge = chargeList.get(index);

                    Integer diff = nCharge.daysBetween(oCharge);

                    if(fee.loan__Recurrent_Charge_Minimum_Days__c > diff) {
                        /* Label.CL017419 = Cannot apply charge. For Loan account {0},
                           multiple charges of type {1} being applied within minimum recurring days.
                           First date = {2}, second date = {3}.
                           Minimum recurring days for charge type {1} are {4}.
                        */

                        List<String> params = new List<String> {loanAcc.Name,
                                                                fee.Name,
                                                                nCharge.chargeDate().format(),
                                                                ocharge.chargeDate().format(),
                                                                String.valueof(fee.loan__Recurrent_Charge_Minimum_Days__c)
                                                               };
                        
                        
                        break;  //no need to go further
                    }
                    oCharge = nCharge;
                }
            }
        }

        return errorMsgList;
    }

    public void beforeInsertHandler() {
        

        List<String> errorMsgList = findSameChargeAppliedWithinMinimumDays();
        if(errorMsgList.size() > 0) {
            //String separator = '\n';
            //String combineErrorMessage = String.join(errorMsgList, separator);
            //throw new ValidationException(combineErrorMessage);
            return;
        }

        Boolean chargeError = false;
        for (loan__Charge__c charge : charges) {
            loan__Loan_Account__c relatedLoan = loanIdMap.get(charge.loan__Loan_Account__c);
            if(relatedLoan.loan__Loan_Block_Codes__r.size() > 0) {
                /* Label.CL017417 = Cannot apply charges. Loan account {0} has active block
                                    codes preventing charges on this account.*/
                
                
                //throw new ValidationException(errorMsg);
                continue;
            }

            //Apply the charge only if #days past after last charge of same type
            loan__Fee__c  fee = fees.get(charge.loan__Fee__c);
            if(fee.loan__Recurrent_Charge_Minimum_Days__c == null) {
                fee.loan__Recurrent_Charge_Minimum_Days__c = 0;
            }
            List<loan__Charge__c> oldCharges = relatedLoan.loan__Charges__r;
            loan__Charge__c existingCharge = ChargeUtil.findSameChargeAppliedWithinMinimumDays(oldCharges, fee, charge.loan__Date__c);
            if(existingCharge != null) {
                /* Label.CL017418 = Cannot apply charge.
                    Loan account {0} has unwaived charge of type {1} applied on {2}.
                    The same charge can be applied after gap of {3} days
                */
                
                //throw new ValidationException(errorMsg);
                continue;
            }

            if (charge.loan__Original_Amount__c == null) {
                if (charge.loan__Fee__c != null) {
                    charge.loan__Original_Amount__c = loan.FeeUtil.computeFee(
                                        fees.get(charge.loan__Fee__c), loanIdMap.get(charge.loan__Loan_Account__c));
                } else {
                    charge.loan__Original_Amount__c = 0.0;
                }
            }
            charge.loan__Principal_Due__c = charge.loan__Original_Amount__c;
            charge.loan__Interest_Due__c = 0.0;
            charge.loan__Interest_Rate__c = relatedLoan.loan__Interest_Rate__c;
            // update balances on charge
            charge.loan__Balance__c = relatedLoan.loan__Loan_Balance__c;
            charge.loan__Payoff_Balance__c = relatedLoan.loan__Pay_Off_Amount_As_Of_Today__c + charge.loan__Original_Amount__c;


            if (!charge.loan__Waive__c && updateLoans) { // update loan only if charge is not waived!
                if(fee.loan__Is_Fee_Capitalized__c) {
                    System.debug('capitalizing charge for loan = ' + relatedLoan.Name + ', amount = ' + charge.loan__Original_Amount__c);
                    ChargeUtil.updateLoanCapitalizeCharge(relatedLoan, charge.loan__Original_Amount__c, charge.loan__Date__c);
                    charge.loan__Capitalization_Date__c = charge.loan__Date__c;
                    charge.loan__Is_Charge_Capitalized__c = true;
                }
                else {
                    ChargeUtil.updateLoanAddCharge(relatedLoan, charge.loan__Original_Amount__c);
                }
            }
          charge.loan__Balance__c = relatedLoan.loan__Loan_Balance__c;
        }
        if (updateLoans && chargeError == false) {
            update loanIdMap.values();
        }
        
    }

    public class ChargeComparableByDate implements Comparable {
        private loan__Charge__c chargeObj;

        public ChargeComparableByDate(loan__Charge__c charge) {
            this.chargeObj = charge;
        }

        public Date chargeDate() {
            return chargeObj.loan__Date__c;
        }

        public Integer daysBetween(ChargeComparableByDate charge2) {
            Date firstDate = chargeDate();
            Date secondDate = charge2.chargeDate();
            return secondDate.daysBetween(firstDate);
        }

        public integer compareTo(Object compareTo) {
            ChargeComparableByDate chargeCompareTo = (ChargeComparableByDate)compareTo;

            Integer retVal = 0;
            if(this.charge().loan__Date__c > chargeCompareTo.charge().loan__Date__c) {
                retVal = 1;
            }
            else if (this.charge().loan__Date__c < chargeCompareTo.charge().loan__Date__c) {
                retVal = -1;
            }
            return retVal;
        }

        public loan__Charge__c charge() {
            return chargeObj;
        }
    }
}