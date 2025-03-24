import 'package:database_project/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class ReportingPage extends StatefulWidget {
  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  String _selectedPeriod = 'today'; // Default period
  double _totalProfit = 0.0;
  int _totalItemsSold = 0;
  Map<String, int> _productSummary = {}; // Store product summary
  List<BarChartGroupData> _barData = []; // Store chart data

  int _saleMonth = 1; // Jan to default

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final report = await dataProvider.fetchSalesReport(_selectedPeriod);

    setState(() {
      // _totalProfit = report['totalProfit'];
      // _totalItemsSold = report['totalItemsSold'];
      // _productSummary = report['productSales'] ?? {};
      // _barData = _generateChartData(report['dailySales'] ?? {});
      _totalProfit = report['totalProfit'];
      _totalItemsSold = report['totalItemsSold'];
      _productSummary = report['productSummary'] ?? {}; // Correct key
      _barData = _generateChartData(report['dailySales'] ?? {});
    });
  }

  List<BarChartGroupData> _generateChartData(Map<String, double> dailySales) {
    print("Raw Daily Sales Data: $dailySales"); // Debugging

    // Sort the sales data by date (key)
    var sortedEntries = dailySales.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by date (ascending)

    // Generate chart data
    return sortedEntries
        .map((entry) {
          List<String> parts = entry.key.split('-'); // Ensure correct format
          int day = 0;
          int month = 0;

          // Debugging to check how the date is split
          print("Parsed Date: ${entry.key} -> Parts: $parts");

          if (parts.length == 3) {
            // If the date is in YYYY-MM-DD format
            day = int.tryParse(parts[2]) ?? 0; // Day is at index 2
            month = int.tryParse(parts[1]) ?? 0; // Month is at index 1

            // Ensure that the month is valid (1-12)
            if (month < 1 || month > 12) {
              print(
                  "Invalid month value detected: $month in date ${entry.key}");
              month = 1; // Default to January if month is invalid
            }
            // Store the correct month value in _currentMonth
            _saleMonth = month;
          } else {
            print("Invalid date format: ${entry.key}");
            return null; // Invalid date format, returning null to be filtered later
          }

          return BarChartGroupData(
            x: day, // Using the day of the month for X-axis
            barRods: [BarChartRodData(toY: entry.value, color: Colors.blue)],
          );
        })
        .whereType<BarChartGroupData>()
        .toList(); // Filter out null values
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return months[month - 1]; // Get the correct month name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedPeriod,
              onChanged: (newValue) {
                setState(() {
                  _selectedPeriod = newValue!;
                });
                _fetchReport();
              },
              items: ['today', 'this_week', 'this_month', 'this_year']
                  .map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period.replaceAll('_', ' ').toUpperCase()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Text Summary
            // Card(
            //   elevation: 4,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Report for ${_selectedPeriod.replaceAll('_', ' ')}',
            //           style:
            //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 10),
            //         Text(
            //           'Total Profit: \$${_totalProfit.toStringAsFixed(2)}',
            //           style: TextStyle(fontSize: 16),
            //         ),
            //         Text(
            //           'Items Sold: $_totalItemsSold',
            //           style: TextStyle(fontSize: 16),
            //         ),
            //         Divider(),
            //         // Display product summary (variations and their quantities sold)
            //         ..._productSummary.entries.map((entry) {
            //           String size = entry.key; // The size (variation)
            //           int quantitySold =
            //               entry.value; // Quantity sold for that size

            //           return Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               // Display size (variation) and quantity sold
            //               Text(
            //                 '$size - Quantity Sold: $quantitySold',
            //                 style: TextStyle(
            //                     fontSize: 16, fontWeight: FontWeight.bold),
            //               ),
            //               SizedBox(height: 5),
            //             ],
            //           );
            //         }).toList(),
            //       ],
            //     ),
            //   ),
            // ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report for ${_selectedPeriod.replaceAll('_', ' ')}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Profit: \$${_totalProfit.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Items Sold: $_totalItemsSold',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    // Display product summary (variations and their quantities sold)
                    ..._productSummary.entries.map((entry) {
                      String productName =
                          entry.key.split(' - ')[0]; // Extract the product name
                      String size =
                          entry.key.split(' - ')[1]; // Extract the size
                      int quantitySold = entry
                          .value; // Quantity sold for that product and size

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display product name, size (variation), and quantity sold
                          Text(
                            '$productName - $size - Quantity Sold: $quantitySold',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Sales Chart
            Expanded(child: _buildChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _totalProfit * 1.2, // Slightly higher than max profit for spacing
        barGroups: _barData,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int day = value.toInt(); // This is the day value
                int month = _saleMonth;
                // Use both month and day to format the X-axis title
                String date =
                    '${_getMonthName(month)} $day'; // Format as Month Day
                return Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(date,
                      style: TextStyle(fontSize: 12)), // Show Month and Day
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
