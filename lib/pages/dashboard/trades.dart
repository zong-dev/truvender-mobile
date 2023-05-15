import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class DashboardTradesPage extends StatefulWidget {
  const DashboardTradesPage({Key? key})
      : super(key: key);

  @override
  _DashboardTradesPageState createState() => _DashboardTradesPageState();
}

class _DashboardTradesPageState extends State<DashboardTradesPage> {
  late ScrollController _scrollController;
  bool isLoading = true;
  List trades = [];
  var tradeData = {};

  Map tradeSelector = {
    "sortBy": 'createdAt',
    "dateFrom": "",
    "dateTo": "",
    "page": 1,
    "type": '',
  };

  _loadTrades() {
    BlocProvider.of<ProfileCubit>(context).trades(
      page: tradeSelector['page'],
      dateFrom: tradeSelector['dateFrom'],
      dateTo: tradeSelector['dateTo'],
      type: tradeSelector['type'],
    );
  }

  _filterTrades(Map selectors) {}


  _loadMoreTrades() {
    if (tradeData['hasNextPage'] != null &&
        tradeData['hasNextPage'] == true) {
      setState(() {
        tradeSelector['page'] = tradeData['nextPage'];
      });
      _loadTrades();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTrades();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        _loadMoreTrades();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RequestSuccess) {
          setState(() {
            isLoading = false;
            tradeData = {
              ...state.responseData,
              'docs': [...trades, ...state.responseData['docs']]
            };
            trades = state.responseData['docs'] as List;
          });
        } else if (state is RequestFailed) {
          setState(() => isLoading = false);
        } else if (state is ProcessingRequest) {
          setState(() => isLoading = true);
        }
      },
      child: AppWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 13, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trades",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      openBottomSheet(
                        context: context,
                        child: FilterWidget(
                          onChange: (selector) => _filterTrades(selector),
                        ),
                        label: "Filter Trades",
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Filter",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                        horizontalSpacing(8),
                        Icon(
                          CustomIcons.filter_1,
                          color: Theme.of(context).accentColor,
                          size: 14,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            verticalSpacing(8),
            trades.isNotEmpty && !isLoading
                ? Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: trades.isNotEmpty ? trades.length : 4,
                      itemBuilder: (context, index) {
                        Trade trade = trades[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeTile(
                              trade: trade,
                            ),
                            isLoading && index == trades.length - 1
                                ? beforeLoad(): const SizedBox()
                          ],
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            isLoading && trades.isEmpty
                ? beforeLoad()
                : const SizedBox(),
            !isLoading && trades.isEmpty ? const Expanded(child: EmptyData(text: "No records found")) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
