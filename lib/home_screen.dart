import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/logo.png',
              height: 35,
              width: 35,
              errorBuilder: (_, _, _) => const Icon(
                Icons.build,
                color: Color(0xffF9703B),
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Maintance ',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Rubik Medium',
                color: Color(0xff203142),
              ),
            ),
            const Text(
              'Box',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Rubik Medium',
                color: Color(0xffF9703B),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xffF9703B)),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffF9703B).withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xffF9703B),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome, ${user?.name ?? 'User'}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Rubik Medium',
                  color: Color(0xff203141),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have successfully logged in to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Rubik Regular',
                  color: Color(0xff4C5980),
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                color: const Color(0xffF8F9FA),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: user?.name ?? '-',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.family_restroom,
                        label: 'Father Name',
                        value: user?.fatherName.isNotEmpty == true
                            ? user!.fatherName
                            : 'Not specified',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.alternate_email,
                        label: 'Email',
                        value: user?.email ?? '-',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.verified_user_outlined,
                        label: 'Status',
                        value: 'Authenticated',
                        valueColor: Colors.green[700],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF9703B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await AuthService.instance.logout();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  child: const Text(
                    'LOG OUT',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Rubik Medium',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xff323F4B)),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Rubik Regular',
            color: Color(0xff4C5980),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Rubik Medium',
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xff203142),
          ),
        ),
      ],
    );
  }
}
