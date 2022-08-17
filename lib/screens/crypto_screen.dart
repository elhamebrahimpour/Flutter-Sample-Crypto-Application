import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_v1/data/api/get_data.dart';
import 'package:crypto_v1/data/constants/color_constants.dart';
import 'package:crypto_v1/data/models/crypto_model.dart';
import 'package:crypto_v1/provider/change_icon.dart';
import 'package:crypto_v1/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CryptoScreen extends StatefulWidget {
  CryptoScreen({Key? key}) : super(key: key);

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<Crypto> cryptoList = [];
  bool _isListUpdated = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

//get data from api
  void _getData() async {
    try {
      List<Crypto> _cryptoList = await getData();
      setState(() {
        cryptoList = _cryptoList;
      });
    } catch (e) {
      Text('Something went wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'قیمت لحظه‌ای رمز ارزها',
          style: TextStyle(color: lightTeal),
        ),
        actions: [
          SwapIconTheme(),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        _getSearchTextField(),
        Visibility(
          visible: _isListUpdated,
          child: Text(
            'در حال آپدیت لیست ...',
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 40, bottom: 12, top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assets',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 14),
              ),
              Text(
                'Change(24Hz)',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 14),
              )
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: greenColor,
            color: whiteColor,
            onRefresh: (() async {
              return _getData();
            }),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (cryptoList.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.waveDots(
                        color: greenColor, size: 60.0),
                  );
                } else {
                  return ListView.separated(
                    itemCount: cryptoList.length,
                    itemBuilder: (((context, index) {
                      return _getListTileItems(cryptoList[index]);
                    })),
                    separatorBuilder: (context, index) => const Divider(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _getListTileItems(Crypto crypto) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CryptoDetails(
            crypto: crypto,
          ),
        ),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 28.0,
          child: Center(
            child: Text(
              crypto.rank.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        title: _getTitleRow(crypto),
        trailing: _getTrailingRow(crypto),
      ),
    );
  }

  Widget _getTitleRow(Crypto crypto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(crypto.symbol, style: Theme.of(context).textTheme.subtitle1),
              Text(
                crypto.name,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ),
        Spacer(),
        SizedBox(
          width: 35,
          height: 15,
          child: Sparkline(
            data: crypto.changePercent24Hr <= 0
                ? [0.0]
                : [
                    crypto.priceUsd,
                    crypto.supply,
                    0.0,
                    0.0,
                    crypto.volumeUsd24Hr,
                  ],
            lineWidth: 1,
            lineColor: _getChangePercentColor24Hr(crypto.changePercent24Hr),
          ),
        )
      ],
    );
  }

  Widget _getTrailingRow(Crypto crypto) {
    return SizedBox(
      width: 140.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$' + crypto.priceUsd.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 14),
              ),
              SizedBox(height: 6),
              Text(
                crypto.changePercent24Hr.toStringAsFixed(2),
                style: TextStyle(
                  color: _getChangePercentColor24Hr(crypto.changePercent24Hr),
                ),
              )
            ],
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: _getIconChangeColor(crypto.changePercent24Hr),
            ),
          )
        ],
      ),
    );
  }

  _getIconChangeColor(double changePercent) {
    return changePercent <= 0
        ? Icon(Icons.trending_down, color: redColor)
        : Icon(Icons.trending_up, color: greenColor);
  }

  _getChangePercentColor24Hr(double changePercent) {
    return changePercent <= 0 ? redColor : greenColor;
  }

  Widget _getSearchTextField() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            contentPadding: EdgeInsets.all(12),
            hintText: 'جستجوی رمز ارز...',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(fontSize: 16.0, color: lightTeal),
            filled: true,
            fillColor: darkTeal),
        onChanged: ((value) {
          _onSearchAction(value);
        }),
      ),
    );
  }

  Future<void> _onSearchAction(String keyWord) async {
    List<Crypto> _filteredList = [];
    if (keyWord.isEmpty) {
      setState(() {
        _isListUpdated = true;
      });
      List<Crypto> _updatedList = await getData();
      setState(() {
        cryptoList = _updatedList;
        _isListUpdated = false;
      });
      FocusScope.of(context).unfocus();
      return;
    }
    _filteredList = cryptoList
        .where((element) =>
            element.name.toLowerCase().contains(keyWord.toLowerCase()))
        .toList();
    setState(() {
      cryptoList = _filteredList;
    });
  }
}
