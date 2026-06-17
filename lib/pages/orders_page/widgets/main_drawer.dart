import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:open_settings/open_settings.dart';

import '/models/shopware/attributes/dewa_shop.dart';
import '/models/shopware/data.dart';
import '/repositories/auth_cubit.dart';
import '/repositories/settings_repo.dart';
import '/widgets/shop_selector.dart';
import '../bloc/orders_bloc.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 56.0,
            child: Center(
              child: ListTile(
                trailing: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 32.0,
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<OrdersBloc, OrdersState>(builder: ((context, state) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    'Lieferung',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    state.deliveryActive ? 'Aktiv' : 'Deaktiviert',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Switch(
                    value: state.deliveryActive,
                    onChanged: (bool value) =>
                        BlocProvider.of<OrdersBloc>(context)
                            .onToggleOpen(deliveryActive: value),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Abholung',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    state.collectActive ? 'Aktiv' : 'Deaktiviert',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Switch(
                    value: state.collectActive,
                    onChanged: (bool value) =>
                        BlocProvider.of<OrdersBloc>(context)
                            .onToggleOpen(collectActive: value),
                  ),
                ),
              ],
            );
          })),
          const Divider(height: 1.0),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            leading: Icon(
              Icons.list_alt_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Bestellungen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => Navigator.of(context).pushNamed('/history'),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            leading: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Einstellungen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => Navigator.of(context).pushNamed('/settings'),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            leading: Icon(
              Icons.print_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Druckereinstellungen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => Navigator.of(context).pushNamed('/printer-settings'),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            onTap: () => showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                children: [
                  ShopSelector(
                    onSelected: (shop) => _onShopSelected(shop),
                  ),
                ],
              ),
            ),
            leading: Icon(
              Icons.restaurant_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Shopauswahl',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (Platform.isAndroid)
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              leading: Icon(
                Icons.wifi_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'WiFi Einstellungen',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => OpenSettings.openWIFISetting(),
            ),
          const Divider(height: 1.0),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            leading: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Ausloggen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => _onLogout(context),
          ),
        ],
      ),
    );
  }

  void _onLogout(BuildContext context) async {
    await BlocProvider.of<AuthCubit>(context).logout();
    if (!mounted) return;
    BlocProvider.of<OrdersBloc>(context).close();
    Phoenix.rebirth(context);
  }

  void _onShopSelected(Data<DewaShop> shop) {
    GetIt.instance.get<SettingsRepository>().shopId = shop.id;
    BlocProvider.of<OrdersBloc>(context)
      ..onGetShop()
      ..onRefresh();
    Navigator.of(context).pop();
  }
}
