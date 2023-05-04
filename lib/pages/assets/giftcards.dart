import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class GiftcardAssetsPage extends StatefulWidget {
  const GiftcardAssetsPage({Key? key}) : super(key: key);

  @override
  _GiftcardAssetsPageState createState() => _GiftcardAssetsPageState();
}

class _GiftcardAssetsPageState extends State<GiftcardAssetsPage> {
  final TextEditingController _searchController = TextEditingController();
  late ScrollController _scrollController;
  bool isLoading = false;
  Map requestData = {};
  List<Giftcard> giftcards = [];
  List<Giftcard> filteredGiftcards = [];
  bool loadingGiftcards = true;

  Map selector = {
    "page": 1,
  };

  @override
  void initState() {
    super.initState();
    _fetchCards();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        _loadMoreCards();
      }
    });
  }

  _fetchCards() {
    BlocProvider.of<AssetCubit>(context).loadGiftcards(
      page: selector['page'],
      query: _searchController.text,
    );
  }

  void filtereCards() {
    List<Giftcard> results = giftcards
        .where((giftcard) => giftcard.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
    setState(() {
      filteredGiftcards = results;
    });
  }

  _loadMoreCards() {
    if (requestData['hasNextPage'] != null && requestData['hasNextPage'] == true) {
      setState(() {
        selector['page'] = requestData['nextPage'];
      });
      _fetchCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listener: (context, state) {
        if(state is AssetLoading){
          setState(() => isLoading = true);
        }else if(state is AssetLoaded){
          setState(() {
            isLoading = false;
            requestData = { ...state.data, 'docs': [ ...giftcards, ...state.data['docs']]};
            giftcards = requestData['docs'];
          });
          filtereCards();
        }else if (state is AssetLoadingFialed){
          setState(() => isLoading = false);
        }
      },
      child: Wrapper(
        title: "Trade Giftcards",
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextInput(
                label: 'Search Giftcard',
                type: TextInputType.text,
                controller: _searchController,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                bordered: true,
                iconPreffix: Icon(
                  CupertinoIcons.search,
                  size: 22,
                  color: Theme.of(context).accentColor,
                ),
              ),
              verticalSpacing(30),
              Expanded(
                child: isLoading || filteredGiftcards.isNotEmpty
                    ? GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        physics: const ClampingScrollPhysics(),
                        itemCount: filteredGiftcards.isEmpty
                            ? 6
                            : filteredGiftcards.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          double itemDiff = index % 2;
                          if (!isLoading &&
                              filteredGiftcards.isNotEmpty) {
                            var card = filteredGiftcards[index];
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed('asset', extra: card, queryParams: { "type": "giftcard"});
                              },
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    40,
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
                                            shapedBorder:
                                                RoundedRectangleBorder(
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
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 14.8,
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if(isLoading && index == giftcards.length -1) {
                            return beforeCardLoad(context, itemDiff);
                          }
                        })
                    : const EmptyData(text: "No Giftcards Found"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
