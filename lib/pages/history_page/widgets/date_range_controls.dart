import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/util.dart';
import '../bloc/history_bloc.dart';

class DateRangeControls extends StatelessWidget {
  const DateRangeControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state.showRange)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: (state.startDate != null)
                        ? Text(
                            state.startDate!.dateFormat,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          )
                        : Text(
                            'Startdatum',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(' - ',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: (state.endDate != null)
                        ? Text(
                            state.endDate!.dateFormat,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          )
                        : Text(
                            'Enddatum',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                  ),
                ],
              )
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: (state.startDate != null)
                    ? Text(
                        'Bestellungen für den ${state.startDate!.dateFormat}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    : Text(
                        'Datum',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
              ),
            const Spacer(),
            IconButton(
              onPressed: () => state.showRange
                  ? showDateRangePicker(
                      context: context,
                      firstDate: DateTime(0),
                      lastDate: DateTime.now(),
                      currentDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendar,
                    ).then((DateTimeRange? value) => value != null
                      ? BlocProvider.of<OrderHistoryBloc>(context)
                          .onSetDateRange(
                              DateTime(value.start.year, value.start.month,
                                  value.start.day),
                              DateTime(value.end.year, value.end.month,
                                  value.end.day, 23, 59, 59))
                      : null)
                  : showDatePicker(
                          context: context,
                          initialDate: state.startDate ?? DateTime.now(),
                          firstDate: DateTime(0),
                          lastDate: DateTime.now())
                      .then((DateTime? value) => value != null
                          ? BlocProvider.of<OrderHistoryBloc>(context)
                              .onSetDateRange(
                                  DateTime(value.year, value.month, value.day),
                                  DateTime(value.year, value.month, value.day,
                                      23, 59, 59))
                          : null),
              icon: const Icon(Icons.edit_rounded),
            ),
          ],
        );
      },
    );
  }
}
