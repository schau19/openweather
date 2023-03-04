//
//  HomeDetailsView.swift
//  OpenWeather
//
//  Created by Steven Chau on 3/2/23.
//

import SnapKit
import UIKit

class HomeDetailsView: UIView {

    let iconSize = CGSize(width: 100.0, height: 100.0)
    
    private lazy var titleLabel: UILabel = {
        let label = labelFactory()
        label.text = "--"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        return labelFactory()
    }()
    
    private lazy var descriptionLabel: UILabel = {
        return labelFactory()
    }()
    
    private lazy var detail1Label: UILabel = {
        return labelFactory()
    }()
    
    private lazy var detail2Label: UILabel = {
        return labelFactory()
    }()
    
    private lazy var detail3Label: UILabel = {
        return labelFactory()
    }()
    
    private lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var paddingWithIconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .systemBlue
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        paddingWithIconView.addSubview(iconView)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(paddingWithIconView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(detail1Label)
        stackView.addArrangedSubview(detail2Label)
        stackView.addArrangedSubview(detail3Label)
        stackView.addArrangedSubview(UIView())
        addSubview(stackView)
        addSubview(spinner)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.width.lessThanOrEqualTo(iconSize.width).priorityLow()
            maker.height.lessThanOrEqualTo(iconSize.height).priorityLow()
            maker.top.lessThanOrEqualTo(paddingWithIconView.snp.top).priorityHigh()
            maker.bottom.lessThanOrEqualTo(paddingWithIconView.snp.bottom).priorityHigh()
            maker.leading.lessThanOrEqualTo(paddingWithIconView.snp.leading)
            maker.trailing.lessThanOrEqualTo(paddingWithIconView.snp.trailing)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.center.equalToSuperview()
        }
    }
    
    public func configure(weatherViewModel: WeatherViewModel?) {
        titleLabel.text = weatherViewModel?.name
        subtitleLabel.text = weatherViewModel?.headline
        descriptionLabel.text = weatherViewModel?.description
        detail1Label.text = weatherViewModel?.detail1
        detail2Label.text = weatherViewModel?.detail2
        detail3Label.text = weatherViewModel?.detail3
        iconView.image = weatherViewModel?.icon
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func startSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    public func stopSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    private func labelFactory() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
}
