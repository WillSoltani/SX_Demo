import 'package:flutter/material.dart';

class BillInvoicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill and Invoices'),
      ),
      body: Center(
        child: Text(
          'Bill and Invoices Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

