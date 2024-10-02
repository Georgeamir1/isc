import 'dart:ui';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../Home/Booking/edit_Booking.dart';
import '../State_manage/Cubits/cubit.dart';
import '../State_manage/States/States.dart';
import 'Data.dart';
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
  final double? width;
  final double? height;
  final double? font;

  const Screens({
    Key? key,
    required this.screenname,
    required this.onPressed,
    required this.imagepath,
    this.height, // Optional height parameter
    this.width,
    this.font,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomblueContainer(
        height: height?? 200,
        width: width ??250,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                screenname,
                style: TextStyle(
                  fontSize: font ??24,
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
        ),
      ),
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
              color: isDarkmodesaved ?Colors.white : Colors.indigo,
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
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkmodesaved ?Colors.white: Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isDarkmodesaved ?Colors.white: Colors.black54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
class CustomDateTimePicker extends StatelessWidget {
  final DateTimePickerType pickerType;
  final ValueNotifier<DateTime> dateNotifier;
  final BoardDateTimeController controller;
  final ValueChanged<DateTime> onDateChanged; // Callback for date change

  const CustomDateTimePicker({
    required this.pickerType,
    required this.dateNotifier,
    required this.controller,
    required this.onDateChanged, // Initialize callback
    Key? key,
  }) : super(key: key);

  Future<void> _openDateTimePicker(BuildContext context) async {
    final DateTime? selectedDate = await showBoardDateTimePicker(
      minimumDate: DateTime.now(),
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
              color: isDarkmodesaved ?Colors.white : Colors.indigo,
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
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkmodesaved ?Colors.white: Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isDarkmodesaved ?Colors.white: Colors.black54,
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
      minimumDate: DateTime.now(),
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
              color: isDarkmodesaved? Colors.white: Colors.indigo,
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
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color:  isDarkmodesaved? Colors.white:Colors.black54,
                    fontSize: 16,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_drop_down,
              color:  isDarkmodesaved? Colors.white: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
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
Widget divider() => Divider(
  color: Colors.grey, // Grey color
  thickness: 1.0, // Thin thickness
  height: 20.0, // Height of the divider
);
//..............................................................................
class ReservationItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final ValueChanged<String> onNoSelected;
  String selectedDate = '';

  ReservationItem({
    Key? key,
    required this.data,
    required this.onNoSelected,
    this.selectedDate = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
    DateFormat('yyyy/MM/dd').format(DateTime.parse(data['SDate']));
    String formattedTime =
    DateFormat('h:mm a').format(DateTime.parse(data['SDate']));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          try {
            DateTime selectedDate = DateTime.parse(data['SDate']);
            DateTime today = DateTime.now();
            DateTime selectedDateOnly = DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day);
            DateTime todayOnly =
            DateTime(today.year, today.month, today.day);

            if (selectedDateOnly.isAfter(todayOnly) ||
                selectedDateOnly.isAtSameMomentAs(todayOnly)) {
              patientcode = data['PatCode'].toString();
              edit = true;
              onNoSelected(data['No'].toString());
              Date = '';
              New = false;
              navigateToPage(context, EditBooking());
            } else {
              print('Selected date is before today, not navigating.');
            }
          } catch (e) {
            print('Error occurred: $e');
          }
        },
        child: CustomwhiteContainer(
          Radius: 12,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  isArabicsaved ? '${data['Patient']}' : '${data['Patient']}',
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isArabicsaved ? 'الكود: ${data['PatCode']}' : 'Code: ${data['PatCode']}',
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isArabicsaved ? 'رقم الحجز: ${data['No']}' : 'Reservation no: ${data['No']}',
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  isArabicsaved ? 'التاريخ: $formattedDate' : 'Date: $formattedDate',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Text(
                  isArabicsaved ? ' $formattedTime' : '$formattedTime',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black45,
                    fontSize: 12,
                  ),
                ),
                Text(
                  isArabicsaved
                      ? 'النوع: ${data['OperRoomt'] ?? 'كشف'}'
                      : 'Type: ${data['OperRoomt'] ?? 'Consultation'}',
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  isArabicsaved
                      ? 'التعاقد: ${data['cont_name'] ?? 'خاص'}'
                      : 'Contact: ${data['cont_name'] ?? 'Private'}',
                  style: TextStyle(
                    color: isDarkmodesaved ? Colors.white : Colors.black54,
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
class MedsItem extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController timesPerDayController;
  final TextEditingController daysController;
  final int index;

  const MedsItem({
    Key? key,
    required this.nameController,
    required this.timesPerDayController,
    required this.daysController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<getDrugsDataCubit, getDrugsDataStatus>(
          builder: (context, state) {
            return CustomwhiteContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<Map<String, dynamic>>(
                  optionsBuilder: (textEditingValue) {
                    return getDrugsDataCubit.get(context).Drugs.where((drug) =>
                        drug['name'].toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (option) => option['name'],
                  onSelected: (selectedItem) {
                    context.read<getDrugsDataCubit>().selectUser(selectedItem['name']);
                    nameController.text = selectedItem['name'];
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      style: TextStyle(color:  isDarkmodesaved? Colors.white:Colors.black45),
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54),
                        border: InputBorder.none,
                        hintText: 'Enter drug name',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ReusableTextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                textStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
                height: 45,
                controller: timesPerDayController,
                hintText: '',
              ),
            ),
            const SizedBox(width: 6),
            Text('Times per day For ', style: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(
              child: ReusableTextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                height: 45,
                textStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
                controller: daysController,
                hintText: '',
              ),
            ),
            const SizedBox(width: 6),
            Text('Days', style: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12),),
            if (index >0)IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<MedsCubit>().getMedications();
                context.read<MedsCubit>().deleteMed(index);
                print(index);
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        divider(),
        SizedBox(height: 8),

      ],
    );
  }
}
class Recordsitems extends StatelessWidget {
  final TextEditingController controller1;
  const Recordsitems({
    Key? key,
    required this.controller1,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        BlocBuilder<getDrugsDataCubit, getDrugsDataStatus>(
          builder: (context, state) {
            return CustomwhiteContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<Map<String, dynamic>>(
                  optionsBuilder: (textEditingValue) {
                    return getDrugsDataCubit.get(context).Drugs.where((drug) =>
                        drug['name'].toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (option) => option['name'],
                  onSelected: (selectedItem) {
                    context.read<getDrugsDataCubit>().selectUser(selectedItem['name']);
                    controller1.text = selectedItem['name'];
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54),
                        border: InputBorder.none,
                        hintText: 'Enter Examination',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        divider(),
        SizedBox(height: 8),
      ],
    );
  }
}
class servicesitems extends StatelessWidget {
  final TextEditingController controller1;
  const servicesitems({
    Key? key,
    required this.controller1,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        BlocBuilder<getDrugsDataCubit, getDrugsDataStatus>(
          builder: (context, state) {
            return CustomwhiteContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<Map<String, dynamic>>(
                  optionsBuilder: (textEditingValue) {
                    return getDrugsDataCubit.get(context).Drugs.where((drug) =>
                        drug['name'].toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (option) => option['name'],
                  onSelected: (selectedItem) {
                    context.read<getDrugsDataCubit>().selectUser(selectedItem['name']);
                    controller1.text = selectedItem['name'];
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: isDarkmodesaved ? Colors.white : Colors.black54),
                        border: InputBorder.none,
                        hintText: 'Enter Service',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        divider(),
        SizedBox(height: 8),
      ],
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

      return no.contains(searchQuery) ||
          patCode.contains(searchQuery) ||
          patient.contains(searchQuery);
    }).toList();
    return Scaffold(
      backgroundColor: isDarkmodesaved ? Colors.black87:Colors.grey[50],
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results.reversed.toList()[index];
          return ReservationItem(
            data: result,
            onNoSelected: (String value) {  {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBooking(),
              ),
            );
          } },
          );
        },
      ),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _typedData
        .where((item) => item['PatCode']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: isDarkmodesaved ? Colors.black87:Colors.grey[50],

      body: ListView.builder(
        itemCount: suggestions.length ,
        itemBuilder: (context, index) {

          final suggestion = suggestions.reversed.toList()[index];
          return ReservationItem(
            data: suggestion,
      onNoSelected: (value) {
        {
      query = suggestion['Patient'];
      showResults(context);
        }
      },        );
        },
      ),
    );
  }
}
//..............................................................................
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final List<Color> gradientColors;
  final TextStyle titleStyle;
  final Color backgroundColor;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final Widget? leading;
  final List<Widget>? actions;
  final List<Color>? color;

  CustomAppBar({
    required this.title,
    this.height = 72.0,
    this.gradientColors = const [Colors.lightBlue, Colors.indigo],
    this.titleStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.2,
    ),
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.borderRadius = const BorderRadius.vertical(bottom: Radius.circular(20)),
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black54,
        offset: Offset(0, 4),
        blurRadius: 8,
      ),
    ],
    this.leading,
    this.actions,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: CustomblueContainer(
        color: color,
        height: 100,
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: elevation,
          title: Text(
            title,
            style: titleStyle,
          ),
          leading: leading,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
class CustomwhiteContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double? Radius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomwhiteContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.Radius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? (isDarkmodesaved ? Colors.grey[700] : Colors.white),
        boxShadow: [
          BoxShadow(
            color: isDarkmodesaved? Colors.transparent:Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(Radius??12),
      ),
      child: child,
    );
  }
}
class CustomText extends StatelessWidget {
  final String Textdata;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const CustomText({
    Key? key,
    required this.Textdata,
    this.fontSize,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(Textdata,style: TextStyle(color: color?? (isDarkmodesaved? Colors.white:Colors.black45),fontSize:fontSize,fontWeight: fontWeight ),);
  }
}
class CustomblueContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? color;
  final double? width;
  final double? height;
  final double? Radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomblueContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.Radius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height??50,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: color ?? (isDarkmodesaved ? [Colors.indigo, Colors.deepPurple] : [Colors.lightBlue, Colors.indigo]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:BorderRadius.circular(Radius??25),
        boxShadow: [
          BoxShadow(
            color: isDarkmodesaved ? Color(0xff2C2C2C).withOpacity(0.2):  Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
}
Widget buildChoiceChip(BuildContext context, String choice, ChoiceChipState state) {
  bool isSelected = state is ChoiceChipSelected && state.selectedChoice == choice;

  return ChoiceChip(
    avatarBorder: CircleBorder(side: BorderSide.none),
    label: Text(choice),
    selected: isSelected,
    onSelected: (selected) {
      if (selected) {
        // Set the selected choice in the cubit
        context.read<ChoiceChipCubit>().changeChoice(choice);
      } else {
        // Optionally handle deselection
        context.read<ChoiceChipCubit>().changeChoice('');
      }
    },
    selectedColor: isDarkmodesaved ? Colors.deepPurple : Colors.blueAccent,
    checkmarkColor: Colors.white,
    backgroundColor: isSelected
        ? (isDarkmodesaved ? Colors.deepPurple : Colors.blueAccent)
        : (isDarkmodesaved ? Colors.grey[800] : Colors.grey[300]),
    labelStyle: TextStyle(
      color: isSelected
          ? Colors.white
          : (isDarkmodesaved ? Colors.white70 : Colors.black54),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
      side: BorderSide.none,
    ),
    shadowColor: Colors.black.withOpacity(0.2),
    elevation: 4,
  );
}
class ReusableTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String hintText;
  final String? Function(String?)? validator;
  final double? height;
  final double? width;
  final Color? fillColor;
  final Color? textColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? maxLenght;
  final TextInputType? keyboardType;
  final bool obscureText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextAlign? Align;
  final IconButton? prefixIconButton; // New prefix icon button

  const ReusableTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.height,
    this.width,
    this.fillColor = Colors.white,
    this.textColor = Colors.black54,
    this.hintStyle,
    this.textStyle,
    this.maxLines = 1,
    this.maxLenght = 999,
    this.keyboardType,
    this.obscureText = false,
    this.padding,
    this.margin,
    this.Align,
    this.prefixIconButton, // Initialize the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomwhiteContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: TextFormField(
         maxLength: maxLenght,
        buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
          return null; // Return null to hide the counter
        },
        textAlign: Align ?? TextAlign.left,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: prefixIconButton,
          hintStyle: hintStyle ?? TextStyle(
            color: isDarkmodesaved ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: textStyle ?? TextStyle(
          color: isDarkmodesaved ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}
class MedicalRecordsItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const MedicalRecordsItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomwhiteContainer(
        child:
        Column(
          children: [

          ],
        )
    );
  }
}
//..............................................................................
class PrescreptoinItem extends StatelessWidget {
  final Map<String, dynamic>  Prescreptoins;

  const PrescreptoinItem({
    Key? key,
    required this. Prescreptoins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: GestureDetector(
        child: CustomwhiteContainer(
          Radius: 12,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '  ${ Prescreptoins['drug_name'] }',
                  style: TextStyle(
                    color: isDarkmodesaved? Colors.white:Colors.black54,
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
class patientsitem extends StatelessWidget {
  final  patient;

  const patientsitem({
    Key? key,
    required this. patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomwhiteContainer(
              child: ExpansionTile(
                shape: BeveledRectangleBorder(side: BorderSide.none), showTrailingIcon: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(Textdata: '${patient['NAME']}',fontSize: 20,fontWeight: FontWeight.bold,),
                    CustomText(Textdata: 'Code: ${patient['PCODE']}'),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, bottom: 12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(Textdata:'Phone: ${patient['PHONE']}'),
                            // CustomText(Textdata:'Adress: ${patient['ADDRESS']}'),
                            CustomText(
                                Textdata: 'Birthdate: ${patient['BIRTH_DT'].substring(0, 10)}' ),
                            CustomText(
                              Textdata: patient['mal'] ? 'Gender: Male' : 'Gender: Female',),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
class Doctorsitem extends StatelessWidget {
  final  patient;

  const Doctorsitem({
    Key? key,
    required this. patient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomwhiteContainer(
              child: ExpansionTile(
                shape: BeveledRectangleBorder(side: BorderSide.none), showTrailingIcon: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(Textdata: '${patient['NAME']}',fontSize: 20,fontWeight: FontWeight.bold,),


                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, bottom: 12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(Textdata: 'Phone: ${patient['Mobile']}'),
                            CustomText(Textdata: 'code: ${patient['DOC']}' ),
                            CustomText(Textdata:'insp: ${patient['insip_name']}'),
                            CustomText(Textdata: 'email: ${patient['email']}' ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
class ExaminationItem extends StatelessWidget {
  final Map<String, dynamic>  Examination;

  const ExaminationItem({
    Key? key,
    required this. Examination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: GestureDetector(
        child: CustomwhiteContainer(
          Radius: 12,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '  ${ Examination['dis_name'] }',
                  style: TextStyle(
                    color: isDarkmodesaved? Colors.white:Colors.black54,
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
class ServiceItem extends StatelessWidget {
  final Map<String, dynamic>  Service;

  const ServiceItem({
    Key? key,
    required this. Service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: GestureDetector(
        child: CustomwhiteContainer(
          Radius: 12,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '  ${ Service['ser_name'] }',
                  style: TextStyle(
                    color: isDarkmodesaved? Colors.white:Colors.black54,
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
Color textcolor = isDarkmodesaved? Colors.white:Colors.black45;
Color invertedtextcolor = isDarkmode? Colors.black87:Colors.white;
Color? backgroundcolor = isDarkmodesaved ? Color(0xff232323) : Colors.grey[50];
Color? backgroundcolor2 = isDarkmode ? Color(0xff232323) : Colors.grey[50];
Color? invertedbackgroundcolor = isDarkmodesaved ?  Colors.grey[200]:Color(0xff232323) ;
class GlassyContainer extends StatelessWidget {
  final Widget child;
  final double? weidth;
  final double? height;

  GlassyContainer(
      {
        required this.child,
        this.weidth,
        this.height
      }

      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: weidth,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Slight transparent white background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: weidth,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Adjust opacity for more glass effect
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: child, // The content inside the glass container
            ),
          ),
        ),
      ],
    );
  }
}
