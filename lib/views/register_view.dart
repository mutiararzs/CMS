import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import '../utils/validators.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glow_background.dart';
import '../widgets/login_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_login_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  const _RegisterBody();

  static const _navy = Color(0xFF0D1C32);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(child: GlowBackground()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 73, 26, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: [
                      LoginHeader(
                        title: AppStrings.registerTitle,
                        subtitle: AppStrings.registerSubtitle,
                        titleStyle: AppTextStyles.title.copyWith(
                          fontSize: 26,
                          height: 34 / 26,
                          letterSpacing: -0.65,
                        ),
                        logoGap: 0,
                        subtitleGap: 4,
                      ),
                      const SizedBox(height: 25),
                      _buildFormCard(context, vm),
                      const SizedBox(height: 25),
                      SocialLoginSection(
                        onPressed: vm.isLoading
                            ? null
                            : (provider) => vm.signInWithSocial(provider.name),
                      ),
                      const SizedBox(height: 5),
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

  // ---------------------------------------------------------------- form

  Widget _buildFormCard(BuildContext context, RegisterViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
            _field(
              label: AppStrings.fullNameLabel,
              hint: AppStrings.fullNameHint,
              controller: vm.nameController,
              prefixAsset: AppAssets.user,
              prefixSize: const Size(13, 13),
              prefixLeft: 19,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: Validators.fullName,
            ),
            const SizedBox(height: 16),
            _field(
              label: AppStrings.birthDateLabel,
              hint: AppStrings.birthDateHint,
              controller: vm.birthDateController,
              prefixAsset: AppAssets.calendarLeft,
              prefixSize: const Size(17, 18),
              prefixLeft: 19,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
              validator: Validators.birthDate,
              suffix: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _pickDate(context, vm),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 18),
                  child: SvgPicture.asset(
                    AppAssets.calendarRight,
                    width: 19.75,
                    height: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _field(
              label: AppStrings.emailLabel,
              hint: AppStrings.studentEmailHint,
              controller: vm.emailController,
              prefixAsset: AppAssets.email,
              prefixSize: const Size(17, 13),
              prefixLeft: 18,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            _field(
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHint,
              controller: vm.passwordController,
              prefixAsset: AppAssets.lock,
              prefixSize: const Size(13, 18),
              prefixLeft: 19,
              obscureText: vm.obscurePassword,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              suffix: _eyeToggle(vm.obscurePassword, vm.togglePassword),
            ),
            const SizedBox(height: 16),
            _field(
              label: AppStrings.confirmPasswordLabel,
              hint: AppStrings.confirmPasswordHint,
              controller: vm.confirmPasswordController,
              prefixAsset: AppAssets.lock,
              prefixSize: const Size(13, 17),
              prefixLeft: 19,
              obscureText: vm.obscureConfirm,
              textInputAction: TextInputAction.done,
              validator: (value) => Validators.confirmPassword(
                value,
                vm.passwordController.text,
              ),
              suffix: _eyeToggle(vm.obscureConfirm, vm.toggleConfirm),
            ),
            const SizedBox(height: 16),
            _buildTerms(vm),
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(vm.errorMessage!, style: AppTextStyles.error),
              ),
            ],
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PrimaryButton(
                text: AppStrings.register,
                trailingAsset: AppAssets.arrowRight,
                height: 52,
                backgroundColor: _navy,
                isLoading: vm.isLoading,
                onPressed: () async {
                  final ok = await vm.register();
                  if (ok && context.mounted) {
                    // TODO: navigasi setelah berhasil daftar
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input gaya halaman daftar: bentuk pil, teks mulai di x=48, label abu-abu.
  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String prefixAsset,
    required Size prefixSize,
    required double prefixLeft,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
  }) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      prefixAsset: prefixAsset,
      prefixSize: prefixSize,
      prefixLeft: prefixLeft,
      textStart: 48,
      borderRadius: 100,
      labelColor: AppColors.textGray,
      labelIndent: 4,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      suffix: suffix,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
    );
  }

  Widget _eyeToggle(bool obscure, VoidCallback onTap) {
    return Tooltip(
      message: obscure ? AppStrings.showPassword : AppStrings.hidePassword,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 20, 4),
          child: SvgPicture.asset(AppAssets.eye, width: 18.33, height: 16.5),
        ),
      ),
    );
  }

  // --------------------------------------------------------------- terms

  Widget _buildTerms(RegisterViewModel vm) {
    final base = AppTextStyles.caption.copyWith(height: 15 / 12);
    final link = base.copyWith(
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primary,
    );
    final hasError = vm.showTermsError && !vm.acceptedTerms;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => vm.toggleTerms(!vm.acceptedTerms),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 13,
                      height: 13,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vm.acceptedTerms
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(2.5),
                        border: Border.all(
                          color: hasError
                              ? AppColors.error
                              : AppColors.checkboxBorder,
                          width: 1,
                        ),
                      ),
                      child: vm.acceptedTerms
                          ? const Icon(Icons.check, size: 10, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: base,
                        children: [
                          const TextSpan(text: AppStrings.termsAgree),
                          TextSpan(text: AppStrings.termsService, style: link),
                          const TextSpan(text: ' & '),
                          TextSpan(text: AppStrings.termsPrivacy, style: link),
                          const TextSpan(text: ' '),
                          TextSpan(text: AppStrings.termsPolicy, style: link),
                          const TextSpan(text: AppStrings.termsSuffix),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 6),
              child: Text(AppStrings.termsError, style: AppTextStyles.error),
            ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- footer

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.haveAccount, style: AppTextStyles.subtitle),
          const SizedBox(width: 4),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppStrings.login, style: AppTextStyles.linkLarge),
                const SizedBox(width: 2),
                SvgPicture.asset(AppAssets.chevronRight, width: 4.93, height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------- date picker

  Future<void> _pickDate(BuildContext context, RegisterViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 15),
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (picked != null) vm.setBirthDate(picked);
  }
}