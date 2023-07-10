import 'package:flutter/material.dart';
import 'pallete.dart';

class LoginField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const LoginField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  //final TextEditingController _controller = TextEditingController(); // Add TextEditingController

 // Add getter method

  @override
  void dispose() {
    widget.controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      child: TextFormField(
        controller: widget.controller, // Set the controller
        // obscureText: true,
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
