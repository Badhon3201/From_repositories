import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:testkj/feature/repositories/repository.dart';

import 'download_file/view/from_download_screen.dart';
import 'feature/view_models/view_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    FlutterLocalNotificationsPlugin flutterNotificationPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel ID',
      'channel name',
      playSound: true,
      importance: Importance.max,
    );
    await flutterNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterNotificationPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        onDidReceiveNotificationResponse: notificationTapBackground);
  } catch (e) {
    debugPrint(e.toString());
  }
  Get.lazyPut(() => StudentRepository(), fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const DownloadPage(title: 'Download'),
    );
  }
}

Future<void> notificationTapBackground(
    NotificationResponse notificationResponse) async {
  final ViewModels downloadingDialog = Get.find();
  OpenFile.open(downloadingDialog.path.value);
}

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = false;
  String? _fileFullPath;
  String? progress;
  var url = "http://www.pdf995.com/samples/pdf.pdf";

  Dio? dio;

  @override
  void initState() {
    dio = Dio();
    super.initState();
  }

  Future<List<Directory>?> _getExternalStoragePath() async {
    return p.getExternalStorageDirectories(type: p.StorageDirectory.documents);
  }

  Future _downloadAndSaveFileToStorage(
      String? urlPath, String? fileName) async {
    try {
      final dirList = await _getExternalStoragePath();
      final path = dirList![0].path;
      final file = File("$path/$fileName");
      await dio?.download(urlPath!, file.path, onReceiveProgress: (rec, total) {
        setState(() {
          _isLoading = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + " %";
          print(progress);
        });
      });
      _fileFullPath = file.path;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Download'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // RaisedButton()
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expandable Demo"),
      ),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Card1(),
            // Card2(),
            // Card3(),
          ],
        ),
      ),
    );
  }
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "ExpandablePanel",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                collapsed: Text(
                  loremIpsum,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var _ in Iterable.generate(5))
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            loremIpsum,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          )),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ));
    }

    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 150);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded2() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightGreenAccent, 100)),
              Expanded(child: buildImg(Colors.orange, 100)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightBlue, 100)),
              Expanded(child: buildImg(Colors.cyan, 100)),
            ],
          ),
        ],
      );
    }

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              loremIpsum,
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expandable(
                collapsed: buildCollapsed1(),
                expanded: buildExpanded1(),
              ),
              Expandable(
                collapsed: buildCollapsed2(),
                expanded: buildExpanded2(),
              ),
              Expandable(
                collapsed: buildCollapsed3(),
                expanded: buildExpanded3(),
              ),
              Divider(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true)!;
                      return TextButton(
                        child: Text(
                          controller.expanded ? "COLLAPSE" : "EXPAND",
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in [1, 2, 3, 4]) buildItem("Item ${i}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Items",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() {
//   runApp(
//     MaterialApp(
//       title: 'Reading and Writing Files',
//       home: FlutterDemo(storage: CounterStorage()),
//     ),
//   );
// }
//
// class CounterStorage {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/counter.txt');
//   }
//
//   Future<int> readCounter() async {
//     try {
//       final file = await _localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//
//       return int.parse(contents);
//     } catch (e) {
//       // If encountering an error, return 0
//       return 0;
//     }
//   }
//
//   Future<File> writeCounter(int counter) async {
//     final file = await _localFile;
//
//     // Write the file
//     return file.writeAsString('$counter');
//   }
// }
//
// class FlutterDemo extends StatefulWidget {
//   const FlutterDemo({Key? key, required this.storage}) : super(key: key);
//
//   final CounterStorage storage;
//
//   @override
//   _FlutterDemoState createState() => _FlutterDemoState();
// }
//
// class _FlutterDemoState extends State<FlutterDemo> {
//   int _counter = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.storage.readCounter().then((int value) {
//       setState(() {
//         _counter = value;
//       });
//     });
//   }
//
//   Future<File> _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//
//     // Write the variable as a string to the file.
//     return widget.storage.writeCounter(_counter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reading and Writing Files'),
//       ),
//       body: Center(
//         child: Text(
//           'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
//

// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const CompleteForm(),
//     );
//   }
// }
//
// class CompleteForm extends StatefulWidget {
//   const CompleteForm({Key? key}) : super(key: key);
//
//   @override
//   State<CompleteForm> createState() {
//     return _CompleteFormState();
//   }
// }
//
// class _CompleteFormState extends State<CompleteForm> {
//   bool autoValidate = true;
//   bool readOnly = false;
//   bool showSegmentedControl = true;
//   final _formKey = GlobalKey<FormBuilderState>();
//   bool _ageHasError = false;
//   bool _genderHasError = false;
//
//   var genderOptions = ['Male', 'Female', 'Other'];
//
//   void _onChanged(dynamic val) => debugPrint(val.toString());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Form Builder Example')),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               FormBuilder(
//                 key: _formKey,
//                 // enabled: false,
//                 onChanged: () {
//                   _formKey.currentState!.save();
//                   debugPrint(_formKey.currentState!.value.toString());
//                 },
//                 autovalidateMode: AutovalidateMode.disabled,
//                 initialValue: const {
//                   'movie_rating': 5,
//                   'best_language': 'Dart',
//                   'age': '13',
//                   'gender': 'Male',
//                   'languages_filter': ['Dart']
//                 },
//                 skipDisabled: true,
//                 child: Column(
//                   children: <Widget>[
//                     const SizedBox(height: 15),
//                     FormBuilderDateTimePicker(
//                       name: 'date',
//                       initialEntryMode: DatePickerEntryMode.calendar,
//                       initialValue: DateTime.now(),
//                       inputType: InputType.both,
//                       decoration: InputDecoration(
//                         labelText: 'Appointment Time',
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () {
//                             _formKey.currentState!.fields['date']
//                                 ?.didChange(null);
//                           },
//                         ),
//                       ),
//                       initialTime: const TimeOfDay(hour: 8, minute: 0),
//                       // locale: const Locale.fromSubtags(languageCode: 'fr'),
//                     ),
//                     FormBuilderDateRangePicker(
//                       name: 'date_range',
//                       firstDate: DateTime(1970),
//                       lastDate: DateTime(2030),
//                       format: DateFormat('yyyy-MM-dd'),
//                       onChanged: _onChanged,
//                       decoration: InputDecoration(
//                         labelText: 'Date Range',
//                         helperText: 'Helper text',
//                         hintText: 'Hint text',
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () {
//                             _formKey.currentState!.fields['date_range']
//                                 ?.didChange(null);
//                           },
//                         ),
//                       ),
//                     ),
//                     FormBuilderSlider(
//                       name: 'slider',
//                       // validator: FormBuilderValidators.compose([
//                       //   FormBuilderValidators.min(6),
//                       // ]),
//                       onChanged: _onChanged,
//                       min: 0.0,
//                       max: 10.0,
//                       initialValue: 7.0,
//                       divisions: 20,
//                       activeColor: Colors.red,
//                       inactiveColor: Colors.pink[100],
//                       decoration: const InputDecoration(
//                         labelText: 'Number of things',
//                       ),
//                     ),
//                     FormBuilderRangeSlider(
//                       name: 'range_slider',
//                       // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
//                       onChanged: _onChanged,
//                       min: 0.0,
//                       max: 100.0,
//                       initialValue: const RangeValues(4, 7),
//                       divisions: 20,
//                       activeColor: Colors.red,
//                       inactiveColor: Colors.pink[100],
//                       decoration:
//                           const InputDecoration(labelText: 'Price Range'),
//                     ),
//                     FormBuilderCheckbox(
//                       name: 'accept_terms',
//                       initialValue: false,
//                       onChanged: _onChanged,
//                       title: RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'I have read and agree to the ',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             TextSpan(
//                               text: 'Terms and Conditions',
//                               style: TextStyle(color: Colors.blue),
//                               // Flutter doesn't allow a button inside a button
//                               // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
//                               /*
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   print('launch url');
//                                 },
//                               */
//                             ),
//                           ],
//                         ),
//                       ),
//                       // validator: FormBuilderValidators.equal(
//                       //   true,
//                       //   errorText:
//                       //       'You must accept terms and conditions to continue',
//                       // ),
//                     ),
//                     FormBuilderTextField(
//                       autovalidateMode: AutovalidateMode.always,
//                       name: 'age',
//                       decoration: InputDecoration(
//                         labelText: 'Age',
//                         suffixIcon: _ageHasError
//                             ? const Icon(Icons.error, color: Colors.red)
//                             : const Icon(Icons.check, color: Colors.green),
//                       ),
//                       onChanged: (val) {
//                         setState(() {
//                           _ageHasError = !(_formKey.currentState?.fields['age']
//                                   ?.validate() ??
//                               false);
//                         });
//                       },
//                       // valueTransformer: (text) => num.tryParse(text),
//                       // validator: FormBuilderValidators.compose([
//                       //   FormBuilderValidators.required(),
//                       //   FormBuilderValidators.numeric(),
//                       //   FormBuilderValidators.max(70),
//                       // ]),
//                       // initialValue: '12',
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                     ),
//                     FormBuilderDropdown<String>(
//                       // autovalidate: true,
//                       name: 'gender',
//                       decoration: InputDecoration(
//                         labelText: 'Gender',
//                         suffix: _genderHasError
//                             ? const Icon(Icons.error)
//                             : const Icon(Icons.check),
//                         hintText: 'Select Gender',
//                       ),
//                       // validator: FormBuilderValidators.compose(
//                       //     [FormBuilderValidators.required()]),
//                       items: genderOptions
//                           .map((gender) => DropdownMenuItem(
//                                 alignment: AlignmentDirectional.center,
//                                 value: gender,
//                                 child: Text(gender),
//                               ))
//                           .toList(),
//                       onChanged: (val) {
//                         setState(() {
//                           _genderHasError = !(_formKey
//                                   .currentState?.fields['gender']
//                                   ?.validate() ??
//                               false);
//                         });
//                       },
//                       valueTransformer: (val) => val?.toString(),
//                     ),
//                     FormBuilderRadioGroup<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'My chosen language',
//                       ),
//                       initialValue: null,
//                       name: 'best_language',
//                       onChanged: _onChanged,
//                       // validator: FormBuilderValidators.compose(
//                       //     [FormBuilderValidators.required()]),
//                       options:
//                           ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
//                               .map((lang) => FormBuilderFieldOption(
//                                     value: lang,
//                                     child: Text(lang),
//                                   ))
//                               .toList(growable: false),
//                       controlAffinity: ControlAffinity.trailing,
//                     ),
//                     FormBuilderSegmentedControl(
//                       decoration: const InputDecoration(
//                         labelText: 'Movie Rating (Archer)',
//                       ),
//                       name: 'movie_rating',
//                       // initialValue: 1,
//                       // textStyle: TextStyle(fontWeight: FontWeight.bold),
//                       options: List.generate(5, (i) => i + 1)
//                           .map((number) => FormBuilderFieldOption(
//                                 value: number,
//                                 child: Text(
//                                   number.toString(),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ))
//                           .toList(),
//                       onChanged: _onChanged,
//                     ),
//                     FormBuilderSwitch(
//                       title: const Text('I Accept the terms and conditions'),
//                       name: 'accept_terms_switch',
//                       initialValue: true,
//                       onChanged: _onChanged,
//                     ),
//                     FormBuilderCheckboxGroup<String>(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       decoration: const InputDecoration(
//                           labelText: 'The language of my people'),
//                       name: 'languages',
//                       // initialValue: const ['Dart'],
//                       options: const [
//                         FormBuilderFieldOption(value: 'Dart'),
//                         FormBuilderFieldOption(value: 'Kotlin'),
//                         FormBuilderFieldOption(value: 'Java'),
//                         FormBuilderFieldOption(value: 'Swift'),
//                         FormBuilderFieldOption(value: 'Objective-C'),
//                       ],
//                       onChanged: _onChanged,
//                       separator: const VerticalDivider(
//                         width: 10,
//                         thickness: 5,
//                         color: Colors.red,
//                       ),
//                       // validator: FormBuilderValidators.compose([
//                       //   FormBuilderValidators.minLength(1),
//                       //   FormBuilderValidators.maxLength(3),
//                       // ]),
//                     ),
//                     FormBuilderFilterChip<String>(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       decoration: const InputDecoration(
//                           labelText: 'The language of my people'),
//                       name: 'languages_filter',
//                       selectedColor: Colors.red,
//                       options: const [
//                         FormBuilderChipOption(
//                           value: 'Dart',
//                           avatar: CircleAvatar(child: Text('D')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Kotlin',
//                           avatar: CircleAvatar(child: Text('K')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Java',
//                           avatar: CircleAvatar(child: Text('J')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Swift',
//                           avatar: CircleAvatar(child: Text('S')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Objective-C',
//                           avatar: CircleAvatar(child: Text('O')),
//                         ),
//                       ],
//                       onChanged: _onChanged,
//                       // validator: FormBuilderValidators.compose([
//                       //   FormBuilderValidators.minLength(1),
//                       //   FormBuilderValidators.maxLength(3),
//                       // ]),
//                     ),
//                     FormBuilderChoiceChip<String>(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       decoration: const InputDecoration(
//                           labelText:
//                               'Ok, if I had to choose one language, it would be:'),
//                       name: 'languages_choice',
//                       initialValue: 'Dart',
//                       options: const [
//                         FormBuilderChipOption(
//                           value: 'Dart',
//                           avatar: CircleAvatar(child: Text('D')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Kotlin',
//                           avatar: CircleAvatar(child: Text('K')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Java',
//                           avatar: CircleAvatar(child: Text('J')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Swift',
//                           avatar: CircleAvatar(child: Text('S')),
//                         ),
//                         FormBuilderChipOption(
//                           value: 'Objective-C',
//                           avatar: CircleAvatar(child: Text('O')),
//                         ),
//                       ],
//                       onChanged: _onChanged,
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState?.saveAndValidate() ?? false) {
//                           debugPrint(_formKey.currentState?.value.toString());
//                         } else {
//                           debugPrint(_formKey.currentState?.value.toString());
//                           debugPrint('validation failed');
//                         }
//                       },
//                       child: const Text(
//                         'Submit',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         _formKey.currentState?.reset();
//                       },
//                       // color: Theme.of(context).colorScheme.secondary,
//                       child: Text(
//                         'Reset',
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.secondary),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool isLoading = true;
//   String pathPDF = "";
//   String landscapePathPdf = "";
//   String remotePDFpath = "";
//   String corruptedPathPDF = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     createFileOfPdfUrl().then((f) {
//       setState(() {
//         remotePDFpath = f.path;
//       });
//     });
//   }
//
//   Future<File> createFileOfPdfUrl() async {
//     Completer<File> completer = Completer();
//     print("Start download file from internet!");
//     try {
//       // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
//       // final url = "https://pdfkit.org/docs/guide.pdf";
//       const url = "http://www.pdf995.com/samples/pdf.pdf";
//       final filename = url.substring(url.lastIndexOf("/") + 1);
//       var request = await HttpClient().getUrl(Uri.parse(url));
//       var response = await request.close();
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       var dir = await getApplicationDocumentsDirectory();
//       print("Download files");
//       print("${dir.path}/$filename");
//       File file = File("${dir.path}/$filename");
//
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file!');
//     }
//
//     return completer.future;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PDF View',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Plugin example app')),
//         body: Center(child: Builder(
//           builder: (BuildContext context) {
//             return Column(
//               children: <Widget>[
//                 TextButton(
//                   child: const Text("Remote PDF"),
//                   onPressed: () {
//                     if (remotePDFpath.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFScreen(path: remotePDFpath),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             );
//           },
//         )),
//       ),
//     );
//   }
// }
//
// class PDFScreen extends StatefulWidget {
//   final String? path;
//
//   const PDFScreen({Key? key, this.path}) : super(key: key);
//
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//       Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             enableSwipe: true,
//             swipeHorizontal: true,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             defaultPage: currentPage!,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation:
//                 false, // if set to true the link is handled in flutter
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String? uri) {
//               print('goto uri: $uri');
//             },
//             onPageChanged: (int? page, int? total) {
//               print('page change: $page/$total');
//               setState(() {
//                 currentPage = page;
//               });
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//                   ? const Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : Container()
//               : Center(
//                   child: Text(errorMessage),
//                 )
//         ],
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _controller.future,
//         builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               label: Text("Go to ${pages! ~/ 2}"),
//               onPressed: () async {
//                 await snapshot.data!.setPage(pages! ~/ 2);
//               },
//             );
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   static List<Tab> myTabs = <Tab>[
//     const Tab(
//       child: Text('Info'),
//     ),
//     const Tab(
//       child: Text('M&E'),
//     ),
//     const Tab(
//       child: Text('Score'),
//     ),
//     const Tab(
//       child: Text('Subject'),
//     ),
//     const Tab(
//       child: Text('Group'),
//     ),
//     // Tab(
//     //   child: Text('Complain',style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 13),),
//     // ),
//     const Tab(
//       text: 'Syllabus',
//       // child: Text('Syllabus'),
//     ),
//     const Tab(
//       text: 'Cash Transfer',
//       // child: Text('Cash Transfer'),
//     ),
//     const Tab(
//       // child: Text('Attendance'),
//       text: 'Attendance',
//     ),
//     const Tab(
//       // child: Text('CMC'),
//       text: 'CMC',
//     ),
//   ];
//   int _counter = 0;
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _tabController = TabController(vsync: this, length: myTabs.length);
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(widget.title),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             height: height * 0.15,
//             color: Colors.blue,
//             child: Builder(builder: (context) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       _tabController.index == 0
//                           ? const SizedBox()
//                           : IconButton(
//                               icon: const Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 setState(() {});
//                                 if (_tabController.index > 0) {
//                                   _tabController
//                                       .animateTo(_tabController.index - 1);
//                                 } else {
//                                   Scaffold.of(context)
//                                       .showSnackBar(const SnackBar(
//                                     content: Text("Can't go back"),
//                                   ));
//                                 }
//                               },
//                             ),
//                       Expanded(
//                         child: TabBar(
//                           isScrollable: true,
//                           controller: _tabController,
//                           labelStyle: const TextStyle(color: Colors.white),
//                           unselectedLabelColor: Colors.white,
//                           labelColor: Colors.white,
//                           tabs: List.generate(
//                             myTabs.length,
//                             (index) {
//                               return Tab(
//                                 child: myTabs[index],
//                                 // text: "${myTabs[index].text}",
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       _tabController.index == 8
//                           ? const SizedBox()
//                           : IconButton(
//                               icon: const Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 setState(() {});
//                                 if (_tabController.index + 1 < 20) {
//                                   _tabController
//                                       .animateTo(_tabController.index + 1);
//                                 } else {
//                                   Scaffold.of(context)
//                                       .showSnackBar(const SnackBar(
//                                     content: Text("Can't move forward"),
//                                   ));
//                                 }
//                               },
//                             ),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//           ),
//           Container(
//             height: height * 0.5,
//             color: Colors.red,
//             child: TabBarView(
//               physics: const NeverScrollableScrollPhysics(),
//               controller: _tabController,
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 50,
//                           width: 300,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text('BBBBBBB'),
//                 Text('CCCCCCC'),
//                 Text('DDDDDDD'),
//                 Text('EEEEEEE'),
//                 Text('FFFFFFF'),
//                 Text('AAAAAAA'),
//                 Text('AAAAAAA'),
//                 Text('AAAAAAA'),
//                 // MAndEWidget(),
//                 // ScoreWidgets(),
//                 // SubjectWidget(),
//                 // GroupWidget(),
//                 // // Center(
//                 // //   child: Text("It's sunny here"),
//                 // // ),
//                 // SyllabusWidget(),
//                 // CashTransferWidgets(),
//                 // AttendanceWidget(),
//                 // CMCWidget()
//               ],
//             ),
//           ),
//           // const Text(
//           //   'You have pushed the button this many times:',
//           // ),
//           // Text(
//           //   '$_counter',
//           //   style: Theme.of(context).textTheme.headline4,
//           // ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
