//
//  HomeViewController.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: AnyObject {
    func didPeformSearchFor(query: String?)
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    weak var listener: HomePresentableListener?
    
    private let searchBarHeight = 56.0
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Enter city"
        return searchBar
    }()
    
    private lazy var detailsView: HomeDetailsView = {
        let view = HomeDetailsView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchBar)
        view.addSubview(detailsView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.frame = CGRect(x: view.safeAreaInsets.left,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                 height: searchBarHeight)
        
        detailsView.frame = CGRect(x: view.safeAreaInsets.left,
                                   y: view.safeAreaInsets.top + searchBarHeight,
                                   width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                   height: view.frame.size.height - view.safeAreaInsets.top - searchBarHeight - view.safeAreaInsets.bottom)
    }
    
    func update(weatherViewModel: WeatherViewModel?) {
        detailsView.configure(weatherViewModel: weatherViewModel)
    }
    
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showSpinner(_ show: Bool) {
        if show {
            detailsView.startSpinner()
        } else {
            detailsView.stopSpinner()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        listener?.didPeformSearchFor(query: query)
    }
}
