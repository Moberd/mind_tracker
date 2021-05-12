import 'dart:convert';
import 'dart:ui';
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mind_tracker/authorization/auth_bloc.dart';
import 'package:mind_tracker/rate_day/rate_day_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
//*основной экран где должен осуществляться ввод данных
class MainWindowWidget extends StatefulWidget {
  @override
  _MainWindowWidgetState createState() => _MainWindowWidgetState();
}

class _MainWindowWidgetState extends State<MainWindowWidget> {
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final blocEmail = BlocProvider.of<AuthBloc>(context).email;
    return BlocProvider<RateDayBloc>(
      create: (context){
        return RateDayBloc(blocEmail)..add(RateDayLoad());
      },
      child: BlocBuilder<RateDayBloc,RateDayState>(
        buildWhen: (state1,state2){
          if(state2 is RateDayTrashState){
            return false;
          }
          return true;
        },
        builder: (context,state){
          print(state);
          if(state is RateDayLoaded){
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Color(0xFFFEF9FF),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: HowAreYouText(),
                      ),
                      Flexible(
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Image.asset(
                                  'assets/meditation_3.gif',
                                  height: 250,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: ThoughtsList(
                                ),
                              ),
                            ]
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: bottom),
                        child: ThoughtBoxContainer(
                          thoughts: state.thoughts,
                        ),
                      ),
                      SliderContainer(
                        mark: state.mark,
                      ),

                    ],
                  ),
                ),
              ),

            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }

}

class HowAreYouText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "How are you today?",
      style: TextStyle(color: Colors.deepPurple, fontSize: 40),
    );
  }
}

class ThoughtsList extends StatefulWidget {
  final void Function() touch;
  ThoughtsList({Key key, this.touch}) : super(key: key);
  @override
  _ThoughtsListState createState() => _ThoughtsListState();
}

class _ThoughtsListState extends State<ThoughtsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RateDayBloc,RateDayState>(
        builder: (context,state){
          if(state is RateDayLoaded){
            final List<String> thoughts = state.thoughts;
            return ListView.builder(
                itemCount: thoughts.length,
                itemBuilder: (context, i) {
                  return Dismissible(
                    key: Key(thoughts[i]),
                    onDismissed: (direction) {
                     BlocProvider.of<RateDayBloc>(context).add(RateDayDelete(i,thoughts ));
                     ScaffoldMessenger
                        .of(context)
                         .showSnackBar(SnackBar(content: Text("Thought deleted")));

                    },
                    child: Opacity(
                      opacity: 0.7,
                      child: Card(
                        child: ListTile(
                          //title: Text("Never gonna give you up"),
                            title: Text(thoughts[i])
                        ),
                      ),
                    ),
                  );
                });
          }
          return Center( child: CircularProgressIndicator(),);
    });
  }

}


final _controller = TextEditingController();
class ThoughtBoxContainer extends StatefulWidget {
  final List<String> thoughts;

  const ThoughtBoxContainer({Key key, this.thoughts}) : super(key: key);
  @override
  _ThoughtBoxContainerState createState() => _ThoughtBoxContainerState();
}
class _ThoughtBoxContainerState extends State<ThoughtBoxContainer> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Your thoughts today',
        border: OutlineInputBorder(),
      ),
      controller: _controller,
      onFieldSubmitted: (value) {
        if (value != '') {
        BlocProvider.of<RateDayBloc>(context).add(RateDayAdd(_controller.text, widget.thoughts));
        }
        _controller.clear();
    }
    );
  }
}

class IconsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.thumb_down, size: 30, color: Colors.deepPurple),
        Icon(Icons.check, size: 30, color: Colors.deepPurple),
        Icon(Icons.thumb_up, size: 30, color: Colors.deepPurple)
      ],
    );
  }
}

class SliderContainer extends StatefulWidget {
  final String mark;

  const SliderContainer({Key key, this.mark}) : super(key: key);
  @override
  _SliderContainerState createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> with WidgetsBindingObserver {
  static double _lowerValue = 0;
  static double _upperValue = 10;
   String saveMark;
   RateDayBloc _rateDayBloc;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _rateDayBloc = BlocProvider.of<RateDayBloc>(context);
    super.initState();
  }
  @override
  void deactivate() {
    _rateDayBloc.add(RateDatSaveLastMark(int.parse(saveMark)));
    super.deactivate();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rateDayBloc.add(RateDatSaveLastMark(int.parse(saveMark)));
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state.toString() == "AppLifecycleState.inactive"){
      _rateDayBloc.add(RateDatSaveLastMark(int.parse(saveMark)));
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RateDayBloc,RateDayState>(
        buildWhen: (state1,state2){
          if(state2 is RateDayTrashState){
            return false;
          }
          return true;
        },
        builder: (context,state){


      if(state is RateDayLoaded){
        double mark = double.parse(state.mark);
        saveMark = state.mark;
        return Column(children: [
          Slider(
            divisions: 10,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple[50],
            min: _lowerValue,
            max: _upperValue,
            value: mark,
            onChanged: (val) {
              print(val);
              BlocProvider.of<RateDayBloc>(context).add(RateDaySetMark(val.truncate()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child:RateDigitText(mark:state.mark,),
          ),
        ],);
      }
      return Center( child: CircularProgressIndicator(),);

    });
  }
}

class RateDigitText extends StatelessWidget {
  final String mark;
  RateDigitText({Key key, this.mark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text(
        mark,
        style: TextStyle(fontSize: 30),
      ),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.black, width: 1),
      ),
      alignment: Alignment.center,
    );
  }
}
