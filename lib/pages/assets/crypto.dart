import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class CryptoAssetsPage extends StatefulWidget {
  const CryptoAssetsPage({Key? key}) : super(key: key);

  @override
  _CryptoAssetsPageState createState() => _CryptoAssetsPageState();
}

class _CryptoAssetsPageState extends State<CryptoAssetsPage> {
  List<Crypto> cryptocurrencies = [];
  bool fetchingCrypto = true;

  @override
  void initState() {
    super.initState();
    _setLoadingState();
  }

  _setLoadingState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        fetchingCrypto = false;
      });
    });
  }

  SizedBox beforCrypoLoad() => SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:  ShimmerWidget.rounded(
                height: 130,
                width: double.maxFinite,
                shapedBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            verticalSpacing(8),
            ShimmerWidget.rectangle(
              height: 18,
              width: (MediaQuery.of(context).size.width / 2.48) - 40,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: 'Crypto currencies',
      child: Column(
        children: [
          Expanded(
            child: fetchingCrypto || cryptocurrencies.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    physics: const ClampingScrollPhysics(),
                    itemCount:
                        cryptocurrencies.isEmpty ? 6 : cryptocurrencies.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (!fetchingCrypto && cryptocurrencies.isNotEmpty) {
                        Crypto crypto = cryptocurrencies[index];
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) - 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 130,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(1000)),
                                    child: CachedNetworkImage(
                                      height: 130,
                                      width: double.maxFinite,
                                      fit: BoxFit.cover,
                                      imageUrl: crypto.icon,
                                      placeholder: (context, url) =>
                                          const ShimmerWidget.rounded(
                                        height: 130,
                                        width: double.maxFinite,
                                        shapedBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(8)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              verticalSpacing(8),
                              Text(
                                "${crypto.name} (${crypto.symbol})",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14.8,
                                        fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      } else {
                        return beforCrypoLoad();
                      }
                    },
                  )
                : const EmptyData(text: "No Crypto Currency Found"),
          ),
        ],
      ),
    );
  }
}
