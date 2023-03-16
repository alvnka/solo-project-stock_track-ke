import 'package:stock_track_ke/import/imports.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CompanyDetailsPage extends StatefulWidget {
  final String companyName;

  CompanyDetailsPage({required this.companyName});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late List<TimeSeriesSales> data;

  @override
  void initState() {
    super.initState();
    data = [];
    _getData();
  }

  void _getData() async {
    print(widget.companyName);
    DocumentSnapshot companyDoc = await FirebaseFirestore.instance
        .collection('Individual_companies')
        .doc(widget.companyName)
        .get();
    if (companyDoc.exists && companyDoc.data() != null) {
      var data = companyDoc.data()!;
      if (data is Map<String, dynamic>) {
        List<dynamic> nseclosingList = data['nseclosing'];
        List<dynamic> timestampList = data['time_stamp'];
        print (nseclosingList);
        print(timestampList);
        Map<DateTime, double> closingPrices = {};
        for (int i = 0; i < nseclosingList.length; i++) {
          int index = i;
          var timestampData = timestampList[index] as Map<String, dynamic>?;
          if (timestampData != null && timestampData.containsKey('time')) {
            var timestamp = timestampData['time'] as Timestamp;
            closingPrices[DateTime.fromMillisecondsSinceEpoch(
                timestamp.millisecondsSinceEpoch)] = (nseclosingList[index]
                        as Map<String, dynamic>?)?['closing_price']
                    ?.toDouble() ??
                0.0;
          }
        }
        setState(() {
          data = closingPrices.entries
              .map((entry) => TimeSeriesSales(entry.key, entry.value))
              .toList();
        });
      } else {
        print('Company data is not of expected type.');
      }
    } else {
      print('Company data does not exist.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: charts.TimeSeriesChart(
                [
                  charts.Series<TimeSeriesSales, DateTime>(
                    id: 'nseclosing',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (TimeSeriesSales sales, _) => sales.time,
                    measureFn: (TimeSeriesSales sales, _) => sales.closingPrice,
                    data: data,
                  )
                ],
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: set tracking function
              },
              child: Text('Set Track'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double closingPrice;

  TimeSeriesSales(this.time, this.closingPrice);

  factory TimeSeriesSales.fromMap(Map<String, dynamic> map) {
    return TimeSeriesSales(
      DateTime.parse(map['time_stamp'] as String),
      (map['nseclosing'] as Map<String, dynamic>)['0'] as double,
    );
  }
}


/* class CompanyDetailsPage extends StatefulWidget {
  final String companyName;

  CompanyDetailsPage({required this.companyName});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late List<TimeSeriesSales> data;

  @override
  void initState() {
    super.initState();
    data = [];
    _getData();
  }

void _getData() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Individual_companies')
      .doc(widget.companyName)
      .collection('nseclosing')
      .get();
  setState(() {
    data = snapshot.docs
        .map((document) => TimeSeriesSales.fromMap(document.data() as Map<String, dynamic>))
        .toList();
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: charts.TimeSeriesChart(
                [
                  charts.Series<TimeSeriesSales, DateTime>(
                    id: 'nseclosing',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (TimeSeriesSales sales, _) => sales.time,
                    measureFn: (TimeSeriesSales sales, _) => sales.closingPrice,

                    data: data,
                  )
                ],
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: set tracking function
              },
              child: Text('Set Track'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double closingPrice;

  TimeSeriesSales(this.time, this.closingPrice);

  factory TimeSeriesSales.fromMap(Map<String, dynamic> map) {
    return TimeSeriesSales(
      DateTime.parse(map['time_stamp'] as String),
      (map['nseclosing'] as Map<String, dynamic>)['0'] as double,
    );
  }
}
 */