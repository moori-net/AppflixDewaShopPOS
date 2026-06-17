import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/orders_bloc.dart';

class ClosedIndicator extends StatelessWidget {
  const ClosedIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, OrdersState state) {
        if (state.active) return const SizedBox();

        return StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) =>
              snapshot.data == ConnectivityResult.none
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      decoration: const BoxDecoration(color: Colors.red),
                      width: MediaQuery.of(context).size.width,
                      height: 48.0,
                      child: Text(
                        'Restaurant geschlossen',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
        );
      },
    );
  }
}
