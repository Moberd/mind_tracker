
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/share/friendlist/friend_pending_bloc/friend_pending_bloc.dart';
import 'package:mind_tracker/main.dart';
import 'package:mind_tracker/share/friendlist/search_bloc/search_bloc.dart';
import '../generate_qr.dart';
import '../share_bloc.dart';

class FriendListWindow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final blocEmail = BlocProvider.of<AuthBloc>(context).email;
    final searchBloc = SearchBloc(blocEmail);
    List<String> friends = [];
    if(kIsWeb){
      return Scaffold(
          appBar: AppBar(
            title: Text(Strings.addFriends[lang]),
          ),
          body:BlocProvider<FriendPendingBloc>(
              create: (context){
                return FriendPendingBloc(email: blocEmail)..add(LoadPendingEvent());
              },
              child: BlocListener<FriendPendingBloc,FriendPendingState>(
                listener: (context,state){
                  if(state is ShowSnackBarState){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocListener<SearchBloc,SearchState>(
                        listener: (context,state){
                          if(state is ShowSnackBarSearchState){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                          }
                          else{
                            if(!ListEquality().equals(friends, state.search))
                              friends = state.search;
                          }
                        },
                        bloc: searchBloc,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 16),
                          child:  TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  prefixIcon:Icon(Icons.search,size: 28,) ,
                                  labelText: Strings.enterFriendsEmail[lang],
                                ),
                                onChanged: (val){
                                  searchBloc.add(StartSearchingEvent(val));
                                }
                            ),
                            suggestionsCallback: (pattern) async{
                              return friends;
                            },
                            hideOnEmpty: true,
                            hideOnLoading: true,
                            animationDuration: Duration.zero,
                            debounceDuration: Duration(milliseconds: 300),
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              offsetX: 3,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            itemBuilder: (context,suggestion){
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion){
                              searchBloc.add(AddFriendSearchEvent(suggestion));
                            },
                          ),
                        ),
                      ),
                      BlocBuilder<FriendPendingBloc,FriendPendingState>(builder: (context,state){
                        final friendPendingBloc =   BlocProvider.of<FriendPendingBloc>(context);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(0,50),
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10)))
                              ),
                              onPressed: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => GenerateScreen()));
                              },
                              label: Text(Strings.shareQR[lang],style: TextStyle(fontSize: 20),),
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
                                      Strings.pendingFriends[lang],
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    )),
                                TextButton(
                                    onPressed: (){
                                      friendPendingBloc.add(LoadAddedEvent());
                                    },
                                    child: Text(
                                      Strings.addFriends[lang],
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16
                                      ),

                                    )),
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
                                      Strings.pendingFriends[lang],
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16
                                      ),
                                    )),
                                TextButton(onPressed: (){
                                  friendPendingBloc.add(LoadAddedEvent());
                                },
                                    child: Text(
                                      Strings.addedFriends[lang],
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
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.emails.length,
                            itemBuilder: (context,index){
                              return ListTile(
                                  title: Text(state.emails[index]),
                                  trailing: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(padding: EdgeInsets.only(right: 10,bottom: 10),
                                        child:IconButton(
                                          icon: Icon(Icons.minimize,color: Colors.redAccent,),
                                          onPressed: (){
                                            final s = state.emails[index];
                                            friendPendingBloc.add(DeclineFriendRequestEvent(s));
                                          },),),
                                      IconButton(
                                        icon: Icon(Icons.add,color: Colors.greenAccent,),
                                        onPressed: (){
                                          final s = state.emails[index];
                                          friendPendingBloc.add(AcceptFriendRequestEvent(s));
                                        },),
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
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.addFriends[lang]),
      ),
      body:BlocProvider<FriendPendingBloc>(
        create: (context){
          return FriendPendingBloc(email: blocEmail)..add(LoadPendingEvent());
        },
        child: BlocListener<FriendPendingBloc,FriendPendingState>(
          listener: (context,state){
            if(state is ShowSnackBarState){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocListener<SearchBloc,SearchState>(
                  listener: (context,state){
                    if(state is ShowSnackBarSearchState){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    else{
                      if(!ListEquality().equals(friends, state.search))
                        friends = state.search;
                    }
                  },
                  bloc: searchBloc,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 16),
                    child:  TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            prefixIcon:Icon(Icons.search,size: 28,) ,
                            labelText: Strings.enterFriendsEmail[lang],
                          ),
                          onChanged: (val){
                            searchBloc.add(StartSearchingEvent(val));
                          }
                      ),
                      suggestionsCallback: (pattern) async{
                        return friends;
                      },
                      hideOnEmpty: true,
                      hideOnLoading: true,
                      animationDuration: Duration.zero,
                      debounceDuration: Duration(milliseconds: 300),
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        offsetX: 3,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      itemBuilder: (context,suggestion){
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion){
                        searchBloc.add(AddFriendSearchEvent(suggestion));
                      },
                    ),
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
                          label: Text(Strings.scanQR[lang],style: TextStyle(fontSize: 20), ),
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
                        label: Text(Strings.shareQR[lang],style: TextStyle(fontSize: 20),),
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
                                Strings.pendingFriends[lang],
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              )),
                          TextButton(
                              onPressed: (){
                                friendPendingBloc.add(LoadAddedEvent());
                              },
                              child: Text(
                                Strings.addFriends[lang],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16
                                ),

                              )),
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
                                Strings.pendingFriends[lang],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16
                                ),
                              )),
                          TextButton(onPressed: (){
                            friendPendingBloc.add(LoadAddedEvent());
                          },
                              child: Text(
                                Strings.addedFriends[lang],
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
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.emails.length,
                      itemBuilder: (context,index){
                        return ListTile(
                            title: Text(state.emails[index]),
                            trailing: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(padding: EdgeInsets.only(right: 10,bottom: 10),
                                  child:IconButton(
                                    icon: Icon(Icons.minimize,color: Colors.redAccent,),
                                    onPressed: (){
                                      final s = state.emails[index];
                                      friendPendingBloc.add(DeclineFriendRequestEvent(s));
                                    },),),
                                IconButton(
                                  icon: Icon(Icons.add,color: Colors.greenAccent,),
                                  onPressed: (){
                                  final s = state.emails[index];
                                  friendPendingBloc.add(AcceptFriendRequestEvent(s));
                                },),
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
      )
    );
  }
  Future scan(FriendPendingBloc bloc) async {
    try {
      var result = await BarcodeScanner.scan();
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
