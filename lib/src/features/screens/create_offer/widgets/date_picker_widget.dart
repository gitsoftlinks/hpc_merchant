// ignore_for_file: deprecated_colon_for_default_value



// class DatePickerWidget {
//   CreateOfferViewModel get viewModel => sl();

//   // Future show(
//   //     {required DateTime initialDateTime,
//   //     required DateTime minimumDate,
//   //     required DateTime maximumDate,
//   //     required bool isEndDate}) async {
//   //   return showDialog(
//   //     context: navigatorKeyGlobal.currentContext!,
//   //     // enableDrag: false,
//   //     // isScrollControlled: true,
//   //     // backgroundColor:
//   //     //     Theme.of(navigatorKeyGlobal.currentContext!).scaffoldBackgroundColor,
//   //     // isDismissible: false,
//   //     // shape: RoundedRectangleBorder(
//   //     //   borderRadius: BorderRadius.vertical(top: kBottomSheetRadius),
//   //     // ),
//   //     builder: (BuildContext context) {
//   //       return GestureDetector(
//   //         onTap: () =>
//   //             FocusScope.of(navigatorKeyGlobal.currentContext!).unfocus(),
//   //         child: SizedBox(
//   //           //  height: 0.35.sh,
//   //           child: Stack(
//   //             children: [
//   //               _showDatePicker(navigatorKeyGlobal.currentContext!,
//   //                   initialDateTime, minimumDate, maximumDate, isEndDate),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   _showDatePicker(BuildContext context, DateTime initialDateTime,
//       DateTime minimumDate, DateTime maximumDate, bool isEndDate) {
//     return Form(
//       child: Column(
//         children: [
//           // Flexible(
//              showDialog(
//         context: context,
//         builder: (_) => SomeCalendar(
//           mode: SomeMode.Single,
//           isWithoutDialog: false,
//           selectedDate: selectedDate,
//           labels: new Labels(
//               dialogDone: 'Selesai',
//               dialogCancel: 'Batal',
//               dialogRangeFirstDate: 'Tanggal Pertama',
//               dialogRangeLastDate: 'Tanggal Terakhir',
//           ),
//           startDate: Jiffy().subtract(years: 3),
//           lastDate: Jiffy().add(months: 9),
//           done: (date) {
//             setState(() {
//               selectedDate = date;
//               showSnackbar(selectedDate.toString());
//             });
//           },
//         ));
//           //  ),
//         ],
//       ),
//     );
//   }
// }
