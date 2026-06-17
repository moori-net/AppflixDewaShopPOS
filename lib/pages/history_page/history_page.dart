import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/history_bloc.dart';
import 'widgets/date_range_controls.dart';
import 'widgets/floating_print_button.dart';
import 'widgets/order_history_list.dart';
import 'widgets/range_switch.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bestellverlauf'),
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 64.0),
            child: const DateRangeControls(),
          ),
          actions: const [
            RangeSwitch(),
          ],
        ),
        body: const OrderHistoryList(),
        floatingActionButton: const FloatingPrintButton(),
      ),
    );
  }
}
