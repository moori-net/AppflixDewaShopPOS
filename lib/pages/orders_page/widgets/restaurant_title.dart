import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/orders_bloc.dart';

class RestaurantTitle extends StatefulWidget {
  const RestaurantTitle({super.key});

  @override
  State<RestaurantTitle> createState() => _RestaurantTitleState();
}

class _RestaurantTitleState extends State<RestaurantTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (BuildContext context, OrdersState state) {
        if (state.shop != null) {
          return Text(state.shop!.name);
        }
        return const Text('Not connected');
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).onGetShop();
    super.initState();
  }
}
