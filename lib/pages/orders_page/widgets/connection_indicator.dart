import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final connectivityResult = snapshot.data as ConnectivityResult;
          if (connectivityResult == ConnectivityResult.none) {
            return Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: const BoxDecoration(color: Colors.red),
              child: Text(
                'Keine Internetverbindung',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          }
        }
        return const SizedBox(width: 0, height: 0);
      },
    );
  }
}
