import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order.dart';
import '../services/offer_type_service.dart';

class OrderItemComponent extends StatefulWidget {
  final Order order;
  final BorderRadius borderRadius;
  final double width;

  const OrderItemComponent({
    super.key,
    required this.order,
    required this.borderRadius,
    required this.width,
  });

  @override
  State<OrderItemComponent> createState() => _OrderItemComponentState();
}

class _OrderItemComponentState extends State<OrderItemComponent> {
  late Color color;
  late Widget icon;

  @override
  void initState() {
    super.initState();
    color = OfferTypeService.instance.getColor(widget.order.offerType!.name);
    icon = OfferTypeService.instance.getIcon(widget.order.offerType!.name);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //expand
      },
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.fromLTRB(0,0,0,6),
        decoration: _containerDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon(),
              _buildOrderDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 0,
          blurRadius: 15,
          offset: Offset(5, 5), // Shadow moved to the right and bottom
        ),
      ],
      borderRadius: widget.borderRadius,
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Center(child: icon),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _orderStatusIcon(),
            const SizedBox(width: 12),
            Text(
              widget.order.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                  color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87)
              ),
            ),
          ],
        ),
        Text("${widget.order.price / widget.order.quantity} BGN/kg"),
      ],
    );
  }

  Widget _orderStatusIcon() {
    return widget.order.status == "Delivered"
        ? const Icon(
      CupertinoIcons.checkmark_alt,
      color: Colors.greenAccent,
      size: 20,
    )
        : widget.order.status == "Denied" ? const Icon(
      CupertinoIcons.xmark,
      color: Colors.red,
      size: 20,
    )
        : const Icon(
      CupertinoIcons.clock,
      color: Colors.grey,
      size: 20,
    );
  }
}
