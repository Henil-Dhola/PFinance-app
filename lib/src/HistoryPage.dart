import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final double amount;
  final String date;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
  });
}

class TransactionListScreen extends StatelessWidget {
  // Sample transaction data
  final List<Transaction> transactions = [
    Transaction(title: 'Shopping', amount: -45.99, date: '2024-04-01'),
    Transaction(title: 'Salary', amount: 1500.00, date: '2024-03-28'),
    Transaction(title: 'Dinner', amount: -30.50, date: '2024-03-25'),
    // Add more transactions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Expenses History",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  // Remove bottom border
                  border: Border(
                    bottom: BorderSide.none,
                  ),
                ),
               // margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    right: 10,
                    left: 10
                  ),
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            transaction.amount < 0 ? Icons.money_off : Icons.attach_money,
                            color: transaction.amount < 0 ? Colors.red : Colors.green,
                          ),
                          title: Text(transaction.title),
                          subtitle: Text(
                            '${transaction.date} • \$${transaction.amount.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
