
import 'package:flutter/material.dart';

class FriendListWindow extends StatelessWidget {
  final List<String> friends = ["Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friends"),
      ),
      body:SingleChildScrollView(
        physics: ScrollPhysics(),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 16),
              child:  TextField(
                style: TextStyle(
                  fontSize: 18
                ),
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.search,size: 28,) ,
                  labelText: "Enter friend's e-email:"
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(0,50),
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10)))

                    ),
                  onPressed: (){},
                  label: Text("Scan QR",style: TextStyle(fontSize: 20), ),
                  icon: Icon(Icons.camera_alt_outlined,size: 34,)
                    ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0,50),
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                  onPressed: (){},
                  label: Text("Share QR",style: TextStyle(fontSize: 20),),
                  icon: Icon(Icons.qr_code_outlined,size: 34),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){},
                      child: Text(
                        "Pending friends",
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )),
                  TextButton(onPressed: (){},
                      child: Text(
                          "Added friends",
                         style: TextStyle(
                             fontSize: 16
                         ),

                      ))
                ],
              ) ,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (context,index){
                return ListTile(
                  onTap: (){

                  },
                  title: Text(friends[index]),
                  trailing: Icon(Icons.navigate_next_sharp),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
