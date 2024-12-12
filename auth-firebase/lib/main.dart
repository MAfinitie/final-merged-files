import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pay',
        theme: ThemeData(
          colorSchemeSeed: Colors.white,
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 150,
              title: Container(
                padding: EdgeInsets.only(left: 70),
                child: Text("Ahlan",
                    style:
                        TextStyle(fontSize: 70, fontWeight: FontWeight.w900)),
              ),
            ),
            body: Center(
                child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  ButtonTypesGroup(enabled: true),
                  Spacer(),
                ],
              ),
            ))));
  }
}

class ButtonTypesGroup extends StatelessWidget {
  const ButtonTypesGroup({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Image(height: 200, image: AssetImage("assets/images/logo.png")),
          // to login page
          OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Login', style: TextStyle(fontSize: 16))),
          // 'Create account' button
          FilledButton.tonal(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text('Create account', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp())),
          ),
          title: Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 56, bottom: 24, left: 24, right: 24),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                      height: 200,
                      image: AssetImage("assets/images/money-background.jpg")),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Phone',
                      hintText: '01XXXXXXXXX',
                      errorText: _errorText,
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '********',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        String phone = _phoneController.text;
                        String password = _passwordController.text;

                        if (phone.isEmpty || password.isEmpty) {
                          setState(() {
                            _errorText = "Both fields are required";
                          });
                          return;
                        }

                        UserCredential user =
                            await _auth.signInWithEmailAndPassword(
                          email: "$phone@payapp.com",
                          password: password,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } catch (e) {
                        setState(() {
                          _errorText = "Login failed. Check your credentials.";
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPage()),
                      );
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Registration page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  bool _isObscuredRegPassword = true;
  bool _isObscuredConfirmNewPassword = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp())),
          ),
          title: Text('Create account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 56,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'John Doe',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      )),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'National ID',
                      hintText: 'XXXXXXXXXXXXX',
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Phone',
                      hintText: '01XXXXXXXXX',
                      errorText: _errorText,
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: _isObscuredRegPassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredRegPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredRegPassword = !_isObscuredRegPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        String phone = _phoneController.text;
                        String password = _passwordController.text;

                        if (phone.isEmpty || password.isEmpty) {
                          setState(() {
                            _errorText = "Both fields are required";
                          });
                          return;
                        }

                        UserCredential user =
                            await _auth.createUserWithEmailAndPassword(
                          email: "$phone@payapp.com",
                          password: password,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } catch (e) {
                        setState(() {
                          _errorText = "Try again.";
                        });
                      }
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _RegBuildConditionRow(String text, bool RegConditionMet) {
    return Row(
      children: [
        Icon(
          RegConditionMet ? Icons.done : Icons.close,
          color: RegConditionMet ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: RegConditionMet ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}

// Reset pages

// Step 1: Credentials
class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Reset Password'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: RibbonIndicator(activeIndex: 0),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 250),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Phone',
                  hintText: '01XXXXXXXXX',
                  hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                  errorText: _errorText,
                ),
                onChanged: (value) {
                  setState(() {
                    if (!value.startsWith('01')) {
                      _errorText = 'Start with 01';
                    } else if (value.length > 11) {
                      _errorText = 'It must contain 11 digits';
                    } else if (value.length < 11) {
                      _errorText = 'It must contain 11 digits';
                    } else {
                      _errorText = null; // Clear the error
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPageOTP()),
                  );
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Step 2: OTP
class ResetPageOTP extends StatefulWidget {
  const ResetPageOTP({super.key});

  @override
  _ResetPageOTPState createState() => _ResetPageOTPState();
}

class _ResetPageOTPState extends State<ResetPageOTP> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Enter OTP'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: RibbonIndicator(activeIndex: 1),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 250),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context)
                              .nextFocus(); // Move to next field
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPageNewPassword()),
                  );
                },
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Step 3: New Password
class ResetPageNewPassword extends StatefulWidget {
  const ResetPageNewPassword({super.key});

  @override
  _ResetPageNewPasswordState createState() => _ResetPageNewPasswordState();
}

class _ResetPageNewPasswordState extends State<ResetPageNewPassword> {
  bool _isObscuredNewPassword = true;
  bool _isObscuredConfirmNewPassword = true;
  String _passwordChng = '';

  bool get NewHasMinLength => _passwordChng.length >= 8;
  bool get NewHasNumber => _passwordChng.contains(RegExp(r'[0-9]'));
  bool get NewHasSymbol => _passwordChng.contains(RegExp(r'[!@#\$&*~]'));
  bool get NewHasUppercase => _passwordChng.contains(RegExp(r'[A-Z]'));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('New Password'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: RibbonIndicator(activeIndex: 2),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),
              // New Password
              TextField(
                obscureText: _isObscuredNewPassword,
                onChanged: (value) {
                  setState(() {
                    _passwordChng = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscuredNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscuredNewPassword = !_isObscuredNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Validation conditions
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChangeBuildConditionRow("At least 8 characters", NewHasMinLength),
                  _ChangeBuildConditionRow("1 number", NewHasNumber),
                  _ChangeBuildConditionRow("1 symbol", NewHasSymbol),
                  _ChangeBuildConditionRow("1 uppercase", NewHasUppercase),
                ],
              ),
              SizedBox(height: 22),
              // Confirm Password
              TextField(
                obscureText: _isObscuredConfirmNewPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscuredConfirmNewPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscuredConfirmNewPassword =
                            !_isObscuredConfirmNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Conditions
  Widget _ChangeBuildConditionRow(String text, bool conditionMet) {
    return Row(
      children: [
        Icon(
          conditionMet ? Icons.done : Icons.close,
          color: conditionMet ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: conditionMet ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}

class RibbonIndicator extends StatelessWidget {
  final int activeIndex;

  RibbonIndicator({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.0,
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: index == activeIndex ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedTappedIndex = 0;

  static List<Widget> ScreenPages = <Widget>[
    PayScreen(),
    MoreScreen(),
  ];

  void onTappedItem(int index) {
    setState(() {
      selectedTappedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You're in, enjoy!"),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: Center(
          child: ScreenPages.elementAt(selectedTappedIndex),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTappedIndex,
          onDestinationSelected: onTappedItem,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Pay',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

class PayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Pay Screen Placeholder")),
      backgroundColor: Colors.white,
    );
  }
}

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
    );
  }
}
