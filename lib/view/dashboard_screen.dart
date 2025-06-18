import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/report_tab.dart';
import 'tabs/profile_tab.dart';
import 'widgets/transaction_form.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openTransactionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const TransactionForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeTab(),
      const ReportTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BaBa Wallet'),
        centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary, 
          foregroundColor: Theme.of(context).colorScheme.onPrimary, 
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _openTransactionForm,
                backgroundColor: Theme.of(context).colorScheme.primary, 
                foregroundColor: Theme.of(context).colorScheme.onPrimary, 
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
