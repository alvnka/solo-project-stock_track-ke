import 'package:stock_track_ke/import/imports.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = "Stock track ke"});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  String _sortField = 'company_name';
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock track KE'),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CompanyDetailsPage(
                                companyName: company['company_name']),
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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


/* import 'package:stock_track_ke/import/imports.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = "Stock track ke"});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = true;
  String _sortField = 'company_name';
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock track KE'),
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
            final List<Map<String, dynamic>> sortedData =
                List.castFrom<dynamic, Map<String, dynamic>>(
                    data.values.toList());

            final filteredData = sortedData
                .where((company) =>
                    company['company_name'].toLowerCase().contains(_searchText))
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
                  Center(child: Text('No companies found')),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CompanyDetailsPage(
                                companyName: company['company_name']),
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
 */