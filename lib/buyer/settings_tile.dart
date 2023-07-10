import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileTile extends StatelessWidget {
  const ProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 16 ,
              bottom: 8 ,
              right: 20 ),
          child: ListTile(
            trailing: SizedBox(
                width: 150 ,
                height: 67 ,
                child: Row(
                  children: [
                    Text(
                      'User',
                      style: TextStyle(
                        fontSize: 30 ,
                      ),
                    ),
                    SizedBox(width: 10 ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(CupertinoPageRoute<void>(
                        //     builder: (BuildContext context) => LoginPage2()));
                      },
                      child: Container(

                        child: Image.asset("assets/avatar.png"),
                      ),
                    ),

                  ],
                )),
          ),
        ),
      ],
    );
  }
}
