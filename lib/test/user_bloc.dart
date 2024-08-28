import 'package:flutter/material.dart';
import 'package:isc/Home/Booking/Booking_list.dart';

class ContainerTransitionExample extends StatefulWidget {
  @override
  _ContainerTransitionExampleState createState() =>
      _ContainerTransitionExampleState();
}

class _ContainerTransitionExampleState
    extends State<ContainerTransitionExample> {
  bool _isExpanded = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: (){print('fefew');},
        onTap: () async{
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Center(
          child: AnimatedContainer(
            width: isExpanded ? MediaQuery.of(context).size.width : 300,
            height: isExpanded ? MediaQuery.of(context).size.height : 200,
            color: Colors.grey,
            duration: Duration(milliseconds:500 ),
            curve: Curves.ease,
            child: isExpanded? BookingList():Center(
              child: GestureDetector(
                onTap:(){ setState(() {
              isExpanded = !isExpanded;
              });},
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  width: _isExpanded ? 200 : 120  ,
                  height: _isExpanded ? 150  : 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(_isExpanded ? 30 : 30),
                  ),
                  child: _isExpanded
                      ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            isExpanded = !isExpanded;

                          });
                                  },
                        child: Text('test1',style: TextStyle(fontSize: 22),)),
                          Divider(),
                          Text('test2',style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ))
                      : Container(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
