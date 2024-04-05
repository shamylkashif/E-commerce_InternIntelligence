class MyDomain {
  static String BASE_URL = "http://192.168.31.177:3000";

  static String createUser = '$BASE_URL/api/user/create_user';

  static getCreateUserAPI() {
    return createUser;
  }

  static String loginUser = '$BASE_URL/api/user/user_login';

  static getLoginUserAPI() {
    return loginUser;
  }
}
