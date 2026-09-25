import 'package:budget/colors.dart';
import 'package:budget/pages/transactionFilters.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget/widgets/countNumber.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePageTotalExpense extends StatelessWidget {
  const HomePageTotalExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TotalWithCount?>(
      stream: database.watchTotalWithCountOfWallet(
        isIncome: false,
        allWallets: Provider.of<AllWallets>(context),
        followCustomPeriodCycle: true,
        cycleSettingsExtension: "AllSpendingSummary",
        onlyIncomeAndExpense: true,
        searchFilters: SearchFilters(walletPks: []),
      ),
      builder: (context, snapshot) {
        double totalSpent = snapshot.data?.total ?? 0;
        double finalAmount = (totalSpent).abs();
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  getColor(context, "expenseAmount"), 
                  getColor(context, "expenseAmount").withOpacity(0.6)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: boxShadowCheck(boxShadowGeneral(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    TextFont(
                      text: "Tổng Chi Tiêu Tháng Này",
                      textColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CountNumber(
                  count: finalAmount,
                  duration: Duration(milliseconds: 1000),
                  initialCount: (0),
                  textBuilder: (number) {
                    return TextFont(
                      text: convertToMoney(
                        Provider.of<AllWallets>(context), 
                        number,
                        finalNumber: finalAmount,
                      ),
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      autoSizeText: true,
                      maxLines: 1,
                    );
                  },
                ),
                SizedBox(height: 5),
                TextFont(
                  text: "Theo dõi sát sao để không vượt ngân sách nhé!",
                  textColor: Colors.white70,
                  fontSize: 13,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}