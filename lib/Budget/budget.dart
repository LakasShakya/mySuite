// import 'package:flutter/material.dart';
//
// class BudgetPage extends StatefulWidget {
//   const BudgetPage({super.key});
//
//   @override
//   State<BudgetPage> createState() => _BudgetPageState();
// }
// //
// class _BudgetPageState extends State<BudgetPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Budget'),
//       ),
//     );
//   }
//
// }
//
//
//-----------------------------------------------------


// import 'package:flutter/material.dart';
//
// class BudgetPage extends StatefulWidget {
//   const BudgetPage({super.key});
//
//   @override
//   State<BudgetPage> createState() => _BudgetPageState();
// }
//
// class _BudgetPageState extends State<BudgetPage> {
//   double totalBudget = 0.0; // Initial budget
//   double totalIncome = 0.0; // Initial income
//   double totalExpense = 0.0; // Initial expense
//
//   void _addIncome(double amount) {
//     setState(() {
//       totalIncome += amount;
//       totalBudget += amount;
//     });
//   }
//
//   void _addExpense(double amount) {
//     setState(() {
//       totalExpense += amount;
//       totalBudget -= amount;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Budget'),
//       ),
//       body: Column(
//         children: [
//           // Budget summary cards
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Total Budget:',
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                   Text(
//                     '$totalBudget',
//                     style: TextStyle(fontSize: 32.0),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Total Income:', style: TextStyle(fontSize: 16.0)),
//                   Text(
//                     '$totalIncome',
//                     style: TextStyle(fontSize: 16.0, color: Colors.green),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Total Expense:', style: TextStyle(fontSize: 16.0)),
//                   Text(
//                     '$totalExpense',
//                     style: TextStyle(fontSize: 16.0, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Add income and expense buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Open dialog or form to enter income amount
//                   _showAddIncomeDialog();
//                 },
//                 child: const Text('Add Income'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open dialog or form to enter expense amount
//                   _showAddExpenseDialog();
//                 },
//                 child: const Text('Add Expense'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showAddIncomeDialog() {
//     // Implement a dialog or form to capture the income amount
//     // Update total income and budget based on user input
//   }
//
//   void _showAddExpenseDialog() {
//     // Implement a dialog or form to capture the expense amount
//     // Update total expense and budget based on user input
//   }
// }


import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  void _addIncome(double amount) {
    setState(() {
      totalIncome += amount;
      totalBudget += amount;
    });
  }

  void _addExpense(double amount) {
    setState(() {
      totalExpense += amount;
      totalBudget -= amount;
    });
  }

  Future<void> _showAddAmountDialog(String title, Function(double) onAmountEntered) async {
    final amountController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter amount',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final enteredAmount = double.parse(amountController.text);
              onAmountEntered(enteredAmount);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Column(
        children: [
          // Budget summary cards
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Total Budget:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    '$totalBudget',
                    style: TextStyle(fontSize: 32.0),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Income:', style: TextStyle(fontSize: 16.0)),
                  Text(
                    '$totalIncome',
                    style: TextStyle(fontSize: 16.0, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Expense:', style: TextStyle(fontSize: 16.0)),
                  Text(
                    '$totalExpense',
                    style: TextStyle(fontSize: 16.0, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),

          // Add income and expense buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddAmountDialog('Add Income', _addIncome);
                },
                child: const Text('Add Income'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddAmountDialog('Add Expense', _addExpense);
                },
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
