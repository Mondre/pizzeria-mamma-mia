import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termini e Condizioni'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TERMINI E CONDIZIONI DI SERVIZIO',
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
              '1. ACCETTAZIONE DEI TERMINI',
              'Utilizzando questa applicazione per effettuare ordini presso Pizzeria Mamma Mia, '
              'accetti di essere vincolato ai presenti Termini e Condizioni. '
              'Se non accetti questi termini, non utilizzare l\'applicazione.',
            ),
            
            _buildSection(
              context,
              '2. REGISTRAZIONE ACCOUNT',
              '• Devi fornire informazioni accurate e complete\n'
              '• Sei responsabile della sicurezza del tuo account\n'
              '• Devi avere almeno 18 anni per registrarti\n'
              '• Non puoi condividere il tuo account con terzi\n'
              '• Devi notificarci immediatamente in caso di accesso non autorizzato',
            ),
            
            _buildSection(
              context,
              '3. ORDINI E PAGAMENTI',
              '• Gli ordini sono soggetti a disponibilità\n'
              '• I prezzi possono variare senza preavviso\n'
              '• Il pagamento può essere effettuato in contanti o carta alla consegna/ritiro\n'
              '• Ci riserviamo il diritto di rifiutare ordini\n'
              '• Gli ordini sono considerati confermati solo dopo nostra accettazione',
            ),
            
            _buildSection(
              context,
              '4. CONSEGNA E RITIRO',
              '• Gli orari di consegna sono indicativi\n'
              '• La consegna è disponibile nelle zone servite\n'
              '• Potrebbero essere applicati costi di consegna\n'
              '• Per il ritiro, rispetta l\'orario confermato\n'
              '• Verifica sempre l\'ordine prima dell\'accettazione',
            ),
            
            _buildSection(
              context,
              '5. CANCELLAZIONI E RIMBORSI',
              '• Le cancellazioni devono essere effettuate prima della preparazione\n'
              '• Non sono previsti rimborsi per ordini già preparati\n'
              '• In caso di errore da parte nostra, provvederemo alla sostituzione o rimborso\n'
              '• I reclami devono essere segnalati entro 24 ore dalla consegna',
            ),
            
            _buildSection(
              context,
              '6. ALLERGENI E INTOLLERANZE',
              '• È tua responsabilità comunicarci eventuali allergie o intolleranze\n'
              '• Forniremo informazioni sugli allergeni su richiesta\n'
              '• Non possiamo garantire assenza di tracce di allergeni\n'
              '• Consulta sempre il personale in caso di dubbi',
            ),
            
            _buildSection(
              context,
              '7. PROPRIETÀ INTELLETTUALE',
              'Tutti i contenuti dell\'app (testo, immagini, logo, menu) sono di proprietà '
              'di Pizzeria Mamma Mia e protetti dalle leggi sul copyright. '
              'È vietata la riproduzione senza autorizzazione.',
            ),
            
            _buildSection(
              context,
              '8. LIMITAZIONE DI RESPONSABILITÀ',
              'Pizzeria Mamma Mia non è responsabile per:\n'
              '• Ritardi dovuti a cause di forza maggiore\n'
              '• Problemi tecnici dell\'applicazione\n'
              '• Danni indiretti o consequenziali\n'
              '• Errori nelle informazioni fornite dall\'utente',
            ),
            
            _buildSection(
              context,
              '9. USO ACCETTABILE',
              'È vietato:\n'
              '• Utilizzare l\'app per scopi illegali\n'
              '• Tentare di violare la sicurezza dell\'app\n'
              '• Interferire con il normale funzionamento\n'
              '• Effettuare ordini falsi o fraudolenti\n'
              '• Abusare del servizio clienti',
            ),
            
            _buildSection(
              context,
              '10. MODIFICHE AI TERMINI',
              'Ci riserviamo il diritto di modificare questi termini in qualsiasi momento. '
              'Le modifiche saranno pubblicate nell\'app. '
              'Continuando a utilizzare l\'app dopo le modifiche, accetti i nuovi termini.',
            ),
            
            _buildSection(
              context,
              '11. LEGGE APPLICABILE',
              'Questi termini sono regolati dalla legge italiana. '
              'Per qualsiasi controversia è competente il foro di [città].',
            ),
            
            _buildSection(
              context,
              '12. CONTATTI',
              'Per domande sui presenti termini:\n'
              'Pizzeria Mamma Mia\n'
              'Email: info@pizzeriamammamia.it\n'
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
