/*To activate TalkBack voice please visit https://cutt.us/AndroidTalkBack */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'dart:async';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:pay/firebase_options.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_firestore/firebase_firestore.dart';
//import 'package:firebase_firestore/cloud_firestore.dart';
//import 'package:local_auth/local_auth.dart';

/*
main() {
  runApp(MyApp());
}

main() function with firebase initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
*/

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BalanceProvider(),
      child: MyApp(),
    ),
  );
}

class BalanceProvider extends ChangeNotifier {
  double CurrentBalance = 0.0;
  List<AdditionLog> _additionLogs = [];

  double get balance => CurrentBalance;

  List<AdditionLog> get additionLogs => _additionLogs;

  void updateBalance(double newBalance) {
    CurrentBalance = newBalance;
    notifyListeners();
  }

  void addLog(AdditionLog log) {
    _additionLogs.add(log);
    notifyListeners();
  }
}

// Welcome Screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pay', // Name of app
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
                child: Text("Ahlan", style: TextStyle(fontSize: 70, fontWeight: FontWeight.w900)),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Login', style: TextStyle(fontSize: 16))),

          // 'Create account' button
          FilledButton.tonal(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
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
  String? _errorText;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp())),
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
                  // Page header image
                  Image(height: 200, image: AssetImage("assets/images/money-background.jpg")),

                  SizedBox(height: 20),
                  // Phone number
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
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '********',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // login button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
                    child: Text('Forgot Password?', style: TextStyle(color: Colors.blue, decoration: TextDecoration.none)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
  String? _errorText;

  bool _isObscuredRegPassword = true;
  bool _isObscuredConfirmNewPassword = true;
  String _passwordReg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
          ),
          title: Text('Create account')
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 56,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          // EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Name
                  TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'John Doe',
                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      )),

                  SizedBox(height: 20),
                  // National ID
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'National ID',
                    hintText: 'XXXXXXXXXXXXX',
                    hintStyle:TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                    counterText: '', // Hides the counter text
                    ),
          ),

                  SizedBox(height: 20),
                  // Phone number
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
                          _errorText = 'It must  must contain 11 digits';
                        } else if (value.length < 11) {
                          _errorText = 'It must  must contain 11 digits';
                        } else {
                          _errorText = null; // Clear the error
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Password
                  TextField(
                    obscureText: _isObscuredRegPassword,
                    onChanged: (value) {
                      setState(() {
                        _passwordReg = value;
                      });
                    },
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
                  // signup button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
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

  // Conditions
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Reset Password'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: RibbonIndicator(activeIndex: 0),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 125),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.developer_mode, color: Colors.grey),
                  Text('Under development', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
              SizedBox(height: 75),
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
                        _errorText = 'It must  must contain 11 digits';
                      } else if (value.length < 11) {
                        _errorText = 'It must  must contain 11 digits';
                      } else {
                        _errorText = null; // Clear the error
                      }
                    }
                    );
                  },
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPageOTP()));
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

//Step 2: OTP
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Enter OTP'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: RibbonIndicator(activeIndex: 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 125),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.developer_mode, color: Colors.grey),
                  Text('Under development', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
              SizedBox(height: 75),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPageNewPassword()));
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
        body: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),
              ///SizedBox(height: 125),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.developer_mode, color: Colors.grey),
                  Text('Under development', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
              SizedBox(height: 75),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
      )
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

//Home Page
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

  // status for tapping event
  void onTappedItem(int index) {
    setState(() {
      selectedTappedIndex = index;
    });
  }

  void _updateBalance(double balance, double newBalance) {
    setState(() {
      balance = newBalance; // Update balance
    });
  }

  // Bottom buttons section
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
            // Pay button
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Pay',
            ),

            // More button
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

// Payment Screen
class PayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: MoneyButtons(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MoneyButtons extends StatefulWidget {
  @override
  MoneyButtonsState createState() => MoneyButtonsState();
}

class MoneyButtonsState extends State<MoneyButtons> {
  // PayTotal
  double PayTotal = 0;

  // Balance
  double balance = 0;

  // when tapping a value button, Payment Total value increases
  void updateValPayTotal(double value) {
    setState(() {
      PayTotal += value;
    });
  }

  // when tapping "Reset" button, Payment total value resets into 0
  void resetValPayTotal() {
    setState(() {
      PayTotal = 0;
    });
  }

  void showPayAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Do you want to pay $PayTotal EGP?'),
        actions: [
          // Dismiss
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),

          // proceed to payment action
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => FirstPayStep()),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Display Payment Total value
        SizedBox(height: 50),
        Tooltip(
          message: PayTotal <= 1 ? 'Pound' : 'Pounds', // "Total" Pound/s
          child: Text('$PayTotal', style: TextStyle(fontSize: 90, fontWeight: FontWeight.w900)),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 0.25 EGP button
            SizedBox(
              width: 85,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(0.25),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: 'Quarter Pound coin',
                  child: Column(
                    children: [
                      Tooltip(message: '25 Piasters'),
                      // Coin image
                      Image.asset('assets/images/money/coins/25pt.jpg'),
                    ],
                  ),
                ),
              ),
            ),

            // 0.50 EGP button
            SizedBox(
              width: 100,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(0.50),
                child: Semantics(
                  label: 'Half Pound coin',
                  child: Column(
                    children: [
                      Tooltip(message: '50 Piasters'),
                      // Coin image
                      Image.asset('assets/images/money/coins/50pt.jpg'),
                    ],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
              ),
            ),

            // 1 EGP button
            SizedBox(
              width: 100,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(1),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '1 Pound coin',
                  child: Column(
                    children: [
                      Tooltip(message: '1 Pound'),
                      // Coin image
                      Image.asset('assets/images/money/coins/1p.jpg'),
                    ],
                  ),
                ), //
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 5 EGP button
            SizedBox(
              width: 115,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(5),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '5 Pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '5 Pounds'),
                      Image.asset('assets/images/money/banknotes/5p.jpg',
                          fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
            ),

            // 10 EGP button
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(10),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '10 Pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '10 Pounds'),
                      Image.asset('assets/images/money/banknotes/10p.jpg'),
                    ],
                  ),
                ),
              ),
            ),

            // 20 EGP button
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(20),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '20 Pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '20 Pounds'),
                      Image.asset('assets/images/money/banknotes/20p.jpg'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 50 EGP button
            SizedBox(
              width: 115,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                onPressed: () => updateValPayTotal(50),
                child: Semantics(
                  label: '50 pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '50 Pounds'),
                      Image.asset('assets/images/money/banknotes/50p.jpg'),
                    ],
                  ),
                ), //
              ),
            ),

            // 100 EGP button
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(100),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '100 pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '100 Pounds'),
                      Image.asset('assets/images/money/banknotes/100p.jpg'),
                    ],
                  ),
                ),
              ),
            ),

            // 200 EGP button
            SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: () => updateValPayTotal(200),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                child: Semantics(
                  label: '200 pounds banknote',
                  child: Column(
                    children: [
                      Tooltip(message: '200 Pounds'),
                      Image.asset('assets/images/money/banknotes/200p.jpg'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Row(
          // Reset button
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100, width: 2.5),
            SizedBox(
              child: OutlinedButton.icon(
                onPressed: resetValPayTotal,
                label: Text('Reset'),
                icon: Icon(Icons.restart_alt),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
              ),
            ),
            SizedBox(width: 220),
            // Pay button
            SizedBox(
              child: OutlinedButton.icon(
                onPressed:
                    PayTotal == 0 ? null : () => showPayAlertDialog(context),
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
                label: Text('Go', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// More Screen
// Pay > More
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
          Center(
            child: Row(
              children: <Widget>[
                SizedBox(width: 20),
                Icon(Icons.account_balance, size: 50),
                SizedBox(width: 20),
                Tooltip(message:'Your balance is ${context.watch<BalanceProvider>().balance.toStringAsFixed(2)} ${context.watch<BalanceProvider>().balance <= 1 ? 'Pound' : 'Pounds'}', // "Total" Pound/s
                child: Card(child: _CardProperties(cardName:'${context.watch<BalanceProvider>().balance.toStringAsFixed(2)}')),
                ),
              ],
            ),
          ),
          DividerLine(),
          
          // Personal Information button
          /*ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Personal Information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoreScreenPrsnlInfo()),
              );
            },
          ),*/
          

          ListTile(
            leading: Icon(Icons.payments),
            title: Text('Charge'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => PaymentMethodsListSheet(),
              );
            },
          ),

          ListTile(
            title: Text('History'),
            leading: Icon(Icons.sync_alt),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>MoreScreenHistory(
                    logs: context.read<BalanceProvider>().additionLogs,
                  ), //MoreScreenHistory(logs: additionLogs),
                ),
              );
            },
          ),

          // Settings button
          /*ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoreScreenSettings()),
              );
            },
          ),*/

          // Logout button
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),

            // making log out by navigating to MyApp() main home page
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('Are you sure?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardProperties extends StatelessWidget {
  const _CardProperties({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 100,
      child: Center(
          child: Text(cardName, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800))),
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Divider(),
          ],
        ),
      ),
    );
  }
}

// Charge Screen    More > Account > Balance > Charge

class PaymentMethodsListSheet extends StatefulWidget {

  @override
  PaymentMethodsListSheetState createState() => PaymentMethodsListSheetState();
}

class PaymentMethodsListSheetState extends State<PaymentMethodsListSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Tooltip(
            message: 'You can pay using MasterCard, Visa or Meeza',
            child: ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Card'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedirectPage()),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('QR Code'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RedirectPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.contactless_outlined),
            title: Text('NFC'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RedirectPage()),
              );
            },
          ),
          Tooltip(
            message:'You can use your network wallet. Vodafone Cash, Orange Cash, Etisalat Cash, and WE Pay are accepted.',
            child: ListTile(
              leading: Icon(Icons.cell_tower),
              title: Text('Operator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedirectPage()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'This is for development purposes',
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text('Add'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoreScreenCharge(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

/*##############################################################################*/
//--------------------------------PAYMENT PROCESS Screens-----------------------

//--------------------------------Screen 1--------------------------------------

class FirstPayStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.barcode_reader),
        title: Text('Checkout'),
      ),
      body: Center(),
    );
  }
}


class MoreScreenPrsnlInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey, // Set the background color
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Name',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Text('John Doe', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Phone',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Text('+20 1XXXXXXXXX', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.badge_outlined, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'National ID',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Text('XXXXXXXXXXXXX', style: TextStyle(fontSize: 16)),
                SizedBox(height: 30),
              ],
            ),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Under development'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                label: Text('Edit', style: TextStyle(color: Colors.black)),
                icon: Icon(Icons.edit, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedirectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.close, size: 80, color: Colors.red.shade400),
            SizedBox(height: 20),
            Text('Under Development'),
          ],
        ),
      ),
    );
  }
}

class MoreScreenHistory extends StatelessWidget {
  final List<AdditionLog> logs;

  MoreScreenHistory({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: logs.isNotEmpty
          ? ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text(
                    '${log.amount.toStringAsFixed(2)} EGP',
                    style: TextStyle(color: Colors.green),
                  ),
                  subtitle: Text('${log.date} ${log.time}'),
                );
              },
            )
          : Center(child: Text('No History')),
    );
  }
}

class AdditionLog {
  final double amount;
  final String date;
  final String time;

  AdditionLog({required this.amount, required this.date, required this.time});
}

// Charge Process Screen     More > Account > Balance > Charge > Add
class MoreScreenCharge extends StatefulWidget {

  @override
  _MoreScreenChargeState createState() => _MoreScreenChargeState();
}

class _MoreScreenChargeState extends State<MoreScreenCharge> {
  double addedVal = 0.0;

  void updateAddedStoredBalance(double amount) {
    setState(() {
      addedVal = amount;
      context
      .read<BalanceProvider>()
      .updateBalance(context.read<BalanceProvider>().balance + amount);
    });

    final now = DateTime.now();
    context.read<BalanceProvider>().addLog(
          AdditionLog(
            amount: amount,
            date: DateFormat('yyyy-MM-dd').format(now),
            time: DateFormat('HH:mm:ss').format(now),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${context.watch<BalanceProvider>().balance.toStringAsFixed(2)} EGP'),
          Text('+${addedVal.toStringAsFixed(2)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 0.25 EGP button
              SizedBox(
                width: 85,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(0.25),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: 'Quarter Pound coin',
                    child: Column(
                      children: [
                        Tooltip(message: '25 Piasters'),
                        // Coin image
                        Image.asset('assets/images/money/coins/25pt.jpg'),
                      ],
                    ),
                  ),
                ),
              ),

              // 0.50 EGP button
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(0.50),
                  child: Semantics(
                    label: 'Half Pound coin',
                    child: Column(
                      children: [
                        Tooltip(message: '50 Piasters'),
                        // Coin image
                        Image.asset('assets/images/money/coins/50pt.jpg'),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                ),
              ),

              // 1 EGP button
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(1),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '1 Pound coin',
                    child: Column(
                      children: [
                        Tooltip(message: '1 Pound'),
                        // Coin image
                        Image.asset('assets/images/money/coins/1p.jpg'),
                      ],
                    ),
                  ), //
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 5 EGP button
              SizedBox(
                width: 115,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(5),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '5 Pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '5 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/5p.jpg',
                            fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ),
              ),

              // 10 EGP button
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(10),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '10 Pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '10 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/10p.jpg'),
                      ],
                    ),
                  ),
                ),
              ),
              // 20 EGP button
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(20),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '20 Pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '20 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/20p.jpg'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 50 EGP button
              SizedBox(
                width: 115,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  onPressed: () => updateAddedStoredBalance(50),
                  child: Semantics(
                    label: '50 pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '50 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/50p.jpg'),
                      ],
                    ),
                  ), //
                ),
              ),

              // 100 EGP button
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(100),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '100 pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '100 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/100p.jpg'),
                      ],
                    ),
                  ),
                ),
              ),

              // 200 EGP button
              SizedBox(
                width: 120,
                child: OutlinedButton(
                  onPressed: () => updateAddedStoredBalance(200),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
                  child: Semantics(
                    label: '200 pounds banknote',
                    child: Column(
                      children: [
                        Tooltip(message: '200 Pounds'),
                        // Banknote image
                        Image.asset('assets/images/money/banknotes/200p.jpg'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.science_outlined, color: Colors.grey),
              Text('Testing Purposes Only', style: TextStyle(color: Colors.grey, fontSize: 18)),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

// Settings Screen     More > Settings
class MoreScreenSettings extends StatelessWidget {
  const MoreScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100),

          // General Settings
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('General'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Under development'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // 'Need Help?' for Support channels
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Need Help?'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 250,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Chat => Text on WhatsApp
                          Tooltip(
                            message: 'WhatsApp',
                            child: Semantics(
                              label: 'WhatsApp',
                              child: OutlinedButton(
                                onPressed: () {
                                  launch('https://wa.me/002012345678901');
                                },
                                child: Icon(Icons.comment),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          // Email => Mail to us
                          Tooltip(
                            message: 'Mail',
                            child: Semantics(
                              label: 'Mail',
                              child: OutlinedButton(
                                onPressed: () {
                                  launch('mailto:example@example.com.eg');
                                },
                                child: Icon(Icons.mail),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          // Phone to Call us
                          Tooltip(
                            message: 'Phone',
                            child: Semantics(
                              label: 'Phone',
                              child: OutlinedButton(
                                onPressed: () {
                                  launch('tel: +2012345678901');
                                },
                                child: Icon(Icons.call),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          // Online Support to Find FAQ and ask community
                          Tooltip(
                            message: 'Support',
                            child: Semantics(
                              label: 'Support',
                              child: OutlinedButton(
                                onPressed: () =>
                                    {launch('https://example.com.eg/support')},
                                child: Icon(Icons.help),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // About
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MoreScreenSettingsAbout()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// About Screen  More > Settings > About
class MoreScreenSettingsAbout extends StatelessWidget {
  const MoreScreenSettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100),

          // Project idea
          ListTile(
            leading: Icon(Icons.emoji_objects),
            title: Text('Idea'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      SizedBox(height: 50),
                      ListTile(
                        title: Text(
                            'This app works as a platform for your payments. With interactive UI, basic functions and rapid usage. You can rely on us to save money and learn children how to spend it wisely.\n'
                            "\nIt's a graduation project presented by a student in Arab Open University creates a model focuses on making payments eaiser for all types and ages to use all over Egypt."),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Project resources
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Resources'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MoreScreenSettingsAboutResources()),
              );
            },
          ),

          // Project credits
          ListTile(
            leading: Icon(Icons.psychology_alt),
            title: Text('Credits'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MoreScreenSettingsAboutCredits()),
              );
            },
          ),

          // Project credits
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MoreScreenSettingsAboutTC()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Resources Screen     More > Settings > About > Resources
class MoreScreenSettingsAboutResources extends StatelessWidget {
  const MoreScreenSettingsAboutResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Android Studio
            GestureDetector(
              onTap: () {
                launch('https://developer.android.com/studio');
              },
              child: Text('developer.android.com', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),

            // Project IDX
            GestureDetector(
              onTap: () {
                launch('https://idx.google.com/');
              },
              child: Text('\nidx.google.com', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),

            // API & Docs
            GestureDetector(
              onTap: () {
                launch('https://api.flutter.dev');
              },
              child: Text('\napi.flutter.dev', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),

            GestureDetector(
              onTap: () {
                launch('https://docs.flutter.dev');
              },
              child: Text('\ndocs.flutter.dev', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),

            // Material3
            GestureDetector(
              onTap: () {
                launch('https://m3.material.io');
              },
              child: Text('\nm3.material.io', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),

            GestureDetector(
              onTap: () {
                launch(
                    'https://flutter.github.io/samples/web/material_3_demo');
              },
              child: Text('\nflutter.github.io', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),

            // Firebase Docs
            GestureDetector(
              onTap: () {
                launch('https://firebase.google.com/docs');
              },
              child: Text('\nfirebase.google.com', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),

            // Icons
            GestureDetector(
              onTap: () {
                launch('https://fonts.google.com/icons');
              },
              child: Text(
                '\nfonts.google.com', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),

            // Images
            // Banknotes source
            GestureDetector(
              onTap: () {
                launch(
                    'https://freepik.com/author/zhuna');
              },
              child: Text('\nBanknotes by Zhuna', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),

            // Coins source
            GestureDetector(
              onTap: () {
                launch(
                    'https://freepik.com/author/dmytrolomonovsky');
              },
              child: Text('\nCoins by Dmytro', style: TextStyle(fontSize: 16,color: Colors.blue, decoration: TextDecoration.none)),
            ),
          ],
        ),
      ),
    );
  }
}

// Credits Screen   More > Settings > Credits
class MoreScreenSettingsAboutCredits extends StatelessWidget {
  const MoreScreenSettingsAboutCredits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 80,
          bottom: 16,
          right: 16,
          left: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 280),
            Text('Developed by Mahmoud Ayman\n©2024', style: TextStyle(fontSize: 16)),
            SizedBox(height: 25),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide.none,
              ),
              onPressed: () {
                launch('https://github.com/MAfinitie');
              },
              child: Icon(Icons.code),
            ),
          ],
        ),
      ),
    );
  }
}

// Terms & Conditions Screen      More > Settings > Terms & Conditions
class MoreScreenSettingsAboutTC extends StatelessWidget {
  const MoreScreenSettingsAboutTC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Text(
                  'By using our services you are accepting current mentioned Terms & Conditions with any future additons can happen without a prior notice.'
                  '\n\nUser must be Egyptian, at least 16 years old, a resident of Arab Republic of Egypt, has a valid National ID, a stable internet connection, and also a method to cover all estimated costs.'
                  '\n\nAll types of data that are transmitted, analyzed, collected or stored are protected according to A.R.E. laws and regulations. Law and Security related parts can collect data by an official permission.'
                  '\n\nSource Code, User Interface navigation techniques are protected by Intellectual Property laws and regulations in A.R.E. and any license can be used in further future.'
                  '\n\nWe are not responsible for any misuse can happen due to code unhandled exception or balance shortage.'
                  '\n\nThis app as a model working for testing purposes and not working as a final application for market usage.'
                  '\n\nLegal cases must be solved through Egyptian courts.',
                  style: TextStyle(fontSize: 18)),
              ]
            ),
          )
        )
    );
  }
}