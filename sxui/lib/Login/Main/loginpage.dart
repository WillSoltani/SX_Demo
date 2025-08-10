import 'package:flutter/material.dart';
import 'package:sxui/ServerCommunicator/SXServerLogin.dart';
import 'package:sxui/dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isOnLeft = true; // Track if the rectangle is on the left or right side
  String userType = 'client'; // Track the selected user type
  String ipAddress = ''; // Variable to store IP address
  String port = ''; // Variable to store Port number
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Animated Lavender Blue Rectangle
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            left: isOnLeft ? 0 : size.width * 0.4,
            top: 0,
            bottom: 0,
            child: Container(
              width: size.width * 0.6,
              color: Color(0xFFE6E6FA), // Lavender blue color
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: isOnLeft ? _buildSignInContent() : _buildSignUpContent(),
            ),
          ),
          // Right Side Content (Background) with Sign Up Button and "Hello, Friend!"
          if (isOnLeft)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: size.width * 0.4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, Friend!',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Enter your personal details and start your journey with us.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardPage()), // ✅ Use const
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 120, vertical: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )


                  ],
                ),
              ),
            ),
          // Left Side Content (Background) with Sign In Button and "Welcome Back!"
          if (!isOnLeft)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: size.width * 0.4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'To keep connected with us please login with your personal info.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isOnLeft = !isOnLeft;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white, width: 2),
                        padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Method to build the content inside the rectangle for sign-in
  Widget _buildSignInContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo at the top
          Container(
            height: 100,
            child: Image.asset('assets/sx.png', fit: BoxFit.contain),
          ),
          SizedBox(height: 20),
          Text(
            'Sign in to Silicone X',
            style: TextStyle(
              fontSize: 56,
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          // IP Address TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.network_check, size: 24),
                hintText: 'Enter IP Address',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  ipAddress = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          // Port TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.usb, size: 24),
                hintText: 'Enter Port',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  port = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          // Username TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, size: 24),
                hintText: 'Username',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
          ),

          // Password TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, size: 24),
                hintText: 'Password',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          // Forgot Password Button
          Center(
            child: TextButton(
              onPressed: () {},
              child:
                  Text('Forgot your password?', style: TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(height: 30),
          // Sign In Button
          ElevatedButton(
            onPressed: () {
              // Handle sign in with the collected IP address and port
              print('IP Address: $ipAddress, Port: $port');
              print('Username is: $username, Password: $password ');
              var authorizer = SXServerAuthorization();
              authorizer.setIPAddressAndPort(ipAddress,int.parse(port)).then((valid){
                print("Is valid? $valid");
                if(valid){
                  authorizer.signin(username, password).then((value) {
                    print("Value is: $value");
                    if(value != "success"){
                      //Not Signed in  -Error massege displayed
                    }
                    else{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                    }
                  },);
                }
              });
              // Navigator.push(
              //   context,
              //   //MaterialPageRoute(builder: (context) => DashboardPage()), // Route to the DashboardPage
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 120, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the content inside the rectangle for sign-up
  Widget _buildSignUpContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo at the top
          Container(
            height: 100,
            child: Image.asset('assets/sx.png', fit: BoxFit.contain),
          ),
          SizedBox(height: 20),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 56,
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          // Username TextField
          // IP Address TextField for Sign Up
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.network_check, size: 24),
                hintText: 'Enter IP Address',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  ipAddress = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),

// Port TextField for Sign Up
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.usb, size: 24),
                hintText: 'Enter Port',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  port = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, size: 24),
                hintText: 'Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Email TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, size: 24),
                hintText: 'Email',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Password TextField
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, size: 24),
                hintText: 'Password',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          // Sign Up Button
// Sign Up Button
          ElevatedButton(
            onPressed: () {
              // Print the values to the terminal
              print('IP Address (Sign Up): $ipAddress');
              print('Port (Sign Up): $port');
              print('Username (Sign Up): $username');
              print('Password (Sign Up): $password');
              var authorizer = SXServerAuthorization();
              authorizer.setIPAddressAndPort(ipAddress, int.parse(port)).then((valid){
                print("Is valid $valid");
                if (valid){
                  authorizer.signup(username, password, password).then((result){
                    print("Result is: $result");
                    if(result == 'success'){
                      //Open up login menu - Sign up successful
                    }
                    else{
                      //Show up error message values entered not correct
                    }

                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 120, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }
}
