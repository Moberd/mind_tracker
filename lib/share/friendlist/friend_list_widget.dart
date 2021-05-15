
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/share/friendlist/friend_pending_bloc/friend_pending_bloc.dart';

import '../generate_qr.dart';
import '../share_bloc.dart';

class FriendListWindow extends StatelessWidget {
  final List<String> friends = ["Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3","Friend1", "Friend2", "Friend3"];
  @override
  Widget build(BuildContext context) {
    final blocEmail = BlocProvider.of<AuthBloc>(context).email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friends"),
      ),
      body:BlocProvider<FriendPendingBloc>(
        create: (context){
          return FriendPendingBloc(email: blocEmail)..add(LoadPendingEvent());
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 16),
                child:  TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          prefixIcon:Icon(Icons.search,size: 28,) ,
                          labelText: "Enter friend's e-mail:"
                      )
                  ),
                  suggestionsCallback: (pattern) async{
                    return ["friend1","friend2","friend2","friend2","friend2","friend2","friend2"];
                  },
                  hideOnEmpty: true,
                  hideOnLoading: true,

                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    offsetX: 3,

                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  itemBuilder: (context,suggestion){
                    return ListTile();
                  },
                  onSuggestionSelected: (suggestion){

                  },

                ),
              ),
              BlocBuilder<FriendPendingBloc,FriendPendingState>(builder: (context,state){
                final friendPendingBloc =   BlocProvider.of<FriendPendingBloc>(context);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(0,50),
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10)))

                        ),
                        onPressed: (){

                          scan(friendPendingBloc);},
                        label: Text("Scan QR",style: TextStyle(fontSize: 20), ),
                        icon: Icon(Icons.camera_alt_outlined,size: 34,)
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(0,50),
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => GenerateScreen()));
                      },
                      label: Text("Share QR",style: TextStyle(fontSize: 20),),
                      icon: Icon(Icons.qr_code_outlined,size: 34),
                    ),
                  ],
                );
              }),
              BlocBuilder<FriendPendingBloc,FriendPendingState>(builder: (context,state){
                final friendPendingBloc =   BlocProvider.of<FriendPendingBloc>(context);
                if(state is PendingLoadingState || state is PendingLoadedState){
                  return Padding(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: (){
                              friendPendingBloc.add(LoadPendingEvent());
                            },
                            child: Text(
                              "Pending friends",
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            )),
                        TextButton(
                            onPressed: (){
                              friendPendingBloc.add(LoadAddedEvent());
                               },
                            child: Text(
                              "Added friends",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16
                              ),

                            ))
                      ],
                    ) ,);
                }
                else{
                  return Padding(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){
                          friendPendingBloc.add(LoadPendingEvent());
                        },
                            child: Text(
                              "Pending friends",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16
                              ),
                            )),
                        TextButton(onPressed: (){
                          friendPendingBloc.add(LoadAddedEvent());
                        },
                            child: Text(
                              "Added friends",
                              style: TextStyle(
                                  fontSize: 16
                              ),

                            ))
                      ],
                    ) ,);
                }
              }),
              BlocBuilder<FriendPendingBloc,FriendPendingState>(builder: (context,state){
                final friendPendingBloc =   BlocProvider.of<FriendPendingBloc>(context);
                if(state is PendingLoadedState){
                  print(state);
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.emails.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(state.emails[index]),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          IconButton(icon: Icon(Icons.minimize,color: Colors.redAccent,),onPressed: (){},),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          IconButton(icon: Icon(Icons.add,color: Colors.greenAccent,),onPressed: (){},),
                        ],)
                      );
                    },
                  );
                }
                if(state is AddedLoadedState){
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.emails.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(state.emails[index]),
                        trailing: IconButton(icon: Icon(Icons.remove,color: Colors.redAccent),onPressed: (){
                          final s = (state.emails[index]);
                          friendPendingBloc.add(DeleteFriendEvent(s));
                        },),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator(),);
              })

            ],
          ),
        ),
      )
    );
  }
  Future scan(FriendPendingBloc bloc) async {
    try {
      var result = await BarcodeScanner.scan();
      print(result);
      bloc.add(AddFriendEvent(result));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {

      } else {

      }
    } on FormatException {

    } catch (e) {
    }
  }

}
