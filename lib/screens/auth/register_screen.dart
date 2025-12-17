import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_conditions_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedPrivacy = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_acceptedPrivacy || !_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devi accettare Privacy Policy e Termini & Condizioni'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pop(context); // Torna alla schermata di login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrazione completata! Accedi ora.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrazione'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 24),
                Text(
                  'Crea il tuo account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Nome
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il tuo nome';
                    }
                    if (value.length < 2) {
                      return 'Nome troppo corto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci l\'email';
                    }
                    if (!value.contains('@')) {
                      return 'Email non valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Telefono
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefono',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il telefono';
                    }
                    if (value.length < 10) {
                      return 'Numero non valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Indirizzo
                TextFormField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Indirizzo (opzionale)',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la password';
                    }
                    if (value.length < 6) {
                      return 'Password troppo corta (min. 6 caratteri)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Conferma password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Conferma password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Conferma la password';
                    }
                    if (value != _passwordController.text) {
                      return 'Le password non coincidono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Privacy Policy
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedPrivacy,
                      onChanged: (value) {
                        setState(() {
                          _acceptedPrivacy = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            const TextSpan(text: 'Accetto la '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PrivacyPolicyScreen(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Terms & Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            const TextSpan(text: 'Accetto i '),
                            TextSpan(
                              text: 'Termini e Condizioni',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TermsConditionsScreen(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Pulsante registrazione
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Registrati'),
                  ),
                ),
                const SizedBox(height: 16),

                // Link login
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hai già un account? Accedi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
