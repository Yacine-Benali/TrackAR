// Divider(height: 0.5),
// Container(
//   color: AppColors.tileColor,
//   child: SwitchListTile(
//     contentPadding: const EdgeInsets.all(0.0),
//     title: const Text('Save'),
//     value: shouldSave,
//     activeColor: AppColors.primaryColor,
//     onChanged: (bool value) async {
//       if (shouldSave == true && value == false) {
//         bloc.shouldSave = false;
//         final d = DateTime.now();
//         try {
//           await pr.show();
//           await Future.delayed(
//               Duration(seconds: 1));
//           String name =
//               '${d.hour}-${d.minute}-${d.second}.xlsx';

//           File file =
//               await storage.getLocalFile(name);
//           await excel.encode().then((onValue) {
//             file
//               ..createSync(recursive: true)
//               ..writeAsBytesSync(onValue);
//           });
//           print('*************');
//           print(file.path);
//           print('**********');
//           int sheetRows = sheetObject.maxRows;
//           for (int i = sheetRows - 1; i > 0; i--)
//             sheetObject.removeRow(i);

//           await pr.hide();
//           PlatformReportDialog(filePath: file.path)
//               .show(context);
//         } on Exception catch (e) {
//           await pr.hide();
//           PlatformAlertDialog(
//             title: 'Operation Failed',
//             content: 'something went wrong',
//             defaultActionText: 'Ok',
//           ).show(context);
//         }
//         setState(() => shouldSave = value);
//       } else if (shouldSave == false &&
//           value == true) {
//         bloc.shouldSave = true;
//         setState(() => shouldSave = value);
//       }
//     },
//   ),
// ),
