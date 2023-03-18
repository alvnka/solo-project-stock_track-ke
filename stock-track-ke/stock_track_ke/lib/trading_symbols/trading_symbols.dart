import 'package:stock_track_ke/import/imports.dart';

class TradingSymbolsPage extends StatefulWidget {
  const TradingSymbolsPage({super.key});

  @override
  State<TradingSymbolsPage> createState() => _TradingSymbolsPageState();
}

class _TradingSymbolsPageState extends State<TradingSymbolsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  String _sortField = 'company_name';
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trading symbols'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sort by'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Company name'),
                          onTap: () {
                            setState(() {
                              _sortField = 'company_name';
                              _sortAscending = !_sortAscending;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('company_info')
              .doc('company_info')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data?.data() as Map<String, dynamic>;
            final List<Map<String, dynamic>> unsortedData =
                List.castFrom<dynamic, Map<String, dynamic>>(
                    data.values.toList());

            final List<Map<String, dynamic>> sortedData =
                List.from(unsortedData);

            if (_sortField == 'company_name') {
              sortedData.sort((a, b) => _sortAscending
                  ? a[_sortField].compareTo(b[_sortField])
                  : b[_sortField].compareTo(a[_sortField]));
            } else if (_sortField == 'nseclosing') {
              sortedData.sort((a, b) {
                final aValue = a[_sortField];
                final bValue = b[_sortField];

                // Compare the length of the values
                final lengthComparison = aValue.length.compareTo(bValue.length);

                // If the length is the same, compare the values themselves
                if (lengthComparison == 0) {
                  return _sortAscending
                      ? aValue.compareTo(bValue)
                      : bValue.compareTo(aValue);
                }

                // Otherwise, return the result of comparing the lengths
                return _sortAscending ? lengthComparison : -lengthComparison;
              });
            }

            final filteredData = sortedData
                .where((company) =>
                    company['company_name']
                        .toLowerCase()
                        .contains(_searchText) ||
                    company['trading_symbol']
                        .toLowerCase()
                        .contains(_searchText))
                .toList();

            if (filteredData.isEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by company name',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value.toLowerCase().trim();
                        });
                      },
                    ),
                  ),
                  Center(child: Text('No companies or Symbols found')),
                ],
              );
            }

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by company name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.toLowerCase().trim();
                    });
                  },
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                  children: List.generate(filteredData.length, (index) {
                    final company = filteredData[index];
                    return Container(
                      width: 40,
                      height: 80,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(1, 2),
                            blurRadius: 3,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company['company_name'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                company['trading_symbol'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ]);
          }),
    );
  }
}


/* class TradingSymbolsPage extends StatefulWidget {
  @override
  State<TradingSymbolsPage> createState() => _TradingSymbolsPageState();
}

class _TradingSymbolsPageState extends State<TradingSymbolsPage> {
  /* final CollectionReference _companyCollection =
      FirebaseFirestore.instance.collection('company_info'); */
  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    final docRef = db.collection('company_info').doc("company_info");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        /* data.forEach((key, value) {
          print('$key:');
          print('Company Name: ${value['company_name']}');
          print('Trading Symbol: ${value['trading_symbol']}');
          print('NSE Closing: ${value['nseclosing']}');
          print('NSE Change: ${value['nsechange']}');
          print('Image URL: ${value['image_url']}');
          print('Time Stamp: ${value['time_stamp']}');
          print('-------------------------------------------');
        }); */
        ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final company = data.values.elementAt(index);
            return Card(
              child: ListTile(
                leading: company['image_url'] != null
                    ? Image.network(
                        company['image_url'],
                        width: 50,
                        height: 50,
                      )
                    : Container(),
                title: Text(company['company_name'] ?? ''),
                subtitle: Text(company['trading_symbol'] ?? ''),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'NSE Closing:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${company['nseclosing'] ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NSE Change:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${company['nsechange'] ?? ''}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
end here*/

/* class Company {
  final String? company_name;
  final String? trading_symbol;
  final int? nseclosing;
  final int? nsechange;
  final String? time_stamp;
  final String? image_url;

  Company({
    this.company_name,
    this.trading_symbol,
    this.nseclosing,
    this.nsechange,
    this.time_stamp,
    this.image_url,
  });

  factory Company.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Company(
      company_name: data?['company_name'],
      trading_symbol: data?['trading_symbol'],
      nseclosing: data?['nseclosing'],
      nsechange: data?['nsechange'],
      time_stamp: data?['time_stamp'],
      image_url: data?['image_url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (company_name != null) "company_name": company_name,
      if (trading_symbol != null) "trading_symbol": trading_symbol,
      if (nseclosing != null) "nseclosing": nseclosing,
      if (nsechange != null) "nsechange": nsechange,
      if (time_stamp != null) "time_stamp": time_stamp,
      if (image_url != null) "image_url": image_url,
    };
  }
}

import 'package:stock_track_ke/import/imports.dart';

class TradingSymbolsPage extends StatefulWidget {
  @override
  State<TradingSymbolsPage> createState() => _TradingSymbolsPageState();
}

class _TradingSymbolsPageState extends State<TradingSymbolsPage> {
  final CollectionReference _companyCollection =
      FirebaseFirestore.instance.collection('company_info');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trading Symbols'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _companyCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;
          print('Snapshot data:');
          docs.forEach((doc) => print(doc.data()));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>?;
              return _buildTradingSymbolWidget(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildTradingSymbolWidget(Map<String, dynamic>? data) {
    final imageUrl = data?['image_url'] ?? '';
    final tradingSymbol = data?['trading_symbol] ?? '';
    final companyName = data?['company_name'] ?? '';
    final nseChange = data?['nsechange'] ?? '';
    final nseClosing = data?['nseclosing'] ?? '';
    final timeStamp = data?['time_stamp'] ?? '';

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            tradingSymbol,
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 8.0),
          Text(
            companyName,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            nseChange,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            nseClosing,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            timeStamp,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
*/