import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (status) {
      case 'Assigned':
        chipColor = Colors.blue;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Completed':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: chipColor),
        borderRadius: BorderRadius.circular(15),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
