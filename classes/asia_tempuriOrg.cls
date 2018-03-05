//Generated by wsdl2apex

public class asia_tempuriOrg {
    public class UnlockUserResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class AddUserResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetUser_element {
        public String username;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username'};
    }
    public class DeleteRoleResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetRolesForUser_element {
        public String userName;
        private String[] userName_type_info = new String[]{'userName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'userName'};
    }
    public class AddUser_element {
        public asia_schemasDatacontractOrg200407Pepperm.PepperUserModel user_x;
        private String[] user_x_type_info = new String[]{'user','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'user_x'};
    }
    public class ChangePasswordResponse_element {
        public Boolean ChangePasswordResult;
        private String[] ChangePasswordResult_type_info = new String[]{'ChangePasswordResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'ChangePasswordResult'};
    }
    public class UnlockUser_element {
        public String username;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username'};
    }
    public class DeleteRole_element {
        public String roleName;
        private String[] roleName_type_info = new String[]{'roleName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'roleName'};
    }
    public class AddRole_element {
        public String roleName;
        private String[] roleName_type_info = new String[]{'roleName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'roleName'};
    }
    public class ResetPassword_element {
        public String username;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username'};
    }
    public class ResetPasswordResponse_element {
        public String ResetPasswordResult;
        private String[] ResetPasswordResult_type_info = new String[]{'ResetPasswordResult','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'ResetPasswordResult'};
    }
    public class DeleteUser_element {
        public String username;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username'};
    }
    public class GetUsers_element {
        public Integer pageIndex;
        public Integer pageSize;
        private String[] pageIndex_type_info = new String[]{'pageIndex','http://tempuri.org/',null,'0','1','false'};
        private String[] pageSize_type_info = new String[]{'pageSize','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'pageIndex','pageSize'};
    }
    public class GetUsersResponse_element {
        public asia_schemasDatacontractOrg200407Pepperm.ArrayOfPepperUserModel GetUsersResult;
        public Integer totalUsersToReturn;
        private String[] GetUsersResult_type_info = new String[]{'GetUsersResult','http://tempuri.org/',null,'0','1','true'};
        private String[] totalUsersToReturn_type_info = new String[]{'totalUsersToReturn','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetUsersResult','totalUsersToReturn'};
    }
    public class RemoveUserFromRoleResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class IsUserLockedOut_element {
        public String username;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username'};
    }
    public class GetRolesForUserResponse_element {
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetRolesForUserResult;
        private String[] GetRolesForUserResult_type_info = new String[]{'GetRolesForUserResult','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetRolesForUserResult'};
    }
    public class AddRoleResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class UpdateUserResponse_element {
        public Boolean UpdateUserResult;
        private String[] UpdateUserResult_type_info = new String[]{'UpdateUserResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'UpdateUserResult'};
    }
    public class GetUsersInRoleResponse_element {
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetUsersInRoleResult;
        private String[] GetUsersInRoleResult_type_info = new String[]{'GetUsersInRoleResult','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetUsersInRoleResult'};
    }
    public class AddUserToRoleResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class AddUserToRole_element {
        public String userName;
        public String roleName;
        private String[] userName_type_info = new String[]{'userName','http://tempuri.org/',null,'0','1','true'};
        private String[] roleName_type_info = new String[]{'roleName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'userName','roleName'};
    }
    public class GetAllRolesResponse_element {
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetAllRolesResult;
        private String[] GetAllRolesResult_type_info = new String[]{'GetAllRolesResult','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetAllRolesResult'};
    }
    public class ChangePassword_element {
        public String username;
        public String oldPassword;
        public String newPassword;
        private String[] username_type_info = new String[]{'username','http://tempuri.org/',null,'0','1','true'};
        private String[] oldPassword_type_info = new String[]{'oldPassword','http://tempuri.org/',null,'0','1','true'};
        private String[] newPassword_type_info = new String[]{'newPassword','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'username','oldPassword','newPassword'};
    }
    public class IsUserLockedOutResponse_element {
        public Boolean IsUserLockedOutResult;
        private String[] IsUserLockedOutResult_type_info = new String[]{'IsUserLockedOutResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'IsUserLockedOutResult'};
    }
    public class DeleteUserResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetAllRoles_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetUserResponse_element {
        public asia_schemasDatacontractOrg200407Pepperm.PepperUserModel GetUserResult;
        private String[] GetUserResult_type_info = new String[]{'GetUserResult','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'GetUserResult'};
    }
    public class GetUsersInRole_element {
        public String roleName;
        private String[] roleName_type_info = new String[]{'roleName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'roleName'};
    }
    public class RemoveUserFromRole_element {
        public String userName;
        public String roleName;
        private String[] userName_type_info = new String[]{'userName','http://tempuri.org/',null,'0','1','true'};
        private String[] roleName_type_info = new String[]{'roleName','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'userName','roleName'};
    }
    public class UpdateUser_element {
        public asia_schemasDatacontractOrg200407Pepperm.PepperUserModel user_x;
        private String[] user_x_type_info = new String[]{'user','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'user_x'};
    }
    public class BasicHttpBinding_IAccountService {
        public String endpoint_x = 'https://stage-member1.australiasoutheast.cloudapp.azure.com/Services/AccountService.svc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays', 'asia_schemasMicrosoftCom200310Serializat', 'http://tempuri.org/', 'asia_tempuriOrg', 'http://schemas.microsoft.com/2003/10/Serialization/', 'asia_schemasMicrosoftCom200310Serializat', 'http://schemas.datacontract.org/2004/07/PepperMembership.Models.DataObjects', 'asia_schemasDatacontractOrg200407Pepperm'};
        public void RemoveUserFromRole(String userName,String roleName) {
            asia_tempuriOrg.RemoveUserFromRole_element request_x = new asia_tempuriOrg.RemoveUserFromRole_element();
            request_x.userName = userName;
            request_x.roleName = roleName;
            asia_tempuriOrg.RemoveUserFromRoleResponse_element response_x;
            Map<String, asia_tempuriOrg.RemoveUserFromRoleResponse_element> response_map_x = new Map<String, asia_tempuriOrg.RemoveUserFromRoleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/RemoveUserFromRole',
              'http://tempuri.org/',
              'RemoveUserFromRole',
              'http://tempuri.org/',
              'RemoveUserFromRoleResponse',
              'asia_tempuriOrg.RemoveUserFromRoleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public void UnlockUser(String username) {
            asia_tempuriOrg.UnlockUser_element request_x = new asia_tempuriOrg.UnlockUser_element();
            request_x.username = username;
            asia_tempuriOrg.UnlockUserResponse_element response_x;
            Map<String, asia_tempuriOrg.UnlockUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.UnlockUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/UnlockUser',
              'http://tempuri.org/',
              'UnlockUser',
              'http://tempuri.org/',
              'UnlockUserResponse',
              'asia_tempuriOrg.UnlockUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetRolesForUser(String userName) {
            asia_tempuriOrg.GetRolesForUser_element request_x = new asia_tempuriOrg.GetRolesForUser_element();
            request_x.userName = userName;
            asia_tempuriOrg.GetRolesForUserResponse_element response_x;
            Map<String, asia_tempuriOrg.GetRolesForUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.GetRolesForUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetRolesForUser',
              'http://tempuri.org/',
              'GetRolesForUser',
              'http://tempuri.org/',
              'GetRolesForUserResponse',
              'asia_tempuriOrg.GetRolesForUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetRolesForUserResult;
        }
        public void AddRole(String roleName) {
            asia_tempuriOrg.AddRole_element request_x = new asia_tempuriOrg.AddRole_element();
            request_x.roleName = roleName;
            asia_tempuriOrg.AddRoleResponse_element response_x;
            Map<String, asia_tempuriOrg.AddRoleResponse_element> response_map_x = new Map<String, asia_tempuriOrg.AddRoleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddRole',
              'http://tempuri.org/',
              'AddRole',
              'http://tempuri.org/',
              'AddRoleResponse',
              'asia_tempuriOrg.AddRoleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetUsersInRole(String roleName) {
            asia_tempuriOrg.GetUsersInRole_element request_x = new asia_tempuriOrg.GetUsersInRole_element();
            request_x.roleName = roleName;
            asia_tempuriOrg.GetUsersInRoleResponse_element response_x;
            Map<String, asia_tempuriOrg.GetUsersInRoleResponse_element> response_map_x = new Map<String, asia_tempuriOrg.GetUsersInRoleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUsersInRole',
              'http://tempuri.org/',
              'GetUsersInRole',
              'http://tempuri.org/',
              'GetUsersInRoleResponse',
              'asia_tempuriOrg.GetUsersInRoleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetUsersInRoleResult;
        }
        public Boolean UpdateUser(asia_schemasDatacontractOrg200407Pepperm.PepperUserModel user_x) {
            asia_tempuriOrg.UpdateUser_element request_x = new asia_tempuriOrg.UpdateUser_element();
            request_x.user_x = user_x;
            asia_tempuriOrg.UpdateUserResponse_element response_x;
            Map<String, asia_tempuriOrg.UpdateUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.UpdateUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/UpdateUser',
              'http://tempuri.org/',
              'UpdateUser',
              'http://tempuri.org/',
              'UpdateUserResponse',
              'asia_tempuriOrg.UpdateUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.UpdateUserResult;
        }
        public asia_schemasDatacontractOrg200407Pepperm.PepperUserModel GetUser(String username) {
            asia_tempuriOrg.GetUser_element request_x = new asia_tempuriOrg.GetUser_element();
            request_x.username = username;
            asia_tempuriOrg.GetUserResponse_element response_x;
            Map<String, asia_tempuriOrg.GetUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.GetUserResponse_element>();
            response_map_x.put('response_x', response_x);
            system.debug('Request:   '+request_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUser',
              'http://tempuri.org/',
              'GetUser',
              'http://tempuri.org/',
              'GetUserResponse',
              'asia_tempuriOrg.GetUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetUserResult;
        }
        public void DeleteRole(String roleName) {
            asia_tempuriOrg.DeleteRole_element request_x = new asia_tempuriOrg.DeleteRole_element();
            request_x.roleName = roleName;
            asia_tempuriOrg.DeleteRoleResponse_element response_x;
            Map<String, asia_tempuriOrg.DeleteRoleResponse_element> response_map_x = new Map<String, asia_tempuriOrg.DeleteRoleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/DeleteRole',
              'http://tempuri.org/',
              'DeleteRole',
              'http://tempuri.org/',
              'DeleteRoleResponse',
              'asia_tempuriOrg.DeleteRoleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public String ResetPassword(String username) {
            asia_tempuriOrg.ResetPassword_element request_x = new asia_tempuriOrg.ResetPassword_element();
            request_x.username = username;
            asia_tempuriOrg.ResetPasswordResponse_element response_x;
            Map<String, asia_tempuriOrg.ResetPasswordResponse_element> response_map_x = new Map<String, asia_tempuriOrg.ResetPasswordResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/ResetPassword',
              'http://tempuri.org/',
              'ResetPassword',
              'http://tempuri.org/',
              'ResetPasswordResponse',
              'asia_tempuriOrg.ResetPasswordResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ResetPasswordResult;
        }
        public Boolean ChangePassword(String username,String oldPassword,String newPassword) {
            asia_tempuriOrg.ChangePassword_element request_x = new asia_tempuriOrg.ChangePassword_element();
            request_x.username = username;
            request_x.oldPassword = oldPassword;
            request_x.newPassword = newPassword;
            asia_tempuriOrg.ChangePasswordResponse_element response_x;
            Map<String, asia_tempuriOrg.ChangePasswordResponse_element> response_map_x = new Map<String, asia_tempuriOrg.ChangePasswordResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/ChangePassword',
              'http://tempuri.org/',
              'ChangePassword',
              'http://tempuri.org/',
              'ChangePasswordResponse',
              'asia_tempuriOrg.ChangePasswordResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ChangePasswordResult;
        }
        public asia_schemasMicrosoftCom200310Serializat.ArrayOfstring GetAllRoles() {
            asia_tempuriOrg.GetAllRoles_element request_x = new asia_tempuriOrg.GetAllRoles_element();
            asia_tempuriOrg.GetAllRolesResponse_element response_x;
            Map<String, asia_tempuriOrg.GetAllRolesResponse_element> response_map_x = new Map<String, asia_tempuriOrg.GetAllRolesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetAllRoles',
              'http://tempuri.org/',
              'GetAllRoles',
              'http://tempuri.org/',
              'GetAllRolesResponse',
              'asia_tempuriOrg.GetAllRolesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetAllRolesResult;
        }
        public void AddUserToRole(String userName,String roleName) {
            asia_tempuriOrg.AddUserToRole_element request_x = new asia_tempuriOrg.AddUserToRole_element();
            request_x.userName = userName;
            request_x.roleName = roleName;
            asia_tempuriOrg.AddUserToRoleResponse_element response_x;
            Map<String, asia_tempuriOrg.AddUserToRoleResponse_element> response_map_x = new Map<String, asia_tempuriOrg.AddUserToRoleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddUserToRole',
              'http://tempuri.org/',
              'AddUserToRole',
              'http://tempuri.org/',
              'AddUserToRoleResponse',
              'asia_tempuriOrg.AddUserToRoleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public void DeleteUser(String username) {
            asia_tempuriOrg.DeleteUser_element request_x = new asia_tempuriOrg.DeleteUser_element();
            request_x.username = username;
            asia_tempuriOrg.DeleteUserResponse_element response_x;
            Map<String, asia_tempuriOrg.DeleteUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.DeleteUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/DeleteUser',
              'http://tempuri.org/',
              'DeleteUser',
              'http://tempuri.org/',
              'DeleteUserResponse',
              'asia_tempuriOrg.DeleteUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public void AddUser(asia_schemasDatacontractOrg200407Pepperm.PepperUserModel user_x) {
            asia_tempuriOrg.AddUser_element request_x = new asia_tempuriOrg.AddUser_element();
            request_x.user_x = user_x;
            asia_tempuriOrg.AddUserResponse_element response_x;
            Map<String, asia_tempuriOrg.AddUserResponse_element> response_map_x = new Map<String, asia_tempuriOrg.AddUserResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddUser',
              'http://tempuri.org/',
              'AddUser',
              'http://tempuri.org/',
              'AddUserResponse',
              'asia_tempuriOrg.AddUserResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public Boolean IsUserLockedOut(String username) {
            asia_tempuriOrg.IsUserLockedOut_element request_x = new asia_tempuriOrg.IsUserLockedOut_element();
            request_x.username = username;
            asia_tempuriOrg.IsUserLockedOutResponse_element response_x;
            Map<String, asia_tempuriOrg.IsUserLockedOutResponse_element> response_map_x = new Map<String, asia_tempuriOrg.IsUserLockedOutResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/IsUserLockedOut',
              'http://tempuri.org/',
              'IsUserLockedOut',
              'http://tempuri.org/',
              'IsUserLockedOutResponse',
              'asia_tempuriOrg.IsUserLockedOutResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.IsUserLockedOutResult;
        }
        public asia_tempuriOrg.GetUsersResponse_element GetUsers(Integer pageIndex,Integer pageSize) {
            asia_tempuriOrg.GetUsers_element request_x = new asia_tempuriOrg.GetUsers_element();
            request_x.pageIndex = pageIndex;
            request_x.pageSize = pageSize;
            asia_tempuriOrg.GetUsersResponse_element response_x;
            Map<String, asia_tempuriOrg.GetUsersResponse_element> response_map_x = new Map<String, asia_tempuriOrg.GetUsersResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUsers',
              'http://tempuri.org/',
              'GetUsers',
              'http://tempuri.org/',
              'GetUsersResponse',
              'asia_tempuriOrg.GetUsersResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}