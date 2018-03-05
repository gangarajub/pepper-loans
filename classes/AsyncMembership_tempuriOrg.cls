//Generated by wsdl2apex

public class AsyncMembership_tempuriOrg {
    public class RemoveUserFromRoleResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class UnlockUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class GetRolesForUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Membership_schemasMicrosoftComArrays.ArrayOfstring getValue() {
            Membership_tempuriOrg.GetRolesForUserResponse_element response = (Membership_tempuriOrg.GetRolesForUserResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetRolesForUserResult;
        }
    }
    public class AddRoleResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class GetUsersInRoleResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Membership_schemasMicrosoftComArrays.ArrayOfstring getValue() {
            Membership_tempuriOrg.GetUsersInRoleResponse_element response = (Membership_tempuriOrg.GetUsersInRoleResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetUsersInRoleResult;
        }
    }
    public class UpdateUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Boolean getValue() {
            Membership_tempuriOrg.UpdateUserResponse_element response = (Membership_tempuriOrg.UpdateUserResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.UpdateUserResult;
        }
    }
    public class GetUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Membership_schemasDatacontractOrg.PepperUserModel getValue() {
            Membership_tempuriOrg.GetUserResponse_element response = (Membership_tempuriOrg.GetUserResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetUserResult;
        }
    }
    public class DeleteRoleResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class ResetPasswordResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            Membership_tempuriOrg.ResetPasswordResponse_element response = (Membership_tempuriOrg.ResetPasswordResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.ResetPasswordResult;
        }
    }
    public class ChangePasswordResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Boolean getValue() {
            Membership_tempuriOrg.ChangePasswordResponse_element response = (Membership_tempuriOrg.ChangePasswordResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.ChangePasswordResult;
        }
    }
    public class GetAllRolesResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Membership_schemasMicrosoftComArrays.ArrayOfstring getValue() {
            Membership_tempuriOrg.GetAllRolesResponse_element response = (Membership_tempuriOrg.GetAllRolesResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetAllRolesResult;
        }
    }
    public class AddUserToRoleResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class DeleteUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class AddUserResponse_elementFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class IsUserLockedOutResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Boolean getValue() {
            Membership_tempuriOrg.IsUserLockedOutResponse_element response = (Membership_tempuriOrg.IsUserLockedOutResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.IsUserLockedOutResult;
        }
    }
    public class GetUsersResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Membership_tempuriOrg.GetUsersResponse_element getValue() {
            Membership_tempuriOrg.GetUsersResponse_element response = (Membership_tempuriOrg.GetUsersResponse_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    public class AsyncBasicHttpBinding_IAccountService {
        public String endpoint_x = 'https://stage-member1.pepper.azure.haylix.net/Services/AccountService.svc';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays', 'Membership_schemasMicrosoftComArrays', 'http://tempuri.org/', 'Membership_tempuriOrg', 'http://schemas.microsoft.com/2003/10/Serialization/', 'Membership_schemasMicrosoftCom', 'http://schemas.datacontract.org/2004/07/PepperMembership.Models.DataObjects', 'Membership_schemasDatacontractOrg'};
        public AsyncMembership_tempuriOrg.RemoveUserFromRoleResponse_elementFuture beginRemoveUserFromRole(System.Continuation continuation,String userName,String roleName) {
            Membership_tempuriOrg.RemoveUserFromRole_element request_x = new Membership_tempuriOrg.RemoveUserFromRole_element();
            request_x.userName = userName;
            request_x.roleName = roleName;
            return (AsyncMembership_tempuriOrg.RemoveUserFromRoleResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.RemoveUserFromRoleResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/RemoveUserFromRole',
              'http://tempuri.org/',
              'RemoveUserFromRole',
              'http://tempuri.org/',
              'RemoveUserFromRoleResponse',
              'Membership_tempuriOrg.RemoveUserFromRoleResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.UnlockUserResponse_elementFuture beginUnlockUser(System.Continuation continuation,String username) {
            Membership_tempuriOrg.UnlockUser_element request_x = new Membership_tempuriOrg.UnlockUser_element();
            request_x.username = username;
            return (AsyncMembership_tempuriOrg.UnlockUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.UnlockUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/UnlockUser',
              'http://tempuri.org/',
              'UnlockUser',
              'http://tempuri.org/',
              'UnlockUserResponse',
              'Membership_tempuriOrg.UnlockUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.GetRolesForUserResponse_elementFuture beginGetRolesForUser(System.Continuation continuation,String userName) {
            Membership_tempuriOrg.GetRolesForUser_element request_x = new Membership_tempuriOrg.GetRolesForUser_element();
            request_x.userName = userName;
            return (AsyncMembership_tempuriOrg.GetRolesForUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.GetRolesForUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetRolesForUser',
              'http://tempuri.org/',
              'GetRolesForUser',
              'http://tempuri.org/',
              'GetRolesForUserResponse',
              'Membership_tempuriOrg.GetRolesForUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.AddRoleResponse_elementFuture beginAddRole(System.Continuation continuation,String roleName) {
            Membership_tempuriOrg.AddRole_element request_x = new Membership_tempuriOrg.AddRole_element();
            request_x.roleName = roleName;
            return (AsyncMembership_tempuriOrg.AddRoleResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.AddRoleResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddRole',
              'http://tempuri.org/',
              'AddRole',
              'http://tempuri.org/',
              'AddRoleResponse',
              'Membership_tempuriOrg.AddRoleResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.GetUsersInRoleResponse_elementFuture beginGetUsersInRole(System.Continuation continuation,String roleName) {
            Membership_tempuriOrg.GetUsersInRole_element request_x = new Membership_tempuriOrg.GetUsersInRole_element();
            request_x.roleName = roleName;
            return (AsyncMembership_tempuriOrg.GetUsersInRoleResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.GetUsersInRoleResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUsersInRole',
              'http://tempuri.org/',
              'GetUsersInRole',
              'http://tempuri.org/',
              'GetUsersInRoleResponse',
              'Membership_tempuriOrg.GetUsersInRoleResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.UpdateUserResponse_elementFuture beginUpdateUser(System.Continuation continuation,Membership_schemasDatacontractOrg.PepperUserModel user_x) {
            Membership_tempuriOrg.UpdateUser_element request_x = new Membership_tempuriOrg.UpdateUser_element();
            request_x.user_x = user_x;
            return (AsyncMembership_tempuriOrg.UpdateUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.UpdateUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/UpdateUser',
              'http://tempuri.org/',
              'UpdateUser',
              'http://tempuri.org/',
              'UpdateUserResponse',
              'Membership_tempuriOrg.UpdateUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.GetUserResponse_elementFuture beginGetUser(System.Continuation continuation,String username) {
            Membership_tempuriOrg.GetUser_element request_x = new Membership_tempuriOrg.GetUser_element();
            request_x.username = username;
            return (AsyncMembership_tempuriOrg.GetUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.GetUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUser',
              'http://tempuri.org/',
              'GetUser',
              'http://tempuri.org/',
              'GetUserResponse',
              'Membership_tempuriOrg.GetUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.DeleteRoleResponse_elementFuture beginDeleteRole(System.Continuation continuation,String roleName) {
            Membership_tempuriOrg.DeleteRole_element request_x = new Membership_tempuriOrg.DeleteRole_element();
            request_x.roleName = roleName;
            return (AsyncMembership_tempuriOrg.DeleteRoleResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.DeleteRoleResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/DeleteRole',
              'http://tempuri.org/',
              'DeleteRole',
              'http://tempuri.org/',
              'DeleteRoleResponse',
              'Membership_tempuriOrg.DeleteRoleResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.ResetPasswordResponse_elementFuture beginResetPassword(System.Continuation continuation,String username) {
            Membership_tempuriOrg.ResetPassword_element request_x = new Membership_tempuriOrg.ResetPassword_element();
            request_x.username = username;
            return (AsyncMembership_tempuriOrg.ResetPasswordResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.ResetPasswordResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/ResetPassword',
              'http://tempuri.org/',
              'ResetPassword',
              'http://tempuri.org/',
              'ResetPasswordResponse',
              'Membership_tempuriOrg.ResetPasswordResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.ChangePasswordResponse_elementFuture beginChangePassword(System.Continuation continuation,String username,String oldPassword,String newPassword) {
            Membership_tempuriOrg.ChangePassword_element request_x = new Membership_tempuriOrg.ChangePassword_element();
            request_x.username = username;
            request_x.oldPassword = oldPassword;
            request_x.newPassword = newPassword;
            return (AsyncMembership_tempuriOrg.ChangePasswordResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.ChangePasswordResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/ChangePassword',
              'http://tempuri.org/',
              'ChangePassword',
              'http://tempuri.org/',
              'ChangePasswordResponse',
              'Membership_tempuriOrg.ChangePasswordResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.GetAllRolesResponse_elementFuture beginGetAllRoles(System.Continuation continuation) {
            Membership_tempuriOrg.GetAllRoles_element request_x = new Membership_tempuriOrg.GetAllRoles_element();
            return (AsyncMembership_tempuriOrg.GetAllRolesResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.GetAllRolesResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetAllRoles',
              'http://tempuri.org/',
              'GetAllRoles',
              'http://tempuri.org/',
              'GetAllRolesResponse',
              'Membership_tempuriOrg.GetAllRolesResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.AddUserToRoleResponse_elementFuture beginAddUserToRole(System.Continuation continuation,String userName,String roleName) {
            Membership_tempuriOrg.AddUserToRole_element request_x = new Membership_tempuriOrg.AddUserToRole_element();
            request_x.userName = userName;
            request_x.roleName = roleName;
            return (AsyncMembership_tempuriOrg.AddUserToRoleResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.AddUserToRoleResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddUserToRole',
              'http://tempuri.org/',
              'AddUserToRole',
              'http://tempuri.org/',
              'AddUserToRoleResponse',
              'Membership_tempuriOrg.AddUserToRoleResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.DeleteUserResponse_elementFuture beginDeleteUser(System.Continuation continuation,String username) {
            Membership_tempuriOrg.DeleteUser_element request_x = new Membership_tempuriOrg.DeleteUser_element();
            request_x.username = username;
            return (AsyncMembership_tempuriOrg.DeleteUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.DeleteUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/DeleteUser',
              'http://tempuri.org/',
              'DeleteUser',
              'http://tempuri.org/',
              'DeleteUserResponse',
              'Membership_tempuriOrg.DeleteUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.AddUserResponse_elementFuture beginAddUser(System.Continuation continuation,Membership_schemasDatacontractOrg.PepperUserModel user_x) {
            Membership_tempuriOrg.AddUser_element request_x = new Membership_tempuriOrg.AddUser_element();
            request_x.user_x = user_x;
            return (AsyncMembership_tempuriOrg.AddUserResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.AddUserResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/AddUser',
              'http://tempuri.org/',
              'AddUser',
              'http://tempuri.org/',
              'AddUserResponse',
              'Membership_tempuriOrg.AddUserResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.IsUserLockedOutResponse_elementFuture beginIsUserLockedOut(System.Continuation continuation,String username) {
            Membership_tempuriOrg.IsUserLockedOut_element request_x = new Membership_tempuriOrg.IsUserLockedOut_element();
            request_x.username = username;
            return (AsyncMembership_tempuriOrg.IsUserLockedOutResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.IsUserLockedOutResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/IsUserLockedOut',
              'http://tempuri.org/',
              'IsUserLockedOut',
              'http://tempuri.org/',
              'IsUserLockedOutResponse',
              'Membership_tempuriOrg.IsUserLockedOutResponse_element'}
            );
        }
        public AsyncMembership_tempuriOrg.GetUsersResponse_elementFuture beginGetUsers(System.Continuation continuation,Integer pageIndex,Integer pageSize) {
            Membership_tempuriOrg.GetUsers_element request_x = new Membership_tempuriOrg.GetUsers_element();
            request_x.pageIndex = pageIndex;
            request_x.pageSize = pageSize;
            return (AsyncMembership_tempuriOrg.GetUsersResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMembership_tempuriOrg.GetUsersResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/IAccountService/GetUsers',
              'http://tempuri.org/',
              'GetUsers',
              'http://tempuri.org/',
              'GetUsersResponse',
              'Membership_tempuriOrg.GetUsersResponse_element'}
            );
        }
    }
}