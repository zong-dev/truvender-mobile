import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/cubits/asset/asset_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class FundsPage extends StatefulWidget {
  const FundsPage({Key? key}) : super(key: key);

  @override
  _FundsPageState createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  bool loadingItems = true;
  List<Fundz> items = [];
  @override
  void initState() {
    super.initState();
    _setLoadingState();
  }

  _setLoadingState() {
    BlocProvider.of<AssetCubit>(context).loadTradableFunds();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCubit, AssetState>(
      listener: (context, state) {
        if (state is AssetLoading) {
          setState(() => loadingItems = true);
        } else if (state is AssetLoaded) {
          setState(() {
            loadingItems = false;
            items = state.data;
          });
        } else if (state is AssetLoadingFialed) {
          setState(() => loadingItems = false);
        }
      },
      child: Wrapper(
        title: "Other assets",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: loadingItems || items.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        physics: const ClampingScrollPhysics(),
                        itemCount: items.isEmpty ? 2 : items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          double itemDiff = index % 2;
                          if (!loadingItems && items.isNotEmpty) {
                            var card = items[index];
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed("asset",
                                    queryParams: {
                                      "type": "funds",
                                    },
                                    extra: card);
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
                          } else {
                            return beforeCardLoad(context, itemDiff);
                          }
                        })
                    : const EmptyData(text: "No Spending Card Found"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
