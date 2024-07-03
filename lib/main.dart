import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Harga Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoPriceScreen(),
    );
  }
}

class CryptoPriceScreen extends StatefulWidget {
  @override
  _CryptoPriceScreenState createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen> {
  List<dynamic> cryptoData = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));
    if (response.statusCode == 200) {
      setState(() {
        cryptoData = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Crypto'),
      ),
      body: cryptoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: cryptoData.length,
        itemBuilder: (context, index) {
          final crypto = cryptoData[index];
          return ListTile(
            title: Text(crypto['name']),
            subtitle: Text('Symbol: ${crypto['symbol']}'),
            trailing: Text('\$${crypto['price_usd']}'),
          );
        },
      ),
    );
  }
}