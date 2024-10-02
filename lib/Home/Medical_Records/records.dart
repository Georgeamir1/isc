import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:isc/Home/Booking/Booking_New.dart';
import 'package:isc/shared/componants.dart';

import '../../shared/Data.dart';
import '../Booking/newPatient.dart';



final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class test extends StatelessWidget {
  const test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      scaffoldMessengerKey: scaffoldKey,
      home: const FirstPage(),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final _counter = ValueNotifier(0);

  CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          ValueListenableBuilder(
            valueListenable: _counter,
            builder: (context, counter, _) {
              return Text(
                '$counter',
                style: Theme.of(context).textTheme.displayMedium,
              );
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('add'),
            onPressed: () => _counter.value++,
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CounterWidget(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
         duration: const Duration(milliseconds: 400),
        distance: 50.0,
         type: ExpandableFabType.up,
         pos: ExpandableFabPos.right,
        childrenOffset: const Offset(-3, 0),
        childrenAnimation: ExpandableFabAnimation.rotate,
         fanAngle: 100,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child:CustomblueContainer(
              width: 60,
              height: 60,
              child:  const Icon(Icons.save)),
          fabSize: ExpandableFabSize.regular,
          foregroundColor:  isDarkmodesaved? Colors.white:Colors.black45,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
    fabSize: ExpandableFabSize.small,
    foregroundColor:  isDarkmodesaved? Colors.white:Colors.black45,
  child: CustomblueContainer(
      width: 40,
      height: 40,
      Radius: 10,
      child: Icon(Icons.close))
),
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withOpacity(0.5),
          blur: 5,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child:CustomwhiteContainer(
                width: 50,
                height: 50,
                child:   Icon(Icons.post_add,color:  isDarkmodesaved? Colors.white:Colors.black45,)),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) =>  BookingNew())));
            },
          ),
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            child: CustomwhiteContainer(
                width: 50,
                height: 50,
                child:  Icon(Icons.person,color:  isDarkmodesaved? Colors.white:Colors.black45)),
            onPressed: () {
              navigateToPage(context, NewPatient());

            },
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('next'),
      ),
      body: const Center(
        child: Text('next'),
      ),
    );
  }
}