import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/orders_bloc.dart';
import 'widgets/closed_indicator.dart';
import 'widgets/connection_indicator.dart';
import 'widgets/main_drawer.dart';
import 'widgets/orders_list.dart';
import 'widgets/restaurant_title.dart';
import 'widgets/time_indicator.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersBloc(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.0,
          title: const RestaurantTitle(),
          actions: [
            Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.menu_rounded,
                      color: Colors.white, size: 32.0),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 48.0),
            child: Column(
              children: const [
                ConnectionIndicator(),
                ClosedIndicator(),
                TimeIndicator(),
              ],
            ),
          ),
        ),
        endDrawer: const MainDrawer(),
        body: const OrdersList(),
      ),
    );
  }
}
