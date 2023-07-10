import 'package:flutter/material.dart';
import 'pallete.dart';

class Password extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const Password({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  @override
  void dispose() {
    widget.controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 370,
      ),
      child: TextFormField(
        controller: widget.controller, // Set the controller
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 150, 147, 184),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
