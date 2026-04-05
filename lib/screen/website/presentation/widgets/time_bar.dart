import 'package:flutter/material.dart';

import '../../data/constant/enum.dart';


class TimeFilterBar extends StatefulWidget {
  final Function(TimeFilter) onChanged;

  const TimeFilterBar({super.key, required this.onChanged});

  @override
  State<TimeFilterBar> createState() => _TimeFilterBarState();
}

class _TimeFilterBarState extends State<TimeFilterBar> {
  TimeFilter selected = TimeFilter.weekly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4), // shadow goes down
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TimeFilter.values.map((filter) {
          final isSelected = selected == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selected = filter;
              });
              widget.onChanged(filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[200] : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _label(filter),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(TimeFilter filter) {
    switch (filter) {
      case TimeFilter.weekly:
        return "weekly";
      case TimeFilter.monthly:
        return "monthly";
      case TimeFilter.yearly:
        return "yearly";
      case TimeFilter.allTime:
        return "AllTime";
    }
  }
}