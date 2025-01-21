import 'package:flutter/material.dart';
import '../models/order.dart';

class CartItemComponent extends StatefulWidget {
  final Order order;
  final BorderRadius borderRadius;
  final Color color;
  final Color textColor;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final double width;

  const CartItemComponent({
    super.key,
    required this.order,
    required this.borderRadius,
    required this.width,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
    this.color = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  State<CartItemComponent> createState() => _CartItemComponentState();
}

class _CartItemComponentState extends State<CartItemComponent> {

  // Method for building the item text
  Widget _buildCartItemText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget.order.quantity}KG of ${widget.order.title.split(" ").last}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
            decoration: widget.textColor == Colors.white
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${double.parse(widget.order.price.toStringAsFixed(2))} BGN.",
          style: TextStyle(
            color: widget.textColor,
            fontSize: 14,
            decoration: widget.textColor == Colors.white
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
      ],
    );
  }

  // Method for building action buttons (increase, decrease, delete)
  Widget _buildCartItemActions() {
    return Row(
      children: [
        if (widget.onDecrease != null)
          IconButton(
            onPressed: widget.onDecrease,
            icon: const Icon(Icons.remove, color: Colors.red),
            tooltip: 'Decrease quantity',
          ),
        if (widget.onIncrease != null)
          IconButton(
            onPressed: widget.onIncrease,
            icon: const Icon(Icons.add, color: Colors.green),
            tooltip: 'Increase quantity',
          ),
        if (widget.onDelete != null)
          IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(Icons.delete, color: Colors.black54),
            tooltip: 'Delete item',
          ),
      ],
    );
  }

  // Method for building the cart item container
  Widget _buildCartItemContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(5, 5), // Shadow moved to the right and bottom
          )
        ],
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildCartItemText()),
            _buildCartItemActions(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
      child: Column(
        children: [
          _buildCartItemContainer(),
        ],
      ),
    );
  }
}
