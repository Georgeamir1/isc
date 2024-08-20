import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/Booking/edit_Booking.dart';
import '../State_manage/Cubits/cubit.dart';
import 'Data.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

//..............................................................................
class ToggleButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final VoidCallback onPressed;

  const ToggleButton({
    Key? key,
    required this.buttonText,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: isSelected
                  ? WidgetStateProperty.all(Colors.red)
                  : WidgetStateProperty.all(Colors.lightGreen),
            ),
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

//..............................................................................
class Screens extends StatelessWidget {
  final String screenname;
  final String imagepath;
  final VoidCallback onPressed;

  const Screens({
    Key? key,
    required this.screenname,
    required this.imagepath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            screenname,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagepath,
              ),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(300, 200),
          backgroundColor: Color(0xffA4D7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
    );
  }
}

//..............................................................................
class RDropdownSearch extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final bool showSearchBox;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final String? errorMessage;

  const RDropdownSearch({
    Key? key,
    required this.items,
    required this.hintText,
    required this.showSearchBox,
    this.selectedItem,
    this.onChanged,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Constrain width to the parent container
      child: DropdownSearch<String>(
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
        ),
        selectedItem: selectedItem,
        popupProps: PopupProps.menu(
          showSearchBox: showSearchBox,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            ),
          ),
          itemBuilder: (context, item, isSelected) => ListTile(
            title: Text(item),
            selected: isSelected,
          ),
        ),
        filterFn: (item, filter) =>
            item.toLowerCase().contains(filter.toLowerCase()),
        onChanged: onChanged,
      ),
    );
  }
}

//..............................................................................
class CustomDateTimePicker extends StatelessWidget {
  final DateTimePickerType pickerType;
  final ValueNotifier<DateTime> dateNotifier;
  final BoardDateTimeController controller;

  const CustomDateTimePicker({
    required this.pickerType,
    required this.dateNotifier,
    required this.controller,
    Key? key,
  }) : super(key: key);

  Future<void> _openDateTimePicker(BuildContext context) async {
    final DateTime? selectedDate = await showBoardDateTimePicker(
      context: context,
      pickerType: pickerType,
      options: const BoardDateTimeOptions(
        languages: BoardPickerLanguages.en(),
      ),
      valueNotifier: dateNotifier,
    );
    if (selectedDate != null) {
      dateNotifier.value = selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDateTimePicker(context),
      child: Container(
        height: 40, // Set the maximum height
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              pickerType.icon,
              color: Colors.indigo,
              size: 20,
            ),
            ValueListenableBuilder<DateTime>(
              valueListenable: dateNotifier,
              builder: (context, date, child) {
                String formattedDate;
                switch (pickerType) {
                  case DateTimePickerType.date:
                    formattedDate = BoardDateFormat('yyyy/MM/dd').format(date);
                    break;
                  case DateTimePickerType.datetime:
                    formattedDate = BoardDateFormat('yyyy/MM/dd h:mm a')
                        .format(date); // AM/PM format
                    break;
                  case DateTimePickerType.time:
                    formattedDate =
                        BoardDateFormat('h:mm a').format(date); // AM/PM format
                    break;
                  default:
                    formattedDate = '';
                }
                return Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDateTimePicker2 extends StatelessWidget {
  final DateTimePickerType pickerType;
  final ValueNotifier<DateTime> dateNotifier;
  final BoardDateTimeController controller;
  final ValueChanged<DateTime> onDateChanged; // Callback for date change

  const CustomDateTimePicker2({
    required this.pickerType,
    required this.dateNotifier,
    required this.controller,
    required this.onDateChanged, // Initialize callback
    Key? key,
  }) : super(key: key);

  Future<void> _openDateTimePicker(BuildContext context) async {
    final DateTime? selectedDate = await showBoardDateTimePicker(
      context: context,
      pickerType: pickerType,
      options: const BoardDateTimeOptions(
        languages: BoardPickerLanguages.en(),
      ),
      valueNotifier: dateNotifier,
    );
    if (selectedDate != null) {
      dateNotifier.value = selectedDate;
      onDateChanged(selectedDate); // Call the callback with the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDateTimePicker(context),
      child: Container(
        height: 40, // Set the maximum height
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              pickerType.icon,
              color: Colors.indigo,
              size: 20,
            ),
            ValueListenableBuilder<DateTime>(
              valueListenable: dateNotifier,
              builder: (context, date, child) {
                String formattedDate;
                switch (pickerType) {
                  case DateTimePickerType.date:
                    formattedDate = BoardDateFormat('yyyy/MM/dd').format(date);
                    break;
                  case DateTimePickerType.datetime:
                    formattedDate = BoardDateFormat('yyyy/MM/dd h:mm a')
                        .format(date); // AM/PM format
                    break;
                  case DateTimePickerType.time:
                    formattedDate =
                        BoardDateFormat('h:mm a').format(date); // AM/PM format
                    break;
                  default:
                    formattedDate = '';
                }
                return Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDateTimePickerFromVariable extends StatelessWidget {
  final DateTimePickerType pickerType;
  final ValueNotifier<DateTime> dateNotifier;
  final BoardDateTimeController controller;
  final DateTime initialDate; // New variable to take time from

  const CustomDateTimePickerFromVariable({
    required this.pickerType,
    required this.dateNotifier,
    required this.controller,
    required this.initialDate, // Pass the initial date from the Date variable
    Key? key,
  }) : super(key: key);

  // Method to retrieve the selected date or time
  DateTime getSelectedDate() {
    return dateNotifier.value;
  }

  Future<void> _openDateTimePicker(BuildContext context) async {
    final DateTime? selectedDate = await showBoardDateTimePicker(
      context: context,
      pickerType: pickerType,
      options: const BoardDateTimeOptions(
        languages: BoardPickerLanguages.en(),
      ),
      valueNotifier: dateNotifier,
    );
    if (selectedDate != null) {
      dateNotifier.value = selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDateTimePicker(context),
      child: Container(
        height: 40, // Set the maximum height
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              pickerType.icon,
              color: Colors.indigo,
              size: 20,
            ),
            ValueListenableBuilder<DateTime>(
              valueListenable: dateNotifier,
              builder: (context, date, child) {
                String formattedDate;
                switch (pickerType) {
                  case DateTimePickerType.date:
                    formattedDate = BoardDateFormat('yyyy/MM/dd').format(date);
                    break;
                  case DateTimePickerType.datetime:
                    formattedDate = BoardDateFormat('yyyy/MM/dd h:mm a')
                        .format(date); // AM/PM format
                    break;
                  case DateTimePickerType.time:
                    formattedDate =
                        BoardDateFormat('h:mm a').format(date); // AM/PM format
                    break;
                  default:
                    formattedDate = '';
                }
                return Text(
                  Date!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

//..............................................................................
extension DateTimePickerTypeExtension on DateTimePickerType {
  String get title {
    switch (this) {
      case DateTimePickerType.date:
        return 'Date';
      case DateTimePickerType.datetime:
        return 'DateTime';
      case DateTimePickerType.time:
        return 'Time';
    }
  }

  IconData get icon {
    switch (this) {
      case DateTimePickerType.date:
        return Icons.date_range_rounded;
      case DateTimePickerType.datetime:
        return Icons.date_range_rounded;
      case DateTimePickerType.time:
        return Icons.schedule_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DateTimePickerType.date:
        return Colors.blue;
      case DateTimePickerType.datetime:
        return Colors.orange;
      case DateTimePickerType.time:
        return Colors.pink;
    }
  }

  String formatter({bool withSecond = false}) {
    switch (this) {
      case DateTimePickerType.date:
        return 'yyyy/MM/dd';
      case DateTimePickerType.datetime:
        return 'yyyy/MM/dd HH:mm';
      case DateTimePickerType.time:
        return withSecond ? 'HH:mm:ss' : 'HH:mm';
    }
  }
}

//..............................................................................
void navigateToPage(BuildContext context, Widget destinationPage) {
  assert(destinationPage != null); // Ensure destinationPage is not null
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => destinationPage,
    ),
  );
}

//..............................................................................
Widget doctoritem(list) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'الأسم : ${list['NAME']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'رقم الهاتف:  ',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              Text(
                'التخصص ',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
//..............................................................................
Widget divider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: Colors.grey, // Grey color
        thickness: 1.0, // Thin thickness
        height: 20.0, // Height of the divider
      ),
    );

//..............................................................................
class ReservationItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final ValueChanged<String> onNoSelected;

  const ReservationItem({
    Key? key,
    required this.data,
    required this.onNoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy/MM/dd').format(DateTime.parse(data['SDate']));
    String formattedTime =
        DateFormat('h:mm a').format(DateTime.parse(data['SDate']));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          try {
            patientcode = data['PatCode'].toString();
            edit = true;
            onNoSelected(data['No'].toString());
            Date = '';
            New = false;
            navigateToPage(context, EditBooking());
          } catch (e) {
            print('Error occurred: $e');
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data['Patient']} ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Code : ${data['PatCode']}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Reservation no : ${data['No']}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Date :$formattedDate',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Time :$formattedTime',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Type : ${data['OperRoomt'] ?? 'كشف'}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Contact  : ${data['cont_name'] ?? 'Private'}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RelevantItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const RelevantItem({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy/MM/dd').format(DateTime.parse(data['SDate']));
    String formattedTime =
        DateFormat('h:mm a').format(DateTime.parse(data['SDate']));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${data['Patient']} ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'كود المريض : ${data['PatCode']}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$formattedDate\n$formattedTime',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'نوع الكشف : ${data['OperRoomt'] ?? 'كشف'}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'التعاقد : ${data['cont_name'] ?? 'خاص'}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                // Additional fields as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//..............................................................................

class Datetimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      headerProps: EasyHeaderProps(
        showMonthPicker: true,
        monthPickerType: MonthPickerType.switcher,
        showHeader: true,
        monthStyle: TextStyle(fontSize: 18, color: Colors.black54),
      ),
      dayProps: EasyDayProps(
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(3, 0),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        inactiveDayStyle: DayStyle(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(3, 0),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        width: 40,
        height: 40,
      ),
      onDateChange: (date) {
        context.read<SelectDateCubit>().selectDate(date);
      },
    );
  }
}
//..............................................................................

class PatientCodeSearchDelegate extends SearchDelegate {
  final List<dynamic> data;
  PatientCodeSearchDelegate(this.data);
  List<Map<String, dynamic>> get _typedData {
    return data.cast<Map<String, dynamic>>();
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    // Filter results based on 'No', 'PatCode', or 'Patient'
    final results = _typedData.where((item) {
      final no = item['No'].toString().toLowerCase();
      final patCode = item['PatCode'].toString().toLowerCase();
      final patient = item['Patient'].toLowerCase();
      final searchQuery = query.toLowerCase();

      return no.contains(searchQuery) || patCode.contains(searchQuery) || patient.contains(searchQuery);
    }).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return RelevantItem(
          data: result,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBooking(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _typedData.where((item) =>
        item['PatCode'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return RelevantItem(
          data: suggestion,
          onTap: () {
            query = suggestion['Patient'];
            showResults(context);
          },
        );
      },
    );
  }
}
Future <bool> _showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Exit App'),
      content: Text('Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}
