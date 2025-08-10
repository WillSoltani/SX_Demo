import 'package:sxui/ServerCommunicator/SXServerTemplate.dart';

class SXServerAuthorization extends SXServerTemplate {
  /// <summary>
  /// constructor
  /// </summary>
  SXServerAuthorization(): super();

  /// <summary>
  /// A method for performing signin.
  /// </summary>
  /// <param name="username">The provided username</param>
  /// <param name="password">The provided password</param>
  /// <returns>a string indicating either "success" or 
  /// the error message from the server.</returns>
  Future<String> signin(String username, String password) async {
    var resp = await postRequest("/auth/signin", data: {
      "username": username,
      "password": password
    });
    if (null == resp) {
      return "Error: IP and Port are not configured correctly.";
    }

    String message = resp.data["message"].toString();

    if (resp.statusCode! == 200) {
      await storage!.write(key: "token", value: message);
      return "success";
    }

    return message;
    
  }

  /// <summary>
  /// A method for signing out the already
  /// logged in user.
  /// </summary>
  Future<void> signout() async {
    await storage!.delete(key: "token");
  }

  /// <summary>
  /// A method for performing sign up.
  /// </summary>
  /// <param name="username"> The newly added username</param>
  /// <param name="password">The password for the user.</param>
  /// <param name="repeatPassword">The password repeated for confirmation.</param>
  /// <returns> the string "success" if signing up was successful; otherwise
  /// the error message.</returns>
  Future<String> signup(String username, String password, String repeatPassword) async {
    var resp = await postRequest("/auth/signup", data: {
      "username": username,
      "password": password,
      "repeat_password": repeatPassword
    });
    if (null == resp) {
      return "Error: IP and port are not configured correctly.";
    }
    String message = resp.data["message"].toString();

    if (resp.statusCode! != 200) {
      return message;
    }

    return "success";
  }
}