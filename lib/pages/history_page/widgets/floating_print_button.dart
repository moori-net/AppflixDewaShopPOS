import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/util.dart';
import '../bloc/history_bloc.dart';

class FloatingPrintButton extends StatelessWidget {
  const FloatingPrintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) => state.error != null || state.orders.isEmpty
          ? const SizedBox(width: 0.0, height: 0.0)
          : FloatingActionButton(
              onPressed: state.startDate != null && state.endDate != null
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Wirklich drucken?'),
                          content: state.startDate!.isSameDay(state.endDate!)
                              ? Text(
                                  'Bestellungen vom ${state.startDate!.dateFormat} drucken?')
                              : Text(
                                  'Bestellungen vom ${state.startDate!.dateFormat} bis ${state.endDate!.dateFormat} drucken?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Abbrechen'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Drucken'),
                            ),
                          ],
                        ),
                      ).then((value) {
                        if (value ?? false) {
                          BlocProvider.of<OrderHistoryBloc>(context)
                              .onPrintCurrentHistory();
                        }
                      });
                    }
                  : null,
              child: state.isPrinting
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.print_rounded),
            ),
    );
  }
}
