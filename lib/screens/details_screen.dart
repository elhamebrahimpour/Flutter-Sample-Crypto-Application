import 'dart:ui';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_v1/data/constants/color_constants.dart';
import 'package:crypto_v1/data/models/crypto_model.dart';
import 'package:crypto_v1/provider/change_icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class CryptoDetails extends StatefulWidget {
  CryptoDetails({Key? key, this.crypto}) : super(key: key);
  Crypto? crypto;
  @override
  State<CryptoDetails> createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  Crypto? crypto;

  @override
  void initState() {
    super.initState();
    crypto = widget.crypto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          crypto!.symbol,
          style: TextStyle(color: lightTeal),
        ),
        actions: [
          SwapIconTheme(),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _getTopContainerContent(),
            _getBottomConatinerContent(),
          ],
        ),
      ),
    );
  }

  Widget _getTopContainerContent() {
    return Container(
      height: MediaQuery.of(context).size.height * .42,
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 38,
          ),
          Text(crypto!.name + ' Price',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('\$' + crypto!.priceUsd.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headline1!),
          SizedBox(
            height: 42,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _get24HrCotainer(
                  '24Hr Price',
                  '\$' + crypto!.volumeUsd24Hr.toStringAsFixed(2),
                  darkGreyColor),
              SizedBox(
                width: 12,
              ),
              _get24HrCotainer(
                'Change(24Hr)',
                crypto!.changePercent24Hr.toStringAsFixed(2),
                _getChangePercentColor24Hr(crypto!.changePercent24Hr),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _get24HrCotainer(String str1, String str2, Color textColor) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 86,
          width: 180,
          decoration: BoxDecoration(
            gradient: containerGradient,
            borderRadius: BorderRadius.circular(15),
          ),
          //color: Color(0xff152B3C),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  str1,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.bold, color: darkGreyColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  str2,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: textColor, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBottomConatinerContent() {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * .50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          gradient: containerGradient,
          color: whiteColor,
        ),
        child: Column(
          children: [
            _getSparkLine(),
            Spacer(),
            Link(
              uri: Uri.parse('https://coincap.io/'),
              builder: ((context, followLink) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: darkGreyColor,
                      maximumSize: Size(200, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => followLink,
                    child: Text(
                      'دریافت اطلاعات بیشتر',
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSparkLine() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 40, bottom: 40),
          child: Sparkline(
            data: [
              crypto!.priceUsd,
              crypto!.supply,
              0.0,
              0.0,
              crypto!.volumeUsd24Hr,
            ],
            useCubicSmoothing: true,
            cubicSmoothingFactor: 0.2,
            gridLinelabelPrefix: '\$ ',
            gridLineLabelPrecision: 2,
            gridLineColor: lightGreyColor,
            gridLineLabelColor: darkGreyColor,
            enableGridLines: true,
            lineWidth: 2,
            lineColor: _getChangePercentColor24Hr(crypto!.changePercent24Hr),
          ),
        ),
        Text(
          'تغییرات در 24 ساعت گذشته',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(fontSize: 18, color: darkGreyColor),
        )
      ],
    );
  }

  _getChangePercentColor24Hr(double changePercent) {
    return changePercent <= 0 ? redColor : greenColor;
  }
}
