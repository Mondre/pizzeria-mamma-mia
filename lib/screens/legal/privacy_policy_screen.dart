import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INFORMATIVA SULLA PRIVACY',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ultimo aggiornamento: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. TITOLARE DEL TRATTAMENTO',
              'Pizzeria Mamma Mia\n'
              'Titolare del trattamento dei dati personali ai sensi del Regolamento UE 2016/679 (GDPR).',
            ),
            
            _buildSection(
              context,
              '2. DATI RACCOLTI',
              'Raccogliamo i seguenti dati personali:\n'
              '• Nome e Cognome\n'
              '• Numero di telefono\n'
              '• Indirizzo email\n'
              '• Indirizzo di consegna\n'
              '• Cronologia degli ordini\n'
              '• Preferenze di pagamento',
            ),
            
            _buildSection(
              context,
              '3. FINALITÀ DEL TRATTAMENTO',
              'I tuoi dati personali sono utilizzati per:\n'
              '• Gestione ed elaborazione degli ordini\n'
              '• Consegna dei prodotti ordinati\n'
              '• Comunicazioni relative agli ordini (notifiche, conferme)\n'
              '• Miglioramento del servizio\n'
              '• Adempimenti fiscali e contabili',
            ),
            
            _buildSection(
              context,
              '4. BASE GIURIDICA',
              'Il trattamento dei dati è basato su:\n'
              '• Esecuzione del contratto (elaborazione ordini)\n'
              '• Consenso esplicito dell\'utente\n'
              '• Obblighi di legge (fatturazione, adempimenti fiscali)',
            ),
            
            _buildSection(
              context,
              '5. CONSERVAZIONE DEI DATI',
              'I dati personali sono conservati per il tempo necessario a:\n'
              '• Erogare il servizio richiesto\n'
              '• Adempiere agli obblighi di legge (10 anni per dati fiscali)\n'
              '• Gestire eventuali contestazioni o reclami',
            ),
            
            _buildSection(
              context,
              '6. DESTINATARI DEI DATI',
              'I tuoi dati possono essere comunicati a:\n'
              '• Personale autorizzato della pizzeria\n'
              '• Fornitori di servizi tecnici (Firebase/Google Cloud - server UE)\n'
              '• Corrieri per la consegna\n'
              '• Autorità fiscali quando richiesto dalla legge',
            ),
            
            _buildSection(
              context,
              '7. DIRITTI DELL\'INTERESSATO',
              'Hai diritto a:\n'
              '• Accedere ai tuoi dati personali\n'
              '• Rettificare dati inesatti o incompleti\n'
              '• Cancellare i tuoi dati ("diritto all\'oblio")\n'
              '• Limitare il trattamento\n'
              '• Opporti al trattamento\n'
              '• Portabilità dei dati\n'
              '• Revocare il consenso in qualsiasi momento\n'
              '• Proporre reclamo al Garante per la Protezione dei Dati Personali',
            ),
            
            _buildSection(
              context,
              '8. SICUREZZA DEI DATI',
              'Adottiamo misure di sicurezza tecniche e organizzative per proteggere i dati personali:\n'
              '• Crittografia delle comunicazioni (HTTPS/SSL)\n'
              '• Autenticazione sicura (Firebase Authentication)\n'
              '• Backup regolari\n'
              '• Accesso limitato ai dati',
            ),
            
            _buildSection(
              context,
              '9. COOKIE E TECNOLOGIE SIMILI',
              'Utilizziamo cookie e tecnologie simili per:\n'
              '• Mantenere la sessione di login\n'
              '• Memorizzare preferenze dell\'utente\n'
              '• Migliorare l\'esperienza di navigazione\n'
              'Puoi gestire i cookie dalle impostazioni del tuo browser.',
            ),
            
            _buildSection(
              context,
              '10. MODIFICHE ALLA PRIVACY POLICY',
              'Ci riserviamo il diritto di modificare questa informativa. '
              'Le modifiche saranno pubblicate su questa pagina con la data di aggiornamento.',
            ),
            
            _buildSection(
              context,
              '11. CONTATTI',
              'Per esercitare i tuoi diritti o per informazioni:\n'
              'Pizzeria Mamma Mia\n'
              'Email: privacy@pizzeriamammamia.it\n'
              'Telefono: [numero]',
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
