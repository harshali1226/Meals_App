import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import 'package:intl/intl.dart';


void main() => {
  // WidgetsFlutterBinding.ensureInitialized(),
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]),
  runApp(MyApp())
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              ),
            button: TextStyle(
              color: Colors.white,
            )
              )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  // String textInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 final List<Transaction> _usertransactions = [
  //   Transaction(
  //   id: '123',
  //   title: 'New Shoes',
  //   amount: 199,
  //   date: DateTime.now(),
  // ),

  // Transaction(
  //   id: '321',
  //   title: 'Groceries',
  //   amount: 159,
  //   date: DateTime.now(),
  // )
  ];

  bool _showChart = false;

  void _addNewTransaction(String txtitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txtitle,
      amount: txAmount,
      date: chosenDate
      );

      setState(() {
        _usertransactions.add(newTx);
      });
  }

 
  List<Transaction> get _recentTransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
          ),
          );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    }
    );
  }

void _deleteTransaction(String id) {
  setState(() {
     _usertransactions.removeWhere((tx) {
     return tx.id == id;
   });
  });
}


  @override
 Widget build(BuildContext context) {
   final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
   final appBar = AppBar(
       title: Text('Personal Expenses'),
       actions: <Widget>[
         IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context)
         )
       ],
     );
     final txListWidget = Container(
       height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top ) * 0.7 ,
            child: TransactionList(_usertransactions, _deleteTransaction)
     );
   return Scaffold(
     appBar: appBar,
     body: SingleChildScrollView( 
      child: Column(
      // mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: <Widget>[
        if (isLandscape) Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Text('Show Chart'),
             Switch(value: _showChart, onChanged: (val) {
               setState(() {
                 _showChart = val;
               });
             })
           ],
         ),
         if (!isLandscape) Container(
            height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top ) * 0.3 ,
            child: Chart(_recentTransactions)
            ),
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart ?
          Container(
            height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top ) * 0.7 ,
            child: Chart(_recentTransactions)
            ) 
            : txListWidget 
          
       ]
        
   )
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
   floatingActionButton: FloatingActionButton(
     child: Icon(Icons.add),
     onPressed: () => _startAddNewTransaction(context)
     ),
   );
 }
}

