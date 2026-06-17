import 'package:flutter/material.dart';

import '/models/order_category.dart';
import '/theme.dart';
import 'text_badge.dart';

class CategoryIndicator extends StatefulWidget {
  final Function(List<OrderCategory>)? onFilterChanged;

  final int numOrders;
  final int numPreparation;
  final int numDelivery;
  final int numTakeaway;

  const CategoryIndicator({
    super.key,
    this.onFilterChanged,
    this.numOrders = 0,
    this.numPreparation = 0,
    this.numDelivery = 0,
    this.numTakeaway = 0,
  });

  @override
  State<CategoryIndicator> createState() => _CategoryIndicatorState();
}

class _CategoryIndicatorState extends State<CategoryIndicator> {
  final List<OrderCategory> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.none,
      elevation: 4.0,
      child: Container(
        clipBehavior: Clip.none,
        height: 42.0,
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextBadge(
              text: 'Bestellungen',
              color: ordersBlue,
              onPressed: () => _onCategorySelected(OrderCategory.order),
              disabled: _selectedCategories.contains(OrderCategory.order),
              badgeContent: widget.numOrders,
            ),
            const SizedBox(width: 8.0),
            TextBadge(
              text: 'Zubereitung',
              color: preparationCoral,
              onPressed: () => _onCategorySelected(OrderCategory.preparation),
              disabled: _selectedCategories.contains(OrderCategory.preparation),
              badgeContent: widget.numPreparation,
            ),
            const SizedBox(width: 8.0),
            TextBadge(
              text: 'Lieferung',
              color: deliveryPurple,
              onPressed: () => _onCategorySelected(OrderCategory.delivery),
              disabled: _selectedCategories.contains(OrderCategory.delivery),
              badgeContent: widget.numDelivery,
            ),
            const SizedBox(width: 8.0),
            TextBadge(
              text: 'Abholung',
              color: takeawayBeige,
              onPressed: () => _onCategorySelected(OrderCategory.takeaway),
              disabled: _selectedCategories.contains(OrderCategory.takeaway),
              badgeContent: widget.numTakeaway,
            ),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(OrderCategory state) {
    setState(() {
      if (_selectedCategories.contains(state)) {
        _selectedCategories.remove(state);
      } else {
        _selectedCategories.add(state);
      }
    });

    widget.onFilterChanged?.call(_selectedCategories);
  }
}
