import 'package:app_ui/app_ui.dart'
    show AppSpacing, AppButton, AppColors, ScrollableColumn;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  static MaterialPageRoute<void> route() => MaterialPageRoute(
        builder: (_) => const UserProfilePage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc(context.read<UserRepository>()),
      child: const UserProfileView(),
    );
  }
}

@visibleForTesting
class UserProfileView extends StatelessWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProfileBloc>().state;
    final l10n = context.l10n;

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: const Key('userProfilePage_closeIcon'),
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ScrollableColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UserProfileTitle(),
            if (state is UserProfilePopulated) ...[
              UserProfileItem(
                leading: Assets.icons.profileIcon.svg(),
                title: state.user.email ?? '',
              ),
              const UserProfileLogoutButton(),
            ],
            const SizedBox(height: AppSpacing.lg),
            const _UserProfileDivider(),
            UserProfileSubtitle(
              subtitle: l10n.userProfileSettingsSubtitle,
            ),
            UserProfileItem(
              key: const Key('userProfilePage_notificationsItem'),
              leading: Assets.icons.notificationsIcon.svg(),
              title: l10n.userProfileSettingsNotificationsTitle,
              trailing: UserProfileSwitch(
                value: true,
                onChanged: (_) {},
              ),
            ),
            UserProfileItem(
              key: const Key('userProfilePage_notificationPreferencesItem'),
              title: l10n.userProfileSettingsNotificationPreferencesTitle,
              trailing: IconButton(
                key: const Key(
                  'userProfilePage_notificationPreferencesItem_trailing',
                ),
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
              ),
            ),
            const _UserProfileDivider(),
            UserProfileSubtitle(
              subtitle: l10n.userProfileLegalSubtitle,
            ),
            UserProfileItem(
              key: const Key('userProfilePage_termsOfUseAndPrivacyPolicyItem'),
              leading: Assets.icons.termsOfUseIcon.svg(),
              title: l10n.userProfileLegalTermsOfUseAndPrivacyPolicyTitle,
            ),
            UserProfileItem(
              key: const Key('userProfilePage_aboutItem'),
              leading: Assets.icons.aboutIcon.svg(),
              title: l10n.userProfileLegalAboutTitle,
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        context.l10n.userProfileTitle,
        style: theme.textTheme.headline3,
      ),
    );
  }
}

@visibleForTesting
class UserProfileSubtitle extends StatelessWidget {
  const UserProfileSubtitle({
    Key? key,
    required this.subtitle,
  }) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        subtitle,
        style: theme.textTheme.subtitle2,
      ),
    );
  }
}

@visibleForTesting
class UserProfileItem extends StatelessWidget {
  const UserProfileItem({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  static const _leadingWidth = AppSpacing.xxxlg + AppSpacing.sm;

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;

    return ListTile(
      dense: true,
      leading: SizedBox(
        width: hasLeading ? _leadingWidth : 0,
        child: leading,
      ),
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        hasLeading ? 0 : AppSpacing.xlg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      horizontalTitleGap: 0,
      minLeadingWidth: hasLeading ? _leadingWidth : 0,
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
              color: AppColors.highEmphasisSurface,
            ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileLogoutButton extends StatelessWidget {
  const UserProfileLogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxlg + AppSpacing.lg,
      ),
      child: AppButton.smallDarkAqua(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.logOutIcon.svg(),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n.userProfileLogoutButtonText),
          ],
        ),
        onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
      ),
    );
  }
}

class _UserProfileDivider extends StatelessWidget {
  const _UserProfileDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Divider(
        color: AppColors.borderOutline,
      ),
    );
  }
}