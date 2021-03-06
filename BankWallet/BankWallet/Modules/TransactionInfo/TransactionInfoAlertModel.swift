import UIKit
import GrouviActionSheet

class TransactionInfoAlertModel: BaseAlertModel {

    let delegate: ITransactionInfoViewDelegate

    init(delegate: ITransactionInfoViewDelegate, transactionHash: String) {
        self.delegate = delegate

        super.init()

        hideInBackground = false

        if let item = delegate.transactionViewItem(forTransactionHash: transactionHash) {
            let titleItem = TransactionTitleItem(item: item, tag: 0, onIdTap: {
                delegate.onCopy(value: item.transactionHash)
            })
            addItemView(titleItem)

            let amountItem = TransactionAmountItem(item: item, tag: 1)
            addItemView(amountItem)

            if let date = item.date {
                let timeItem = TransactionValueItem(title: "tx_info.time".localized, value: DateHelper.instance.formatTransactionInfoTime(from: date), tag: 2)
                addItemView(timeItem)
            }

            let statusItem = TransactionStatusItem(item: item, tag: 3)
            addItemView(statusItem)

            if let from = item.from {
                addItemView(TransactionFromToHashItem(title: "tx_info.from_hash".localized, value: from, tag: 4, required: true, onHashTap: {
                    delegate.onCopy(value: from)
                }))
            }

            if let to = item.to {
                addItemView(TransactionFromToHashItem(title: "tx_info.to_hash".localized, value: to, tag: 5, required: true, onHashTap: {
                    delegate.onCopy(value: to)
                }))
            }
        }

        let closeItem = TransactionCloseItem(tag: 5, required: true, onTap: { [weak self] in
            self?.dismiss?(true)
        })
        addItemView(closeItem)
    }

}

extension TransactionInfoAlertModel: ITransactionInfoView {

    func showCopied() {
        HudHelper.instance.showSuccess(title: "alert.copied".localized)
    }

}
