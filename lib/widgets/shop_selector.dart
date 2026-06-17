import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '/models/shopware/attributes/dewa_shop.dart';
import '/models/shopware/data.dart';
import '/repositories/deliveryware_repository.dart';
import '/repositories/settings_repo.dart';

class ShopSelector extends StatelessWidget {
  static final SettingsRepository _settings = GetIt.I<SettingsRepository>();

  final Function(Data<DewaShop>) onSelected;

  const ShopSelector({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data<DewaShop>>>(
      future: GetIt.I<DeliverywareRepository>().getShops(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.data ?? []).length == 1) {
          onSelected(snapshot.data!.first);
        }
        return Column(
          children: [
            for (Data<DewaShop> data in (snapshot.data ?? []))
              ListTile(
                title: Text(
                  data.attributes!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () => onSelected(data),
                selected: _settings.shopId == data.id,
              ),
          ],
        );
      },
    );
  }
}
