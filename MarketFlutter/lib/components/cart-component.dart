import 'package:flutter/material.dart';
import '../models/order.dart';

class CartComponent extends StatefulWidget {
  final Order order;
  final BorderRadius borderRadius;
  final Color color;
  final Color textColor;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const CartComponent({
    super.key,
    required this.order,
    required this.borderRadius,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
    this.color = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  State<CartComponent> createState() => _CartComponentState();
}

class _CartComponentState extends State<CartComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.order.quantity}KG of ${widget.order.title.split(" ")[widget.order.title.split(" ").length - 1]}",
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
                    ),
                  ),
                  Row(
                    children: [
                      widget.onDecrease !=  null ? IconButton(
                        onPressed: widget.onDecrease,
                        icon: const Icon(Icons.remove, color: Colors.red),
                        tooltip: 'Decrease quantity',
                      ) : const SizedBox(),
                      widget.onIncrease !=  null ? IconButton(
                        onPressed: widget.onIncrease,
                        icon: const Icon(Icons.add, color: Colors.green),
                        tooltip: 'Increase quantity',
                      ) : const SizedBox(),
                      widget.onDelete !=  null ? IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete, color: Colors.black54),
                        tooltip: 'Delete item',
                      ) : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
