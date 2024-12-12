import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

class AdditionLog {
  final double amount;
  final String date;
  final String time;
  final String? qrCodeId;

  AdditionLog({
    required this.amount,
    required this.date,
    required this.time,
    this.qrCodeId,
  });
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
      home: MyHomePage(),
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
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      FirstPayStep(payTotal: PayTotal),
                ),
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
          child: Text('$PayTotal',
              style: TextStyle(fontSize: 90, fontWeight: FontWeight.w900)),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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

// First Payment Step
class FirstPayStep extends StatefulWidget {
  final double payTotal;

  const FirstPayStep({required this.payTotal, super.key});

  @override
  State<FirstPayStep> createState() => _FirstPayStepState();
}

class _FirstPayStepState extends State<FirstPayStep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.barcode_reader),
        title: Text('Checkout'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            String qrCodeId = barcode.rawValue ?? "";
            final now = DateTime.now();
            context.read<BalanceProvider>().addLog(
                  AdditionLog(
                    amount: widget.payTotal,
                    date: DateFormat('yyyy-MM-dd').format(now),
                    time: DateFormat('HH:mm:ss').format(now),
                    qrCodeId: qrCodeId,
                  ),
                );

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.qr_code_2),
                      SizedBox(width: 8),
                      Text(qrCodeId),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.done_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Transaction Accepted',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

// More Screen
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
                Tooltip(
                  message:
                      'Your balance is ${context.watch<BalanceProvider>().balance.toStringAsFixed(2)} ${context.watch<BalanceProvider>().balance <= 1 ? 'Pound' : 'Pounds'}', // "Total" Pound/s
                  child: Card(
                      child: _CardProperties(
                          cardName:
                              '${context.watch<BalanceProvider>().balance.toStringAsFixed(2)}')),
                ),
              ],
            ),
          ),
          DividerLine(),
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
                  builder: (context) => MoreScreenHistory(
                    logs: context.read<BalanceProvider>().additionLogs,
                  ),
                ),
              );
            },
          ),

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


class MoreScreenHistory extends StatelessWidget {
  final List<AdditionLog> logs;

  const MoreScreenHistory({required this.logs, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.history),
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            title: Text('${log.amount} EGP'),
            subtitle: Text('Date: ${log.date}, Time: ${log.time}'),
          );
        },
      ),
    );
  }
}

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
          SizedBox(
            height: 50,
          ),
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
