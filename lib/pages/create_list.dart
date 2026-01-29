
import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/core/widgets/share_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateList extends StatefulWidget {
  final String? title;
  final List<Expense>? expenses;
  const CreateList({Key? key, this.title, this.expenses}) : super(key: key);

  @override
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _quantityC = TextEditingController(text: '1');
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _amountToSpendC = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _quantityNode = FocusNode();
  final FocusNode _priceNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _amountFormKey = GlobalKey<FormState>();

  List<Expense> expenses = [];
  bool reverseMode = false;
  int amountToSpend = 0;

  @override
  void initState() {
    super.initState();
    hasViewedReverse();
    if (widget.expenses != null) {
      expenses.addAll(widget.expenses!);
    }
  }

  @override
  void dispose() {
    // FIX: Memory management
    _nameC.dispose();
    _quantityC.dispose();
    _priceC.dispose();
    _amountToSpendC.dispose();
    _nameNode.dispose();
    _quantityNode.dispose();
    _priceNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int get _total => expenses.fold(0, (sum, item) => sum + (item.quantity * item.price));
  int get _balance => amountToSpend - _total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<ApplicationState>(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? l10n.quick_spending_plan),
        actions: [
      FilledButton(
        onPressed: expenses.isEmpty ? null : _onDone,
      
        child: const Icon(Icons.check),
      ),
      SizedBox(width: 10,)
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          
          // Header Stats (Total/Balance)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(reverseMode ? l10n.balance_remaining : l10n.estimated_total,
                              style: theme.textTheme.titleMedium),
                          Switch(
                            value: reverseMode,
                            onChanged: (val) {
                              if (val) showAmountInput();
                              setState(() => reverseMode = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppFormatters.moneyCommaStr(reverseMode ? _balance : _total)} ${appState.currentCurrency}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: reverseMode && _balance < 0 ? theme.colorScheme.error : theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          if (reverseMode)
                            IconButton.filledTonal(
                              onPressed: showAmountInput,
                              icon: const Icon(Icons.edit, size: 18),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    
          // Items List
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = expenses[index];
                  return Dismissible(
                    key: ValueKey(item.name + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: theme.colorScheme.errorContainer,
                      child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
                    ),
                    onDismissed: (_) {
                      setState(() => expenses.removeAt(index));
                    },
                    child: ListTile(
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${item.quantity} × ${AppFormatters.moneyCommaStr(item.price)} ${appState.currentCurrency}'),
                      trailing: Text(
                        '${AppFormatters.moneyCommaStr(item.quantity * item.price)} ${appState.currentCurrency}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
                childCount: expenses.length,
              ),
            ),
          ),
        ],
      ),
      
      // Fixed Add Item Form at bottom
      bottomSheet: _buildAddItemForm(theme, appState),
      
    
    );
  }

  Widget _buildAddItemForm(ThemeData theme, ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _nameC,
                    focusNode: _nameNode,
                    
                    decoration:  InputDecoration(labelText: l10n.item, hintText: l10n.food, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    onFieldSubmitted: (_) => _priceNode.requestFocus(),
                    validator: (val) => val!.isEmpty ? l10n.required : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _quantityC,
                    focusNode: _quantityNode,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(labelText: '',border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceC,
                    focusNode: _priceNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.price,border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    onFieldSubmitted: (_) => _addItem(),
                    validator: (val) => val!.isEmpty ? l10n.required : null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.quick_add_fill_fields_and_tap_or_press_enter, 
                 style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        expenses.add(Expense(
          name: _nameC.text,
          quantity: int.tryParse(_quantityC.text) ?? 1,
          price: int.parse(_priceC.text),
          index: expenses.length,
        ));
      });
      _nameC.clear();
      _priceC.clear();
      _quantityC.text = '1';
      _nameNode.requestFocus();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onDone() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.title != null) {
      context.pop({'expenses': expenses, 'total': _total});
    } else {
      SpendingPlan plan = SpendingPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        total: _total,
        title: l10n.quick_plan,
        creationDate: DateTime.now(),
        reminderDate: DateTime.now(),
        reminder: false,
        expenses: expenses,
      );

      bool? share = await showModalBottomSheet<bool>(
        context: context,
        builder: (context) => const QuickListoptions(),
      );

      if (share == true) {
        context.push(AppLinks.pdfPreview, extra: plan);
        
      } else {
        context.push(AppLinks.addSpendingPlan, extra: plan);
        
      }
    }
  }

  // --- Utility Dialogs ---
  void showAmountInput() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(l10n.set_budget_limit),
        content: Form(
          key: _amountFormKey,
          child: TextFormField(
            controller: _amountToSpendC,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration:  InputDecoration(labelText: l10n.amount, hintText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),),
            validator: (val) => val!.isEmpty ? l10n.required : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child:  Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              if (_amountFormKey.currentState!.validate()) {
                setState(() => amountToSpend = int.parse(_amountToSpendC.text));
                Navigator.pop(context);
              }
            },
            child:  Text(l10n.set),
          ),
        ],
      ),
    );
  }

  void hasViewedReverse() async {
    final l10n = AppLocalizations.of(context)!;
    bool? hasSeen = await SharedPrefs().seenReverseMode();
    if (hasSeen != true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:  Text(l10n.reverse_mode),
          content:  Text(l10n.specify_a_budget_and_each_item_will_deduct_from_that_total),
          actions: [
            TextButton(
              onPressed: () {
                SharedPrefs().setSeenReverseMode();
                Navigator.pop(context);
              },
              child:  Text(l10n.got_it),
            )
          ],
        ),
      );
    }
  }
}