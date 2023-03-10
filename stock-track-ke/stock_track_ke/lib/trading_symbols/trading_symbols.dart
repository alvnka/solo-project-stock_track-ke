import 'package:stock_track_ke/import/imports.dart';

class TradingSymbolsPage extends StatefulWidget {
  @override
  State<TradingSymbolsPage> createState() => _TradingSymbolsPageState();
}

class _TradingSymbolsPageState extends State<TradingSymbolsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  String _sortField = 'company_name';

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
                              _sortAscending = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('NSE Closing (ascending)'),
                          onTap: () {
                            setState(() {
                              _sortField = 'nseclosing';
                              _sortAscending = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('NSE Closing (descending)'),
                          onTap: () {
                            setState(() {
                              _sortField = 'nseclosing';
                              _sortAscending = false;
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
            final List<Map<String, dynamic>> sortedData = List.castFrom<dynamic,
                Map<String, dynamic>>(data.values.toList())
              ..where((element) {
                final searchTerm = _searchController.text.trim().toLowerCase();
                final companyName =
                    element['company_name'].toString().toLowerCase();
                final tradingSymbol =
                    element['trading_symbol'].toString().toLowerCase();
                return companyName.contains(searchTerm) ||
                    tradingSymbol.contains(searchTerm);
              })
              ..toList()
              ..sort((a, b) {
                final searchTerm = _searchController.text.trim().toLowerCase();
                final companyNameA = a['company_name'].toString().toLowerCase();
                final companyNameB = b['company_name'].toString().toLowerCase();
                final tradingSymbolA =
                    a['trading_symbol'].toString().toLowerCase();
                final tradingSymbolB =
                    b['trading_symbol'].toString().toLowerCase();

                // Assign a score based on how closely the item matches the search term
                int scoreA = 0, scoreB = 0;
                if (companyNameA.contains(searchTerm)) {
                  scoreA += 2;
                } else if (companyNameA.startsWith(searchTerm)) {
                  scoreA += 1;
                }
                if (tradingSymbolA.contains(searchTerm)) {
                  scoreA += 1;
                }
                if (companyNameB.contains(searchTerm)) {
                  scoreB += 2;
                } else if (companyNameB.startsWith(searchTerm)) {
                  scoreB += 1;
                }
                if (tradingSymbolB.contains(searchTerm)) {
                  scoreB += 1;
                }

                // Sort the items based on their scores
                if (scoreA != scoreB) {
                  return scoreB - scoreA;
                } else {
                  if (_sortField == 'company_name') {
                    return _sortAscending
                        ? a[_sortField].compareTo(b[_sortField])
                        : b[_sortField].compareTo(a[_sortField]);
                  } else if (_sortField == 'nseclosing') {
                    final double? aVal = double.tryParse(a[_sortField]);
                    final double? bVal = double.tryParse(b[_sortField]);
                    if (aVal == null && bVal == null) {
                      return 0;
                    } else if (aVal == null) {
                      return _sortAscending ? 1 : -1;
                    } else if (bVal == null) {
                      return _sortAscending ? -1 : 1;
                    } else {
                      return _sortAscending
                          ? aVal.compareTo(bVal)
                          : bVal.compareTo(aVal);
                    }
                  } else {
                    return 0;
                  }
                }
              });

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
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                  child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
                children: List.generate(data.length, (index) {
                  final company = data.values.elementAt(index);
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NSE Closing:',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${company['nseclosing'] ?? ''}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              ],
                            ),
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