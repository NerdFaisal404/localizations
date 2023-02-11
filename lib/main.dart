import 'dart:io';

import 'package:flutter/material.dart';

import 'app_locales.dart';
import 'lang/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: 'assets/translations',
      startLocale: AppLocales.english,
      fallbackLocale: AppLocales.english,
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Counter App',
        home: MyHomePage('Counter App Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool hasLongPressedText = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<String> _downloadSurahAudioFile(
      {required String url, required String savePath}) async {
    Dio dio = new Dio();
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: "Downloading",
        progressType: ProgressType.valuable,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        progressValueColor: Theme.of(context).dialogBackgroundColor,
        progressBgColor: Theme.of(context).primaryColor,
        msgColor: Theme.of(context).primaryColor,
        valueColor: Theme.of(context).primaryColor);
    Response response = await dio.get(
      url,
      //Received data with List<int>
      onReceiveProgress: (rec, total) {
        int progress = (((rec / total) * 100).toInt());
        pd.update(value: progress);
      },
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    pd.close();
    print('dio-headers ${response.headers}');
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return raf.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        key: const Key('drawer'),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // Provide a Key to this specific Text Widget. This allows us
              // to identify this specific Widget from inside our test suite and
              // read the text.
              key: const Key('counter'),
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              key: Key('openPage2'),
              onLongPress: () {
                Future.delayed(
                    Duration(seconds: 12),
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PageTwo()),
                        ));
              },
              onPressed: () async {
                Directory _appDocumentsDirectory =
                    await getApplicationDocumentsDirectory();
                // print(_appDocumentsDirectory.absolute.path);

                Directory directory = Directory("lang/");
                print(directory.path);
                _downloadSurahAudioFile(
                        url: "https://tmpfiles.org/dl/922932/en.json",
                        savePath: "${_appDocumentsDirectory.path}/en11.json")
                    .then((value) async {
                  //await context.setLocale(Locale('en'));
                  AppLocalizations.of(context)!.load();
                  Future.delayed(Duration(seconds: 3));
                  setState(() {});
                });
              },
              child: Text(
                  AppLocalizations.of(context)!.translate().drawer.drawerTitle),
            ),
            GestureDetector(
              onLongPress: () {
                setState(() {
                  hasLongPressedText = true;
                });
              },
              child: Container(
                color:
                    hasLongPressedText ? Colors.blueGrey : Colors.transparent,
                child: Text(
                  hasLongPressedText
                      ? 'Text has been long pressed!'
                      : 'Text that has not been long pressed',
                  key: const Key('longPressText'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide a Key to this the button. This allows us to find this
        // specific button and tap it inside the test suite.
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('pageTwo'),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Page 2'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Contents of page 2'),
        ),
      ),
    );
  }
}
