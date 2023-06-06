import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/data/models/user.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({
    super.key,
  });

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  late User user;
  Map<String, dynamic>? accountData;
  bool isLoading = false;
  double balance = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).dashboard();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RequestSuccess) {
          setState(() {
            accountData = state.responseData;
            balance = double.parse("${accountData!['balance'] ?? 0}");
            isLoading = false;
          });
        } else if (state is ProcessingRequest) {
          setState(() {
            isLoading = true;
          });
        } else if (state is RequestFailed) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: AppWrapper(
        child: !isLoading
            ? Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome ${user.username}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).accentColor,
                                  ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.push('/notification'),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.9),
                            child: const Icon(
                              CupertinoIcons.bell_fill,
                                size: 16,
                                color: AppColors.backgroundLight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpacing(14),
                  Center(
                    child: Container(
                      height: 180.0,
                      margin: const EdgeInsets.only(top: 12),
                      child: HomeCard(
                        currency: user.currency!,
                        balance: balance,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 28, bottom: 13, top: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quick Action",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      itemCount: actions.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) {
                        var action = actions[index];
                        Widget icon = action['name'] != "Perfect money"
                            ? Icon(
                                action['image'],
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.9),
                                size: 24,
                              )
                            : Image.asset(
                                action['image'],
                                width: 24,
                                height: 24,
                              );
                        return QuickAction(
                          name: action['name'],
                          icon: icon,
                          context: context,
                          onTap: () {
                            String route = action['route'];
                            determinUtilRoute(context, route);
                          },
                        );
                      },
                    ),
                  ),
                  verticalSpacing(10),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, bottom: 13, top: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Operations",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: tradables.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8),
                      itemBuilder: (context, index) {
                        var item = tradables[index];
                        return OperationTile(
                          title: item['name'],
                          subTitle: item['description'],
                          icon: item['icon'],
                          onTap: () {
                            String route = item['route'].toString();
                            if (route.isNotEmpty) {
                              if (route != 'virtualNumber') {
                                context.pushNamed("assets",
                                    queryParams: {"type": route});
                              } else {
                                context.pushNamed("virtualNumber");
                              }
                            }
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            : const LoadingWidget(),
      ),
    );
  }
}
