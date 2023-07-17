import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PaymentUI extends StatefulWidget {
  const PaymentUI({super.key});

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Payments")),
      body: SafeArea(
        child: Padding(
          
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Spacer(),
              Form(
                
                child: Column(
                  
                  children: [
                    TextFormField(
                      cursorColor: Colors.deepPurple,
                      maxLength: 20,
                      decoration: InputDecoration(
                        icon: Icon(Icons.numbers),
                        labelText: 'Card Number',
                        labelStyle: TextStyle(
                          color: Color(0xFF6200EE),
                        ),
                        suffixIcon: Icon(
                          Icons.check_circle,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child:TextFormField(
                          cursorColor: Colors.deepPurple,
                          maxLength: 20,
                          decoration: InputDecoration(
                            icon: Icon(Icons.abc_outlined),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            suffixIcon: Icon(
                              Icons.check_circle,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                        ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            maxLength: 20,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Card Number',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              suffixIcon: Icon(
                                Icons.check_circle,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            maxLength: 20,
                            decoration: InputDecoration(
                              icon: Icon(Icons.date_range),
                              labelText: 'MM/YY',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              suffixIcon: Icon(
                                Icons.check_circle,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OutlinedButton(
                  child: Text("Tap on this"),
                  style: OutlinedButton.styleFrom(
                    primary: Color(0xFF6200EE),
                    side: BorderSide(
                      color: Color(0xFF6200EE),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}


