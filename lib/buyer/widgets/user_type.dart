import 'package:flutter/material.dart';
import 'pallete.dart';


class UserType extends StatefulWidget {
  final String hintText;

  const UserType({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 370,
        maxHeight: 70,
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 150, 147, 184),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
            },
            items: <String>[
              'User',
              'Vendor',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(widget.hintText),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
