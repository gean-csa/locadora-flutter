import 'package:flutter/material.dart';

class MainDatePickerField extends StatefulWidget {
  const MainDatePickerField({
    super.key,
    required this.onSelect,
    this.initialDate,
    required this.title,
  });

  final Function(DateTime) onSelect;
  final DateTime? initialDate;
  final String title;

  @override
  State<MainDatePickerField> createState() => _MainDatePickerFieldState();
}

class _MainDatePickerFieldState extends State<MainDatePickerField> {
  late DateTime? selectedDate = widget.initialDate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDate: DateTime.now(),
        );
        selectedDate = date;
        widget.onSelect(selectedDate!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  selectedDate == null
                      ? "Selecionar a data"
                      : selectedDate!.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
