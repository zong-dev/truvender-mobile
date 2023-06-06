// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class DashboardWalletPage extends StatefulWidget {
  const DashboardWalletPage({Key? key})
      : super(key: key);

  @override
  _DashboardWalletPageState createState() => _DashboardWalletPageState();
}

class _DashboardWalletPageState extends State<DashboardWalletPage> {
  late ScrollController _scrollController;
  bool loadingTransactions = true;
  bool isLoading = true;
  Map transactionSelector = {
    "sortBy": 'createdAt',
    "dateFrom": "",
    "dateTo": "",
    "page": 1,
  };

  int walletIndex = 0;
  List wallets = [];
  Wallet? wallet;

  List<Map<String, dynamic>> filteredActions = [];
  List transactions = [];
  var transactionData = {};

  _loadTransactions() {
    BlocProvider.of<ProfileCubit>(context).transactions(
      walletId: wallet!.id, page: transactionSelector['page'], 
      dateFrom: transactionSelector['dateFrom'], dateTo: transactionSelector['dateTo'])
    ;
  }

  _filterActions() {
    for (var action in actions) {
      if (action['ofWallet'] == true) {
        filteredActions.add(action);
      }
    }
  }

  filterTransactions(selector){
    setState(() {
      loadingTransactions = true;
      transactionData = {};
    });
    BlocProvider.of<ProfileCubit>(context).transactions(
        walletId: wallet!.id,
        page: transactionSelector['page'],
        dateFrom: transactionSelector['dateFrom'],
        dateTo: transactionSelector['dateTo']);
  }

  _loadMoreTransactions(){
    setState(() {
      loadingTransactions = true;
    });
    if (transactionData['hasNextPage'] != null && transactionData['hasNextPage'] == true) {
      setState(() {
        transactionSelector['page'] = transactionData['nextPage'];
      });
      _loadTransactions();
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).wallets();
    _filterActions();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.95 && !loadingTransactions){
          _loadMoreTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    showPickerModal(ctx) {
      showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
          actions: [
            Container(
              // color: Theme.of(context).colorScheme.background.withOpacity(.8),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: MediaQuery.of(context).size.height / 5,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: 0),
                itemExtent: 48,
                onSelectedItemChanged: (index) {
                  setState(() {
                    walletIndex = index;
                    wallet = wallets[walletIndex];
                  });
                },
                children: wallets
                    .map(
                      (item) => Center(
                        child: Text(
                          item.currency,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RequestSuccess) {
          if (state.isSubProccess) {
            setState(() {
              loadingTransactions = false;
              transactionData = { ...state.responseData, 'docs': [ ...transactions, ...state.responseData['docs']]};
              transactions = state.responseData['docs'] as List;
            });
          } else {
            setState(() {
              isLoading = false;
              wallets = state.responseData;
              wallet = wallets[walletIndex];
            });
            _loadTransactions();
          }
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return !isLoading
              ? AppWrapper(
                  topSpace: 24,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28, bottom: 13, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Wallets",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      wallet == null
                          ? const LoadingWallet()
                          : WalletCard(
                              wallet: wallet!,
                              onSwitchClicked: showPickerModal,
                              withActions: true,
                              isSelectable: true,
                            ),
                      verticalSpacing(20),
                      wallet != null && wallet!.type == 0
                          ? SizedBox(
                              height: 128,
                              child: GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 26),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: true,
                                itemCount: filteredActions.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 4,
                                ),
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () => determinUtilRoute(
                                      context, filteredActions[index]['route']),
                                  child: Container(
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: AppColors.secoundaryLight,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 221, 250),
                                            offset: Offset(0.0, 1), //(x,y)
                                            blurRadius: .6,
                                            spreadRadius: -1,
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            filteredActions[index]['image'],
                                            color: AppColors.accent,
                                            size: 24,
                                          ),
                                          horizontalSpacing(8),
                                          Text(
                                            filteredActions[index]['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 14,
                                                  color: AppColors.accent,
                                                ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      verticalSpacing(14),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 26, bottom: 8, top: 8, right: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Activities",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                            ),
                            InkWell(
                              onTap: () {
                                openBottomSheet(
                                   height: 520,
                                    context: context,
                                    child: FilterWidget(
                                      onChange: (selector) => filterTransactions(selector),
                                    ),
                                    label: "Filter Transactions");
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
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
                      transactions.isNotEmpty && !loadingTransactions
                          ? Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                physics: const ClampingScrollPhysics(),
                                itemCount: transactions.isNotEmpty
                                    ? transactions.length
                                    : 4,
                                itemBuilder: (context, index) {
                                  if (transactions.isNotEmpty) {
                                    Transaction transaction =
                                        transactions[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ActivityTile(
                                          transaction: transaction,
                                        ),
                                        loadingTransactions &&
                                                index == transactions.length - 1
                                            ?  beforeLoad()
                                            : const SizedBox()
                                      ],
                                    );
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                      loadingTransactions && transactions.isEmpty ? beforeLoad() : const SizedBox(),
                      !loadingTransactions && transactions.isEmpty ?  const Expanded(child:  EmptyData(text: "No Transactions Yet")) : const SizedBox()
                    ],
                  ),
                )
              : const LoadingWidget();
        },
      ),
    );
  }
}
