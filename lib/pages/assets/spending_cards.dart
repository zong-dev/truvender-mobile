import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class SpendingCardsPage extends StatefulWidget {
  const SpendingCardsPage({Key? key}) : super(key: key);

  @override
  _SpendingCardsPageState createState() => _SpendingCardsPageState();
}

class _SpendingCardsPageState extends State<SpendingCardsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Spending> items = [];
  List<Spending> filteredItems = [];

  bool loadingItems = true;

  @override
  void initState() {
    super.initState();
    _setLoadingState();
  }

  _setLoadingState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadingItems = false;
      });
    });
  }

  void filterItems() {
    List<Spending> results = items
        .where((giftcard) => giftcard.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
    setState(() {
      filteredItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: "Spending Cards",
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            TextInput(
              label: 'Search Spending Card Name',
              type: TextInputType.text,
              controller: _searchController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              bordered: true,
              iconPreffix: Icon(
                CupertinoIcons.search,
                size: 22,
                color: Theme.of(context).accentColor,
              ),
            ),
            verticalSpacing(30),
            Expanded(
              child: loadingItems || filteredItems.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      physics: const ClampingScrollPhysics(),
                      itemCount: filteredItems.isEmpty ? 6 : filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        double itemDiff = index % 2;
                        if (!loadingItems && filteredItems.isNotEmpty) {
                          var card = filteredItems[index];
                          return GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width / 2) - 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: (itemDiff > 0)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 118,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        height: 108,
                                        width: double.maxFinite,
                                        fit: BoxFit.cover,
                                        imageUrl: card.image,
                                        placeholder: (context, url) =>
                                            const ShimmerWidget.rounded(
                                          height: 108,
                                          width: double.maxFinite,
                                          shapedBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  verticalSpacing(8),
                                  Text(
                                    card.name,
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
                            ),
                          );
                        } else {
                          return beforeCardLoad(context, itemDiff);
                        }
                      })
                  : const EmptyData(text: "No Spending Card Found"),
            )
          ],
        ),
      ),
    );
  }
}
