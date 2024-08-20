// Autocomplete<String>(
// optionsBuilder: (TextEditingValue textEditingValue) {
// if (textEditingValue.text == '') {
// return const Iterable<String>.empty();
// }
// return userNames.where((String option) {
// return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
// });
// },
// onSelected: (String selection) {
// cubit.selectUser(selection);
// },
// fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
// return TextField(
// controller: controller,
// focusNode: focusNode,
// decoration: InputDecoration(
// contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// hintText: "Select User",
// hintStyle: TextStyle(color: Colors.grey[600]),
// filled: true,
// fillColor: Colors.white,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12),
// borderSide: BorderSide.none,
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12),
// borderSide: BorderSide(color: Colors.blueAccent, width: 2),
// ),
// ),
// );
// },
// );
//..............................................................................