import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import '../utils/validators.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glow_background.dart';
import '../widgets/login_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/remember_forgot_row.dart';
import '../widgets/social_login_button.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: 43,
              left: 0,
              right: 0,
              child: Center(child: GlowBackground()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 91, 26, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: [
                      const LoginHeader(),
                      const SizedBox(height: 39),
                      _buildFormCard(context, vm),
                      const SizedBox(height: 42),
                      SocialLoginSection(
                        onPressed: vm.isLoading
                            ? null
                            : (provider) => vm.loginWithSocial(provider.name),
                      ),
                      const SizedBox(height: 48),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, LoginViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 38, 24, 34),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Form(
        key: vm.formKey,
        child: Column(
          children: [
            CustomTextField(
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              prefixAsset: AppAssets.email,
              prefixSize: const Size(16.67, 16.67),
              controller: vm.emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: 18),
            CustomTextField(
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHint,
              prefixAsset: AppAssets.lock,
              prefixSize: const Size(13.33, 17.5),
              controller: vm.passwordController,
              obscureText: vm.obscurePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              suffix: Tooltip(
                message: vm.obscurePassword
                    ? AppStrings.showPassword
                    : AppStrings.hidePassword,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: vm.togglePasswordVisibility,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 13, 4),
                    child: SvgPicture.asset(
                      AppAssets.eye,
                      width: 18.33,
                      height: 12.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            RememberForgotRow(
              rememberMe: vm.rememberMe,
              onRememberChanged: vm.toggleRememberMe,
              onForgotPressed: () {},
            ),
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(vm.errorMessage!, style: AppTextStyles.error),
              ),
            ],
            const SizedBox(height: 26),
            PrimaryButton(
              text: AppStrings.login,
              trailingAsset: AppAssets.arrowRight,
              isLoading: vm.isLoading,
              onPressed: () async {
                final ok = await vm.login();
                if (ok && context.mounted) {
                  // TODO: navigasi ke halaman beranda
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.noAccount, style: AppTextStyles.subtitle),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterView()),
            );
          },
          child: Text(AppStrings.register, style: AppTextStyles.linkLarge),
        ),
      ],
    );
  }
}