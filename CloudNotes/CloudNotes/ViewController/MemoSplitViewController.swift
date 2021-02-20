import UIKit

class MemoSplitViewController: UISplitViewController {
    let memoListTableViewController = MemoListTableViewController(style: .plain)
    let memoContentsViewController = MemoContentsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        memoContentsViewController.receiveText(memo: memoListTableViewController.memoList[0])

        self.viewControllers = [memoListNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }

    override func viewDidAppear(_ animated: Bool) {
        self.viewControllers.append(memoContentsViewController)
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        switch memoListTableViewController.isCellSelected {
        case true:
            return false
        case false:
            return true
        }
    }
}
