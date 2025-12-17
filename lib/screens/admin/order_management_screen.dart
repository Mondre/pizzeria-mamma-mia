import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../services/order_service.dart';
import '../../models/order.dart' as models;
import '../../models/delivery_info.dart';
import '../../utils/constants.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  models.OrderStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);

    return Column(
      children: [
        // Filtri stato
        Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tutti', null),
                const SizedBox(width: 8),
                ...models.OrderStatus.values.map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      AppConstants.orderStatusLabels[status.toString().split('.').last] ?? '',
                      status,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lista ordini
        Expanded(
          child: StreamBuilder<List<models.Order>>(
            stream: _filterStatus != null
                ? orderService.getOrdersByStatusStream(_filterStatus!)
                : orderService.getAllOrdersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Errore: ${snapshot.error}'));
              }

              final orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nessun ordine',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await orderService.loadAllOrders();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _AdminOrderCard(
                      order: orders[index],
                      onStatusChanged: (status) async {
                        await orderService.updateOrderStatus(orders[index].id, status);
                      },
                      onDelete: () async {
                        await orderService.deleteOrder(orders[index].id);
                      },
                      onPrint: () async {
                        await _printOrder(orders[index]);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, models.OrderStatus? status) {
    final isSelected = _filterStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = selected ? status : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }

  Future<void> _printOrder(models.Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Pizzeria Mamma Mia',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Ordine #${order.id.substring(0, 8)}'),
            pw.Text('Data: ${DateFormat(AppConstants.dateTimeFormat).format(order.createdAt)}'),
            pw.SizedBox(height: 20),
            pw.Divider(),
            
            // 1. PIZZE ORDINATE
            pw.SizedBox(height: 15),
            pw.Text(
              'PIZZE ORDINATE:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
            pw.SizedBox(height: 10),
            ...order.items.expand(
              (item) => [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '${item.quantity}x ${item.name}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Text(
                      'EUR ${item.totalPrice.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                if (item.customization != null) ...[
                  if (item.customization!.base != null)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, top: 3),
                      child: pw.Text(
                        '  Base: ${item.customization!.base!.name}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  if (item.customization!.addedIngredients.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, top: 3),
                      child: pw.Text(
                        '  Aggiunti: ${item.customization!.addedIngredients.join(", ")}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  if (item.customization!.removedIngredients.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, top: 3),
                      child: pw.Text(
                        '  Rimossi: ${item.customization!.removedIngredients.join(", ")}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  if (item.customization!.notes != null && item.customization!.notes!.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, top: 3),
                      child: pw.Text(
                        '  Note: ${item.customization!.notes}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                ],
                if (item.notes != null && item.notes!.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 15, top: 3),
                    child: pw.Text(
                      '  Note: ${item.notes}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                pw.SizedBox(height: 8),
              ],
            ),
            
            // 2. ORARIO
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 15),
            pw.Text(
              'ORARIO:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
            pw.SizedBox(height: 5),
            if (order.scheduledTime != null)
              pw.Text(
                'Orario confermato: ${DateFormat('dd/MM/yyyy HH:mm').format(order.scheduledTime!)}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              )
            else if (order.deliveryInfo?.desiredTime != null)
              pw.Text(
                'Orario richiesto: ${DateFormat('dd/MM/yyyy HH:mm').format(order.deliveryInfo!.desiredTime)}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            
            // 3. CONSEGNA/RITIRO
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 15),
            pw.Text(
              'TIPO SERVIZIO:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
            pw.SizedBox(height: 5),
            if (order.deliveryInfo != null) ...[
              pw.Text(
                order.deliveryInfo!.getTypeLabel().toUpperCase(),
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              if (order.deliveryInfo!.address != null) ...[
                pw.SizedBox(height: 5),
                pw.Text('Indirizzo: ${order.deliveryInfo!.address}'),
              ],
            ],
            
            // 4. COGNOME
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 15),
            pw.Text(
              'CLIENTE:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
            pw.SizedBox(height: 5),
            if (order.deliveryInfo?.lastName != null)
              pw.Text(
                'Cognome: ${order.deliveryInfo!.lastName}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            pw.Text('Nome: ${order.userName}'),
            pw.Text('Telefono: ${order.deliveryInfo?.phoneNumber ?? order.userPhone}'),
            
            // 5. PREZZO
            pw.SizedBox(height: 20),
            // 5. PREZZO
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'TOTALE DA PAGARE:',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'EUR ${order.totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            if (order.deliveryInfo?.paymentMethod != null) ...[
              pw.SizedBox(height: 5),
              pw.Text(
                'Pagamento: ${order.deliveryInfo!.getPaymentLabel()}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Text(
                'Note:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(order.notes!),
            ],
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final models.Order order;
  final Function(models.OrderStatus) onStatusChanged;
  final VoidCallback onDelete;
  final VoidCallback onPrint;

  const _AdminOrderCard({
    required this.order,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onPrint,
  });

  Future<void> _showScheduleTimeDialog(BuildContext context) async {
    final currentTime = order.scheduledTime ?? order.deliveryInfo?.desiredTime ?? DateTime.now();
    
    final date = await showDatePicker(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentTime),
      );

      if (time != null && context.mounted) {
        final scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        try {
          final orderService = Provider.of<OrderService>(context, listen: false);
          await orderService.updateScheduledTime(order.id, scheduledTime);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Orario aggiornato! Il cliente verrà notificato.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Errore: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _confirmAndAcceptOrder(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accetta Ordine'),
        content: const Text('Vuoi accettare questo ordine? Il cliente verrà notificato.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Accetta'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      onStatusChanged(models.OrderStatus.accepted);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ordine accettato! Cliente notificato.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: _buildStatusIcon(),
        title: Text(
          'Ordine #${order.id.substring(0, 8)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat(AppConstants.dateTimeFormat).format(order.createdAt)),
            Text('Cliente: ${order.userName}'),
            Text('Tel: ${order.userPhone}'),
          ],
        ),
        trailing: Text(
          '${AppConstants.currencySymbol} ${order.totalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informazioni consegna
                if (order.deliveryInfo != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              order.deliveryInfo!.type == DeliveryType.delivery
                                  ? Icons.delivery_dining
                                  : Icons.shopping_bag,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              order.deliveryInfo!.getTypeLabel(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (order.deliveryInfo!.address != null)
                          Text('📍 ${order.deliveryInfo!.address}'),
                        Text('💳 ${order.deliveryInfo!.getPaymentLabel()}'),
                        Text('👤 ${order.deliveryInfo!.lastName}'),
                        Text('📞 ${order.deliveryInfo!.phoneNumber}'),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orario richiesto:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(order.deliveryInfo!.desiredTime),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (order.scheduledTime != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Orario confermato:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(order.scheduledTime!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showScheduleTimeDialog(context),
                            icon: const Icon(Icons.schedule),
                            label: Text(order.scheduledTime != null
                                ? 'Modifica orario'
                                : 'Conferma orario'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Articoli
                Text(
                  'Articoli:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.quantity}x ${item.name}'),
                          ),
                          Text(
                            '${AppConstants.currencySymbol} ${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),

                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    'Note:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(order.notes!),
                ],

                const Divider(),

                // Cambia stato
                Text(
                  'Stato ordine:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: models.OrderStatus.values.map((status) {
                    final isSelected = order.status == status;
                    return ChoiceChip(
                      label: Text(
                        AppConstants.orderStatusLabels[status.toString().split('.').last] ?? '',
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) onStatusChanged(status);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Azioni
                Column(
                  children: [
                    // Riga 1: Accetta / Stampa
                    Row(
                      children: [
                        if (order.status == models.OrderStatus.pending)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _confirmAndAcceptOrder(context),
                              icon: const Icon(Icons.check),
                              label: const Text('Accetta'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onPrint,
                              icon: const Icon(Icons.print),
                              label: const Text('Stampa Ricevuta'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showDeleteDialog(context),
                            icon: const Icon(Icons.delete),
                            label: const Text('Elimina'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Riga 2: Stampa (sempre visibile tranne per pending)
                    if (order.status != models.OrderStatus.pending) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onPrint,
                          icon: const Icon(Icons.print),
                          label: const Text('Ristampa'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (order.status) {
      case models.OrderStatus.pending:
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case models.OrderStatus.accepted:
        icon = Icons.check_circle_outline;
        color = Colors.blue;
        break;
      case models.OrderStatus.preparing:
        icon = Icons.restaurant;
        color = Colors.purple;
        break;
      case models.OrderStatus.ready:
        icon = Icons.done_all;
        color = Colors.green;
        break;
      case models.OrderStatus.delivered:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case models.OrderStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina ordine'),
        content: const Text('Sei sicuro di voler eliminare questo ordine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }
}
