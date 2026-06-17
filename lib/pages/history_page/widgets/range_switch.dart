import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/history_bloc.dart';

enum DropdownActions { range }

class RangeSwitch extends StatelessWidget {
  const RangeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) => PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
              value: DropdownActions.range,
              child: state.showRange
                  ? const Text('Tagesbilanz')
                  : const Text('Datumsbereich'))
        ],
        onSelected: (value) {
          if (value == DropdownActions.range) {
            BlocProvider.of<OrderHistoryBloc>(context).onSwitchRangeMode();
          }
        },
      ),
    );
  }
}
