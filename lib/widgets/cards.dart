import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/cubits/profile/profile_cubit.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/theme.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class HomeCard extends StatefulWidget {

  final double balance;
  final String currency;
  HomeCard(
      {Key? key,
      required this.balance,
      required this.currency})
      : super(key: key);

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  final StorageUtil storage = StorageUtil();

  String walletBalance = "";

  @override
  void initState() {
    super.initState();
    _displayAccountBalance();
  }

  _displayAccountBalance() async {
    String bal = await showOrHideBalance(
        "${widget.currency} ${moneyFormat(widget.balance)}");
    setState(() {
      walletBalance = bal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/images/card.png'),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(18),
        // color: Theme.of(context).colorScheme.primary.withGreen(45),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 28,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.rectangle_fill_on_rectangle_fill,
                  size: 28,
                  color: Colors.amber.shade600,
                ),
                horizontalSpacing(8),
                Text(
                  "Wallet Overview",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 28,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "Total Balance",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                    ),
                  ],
                ),
                verticalSpacing(12),
                Text(
                  walletBalance,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                ),
                verticalSpacing(12),
              ],
            ),
          ),
          Positioned(
            bottom: 28,
            left: 24,
            child: GestureDetector(
              onTap: () {
                context.pushNamed('dashboard', queryParams: {"index": '0'});
              },
              child: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.secoundaryLight,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border:
                      Border.all(width: 1, color: AppColors.secoundaryLight),
                ),
                child: Text(
                  'See Wallets',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletCard extends StatefulWidget {
  final Wallet wallet;
  final bool withActions;
  final bool isSelectable;
  final Function? onSwitchClicked;
  const WalletCard(
      {Key? key,
      required this.wallet,
      this.onSwitchClicked,
      this.withActions = false,
      this.isSelectable = false})
      : super(key: key);

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  String balance = "";
  late User user;
  @override
  void initState() {
    super.initState();
    _formatBalance();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
  }

  _formatBalance() async {
    String bal = await showOrHideBalance(widget.wallet.getFormattedAmount());
    setState(() {
      balance = bal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
            image: AssetImage('assets/images/card.png'),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 28,
            child: GestureDetector(
              onTap: () {
                if (widget.isSelectable && widget.onSwitchClicked != null) {
                  widget.onSwitchClicked!(context);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildIcon(widget.wallet, context),
                  horizontalSpacing(10),
                  Text(
                    user.currency ?? "",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                  horizontalSpacing(10),
                  widget.isSelectable
                      ? const Icon(
                          color: Colors.white70,
                          size: 22,
                          CupertinoIcons.arrowtriangle_down_square,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: widget.withActions ? 80 : 60,
            right: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Wallet Balance",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white70),
                ),
                verticalSpacing(8),
                Text(
                  balance,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          widget.withActions
              ? Positioned(
                  bottom: 20,
                  left: 24,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 96,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Button.light(
                          icon: CupertinoIcons.arrow_down_circle_fill,
                          foreground: AppColors.accent,
                          width: 84,
                          title:
                              widget.wallet.type == 1 ? 'Recieve' : 'Deposit',
                          height: 38,
                          fontSize: 11,
                          iconSize: 24,
                          onPressed: () {
                            context.pushNamed("wallet",
                                extra: widget.wallet,
                                queryParams: {"action": 'deposit'});
                          },
                        ),
                        horizontalSpacing(12),
                        Button.light(
                          icon: CupertinoIcons.arrow_up_circle_fill,
                          foreground: AppColors.accent,
                          width: 84,
                          height: 38,
                          fontSize: 11,
                          title: widget.wallet.type == 1 ? 'Send' : 'Withdraw',
                          iconSize: 24,
                          onPressed: () {
                            context.pushNamed("wallet",
                                extra: widget.wallet,
                                queryParams: {"action": 'withdraw'});
                          },
                        ),
                        horizontalSpacing(12),
                        Button.light(
                          icon:
                              CupertinoIcons.arrow_right_arrow_left_circle_fill,
                          foreground: AppColors.accent,
                          width: 84,
                          height: 38,
                          fontSize: 11,
                          title: widget.wallet.type == 1 ? 'Trade' : 'Transfer',
                          iconSize: 24,
                          onPressed: () {
                            if (widget.wallet.type == 0) {
                              context.pushNamed("wallet",
                                  extra: widget.wallet,
                                  queryParams: {"action": 'transfer'});
                            } else {}
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  _buildIcon(Wallet wallet, context) {
    return wallet.type == 0
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: AppColors.secoundaryLight,
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              wallet.getCurrencySymbol(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent),
            ),
          )
        : CircleAvatar(
            child: CachedNetworkImage(
              height: 34,
              width: 34,
              imageUrl: wallet.asset!.icon,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // child: Image(image: CachedNetworkImageProvider(url)),
          );
  }
}

class AccountHeader extends StatefulWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  late User user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AppBloc>(context).authenticatedUser;
  }

  ImagePicker picker = ImagePicker();

  _uploadAvatar() async {
    var image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ProfileCubit>(context)
          .changeAvatar(image: File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if(state is RequestSuccess){
          BlocProvider.of<AppBloc>(context).add(UserChanged());
        }
      },
      child: Container(
        alignment: Alignment.center,
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 24,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 78,
                  width: 78,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      height: 78,
                      width: 78,
                      fit: BoxFit.cover,
                      imageUrl: user.avatar!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                horizontalSpacing(12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    verticalSpacing(4),
                    Text(
                      user.email!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    verticalSpacing(10),
                    InkWell(
                      onTap: () => _uploadAvatar(),
                      child: Container(
                        width: 98,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.secoundaryLight,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                              width: 1, color: AppColors.secoundaryLight),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.photo_camera_solid,
                              size: 14,
                              color: AppColors.accent,
                            ),
                            horizontalSpacing(8),
                            Text(
                              'Change image',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () => context.pushNamed("support"),
              child: CircleAvatar(
                backgroundColor: AppColors.backgroundLight,
                child: Icon(
                  Icons.headset_mic_rounded,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class LoadingWallet extends StatelessWidget {
  const LoadingWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
            image: AssetImage('assets/images/wallet_pattern.png'),
            fit: BoxFit.cover),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.secoundaryLight,
        ),
      ),
    );
  }
}
