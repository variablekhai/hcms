
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

const String _groupId = "dropdown";

enum StatusChoices {
  pending,
  assigned,
  completed,
  cancelled;

  String get name {
    return switch (this) {
      StatusChoices.pending => 'Pending',
      StatusChoices.assigned => 'Assigned',
      StatusChoices.completed => 'Completed',
      StatusChoices.cancelled => 'Cancelled'
    };
  }
}

enum DateRangeChoices {
  today,
  thisWeek,
  thisMonth;

  String get name {
    return switch (this) {
      DateRangeChoices.today => 'Today',
      DateRangeChoices.thisWeek => 'This Week',
      DateRangeChoices.thisMonth => 'This Month'
    };
  }
}

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  bool _showStatusChoices = false;
  bool _showDateRangeChoices = false;
  String _selectedStatus = "Status";
  String _selectedDateRange = "Date Range";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status Dropdown
        Expanded(
          child: MoonDropdown(
            show: _showStatusChoices,
            groupId: _groupId,
            constrainWidthToChild: true,
            onTapOutside: () => setState(() => _showStatusChoices = false),
            content: Column(
              children: StatusChoices.values.map((choice) {
                return MoonMenuItem(
                  onTap: () => setState(() {
                    _selectedStatus = choice.name;
                    _showStatusChoices = false;
                  }),
                  label: Text(choice.name),
                );
              }).toList(),
            ),
            child: MoonFilledButton(
              onTap: () => setState(() => _showStatusChoices = !_showStatusChoices),
              backgroundColor: const Color(0xFF9DC543),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedStatus),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Date Range Dropdown
        Expanded(
          child: MoonDropdown(
            show: _showDateRangeChoices,
            groupId: _groupId,
            constrainWidthToChild: true,
            onTapOutside: () => setState(() => _showDateRangeChoices = false),
            content: Column(
              children: DateRangeChoices.values.map((choice) {
                return MoonMenuItem(
                  onTap: () => setState(() {
                    _selectedDateRange = choice.name;
                    _showDateRangeChoices = false;
                  }),
                  label: Text(choice.name),
                );
              }).toList(),
            ),
            child: MoonFilledButton(
              onTap: () => setState(() => _showDateRangeChoices = !_showDateRangeChoices),
              backgroundColor: const Color(0xFF9DC543),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDateRange),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
