//
//  DetailViewController.swift
//  TesteiOSV2
//
//  Created by Julio Cezar de Souza on 05/06/20.
//  Copyright (c) 2020 Julio Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailDisplayLogic: class {
    func displayError(response: Detail.Error)
    func displayList(response: [Detail.StatementList])
    func displayPersonalData(user: Login.UserAccount)
}

class DetailViewController: UIViewController, DetailDisplayLogic {
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserScreen()
        getList()
    }
    
    // MARK: Properties

    var list: [Detail.StatementList] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    
    func updateUserScreen() {
        interactor?.updatePersonalData()
    }
    
    func displayPersonalData(user: Login.UserAccount) {
        nameLabel.text = user.name
        accountNumberLabel.text = "\(user.agency ?? "") / \(user.bankAccount ?? "")"
        balanceLabel.text = user.balance?.formatCurrency()
    }
    
    func displayList(response: [Detail.StatementList]) {
        list = response
        tableView.reloadData()
    }
    
    func displayError(response: Detail.Error) {
        self.showOkAlert(title: "Erro", message: response.message ?? "Ërro desconhecido")
    }
    

    func getList() {
        interactor?.getList()
    }

}

// MARK: Table View
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        cell.shadowView.addShadow(color: .black)
        cell.titleLabel.text = list[indexPath.row].title
        cell.descLabel.text = list[indexPath.row].desc
        cell.valueLabel.text = list[indexPath.row].value?.formatCurrency()
        cell.dateLabel.text = list[indexPath.row].date?.toDate()?.toString()
        return cell
    }
    
    
}

