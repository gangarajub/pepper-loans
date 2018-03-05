public class CLConstants {
    // Repayment Frequency
    public static String REPAYMENT_FREQ_WEEKLY = 'Weekly';
    public static String REPAYMENT_FREQ_SEMI_MONTHLY = 'Semi-Monthly';
    public static String REPAYMENT_FREQ_SEMI_MONTHLY_PAY_DAY = 'Semi-Monthly-PD';
    public static String REPAYMENT_FREQ_BI_WEEKLY = 'Bi-Weekly';
    public static String REPAYMENT_FREQ_MONTHLY = 'Monthly';
    public static String REPAYMENT_FREQ_DAILY = 'Daily';
    public static String REPAYMENT_FREQ_BI_MONTHLY = 'Bi-Monthly';
    public static String REPAYMENT_FREQ_QUARTERLY = 'Quarterly';
    public static String REPAYMENT_FREQ_SINGLEPMT = 'Single-Payment';
    public static String REPAYMENT_FREQ_ANNUAL = 'Annual';
    public static String REPAYMENT_FREQ_SEMI_ANNUAL = 'Semi-Annual';

    // Time counting methods
    public static String TIME_COUNTING_MONTH_AND_DAYS = 'Month And Days';
    public static String TIME_COUNTING_ACTUAL_DAYS = 'Actual Days';
    public static String TIME_COUNTING_ACTUAL_DAYS_366 = 'Actual Days (366)';
    public static String TIME_COUNTING_APR = 'APR';

    // Acrual base method code
    public static String ACCRUAL_METHOD_CD_360_360 = '360/360';
    public static String ACCRUAL_METHOD_CD_360_365 = '360/365';
    public static String ACCRUAL_METHOD_CD_360_366 = '360/366';
    public static String ACCRUAL_METHOD_CD_365_360 = '365/360';
    public static String ACCRUAL_METHOD_CD_365_365 = '365/365';
    public static String ACCRUAL_METHOD_CD_365_366 = '365/366';
    public static String ACCRUAL_METHOD_CD_366_360 = '366/360';
    public static String ACCRUAL_METHOD_CD_366_364 = '366/364';
    public static String ACCRUAL_METHOD_CD_366_365 = '366/365';
    public static String ACCRUAL_METHOD_CD_366_366 = '366/366';

    // Interest Calculation Method. Renamed as 'Billing Method'
    public static String REPAYMENT_INT_CALC_METHOD_FLAT = 'Flat';
    public static String REPAYMENT_INT_CALC_METHOD_DEC_BAL = 'Declining Balance';
    public static String REPAYMENT_INT_CALC_METHOD_INTEREST_ONLY = 'Interest Only';
    public static String REPAYMENT_INT_CALC_METHOD_FLEXIBLE_REPAYMENT = 'Flexible Repayment';

    // Loan interest only payment behaviors
    public static String INT_ONLY_BEHAVIOUR_ACTUAL = 'Actual';
    public static String INT_ONLY_BEHAVIOUR_FIRST_PERIOD_INTEREST = 'FirstPeriodInterest';
    public static String INT_ONLY_BEHAVIOUR_ONE_CYCLE_INTEREST = 'OneCycleInterest';
    public static String INT_ONLY_BEHAVIOUR_UNIFORM_SPREAD = 'UniformInterestSpread';
    public static String INT_ONLY_BEHAVIOUR_FIXED_PAYMENT = 'FixedPayment';
}